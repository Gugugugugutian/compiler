%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char const *);

	#ifndef BTOD_H_INCLUDED
	#define BTOD_H_INCLUDED
	typedef struct
	{
   	 int val;
   	 int total;
   	 int short1;
	} myStruct; 
	#endif
	#define YYSTYPE myStruct
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
    printf("Output: %s, %d, %d\n", $1.val ? "TRUE" : "FALSE", $1.total, $1.short1); 
    return 0; 
}
;
E: E AND E { 
    if ($1.val) {
        $$.val = $3.val;
    } else {
        $$.val = 0;
        $$.short1 += $3.total;
    }
	$$.total = $1.total + $3.total;
}
 | E OR E { 
    if ($1.val) {
        $$.val = $1.val;
        $$.short1 += $3.total;
    } else {
        $$.val = $3.val;
    }
	$$.total = $1.total + $3.total;
}
 | NOT E { 
    $$.val = !$2.val; 
	$$.total = $2.total;
	$$.short1 = $2.short1;
}
 | LPAREN E RPAREN { $$.val = $2.val; }
 | R { $$.val = $1.val; }
;
R: VALUE LT VALUE { 
    $$.val = ($1.val < $3.val); 
	$$.total = 1; $$.short1 = 0;
}
 | VALUE EQ VALUE { 
    $$.val = ($1.val == $3.val); 
	$$.total = 1; $$.short1 = 0;
}
 | VALUE GT VALUE { 
    $$.val = ($1.val > $3.val); 
	$$.total = 1; $$.short1 = 0;
}
 | VALUE LTEQ VALUE { 
    $$.val = ($1.val <= $3.val); 
	$$.total = 1; $$.short1 = 0;
}
 | VALUE GTEQ VALUE { 
    $$.val = ($1.val >= $3.val); 
	$$.total = 1; $$.short1 = 0;
}
 | VALUE NOTEQ VALUE { 
    $$.val = ($1.val != $3.val); 
	$$.total = 1; $$.short1 = 0;
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
