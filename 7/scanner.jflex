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

comment = "\/*"~"*\/"

code_start = [xyz]{6}([xyz][xyz])*

code_optional_part = (("-" ("3B"
| "3"[13579BbDdFf]
| [0-2][13579BbDdFf])
) | ( [13579BbDdFf]
| [0-9A-Fa-f][13579BbDdFf]
| [0-9][0-9A-Fa-f][13579BbDdFf]
| [aA]([0-9]|[aA])[13579BbDdFf]
| [aA][bB][0-3]
| "aB5"
))?

code = {code_start}[\|]{code_optional_part}

hour = ( "10:11:12"
| "10:11:1"[2-9]
| "10:11:"[2-5][0-9]
| "10:1"[2-9]":"[0-5][0-9]
| "10:"[2-5][0-9]":"[0-5][0-9]
| "1"[1-4]":"[0-5][0-9]":"[0-5][0-9]
| "15:"[0-2][0-9]":"[0-5][0-9]
| "15:3"[0-5]":"[0-5][0-9]
| "15:36:"[0-3][0-9]
| "15:36:4"[0-7] )

number_separator = [\+-\.]

binary_for_number = ([01]{3}|[01]{15})

number = ({binary_for_number}{number_separator}
{binary_for_number}{number_separator}
{binary_for_number}{number_separator}
{binary_for_number})({number_separator}{binary_for_number}{number_separator}{binary_for_number})?

signed_integer = ([\+-]?[1-9][0-9]*) | [0]

DIGIT       = [0-9]
LETTER      = [a-zA-Z]
UNDERSCORE  = [_]
ID          = ({LETTER}|{UNDERSCORE})({LETTER}|{DIGIT}|{UNDERSCORE})*

attr_name = [a-z]+

quoted_string = \"([^\"\\\n]|\\.)*\"

%%

"INIT"                       { return new Symbol(sym.INIT); }

"CASE"                       { return new Symbol(sym.CASE); }

"DEFAULT"                       { return new Symbol(sym.DEFAULT); }

"WHEN"                       { return new Symbol(sym.WHEN); }

"DO"                       { return new Symbol(sym.DO); }

"DONE"                       { return new Symbol(sym.DONE); }

"PRINT"                       { return new Symbol(sym.PRINT); }

"NEXT"                       { return new Symbol(sym.NEXT); }




"("                       { return new Symbol(sym.LPAREN); }

")"                       { return new Symbol(sym.RPAREN); }

"["                       { return new Symbol(sym.LBRACKET); }

"]"                       { return new Symbol(sym.RBRACKET); }

"."                       { return new Symbol(sym.DOT); }

"="                       { return new Symbol(sym.EQ); }

"=="                       { return new Symbol(sym.EQUAL); }

"!"                       { return new Symbol(sym.NOT); }

"&&"                      { return new Symbol(sym.AND); }

"||"                      { return new Symbol(sym.OR); }

"true"             { return new Symbol(sym.TRUE); }

"false"             { return new Symbol(sym.FALSE); }

{signed_integer}		{return new Symbol(sym.SIGNED_INTEGER, Integer.parseInt(yytext()));}

","		{return new Symbol(sym.C);}

";"		{return new Symbol(sym.SC);}

{code}		{return new Symbol(sym.CODE);}

{hour}		{return new Symbol(sym.HOUR);}

{number}		{return new Symbol(sym.NUMBER);}

{separator}		{return new Symbol(sym.SEPARATOR);}

{attr_name}		{return new Symbol(sym.ATTR_NAME, yytext());}

{ID}		{return new Symbol(sym.STATE_NAME, yytext());}

{quoted_string} {return new Symbol(sym.QUOTED_STRING, yytext());}

{comment}		{;}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
