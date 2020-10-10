{
module Lexer where
}

%wrapper "monad"

$letter    = [a-z A-Z]
$digit     = 0-9

@int       = $digit+
@id        = $letter [$letter _ $digit]*

$e         = [e E]
$sign      = [\- \+]
@power     = ($e $sign? @int)? 
@real      = @int \. @int @power  

$inCommment = [$printable $white] # \*
$afterStar  = $inCommment # \)
@comment    = \( \* ( $inCommment | (\*)* $afterStar)* (\*)+ \)

$printChar = $printable # [\\ \' \"]
@escSeq    = \\ [n t r 0 \\ \' \"]
@char      = \' ($printChar | @escSeq) \'
@string    = \" ($printChar | @escSeq)* \"

tokens :-
  $white+               ;
  and                   { \(p,_,_,_) _ -> return $ TAnd           p }
  array                 { \(p,_,_,_) _ -> return $ TArray         p }
  begin                 { \(p,_,_,_) _ -> return $ TBegin         p }
  boolean               { \(p,_,_,_) _ -> return $ TBoolean       p }
  char                  { \(p,_,_,_) _ -> return $ TChar          p }
  dispose               { \(p,_,_,_) _ -> return $ TDispose       p }
  div                   { \(p,_,_,_) _ -> return $ TDivInt        p }
  do                    { \(p,_,_,_) _ -> return $ TDo            p }
  else                  { \(p,_,_,_) _ -> return $ TElse          p }
  end                   { \(p,_,_,_) _ -> return $ TEnd           p }
  false                 { \(p,_,_,_) _ -> return $ TFalse         p }
  forward               { \(p,_,_,_) _ -> return $ TForward       p }
  function              { \(p,_,_,_) _ -> return $ TFunction      p }
  goto                  { \(p,_,_,_) _ -> return $ TGoto          p }
  if                    { \(p,_,_,_) _ -> return $ TIf            p }
  integer               { \(p,_,_,_) _ -> return $ TInteger       p }
  label                 { \(p,_,_,_) _ -> return $ TLabel         p }
  mod                   { \(p,_,_,_) _ -> return $ TMod           p }
  new                   { \(p,_,_,_) _ -> return $ TNew           p }
  nil                   { \(p,_,_,_) _ -> return $ TNil           p }
  not                   { \(p,_,_,_) _ -> return $ TNot           p }
  of                    { \(p,_,_,_) _ -> return $ TOf            p }
  or                    { \(p,_,_,_) _ -> return $ TOr            p }
  procedure             { \(p,_,_,_) _ -> return $ TProcedure     p }
  program               { \(p,_,_,_) _ -> return $ TProgram       p }
  real                  { \(p,_,_,_) _ -> return $ TReal          p }
  result                { \(p,_,_,_) _ -> return $ TResult        p }
  return                { \(p,_,_,_) _ -> return $ TReturn        p }
  then                  { \(p,_,_,_) _ -> return $ TThen          p }
  true                  { \(p,_,_,_) _ -> return $ TTrue          p }
  var                   { \(p,_,_,_) _ -> return $ TVar           p }
  while                 { \(p,_,_,_) _ -> return $ TWhile         p }
  @id                   { \(p,_,_,s) l -> return $ TId            (take l s) p }
  @int                  { \(p,_,_,s) l -> return $ TIntconst      (read $ take l s) p }
  @real                 { \(p,_,_,s) l -> return $ TRealconst     (read $ take l s) p }
  @comment              ;
  @char                 { \(p,_,_,s) l -> return $ TCharconst     (read $ take l s) p }
  @string               { \(p,_,_,s) l ->
                                return $ TStringconst (correctStrLit $ take l s) p }
  =                     { \(p,_,_,_) _ -> return $ TLogiceq       p }
  >                     { \(p,_,_,_) _ -> return $ TGreater       p }
  \<                    { \(p,_,_,_) _ -> return $ TSmaller       p }
  \<>                   { \(p,_,_,_) _ -> return $ TDifferent     p }
  >=                    { \(p,_,_,_) _ -> return $ TGreaterequal  p }
  \<=                   { \(p,_,_,_) _ -> return $ TSmallerequal  p }
  \+                    { \(p,_,_,_) _ -> return $ TAdd           p }
  \-                    { \(p,_,_,_) _ -> return $ TMinus         p }
  \*                    { \(p,_,_,_) _ -> return $ TMul           p }
  \/                    { \(p,_,_,_) _ -> return $ TDivReal       p }
  \^                    { \(p,_,_,_) _ -> return $ TPointer       p }
  @                     { \(p,_,_,_) _ -> return $ TAdress        p }
  :=                    { \(p,_,_,_) _ -> return $ TEq            p }
  \;                    { \(p,_,_,_) _ -> return $ TSeperator     p }
  \.                    { \(p,_,_,_) _ -> return $ TDot           p }
  \(                    { \(p,_,_,_) _ -> return $ TLeftparen     p }
  \)                    { \(p,_,_,_) _ -> return $ TRightparen    p }
  :                     { \(p,_,_,_) _ -> return $ TUpdown        p }
  \,                    { \(p,_,_,_) _ -> return $ TComma         p }
  \[                    { \(p,_,_,_) _ -> return $ TLeftbracket   p }
  \]                    { \(p,_,_,_) _ -> return $ TRightbracket  p }

{
data Token =
  TAnd                {posn :: AlexPosn} |
  TArray              {posn :: AlexPosn} |
  TBegin              {posn :: AlexPosn} |
  TBoolean            {posn :: AlexPosn} |
  TChar               {posn :: AlexPosn} |
  TDispose            {posn :: AlexPosn} |
  TDivInt             {posn :: AlexPosn} |
  TDo                 {posn :: AlexPosn} |
  TElse               {posn :: AlexPosn} |
  TEnd                {posn :: AlexPosn} |
  TFalse              {posn :: AlexPosn} |
  TForward            {posn :: AlexPosn} |
  TFunction           {posn :: AlexPosn} |
  TGoto               {posn :: AlexPosn} |
  TIf                 {posn :: AlexPosn} |
  TInteger            {posn :: AlexPosn} |
  TLabel              {posn :: AlexPosn} |
  TMod                {posn :: AlexPosn} |
  TNew                {posn :: AlexPosn} |
  TNil                {posn :: AlexPosn} |
  TNot                {posn :: AlexPosn} |
  TOf                 {posn :: AlexPosn} |
  TOr                 {posn :: AlexPosn} |
  TProcedure          {posn :: AlexPosn} |
  TProgram            {posn :: AlexPosn} |
  TReal               {posn :: AlexPosn} |
  TResult             {posn :: AlexPosn} |
  TReturn             {posn :: AlexPosn} |
  TThen               {posn :: AlexPosn} |
  TTrue               {posn :: AlexPosn} |
  TVar                {posn :: AlexPosn} |
  TWhile              {posn :: AlexPosn} |
  TId          {getId    ::String,posn :: AlexPosn} |
  TIntconst    {getInt   ::Int   ,posn :: AlexPosn} |
  TRealconst   {getReal  ::Double,posn :: AlexPosn} |
  TCharconst   {getChar  ::Char  ,posn :: AlexPosn} |
  TStringconst {getString::String,posn :: AlexPosn} |
  TLogiceq            {posn :: AlexPosn} |
  TGreater            {posn :: AlexPosn} |
  TSmaller            {posn :: AlexPosn} |
  TDifferent          {posn :: AlexPosn} |
  TGreaterequal       {posn :: AlexPosn} |
  TSmallerequal       {posn :: AlexPosn} |
  TAdd                {posn :: AlexPosn} |
  TMinus              {posn :: AlexPosn} |
  TMul                {posn :: AlexPosn} |
  TDivReal            {posn :: AlexPosn} |
  TPointer            {posn :: AlexPosn} |
  TAdress             {posn :: AlexPosn} |
  TEq                 {posn :: AlexPosn} |
  TSeperator          {posn :: AlexPosn} |
  TDot                {posn :: AlexPosn} |
  TLeftparen          {posn :: AlexPosn} |
  TRightparen         {posn :: AlexPosn} |
  TUpdown             {posn :: AlexPosn} |
  TComma              {posn :: AlexPosn} |
  TLeftbracket        {posn :: AlexPosn} |
  TRightbracket       {posn :: AlexPosn} |
  Eof
  deriving (Eq,Show)

alexEOF :: Alex Token
alexEOF = return Eof

correctStrLit :: String -> String
correctStrLit (c1:c2:str) = case c1 of
  '\\' -> case c2 of
    'n'  -> '\n' : correctStrLit str
    't'  -> '\t' : correctStrLit str
    'r'  -> '\r' : correctStrLit str
    '0'  -> '\0' : correctStrLit str
    '\\' -> '\\' : correctStrLit str
    '\'' -> '\'' : correctStrLit str
    '\"' -> '\"' : correctStrLit str
  _    -> c1 : correctStrLit (c2:str)

correctStrLit s = s

}
