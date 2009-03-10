
module Agda.Syntax.Abstract.Views where

import Agda.Syntax.Position
import Agda.Syntax.Common
import Agda.Syntax.Abstract
import Agda.Syntax.Info

data AppView = Application Head [NamedArg Expr]
	     | NonApplication Expr
		-- ^ TODO: if we allow beta-redexes (which we currently do) there could be one here.

data Head = HeadVar Name
	  | HeadDef QName
	  | HeadCon [QName]

appView :: Expr -> AppView
appView e =
    case e of
	Var x	       -> Application (HeadVar x) []
	Def x	       -> Application (HeadDef x) []
	Con (AmbQ x)   -> Application (HeadCon x) []
	App i e1 arg   -> apply i (appView e1) arg
	ScopedExpr _ e -> appView e
	_	       -> NonApplication e
    where
	apply i v arg =
	    case v of
		Application hd es -> Application hd $ es ++ [arg]
		NonApplication e  -> NonApplication (App i e arg)

headToExpr :: Head -> Expr
headToExpr (HeadVar x)  = Var x
headToExpr (HeadDef f)  = Def f
headToExpr (HeadCon cs) = Con (AmbQ cs)

unAppView :: AppView -> Expr
unAppView (NonApplication e) = e
unAppView (Application h es) =
  foldl (App (ExprRange noRange)) (headToExpr h) es

instance HasRange Head where
    getRange (HeadVar x) = getRange x
    getRange (HeadDef x) = getRange x
    getRange (HeadCon x) = getRange x

