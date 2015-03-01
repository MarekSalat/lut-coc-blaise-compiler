#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "blaise.tab.h"
#include "symtable.h"
#include "ast.h"
#include "tac.h"
#include "tac2as64.h"

extern FILE *yyin; 
extern FILE *yyout; 
extern int yyparse(void);   
   
extern BlaiseProgram program;
extern int yyerror_state;

extern char *strdup(const char *);

int main(int argc, char **argv) {
    addsymbol(&program.symtab, strdup("write"));
    addsymbol(&program.symtab, strdup("writeln"));
     
    char * input_file_name = NULL;
    // open a file handle to a particular file:        
    FILE * input_file = stdin; 
    if (argc >= 1) {
        input_file = fopen(argv[1], "r");
        input_file_name = argv[1];
    }

    // make sure it is valid:     
    if (!input_file) {
        fprintf(stderr, "I can't open %s!", input_file_name);
        return -1;     
    }  
    // set flex to read from it instead of defaulting to STDIN :
    yyin = input_file;
    // parse through the input until there is no more:  
    do {
        yyparse();  
    } while (!feof(yyin));  

    if (input_file_name != NULL)
        fclose(input_file);

    if (yyerror_state != 0) return yyerror_state;

    if (program.ast == NULL) return -42;

    //printf("__________-= AST =-___________\n");

    //printf("program name is %s, io [%d, %d]\n", program.name, program.in, program.out);
    //ast_print(stdout, program.ast, 0);

    int file_name_len = strlen(input_file_name);
    if (input_file_name[file_name_len - 2] == '.' && input_file_name[file_name_len - 1] == 'b'){
        input_file_name[file_name_len - 1] = '\0';
        input_file_name[file_name_len - 2] = '\0';
    }

    char output_file_name[512];
    if (input_file_name != NULL)
        sprintf(output_file_name, "%s.s", input_file_name);

    //printf("______-= SYMBOL TABLE =-______\n");
    //printInorder(&program.symtab);

    
    //printf("__________-= TAC =-___________\n");
    TacListItem * tac = tac_buildList(&program);
    char tac_output_file_name[512];
    strcpy(tac_output_file_name, output_file_name);
    tac_output_file_name[strlen(tac_output_file_name) - 1] = 't';

    FILE * tac_output_file = fopen(tac_output_file_name, "w");
        tac_print(tac_output_file, tac);
    fclose(tac_output_file);

    FILE * output_file = (input_file_name != NULL) ? fopen(output_file_name, "w") : stdout;

    //printf("_________-= AS 64 =-__________\n");
    tac2as64(tac, &program.symtab, output_file);
    if (input_file_name != NULL){
        fclose(output_file);

        char command[1024];
        sprintf(command, "gcc -O3 -o %s %s", input_file_name, output_file_name);
        //printf("run: %s\n", command);
        if (system(command) != 0){
            fprintf(stderr, "Something weird just have happened.\n");
        }
    }

    // freesymbolTableAndStrings(program->symtab);
    // ast_free
    // tac_free

    return 0;       
}          