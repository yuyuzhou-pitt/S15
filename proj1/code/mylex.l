%{
#include <stdlib.h>
#include "token.h"
#define LIMIT1 1000 //total number of characters in all dictint identifier and strings
#define LIMIT2 10000 //total number of Token

extern int yycolumn, yylength, yyline, yylval;
%}

/* regular definitions */

digit         [0-9]
consint       [0-9]+
id            [a-zA-Z][a-zA-Z0-9]*
delim         [ \t]
ws            {delim}+
newline       [\n]

%%
{newline}           {yyline++; yycolumn=0;}
"/*"(.*)"*/"        {yycolumn+=yyleng;}
"/*"(.*)"\n"        {printf("Error: line %d: Unmatched comments", yyline);yyline++; yycolumn=0;}
&&                  {yycolumn+=2;return(ANDnum);}
\|\|                {yycolumn+=2;return(ORnum);}
:=                  {yycolumn+=2;return(ASSGNnum);}
declarations        {yycolumn+=12;return(DECLARATIONSnum);}
enddeclarations     {yycolumn+=15;return(ENDDECLARATIONSnum);}
int                 {yycolumn+=3;return(INTnum);}
method              {yycolumn+=6;return(METHODnum);}
program             {yycolumn+=7;return(PROGRAMnum);}
val                 {yycolumn+=3;return(VALnum);}
while               {yycolumn+=5;return(WHILEnum);}
class               {yycolumn+=5;return(CLASSnum);}
else                {yycolumn+=4;return(ELSEnum);}
if                  {yycolumn+=2;return(IFnum);}
return              {yycolumn+=6;return(RETURNnum);}
void                {yycolumn+=4;return(VOIDnum);} 
[.]                 {yycolumn+=1;return(DOTnum);}
[,]                 {yycolumn+=1;return(COMMAnum);}
[;]                 {yycolumn+=1;return(SEMInum);}
==                  {yycolumn+=2;return(EQnum);}
!=                  {yycolumn+=2;return(NEnum);}
>=                  {yycolumn+=2;return(GEnum);}
\<=                 {yycolumn+=2;return(LEnum);}
[=]                 {yycolumn+=1;return(EQUALnum);}
[<]                 {yycolumn+=1;return(LTnum);}
[>]                 {yycolumn+=1;return(GTnum);}
[+]                 {yycolumn+=1;return(PLUSnum);}
[-]                 {yycolumn+=1;return(MINUSnum);}
[*]                 {yycolumn+=1;return(TIMESnum);}
[/]                 {yycolumn+=1;return(DIVIDEnum);}
[!]                 {yycolumn+=1;return(NOTnum);}
{ws}                {yycolumn+=yyleng;}
{id}		    {yycolumn+=yyleng;return (IDnum);}
{consint}           {yycolumn+=yyleng;return (ICONSTnum);}
[/{]                {yycolumn+=1;return(LBRACEnum);}
[/}]                {yycolumn+=1;return(RBRACEnum);}
[/[]                {yycolumn+=1;return(LBRACnum);}
]                   {yycolumn+=1;return(RBRACnum);}
[(]                 {yycolumn+=1;return(LPARENnum);}
[)]                 {yycolumn+=1;return(RPARENnum);}
%%

int yyline = 0;
int yycolumn = 0;
int yywrap()
{
    return 1;
}

char StringTable[LIMIT1];// stringtable
int STIndex=0;// A pointer to next empty slot in String Table

typedef struct{
    int line;
    int column;
    int token;
    int Index_in_String_Table;   
}LineItem;  // one line of the output
 
LineItem output[LIMIT2]; // output table
int OUTIndex = 0; // a point to the new line of output table 

char* transToken(int Tokenid)
{
    switch(Tokenid)
    {
        case 257:	return("ANDnum");
	case 258:	return("ASSGNnum");
	case 259:	return("DECLARATIONSnum");
        case 260:	return("DOTnum");
	case 261:	return("ENDDECLARATIONSnum");
	case 262:	return("EQUALnum");
	case 263:	return("GTnum");
	case 264:	return("IDnum");
	case 265:	return("INTnum");
	case 266:	return("LBRACnum");
	case 267:	return("LPARENnum");
	case 268:	return("METHODnum");
	case 269:	return("NEnum");
	case 270:	return("ORnum");
	case 271:	return("PROGRAMnum");
	case 272:	return("RBRACnum");
	case 273:	return("RPARENnum");
	case 274:	return("SEMInum");
	case 275:	return("VALnum");
	case 276:	return("WHILEnum");
	case 277:	return("CLASSnum");
	case 278:	return("COMMAnum");
	case 279:	return("DIVIDEnum");
	case 280:	return("ELSEnum");
	case 281:	return("EQnum");
	case 282:	return("GEnum");
	case 283:	return("ICONSTnum");
	case 284:	return("IFnum");
	case 285:	return("LBRACEnum");
	case 286:	return("LEnum");
	case 287:	return("LTnum");
	case 288:	return("MINUSnum");
	case 289:	return("NOTnum");
	case 290:	return("PLUSnum");
	case 291:	return("RBRACEnum");
	case 292:	return("RETURNnum");
	case 293:	return("SCONSTnum");
	case 294:	return("TIMESnum");
	case 295:	return("VOIDnum");
	case 0:		return("EOFnum");
	default: 	return("NA");
    }
}

main()
{
    int lexReturn;
    int i;
    do {
       lexReturn = yylex();
       output[OUTIndex].token=lexReturn;
       output[OUTIndex].line=yyline;
       output[OUTIndex].column=yycolumn;
       OUTIndex++;
       //printf("return token type is %d\n", lexReturn);

    } while (lexReturn != 0);

    printf("\nLine\tColummn\tToken\tIndex_in_String_Table\n");
    for (i=0;i<OUTIndex;i++){
        printf("%d\t%d\t%s\n",output[i].line, output[i].column, 
               transToken(output[i].token));
    }
}
