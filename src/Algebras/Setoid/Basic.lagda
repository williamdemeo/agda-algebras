---
layout: default
title : Algebras.Setoid.Basic module (Agda Universal Algebra Library)
date : 2021-04-23
author: [agda-algebras development team][]
---

#### <a id="basic-definitions">Basic Definitions</a>

This is the [Algebras.Setoid.Basic][] module of the [Agda Universal Algebra Library][].

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import Algebras.Basic using (𝓞 ; 𝓥 ; Signature )

module Algebras.Setoid.Basic {𝑆 : Signature 𝓞 𝓥} where

-- Imports from the Agda and the Agda Standard Library --------------------
open import Agda.Primitive   using ( _⊔_ ; lsuc ) renaming ( Set to Type )
open import Data.Product     using ( _,_ ; _×_ ; Σ-syntax )
open import Function         using ( _∘_ )
open import Function.Bundles using ( Func )
open import Level            using ( Level )
open import Relation.Binary  using ( Setoid ; IsEquivalence )
open import Relation.Binary.PropositionalEquality as PE
                             using ( _≡_ ; refl )

-- Imports from the Agda Universal Algebra Library ----------------------
open import Overture.Preliminaries using ( ∥_∥ ; ∣_∣ )

private variable
 α ρ ι : Level

ov : Level → Level
ov α = 𝓞 ⊔ 𝓥 ⊔ lsuc α
\end{code}


#### <a id="setoid-algebras">Setoid Algebras</a>

Here we define algebras over a setoid, instead of a mere type with no equivalence on it.

(This approach is inspired by the one taken, e.g., by Andreas Abel in his formalization Birkhoff's completeness theorem; a [pdf is available here](http://www.cse.chalmers.se/~abela/agda/MultiSortedAlgebra.pdf).)

First we define an operator that translates an ordinary signature into a signature over a setoid domain.

\begin{code}

open Setoid using    (_≈_ ; Carrier )
            renaming ( refl  to reflS
                     ; sym   to symS
                     ; trans to transS
                     ; isEquivalence to isEqv )
open Func renaming   ( f to _<$>_ ; cong to ≈cong )

⟦_⟧ : Signature 𝓞 𝓥 → Setoid α ρ → Setoid _ _

Carrier (⟦ 𝑆 ⟧ ξ) = Σ[ f ∈ ∣ 𝑆 ∣ ] ((∥ 𝑆 ∥ f) → ξ .Carrier)
_≈_ (⟦ 𝑆 ⟧ ξ) (f , u) (g , v) = Σ[ eqv ∈ f ≡ g ] EqArgs eqv u v
 where
 EqArgs : f ≡ g → (∥ 𝑆 ∥ f → Carrier ξ) → (∥ 𝑆 ∥ g → Carrier ξ) → Type _
 EqArgs refl u v = ∀ i → (_≈_ ξ) (u i) (v i)

IsEquivalence.refl  (isEqv (⟦ 𝑆 ⟧ ξ))                     = refl , λ _ → reflS  ξ
IsEquivalence.sym   (isEqv (⟦ 𝑆 ⟧ ξ))(refl , g)           = refl , λ i → symS   ξ (g i)
IsEquivalence.trans (isEqv (⟦ 𝑆 ⟧ ξ))(refl , g)(refl , h) = refl , λ i → transS ξ (g i) (h i)

\end{code}


A setoid algebra is just like an algebra but we require that all basic operations
of the algebra respect the underlying setoid equality. The `Func` record packs a
function (f, aka apply, aka _<$>_) with a proof (cong) that the function respects
equality.

\begin{code}

Algebroid : (α ρ : Level) → Type (𝓞 ⊔ 𝓥 ⊔ lsuc (α ⊔ ρ))
Algebroid α ρ = Σ[ A ∈ Setoid α ρ ]      -- the domain (a setoid)
                  Func (⟦ 𝑆 ⟧ A) A       -- the basic operations,
                                         -- along with congruence proofs that
                                         -- each operation espects setoid equality

\end{code}

Alternatively, we can represent a setoid algebra using a record type as follows.

\begin{code}

record SetoidAlgebra α ρ : Type (𝓞 ⊔ 𝓥 ⊔ lsuc (α ⊔ ρ)) where
 field
  Domain : Setoid α ρ
  Interp : Func (⟦ 𝑆 ⟧ Domain) Domain
   --      ^^^^^^^^^^^^^^^^^^^^^^^ is a record type with two fields:
   --       1. a function  f : Carrier (⟦ 𝑆 ⟧ Domain)  → Carrier Domain
   --       2. a proof cong : f Preserves _≈₁_ ⟶ _≈₂_ (that f preserves the setoid equalities)
 ≡→≈ : ∀{x}{y} → x ≡ y → (_≈_ Domain) x y
 ≡→≈ refl = Setoid.refl Domain

\end{code}

It should be clear that the two types `Algebroid` and `SetoidAlgebra` are equivalent. (We tend to use the latter throughout most of the [agda-algebras][] library.)

\begin{code}

open SetoidAlgebra

-- Forgetful Functor
𝕌[_] : SetoidAlgebra α ρ →  Type α
𝕌[ 𝑨 ] = Carrier (Domain 𝑨)

𝔻[_] : SetoidAlgebra α ρ →  Setoid α ρ
𝔻[ 𝑨 ] = Domain 𝑨


-- The universe level of a SetoidAlgebra

Level-of-Alg : {α ρ 𝓞 𝓥 : Level}{𝑆 : Signature 𝓞 𝓥} → SetoidAlgebra α ρ → Level
Level-of-Alg {α = α}{ρ}{𝓞}{𝓥} _ = 𝓞 ⊔ 𝓥 ⊔ lsuc (α ⊔ ρ)

Level-of-Carrier : {α ρ 𝓞 𝓥  : Level}{𝑆 : Signature 𝓞 𝓥} → SetoidAlgebra α ρ → Level
Level-of-Carrier {α = α} _ = α



-- Easier notation for application of an (interpreted) operation symbol.

_∙_ : (f : ∣ 𝑆 ∣)(𝑨 : Algebroid α ρ) → (∥ 𝑆 ∥ f  →  Carrier ∣ 𝑨 ∣) → Carrier ∣ 𝑨 ∣

f ∙ 𝑨 = λ a → ∥ 𝑨 ∥ <$> (f , a)


open SetoidAlgebra

_̂_ : (f : ∣ 𝑆 ∣)(𝑨 : SetoidAlgebra α ρ) → (∥ 𝑆 ∥ f  →  𝕌[ 𝑨 ]) → 𝕌[ 𝑨 ]

f ̂ 𝑨 = λ a → (Interp 𝑨) <$> (f , a)

\end{code}


#### <a id="level-lifting-setoid-algebra-types">Level lifting setoid algebra types</a>

\begin{code}

open Level


Lift-SetoidAlg : SetoidAlgebra α ρ → (ℓ : Level) → SetoidAlgebra (α ⊔ ℓ) ρ

Domain (Lift-SetoidAlg 𝑨 ℓ) = record { Carrier = Lift ℓ 𝕌[ 𝑨 ]
                                     ; _≈_ = λ x y → lower x ≈A lower y
                                     ; isEquivalence = record { refl = srefl
                                                              ; sym = sym
                                                              ; trans = trans
                                                              }
                                     } where open Setoid (Domain 𝑨) renaming (_≈_ to _≈A_ ; refl to srefl )

Interp (Lift-SetoidAlg 𝑨 ℓ) <$> (f , la) = lift ((f ̂ 𝑨) (lower ∘ la))

≈cong (Interp (Lift-SetoidAlg 𝑨 ℓ)) (refl , la=lb) = ≈cong (Interp 𝑨) ((refl , la=lb))


module _ {𝑨 : SetoidAlgebra α ρ} where

 open SetoidAlgebra 𝑨
 open Setoid (Domain 𝑨) renaming ( refl to srefl )
 private
  A = Carrier (Domain 𝑨)
  _≈A_ = _≈_ (Domain 𝑨)

 Lift-SetoidAlg' : (ℓ : Level) → SetoidAlgebra (α ⊔ ℓ) ρ

 Domain (Lift-SetoidAlg' ℓ) = record { Carrier = Lift ℓ A
                                     ; _≈_ = λ x y → lower x ≈A lower y
                                     ; isEquivalence = record { refl = srefl ; sym = sym ; trans = trans }
                                     }

 Interp (Lift-SetoidAlg' ℓ) <$> (f , la) = lift ((f ̂ 𝑨) (lower ∘ la))

 ≈cong (Interp (Lift-SetoidAlg' ℓ)) (refl , la≡lb) = ≈cong (Interp 𝑨) (PE.refl , la≡lb)

\end{code}


--------------------------------

[↑ Algebras.Setoid](Algebras.Setoid.html)
<span style="float:right;">[Algebras.Setoid.Products →](Algebras.Setoid.Products.html)</span>

{% include UALib.Links.md %}

[agda-algebras development team]: https://github.com/ualib/agda-algebras#the-agda-algebras-development-team
