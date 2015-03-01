#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "symtable.h"

Symbol * newsym(char * name){
	Symbol * s = malloc(sizeof(Symbol));
	s->name  = name;
	s->left  = NULL;
	s->right = NULL;
	return s;
}

Symbol * findsym(Symbol * s, char * sname){
	if (s == NULL) return NULL;

	int cmp = strcmp(sname, s->name);
	if (cmp == 0) return s;
	if (cmp < 0) return findsym(s->left,  sname);
	//if (cmp > 0)
	return findsym(s->right, sname);
}

Symbol * findsymbol(SymbolTable *symtab, char * sname){
	return findsym(symtab->root, sname);
}

Symbol * addsym(Symbol * root, Symbol * s){
	int cmp = strcmp(s->name, root->name);
	
	if (cmp == 0) return root;	// conflict
	if (cmp < 0) {
		if (root->left != NULL)
			return addsym(root->left, s);
		root->left = s;
		return s;
		
	}
	//if (cmp > 0) {
	if (root->right != NULL)
		return addsym(root->right, s);
	root->right = s;
	return s;
	//}
}

Symbol * addsymbol(SymbolTable * symtab, char * name){
	Symbol * s = newsym(name);
	if(s == NULL) return NULL;
	if(symtab->root == NULL) {
		symtab->root = s;
		return s;
	}
	return addsym(symtab->root, s);
}

void freesymbol(Symbol *s, int nameToo){
	if (s == NULL) return;
	if (nameToo) free(s->name);
	freesymbol(s->left, nameToo);
	freesymbol(s->right, nameToo);
	free(s);
}

void freesymbolTableAndStrings(SymbolTable * st){
	freesymbol(st->root, 1);
}
void freesymbolTable(SymbolTable * st){
	freesymbol(st->root, 0);
}

void printsym(Symbol *s){
	if (s == NULL) return;
	printsym(s->left);
	printf("%s\n", s->name);
	printsym(s->right);
}

void printInorder(SymbolTable * st){
	printsym(st->root);
}