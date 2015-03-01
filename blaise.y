/* simplest version of calculator */
%{
	#include <stdio.h>
	#include <string.h>
	#include "symtable.h"
	#include "blaise.h"
	#include "ast.h"

	// stuff from flex that bison needs to know about:
	extern int yylex();
	extern int yylineno;
	extern int yycolumn;
	extern char linebuf[500];

	void yyerror (char const *); 

	BlaiseProgram program;
	int yyerror_state = 0;
%}



/* declare tokens */

%union {
	char *unknown;

	int ival;	
	char *sval;
	
	struct TSymbol *id;
	struct TASTnode * ast;
}

%locations

%token <unknown> UNKNOWN 
%token <id> ID 
%token <ival> INT
%token <sval> STR

%token VAR
%token ADD SUB MUL DIV LPAREN RPAREN
%token EQL NEQ LSS GTR LEQ GEQ 

%token PROGRAM BEGINSYM	END 
%token IF THEN ELSE
%token WHILE DO REPEAT UNTIL
%token SEMICOLON COLON COMMA PERIOD BECOMES QUOTE

%token INPUT OUTPUT DT_INT

%left ADD SUB MUL DIV LPAREN RPAREN
%right THEN ELSE	// Same precedence, but "shift" wins.

%type <ival> int
%type <id> id varid
%type <sval> str

%type <ast> blaise varlist vars emptylist list list1 stmt paramlist param multiparam exp factor term simpleExp
	
%%

blaise: PROGRAM ID LPAREN io RPAREN SEMICOLON varlist BEGINSYM emptylist END PERIOD { 
	ASTnode * n = new_astnode(AST_PROGRAM);
	ast_addchild(n, $7); // varlist
	ast_addchild(n, $9); // list
	program.ast = n;

	$$ = n;
}
	;
io:
	| INPUT				 {program.in = 1;}
	| OUTPUT			 {program.out = 1;}
	| INPUT COMMA OUTPUT {program.in = 1; program.out = 1;}
	;

varlist: { $$ = NULL; }
	| VAR vars SEMICOLON					{ $$ = new_astnode(AST_VARS); ast_addchild($$, $2);}
	;
vars: varid COLON DT_INT					{ $$ = new_astnode_symbol(AST_VAR, $1); }
	| varid 								{ $$ = new_astnode_symbol(AST_VAR, $1); }
	| vars SEMICOLON varid					{ ASTnode*n = new_astnode_symbol(AST_VAR, $3); ast_addsibling($1, n);}	
    | vars SEMICOLON varid COLON DT_INT		{ ASTnode*n = new_astnode_symbol(AST_VAR, $3); ast_addsibling($1, n);}
    | vars COMMA varid COLON DT_INT			{ ASTnode*n = new_astnode_symbol(AST_VAR, $3); ast_addsibling($1, n);}
    | vars COMMA varid						{ ASTnode*n = new_astnode_symbol(AST_VAR, $3); ast_addsibling($1, n);}
	;

varid: ID { 
		char * idname = (char*)$1;
		Symbol * symbol = findsymbol(&program.symtab, idname);
		 /*add to symbol table if not exist*/
		if( symbol != NULL) {
			fprintf(stderr, "Symbol '%s' was already declared\n", idname);
			yyerror("");
			free(idname);
		}
		else
			symbol = addsymbol(&program.symtab, idname);

		$$ = symbol;
	}
	;

emptylist:									{ $$ = new_astnode(AST_NOPE); }
	| list									{ $$ = new_astnode(AST_STMT_LIST); ast_addchild($$, $1); }
	;
list: list1 ending
	;

list1: list1 SEMICOLON stmt								{ if($1 == NULL) {$$ = $3;} else {ast_addsibling($1, $3); $$ = $1;} }
	| stmt  								{ $$ = $1; }
	;

ending: 
    | SEMICOLON
    ;

stmt: BEGINSYM emptylist END		      { $$ = $2;}
	| id BECOMES exp	 			         { $$ = new_astnode_symbol(AST_ASS, $1); ast_addchild($$, $3); }
	/*/* write(   a, 'b c', 1+1, )  */
	| id LPAREN paramlist RPAREN	      { $$ = new_astnode_symbol(AST_CALL, $1); ast_addchild($$, $3); }
	| IF exp THEN stmt 						{ $$ = new_astnode(AST_IF);     ast_addchild($$, $2); ast_addchild($$, $4);}
	| IF exp THEN stmt ELSE stmt 			{ $$ = new_astnode(AST_IF);     ast_addchild($$, $2); ast_addchild($$, $4); ast_addchild($$, $6);}
	| WHILE exp DO stmt  					{ $$ = new_astnode(AST_WHILE);  ast_addchild($$, $2); ast_addchild($$, $4);}
	| REPEAT emptylist UNTIL exp 	      { $$ = new_astnode(AST_REPEAT); ast_addchild($$, $4); ast_addchild($$, $2);}
	;

paramlist: 						{ $$ = NULL; }
	| multiparam 				{ $$ = new_astnode(AST_PARAM_LIST); ast_addchild($$, $1);}
	;
multiparam: param 				{ $$ = $1; }
	| multiparam COMMA param 	{ ast_addsibling($1, $3);}
	;
param: str 						{ $$ = new_astnode_char(AST_STR, $1); }
	| exp 						{ $$ = $1; }
	; 


exp: simpleExp 	{$$ = new_astnode(AST_EXP); ast_addchild($$, $1);}
	| simpleExp EQL simpleExp 	{ $$ = new_astnode(AST_EQL); ast_addchild($$, $1); ast_addchild($$, $3); }
	| simpleExp NEQ simpleExp 	{ $$ = new_astnode(AST_NEQ); ast_addchild($$, $1); ast_addchild($$, $3); }
	| simpleExp LEQ simpleExp 	{ $$ = new_astnode(AST_LEQ); ast_addchild($$, $1); ast_addchild($$, $3); }
	| simpleExp GEQ simpleExp 	{ $$ = new_astnode(AST_GEQ); ast_addchild($$, $1); ast_addchild($$, $3); }
	| simpleExp LSS simpleExp 	{ $$ = new_astnode(AST_LSS); ast_addchild($$, $1); ast_addchild($$, $3); }
	| simpleExp GTR simpleExp 	{ $$ = new_astnode(AST_GTR); ast_addchild($$, $1); ast_addchild($$, $3); }
	; 
simpleExp: factor
	| simpleExp ADD factor      { $$ = new_astnode(AST_ADD);  ast_addchild($$, $1); ast_addchild($$, $3); }
	| simpleExp SUB factor 	    { $$ = new_astnode(AST_SUB);  ast_addchild($$, $1); ast_addchild($$, $3); }
	| SUB simpleExp %prec SUB   { $$ = new_astnode(AST_USUB); ast_addchild($$, $2); }
	;
factor: term
	| factor MUL term 			{ $$ = new_astnode(AST_MUL); ast_addchild($$, $1); ast_addchild($$, $3); }
	| factor DIV term 			{ $$ = new_astnode(AST_DIV); ast_addchild($$, $1); ast_addchild($$, $3); }
	;	
term: int 						{ $$ = new_astnode_int(AST_INT, $1);  }
	| id 						{ $$ = new_astnode_symbol(AST_VAR, $1); }
	| LPAREN exp RPAREN 		{ $$ = $2; }
	;

id: ID {
	char *idname = (char*)$1;
	Symbol * symbol = findsymbol(&program.symtab, idname);
	/*look to the symbol table if its defined*/
	if( symbol == NULL){
		fprintf(stderr, "Symbol '%s' was not declared in this scope.\n", idname);
		yyerror("");
		free(idname);
	}

	$$ = symbol;
};	

int: INT
	;
str: STR
	;
%%

void yyerror (char const *msg) {
	yyerror_state = 1;
	fprintf(stderr, "%s\n", msg);
	fprintf(stderr, "line:%d\n", yylineno);
	fprintf(stderr, "%s\n", linebuf);
}