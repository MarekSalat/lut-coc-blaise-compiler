#ifndef _BLAISE_H_
#define _BLAISE_H_

#include "symtable.h"
#include "ast.h"

typedef struct TBlaiseProgram {
   char * name;

   int in;
   int out;

   SymbolTable symtab;
   ASTnode		* ast;
} BlaiseProgram;

#endif