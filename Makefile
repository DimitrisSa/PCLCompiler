c = app
l = Lexer
p = Parser
lp = $(c)/$(l)$(p)
LexerFile = $(lp)/$(l).x
ParserFile = $(lp)/$(p).y
LexerHaskellFile = $(lp)/$(l).hs
ParserHaskellFile = $(lp)/$(p).hs

all: $(LexerHaskellFile) $(ParserHaskellFile) Build CopyExecutable

$(LexerHaskellFile): $(LexerFile)
	alex $^ -o $@

$(ParserHaskellFile): $(ParserFile)
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
