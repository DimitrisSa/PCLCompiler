{
  module Lexer (Token(..),AlexPosn(..),alexScanTokens) where
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
@comment   = @comS ( $inCom | \* $comCont )* \*+ \)

$printChar = $printable # [\\ \' \"]
@escSeq    = \\ [n t r 0 \\ \' \"]
@char      = \' ($printChar | @escSeq) \'
@string    = \" ($printChar | @escSeq)* \"

tokens :-
  $white+               ;
  and                   { \p s -> TAnd                  }
  array                 { \p s -> TArray                }
  begin                 { \p s -> TBegin                }
  boolean               { \p s -> TBoolean              }
  char                  { \p s -> TChar                 }
  dispose               { \p s -> TDispose              }
  div                   { \p s -> TDivInt               }
  do                    { \p s -> TDo                   }
  else                  { \p s -> TElse                 }
  end                   { \p s -> TEnd                  }
  false                 { \p s -> TFalse                }
  forward               { \p s -> TForward              }
  function              { \p s -> TFunction             }
  goto                  { \p s -> TGoto                 }
  if                    { \p s -> TIf                   }
  integer               { \p s -> TInteger              }
  label                 { \p s -> TLabel                }
  mod                   { \p s -> TMod                  }
  new                   { \p s -> TNew                  }
  nil                   { \p s -> TNil                  }
  not                   { \p s -> TNot                  }
  of                    { \p s -> TOf                   }
  or                    { \p s -> TOr                   }
  procedure             { \p s -> TProcedure            }
  program               { \p s -> TProgram              }
  real                  { \p s -> TReal                 }
  result                { \p s -> TResult               }
  return                { \p s -> TReturn               }
  then                  { \p s -> TThen                 }
  true                  { \p s -> TTrue                 }
  var                   { \p s -> TVar                  }
  while                 { \p s -> TWhile                }
  @id                   { \p s -> TId s                 }
  @int                  { \p s -> TIntconst    (read s) }
  @real                 { \p s -> TRealconst   (read s) }
  @comment              ;
  @char                 { \p s -> TCharconst   (read s) }
  @string               { \p s -> TStringconst (read s) }
  =                     { \p s -> TLogiceq              }
  >                     { \p s -> TGreater              }
  \<                    { \p s -> TSmaller              }
  \<>                   { \p s -> TDifferent            }
  >=                    { \p s -> TGreaterequal         }
  \<=                   { \p s -> TSmallerequal         }
  \+                    { \p s -> TAdd                  }
  \-                    { \p s -> TMinus                }
  \*                    { \p s -> TMul                  }
  \/                    { \p s -> TDivReal              }
  \^                    { \p s -> TPointer              }
  @                     { \p s -> TAdress               }
  :=                    { \p s -> TEq                   }
  \;                    { \p s -> TSeperator            }
  \.                    { \p s -> TDot                  }
  \(                    { \p s -> TLeftparen            }
  \)                    { \p s -> TRightparen           }
  :                     { \p s -> TUpdown               }
  \,                    { \p s -> TComma                }
  \[                    { \p s -> TLeftbracket          }
  \]                    { \p s -> TRightbracket         }

{
data Token =
  TAnd                |
  TArray              |
  TBegin              |
  TBoolean            |
  TChar               |
  TDispose            |
  TDivInt             |
  TDo                 |
  TElse               |
  TEnd                |
  TFalse              |
  TForward            |
  TFunction           |
  TGoto               |
  TIf                 |
  TInteger            |
  TLabel              |
  TMod                |
  TNew                |
  TNil                |
  TNot                |
  TOf                 |
  TOr                 |
  TProcedure          |
  TProgram            |
  TReal               |
  TResult             |
  TReturn             |
  TThen               |
  TTrue               |
  TVar                |
  TWhile              |
  TId String          |
  TIntconst Int       |
  TRealconst Double   |
  TCharconst  Char    |
  TStringconst String |
  TLogiceq            |
  TGreater            |
  TSmaller            |
  TDifferent          |
  TGreaterequal       |
  TSmallerequal       |
  TAdd                |
  TMinus              |
  TMul                |
  TDivReal            |
  TPointer            |
  TAdress             |
  TEq                 |
  TSeperator          |
  TDot                |
  TLeftparen          |
  TRightparen         |
  TUpdown             |
  TComma              |
  TLeftbracket        |
  TRightbracket         
  deriving (Eq,Show)

}
