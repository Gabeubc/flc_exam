import java_cup.runtime.*;
import java.util.*;

%%

%unicode
%cup
%line
%column

%{
	private Symbol sym(int type) {
		return  new Symbol(type, yyline, yycolumn);
	}
	
	private Symbol sym(int type, Object value) {
		return  new Symbol(type, yyline, yycolumn, value);
	}
	
%}

// regex definition

quoted_string = \".*\"

separator = "+++"

comment = "[(".*")]"

token1 = "X:"("-4.4"|"-4."[0-4]|-[0-3]"."[0-9]|[0-11]"."[0-9]|12"."[0-3]|12"."3)

token2 = "Y:"("!"|"?"){5}("!"|"?")*([a-z]([a-z]{2})*)(11|10[01]|10[01][01]|1010[01]|10101)?

HEX3 = ([0-9]|[a-z]|[A-Z]){3}

HEX5 = ([0-9]|[a-z]|[A-Z]){5}

HEX3T = ((({HEX3}|{HEX5})("!"|"?")){2}({HEX3}|{HEX5}))

HEX5T = ((({HEX3}|{HEX5})("!"|"?")){3}({HEX3}|{HEX5}))

HEX7T = ((({HEX3}|{HEX5})("!"|"?")){6}({HEX3}|{HEX5}))

token3 = "Z:"({HEX3T}|{HEX5T}|{HEX7T})

idCSyle = [a-zA-Z_][a-zA-Z0-9_]*


%%

{separator}		{return sym(sym.SEP);}

{comment}			{;}


{token1}			{return sym(sym.TOKEN1);}

{token2}			{return sym(sym.TOKEN2);}

{token3}			{return  sym(sym.TOKEN3);}

"="				{return sym(sym.EQ);}

";"				{return  sym(sym.SC);}

","				{return  sym(sym.C);}

"MULTIIF"		{return  sym(sym.MULTIIF);}

"DIV"			{return  sym(sym.DIV);}

"EXP1"			{return  sym(sym.EXP1);}

"EXP2"			{return  sym(sym.EXP2);}

"EXP3"			{return  sym(sym.EXP3);}

"ELSE"			{return  sym(sym.ELSE);}

"{"				{return  sym(sym.LBRACE);}

"}"				{return  sym(sym.RBRACE);}

"print"			{return  sym(sym.PRINT);}

{quoted_string}	{return  sym(sym.QS, yytext());}

"and"			{return  sym(sym.AND);}

"or"			{return  sym(sym.OR);}

"not"			{return  sym(sym.NOT);}

"("				{return  sym(sym.LP);}

")"				{return  sym(sym.RP);}

"true"|"false"	{return sym(sym.BOOL, Boolean.valueOf(yytext()));}

{idCSyle}		{return  sym(sym.WORD, yytext());}

[ A−Za−z0 −9 ]∗ {return  sym(sym.WORD, yytext());}


\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
