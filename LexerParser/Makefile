all: lexer1 lexer2 parser1 parser2
 
lexer1:
	alex Lexer.x

lexer2:
	ghc Lexer.hs

parser1:
	happy -i Parser.y

parser2:
	ghc Parser.hs

clean:
	rm -f Lexer.hs Lexer.hi Lexer.o Lexer Parser.hs Parser.hi Parser.o Parser

clean_:
	rm -f Lexer.hs Lexer.hi Lexer.o Parser.hs Parser.hi Parser.o

