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

separator = "\$\$\$"

digit       = [0-9]
letter      = [a-zA-Z]
underscore  = [_]
id          = ({letter}|{underscore})({letter}|{digit}|{underscore})*

comment = "\/*"~"*\/"

token_1_start = [\*#&]{6}([\*#&]{2})*

token_1_second_word = ({letter}|{digit})*{letter}{2}

token_1_optional_end = ("-"(
	([2][024])
	| ([1][0248])
	| ([0248])
)
|( ([0248] )
| ([1-9][0248])
| ([1-9][0-9][0248])
| ([1][0][0-9][0248])
| ([1][2][0-4][0248])
| ([1][2][5][0248])))?

token_1 = {token_1_start}{token_1_second_word}{token_1_optional_end}

hex = [0-9A-Fa-f]

token_2 = ((({hex}{3}|{hex}{5})[-:]){3} | (({hex}{3}|{hex}{5})[-:]){6} | (({hex}{3}|{hex}{5})[-:]){18})({hex}{3}|{hex}{5})

token_3 = ((
	("09:31" "am"?)
	| ("09:3"[2-9] "am"?)
	| ("09:"[45][0-9] "am"?)
	| ([1][0-6]":"[0-5][0-9])
	| ([1][7]":"[0-3][0-9])
	| ([1][7]":"[4][0-6])
) | (
	 ([1][0-2]":"[0-5][0-9] "am")
	| ([0][1-4]":"[0-3][0-9] "pm")
	| ([0][5]":"[4][0-6] "pm")
))

quoted_string = \"([^\"\\\n]|\\.)*\"

realNumber = ([1-9][0-9]*"."[0-9]*) | ("."[0-9]+) | (0"."[0-9]*)


%%




"["                       { return new Symbol(sym.LBRACKET); }

"]"                       { return new Symbol(sym.RBRACKET); }

"("                       { return new Symbol(sym.LPAREN); }

")"                       { return new Symbol(sym.RPAREN); }

"="                       { return new Symbol(sym.EQ); }

"+"                       { return new Symbol(sym.PLUS); }

"/"                       { return new Symbol(sym.DIV); }

"*"                       { return new Symbol(sym.MULT); }

"-"                       { return new Symbol(sym.MINUS); }

"^"                       { return new Symbol(sym.POW); }

":"                       { return new Symbol(sym.COLON); }

","                       { return new Symbol(sym.C); }

";"                       { return new Symbol(sym.SC); }

"PRINT"                       { return new Symbol(sym.PRINT); }

"FZ"                       { return new Symbol(sym.FZ); }

"IF"                       { return new Symbol(sym.IF); }

"IN"                       { return new Symbol(sym.IN); }

"RANGE"                       { return new Symbol(sym.RANGE); }

"PATH"                       { return new Symbol(sym.PATH, yytext()); }

"MAX"                       { return new Symbol(sym.MAX, yytext()); }

{token_1}		{return new Symbol(sym.TOKEN_1);}

{token_2}		{return new Symbol(sym.TOKEN_2);}

{token_3}		{return new Symbol(sym.TOKEN_3);}

{separator}		{return new Symbol(sym.SEPARATOR);}

{realNumber}	{return new Symbol(sym.REAL_NUMBER, Float.parseFloat(yytext()));}

{quoted_string} {return new Symbol(sym.QUOTED_STRING);}

{id}		{return new Symbol(sym.ID, yytext());}

{comment}		{;}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
