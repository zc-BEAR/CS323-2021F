%{
    #include "lex.yy.c"
    void yyerror(const char*);
%}
%token INT
%left ADD SUB
%left MUL DIV
%token LP RP
%%
Calc: /* to allow empty input */
    | Exp { printf("= %d\n", $1); }
    ;
Exp: INT
    | LP Exp RP {$$ = $2; }
    | Exp ADD Exp { $$ = $1 + $3; }
    | Exp SUB Exp { $$ = $1 - $3; }
    | Exp MUL Exp { $$ = $1 * $3; }
    | Exp DIV Exp { $$ = $1 / $3; }
    ;
%%
void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}
int main() {
    yyparse();
}
