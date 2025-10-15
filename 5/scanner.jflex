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


separator = "#"{3}"#"*

comment = "\/*"~"*\/"

token_1_first_part = "\?"

token_1_second_part = 0*10*10* | 0*10*10*10*10*

token_1_second_part_bis = (("xy")*"x"?) | (("yx")*"y"?) 

token_1 = {token_1_first_part} ({token_1_second_part} | {token_1_second_part_bis})

token_2_first_part = ("2017/01/18" 
| "2017/01/1"[9] 
| "2017/01/2"[0-9] 
| "2017/01/3"[0-1] 
| "2017/02/"[0-1][0-9] 
| "2017/02/2"[0-8] 
| "2017/03/"[0-2][0-9] 
| "2017/03/3"[0-1] 
| "2017/04/"[0-2][0-9] 
| "2017/04/30"
| "2017/05/"[0-2][0-9] 
| "2017/05/3"[0-1] 
| "2017/06/"[0-2][0-9] 
| "2017/06/3"[0-1] 
| "2017/07/0"[0-2] 
| "2017/07/02")

token_2_optional_part = (":"(
	"01:12"
	| "01:1"[3-9]
	| "01:"[2-5][0-9]
	| "0"[2-9]":"[0-5][0-9]
	| "10:"[0-5][0-9]
	| "11:"[0-2][0-9]
	| "11:3"[0-6]
	| "11:37"
))?



token_2 = {token_2_first_part}{token_2_optional_part}

token_3_separator = ("\/" | "\$" | "\+")

token_3_word = ("15"
| "1"(5|7|9)
| [2-9](1|3|5|7|9)
| [1-9][0-9](1|3|5|7|9)
| "1"[0-4][0-9](1|3|5|7|9)
| "15"[0-9](1|3|5|7|9)
| "15"[0-6](1|3|5|7|9)
| "157"(1|3))

token_3 = (({token_3_word} {token_3_separator}) {5} {token_3_word} )({token_3_separator}{token_3_word}{token_3_separator}{token_3_word})*

avg = "AVG"|"avg"

integer = 0 | [1-9][0-9]*

DIGIT       = [0-9]
LETTER      = [a-zA-Z]
UNDERSCORE  = [_]
ID          = ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*

temperature = "TEMPERATURE"|"temperature"

humidity = "HUMIDITY"|"humidity"

%%



"("                       { return new Symbol(sym.LPAREN); }

")"                       { return new Symbol(sym.RPAREN); }

"{"                       { return new Symbol(sym.LBRACE); }

"}"                       { return new Symbol(sym.RBRACE); }

"STORE"                       { return new Symbol(sym.STORE); }

"CASE"                       { return new Symbol(sym.CASE); }

"CONFIGURE"                       { return new Symbol(sym.CONFIGURE); }

"IS"                       { return new Symbol(sym.IS); }

"IN RANGE"                       { return new Symbol(sym.IN_RANGE); }

"EQUAL"                       { return new Symbol(sym.EQUAL); }

"="                       { return new Symbol(sym.EQ); }

"+"                       { return new Symbol(sym.PLUS); }

"/"                       { return new Symbol(sym.DIV); }

"*"                       { return new Symbol(sym.MULT); }

"-"                       { return new Symbol(sym.MINUS); }

"^"                       { return new Symbol(sym.POW); }

","                       { return new Symbol(sym.C); }

";"                       { return new Symbol(sym.SC); }

{humidity}                       { return new Symbol(sym.HUMIDITY, yytext()); }

{temperature}                      { return new Symbol(sym.TEMPERATURE, yytext()); }

{avg}		{return new Symbol(sym.AVG);}

{token_1}		{return new Symbol(sym.TOKEN_1);}

{token_2}		{return new Symbol(sym.TOKEN_2);}

{token_3}		{return new Symbol(sym.TOKEN_3);}

{integer}		{return new Symbol(sym.INTEGER, Integer.parseInt(yytext()));}


{ID}		{return new Symbol(sym.ID, yytext());}


{separator}		{return new Symbol(sym.SEPARATOR);}

{comment}		{;}


\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
