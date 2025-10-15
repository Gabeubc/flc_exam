/**************************
 Scanner
***************************/

import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

%{
	private Symbol sym(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	
	private Symbol sym(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
	
%}

separator = "#"{2}

comment = "\/-"~"-\/"

token_1_hex = (("-"(
	("2"[0-7])
	| ("1"[0-9A-Fa-f])
	| ([0-9A-Fa-f])
))
| (
	([0-9A-Fa-f])
	| ([0-9A-Fa-f][0-9A-Fa-f])
	| ([0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])
	| ([01][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])
	| ("2"[0-4][0-9A-Fa-f][0-9A-Fa-f])
	| ("25"[0-5][0-9A-Fa-f])
	| ("256"[0-9A-Ca-c])
))

token_1_sep = "_"

token_1_word = [A-Za-z]{5}"_"?([A-Za-z]{2}"_")*

token_1_opt = ("SOS"| ("X"("Y"("Y"{2})*)?(("Z"{2})*)?)*)?

token_1 = {token_1_hex}{token_1_sep}{token_1_word}{token_1_opt}

token_2 = (
	("09:21"":12"?) ("am"|"pm")
| ("09:21"(":1"[2-9])?) ("am"|"pm")
| ("09:21"(":"[2-5][2-9])?) ("am"|"pm")
| ("09:2"[2-9](":"[0-5][0-9])?) ("am"|"pm")
| ("09:"[3-5][0-9](":"[0-5][0-9])?) ("am"|"pm")
| ("1"[0-6]":"[0-5][0-9](":"[0-5][0-9])?) ("am"|"pm")
| ("17:"[0-3][0-9](":"[0-5][0-9])?) ("am"|"pm")
| ("17:4"[0-2](":"[0-5][0-9])?) ("am"|"pm")
| ("17:43"(":"[0-2][0-9])?) ("am"|"pm")
| ("17:43"(":3"[0-4])?) ("am"|"pm")
)



token_3 = (([\$]{2} (("0"*"1""0"*"1""0"*"1""0"*) | ("0"*"1""0"*"1""0"*"1""0"*"1""0"*"1""0"*))) | ("&&" ( "XO"*"X"? | "OX"*"O"?)))


quoted_string = \"([^\"\\\n]|\\.)*\"

realNumber = ("+"|"-")?([1-9][0-9]*"."[0-9]*) | ("."[0-9]+) | (0"."[0-9]*)

unsignedint= 0 | [1-9][0-9]*

%%

"EXTRA"			{return new Symbol(sym.EXTRA);} 

"EXPENSE"			{return new Symbol(sym.EXPENSE);} 

"TIME"			{return new Symbol(sym.TIME);} 

"TO"			{return new Symbol(sym.TO);} 

"km/h"			{return new Symbol(sym.KM_H);} 

"km"			{return new Symbol(sym.KM);} 

"euro"			{return new Symbol(sym.EURO);} 

"euro/km"			{return new Symbol(sym.EURO_KM);} 

"DISC"			{return new Symbol(sym.DISC);} 

"COMPUTE"			{return new Symbol(sym.COMPUTE);} 

"%"			{return new Symbol(sym.PERCENT);} 

"-"			{return new Symbol(sym.MINUS);} 

":"			{return new Symbol(sym.COLON);} 

"->"			{return new Symbol(sym.R_ARROW);} 

","				{return new Symbol(sym.C);}

";"				{return new Symbol(sym.SC);}

{token_1}		{return new Symbol(sym.TOKEN_1);}

{token_2}		{return new Symbol(sym.TOKEN_2);}

{token_3}		{return new Symbol(sym.TOKEN_3);}

{separator}		{return new Symbol(sym.SEPARATOR);}

{quoted_string} {return new Symbol(sym.QUOTED_STRING, yytext());}

{realNumber} {return new Symbol(sym.REAL_NUMBER, Float.parseFloat(yytext()));}

{unsignedint} {return new Symbol(sym.U_INTEGER, Integer.parseInt(yytext()) );}

{comment}		{;}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
