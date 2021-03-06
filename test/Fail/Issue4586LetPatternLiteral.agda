-- Andreas, 2020-04-15, issue #4586
-- Better error for invalid let pattern.

import Agda.Builtin.Nat

test : Set₁
test = let 13 = Set
       in  Set

-- WAS:
-- Set != x of type Set₁
-- when checking that the given dot pattern Set matches the inferred
-- value x

-- EXPECTED:
-- Not a valid let pattern
-- when scope checking let .Set = Set in Set
