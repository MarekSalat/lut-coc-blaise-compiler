#include <stdlib.h>
#include "ast.h"

const char * STR_EASTtype[] = {
   "UNKNOWN",
   "NOPE",
   "PROGRAM",

   "VARS",
   "VAR",
   "INT",
   "STR",

   "STMT_LIST",
   "STMT",

   "ASS",
   "IF",
   "WHILE",
   "REPEAT",
   "EXP",

   "CALL",
   "PARAM",
   "PARAM_LIST",

   "EQL",
   "NEQ",
   "LEQ",
   "GEQ",
   "LSS",
   "GTR",

   "ADD",
   "SUB",
   "USUB",

   "MUL",
   "DIV",
};

int ast_addchild(ASTnode * parent, ASTnode * kid){
   if (kid == NULL || parent == NULL) return 0;

   kid->parent = parent;
   parent->children.count++;

   if (parent->children.first == NULL){
      parent->children.last  = kid;
      parent->children.first = kid;
      return 1;
   }

   kid->siblings.prev = parent->children.last;
   parent->children.last->siblings.next = kid;
   parent->children.last = kid;

   return 1;
}

int ast_addsibling(ASTnode * first_born, ASTnode * sib){
   if (first_born == NULL || sib == NULL) return 0;
   if (first_born->parent != NULL) return ast_addchild(first_born->parent, sib);

   for (ASTnode * i = first_born; i != NULL; i = i->siblings.next){
      if (i->siblings.next != NULL) continue;
      i->siblings.next = sib;

      sib->siblings.prev = i;
      sib->siblings.next = NULL;
      break;
   }
   return 1;
   
}

ASTnode * new_astnode(ASTtype type){
   ASTnode * n = malloc(sizeof(ASTnode));
   n->type = type;
   n->sval = NULL;
   n->ival = 0;
   n->children.count = 0;
   n->symbol = NULL;

   n->parent = NULL;

   n->children.first = NULL ;
   n->children.last = NULL;

   n->siblings.next = NULL;
   n->siblings.prev = NULL;

   return n;
}

ASTnode * new_astnode_char(ASTtype t, char * ret){
   ASTnode * n = new_astnode(t) ; 
   n->sval = ret;
   return n;
} 

ASTnode * new_astnode_symbol(ASTtype t, Symbol * s){
    ASTnode * n = new_astnode(t);
    n->symbol = s;
    return n;
}

ASTnode * new_astnode_int(ASTtype t, int i){
   ASTnode * n = new_astnode(t);
   n->ival = i;
   return n;
}

void ast_print(FILE * out,  ASTnode * ast, int level){
   if (ast == NULL) { printf("no children\n"); return; };

   for (int i = 0; i < level; i++) printf("  ");

   fprintf(out, "%s", STR_EASTtype[ast->type]);
   if (ast->sval != NULL) 
       fprintf(out, " - %s", ast->sval);
   if (ast->type == AST_INT)
       fprintf(out, " - %d", ast->ival);
   if (ast->type == AST_CALL)
       fprintf(out, " - %s", ast->symbol->name);
   if (ast->type == AST_VAR)
       fprintf(out, " - %s", ast->symbol->name);
   fprintf(out, "\n");

   level++;
   for (ASTnode * i = ast->children.first; i != NULL; i = i->siblings.next){
       ast_print(out, i, level);
   }
}