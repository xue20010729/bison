%{
/****************************************************************************
expr.y
ParserWizard generated YACC file.

Date: 2022年10月14日
****************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <cstring>
#include <map>
#include <iostream>
using namespace std;


struct cmp_str
{
    bool operator()(char const *a, char const *b)
    {
        return strcmp(a, b) < 0;
    }
};


char idStr[20];
int yylex();                            //词法分析
extern int yyparse();
FILE* yyin;
void yyerror(const char* s );           //文法出错时调用
map<char*,int,cmp_str> table;


%}

%union{ 
    double dbl;
    char* name;
}

// token define
%token ADD
%token SUB
%token MUL
%token DIV
%token LBRACKET
%token RBRACKET
%token Equal

%token <dbl> NUMBER
%token <name> ID

%type <dbl> expr 

%left ADD SUB
%left MUL DIV
%right UMINUS

%%
lines	:	lines expr ';'	{ printf("%f\n", $2); }
        |   lines assign ';' {}
		|	lines ';'
		|
		;

expr	:	expr ADD expr	{ $$ = $1 + $3; }
		|	expr SUB expr	{ $$ = $1 - $3; }
		|	expr MUL expr	{ $$ = $1 * $3; }
		|	expr DIV expr	{ $$ = $1 / $3; }
		|	LBRACKET expr RBRACKET	{ $$ = $2; }
		|	SUB expr %prec UMINUS	{ $$ = -$2; }
        |   ID {$$ = table[$1];}
		|	NUMBER   {$$ = $1;}
		;   

assign  :   ID Equal expr {table[$1] = $3;}
        ;

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
        }else if(t == '='){
            return Equal;
        }else if (isdigit(t)){
            yylval.dbl= 0;
            while(isdigit(t)){
                yylval.dbl = yylval.dbl* 10 + t - '0';
                t = getchar();
            }
            ungetc(t,stdin);
            return NUMBER;
        }else if (( t >= 'a' && t <= 'z' ) || ( t >= 'A' && t <= 'Z' ) || (t == '_')){
            int ti=0;
            while(( t >= 'a' && t <= 'z' ) || ( t >= 'A' && t <= 'Z' ) || (t == '_') || (t >= '0' &&  t <= '9')){
                idStr[ti]=t;
                ti++;
                t = getchar();
            }
            idStr[ti]='\0';
            yylval.name=new char[20];
            strcpy(yylval.name, idStr); 
            table.insert(pair<char*,int>(yylval.name,0));
            ungetc(t,stdin);
            return ID;
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