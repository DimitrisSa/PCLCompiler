# PCLCompiler

tools:
* Alex for lexer
* Happy for parsing

Επιλέξαμε τα παραπάνω εργαλεία γιατί μερικές πράξεις στη γλώσσα χρειάζεται να είναι αριστερά προσεταιριστικές οπότε εργαλεία όπως το Parsec υστερούν,διότι η γλώσσα μας δεν είναι LL(1).

To Do:
- operations for integers also (possibly by merging ir with sems) DONE
- HeaderBody Local DONE
- Forward Local DONE
- Label statement DONE
- goto statement DONE
- return statement DONE
- result lval DONE
- dispose statement DONE
- new statement DONE
- double to X86_FP80 
- size of pointers?
- eat space in beginning of string?
- find all the built-in functions in llvm and define them (like printf) DONE
      -> then define the PCL equivalent (like writeString)

To Fix:
  - references gap because of pass by ref
