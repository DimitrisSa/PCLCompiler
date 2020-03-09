sr=$(shell find '.' -name '*.hs')
l = lexer
p = parser
o = odir

all: $(l) $(p) both

lexer:
	alex $(l).x -o $(o)/$(l).hs

parser:
	happy $(p).y -o $(o)/$(p).hs

both: $(sr)
	ghc -XFlexibleInstances -XLambdaCase -o $(p) -odir $(o) -hidir $(o) $^

clean:
	rm -f $(o)/* $(p)

clean_:
	rm -f $(o)/* 
