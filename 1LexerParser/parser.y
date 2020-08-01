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
    and                 { TAnd          $$       }
    array               { TArray        $$       }
    begin               { TBegin        $$       }
    boolean             { TBoolean      $$       }
    char                { TChar         $$       }
    dispose             { TDispose      $$       }
    div                 { TDivInt       $$       }
    do                  { TDo           $$       }
    else                { TElse         $$       }
    end                 { TEnd          $$       }
    false               { TFalse        $$       }
    forward             { TForward      $$       }
    function            { TFunction     $$       }
    goto                { TGoto         $$       }
    if                  { TIf           $$       }
    integer             { TInteger      $$       }
    label               { TLabel        $$       }
    mod                 { TMod          $$       }
    new                 { TNew          $$       }
    nil                 { TNil          $$       }
    not                 { TNot          $$       }
    of                  { TOf           $$       }
    or                  { TOr           $$       }
    procedure           { TProcedure    $$       }
    program             { TProgram      $$       }
    real                { TReal         $$       }
    result              { TResult       $$       }
    return              { TReturn       $$       }
    then                { TThen         $$       }
    true                { TTrue         $$       }
    var                 { TVar          $$       }
    while               { TWhile        $$       }
    id                  { TId           value posn }
    intconst            { TIntconst     value posn }
    realconst           { TRealconst    value posn }
    charconst           { TCharconst    value posn }
    stringconst         { TStringconst  value posn }
    '='                 { TLogiceq      $$       }
    '>'                 { TGreater      $$       }
    '<'                 { TSmaller      $$       }
    diff                { TDifferent    $$       }
    greq                { TGreaterequal $$       }
    smeq                { TSmallerequal $$       }
    '+'                 { TAdd          $$       }
    '-'                 { TMinus        $$       }
    '*'                 { TMul          $$       }
    '/'                 { TDivReal      $$       }
    '^'                 { TPointer      $$       }
    '@'                 { TAdress       $$       }
    equal               { TEq           $$       }
    ';'                 { TSeperator    $$       }
    '.'                 { TDot          $$       }
    '('                 { TLeftparen    $$       }
    ')'                 { TRightparen   $$       }
    ':'                 { TUpdown       $$       }
    ','                 { TComma        $$       }
    '['                 { TLeftbracket  $$       }
    ']'                 { TRightbracket $$       }

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

Args       :: { Args }
           : {-empty-}                          { [] }
           | Formals                            { $1 }

Formals    :: { [Formal] }
           : Formal                             { [$1]  }
           | Formals ';' Formal                 { $3:$1 }

Formal     :: { Formal }
           : Optvar Ids ':' Type                { ($1,$2,$4) }

Optvar     :: { PassBy }
Optvar     : {-empty-}                          { Value     }
           | var                                { Reference }

Type       :: { Type }
           : integer                            { Tint           }
           | real                               { Treal          }
           | boolean                            { Tbool          }
           | char                               { Tchar          }
           | array ArrSize of Type              { ArrayT   $2 $4 }
           | '^' Type                           { PointerT $2    }

ArrSize    :: { ArrSize }
           : {-empty-}                          { NoSize  }
           | '[' intconst ']'                   { Size (getInt $2) }

Block      :: { Block }
           : begin Stmts end                    { Block $2 }

Stmts      :: { Stmts }
           : Stmt                               { [$1]    }
           | Stmts ';' Stmt                     { $3 : $1 }

Stmt       :: { Stmt }
           : {-empty-}                          { SEmpty                  }
           | LValue equal Expr                  { SEqual   (posnToIntInt $2) $1 $3          }
           | Block                              { SBlock   $1             }
           | Call                               { SCall    $1             }
           | if Expr then Stmt                  { SIT      (posnToIntInt $1) $2 $4          }
           | if Expr then Stmt else Stmt        { SITE     (posnToIntInt $1) $2 $4 $6       }
           | while Expr do Stmt                 { SWhile   (posnToIntInt $1) $2 $4          }
           | id ':' Stmt                        { SId      (tokenToId $1)  $3          }
           | goto id                            { GoToStatement    (tokenToId $2)   }
           | return                             { SReturn                 }
           | new New LValue                     { SNew     (posnToIntInt $1) $2 $3          }
           | dispose Dispose LValue             { SDispose (posnToIntInt $1) $2 $3          }

New        :: { New }
           :  {-empty-}                         { NewEmpty   }
           | '[' Expr ']'                       { NewExpr $2 }

Dispose    : {-empty-}                          { Without }
           | '[' ']'                            { With    }

Expr       :: { Expr }
           : LValue %prec LExpr                 { L $1 }
           | RValue %prec RExpr                 { R $1 }

LValue     :: { LValue }
           : id                                 { LId        (tokenToId $1)    }
           | result                             { LResult    (posnToIntInt $1) }
           | stringconst                        { LString    (getString $1)    }
           | LValue '[' Expr ']'                { LValueExpr (posnToIntInt $2) $1 $3 }
           | Expr '^'                           { LExpr      (posnToIntInt $2) $1    }
           | '(' LValue ')'                     { LParen     $2    }

RValue     :: { RValue }
           : intconst                           { RInt     (getInt $1) }
           | true                               { RTrue       }
           | false                              { RFalse      }
           | realconst                          { RReal    (getReal $1) }
           | charconst                          { RChar    (getChar $1) }
           | '(' RValue ')'                     { RParen   $2 }
           | nil                                { RNil        }
           | Call                               { RCall    $1 }
           | '@' LValue                         { RPapaki  (posnToIntInt $1) $2 }
           | not  Expr                          { RNot     (posnToIntInt $1) $2 }
           | '+'  Expr %prec POS                { RPos     (posnToIntInt $1) $2 }
           | '-'  Expr %prec NEG                { RNeg     (posnToIntInt $1) $2 }
           | Expr '+'  Expr                     { RPlus    (posnToIntInt $2) $1 $3 }
           | Expr '*'  Expr                     { RMul     (posnToIntInt $2) $1 $3 }
           | Expr '-'  Expr                     { RMinus   (posnToIntInt $2) $1 $3 }
           | Expr '/'  Expr                     { RRealDiv (posnToIntInt $2) $1 $3 }
           | Expr div  Expr                     { RDiv     (posnToIntInt $2) $1 $3 }
           | Expr mod  Expr                     { RMod     (posnToIntInt $2) $1 $3 }
           | Expr or   Expr                     { ROr      (posnToIntInt $2) $1 $3 }
           | Expr and  Expr                     { RAnd     (posnToIntInt $2) $1 $3 }
           | Expr '='  Expr                     { REq      (posnToIntInt $2) $1 $3 }
           | Expr diff Expr                     { RDiff    (posnToIntInt $2) $1 $3 }
           | Expr '<'  Expr                     { RLess    (posnToIntInt $2) $1 $3 }
           | Expr '>'  Expr                     { RGreater (posnToIntInt $2) $1 $3 }
           | Expr greq Expr                     { RGreq    (posnToIntInt $2) $1 $3 }
           | Expr smeq Expr                     { RSmeq    (posnToIntInt $2) $1 $3 }

Call       :: { Call }
           : id '(' ArgExprs ')'                { CId (tokenToId $1)  $3 }

ArgExprs   :: { Exprs }
           : {-empty-}                          { [] }
           | Exprs                              { $1 }

Exprs      :: { Exprs }
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

--instance Show Program with
--  show = \(P i b) -> concat ["P\n\n\n",show i,show b]

data Body =
  Body [Local] Block
  deriving(Show)

data Id        = Id {
    idString::String
  , idLine::Int
  , idColum::Int
  }
  deriving(Show)

instance Eq Id where
  x == y = idString x == idString y

instance Ord Id where
  x <= y = idString x <= idString y

data Local =
  VarsWithTypeList [([Id],Type)]    |
  Labels [Id]             |
  HeaderBody Header Body |
  Forward Header
  deriving(Show)

data Header =
  ProcHeader {
    pname :: Id
  , pargs :: Args
  }  |
  FuncHeader  {
    fname :: Id
  , fargs :: Args
  , fty :: Type
  }
  deriving(Show)

data PassBy =
  Value     |
  Reference
  deriving(Show,Eq)

type Formal = (PassBy,[Id],Type)
type Args   = [Formal]

data Type =
  Tnil                |
  Tint                |
  Treal               |
  Tbool               |
  Tchar               |
  ArrayT ArrSize Type |
  PointerT Type
  deriving(Show,Eq)

data ArrSize =
  Size Int |
  NoSize
  deriving(Show,Eq)

data Block =
  Block Stmts
  deriving(Show)

type Stmts = [Stmt]

data Stmt =
  SEmpty              |
  SEqual (Int,Int) LValue Expr  |
  SBlock Block        |
  SCall Call          |
  SIT  (Int,Int) Expr Stmt      |
  SITE (Int,Int) Expr Stmt Stmt |
  SWhile (Int,Int) Expr Stmt    |
  SId Id Stmt         |
  GoToStatement Id            |
  SReturn             |
  SNew (Int,Int) New LValue     |
  SDispose (Int,Int) DispType LValue
  deriving(Show)

data DispType =
  With    |
  Without
  deriving(Show)

type Exprs = [Expr]

data New =
  NewEmpty     |
  NewExpr Expr
  deriving(Show)

data Expr =
 L LValue |
 R RValue
 deriving(Show,Ord,Eq)

data LValue =
  LId Id                 |
  LResult (Int,Int)      |
  LString String         |
  LValueExpr (Int,Int) LValue Expr |
  LExpr (Int,Int) Expr             |
  LParen LValue
  deriving(Show,Ord,Eq)

data RValue =
  RInt Int           |
  RTrue              |
  RFalse             |
  RReal Double       |
  RChar Char         |
  RParen RValue      |
  RNil               |
  RCall    Call      |
  RPapaki  (Int,Int) LValue    |
  RNot     (Int,Int) Expr      |
  RPos     (Int,Int) Expr      |
  RNeg     (Int,Int) Expr      |
  RPlus    (Int,Int) Expr Expr |
  RMul     (Int,Int) Expr Expr |
  RMinus   (Int,Int) Expr Expr |
  RRealDiv (Int,Int) Expr Expr |
  RDiv     (Int,Int) Expr Expr |
  RMod     (Int,Int) Expr Expr |
  ROr      (Int,Int) Expr Expr |
  RAnd     (Int,Int) Expr Expr |
  REq      (Int,Int) Expr Expr |
  RDiff    (Int,Int) Expr Expr |
  RLess    (Int,Int) Expr Expr |
  RGreater (Int,Int) Expr Expr |
  RGreq    (Int,Int) Expr Expr |
  RSmeq    (Int,Int) Expr Expr
  deriving(Show,Eq,Ord)

data Call =
  CId Id [Expr]
  deriving(Show,Eq,Ord)

parser s = runAlex s parse
lexwrap = (alexMonadScan >>=)

tokenToId :: Token -> Id
tokenToId = \case
  TId string (AlexPn _ line column) -> Id string line column
  _   -> error "Shouldn't happen, not id token"

posnToIntInt :: AlexPosn -> (Int,Int)
posnToIntInt (AlexPn _ l c) = (l,c)

alexPosnToLine :: AlexPosn -> Int
alexPosnToLine (AlexPn _ line _) = line

alexPosnToColumn :: AlexPosn -> Int
alexPosnToColumn (AlexPn _ _ column) = column

}
