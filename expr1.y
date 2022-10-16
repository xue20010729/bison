%{
/****************************************************************************
expr.y
ParserWizard generated YACC file.

Date: 2022年10月14日
****************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#ifndef YYSTYPE
#define YYSTYPE double
#endif

int yylex();                            //词法分析
extern int yyparse();
FILE* yyin;
void yyerror(const char* s );           //文法出错时调用

%}


// token define
%token ADD
%token SUB
%token MUL
%token DIV
%token LBRACKET
%token RBRACKET
%token NUMBER


//%token NUMBER
%left ADD SUB
%left MUL DIV
%right UMINUS

%%
lines	:	lines expr ';'	{ printf("%f\n", $2); }
		|	lines ';'
		|
		;

expr	:	expr ADD expr	{ $$ = $1 + $3; }
		|	expr SUB expr	{ $$ = $1 - $3; }
		|	expr MUL expr	{ $$ = $1 * $3; }
		|	expr DIV expr	{ $$ = $1 / $3; }
		|	LBRACKET expr RBRACKET	{ $$ = $2; }
		|	SUB expr %prec UMINUS	{ $$ = -$2; }
		|	NUMBER   {$$ = $1;}
		;   
// NUMBER	:	'0'				{ $$ = 0.0; }
// 		|	'1'				{ $$ = 1.0; }
// 		|	'2'				{ $$ = 2.0; }
// 		|	'3'				{ $$ = 3.0; }
// 		|	'4'				{ $$ = 4.0; }
// 		|	'5'				{ $$ = 5.0; }
// 		|	'6'				{ $$ = 6.0; }
// 		|	'7'				{ $$ = 7.0; }
// 		|	'8'				{ $$ = 8.0; }
// 		|	'9'				{ $$ = 9.0; }
// 		;
		
		
%%


int yylex(void)
{	
	int t;
	while(1){
		t = getchar();
		if (t == ' ' || t == '\t'|| t == '\n') {
            ;
        }
        else if (t == '+'){
            return ADD;
        }
        else if (t == '-'){
            return SUB;
        }
        else if (t == '*'){
            return MUL;
        }
        else if (t == '/'){
            return DIV;
        }
        else if (t == '('){
            return LBRACKET;
        }
        else if (t == ')'){
            return RBRACKET;
        }else if (isdigit(t)){
            yylval = 0;
            while(isdigit(t)){
                yylval = yylval * 10 + t - '0';
                t = getchar();
            }
            ungetc(t,stdin);
            return NUMBER;
        }else{
            return t;
        }
	}
}

int main(void)
{
    yyin = stdin ; 
    do {
            yyparse();
    } while (! feof(yyin)); 
    return 0;
}

void yyerror(const char* s) { 
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}