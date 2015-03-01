#ifndef _TAC_H_
#define _TAC_H_

#include "blaise.h"
#include "ast.h"
#include "symtable.h"

typedef enum TEtacArgType {
   TAGARG_NONE = 0,
   TAGARG_INT,
   TAGARG_STR,
   TAGARG_VAR,
   TAGARG_LAB,
} EtacArgType;

typedef struct TTacArg {
   EtacArgType type;
   union {
      int integer;	/* Integer constants */
      char * string;	/* String constant */
      Symbol *symbol; /* Identifiers */
      char *label;	/* Labels */
   } argument;
} TacArg;

typedef enum TEtactype {
   TAC_NOPE = 0,    // <-- DO NOTHING
   // dest a b
   TAC_EQL,
   TAC_NEQ,
   TAC_LEQ,
   TAC_GEQ,
   TAC_LSS,
   TAC_GTR,
   // dest a b
   TAC_ADD,
   TAC_SUB,
   TAC_MUL,
   TAC_DIV,
   // dest a
   TAC_ASS,
   // dest a
   TAC_USUB,
   // a
   TAC_CALL,
   // label
   TAC_GOTO,
   // label a
   TAC_JMP0,    // jump if zero 
   TAC_LABEL,
} Etactype;

typedef struct Ttac {
   Etactype type;

   TacArg b;
   TacArg c;
   TacArg a;
} Tac;

typedef struct TTacListItem {
   Tac tac;
   struct TTacListItem * next;
} TacListItem;

TacListItem * tac_buildList(BlaiseProgram *);
void tac_free(TacListItem *);

void tac_print(FILE * out, TacListItem * head);

#endif // !_TAC_H_
