instance Show C where
  showsPrec p Cskip = ("skip" ++)
  showsPrec p (Cassign x e) = (x ++) . (" := " ++) . showsPrec 0 e
  showsPrec p (Cseq c1 c2) =
    showParen (p > 0) $
    showsPrec 1 c1 . ("; " ++) . showsPrec 0 c2
  showsPrec p (Cfor e c) =
    showParen (p > 1) $
    ("for " ++) . showsPrec 1 e . (" do " ++) . showsPrec 1 c
  showsPrec p (Cif e c1 c2) =
    showParen (p > 1) $
    ("if " ++) . showsPrec 1 e . (" then " ++) . showsPrec 2 c1 .
                                 (" else " ++) . showsPrec 1 c2
  showsPrec p (Cwhile e c) =
    showParen (p > 1) $
    ("while " ++) . showsPrec 1 e . (" do " ++) . showsPrec 1 c
