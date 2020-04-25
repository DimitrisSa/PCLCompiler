sr=$(shell find '.' -name '*.hs')
l = lexer
p = parser
c = compiler
o = odir
lp = 1LexerParser

all: $(l) $(p) both

lexer:
	alex $(lp)/$(l).x -o $(o)/$(l).hs

parser:
	happy $(lp)/$(p).y -o $(o)/$(p).hs

both: $(sr)
	ghc -XFlexibleInstances -XLambdaCase -o $(c) -odir $(o) -hidir $(o) $^

clean:
	rm -f $(o)/*.o $(o)/*.hi $(o)/*.hs $(c)

clean_:
	rm -f $(o)/*.o $(o)/*.hi $(o)/*.hs 
