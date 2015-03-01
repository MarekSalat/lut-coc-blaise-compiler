%{
	#include <string.h>
	#include <wchar.h>
	#include <ctype.h>
	#include "blaise.tab.h"

	extern char *strdup(const char *);
	extern char *strndup(const char *s, size_t n);

#if defined _WIN32 || defined __CYGWIN__
	int yylineno=1;
#endif

	char linebuf[500];

	void comment();

	char * str2lower(char * st){
		for (int i = 0; st[i]; i++)
  			st[i] = tolower(st[ i ]);
  		return st;
  	}
%}

%option yylineno
%option warn nodefault
%option noyywrap never-interactive

/* %option bison-bridge */

digit         [0-9]
letter        [a-zA-Z]
 
%%
"(*"				 { comment(); }

"+"                  { return ADD;       }
"-"                  { return SUB;      }
"*"                  { return MUL;      }
"DIV"                { return DIV;        }
"("                  { return LPAREN;     }
")"                  { return RPAREN;     }
";"                  { return SEMICOLON;  }
":"                  { return COLON;	  }
","                  { return COMMA;      }
"."                  { return PERIOD;     }
":="                 { return BECOMES;    }
"'"					 { return QUOTE;      }

"="                  { return EQL;        }
"<>"                 { return NEQ;        }
"<"                  { return LSS;        }
">"                  { return GTR;        }
"<="                 { return LEQ;        }
">="                 { return GEQ;        }

"program"            { return PROGRAM;    }
"begin"              { return BEGINSYM;   }
"end"                { return END;     }
"if"                 { return IF;      }
"then"               { return THEN;    }
"else"               { return ELSE;    }
"var"                { return VAR;     }
"while"              { return WHILE;   }
"do"                 { return DO;      }
"repeat"             { return REPEAT;  }
"until"              { return UNTIL;   }

"input"				 { return INPUT ;  }
"output"			 { return OUTPUT;  }
"integer"			 { return DT_INT; }

{letter}({letter}|{digit}|_)* {
                       yylval.sval = str2lower(strdup(yytext));
                       return ID;      }

{digit}+             { yylval.ival = atoi(yytext);
                       return INT;     }


\n.*				 {	strncpy(linebuf, yytext+1, sizeof(linebuf)); /* save the next line */
						yyless(1); /* give back all but the \n to rescan */
						yylineno++; }

'([^']*)'		 	 {  yylval.sval = strdup(yytext+1); 
						yylval.sval[strlen(yylval.sval)-1] = '\0'; 
						return STR;
					 }				

[ \t\n\r]            /* skip whitespace */
"{"[^\n\r}]*"}"		 /* skip one-line comment */
.                    { yylval.unknown = strdup(yytext); return UNKNOWN;    }
%%

void comment() {
	char star, rpar;

	while(1){
		while ((star = input()) != '*' && star != 0) {
			if(star == '\n') yylineno++;
		}
		
		if ((rpar = input()) != ')' && star != 0) continue;

		break;		
	}	
} 