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

separator = "\$\$"

comment = "%"~"\n"

token_1_even_numbers = ("-"("124" | "12"[02] | "1"[01][02468] | [0-9][02468] | [02468]) | ([02468] | [0-7][02468] | 8[0246]))

token_1_optional_words = (([a-z]{5}([a-z])*)((([a-z]{5})([a-z])*)(([a-z]{5})([a-z])*))*)?

token_1_final_part = "ABC" | (("XX" | "XY" | "YX" | "YY"){3}("XX" | "XY" | "YX" | "YY")*)

token_1 = {token_1_even_numbers}{token_1_optional_words}{token_1_final_part}

token_2_words = ("1"[01] | "1"[01][01] | "1"[01][01][01] | "10"[01][01][01] | "1111"0)

token_2_separator = [\*-]

token_2 = ({token_2_words}{token_2_separator}{token_2_words}{token_2_separator}{token_2_words}{token_2_separator}{token_2_words}{token_2_separator}{token_2_words})({token_2_separator}{token_2_words}{token_2_separator}{token_2_words})*

token_3 = "08:12:34"
| "08:12:3"[5-9]
| "08:12:"[45][0-9]
| "09:"[0-5][0-9]":"[0-5][0-9]
| "1"[0-6]":"[0-5][0-9]":"[0-5][0-9]
| "17:"[0-1][0-9]":"[0-5][0-9]
| "17:20:"[0-5][0-9]
| "17:21:"[0-2][0-9]
| "17:21:3"[0-7]

DIGIT       = [0-9]
LETTER      = [a-zA-Z]
UNDERSCORE  = [_]
ID          = ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*

signed_integer = ([\+-]?[1-9][0-9]*) | [0]

%%

"("                       { return new Symbol(sym.LPAREN); }

")"                       { return new Symbol(sym.RPAREN); }

"{"                       { return new Symbol(sym.LBRACE); }

"}"                       { return new Symbol(sym.RBRACE); }

"="                       { return new Symbol(sym.EQ); }

"-"                       { return new Symbol(sym.MINUS); }

","                       { return new Symbol(sym.C); }

";"                       { return new Symbol(sym.SC); }

"?"                       { return new Symbol(sym.QUESION_MARK); }

":"                       { return new Symbol(sym.COLON); }

"."                       { return new Symbol(sym.DOT); }

"=="                       { return new Symbol(sym.EQUAL); }

"not"                       { return new Symbol(sym.NOT); }

"and"                      { return new Symbol(sym.AND); }

"or"                      { return new Symbol(sym.OR); }

"true"             { return new Symbol(sym.TRUE); }

"false"             { return new Symbol(sym.FALSE); }

"fuel"             { return new Symbol(sym.FUEL); }

"declare"             { return new Symbol(sym.DECLARE); }

"else"             { return new Symbol(sym.ELSE); }

"min"             { return new Symbol(sym.MIN); }

"max"             { return new Symbol(sym.MAX); }

"set"             { return new Symbol(sym.SET); }

"mv"             { return new Symbol(sym.MV); }

"position"             { return new Symbol(sym.POSITION); }

"increases"             { return new Symbol(sym.INCREASE); }

"decreases"             { return new Symbol(sym.DECREASE); }


{signed_integer}		{return new Symbol(sym.SIGNED_INTEGER, Integer.parseInt(yytext()));}

{token_1}		{return new Symbol(sym.TOKEN_1);}

{token_2}		{return new Symbol(sym.TOKEN_2);}

{token_3}		{return new Symbol(sym.TOKEN_3);}

{separator}		{return new Symbol(sym.SEPARATOR);}

{ID}		{return new Symbol(sym.ID, yytext());}

{comment}		{;}


\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
