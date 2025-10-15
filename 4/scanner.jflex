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

comment = "\/*"~"*\/"

token_1_first_part = ("\*"|"#"|"&"){6}(("\*"|"#"|"&")("\*"|"#"|"&"))*

token_1_second_part = [a0-z9]*[a-z][a0-z9]*[a-z][a0-z9]*

token_1_third_part = (("-" (24 | 2[0-3] | 1[0-9] | [0-9]))|([0-9] | [1-9][0-9] | [1-9][0-9][0-9] | 1[0-1][0-9][0-9] | 12[0-4][0-9] | 125[0-8]))?

token_1 =  {token_1_first_part}{token_1_second_part}{token_1_third_part}

token_2_base_hex = (([0-9A-Fa-f]){3}|([0-9A-Fa-f]){5})

token_2 = ((({token_2_base_hex}("-"|":")){3})|(({token_2_base_hex}("-"|":")){6})|(({token_2_base_hex}("-"|":")){18})){token_2_base_hex}

token_3_std_format = "09:31"
| ("09:3"[2-9])
| ("09:"[4-5][0-9])
| ((10|11|12|13|14|15|16)":"[0-5][0-9])
| ("17:"[0-4][0-6])

token_3_hours_format = "09:31" ("am")
| ("09:3"[2-9] ("am"))
| ("09:"[4-5][0-9] ("am"))
| ((10|11|12)":"[0-5][0-9] ("am"))
| ("0"[1-4]":"[0-5][0-9] ("pm"))
| ("05:"[0-4][0-6] ("pm"))


token_3 = {token_3_hours_format} | {token_3_std_format};

underscore = "_"

DIGIT       = [0-9]
LETTER      = [a-zA-Z]
UNDERSCORE  = [_]
id          = ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*

operation = "PATH"|"MAX"

quoted_string = \"([^\"\\\n]|\\.)*\"

realNumber = ("+"|"-")?([1-9][0-9]*"."[0-9]*) | ("."[0-9]+) | (0"."[0-9]*)

%%


"+"            {return new Symbol(sym.PLUS);}

"-"             {return new Symbol(sym.MINUS);}

"*"             {return new Symbol(sym.MULTIPLY);}

"/"            	{return new Symbol(sym.DIVIDE);}

";"				{return new Symbol(sym.SC);}

"="             {return new Symbol(sym.EQ);}

"FZ"            {return new Symbol(sym.FZ);}

"IF"            {return new Symbol(sym.IF);}

"IN"            {return new Symbol(sym.IN);}

"RANGE"         {return new Symbol(sym.RANGE);}

"PRINT"         {return new Symbol(sym.PRINT);}

"("             {return new Symbol(sym.LPAREN);}

")"             {return new Symbol(sym.RPAREN);}

"["             {return new Symbol(sym.LBRACKET);}

"]"             {return new Symbol(sym.RBRACKET);}

","             {return new Symbol(sym.COMMA);}

{token_1}		{return new Symbol(sym.TOKEN_1);}

{token_2}		{return new Symbol(sym.TOKEN_2);}

{token_3}		{return new Symbol(sym.TOKEN_3);}

{id}			{return new Symbol(sym.ID);}

{operation}		{return new Symbol(sym.OPERATION);}

{quoted_string} {return new Symbol(sym.QUOTED_STRING);}

{realNumber}	{return new Symbol(sym.REAL_NUMBER);}

{separator}		{return new Symbol(sym.SEPARATOR);}

{comment}		{;}



\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
