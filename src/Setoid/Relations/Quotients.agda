
{-# OPTIONS --without-K --exact-split --safe #-}

module Setoid.Relations.Quotients where

open import Agda.Primitive    using () renaming ( Set to Type )
open import Data.Product      using ( _,_ ; Σ-syntax ) renaming ( _×_ to _∧_ )
open import Function          using ( id ) renaming ( Func to _⟶_ )
open import Level using ( Level ; _⊔_ ; suc )
open import Relation.Binary   using ( IsEquivalence ) renaming ( Rel to BinRel )
open import Relation.Unary    using ( Pred ; _∈_ ; _⊆_ )
open import Relation.Binary   using ( Setoid )
open import Relation.Binary.PropositionalEquality as ≡
                              using ( _≡_ )

open import Overture                   using ( ∣_∣ ; ∥_∥ )
open import Base.Relations             using ( [_] ; Equivalence )
open import Setoid.Relations.Discrete  using ( fker )

private variable α β ρᵃ ρᵇ ℓ : Level

open _⟶_ using ( cong ) renaming ( to to _⟨$⟩_ )

module _ {𝐴 : Setoid α ρᵃ}{𝐵 : Setoid β ρᵇ} where
 open Setoid 𝐴  using ( refl ) renaming (Carrier to A )
 open Setoid 𝐵  using ( sym ; trans ) renaming (Carrier to B )

 ker-IsEquivalence : (f : 𝐴 ⟶ 𝐵) → IsEquivalence (fker f)
 IsEquivalence.refl   (ker-IsEquivalence f) = cong f refl
 IsEquivalence.sym    (ker-IsEquivalence f) = sym
 IsEquivalence.trans  (ker-IsEquivalence f) = trans

record IsBlock  {A : Type α}{ρ : Level}
                (P : Pred A ρ){R : BinRel A ρ} : Type(α ⊔ suc ρ) where
 constructor mkblk
 field
  a : A
  P≈[a] : ∀ x → (x ∈ P → [ a ]{ρ} R x) ∧ ([ a ]{ρ} R x → x ∈ P)

open IsBlock

Quotient : (A : Type α) → Equivalence A{ℓ} → Type(α ⊔ suc ℓ)
Quotient A R = Σ[ P ∈ Pred A _ ] IsBlock P {∣ R ∣}

_/_ : (A : Type α) → Equivalence A{ℓ} → Setoid _ _
A / R = record { Carrier = A ; _≈_ = ∣ R ∣ ; isEquivalence = ∥ R ∥ }

infix -1 _/_

open Setoid
⟪_⟫ : {α : Level}{A : Type α} → A → {R : Equivalence A{ℓ}} → Carrier (A / R)
⟪ a ⟫{R} = a

module _ {A : Type α}{R : Equivalence A{ℓ} } where

 open Setoid (A / R) using () renaming ( _≈_ to _≈₁_ )

 ⟪_∼_⟫-intro : (u v : A) → ∣ R ∣ u v → ⟪ u ⟫{R} ≈₁ ⟪ v ⟫{R}
 ⟪ u ∼ v ⟫-intro = id

 ⟪_∼_⟫-elim : (u v : A) → ⟪ u ⟫{R} ≈₁ ⟪ v ⟫{R} → ∣ R ∣ u v
 ⟪ u ∼ v ⟫-elim = id

≡→⊆ : {A : Type α}{ρ : Level}(Q R : Pred A ρ) → Q ≡ R → Q ⊆ R
≡→⊆ Q .Q ≡.refl {x} Qx = Qx

