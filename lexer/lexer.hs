module ParsePCL where
import System.IO
import Control.Monad
import Text.Parsec
import Text.Parsec.Expr
import Text.Parsec.Language
import qualified Text.Parsec.Token as Token

languageDef = 
  emptyDef { Token.commentStart = "(*"
           , Token.commentEnd = "*)"
           , Token.commentLine = fail "Line comment not supported"
           , Token.nestedComments = False 
           , Token.identStart = letter
           , Token.identLetter = alphaNum <|> char '_'
           , Token.reservedNames = [ "and"
                                   , "do"
                                   , "if"
                                   , "of"
                                   , "then"
                                   , "array"
                                   , "else"
                                   , "integer"
                                   , "or"
                                   , "true"
                                   , "begin"
                                   , "end"
                                   , "label"
                                   , "procedure"
                                   , "var"
                                   , "boolean"
                                   , "false"
                                   , "mod"
                                   , "program"
                                   , "while"
                                   , "char"
                                   , "forward"
                                   , "new"
                                   , "real"
                                   , "dispose"
                                   , "function"
                                   , "nil"
                                   , "result"
                                   , "div"
                                   , "goto"
                                   , "not"
                                   , "return"
                                   ]
           , Token.reservedOpNames = [ "="
                                     , ">"
                                     , "<"
                                     , "<>"
                                     , ">="
                                     , "<="
                                     , "+"
                                     , "-"
                                     , "*"
                                     , "/"
                                     , "^"
                                     , "@"
                                     ]
           , Token.caseSensitive = True
  }  

lexer = Token.makeTokenParser languageDef
