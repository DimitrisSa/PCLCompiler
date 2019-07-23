{
  module Main where
}

%wrapper "basic"

$digit  = 0-9
$letter = [a-zA-Z]
$incomment = $printable # [\*]
$commentcont = $printable # [\)]
$escapesequence = [ntr0\\\'\"]
$notsafe = [\\\'\"]
@id =$letter [$letter \_]*
@intconst = $digit+
@realconst =  $digit+\.$digit+
           |  $digit+\.$digit+e$digit+
           |  $digit+\.$digit+E$digit+
           |  $digit+\.$digit+e\+$digit+
           |  $digit+\.$digit+E\+$digit+
           |  $digit+\.$digit+e\-$digit+
           |  $digit+\.$digit+E\-$digit+
@comment = \(\*($incomment*(\*$commentcont)?)*(\*)+\)
@charconst = \'([$printable # $notsafe] | \\$escapesequence)\'
@stringconst = \"([$printable # [\"]] | \\$escapesequence)*\"

tokens :-
  $white+                   ;
  and                       { \s -> TAnd  }
  array                     {\s->TArray}
  begin                     {\s->TBegin}
  boolean                   {\s->TBoolean}
  char                      {\s->TChar}
  dispose               {\s->TDispose}
  div                   {\s->TDivInt}
  do                    {\s->TDo}
  else                  {\s->TElse}
  end                   {\s->TEnd}
  false                 {\s->TFalse}
  forward               {\s->TForward}
  function              {\s->TFunction}
  goto                  {\s->TGoto}
  if                    {\s->TIf}
  integer               {\s->TInteger}
  label                 {\s->TLabel}
  mod                   {\s->TMod}
  new                   {\s->TNew}
  nil                   {\s->TNil}
  not                   {\s->TNot}
  of                    {\s->TOf}
  or                    {\s->TOr}
  procedure             {\s->TProcedure}
  program               {\s->TProgram}
  real                  {\s->TReal}
  result                {\s->TResult}
  return                {\s->TReturn}
  then                  {\s->TThen}
  true                  {\s->TTrue}
  var                   {\s->TVar}
  while                 {\s->TWhile}
  @id                       { \s -> TId s }
  @intconst                 { \s -> TIntconst (read s)}
  @realconst                {\s->TRealconst s}
  @comment                  ;
  @charconst            {\s -> TCharconst (read s)}
  @stringconst              { \s -> TStringconst s}
  \=                    {\s->TLogiceq}
  \>                    {\s->TGreater}
  \<                    {\s->TSmaller}
  \<\>                  {\s->TDifferent}
  \>\=                  {\s->TGreaterequal}
  \<\=                  {\s->TSmallerequal}
  \+                    {\s->TAdd}
  \-                    {\s->TMinus}
  \*                    {\s->TMul}
  \/                    {\s->TDivReal}
  \^                    {\s->TPointer}
  \@                    {\s->TAdress}
  \:\=                  {\s->TEq}
  \;                    {\s->TSeperator}
  \.                    {\s->TDot}
  \(                    {\s->TLeftparen}
  \)                    {\s->TRightparen}
  \:                    {\s->TUpdown}
  \,                    {\s->TComma}
  \[                    {\s->TLeftbracket}
  \]                    {\s->TRightbracket}
  .                         { \s -> Error }

{
data Token =
  TAnd        |
  TArray    |
  TBegin    |
  TBoolean    |
  TChar   |
  TDispose    |
  TDivInt    |
  TDo   |
  TElse   |
  TEnd    |
  TFalse    |
  TForward    |
  TFunction   |
  TGoto   |
  TIf   |
  TInteger    |
  TLabel    |
  TMod    |
  TNew    |
  TNil    |
  TNot    |
  TOf   |
  TOr   |
  TProcedure    |
  TProgram    |
  TReal   |
  TResult   |
  TReturn   |
  TThen   |
  TTrue   |
  TVar    |
  TWhile    |
  TId String  |
  TIntconst Int |
  TRealconst String |
  TCharconst  Char  |
  TStringconst String |
  TLogiceq  |
  TGreater  |
  TSmaller  |
  TDifferent  |
  TGreaterequal |
  TSmallerequal |
  TAdd          |
  TMinus        |
  TMul          |
  TDivReal      |
  TPointer      |
  TAdress       |
  TEq           |
  TSeperator    |
  TDot          |
  TLeftparen    |
  TRightparen   |
  TUpdown       |
  TComma        |
  TLeftbracket  |
  TRightbracket |
  Error
  deriving (Eq,Show)

main = do
  s <- getContents
  print (alexScanTokens s)
}
