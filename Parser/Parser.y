{
  import Lexer
  module Main where
}

%name calc
%tokentype { Token }
%error { parseError }

%token 
    and                 { TAnd }
    array               { TArray }
    begin               { TBegin }
    boolean             { TBoolean }
    char                { TChar }
    dispose             { TDispose }
    div                 { TDivInt }
    do                  { TDo }
    else                { TElse }
    end                 { TEnd }
    false               { TFalse }
    forward             { TForward }
    function            { TFunction }
    goto                { TGoto }
    if                  { TIf }
    integer             { TInteger }
    label               { TLabel }
    mod                 { TMod }
    new                 { TNew }
    nil                 { TNil }
    not                 { TNot }
    of                  { TOf }
    or                  { TOr }
    procedure           { TProcedure }
    program             { TProgram }
    real                { TReal }
    result              { TResult }
    return              { TReturn }
    then                { TThen }
    true                { TTrue }
    var                 { TVar }
    while               { TWhile }
    id                  { TId $$ }
    intconst            { TIntconst $$ }
    realconst           { TRealconst $$ }
    charconst           { TCharconst $$ }
    stringconst         { TStringconst $$ }
    '='                 { TLogiceq }
    '>'                 { TGreater }
    '<'                 { TSmaller }
    diff                { TDifferent }
    greq                { TGreaterequal }
    smeq                { TSmallerequal }
    '+'                 { TAdd }
    '-'                 { TMinus }
    '*'                 { TMul }
    '/'                 { TDivReal }
    '^'                 { TPointer }
    '@'                 { TAdress }
    equal               { TEq }
    ';'                 { TSeperator }
    '.'                 { TDot }
    '('                 { TLeftparen }
    ')'                 { TRightparen }
    ':'                 { TUpdown }
    ','                 { TComma }
    '['                 { TLeftbracket }
    ']'                 { TRightbracket }

%nonassoc '<' '>' '=' greq smeq diff
%left '+' '-' or
%left '*' '/' div mod and
%left not
%left NEG POS
%right '^'
%left '@'
%%

Program : program id ';' Body '.'                     { P $2 $4 }

Body : Bodyrec Block                                  { B $1 $2 }  

Bodyrec : Bodyrec Local                               { $2 : $1 }
        | {-empty-}                                   { [] }

Local : var Variables                                 { LoVar $2 }
      | label id Labels ';'                           { LoLabel ($2 : $3) }
      | Header ';' Body ';'                           { LoHeadBod $1 $3 }
      | forward Header ';'                            { LoForward $2 }

Variables : Variables id Morevariables ':' Type ';'   { (($5,$2 : $3) : $1) }
          | id Morevariables ':' Type ';'             { [($4,$1 : $2)] }

Morevariables : Morevariables ',' id                  { $3 : $1 }
              | {-empty-}                             { [] }

Labels : Labels ',' id                                { $3 : $1 }
       | {-empty-}                                    { [] }

Header : procedure id '(' Arguments1 ')'               { Procedure $2 $4 } 
       | function id '(' Arguments1 ')' ':' Type       { Function $2 $4 $7 }

Arguments1 : {-empty-}                                { [] }
           | Arguments2                               { $1 }

Arguments2 : Arguments2 ';' Formal                    { $3 : $1 }
           | Formal                                   { $1 }

Formal : Vars id Labels ':' Type                      { ($5,$2:$3) }
 
Vars : {-empty-}                                      { [] }
     | var                                            { [] }

Type : integer                                        { Tint }     
     | real                                           { Treal }
     | boolean                                        { Tbool }
     | char                                           { Tchar }
     | array Array of Type                            { ArrayT $4 }
     | '^' Type                                       { PointerT $2 }

Array : '[' intconst ']'                              { [] }
      | {-empty-}                                     { [] }

Block : begin Stmt Stmts end                          { Block ($2:$3) } 

Stmts : Stmts ';' Stmt                                { $3 : $1 } 
      | {-empty-}                                     { [] }

Stmt : {-empty-}                                      { SEmpty } 
     | LValue equal Expr                              { SEqual $1 $3 }
     | Block                                          { SBlock $1 }
     | Call                                           { SCall $1 }
     | if Expr then Stmt Else                         { SIf $1 $4 $5 }     
     | while Expr do Stmt                             { SWhile $2 $4 }
     | id ':' Stmt                                    { SId $1 $3 }
     | goto id                                        { SGoto $1 }
     | return                                         { SReturn }
     | new New LValue                                 { SNew $2 $3 }
     | dispose Dispose LValue                         { SDispose $2 $3 }

Else : else Stmt                                      { SElse $2 }
     | {-empty-}                                      { SEmpty }

New : '[' Expr ']'                                    { $2 }
    | {-empty-}                                       { EEmpty }

Dispose : '[' ']'                                     { [] }
        | {-empty-}                                   { [] }

Expr : LValue                                         { LValue $1 }
     | RValue                                         { RValue $1 }

LValue : id                                           { LId $1 }
       | result                                       { LResult }
       | stringconst                                  { LString $1 }
       | LValue '[' Expr ']'                          { LValueExpr $1 $3}
       | Expr '^'                                     { LExpr $1 }
       | '(' LValue ')'                               { LParen $2 }

RValue : intconst                                     { RInt $1 }
       | true                                         { RTrue }
       | false                                        { RFalse } 
       | realconst                                    { RReal $1 }
       | charconst                                    { RChar $1 }
       | '(' RValue ')'                               { RParen $2 }
       | nil                                          { RNil }
       | Call                                         { RCall $1 }
       | '@' LValue %prec NEG                         { RPapaki $2 }
       | Unop Expr                                    { RUnop $1 $2 }
       | Expr Binop Expr                              { RBinop $1 $2 $3 }
       
Call : id '(' Call2 ')'                               { CId $1 $3 }

Call2 : {-empty-}                                     { [] }
      | Expr Call3                                    { $1 : $2 }

Call3 : Call3 ',' Expr                                { $3 : $1 } 
      | {-empty-}                                     { [] }

Unop : not                                            { UNot }
     | '+'  %prec POS                                 { UPos }
     | '-'  %prec NEG                                 { UNeg }
    
Binop : '+'                                           { BPlus }
      | '-'                                           { BMinus }
      | '*'                                           { BMul }
      | '/'                                           { BRealDiv }
      | div                                           { BDiv }
      | mod                                           { BMod }
      | or                                            { BOr }
      | and                                           { BAnd }
      | '='                                           { BEq }
      | diff                                          { BDiff }
      | '<'                                           { BLess }
      | '>'                                           { BGreater }
      | greq                                          { BGreq }
      | smeq                                          { BSmeq }

{
data Program =
  P String Body

data Body =
  B [Local] Block

data Local =
  LoVar Variables         |
  LoLabel [String]        |
  LoHeadBod Header Body   |
  LoForward Header

type Id = String
type MoreVariables = [Id]
type Variables = [ (Type, MoreVariables) ]
type Labels = MoreVariables

data Header =
  Procedure String Arguments1 |
  Function String Arguments1 Type

type Arguments1 = [Formal]
type Arguments2 = Arguments1

type Formal = (Type,[String])

data Type =
  Tint  | 
  Treal |
  Tbool |
  Tchar |
  ArrayT Type |
  PointerT Type |
}
