%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char const *);
    int compare_count = 0;
    int short_circuit_count = 0;
%}
%token VALUE
%token LT
%token EQ
%token GT
%token AND
%left AND
%left LT GT EQ
%%
S: E { 
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
