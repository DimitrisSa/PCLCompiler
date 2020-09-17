# PCLCompiler

tools:
* Alex for lexer
* Happy for parsing

Επιλέξαμε τα παραπάνω εργαλεία γιατί μερικές πράξεις στη γλώσσα χρειάζεται να είναι αριστερά προσεταιριστικές οπότε εργαλεία όπως το Parsec υστερούν,διότι η γλώσσα μας δεν είναι LL(1).

To Do:
- operations for integers also (possibly by merging ir with sems) DONE
- HeaderBody Local
- Forward Local
- Label statement
- goto statement
- return statement
- result lval
- dispose statement
- find all the built-in functions in llvm and define them (like printf) ON THE WORKS
      -> then define the PCL equivalent (like writeString)
