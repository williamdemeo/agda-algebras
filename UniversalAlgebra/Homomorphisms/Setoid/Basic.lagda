---
layout: default
title : Homomorphisms.Setoid.Basic module (Agda Universal Algebra Library)
date : 2021-07-03
author: [agda-algebras development team][]
---

### Homomorphisms of Algebras over Setoids

This is the [Homomorphisms.Setoid][] module of the [Agda Universal Algebra Library][].

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import Algebras.Basic using (𝓞 ; 𝓥 ; Signature )

module Homomorphisms.Setoid.Basic {𝑆 : Signature 𝓞 𝓥} where

-- Imports from the Agda (Builtin) and the Agda Standard Library
open import Agda.Builtin.Equality  using    ( _≡_      ;  refl )
open import Agda.Primitive         using    ( _⊔_      ;  lsuc )
                                   renaming ( Set      to Type )
open import Data.Product           using    ( _,_      ;  Σ
                                            ; Σ-syntax ;  _×_  )
                                   renaming ( proj₁    to fst
                                            ; proj₂    to snd  )
open import Function               using    ( _∘_      ;  id   )
open import Level                  using    ( Level    ;  Lift )
open import Relation.Binary        using    ( IsEquivalence    )
open import Relation.Unary         using    ( _⊆_              )
import Relation.Binary.PropositionalEquality as PE

-- Imports from the Agda Universal Algebra Library
open import Overture.Preliminaries     using ( ∣_∣ ; ∥_∥ ; _⁻¹ ; _≈_)
open import Overture.Inverses          using ( IsInjective ; IsSurjective )
open import Overture.Inverses          using ( SurjInv )
open import Relations.Discrete         using ( ker ; kernel )
open import Relations.Quotients        using ( ker-IsEquivalence )
open import Relations.Truncation       using ( is-set ; blk-uip ; is-embedding
                                             ; monic-is-embedding|Set )
open import Relations.Extensionality   using ( swelldef ; block-ext|uip ; pred-ext
                                             ; SurjInvIsRightInv ; epic-factor )
open import Algebras.Setoid.Basic    {𝑆 = 𝑆} using ( 𝕌[_] ; SetoidAlgebra ; _̂_ ; Lift-SetoidAlg )
open import Algebras.Setoid.Congruences {𝑆 = 𝑆} using ( _∣≈_ ; Con ; IsCongruence ; mkcon ; _╱_)
\end{code}

### Homomorphisms for setoid algebras

\begin{code}

-- module _ {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
--          {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)
--          where
--  private
--   A = 𝕌[ 𝑨 ] -- (𝕌 = forgetful functor)
--   B = 𝕌[ 𝑩 ]

compatible-op-map : {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
                    {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)
 →                  ∣ 𝑆 ∣ → (𝕌[ 𝑨 ] → 𝕌[ 𝑩 ]) → Type _
compatible-op-map 𝑨 𝑩 f h = ∀ a → h ((f ̂ 𝑨) a) ≡ (f ̂ 𝑩) (h ∘ a)

-- The property of being a homomorphism.
is-homomorphism : {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
                  {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)
 →                (𝕌[ 𝑨 ] → 𝕌[ 𝑩 ]) → Type _
is-homomorphism 𝑨 𝑩 h = ∀ f  →  compatible-op-map 𝑨 𝑩 f h

-- The type of homomorphisms from `𝑨` to `𝑩`.
hom : {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
                  {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)
 →                Type _
hom 𝑨 𝑩 = Σ (𝕌[ 𝑨 ] → 𝕌[ 𝑩 ]) (is-homomorphism 𝑨 𝑩)

open PE.≡-Reasoning
open PE renaming (cong to ≡-cong)

module _ {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)  -- (explicit 𝑨)
         {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)  -- (implicit 𝑩)
         {γ ρᶜ : Level} (𝑪 : SetoidAlgebra γ ρᶜ)  -- (explicit 𝑪)
         where

 -- The composition of homomorphisms is again a homomorphism.
 ∘-is-hom : {g : 𝕌[ 𝑨 ] → 𝕌[ 𝑩 ]}{h : 𝕌[ 𝑩 ] → 𝕌[ 𝑪 ]}
  →         is-homomorphism 𝑨 𝑩 g → is-homomorphism 𝑩 𝑪 h
            -------------------------------------------------
  →         is-homomorphism 𝑨 𝑪 (h ∘ g)

 ∘-is-hom {g} {h} ghom hhom 𝑓 a = (h ∘ g)((𝑓 ̂ 𝑨) a) ≡⟨ ≡-cong h ( ghom 𝑓 a ) ⟩
                                  h ((𝑓 ̂ 𝑩)(g ∘ a)) ≡⟨ hhom 𝑓 ( g ∘ a ) ⟩
                                  (𝑓 ̂ 𝑪)(h ∘ g ∘ a) ∎

 ∘-hom : hom 𝑨 𝑩  →  hom 𝑩 𝑪  →  hom 𝑨 𝑪
 ∘-hom (g , ghom) (h , hhom) = h ∘ g , ∘-is-hom {g}{h} ghom hhom 


private variable
 α ρ : Level

-- the identity homs
𝒾𝒹 :  (𝑨 : SetoidAlgebra α ρ) → hom 𝑨 𝑨
𝒾𝒹 _ = id , λ 𝑓 a → refl

open Level
-- the lift hom
𝓁𝒾𝒻𝓉 : {ℓ : Level}{𝑨 : SetoidAlgebra α ρ} → hom 𝑨 (Lift-SetoidAlg 𝑨 ℓ)
𝓁𝒾𝒻𝓉 = lift , (λ 𝑓 a → refl)

-- the lower hom
𝓁ℴ𝓌ℯ𝓇 : {ℓ : Level}{𝑨 : SetoidAlgebra α ρ} → hom (Lift-SetoidAlg 𝑨 ℓ) 𝑨
𝓁ℴ𝓌ℯ𝓇 = (lower , λ 𝑓 a → refl)

module LiftSetoidHom {α ρᵃ : Level}{𝑨 : SetoidAlgebra α ρᵃ}
                     (ℓᵃ : Level)
                     {β ρᵇ : Level}{𝑩 : SetoidAlgebra β ρᵇ}
                     (ℓᵇ : Level)
                     where
 open Level

 Lift-hom : hom 𝑨 𝑩  →  hom (Lift-SetoidAlg 𝑨 ℓᵃ) (Lift-SetoidAlg 𝑩 ℓᵇ)

 Lift-hom (f , fhom) = lift ∘ f ∘ lower , Goal
  where
  lA lB : SetoidAlgebra _ _
  lA = Lift-SetoidAlg 𝑨 ℓᵃ
  lB = Lift-SetoidAlg 𝑩 ℓᵇ

  lABh : is-homomorphism lA 𝑩 (f ∘ lower)
  lABh = ∘-is-hom lA 𝑨  𝑩 {lower}{f} (λ _ _ → refl) fhom

  Goal : is-homomorphism lA lB (lift ∘ (f ∘ lower))
  Goal = ∘-is-hom lA 𝑩 lB {f ∘ lower}{lift} lABh λ _ _ → refl


-- Monomorphisms and epimorphisms
module _ {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
         {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)
         where

 private
  A = 𝕌[ 𝑨 ]  -- carrier of domain of 𝑨
  B = 𝕌[ 𝑩 ]

 is-monomorphism : (A → B) → Type _
 is-monomorphism g = is-homomorphism 𝑨 𝑩 g × IsInjective g

 is-epimorphism : (A → B) → Type _
 is-epimorphism g = is-homomorphism 𝑨 𝑩 g × IsSurjective g

record mon {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
           {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ) : Type (𝓞 ⊔ 𝓥 ⊔ α ⊔ β) where
 field
  map : 𝕌[ 𝑨 ] → 𝕌[ 𝑩 ]
  is-mon : is-monomorphism 𝑨 𝑩 map

 mon-to-hom : hom 𝑨 𝑩
 mon-to-hom = map , ∣ is-mon ∣


record epi {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
           {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ) : Type (𝓞 ⊔ 𝓥 ⊔ α ⊔ β) where
 field
  map : 𝕌[ 𝑨 ] → 𝕌[ 𝑩 ]
  is-epi : is-epimorphism 𝑨 𝑩 map

 epi-to-hom : hom 𝑨 𝑩
 epi-to-hom = map , ∣ is-epi ∣


\end{code}



#### Kernels of homomorphisms for SetoidAlgebras

\begin{code}


module _ {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
         {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)
         where
 private
  A = 𝕌[ 𝑨 ]
  B = 𝕌[ 𝑩 ]


 homker-comp : swelldef 𝓥 β → (h : hom 𝑨 𝑩) → 𝑨 ∣≈ (ker ∣ h ∣)
 homker-comp wd h f {u}{v} kuv = ∣ h ∣((f ̂ 𝑨) u)   ≡⟨ ∥ h ∥ f u ⟩
                                 (f ̂ 𝑩)(∣ h ∣ ∘ u) ≡⟨ wd(f ̂ 𝑩)(∣ h ∣ ∘ u)(∣ h ∣ ∘ v)kuv ⟩
                                 (f ̂ 𝑩)(∣ h ∣ ∘ v) ≡⟨ (∥ h ∥ f v)⁻¹ ⟩
                                 ∣ h ∣((f ̂ 𝑨) v)   ∎


 kercon : swelldef 𝓥 β → hom 𝑨 𝑩 → Con 𝑨
 kercon wd h = ker ∣ h ∣ , mkcon (ker-IsEquivalence ∣ h ∣) (homker-comp wd h)

 kerquo : swelldef 𝓥 β → hom 𝑨 𝑩 → SetoidAlgebra _ _
 kerquo wd h = 𝑨 ╱ (kercon wd h)


ker[_⇒_]_↾_ : {α ρᵃ : Level} (𝑨 : SetoidAlgebra α ρᵃ)
              {β ρᵇ : Level} (𝑩 : SetoidAlgebra β ρᵇ)
 →            hom 𝑨 𝑩 → swelldef 𝓥 β → SetoidAlgebra _ _
ker[ 𝑨 ⇒ 𝑩 ] h ↾ wd = kerquo 𝑨 𝑩 wd h

\end{code}