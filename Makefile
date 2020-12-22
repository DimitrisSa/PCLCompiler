l = Lexer
p = Parser
lp = $(l)$(p)
LexerHaskellFile = $(lp)/$(l).hs
ParserHaskellFile = $(lp)/$(p).hs

all: $(LexerHaskellFile) $(ParserHaskellFile) Build CopyExecutable

$(lp)/$(l).hs: $(lp)/$(l).x
	alex $^ -o $@

$(lp)/$(p).hs: $(lp)/$(p).y
	happy $^ -o $@

Build:
	cabal build

CopyExecutable:
	cp dist/build/0PCLCompiler/0PCLCompiler .

generatedByCabal = dist
dirty = $(LexerHaskellFile) $(ParserHaskellFile) $(generatedByCabal) IntermediateFiles \
				./a.out ./*.s ./*.asm ./*.ll ./*.imm

clean:
	rm -rf $(dirty) ./0PCLCompiler 

distclean:
	rm -rf $(dirty)
