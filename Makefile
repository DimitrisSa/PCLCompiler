l = Lexer
p = Parser
b = Build
lp = 1LexerParser
ce = CopyExec
all: $(l) $(p) $(b) $(ce)

Lexer:
	alex $(lp)/$(l).x -o $(lp)/$(l).hs

Parser:
	happy $(lp)/$(p).y -o $(lp)/$(p).hs

Build:
	cabal build

CopyExec:
	cp dist/build/0PCLCompiler/0PCLCompiler .

clean:
	rm -rf 1LexerParser/$(l).hs 1LexerParser/$(p).hs dist 3IntermediateFiles/* ./a.out ./0PCLCompiler ./*.s ./*.asm ./*.ll ./*.imm

distclean:
	rm -rf 1LexerParser/$(l).hs 1LexerParser/$(p).hs dist 3IntermediateFiles/* ./a.out  ./*.s ./*.asm ./*.ll ./*.imm
