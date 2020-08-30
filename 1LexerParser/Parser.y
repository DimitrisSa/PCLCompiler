{
module Parser where
import Lexer
import Prelude hiding (getChar)
import Data.Either
}

%name parse
%tokentype { Token }
%error { parseError }
%monad { Alex }
%lexer { lexwrap } { Eof }

%token
    and         { TAnd          $$ }
    array       { TArray        $$ }
    begin       { TBegin        $$ }
    boolean     { TBoolean      $$ }
    char        { TChar         $$ }
    dispose     { TDispose      $$ }
    div         { TDivInt       $$ }
    do          { TDo           $$ }
    else        { TElse         $$ }
    end         { TEnd          $$ }
    false       { TFalse        $$ }
    forward     { TForward      $$ }
    function    { TFunction     $$ }
    goto        { TGoto         $$ }
    if          { TIf           $$ }
    integer     { TInteger      $$ }
    label       { TLabel        $$ }
    mod         { TMod          $$ }
    new         { TNew          $$ }
    nil         { TNil          $$ }
    not         { TNot          $$ }
    of          { TOf           $$ }
    or          { TOr           $$ }
    procedure   { TProcedure    $$ }
    program     { TProgram      $$ }
    real        { TReal         $$ }
    result      { TResult       $$ }
    return      { TReturn       $$ }
    then        { TThen         $$ }
    true        { TTrue         $$ }
    var         { TVar          $$ }
    while       { TWhile        $$ }
    id          { TId           value posn }
    intconst    { TIntconst     value posn }
    realconst   { TRealconst    value posn }
    charconst   { TCharconst    value posn }
    stringconst { TStringconst  value posn }
    '='         { TLogiceq      $$ }
    '>'         { TGreater      $$ }
    '<'         { TSmaller      $$ }
    diff        { TDifferent    $$ }
    greq        { TGreaterequal $$ }
    smeq        { TSmallerequal $$ }
    '+'         { TAdd          $$ }
    '-'         { TMinus        $$ }
    '*'         { TMul          $$ }
    '/'         { TDivReal      $$ }
    '^'         { TPointer      $$ }
    '@'         { TAdress       $$ }
    equal       { TEq           $$ }
    ';'         { TSeperator    $$ }
    '.'         { TDot          $$ }
    '('         { TLeftparen    $$ }
    ')'         { TRightparen   $$ }
    ':'         { TUpdown       $$ }
    ','         { TComma        $$ }
    '['         { TLeftbracket  $$ }
    ']'         { TRightbracket $$ }

%left RExpr
%left LExpr
%right then else
%nonassoc '<' '>' '=' greq smeq diff
%left '+' '-' or
%left '*' '/' div mod and
%left not
%left NEG POS
%right '^'
%left '@'
%%

Program    :: { Program }
           : program id ';' Body '.'            { P (tokenToId $2) $4 }

Body       :: { Body }
           : Locals Block                       { Body $1 $2 }

Locals     :: { [Local] }
           : {-empty-}                          { []    }
           | Locals Local                       { $2:$1 }

Local      :: { Local }
           : var Variables                      { VarsWithTypeList    $2    }
           | label Ids ';'                      { Labels   $2    }
           | Header ';' Body ';'                { HeaderBody $1 $3 }
           | forward Header ';'                 { Forward $2    }

Variables  :: { [([Id],Type)] }
           : IdsAndType                         { [$1]  }
           | Variables IdsAndType               { $2:$1 }

IdsAndType :: { ([Id],Type) }
           : Ids ':' Type ';'                   { ($1,$3) }

Ids        :: { [Id] }
           : id                                 { [(tokenToId $1) ]  }
           | Ids ',' id                         { (tokenToId $3) :$1 }

Header     :: { Header }
           : procedure id '(' Args ')'          { ProcHeader (tokenToId $2)  $4    }
           | function  id '(' Args ')' ':' Type { FuncHeader  (tokenToId $2)  $4 $7 }

Args       :: { [Frml] }
           : {-empty-}                          { [] }
           | Frmls                            { $1 }

Frmls    :: { [Frml] }
           : Frml                             { [$1]  }
           | Frmls ';' Frml                 { $3:$1 }

Frml     :: { Frml }
           : Optvar Ids ':' Type                { ($1,$2,$4) }

Optvar     :: { PassBy }
Optvar     : {-empty-}                          { Value     }
           | var                                { Reference }

Type :: { Type }
     : integer                            { IntT           }
     | real                               { RealT          }
     | boolean                            { BoolT          }
     | char                               { CharT          }
     | array ArrSize of Type              { Array   $2 $4 }
     | '^' Type                           { Pointer $2    }

ArrSize :: { ArrSize }
        : {-empty-}                          { NoSize  }
        | '[' intconst ']'                   { Size (getInt $2) }

Block :: { [Stmt] }
      : begin Stmts end                    { $2 }

Stmts :: { [Stmt] }
      : Stmt                               { [$1]    }
      | Stmts ';' Stmt                     { $3 : $1 }

Stmt :: { Stmt }
     : {-empty-}                   { Empty }
     | LVal equal Expr             { Assignment (posnToLiCo $2) $1 $3}
     | Block                       { Block $1 }
     | Call                        { CallS $1 }
     | if Expr then Stmt           { IfThen (posnToLiCo $1) $2 $4 }
     | if Expr then Stmt else Stmt { IfThenElse (posnToLiCo $1) $2 $4 $6 }
     | while Expr do Stmt          { While (posnToLiCo $1) $2 $4 }
     | id ':' Stmt                 { Label (tokenToId $1) $3 }
     | goto id                     { GoTo (tokenToId $2) }
     | return                      { Return }
     | new New LVal              { New (posnToLiCo $1) $2 $3 }
     | dispose Dispose LVal      { Dispose (posnToLiCo $1) $2 $3 }

New        :: { New }
           :  {-empty-}                         { NewNoExpr   }
           | '[' Expr ']'                       { NewExpr $2 }

Dispose    : {-empty-}                          { Without }
           | '[' ']'                            { With    }

Expr       :: { Expr }
           : LVal %prec LExpr                 { LVal $1 }
           | RVal %prec RExpr                 { RVal $1 }

LVal     :: { LVal }
           : id                { IdL        (tokenToId $1)    }
           | result            { Result    (posnToLiCo $1) }
           | stringconst       { StrLiteral    (filter (/='"') $ getString $1)    }
           | LVal '[' Expr ']' { Indexing (posnToLiCo $2) $1 $3 }
           | Expr '^'          { Dereference      (posnToLiCo $2) $1    }
           | '(' LVal ')'      { ParenL     $2    }

RVal     :: { RVal }
           : intconst                           { IntR     (getInt $1) }
           | true                               { TrueR       }
           | false                              { FalseR      }
           | realconst                          { RealR    (getReal $1) }
           | charconst                          { CharR    (getChar $1) }
           | '(' RVal ')'                       { ParenR   $2 }
           | nil                                { NilR        }
           | Call                               { CallR    $1 }
           | '@' LVal                           { Papaki   $2 }
           | not  Expr                          { Not     (posnToLiCo $1) $2 }
           | '+'  Expr %prec POS                { Pos     (posnToLiCo $1) $2 }
           | '-'  Expr %prec NEG                { Neg     (posnToLiCo $1) $2 }
           | Expr '+'  Expr                     { Plus    (posnToLiCo $2) $1 $3 }
           | Expr '*'  Expr                     { Mul     (posnToLiCo $2) $1 $3 }
           | Expr '-'  Expr                     { Minus   (posnToLiCo $2) $1 $3 }
           | Expr '/'  Expr                     { RealDiv (posnToLiCo $2) $1 $3 }
           | Expr div  Expr                     { Div     (posnToLiCo $2) $1 $3 }
           | Expr mod  Expr                     { Mod     (posnToLiCo $2) $1 $3 }
           | Expr or   Expr                     { Or      (posnToLiCo $2) $1 $3 }
           | Expr and  Expr                     { And     (posnToLiCo $2) $1 $3 }
           | Expr '='  Expr                     { Eq      (posnToLiCo $2) $1 $3 }
           | Expr diff Expr                     { Diff    (posnToLiCo $2) $1 $3 }
           | Expr '<'  Expr                     { Less    (posnToLiCo $2) $1 $3 }
           | Expr '>'  Expr                     { Greater (posnToLiCo $2) $1 $3 }
           | Expr greq Expr                     { Greq    (posnToLiCo $2) $1 $3 }
           | Expr smeq Expr                     { Smeq    (posnToLiCo $2) $1 $3 }

Call       :: { (Id,[Expr]) }
           : id '(' ArgExprs ')'                { (tokenToId $1,$3) }

ArgExprs   :: { [Expr] }
           : {-empty-}                          { [] }
           | Exprs                              { $1 }

Exprs      :: { [Expr] }
           : Expr                               { [$1]  }
           | Exprs ',' Expr                     { $3:$1 }

{

parseError :: Token -> Alex a
parseError = posnParseError . posn

posnParseError (AlexPn _ li co) =
  alexError $ concat ["Parse error at line ",show li,", column ",show co]

data Program =
  P Id Body
  deriving(Show)

data Body = Body [Local] [Stmt]
  deriving(Show)

data Id        = Id {idPosn :: (Int,Int), idString:: String}
  deriving(Show)

instance Eq Id where
  x == y = idString x == idString y

instance Ord Id where
  x <= y = idString x <= idString y

data Local =
  VarsWithTypeList [([Id],Type)]    |
  Labels [Id]                       |
  HeaderBody Header Body            |
  Forward Header
  deriving(Show)

data Header = ProcHeader Id [Frml]  | FuncHeader Id [Frml] Type
  deriving(Show)

data PassBy = Value | Reference
  deriving(Show,Eq)

type Frml = (PassBy,[Id],Type)

data Type =
  Nil                |
  IntT               |
  RealT              |
  BoolT              |
  CharT              |
  Array ArrSize Type |
  Pointer Type
  deriving(Show,Eq)

data ArrSize = Size Int | NoSize
  deriving(Show,Eq)

data Stmt =
  Empty                               |
  Assignment (Int,Int) LVal Expr      |
  Block      [Stmt]                   |
  CallS      (Id,[Expr])              |
  IfThen     (Int,Int) Expr Stmt      |
  IfThenElse (Int,Int) Expr Stmt Stmt |
  While      (Int,Int) Expr Stmt      |
  Label      Id Stmt                  |
  GoTo       Id                       |
  Return                              |
  New        (Int,Int) New LVal       |
  Dispose    (Int,Int) DispType LVal
  deriving(Show)

data DispType = With | Without
  deriving(Show)

data New =
  NewNoExpr     |
  NewExpr Expr
  deriving(Show)

data Expr =
 LVal LVal |
 RVal RVal
 deriving(Show,Ord,Eq)

data LVal =
  IdL         Id                  |
  Result      (Int,Int)           |
  StrLiteral  String              |
  Indexing    (Int,Int) LVal Expr |
  Dereference (Int,Int) Expr      |
  ParenL      LVal
  deriving(Show,Ord,Eq)

data RVal =
  IntR    Int                 |
  TrueR                       |
  FalseR                      |
  RealR   Double              |
  CharR   Char                |
  ParenR  RVal                |
  NilR                        |
  CallR   (Id,[Expr])         |
  Papaki  LVal                |
  Not     (Int,Int) Expr      |
  Pos     (Int,Int) Expr      |
  Neg     (Int,Int) Expr      |
  Plus    (Int,Int) Expr Expr |
  Mul     (Int,Int) Expr Expr |
  Minus   (Int,Int) Expr Expr |
  RealDiv (Int,Int) Expr Expr |
  Div     (Int,Int) Expr Expr |
  Mod     (Int,Int) Expr Expr |
  Or      (Int,Int) Expr Expr |
  And     (Int,Int) Expr Expr |
  Eq      (Int,Int) Expr Expr |
  Diff    (Int,Int) Expr Expr |
  Less    (Int,Int) Expr Expr |
  Greater (Int,Int) Expr Expr |
  Greq    (Int,Int) Expr Expr |
  Smeq    (Int,Int) Expr Expr
  deriving(Show,Eq,Ord)

parser s = runAlex s parse
lexwrap = (alexMonadScan >>=)

tokenToId :: Token -> Id
tokenToId = \case
  TId string (AlexPn _ li co) -> Id (li,co) string
  _                           -> error "Shouldn't happen, not id token"

posnToLiCo :: AlexPosn -> (Int,Int)
posnToLiCo (AlexPn _ li co) = (li,co)
 
}
