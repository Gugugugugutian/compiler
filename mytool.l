%{
    #include <stdio.h>
    #include "mytool.tab.h"
    #include <stdlib.h>
%}
digit   [0-9]
%%
{digit}+ {
    yylval = atoi(yytext);
    return VALUE;
}
"==" {
    return EQ;
}
">" {
    return GT;
}
"<" {
    return LT;
}
"&&" {
    return AND;
}
"||" {
    return OR;
}
"!" {
    return NOT;
}
"<=" {
    return LTEQ;
}
">=" {
    return GTEQ;
}
"!=" {
    return NOTEQ;
}
"\n" {
    return NEWLINE;
}
"(" {
    return LPAREN;
}
")" {
    return RPAREN;
}
%%
int yywrap(void)
{
    return 1;
}
