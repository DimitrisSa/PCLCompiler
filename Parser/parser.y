{
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

%%


