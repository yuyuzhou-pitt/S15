%{
#include <stdlib.h>
#include <string.h>
#include "token.h"
#define LIMIT1 1000 //total number of characters in all dictint identifier and strings
#define LIMIT2 10000 //total number of Token

extern int yycolumn, yylength, yyline, yylval;
extern char* yystring;
%}

/* regular definitions */

digit         [0-9]
consint       [0-9]+
id            [a-zA-Z][a-zA-Z0-9]*
wrongid       [0-9]+[a-zA-Z]+
delim         [ \t]
ws            {delim}+
newline       [\n]

%%
{newline}                 {yyline++; yycolumn=0;}
"/*"(.*)"*/"              {yycolumn+=yyleng;}
"/*"(.*)"\n"              {printf("Error: line %d: Unmatched comments.\n", yyline);yyline++; yycolumn=0;}
&&                        {yycolumn+=2;return(ANDnum);}
\|\|                      {yycolumn+=2;return(ORnum);}
:=                        {yycolumn+=2;return(ASSGNnum);}
declarations              {yycolumn+=12;return(DECLARATIONSnum);}
enddeclarations           {yycolumn+=15;return(ENDDECLARATIONSnum);}
int                       {yycolumn+=3;return(INTnum);}
method                    {yycolumn+=6;return(METHODnum);}
program                   {yycolumn+=7;return(PROGRAMnum);}
val                       {yycolumn+=3;return(VALnum);}
while                     {yycolumn+=5;return(WHILEnum);}
class                     {yycolumn+=5;return(CLASSnum);}
else                      {yycolumn+=4;return(ELSEnum);}
if                        {yycolumn+=2;return(IFnum);}
return                    {yycolumn+=6;return(RETURNnum);}
void                      {yycolumn+=4;return(VOIDnum);} 
[.]                       {yycolumn+=1;return(DOTnum);}
[,]                       {yycolumn+=1;return(COMMAnum);}
[;]                       {yycolumn+=1;return(SEMInum);}
==                        {yycolumn+=2;return(EQnum);}
!=                        {yycolumn+=2;return(NEnum);}
>=                        {yycolumn+=2;return(GEnum);}
\<=                       {yycolumn+=2;return(LEnum);}
[=]                       {yycolumn+=1;return(EQUALnum);}
[<]                       {yycolumn+=1;return(LTnum);}
[>]                       {yycolumn+=1;return(GTnum);}
[+]                       {yycolumn+=1;return(PLUSnum);}
[-]                       {yycolumn+=1;return(MINUSnum);}
[*]                       {yycolumn+=1;return(TIMESnum);}
[/]                       {yycolumn+=1;return(DIVIDEnum);}
[!]                       {yycolumn+=1;return(NOTnum);}
{ws}                      {yycolumn+=yyleng;}
{id}                      {yycolumn+=yyleng;yylength=yyleng;yystring=yytext;return(IDnum);}
{wrongid}                 {yycolumn+=yyleng;printf("Error: line %d: Wrong ID.\n", yyline);}
{consint}                 {yycolumn+=yyleng;return(ICONSTnum);}
[/{]                      {yycolumn+=1;return(LBRACEnum);}
[/}]                      {yycolumn+=1;return(RBRACEnum);}
[/[]                      {yycolumn+=1;return(LBRACnum);}
]                         {yycolumn+=1;return(RBRACnum);}
[(]                       {yycolumn+=1;return(LPARENnum);}
[)]                       {yycolumn+=1;return(RPARENnum);}
\'(\\.|[^\\'\n])*("\n")   { 
                          printf("Error: line %d: Uneding String.\n", yyline);
                          yyline+=1;yycolumn=0;
                          }
\'(\\.|[^\\'\n])*(\')     {
                          if ((yytext[yyleng-1] == '\\') && (yytext[yyleng] == '\'')) 
                              yymore();
                          else {
                              yycolumn+=yyleng;
                              yystring=yytext;
                              yylength=yyleng;
                              return(SCONSTnum); 
                              }
                          }
.                         {yycolumn+=yyleng;printf("Error: line %d: Wrong ID.\n", yyline);}
%%

int yyline = 0;
int yycolumn = 0;
int yylength = 0;
char *yystring = NULL;

int yywrap()
{
    return 1;
}

char StringTable[LIMIT1];// stringtable
int STIndex=0;// A pointer to next empty slot in String Table

typedef struct EasyStringTable{
    int StringType; //SCONSTnum or IDnum
    int Index_inST; // index in string table
    char *string; //String
}StringTableCB;

int stcbIndex=0;
StringTableCB st_cb[LIMIT1];

typedef struct{
    int line;
    int column;
    int token;
    int index;   
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

int updateStringTable(char *ch, int type, int len)
{
    int i= 0; int j=0;
    //case insensitive
    while (i<len){
       if (ch[i]>='A' && ch[i] <='Z') {
           ch[i]=ch[i]+'a'-'A';
       }
       i++;
    }
    //escape sequence
    if (type == SCONSTnum) {
        i = 1;  // ignore first '  
        j = 0;
        while (i < len-1){ //ignore last '
           if ((ch[i] == '\\') && (ch[i+1] == 'n'))  //handle \n
           {
              ch[j]='\n';
              i+=2;
              j++;
           }
           else if ((ch[i] == '\\') && (ch[i+1] == 't'))  //handle \t
           {
              ch[j]='\t';
              i+=2;
              j++;
           }
           else if ((ch[i] == '\\') && (ch[i+1] == '\''))  //handle \'
           {
              ch[j]='\'';
              i+=2;
              j++;
           }
           else if ((ch[i] == '\\') && (ch[i+1] == '\\'))  //handle '\\'
           {
              ch[j]='\\';
              i+=2;
              j++;
           }
           else {
               ch[j]=ch[i];
               i++;
               j++;
           }
        }
        len = j; 
    } 


    //try maching old record;
    i = 0;
    while (i<stcbIndex) {
        if ((st_cb[i].StringType == type) &&
            (strcmp(ch, st_cb[i].string) == 0))
            return(st_cb[i].Index_inST);
        i++;
    } 
    // update a new record
    st_cb[stcbIndex].StringType = type;
    st_cb[stcbIndex].Index_inST = STIndex;
    st_cb[stcbIndex].string = (char *) malloc(len);
    strcpy(st_cb[stcbIndex].string, ch);
    i = 0;
    while (i<len) {
        StringTable[STIndex] = ch[i];
        STIndex++;
        i++;
    }
    StringTable[STIndex] = ' ';
    STIndex=STIndex+1;
    stcbIndex++;
    return(st_cb[stcbIndex-1].Index_inST);
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
       output[OUTIndex].index = -1;
       if ((output[OUTIndex].token == IDnum) || (output[OUTIndex].token == SCONSTnum)) 
          output[OUTIndex].index = updateStringTable(yystring, output[OUTIndex].token, yylength);
       OUTIndex++;
    } while (lexReturn != 0);

    printf("\n%10s%10s%25s%25s\n","Line", "Column", "Token", "Index_in_String_Table");
    for (i=0;i<OUTIndex;i++){
        if (output[i].token == EOFnum)
            printf("%45s\n",transToken(output[i].token));
        else if (output[i].index == -1)
            printf("%10d%10d%25s\n",output[i].line, output[i].column, transToken(output[i].token));
       else printf("%10d%10d%25s%13d\n",output[i].line, output[i].column, transToken(output[i].token),output[i].index);
    }

    for (i=0;i<STIndex;i++){
        printf("%c", StringTable[i]);
    }
    printf("\n");

}
