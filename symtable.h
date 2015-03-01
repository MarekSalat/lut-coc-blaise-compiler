#include <stdio.h>

#ifndef __SYMTABLE_H_
#define __SYMTABLE_H_

typedef struct TSymbol {
	char * name;
	struct TSymbol * left;
	struct TSymbol * right;
} Symbol;

typedef struct TSymbolTable{
	Symbol * root;
} SymbolTable;


Symbol * findsymbol(SymbolTable *, char *);
Symbol * addsymbol(SymbolTable *, char *);

/* strings will be freed too */
void freesymbolTableAndStrings(SymbolTable *);
void freesymbolTable(SymbolTable *);

void printInorder(SymbolTable *);


#endif // !__SYMTABLE_H_