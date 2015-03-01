#ifndef _AST_H_
#define _AST_H_

#include "symtable.h"

typedef enum EASTtype{
	AST_UNKNOWN = 0, 
	AST_NOPE,
	AST_PROGRAM,

	AST_VARS,
	AST_VAR,
	AST_INT,
	AST_STR,

	AST_STMT_LIST,
	AST_STMT,
	
	AST_ASS,
	AST_IF,
	AST_WHILE,
	AST_REPEAT,
	AST_EXP,

	AST_CALL,
	AST_PARAM,
	AST_PARAM_LIST,	

	AST_EQL,
	AST_NEQ,
	AST_LEQ,
	AST_GEQ,
	AST_LSS,
	AST_GTR,

	AST_ADD	,
	AST_SUB	,
	AST_USUB,

	AST_MUL,
	AST_DIV,	
} ASTtype;

typedef struct TASTnode {
	ASTtype type;

	int ival;
	char * sval;
	Symbol * symbol;

	struct TChildren {
		int count;
		struct TASTnode * first;
		struct TASTnode * last;
	} children;

	/* double linked list */
	struct Tsiblings {
		struct TASTnode * next;
		struct TASTnode * prev;
	} siblings;	

	struct TASTnode * parent;
} ASTnode;


int ast_addchild(ASTnode * parent, ASTnode * kid);
int ast_addsibling(ASTnode * first_born, ASTnode * sib);


ASTnode * new_astnode(ASTtype);
ASTnode * new_astnode_char(ASTtype, char *);
ASTnode * new_astnode_symbol(ASTtype, Symbol *);
ASTnode * new_astnode_int(ASTtype, int);

void ast_print(FILE * out, ASTnode *, int);

#endif