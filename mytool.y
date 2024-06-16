%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char const *);
%}
%token VALUE
%token LT
%token EQ
%token GT
%token AND
%left AND
%left LT GT EQ
%%
S: E { printf("Output: %s, 2, %d\n", $1 ? "TRUE" : "FALSE", !$1); return 0; }
;
E: E AND E { $$ = ($1 && $3); }
 | R { $$ = $1; }
;
R: VALUE LT VALUE { $$ = ($1 < $3); }
 | VALUE EQ VALUE { $$ = ($1 == $3); }
 | VALUE GT VALUE { $$ = ($1 > $3); }
;
%%
int main()
{
    yyparse();
    return 0;
}
void yyerror(char const *msg)
{
    fprintf(stderr, "%s\n", msg);
}
