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


separator = [#]{2}

comment = "\[\*\*"~"\*\*\]"

integer = ([\+-]?[1-9][0-9]*) | [0]


hex = [0-9A-Fa-f]

digit       = [0-9]
letter      = [a-zA-Z]
underscore  = [_]
id          = ({letter}|{underscore})({letter}|{digit}|{underscore})*

hex_token_1 = (
	({hex}{2})
	|({hex}{4})
	|({hex}{7})
	)

token_1_start = "X>"(
	(({hex_token_1}"#"){2}{hex_token_1})
	| (({hex_token_1}"#"){6}{hex_token_1})
	)


ip_number = (2(([0-4][0-9])|(5[0-5])))|(1[0-9][0-9])|([1-9][0-9])|([0-9])

ip = ("-"(({ip_number}"."){3}{ip_number}))?

token_1 = {token_1_start}{ip}

tokekn_2_separator = [\*\/]

token_2_odd_number = (
	("-"(
		"12"[01]
		| [1][01][13579]
		| [1-9][13579]
		| [13579]
	))
	|(
		[13579]
		| [1-9][13579]
		| [1-2][1-9][13579]
		| [3][1-6][13579]
		| [3][7][1357]
	)
)

token_2= "Y>"((({token_2_odd_number}{tokekn_2_separator}){3}{token_2_odd_number})
|(({token_2_odd_number}{tokekn_2_separator}){8}{token_2_odd_number})
|({token_2_odd_number}{tokekn_2_separator}{22}{token_2_odd_number})
)

token_3_hour = (
	("06:12:3"[89])
	| ("06:12:"[45][0-9])
	| ("06:1"[3-9]":"[0-5][0-9])
	| ("06:"[2-5][0-9]":"[0-5][0-9])
	| ("0"[7-9]":"[0-5][0-9]":"[0-5][0-9])
	| ([1][0-9]":"[0-5][0-9]":"[0-5][0-9])
	| ([2][0]":"[0-5][0-9]":"[0-5][0-9])
	| ([2][1]":"[0-2][0-9]":"[0-5][0-9])
	| ([2][1]":"[3][0]":"[0-5][0-9])
	| ([2][1]":"[3][1]":"[01][0-9])
	| ([2][1]":"[3][1]":"[2][0-6])
)

token_3 = "Z>"{token_3_hour}(("xx"|"yy"|"zz"){4}(("xx"|"yy"|"zz"){2})*)?


%%


"("                       { return new Symbol(sym.LPAREN); }

")"                       { return new Symbol(sym.RPAREN); }


";"                       { return new Symbol(sym.SC); }

// boolean expression

"!"                       { return new Symbol(sym.NOT); }

"&"                      { return new Symbol(sym.AND); }

"|"                      { return new Symbol(sym.OR); }

"T"             { return new Symbol(sym.TRUE); }

"F"             { return new Symbol(sym.FALSE); }

"if"                       { return new Symbol(sym.IF); }


"exec"                       { return new Symbol(sym.EXEC); }

"max"                       { return new Symbol(sym.MAX); }

"ass"                       { return new Symbol(sym.ASS); }

// boolean expression

{token_1}		{return new Symbol(sym.TOKEN_1);}

{token_2}		{return new Symbol(sym.TOKEN_2);}

{token_3}		{return new Symbol(sym.TOKEN_3);}

{separator}		{return new Symbol(sym.SEPARATOR);}

{integer}		{return new Symbol(sym.INTEGER, Integer.parseInt(yytext()));}

{id}		{return new Symbol(sym.ID, yytext());}

{comment}		{;}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }