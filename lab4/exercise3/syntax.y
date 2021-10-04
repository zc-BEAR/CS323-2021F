%{
    #include"lex.yy.c"
    void yyerror(const char*);
%}

%token LC RC LB RB COLON COMMA
%token STRING NUMBER FAKEINT
%token TRUE FALSE VNULL
%%

Json:
      Value
    ;
Value:
      Object
    | Array
    | STRING
    | NUMBER
    | TRUE
    | FALSE
    | VNULL
    | FAKEINT error { puts("fake int, recovered"); }
    ;
Object:
      LC RC
    | LC Members RC
    | LC Members RC Value error { puts("extra values, recovered"); }
    ;
Members:
      Member
    | Member COMMA Members
    | Member COMMA error { puts("miss members, recovered"); }
    | COMMA error { puts("begin with comma, recovered"); }
    | STRING VNULL error { puts("invalid members, recovered"); }
    | STRING COMMA VNULL error { puts("invalid members, recovered"); }
    ;
Member:
      STRING COLON Value
    | STRING COLON COLON Value error { puts("repeated colon, recovered"); }
    ;
Array:
      LB RB
    | LB Values RB
    | LB Values RC error { puts("unmatched right bracket, recovered"); }
    | RB error { puts("begin with right bracket, recovered"); }
    | LB Values RB COMMA error { puts("extra comma, recovered"); }
    | LB Values RB RB error { puts("extra right bracket, recovered"); }
    | LB Member RB error { puts("invalid value, recovered"); }
    | LB Values error { puts("miss right bracket, recovered"); }
    | LB Value COMMA COMMA RB error { puts("extra comma, recovered"); }
    | LB COMMA Value RB error { puts("extra comma, recovered"); }
    ;
Values:
      Value
    | Value COMMA Values
    ;
%%

void yyerror(const char *s){
    printf("syntax error: ");
}

int main(int argc, char **argv){
    if(argc != 2) {
        fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
        exit(-1);
    }
    else if(!(yyin = fopen(argv[1], "r"))) {
        perror(argv[1]);
        exit(-1);
    }
    yyparse();
    return 0;
}
