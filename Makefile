c = code
l = Lexer
p = Parser
lp = $(c)/$(l)$(p)
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
	cp dist/build/PCLCompiler/PCLCompiler .

generatedByCabal = dist
dirty = $(LexerHaskellFile) $(ParserHaskellFile) $(generatedByCabal) IntermediateFiles \
				./a.out ./*.s ./*.asm ./*.ll ./*.imm

clean:
	rm -rf $(dirty) ./PCLCompiler 

distclean:
	rm -rf $(dirty)
