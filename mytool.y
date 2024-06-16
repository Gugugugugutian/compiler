%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char const *);
    int compare_count = 0;
    int short_circuit_count = 0;
%}
%token NEWLINE
%token VALUE
%token LT
%token EQ
%token GT
%token AND
%token OR
%token NOT
%token LTEQ
%token GTEQ
%token NOTEQ
%token LPAREN
%token RPAREN

%left OR
%left AND
%nonassoc LT GT LTEQ GTEQ EQ NOTEQ
%nonassoc NOT
%left LPAREN RPAREN

%%
S: E NEWLINE { 
    printf("Output: %s, %d, %d\n", $1 ? "TRUE" : "FALSE", compare_count, short_circuit_count); 
    return 0; 
}
;
E: E AND E { 
    if ($1) {
        $$ = $3;
        short_circuit_count += 0;
    } else {
        $$ = 0;
        short_circuit_count += 1;
    }
}
 | E OR E { 
    if ($1) {
        $$ = 1;
        short_circuit_count += 1;
    } else {
        $$ = $3;
        short_circuit_count += 0;
    }
}
 | NOT E { 
    $$ = !$2; 
}
 | LPAREN E RPAREN { $$ = $2; }
 | R { $$ = $1; }
;
R: VALUE LT VALUE { 
    $$ = ($1 < $3); 
    compare_count++; 
}
 | VALUE EQ VALUE { 
    $$ = ($1 == $3); 
    compare_count++; 
}
 | VALUE GT VALUE { 
    $$ = ($1 > $3); 
    compare_count++; 
}
 | VALUE LTEQ VALUE { 
    $$ = ($1 <= $3); 
    compare_count++; 
}
 | VALUE GTEQ VALUE { 
    $$ = ($1 >= $3); 
    compare_count++; 
}
 | VALUE NOTEQ VALUE { 
    $$ = ($1 != $3); 
    compare_count++; 
}
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
