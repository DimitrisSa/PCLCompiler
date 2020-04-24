{
module Lexer where
}

%wrapper "posn"

$letter    = [a-z A-Z]
@id        = $letter [$letter _]*

$digit     = 0-9
@int       = $digit+

$e         = [e E]
$sign      = [\- \+]
@power     = ($e $sign? @int)? 
@real      = @int \. @int @power  

$inCom     = [$printable $white] # \*
$comCont   = [$printable $white] # \)
@comS      = \( \*
@comment   = @comS ( $inCom | \* $comCont )* \* \)

$printChar = $printable # [\\ \' \"]
@escSeq    = \\ [n t r 0 \\ \' \"]
@char      = \' ($printChar | @escSeq) \'
@string    = \" ($printChar | @escSeq)* \"

tokens :-
  $white+               ;
  and                   { \p s -> TAnd        $ posnLC  p }
  array                 { \p s -> TArray      $ posnLC  p }
  begin                 { \p s -> TBegin      $ posnLC  p }
  boolean               { \p s -> TBoolean    $ posnLC  p }
  char                  { \p s -> TChar       $ posnLC  p }
  dispose               { \p s -> TDispose    $ posnLC  p }
  div                   { \p s -> TDivInt     $ posnLC  p }
  do                    { \p s -> TDo         $ posnLC  p }
  else                  { \p s -> TElse       $ posnLC  p }
  end                   { \p s -> TEnd        $ posnLC  p }
  false                 { \p s -> TFalse      $ posnLC  p }
  forward               { \p s -> TForward    $ posnLC  p }
  function              { \p s -> TFunction   $ posnLC  p }
  goto                  { \p s -> TGoto       $ posnLC  p }
  if                    { \p s -> TIf         $ posnLC  p }
  integer               { \p s -> TInteger    $ posnLC  p }
  label                 { \p s -> TLabel      $ posnLC  p }
  mod                   { \p s -> TMod        $ posnLC  p }
  new                   { \p s -> TNew        $ posnLC  p }
  nil                   { \p s -> TNil        $ posnLC  p }
  not                   { \p s -> TNot        $ posnLC  p }
  of                    { \p s -> TOf         $ posnLC  p }
  or                    { \p s -> TOr         $ posnLC  p }
  procedure             { \p s -> TProcedure  $ posnLC  p }
  program               { \p s -> TProgram    $ posnLC  p }
  real                  { \p s -> TReal       $ posnLC  p }
  result                { \p s -> TResult     $ posnLC  p }
  return                { \p s -> TReturn     $ posnLC  p }
  then                  { \p s -> TThen       $ posnLC  p }
  true                  { \p s -> TTrue       $ posnLC  p }
  var                   { \p s -> TVar        $ posnLC  p }
  while                 { \p s -> TWhile      $ posnLC  p }
  @id                   { \p s -> TId        $ posnALC s p }
  @int           { \p s -> TIntconst    $ posnALC (read s) p }
  @real          { \p s -> TRealconst   $ posnALC (read s) p }
  @comment       ;
  @char          { \p s -> TCharconst   $ posnALC (read s) p }
  @string        { \p s -> TStringconst $ posnALC (read s) p }
  =                     { \p s -> TLogiceq      $ posnLC p }
  >                     { \p s -> TGreater      $ posnLC p }
  \<                    { \p s -> TSmaller      $ posnLC p }
  \<>                   { \p s -> TDifferent    $ posnLC p }
  >=                    { \p s -> TGreaterequal $ posnLC p }
  \<=                   { \p s -> TSmallerequal $ posnLC p }
  \+                    { \p s -> TAdd          $ posnLC p }
  \-                    { \p s -> TMinus        $ posnLC p }
  \*                    { \p s -> TMul          $ posnLC p }
  \/                    { \p s -> TDivReal      $ posnLC p }
  \^                    { \p s -> TPointer      $ posnLC p }
  @                     { \p s -> TAdress       $ posnLC p }
  :=                    { \p s -> TEq           $ posnLC p }
  \;                    { \p s -> TSeperator    $ posnLC p }
  \.                    { \p s -> TDot          $ posnLC p }
  \(                    { \p s -> TLeftparen    $ posnLC p }
  \)                    { \p s -> TRightparen   $ posnLC p }
  :                     { \p s -> TUpdown       $ posnLC p }
  \,                    { \p s -> TComma        $ posnLC p }
  \[                    { \p s -> TLeftbracket  $ posnLC p }
  \]                    { \p s -> TRightbracket $ posnLC p }

{
data Token =
  TAnd                (Int,Int) |
  TArray              (Int,Int) |
  TBegin              (Int,Int) |
  TBoolean            (Int,Int) |
  TChar               (Int,Int) |
  TDispose            (Int,Int) |
  TDivInt             (Int,Int) |
  TDo                 (Int,Int) |
  TElse               (Int,Int) |
  TEnd                (Int,Int) |
  TFalse              (Int,Int) |
  TForward            (Int,Int) |
  TFunction           (Int,Int) |
  TGoto               (Int,Int) |
  TIf                 (Int,Int) |
  TInteger            (Int,Int) |
  TLabel              (Int,Int) |
  TMod                (Int,Int) |
  TNew                (Int,Int) |
  TNil                (Int,Int) |
  TNot                (Int,Int) |
  TOf                 (Int,Int) |
  TOr                 (Int,Int) |
  TProcedure          (Int,Int) |
  TProgram            (Int,Int) |
  TReal               (Int,Int) |
  TResult             (Int,Int) |
  TReturn             (Int,Int) |
  TThen               (Int,Int) |
  TTrue               (Int,Int) |
  TVar                (Int,Int) |
  TWhile              (Int,Int) |
  TId          (String,Int,Int) |
  TIntconst    (Int   ,Int,Int) |
  TRealconst   (Double,Int,Int) |
  TCharconst   (Char  ,Int,Int) |
  TStringconst (String,Int,Int) |
  TLogiceq            (Int,Int) |
  TGreater            (Int,Int) |
  TSmaller            (Int,Int) |
  TDifferent          (Int,Int) |
  TGreaterequal       (Int,Int) |
  TSmallerequal       (Int,Int) |
  TAdd                (Int,Int) |
  TMinus              (Int,Int) |
  TMul                (Int,Int) |
  TDivReal            (Int,Int) |
  TPointer            (Int,Int) |
  TAdress             (Int,Int) |
  TEq                 (Int,Int) |
  TSeperator          (Int,Int) |
  TDot                (Int,Int) |
  TLeftparen          (Int,Int) |
  TRightparen         (Int,Int) |
  TUpdown             (Int,Int) |
  TComma              (Int,Int) |
  TLeftbracket        (Int,Int) |
  TRightbracket       (Int,Int) 
  deriving (Eq,Show)

posnLC :: AlexPosn -> (Int,Int)
posnLC (AlexPn _ l c) = (l,c)

posnALC :: a -> AlexPosn -> (a,Int,Int)
posnALC a (AlexPn _ l c) = (a,l,c)
}
