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

executableHugePath1 = dist-newstyle/build/x86_64-linux/ghc-8.0.2/PCLCompiler-0.1.0.0/x/
executableHugePath2 = PCLCompiler/build/PCLCompiler/PCLCompiler
executableHugePath = $(executableHugePath1)$(executableHugePath2)

CopyExecutable:
	cp $(executableHugePath) .

generatedByCabal = dist-newstyle

dirty = $(LexerHaskellFile) $(ParserHaskellFile) $(generatedByCabal) IntermediateFiles \
				./a.out ./*.s ./*.asm ./*.ll ./*.imm

clean:
	rm -rf $(dirty) ./PCLCompiler 

distclean:
	rm -rf $(dirty)
