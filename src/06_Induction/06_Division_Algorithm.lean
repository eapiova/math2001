/- Copyright (c) Heather Macbeth, 2023.  All rights reserved. -/
import Mathlib.Tactic.IntervalCases
import Math2001.Tactic.Addarith
import Math2001.Tactic.Induction
import Math2001.Tactic.Rel
import Math2001.Tactic.Take

set_option linter.unusedVariables false


def mod (n d : ℤ) : ℤ :=
  if n * d < 0 then
    mod (n + d) d
  else if h2 : 0 < d * (n - d) then
    mod (n - d) d
  else if h3 : n = d then
    0
  else
    n
termination_by _ n d => 2 * n - d

def div (n d : ℤ) : ℤ :=
  if n * d < 0 then
    div (n + d) d - 1
  else if 0 < d * (n - d) then
    div (n - d) d + 1
  else if h3 : n = d then
    1
  else
    0
termination_by _ n d => 2 * n - d


#eval div 23 4 -- infoview displays `5`
#eval mod 23 4 -- infoview displays `3`


theorem div_add_mod (n d : ℤ) : d * div n d + mod n d = n := by
  rw [div, mod]
  split_ifs with h1 h2 h3 <;> push_neg at *
  · have IH := div_add_mod (n + d) d
    calc d * (div (n + d) d - 1) + mod (n + d) d
        = (d * div (n + d) d + mod (n + d) d) - d := by ring
      _ = n := by addarith [IH]
  · have IH := div_add_mod (n - d) d
    calc d * (div (n - d) d + 1) + mod (n - d) d
        = (d * div (n - d) d + mod (n - d) d) + d := by ring
        _ = n := by addarith [IH]
  · calc d * 1 + 0 = d := by ring
      _ = n := by rw [h3]
  · ring
termination_by _ n d => 2 * n - d


theorem mod_nonneg (n : ℤ) {d : ℤ} (hd : 0 < d) : 0 ≤ mod n d := by
  rw [mod]
  split_ifs with h1 h2 h3 <;> push_neg at *
  · exact mod_nonneg (n + d) hd
  · exact mod_nonneg (n - d) hd
  · extra
  · apply nonneg_of_mul_nonneg_left (b := d)
    apply h1
    apply hd
termination_by _ n d hd => 2 * n - d


theorem mod_lt (n : ℤ) {d : ℤ} (hd : 0 < d) : mod n d < d := by
  rw [mod]
  split_ifs with h1 h2 h3 <;> push_neg at *
  · exact mod_lt (n + d) hd
  · exact mod_lt (n - d) hd
  · exact hd
  · have h4 : n - d ≤ 0
    · apply nonpos_of_mul_nonpos_right (a := d)
      apply h2
      apply hd
    apply lt_of_le_of_ne
    · addarith [h4]
    · apply h3
termination_by _ n d hd => 2 * n - d


example (a b : ℤ) (h : 0 < b) : ∃ r : ℤ, 0 ≤ r ∧ r < b ∧ a ≡ r [ZMOD b] := by
  take mod a b
  constructor
  · apply mod_nonneg a h
  constructor
  · apply mod_lt a h
  · take div a b
    have Hab : b * div a b + mod a b = a := div_add_mod a b
    addarith [Hab]


theorem uniqueness (a b : ℤ) (h : 0 < b) {r s : ℤ} (hr : 0 ≤ r ∧ r < b ∧ a ≡ r [ZMOD b]) 
    (hs : 0 ≤ s ∧ s < b ∧ a ≡ s [ZMOD b]) :
    r = s := by
  sorry

example (a b : ℤ) (h : 0 < b) : ∃! r : ℤ, 0 ≤ r ∧ r < b ∧ a ≡ r [ZMOD b] := by
  sorry
