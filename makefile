NAME=blaise
PACKAGE_NAME=0426412
FILES   = makefile blaise.l blaise.y blaise.h blaise.c symtable.c symtable.h ast.h ast.c tac.h tac.c tac2as64.h tac2as64.c README.txt opt
CC	    = gcc
CFLAGS	= -std=c99 -Wall -pedantic -Wno-unused -O3

OBJFILES=blaise.lex.o blaise.tab.o blaise.o symtable.o tac.o ast.o tac2as64.o

all: $(NAME)

# universal rule for generating all object files
%.o : %.c
	$(CC) $(CFLAGS) -c $<
 
blaise.lex.c: blaise.l blaise.tab.h blaise.tab.c
	flex -i -oblaise.lex.c $<
 
blaise.tab.c blaise.tab.h: blaise.y
	bison -o blaise.tab.c -d $<

## ## ## 
# This generates dependecies
dep:
	$(CC) -MM *.c >dep.list

## Add generated dependecies
-include dep.list
## ## ## 

# Compiling and linking all abject files to one executable file
$(NAME): $(OBJFILES)
	$(CC) $(CFLAGS) $(OBJFILES) -o $@

pack: $(FILES)
	mkdir $(PACKAGE_NAME)
	cp -f -r -t $(PACKAGE_NAME) $(FILES)
	tar -zcvf $(PACKAGE_NAME).tar.gz $(PACKAGE_NAME)
	rm -r $(PACKAGE_NAME) 
 
clean:
	rm -f *.o *~ *.exe blaise blaise.lex.c blaise.tab.h blaise.tab.c
clean-win:
	del -f *.o *~ *.exe blaise.lex.c blaise.tab.h blaise.tab.c