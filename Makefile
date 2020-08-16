l = Lexer
p = Parser
lp = 1LexerParser

all: $(l) $(p)

Lexer:
	alex $(lp)/$(l).x -o $(lp)/$(l).hs

Parser:
	happy $(lp)/$(p).y -o $(lp)/$(p).hs

