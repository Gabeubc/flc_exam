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

separator = "##"
comment = "\/-"~"-\/"

HEX = "-"( 2[0-7] | 1[0-9A-Fa-f] ) | [0-9A-Fa-f] | [0-9A-Fa-f][0-9A-Fa-f] | [0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f] | 1[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f] | 2[0-4][0-9A-Fa-f][0-9A-Fa-f] | 25[0-6][0-9A-Ca-c]

UNDERSCORE  = "_"

LETTERS      = [a-zA-Z]{5}([a-zA-Z][a-zA-Z])*

END_token_1 = ("SOS"|("X"Y(YY)*(ZZ)*"X"))?

token_1 = {HEX} {UNDERSCORE} {LETTERS} {UNDERSCORE} {END_token_1}

token_2 = 09:21:12 (am|pm)? |
09:21(:1[2-9])?(am|pm)? |
09:21(:[2-5][0-9])?(am|pm)? |
09:2[2-9](:[2-5][0-9])?(am|pm)? |
09:[3-9][0-9](:[2-5][0-9])?(am|pm)? |
1[0-2]:[0-5][0-9](:[2-5][0-9])?(am|pm)?  |
1[3-6]:[0-5][0-9](:[2-5][0-9])? |
17:[0-3][0-9](:[2-5][0-9])? |
17:4[0-2](:[2-5][0-9])? |
17:43(:[0-2][0-9])? |
17:43(:3[0-3])? |
17:43:34

token_3 = "\$\$"((0*10*10*10*10*10*)|(0*10*10*10*))|(&&)(XO?|OX?)* // binary string that contains at least 5 '1'

word = [aA-zZ]+

num = [0-9]{1,3}

quoted_string = \"([^\"\\\n]|\\.)*\"

type = ("TIME"|"EXPENSE")("EXTRA"[0-9]+"."[0-9]{0,2})?

real_number = [0-9]+"."[0-9]{0,2}

%%


"##"			{return new Symbol(sym.SEPARATOR);}
":"				{return new Symbol(sym.COLON);}
","				{return new Symbol(sym.COMMA);}
"-"         	{return new Symbol(sym.MINUS);}
";"				{return new Symbol(sym.SC);}
"COMPUTE"		{return new Symbol(sym.COMPUTE);}
"km/h"			{return new Symbol(sym.KM_H);}
"km"			{return new Symbol(sym.KM);}
"TO"			{return new Symbol(sym.TO);}
"->" 			{return new Symbol(sym.DIR);}
"euro/km"		{return new Symbol(sym.EUR_KM);}
"DISC"			{return new Symbol(sym.DISC);}
"euro"			{return new Symbol(sym.EUR);}
"%"				{return new Symbol(sym.PERCENT);}
{num}			{return new Symbol(sym.NUMBER);}
{token_1}		{return new Symbol(sym.TOKEN_1);}
{token_2}		{return new Symbol(sym.TOKEN_2);}
{token_3}		{return new Symbol(sym.TOKEN_3);}
{comment}		{;}
{real_number}	{return new Symbol(sym.REAL_NUMBER);}
{quoted_string}	{return new Symbol(sym.QUOTED_STRING);}
{separator}		{return new Symbol(sym.SEPARATOR);}
{type}			{return new Symbol(sym.TYPE);}
{word}			{return new Symbol(sym.WORD);}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
