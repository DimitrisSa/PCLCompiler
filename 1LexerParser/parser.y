{
module Main where
import Lexer (Token(..),alexScanTokens)
}

%name parse
%tokentype { Token }
%error { parseError }

%token 
    and                 { TAnd       }
    array               { TArray     }
    begin               { TBegin     }
    boolean             { TBoolean   }
    char                { TChar      }
    dispose             { TDispose   }
    div                 { TDivInt    }
    do                  { TDo        }
    else                { TElse      }
    end                 { TEnd       }
    false               { TFalse     }
    forward             { TForward   }
    function            { TFunction  }
    goto                { TGoto      }
    if                  { TIf        }
    integer             { TInteger   }
    label               { TLabel     }
    mod                 { TMod       }
    new                 { TNew       }
    nil                 { TNil       }
    not                 { TNot       }
    of                  { TOf        }
    or                  { TOr        }
    procedure           { TProcedure }
    program             { TProgram   }
    real                { TReal      }
    result              { TResult    }
    return              { TReturn    }
    then                { TThen      }
    true                { TTrue      }
    var                 { TVar       }
    while               { TWhile     }
    id                  { TId          $$ }
    intconst            { TIntconst    $$ }
    realconst           { TRealconst   $$ }
    charconst           { TCharconst   $$ }
    stringconst         { TStringconst $$ }
    '='                 { TLogiceq      }
    '>'                 { TGreater      }
    '<'                 { TSmaller      }
    diff                { TDifferent    }
    greq                { TGreaterequal }
    smeq                { TSmallerequal }
    '+'                 { TAdd          }
    '-'                 { TMinus        }
    '*'                 { TMul          }
    '/'                 { TDivReal      }
    '^'                 { TPointer      }
    '@'                 { TAdress       }
    equal               { TEq           }
    ';'                 { TSeperator    }
    '.'                 { TDot          }
    '('                 { TLeftparen    }
    ')'                 { TRightparen   }
    ':'                 { TUpdown       }
    ','                 { TComma        }
    '['                 { TLeftbracket  }
    ']'                 { TRightbracket }

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
           : program id ';' Body '.'            { P $2 $4 }

Body       :: { Body }
           : Locals Block                       { B $1 $2 }  

Locals     :: { [Local] }
           : {-empty-}                          { []    }
           | Locals Local                       { $2:$1 }

Local      :: { Local }
           : var Variables                      { LoVar     $2    }
           | label Ids ';'                      { LoLabel   $2    }
           | Header ';' Body ';'                { LoHeadBod $1 $3 }
           | forward Header ';'                 { LoForward $2    }

Variables  :: { Variables }
           : IdsAndType                         { [$1]  }
           | Variables IdsAndType               { $2:$1 }

IdsAndType :: { (Ids,Type) }
           : Ids ':' Type ';'                   { ($1,$3) } 

Ids        :: { Ids }
           : id                                 { [$1]  }
           | Ids ',' id                         { $3:$1 }

Header     :: { Header }
           : procedure id '(' Args ')'          { Procedure $2 $4    }
           | function  id '(' Args ')' ':' Type { Function  $2 $4 $7 }

Args       :: { Args }
           : {-empty-}                          { [] }
           | Formals                            { $1 }

Formals    :: { [Formal] }
           : Formal                             { [$1]  }
           | Formals ';' Formal                 { $3:$1 }

Formal     :: { Formal }
           : Optvar Ids ':' Type                { ($2,$4) }

Optvar     : {-empty-}                          { [] }
           | var                                { [] }

Type       :: { Type }
           : integer                            { Tint           }     
           | real                               { Treal          }
           | boolean                            { Tbool          }
           | char                               { Tchar          }
           | array ArrSize of Type              { ArrayT   $2 $4 }
           | '^' Type                           { PointerT $2    }

ArrSize    :: { ArrSize }
           : {-empty-}                          { NoSize  }
           | '[' intconst ']'                   { Size $2 }

Block      :: { Block }
           : begin Stmts end                    { Bl $2 } 

Stmts      :: { Stmts }
           : Stmt                               { [$1]    }
           | Stmts ';' Stmt                     { $3 : $1 } 

Stmt       :: { Stmt }
           : {-empty-}                          { SEmpty                  } 
           | LValue equal Expr                  { SEqual   $1 $3          }
           | Block                              { SBlock   $1             }
           | Call                               { SCall    $1             }
           | if Expr then Stmt                  { SIT      $2 $4          }     
           | if Expr then Stmt else Stmt        { SITE     $2 $4 $6       }     
           | while Expr do Stmt                 { SWhile   $2 $4          }
           | id ':' Stmt                        { SId      $1 $3          }
           | goto id                            { SGoto    (tokenizer $1) }
           | return                             { SReturn                 }
           | new New LValue                     { SNew     $2 $3          }
           | dispose Dispose LValue             { SDispose $3             }

New        :: { Expr }
           :  {-empty-}                         { EEmpty }
           | '[' Expr ']'                       { $2     }

Dispose    : {-empty-}                          { [] }
           | '[' ']'                            { [] }

Expr       :: { Expr }
           : LValue %prec LExpr                 { L $1 }
           | RValue %prec RExpr                 { R $1 }

LValue     :: { LValue }
           : id                                 { LId        $1    }
           | result                             { LResult          }
           | stringconst                        { LString    $1    }
           | LValue '[' Expr ']'                { LValueExpr $1 $3 }
           | Expr '^'                           { LExpr      $1    }
           | '(' LValue ')'                     { LParen     $2    }

RValue     :: { RValue }
           : intconst                           { RInt     $1 }
           | true                               { RTrue       }
           | false                              { RFalse      } 
           | realconst                          { RReal    $1 }
           | charconst                          { RChar    $1 }
           | '(' RValue ')'                     { RParen   $2 }
           | nil                                { RNil        }
           | Call                               { RCall    $1 }
           | '@' LValue                         { RPapaki  $2 }
           | not  Expr                          { RNot     $2 }
           | '+'  Expr %prec POS                { RPos     $2 }
           | '-'  Expr %prec NEG                { RNeg     $2 }
           | Expr '+'  Expr                     { RPlus    $1 $3 }
           | Expr '*'  Expr                     { RMul     $1 $3 }
           | Expr '-'  Expr                     { RMinus   $1 $3 }
           | Expr '/'  Expr                     { RRealDiv $1 $3 }
           | Expr div  Expr                     { RDiv     $1 $3 }
           | Expr mod  Expr                     { RMod     $1 $3 }
           | Expr or   Expr                     { ROr      $1 $3 }
           | Expr and  Expr                     { RAnd     $1 $3 }
           | Expr '='  Expr                     { REq      $1 $3 }
           | Expr diff Expr                     { RDiff    $1 $3 }
           | Expr '<'  Expr                     { RLess    $1 $3 }
           | Expr '>'  Expr                     { RGreater $1 $3 }
           | Expr greq Expr                     { RGreq    $1 $3 }
           | Expr smeq Expr                     { RSmeq    $1 $3 }

Call       :: { Call }      
           : id '(' ArgExprs ')'                { CId $1 $3 }

ArgExprs   :: { Exprs }
           : {-empty-}                          { [] }
           | Exprs                              { $1 }

Exprs      :: { Exprs }
           : Expr                               { [$1]  }
           | Exprs ',' Expr                     { $3:$1 } 

{

parseError :: [Token] -> a
parseError = \_ -> error "Parse error\n"

tokenizer :: Token -> String
tokenizer = \t -> show t

data Program =
  P Id Body
  deriving(Show)

--instance Show Program with
--  show = \(P i b) -> concat ["P\n\n\n",show i,show b]

data Body =
  B [Local] Block
  deriving(Show)

type Id        = String
type Ids       = [Id]
type Variables = [(Ids,Type)]

data Local =
  LoVar Variables       |
  LoLabel Ids           |
  LoHeadBod Header Body |
  LoForward Header
  deriving(Show)

data Header =
  Procedure Id Args |
  Function  Id Args Type
  deriving(Show)

type Formal = (Ids,Type)
type Args   = [Formal]

data Type =
  Tint                | 
  Treal               |
  Tbool               |
  Tchar               |
  Tlabel              |
  Tproc Args          |
  Tfunc Args Type     |
  TFproc Args         |
  TFfunc Args Type    |
  ArrayT ArrSize Type |
  PointerT Type 
  deriving(Show,Eq)

data ArrSize =
  Size Int |
  NoSize
  deriving(Show,Eq)

data Block =
  Bl Stmts
  deriving(Show)
  
type Stmts = [Stmt]

data Stmt = 
  SEmpty              | 
  SEqual LValue Expr  |
  SBlock Block        |
  SCall Call          |
  SIT  Expr Stmt      |
  SITE Expr Stmt Stmt |
  SWhile Expr Stmt    |
  SId Id Stmt         |
  SGoto Id            |
  SReturn             |
  SNew Expr LValue    |
  SDispose LValue     |
  SElse Stmt
  deriving(Show)

type Exprs = [Expr]

data Expr =
 L LValue |
 R RValue |
 EEmpty
 deriving(Show)

data LValue =
  LId Id                 |
  LResult                |
  LString String         |
  LValueExpr LValue Expr |
  LExpr Expr             |
  LParen LValue
  deriving(Show)

data RValue =
  RInt Int           |
  RTrue              |
  RFalse             |
  RReal Double       |
  RChar Char         |
  RParen RValue      |
  RNil               |
  RCall    Call      |
  RPapaki  LValue    |
  RNot     Expr      |
  RPos     Expr      |
  RNeg     Expr      |
  RPlus    Expr Expr |
  RMul     Expr Expr |
  RMinus   Expr Expr |
  RRealDiv Expr Expr |
  RDiv     Expr Expr |
  RMod     Expr Expr |
  ROr      Expr Expr |
  RAnd     Expr Expr |
  REq      Expr Expr |
  RDiff    Expr Expr |
  RLess    Expr Expr |
  RGreater Expr Expr |
  RGreq    Expr Expr |
  RSmeq    Expr Expr
  deriving(Show)

data Call =
  CId Id [Expr]
  deriving(Show)

main = getContents >>= print . parse . alexScanTokens 
}
