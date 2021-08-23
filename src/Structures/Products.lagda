---
layout: default
title : Sturctures.Products module
date : 2021-05-11
author: [agda-algebras development team][]
---

### Products for structures as records

This module is similar to Products.lagda but for structures represented using records rather than
dependent pair type.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-} -- cubical #-}

module Structures.Products where

-- Imports from the Agda Standard Library ----------------------------------
open import Agda.Primitive using ( _⊔_ ; lsuc ) renaming ( Set to Type )
open import Data.Product   using ( _,_ ; Σ-syntax )
open import Level          using ( Level )
open import Relation.Unary using ( _∈_ ; Pred )

-- Imports from agda-algebras ----------------------------------------------
open import Overture.Preliminaries using ( ∣_∣ ; Π-syntax )
open import Structures.Basic       using ( signature ; structure )


private variable
 𝓞₀ 𝓥₀ 𝓞₁ 𝓥₁ : Level
 𝐹 : signature 𝓞₀ 𝓥₀
 𝑅 : signature 𝓞₁ 𝓥₁
 α ρ ℓ : Level

open structure

⨅ : {ℑ : Type ℓ}(𝒜 : ℑ → structure 𝐹 𝑅 {α}{ρ} ) → structure 𝐹 𝑅
⨅ {ℑ = ℑ} 𝒜 =
 record { carrier = Π[ i ∈ ℑ ] carrier (𝒜 i)            -- domain of the product structure
        ; op = λ 𝑓 a i → (op (𝒜 i) 𝑓) λ x → a x i       -- interpretation of  operations
        ; rel = λ r a → ∀ i → (rel (𝒜 i) r) λ x → a x i -- interpretation of relations
        }


module _ {𝒦 : Pred (structure 𝐹 𝑅 {α}{ρ}) ℓ} where

  ℓp : Level
  ℓp = lsuc (α ⊔ ρ) ⊔ ℓ

  ℑ : Type _
  ℑ = Σ[ 𝑨 ∈ structure 𝐹 𝑅  {α}{ρ}] 𝑨 ∈ 𝒦

  𝔄 : ℑ → structure 𝐹 𝑅 {α}{ρ}
  𝔄 𝔦 = ∣ 𝔦 ∣

  class-product : structure 𝐹 𝑅
  class-product = ⨅ 𝔄

\end{code}

--------------------------------

<br>
<br>

[← Structures.Graphs0](Structures.Graphs0.html)
<span style="float:right;">[Structures.Congruences →](Structures.Congruences.html)</span>

{% include UALib.Links.md %}

[agda-algebras development team]: https://github.com/ualib/agda-algebras#the-agda-algebras-development-team
