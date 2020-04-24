{
module Lexer where
}

%wrapper "basic"

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
  and                   { \s -> TAnd                   }
  array                 { \s -> TArray                 }
  begin                 { \s -> TBegin                 }
  boolean               { \s -> TBoolean               }
  char                  { \s -> TChar                  }
  dispose               { \s -> TDispose               }
  div                   { \s -> TDivInt                }
  do                    { \s -> TDo                    }
  else                  { \s -> TElse                  }
  end                   { \s -> TEnd                   }
  false                 { \s -> TFalse                 }
  forward               { \s -> TForward               }
  function              { \s -> TFunction              }
  goto                  { \s -> TGoto                  }
  if                    { \s -> TIf                    }
  integer               { \s -> TInteger               }
  label                 { \s -> TLabel                 }
  mod                   { \s -> TMod                   }
  new                   { \s -> TNew                   }
  nil                   { \s -> TNil                   }
  not                   { \s -> TNot                   }
  of                    { \s -> TOf                    }
  or                    { \s -> TOr                    }
  procedure             { \s -> TProcedure             }
  program               { \s -> TProgram               }
  real                  { \s -> TReal                  }
  result                { \s -> TResult                }
  return                { \s -> TReturn                }
  then                  { \s -> TThen                  }
  true                  { \s -> TTrue                  }
  var                   { \s -> TVar                   }
  while                 { \s -> TWhile                 }
  @id                   { \s -> TId s                  }
  @int                  { \s -> TIntconst    (read s) }
  @real                 { \s -> TRealconst   (read s) }
  @comment              ;
  @char                 { \s -> TCharconst   (read s) }
  @string               { \s -> TStringconst (read s) }
  =                     { \s -> TLogiceq               }
  >                     { \s -> TGreater               }
  \<                    { \s -> TSmaller               }
  \<>                   { \s -> TDifferent             }
  >=                    { \s -> TGreaterequal          }
  \<=                   { \s -> TSmallerequal          }
  \+                    { \s -> TAdd                   }
  \-                    { \s -> TMinus                 }
  \*                    { \s -> TMul                   }
  \/                    { \s -> TDivReal               }
  \^                    { \s -> TPointer               }
  @                     { \s -> TAdress                }
  :=                    { \s -> TEq                    }
  \;                    { \s -> TSeperator             }
  \.                    { \s -> TDot                   }
  \(                    { \s -> TLeftparen             }
  \)                    { \s -> TRightparen            }
  :                     { \s -> TUpdown                }
  \,                    { \s -> TComma                 }
  \[                    { \s -> TLeftbracket           }
  \]                    { \s -> TRightbracket          }

{
data Token =
  TAnd                 |
  TArray               |
  TBegin               |
  TBoolean             |
  TChar                |
  TDispose             |
  TDivInt              |
  TDo                  |
  TElse                |
  TEnd                 |
  TFalse               |
  TForward             |
  TFunction            |
  TGoto                |
  TIf                  |
  TInteger             |
  TLabel               |
  TMod                 |
  TNew                 |
  TNil                 |
  TNot                 |
  TOf                  |
  TOr                  |
  TProcedure           |
  TProgram             |
  TReal                |
  TResult              |
  TReturn              |
  TThen                |
  TTrue                |
  TVar                 |
  TWhile               |
  TId String           |
  TIntconst    Int    |
  TRealconst   Double |
  TCharconst   Char   |
  TStringconst String |
  TLogiceq             |
  TGreater             |
  TSmaller             |
  TDifferent           |
  TGreaterequal        |
  TSmallerequal        |
  TAdd                 |
  TMinus               |
  TMul                 |
  TDivReal             |
  TPointer             |
  TAdress              |
  TEq                  |
  TSeperator           |
  TDot                 |
  TLeftparen           |
  TRightparen          |
  TUpdown              |
  TComma               |
  TLeftbracket         |
  TRightbracket        
  deriving (Eq,Show)
}
