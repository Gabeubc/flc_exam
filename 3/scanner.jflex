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

binary_interval_token_1 = (1[01] | 1([01]{2}) | 1([01]{3}) | 1([01]{4}) | 10([01]{3})0)?

token_1 = ("!"{3}|"!"{30}|"!"{300})(([a-z]{5}([a-z]{2})*)|([A-Z]{6}([A-Z]*))){binary_interval_token_1}

word_token_2 =  ( ("xx"|"xy"|"yx"|"yy"){2} | ("xx"|"xy"|"yx"|"yy"){4} | ("xx"|"xy"|"yx"|"yy"){7} )("\*"|"\$"|"%")?

token_2 = ({word_token_2}{3})({word_token_2}{2})*

june = [Jj]"une"

july = [Jj]"uly"

august = [Aa]"ugust"

september = [Ss]"eptember"

october = [Oo]"ctober"

year = ", 2018"

valid_month = ([Jj]"une"|[Jj]"July"|[Aa]"ugust"|[Ss]"eptember"|[Oo]"ctober")

valid_date_interval_1 = (
	({june} " 13")
|	({june}(1[3-9]|(2[0-9])|(3[0-1])))
|	({july} | {august} | {september}) " " ((0[1-9])|([1-2][0-9])|(3[0-1])) 
|	({october} ((0[1-9])|(1[0-9])|(2[0-3])))
) {year} 

valid_date_interval_2 = 2018 "/" ( 06"/"13
| (06"/"(1[3-9]|("2"[0-9])|(3[0-1])))
| ((07|08|09)"/"((0[1-9])|([1-2][0-9])|(3[0-1])))
| (10"/"((0[1-9])|(1[0-9])|(2[0-3])))
)

token_3 = {valid_date_interval_1} | {valid_date_interval_2}

comment = (("\$\$"|"\?\?")~"\n")

signed_integer = ("\+"|"-")?([0-9]+)

quoted_string = \"([^\"\\\n]|\\.)*\"

pos_X_Y = ("POS\."("X"|"Y"|"Z"))

stat = "AVG"|"MAX"




%%




"##"			{return new Symbol(sym.SEPARATOR);}
":"				{return new Symbol(sym.COLON);}
","				{return new Symbol(sym.COMMA);}
"-"         	{return new Symbol(sym.MINUS);}
";"				{return new Symbol(sym.SC);}
"("       	 	{ return new Symbol(sym.LPAREN); }
")"        		{ return new Symbol(sym.RPAREN); }

"DONE"			{ return new Symbol(sym.DONE); }

"DO"			{ return new Symbol(sym.DO); }

"AND"			{ return new Symbol(sym.AND); }

"POS"			{ return new Symbol(sym.POS); }

"IN_CASE"		{ return new Symbol(sym.IN_CASE); }

"LOWER"			{ return new Symbol(sym.LOWER); }

"HIGHER"		{ return new Symbol(sym.HIGHER); }

"BETWEEN"		{ return new Symbol(sym.BETWEEN); }

"COMPUTE"		{return new Symbol(sym.COMPUTE);}

"PRINT"			{return new Symbol(sym.PRINT);}

"CHANGE"		{return new Symbol(sym.CHANGE);}

"SET"			{return new Symbol(sym.SET);}

"BATTERY"		{return new Symbol(sym.BATTERY);}

{stat}			{return new Symbol(sym.STAT);}

{pos_X_Y}	{return new Symbol(sym.POS_X_Y);}

{token_1}		{return new Symbol(sym.TOKEN_1);}

{token_2}		{return new Symbol(sym.TOKEN_2);}

{token_3}		{return new Symbol(sym.TOKEN_3);}

{separator}		{return new Symbol(sym.SEPARATOR);}

{signed_integer}	{return new Symbol(sym.SIGNED_INTEGER);}

{quoted_string}	{return new Symbol(sym.QUOTED_STRING);}

{comment}		{;}



\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
