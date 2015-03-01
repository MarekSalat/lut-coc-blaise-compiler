#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <string.h>
#include <wchar.h>

#include "tac.h"

char * tacname[] = {
    "NOPE",
    
    "EQL",
    "NEQ",
    "LEQ",
    "GEQ",
    "LSS",
    "GTR",
    
    "ADD",
    "SUB",
    "MUL",
    "DIV",
    
    "ASS",
    
    "USUB",
    
    "CALL",
    
    "GOTO",
    
    "JMP0", 
    "LABEL",
} ;


extern char *strdup(const char *);

#define FOR_EACH_AST_CHILD(ast) for (ASTnode *child = (ast)->children.first; (child) != NULL; (child) = (child)->siblings.next)
#define GET_CALLBACK(ast) (tac_callbacks[(ast)->type])
#define CALL_CALLBACK(prog, ast, head) (GET_CALLBACK(ast)(prog, ast, head))
#define BUILD_ALL_CHILDREN(prog, parent, head) {FOR_EACH_AST_CHILD(ast){ head = CALL_CALLBACK(prog, child, head); }}

typedef TacListItem*(*F_callback) (BlaiseProgram *, ASTnode *, TacListItem *);

TacListItem * build(BlaiseProgram * prog, ASTnode *ast);

TacListItem * build_unknown	(BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_nope	   (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_program	(BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_vars	   (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_var		   (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_int       (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_stmt_list (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_ass       (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);

TacListItem * build_if        (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_while     (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_repeat    (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_exp       (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);

TacListItem * build_call      (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);

TacListItem * build_op        (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);
TacListItem * build_not_used  (BlaiseProgram *prog, ASTnode *ast, TacListItem * head);

F_callback tac_callbacks[] = {
   build_unknown,	   // AST_UNKNOWN = 0,
   build_nope,		   // AST_NOPE,
   build_program,	   // AST_PROGRAM,
                     
   build_vars,		   // AST_VARS,
   build_var,		   // AST_VAR,
                     
   build_int,        // AST_INT,        -- not used
   build_not_used,   // AST_STR,        -- not used

   build_stmt_list,	// AST_STMT_LIST,
   build_not_used,   // AST_STMT,       -- not used
   
   build_ass,   // AST_ASS,
   
   build_if,    // AST_IF,
   build_while, // AST_WHILE,
   build_repeat,// AST_REPEAT,
   build_exp,   // AST_EXP,
                
   build_call,        // AST_CALL,
   build_not_used,    // AST_PARAM,     -- not used
   build_not_used,    // AST_PARAM_LIST,-- not used

   build_op,    //AST_EQL,
   build_op,    //AST_NEQ,
   build_op,    //AST_LEQ,
   build_op,    //AST_GEQ,
   build_op,    //AST_LSS,
   build_op,    //AST_GTR,
   
   build_op,    //AST_ADD,
   build_op,    //AST_SUB,
   build_op,    //AST_USUB,
   
   build_op,    //AST_MUL,
   build_op,    //AST_DIV,
};


#define LAB_LENGHT (2 + 2 + 64 / 4)

void generateName(char dest[LAB_LENGHT + 1], const char *prefix, unsigned long num){
    snprintf(dest, LAB_LENGHT + 1, "%s%lx", prefix, num);
}

char * generateLabel(){
    static unsigned long int cnt = 0l;
    char dest[LAB_LENGHT + 1];
    generateName(dest, "__L_", cnt++);
    return strdup(dest);
}

unsigned long int new_tmpvarname_cnt = 0;
Symbol * new_tmpvar_symbol(SymbolTable * symtab){
    char dest[LAB_LENGHT + 1];
    generateName(dest, "__V_", new_tmpvarname_cnt++);

    Symbol * sym = findsymbol(symtab, dest);
    if (sym != NULL) 
        return sym;

    return addsymbol(symtab, strdup(dest));
}

TacListItem * new_TacListItem(Etactype type){
    TacListItem * i = malloc(sizeof(TacListItem));
    i->next = NULL;
    i->tac.type = type;
    i->tac.a.type = TAGARG_NONE;
    i->tac.b.type = TAGARG_NONE;
    i->tac.c.type = TAGARG_NONE;
    return i;
}

TacListItem * new_TacListItemLabel(){
    TacListItem * i = new_TacListItem(TAC_LABEL);
    i->tac.a.type = TAGARG_LAB;
    i->tac.a.argument.string = generateLabel();
    return i;
}

TacListItem * new_TacListItemGoto(TacListItem * label){
    assert(label != NULL);
    assert(label->tac.type == TAC_LABEL);
    assert(label->tac.a.type == TAGARG_LAB);

    TacListItem * i = new_TacListItem(TAC_GOTO);
    i->tac.a = label->tac.a;
    return i;
}

void tac_print(FILE * out, TacListItem * head) {

    for (TacListItem * item = head; item != NULL; item = item->next){
        TacArg arg[] = { item->tac.a, item->tac.b, item->tac.c };
        fprintf(out, "%7s   ", tacname[item->tac.type]);

        for (int i = 0; i < 3; i++) {
            if (arg[i].type == TAGARG_NONE) { continue; }
            if (arg[i].type == TAGARG_INT)  { fprintf(out, "%s%12d", i == 0 ? "" : "   ", arg[i].argument.integer); continue; }
            if (arg[i].type == TAGARG_VAR)  { fprintf(out, "%s%12s", i == 0 ? "" : "   ", arg[i].argument.symbol->name); continue; }
            // str or label
            fprintf(out, "%s%12s", i==0?"":"   ", arg[i].argument.string);
        }
        fprintf(out, "\n");
    }
}

void tac_free(TacListItem * taclist){
   return;
}

TacListItem * tac_buildList(BlaiseProgram * prog){
    return build(prog, prog->ast);
}

TacListItem * build(BlaiseProgram * prog, ASTnode *ast){
   assert(prog != NULL);
   assert(ast != NULL);

   TacListItem * head = new_TacListItem(TAC_NOPE);
   TacListItem * tail = CALL_CALLBACK(prog, ast, head);
   return head;
}

TacListItem * build_unknown(BlaiseProgram * prog, ASTnode *ast, TacListItem * head){
   fprintf(stderr, "%s:%d build_unknown", __FILE__,__LINE__);
   return head;
}

TacListItem * build_nope(BlaiseProgram * prog, ASTnode *ast, TacListItem * head){
   return head->next = new_TacListItem(TAC_NOPE);
}

TacListItem * build_program(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
   assert(ast->type == AST_PROGRAM);

   ASTtype expected = ast->children.count > 1 ? AST_VARS : AST_STMT_LIST;

   FOR_EACH_AST_CHILD(ast){
      if (child->type == AST_NOPE) continue;
      if (child->type != expected){
         fprintf(stderr, "expected %d but was %d\n", expected, child->type);
         break;
      }
      if (expected == AST_VARS) expected = AST_STMT_LIST;

      head = CALL_CALLBACK(prog, child, head);
   }

   return head;
}

TacListItem * build_vars(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
   assert(ast->type == AST_VARS);

   BUILD_ALL_CHILDREN(prog, ast, head);

   return head;
}

TacListItem * build_var(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
   assert(ast->type == AST_VAR);
   return head;
}

TacListItem * build_int(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    TacListItem * n = new_TacListItem(TAC_NOPE);
    n->tac.a.type = TAGARG_INT;
    n->tac.a.argument.integer = ast->ival;
    return head->next = n;
}

TacListItem * build_stmt_list(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
   assert(ast->type == AST_STMT_LIST);

   BUILD_ALL_CHILDREN(prog, ast, head);
   return head;
}

int try_evaluate(ASTnode * ast, int * dest){
    if (ast == NULL || ast->type == AST_VAR || ast->type == AST_STR)
        return 0;
    
    if (ast->type == AST_INT) { *dest = ast->ival; return 1; }
    if (ast->type == AST_EXP) return try_evaluate(ast->children.first, dest);

    int a, b;
    if (try_evaluate(ast->children.first, &a) <= 0) return 0;
    if (try_evaluate(ast->children.last,  &b) <= 0) return 0;

    switch (ast->type) {
        case AST_EQL: *dest = a == b; break;
        case AST_NEQ: *dest = a != b; break;
        case AST_LEQ: *dest = a <= b; break;
        case AST_GEQ: *dest = a >= b; break;
        case AST_LSS: *dest = a <  b; break;
        case AST_GTR: *dest = a >  b; break;
                      
        case AST_ADD: *dest = a + b; break;
        case AST_SUB: *dest = a - b; break;
        case AST_USUB:*dest = - a  ; break;
                      
        case AST_MUL: *dest = a * b; break;
        case AST_DIV: *dest = a / b; break;

        default: fprintf(stderr, "This should not have happened %s:%d", __FILE__, __LINE__); 
            return 0;
    }
    return 1;
}

TacListItem * build_ass(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    assert(ast->type == AST_ASS);
    assert(ast->children.count > 0);

    TacListItem * ass = new_TacListItem(TAC_ASS);
    ass->tac.a.type = TAGARG_VAR;
    ass->tac.a.argument.symbol = ast->symbol;

    head = CALL_CALLBACK(prog, ast->children.first, head);
    ass->tac.b = head->tac.a;
   
    head->next = ass;
    return ass;
}

TacListItem * build_exp(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    static unsigned long int cnt = 0;
    assert(ast->type == AST_EXP);
    assert(ast->children.count == 1);

    /* quick-fix: 
            when expresion has not instruction ( if var than) NOPE inctruction is created
            with first parameter set to VAR
    */
    ASTnode * var = ast->children.first;
    if (var->type == AST_VAR){
        TacListItem * instr = new_TacListItem(TAC_NOPE);
        instr->tac.a.type = TAGARG_VAR;
        instr->tac.a.argument.symbol = var->symbol;
        return head->next = instr;
    }

    cnt++;
    TacListItem * tail = CALL_CALLBACK(prog, ast->children.first, head);
    if ((--cnt) <= 0) { new_tmpvarname_cnt = 0; cnt = 0; }
    return tail;
}

TacListItem * build_op(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    ASTnode * node[2] = { ast->children.first, ast->children.last };
    TacArg arg[2];

    int result;
    if (try_evaluate(ast, &result) > 0){
        TacListItem * n = new_TacListItem(TAC_NOPE);
        n->tac.a.type = TAGARG_INT;
        n->tac.a.argument.integer = result;
        return head->next = n;
    }

    // because unary minus has only one child
    const int max = ast->children.first == ast->children.last ? 1 : 2;

    for (int i = 0; i < max; i++){
        if (node[i]->type == AST_VAR){
            arg[i].type = TAGARG_VAR;
            arg[i].argument.symbol = node[i]->symbol;
            continue;
        }

        int result;
        if (try_evaluate(node[i], &result) > 0){
            arg[i].type = TAGARG_INT;
            arg[i].argument.integer = result;            
        }
        else {
            head = CALL_CALLBACK(prog, node[i], head);
            arg[i] = head->tac.a;            
        }
    }

    TacArg dest;
    dest.type = TAGARG_VAR;
    dest.argument.symbol = new_tmpvar_symbol(&prog->symtab);

    TacListItem * inst = new_TacListItem(TAC_NOPE);
    inst->tac.a = dest;
    inst->tac.b = arg[0];
    if (max > 1)
        inst->tac.c = arg[1];

    switch (ast->type) {
        case AST_EQL: inst->tac.type = TAC_EQL; break;
        case AST_NEQ: inst->tac.type = TAC_NEQ; break;
        case AST_LEQ: inst->tac.type = TAC_LEQ; break;
        case AST_GEQ: inst->tac.type = TAC_GEQ; break;
        case AST_LSS: inst->tac.type = TAC_LSS; break;
        case AST_GTR: inst->tac.type = TAC_GTR; break;
            
        case AST_ADD: inst->tac.type = TAC_ADD; break;
        case AST_SUB: inst->tac.type = TAC_SUB; break;
        case AST_USUB:inst->tac.type = TAC_USUB;break;
            
        case AST_MUL: inst->tac.type = TAC_MUL; break;
        case AST_DIV: inst->tac.type = TAC_DIV; break;

        default: fprintf(stderr, "This should not have happened %s:%d", __FILE__, __LINE__);
            break;
    }
   
    head->next = inst;
    return inst;
}

TacListItem * build_if(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    assert(ast->type == AST_IF);
    assert(ast->children.count >= 1);

    TacListItem * lab_else  = new_TacListItemLabel();
    TacListItem * lab_endif = new_TacListItemLabel();

    // exp
    ASTnode * exp = ast->children.first;
    head = CALL_CALLBACK(prog, exp, head);
    TacListItem * jmp0 = new_TacListItem(TAC_JMP0);
    jmp0->tac.a = head->tac.a;
    jmp0->tac.b = lab_else->tac.a;
    head = head->next = jmp0;

    ASTnode * stmt_list_1 = exp->siblings.next;
    head = CALL_CALLBACK(prog, stmt_list_1, head);
    // GOTO endif
    ASTnode * stmt_list_2 = stmt_list_1->siblings.next;
    if (stmt_list_2 != NULL)
        head = head->next = new_TacListItemGoto(lab_endif);

    head = head->next = lab_else;
    
    if (stmt_list_2 != NULL){
        head = CALL_CALLBACK(prog, stmt_list_2, head);
        head = head->next = lab_endif;
    }
    else{
        free(lab_endif);
    }

    return head;
}

TacListItem * build_while(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    assert(ast->type == AST_WHILE);
    assert(ast->children.count > 1);

    ASTnode * exp = ast->children.first;
    ASTnode * stmt_list = exp->siblings.next;

    TacListItem * lab_cmp = new_TacListItemLabel();
    TacListItem * lab_end = new_TacListItemLabel();

    head = head->next = lab_cmp;
    //exp
    head = CALL_CALLBACK(prog, exp, head);

    TacListItem * jmp0 = new_TacListItem(TAC_JMP0);
    jmp0->tac.a = head->tac.a;
    jmp0->tac.b = lab_end->tac.a;
    head = head->next = jmp0;

    head = CALL_CALLBACK(prog, stmt_list, head);
    head = head->next = new_TacListItemGoto(lab_cmp);
    head = head->next = lab_end;

    return head;
}

TacListItem * build_repeat(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    assert(ast->type == AST_REPEAT);
    assert(ast->children.count > 1);

    ASTnode * exp = ast->children.first;
    ASTnode * stmt_list = exp->siblings.next;

    TacListItem * lab_start = new_TacListItemLabel();

    head = head->next = lab_start;

    head = CALL_CALLBACK(prog, stmt_list, head);

    //exp
    head = CALL_CALLBACK(prog, exp, head);

    TacListItem * jmp0 = new_TacListItem(TAC_JMP0);
    jmp0->tac.a = head->tac.a;
    jmp0->tac.b = lab_start->tac.a;
    head = head->next = jmp0;   

    return head;
}

TacListItem * build_call(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    assert(ast->type == AST_CALL);
    ASTnode * paramlist = ast->children.first;

    if (paramlist == NULL) return head;

    FOR_EACH_AST_CHILD(paramlist){
        TacListItem * call = new_TacListItem(TAC_CALL);

        call->tac.a.type = TAGARG_VAR;
        call->tac.a.argument.symbol = ast->symbol;

        if (child->type == AST_STR) {            
            call->tac.b.type = TAGARG_STR;
            call->tac.b.argument.string = child->sval;
            head = head->next = call;
            continue;
        }
        
        head = CALL_CALLBACK(prog, child, head);

        call->tac.b = head->tac.a;        
        head = head->next = call;
    }

    return head;
}

TacListItem * build_not_used(BlaiseProgram *prog, ASTnode *ast, TacListItem * head){
    fprintf(stderr, "%s:%d This should have not happen\n", __FILE__, __LINE__);
    return head;
}