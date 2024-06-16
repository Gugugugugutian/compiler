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
[ \t\n]+ ;  // 忽略空格、制表符和换行符
. {
    yyerror("Unexpected character");
}
%%
int yywrap(void)
{
    return 1;
}
