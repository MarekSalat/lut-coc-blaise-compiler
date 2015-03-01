#include <string.h>
#include "tac2as64.h"
#include "symtable.h"

typedef void(*F_Tac2as)(TacListItem * head, FILE * out);

#define GET_CALLBACK(item) (tac2as64_callbacks[((item)->tac.type)])
#define CALL_CALLBACK(item, out) (GET_CALLBACK(item)(item, out))

void nope(TacListItem * head, FILE * out){}

void op (TacListItem * head, FILE * out);
void ass (TacListItem * head, FILE * out);
void usub(TacListItem * head, FILE * out);
void call(TacListItem * head, FILE * out);
void _goto(TacListItem * head, FILE * out);
void jmp0 (TacListItem * head, FILE * out);
void label(TacListItem * head, FILE * out);

void vars(Symbol * root, FILE * out);

unsigned long string_counter = 0;

F_Tac2as tac2as64_callbacks[] = {
    nope,   // TAC_NOPE = 0,    // <-- DO NOTHING
    op,    // TAC_EQL,
    op,    // TAC_NEQ, 
    op,    // TAC_LEQ, 
    op,    // TAC_GEQ, 
    op,    // TAC_LSS, 
    op,    // TAC_GTR,
    
    op,    // TAC_ADD,
    op,    // TAC_SUB,
    op,    // TAC_MUL,
    op,    // TAC_DIV,
    
    ass,    // TAC_ASS,
    usub,   // TAC_USUB,
    
    call,  // TAC_CALL,
    
    _goto,  // TAC_GOTO,
    
    jmp0,   // TAC_JMP0,
    label,  // TAC_LABEL,    
};

extern char * tacname[];

void tac2as64(TacListItem * head, SymbolTable * symtab,FILE * out){
    string_counter = 0;

    fprintf(out, ".text\n");
    fprintf(out, "   .global main\n");
    
    fprintf(out, "main:\n");
    fprintf(out, "   pushq %%rbp\n");
    fprintf(out, "   movq  %%rsp, %%rbp\n");
    fprintf(out, "   /** START **/\n\n\n");

    for (TacListItem * i = head; i != NULL; i = i->next){
        if (i->tac.type == TAC_NOPE) continue;
        fprintf(out, "\n   /* %s */\n", tacname[i->tac.type]);
        CALL_CALLBACK(i, out);
    }    

    fprintf(out, "\n\n   /** END **/\n");
    fprintf(out, "   leave\n");
    fprintf(out, "   ret\n");

    fprintf(out, ".data\n");
    fprintf(out, "   paramwrlstr : .string \"%%s\\n\"\n");
    fprintf(out, "   paramwrlint : .string \"%%d\\n\"\n");
    fprintf(out, "   paramwristr : .string \"%%s\"\n");
    fprintf(out, "   paramwriint : .string \"%%d\"\n\n");
    vars(symtab->root, out);

    // WARNING: QUICK FIX
    string_counter = 0;
    for (TacListItem * item = head; item != NULL; item = item->next){
        
        TacArg * arg[3] = { &item->tac.a, &item->tac.b, &item->tac.c };
        for (int i = 0; i < 3; i++){
            if (arg[i]->type == TAGARG_STR)
                fprintf(out, "   __S_%lx: .string \"%s\"\n", string_counter++, arg[i]->argument.string);
        }
    }
}

void vars(Symbol * s, FILE * out){
    if (s == NULL) return;
    vars(s->left, out);
    fprintf(out, "   %s : .quad 0\n", s->name);
    vars(s->right, out);
}

void op(TacListItem * head, FILE * out){
    /*
    [TAC_ADD (k) (t) (_T0)]
    movq k(%rip), %rbx
    movq t(%rip), %rax
    addq %rbx, %rax
    movq %rax, _T0(%rip)

    [TAC_SUB (k) (t) (_T1)]
    movq k(%rip), %rax
    movq t(%rip), %rbx
    subq %rbx, %rax
    movq %rax, _T1(%rip)

    [TAC_MUL (k) (t) (_T2)]

    movq k(%rip), %rbx
    movq t(%rip), %rax
    imulq %rbx, %rax
    movq %rax, _T2(%rip)

    [TAC_DIV (k) (t) (_T3)]

    movq k(%rip), %rax
    movq t(%rip), %rbx
    movq $0, %rdx
    idivq %rbx
    movq %rax, _T3(%rip)

    [TAC_CMP]
    movq	k(%rip), %rax
    movq	t(%rip), %rbx
    cmpq	%rbx, %rax
    setne	%al
    movzbq	%al, %rax
    movl	%rax, x(%rip)
    */

    TacArg a = head->tac.a;
    TacArg b = head->tac.b;
    TacArg c = head->tac.c;

    if (b.type == TAGARG_VAR)
        fprintf(out, "   movq %s(%%rip), %%rax\n", b.argument.symbol->name);
    else if (b.type == TAGARG_INT)
        fprintf(out, "   movq $%d, %%rax\n", b.argument.integer);

    if (c.type == TAGARG_VAR)
        fprintf(out, "   movq %s(%%rip), %%rbx\n", c.argument.symbol->name);
    else if (c.type == TAGARG_INT)
        fprintf(out, "   movq $%d, %%rbx\n", c.argument.integer);

    switch (head->tac.type){
        case TAC_ADD: fprintf(out, "   addq %%rbx, %%rax\n"); break;
        case TAC_SUB: fprintf(out, "   subq %%rbx, %%rax\n"); break;
        case TAC_MUL: fprintf(out, "   imulq %%rbx, %%rax\n"); break;
        case TAC_DIV: 
            fprintf(out, "   movq $0, %%rdx\n");
            fprintf(out, "   idivq %%rbx\n"); 
            break;
        default: {
            fprintf(out, "   cmpq %%rbx, %%rax\n");
            switch (head->tac.type){
                case TAC_EQL: fprintf(out, "   sete %%al\n"); break;
                case TAC_NEQ: fprintf(out, "   setne %%al\n"); break;
                case TAC_LEQ: fprintf(out, "   setl %%al\n"); break;
                case TAC_GEQ: fprintf(out, "   setg %%al\n"); break;
                case TAC_LSS: fprintf(out, "   setle %%al\n"); break;
                case TAC_GTR: fprintf(out, "   setge %%al\n"); break;
                default: fprintf(stderr, "This should not have happened %s:%d\n", __FILE__, __LINE__);
            }
            fprintf(out, "   movzbq %%al, %%rax\n");
        }
    }

    fprintf(out, "   movq %%rax, %s(%%rip)\n", a.argument.symbol->name);
}

void ass(TacListItem * head, FILE * out) {
    /*  movq src(%rip)|$const, %rax
        movq %rax, dst(%rip) 
    */
    TacArg src = head->tac.b;
    TacArg dst = head->tac.a;
    if (src.type == TAGARG_VAR)
        fprintf(out, "   movq %s(%%rip), %%rax\n", src.argument.symbol->name);
    else if (src.type == TAGARG_INT)
        fprintf(out, "   movq $%d, %%rax\n", src.argument.integer);
    fprintf(out, "   movq %%rax, %s(%%rip)\n", dst.argument.symbol->name);
}   

void usub(TacListItem * head, FILE * out){
    TacArg var = head->tac.b;
    if (var.type == TAGARG_VAR)
        fprintf(out, "   movq %s(%%rip), %%rax\n", var.argument.symbol->name);
    else if (var.type == TAGARG_INT)
        fprintf(out, "   movq $%d, %%rax\n", var.argument.integer);
    fprintf(out, "   negq %%rax\n");
    fprintf(out, "   movq %%rax, %s(%%rip)\n", head->tac.a.argument.symbol->name);
}

void wrt(TacListItem * head, FILE * out, int nl){
    /*
    movq k(%rip), %rsi
    movq $paramwrlint, %rdi
    movq $0, %rax
    call printf

    movq $paramwrlstr, %rdi
    movq $_S0, %rsi
    call printf
    */
    switch (head->tac.b.type){
        case TAGARG_VAR:
            fprintf(out, "   movq %s(%%rip), %%rsi\n", head->tac.b.argument.symbol->name);
            fprintf(out, "   movq $%s, %%rdi\n", nl > 0 ? "paramwrlint" : "paramwriint");
            fprintf(out, "   movq $0, %%rax\n");
            break;
        case TAGARG_INT:
            fprintf(out, "   movq $%d, %%rsi\n", head->tac.b.argument.integer);
            fprintf(out, "   movq $%s, %%rdi\n", nl > 0 ? "paramwrlint" : "paramwriint");
            fprintf(out, "   movq $0, %%rax\n");
            break;
        case TAGARG_STR: 
            fprintf(out, "   movq $%s, %%rdi\n", nl > 0 ? "paramwrlstr" : "paramwristr");
            fprintf(out, "   movq $__S_%lx, %%rsi\n", string_counter++);
            break;
        default: fprintf(stderr, "This should not have happened %s:%d\n", __FILE__, __LINE__); return;
    }
    fprintf(out, "   call printf\n");
}

void call(TacListItem * head, FILE * out)  {
    if (strcmp(head->tac.a.argument.symbol->name, "write") == 0)
        wrt(head, out, 0);
    else if (strcmp(head->tac.a.argument.symbol->name, "writeln") == 0)
        wrt(head, out, 1);
    else 
        fprintf(stderr, "This should not have happened %s:%d\n", __FILE__, __LINE__);
    return;
}

void _goto(TacListItem * head, FILE * out){
    /* jmp label */
    fprintf(out, "   jmp %s\n", head->tac.a.argument.label);
} 

void jmp0(TacListItem * head, FILE * out) {
    /*  movq var(%rip)|$const, %rax
        cmpq $0, %rax
        jz _L2 
    */
    TacArg var = head->tac.a;
    TacArg lbl = head->tac.b;
    if (var.type == TAGARG_VAR) 
        fprintf(out, "   movq %s(%%rip), %%rax\n", var.argument.symbol->name);
    else if (var.type == TAGARG_INT)
        fprintf(out, "   movq $%d, %%rax\n", var.argument.integer);
    fprintf(out, "   cmpq $0, %%rax\n");
    fprintf(out, "   jz %s\n", lbl.argument.label);
}

void label(TacListItem * head, FILE * out){
    fprintf(out, "%s:\n", head->tac.a.argument.label);
}