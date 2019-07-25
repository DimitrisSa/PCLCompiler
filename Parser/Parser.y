{
  module Main where
  import Lexer
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

Program : program id ';' Body '.' 			{ Program $2 $4 }

Body : Bodyrec Block                 			{ Body $1 $2 }  

Bodyrec : Bodyrec Local		     			{ $2 : $1 }
	| {-empty-}					{ [] }

Local : var Variables		  			{ $2 }
      | label id Labels	';'				{ Label ($2 : $3) }
      |	Header ';' Body ';'				{ HeadBod $1 $3 }
      | forward Header ';'				{ Forward $2 }

Variables : Variables id Morevariables ':' Type ';'	{ (($5,$2 : $3) : $1) }
	  | id Morevariables ':' Type ';'		{ [($4,$1 : $2)] }

Morevariables : Morevariables ',' id			{ $3 : $1 }
	      | {-empty-}				{ [] }

Labels : Labels ',' id					{ $3 : $1 }
       | {-empty-}					{ [] }

Header : procedure id '(' Arguments ')'			{ Procedure $2 $4 } 
       | function id '(' Arguments ')' ':' Type		{ Function $2 $4 $7 }

Arguments1 : {-empty-}					{ [] }
	   | Arguments2					{ $1 }

Arguments2 : Arguments2 ';' Formal 			{ $3 : $1 }
	   | Formal					{ $1 }

Formal : Vars id Labels ':' Type		        { ($5,$2:$3) }												  
 
Vars : {-empty-}					{ [] }
     | var						{ [] }


