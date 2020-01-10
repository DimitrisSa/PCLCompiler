all: lexer1 lexer2 parser1 parser2
l = lexer
p = parser
o = odir
 
lexer1:
	alex $(l).x -o $(o)/$(l).hs

lexer2:
	ghc -odir $(o) -hidir $(o) $(o)/$(l).hs

parser1:
	happy $(p).y -o $(o)/$(p).hs

parser2:
	ghc -odir $(o) -hidir $(o) $(o)/$(p).hs

clean:
	rm -f *.hi *.o $(l).hs $(p).hs Parser

clean_:
	rm -f *.hi *.o 
