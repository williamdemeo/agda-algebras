---
layout: default
title : Subalgebras.Subalgebras module (The Agda Universal Algebra Library)
date : 2021-01-14
author: William DeMeo
---

### <a id="subalgebras">Subalgebras</a>

The [Subalgebras.Subalgebras][] module of the [Agda Universal Algebra Library][] defines the `Subalgebra` type, representing the subalgebra of a given algebra, as well as the collection of all subalgebras of a given class of algebras.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

-- Imports from Agda (builtin/primitive) and the Agda Standard Library
open import Agda.Builtin.Equality using (_≡_; refl)
open import Axiom.Extensionality.Propositional renaming (Extensionality to funext)
open import Data.Product using (_,_; Σ; _×_)
open import Function.Base  using (_∘_)
open import Level renaming (suc to lsuc; zero to lzero)
open import Relation.Binary.PropositionalEquality.Core using (cong; module ≡-Reasoning)
open ≡-Reasoning
open import Relation.Unary using (_∈_; Pred; _⊆_)

-- Imports from the Agda Universal Algebra Library
open import Algebras.Basic
open import Relations.Extensionality using (pred-ext; swelldef)
open import Relations.Truncation using (is-set; blk-uip)
open import Overture.Inverses using (IsInjective; id-is-injective; ∘-injective)
open import Overture.Preliminaries
 using (Type; 𝓞; 𝓤; 𝓥; 𝓦; 𝓧; 𝓨; 𝓩; Π; -Π; -Σ; _∙_;_⁻¹; ∣_∣; ∥_∥; snd; 𝑖𝑑; fst)


module Subalgebras.Subalgebras {𝑆 : Signature 𝓞 𝓥} where

open import Algebras.Products{𝑆 = 𝑆} using (ov)
open import Homomorphisms.Basic {𝑆 = 𝑆} using (hom; kercon; ker[_⇒_]_↾_; ∘-hom; is-homomorphism; ∘-is-hom)
open import Homomorphisms.Noether using (FirstHomTheorem|Set)
open import Homomorphisms.Isomorphisms using (_≅_; ≅-sym; ≅-trans; Lift-≅)
open import Terms.Basic {𝑆 = 𝑆} using (Term; ℊ; node; 𝑻)

\end{code}


#### <a id="subalgebra-type">Subalgebra type</a>

Given algebras `𝑨 : Algebra 𝓤 𝑆` and `𝑩 : Algebra 𝓦 𝑆`, we say that `𝑩` is a **subalgebra** of `𝑨` just in case `𝑩` can be *homomorphically embedded* in `𝑨`; that is, there exists a map `h : ∣ 𝑩 ∣ → ∣ 𝑨 ∣` that is both a homomorphism and an embedding.<sup>[1](Subalgebras.Subalgebras.html#fn1)</sup>

\begin{code}

_IsSubalgebraOf_ : {𝓦 𝓤 : Level}(𝑩 : Algebra 𝓦 𝑆)(𝑨 : Algebra 𝓤 𝑆) → Type(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⊔ 𝓦)
𝑩 IsSubalgebraOf 𝑨 = Σ[ h ꞉ hom 𝑩 𝑨 ] IsInjective ∣ h ∣

Subalgebra : {𝓦 𝓤 : Level} → Algebra 𝓤 𝑆 → Type(ov 𝓦 ⊔ 𝓤)
Subalgebra {𝓦} 𝑨 = Σ[ 𝑩 ꞉ (Algebra 𝓦 𝑆) ] 𝑩 IsSubalgebraOf 𝑨

\end{code}

Note the order of the arguments.  The universe `𝓦` comes first because in certain situations we must explicitly specify this universe, whereas we can almost always leave the universe `𝓤` implicit. (See, for example, the definition of `_IsSubalgebraOfClass_` below.)




#### <a id="consequences-of-first-homomorphism-theorem">Consequences of First Homomorphism Theorem</a>

We take this opportunity to prove an important lemma that makes use of the `IsSubalgebraOf` type defined above.  It is the following: If `𝑨` and `𝑩` are `𝑆`-algebras and `h : hom 𝑨 𝑩` a homomorphism from `𝑨` to `𝑩`, then the quotient `𝑨 ╱ ker h` is (isomorphic to) a subalgebra of `𝑩`.  This is an easy corollary of the First Homomorphism Theorem proved in the [Homomorphisms.Noether][] module.

\begin{code}

module _ (𝑨 : Algebra 𝓤 𝑆)(𝑩 : Algebra 𝓦 𝑆)(h : hom 𝑨 𝑩)
         -- extensionality assumptions:
         (pe : pred-ext 𝓤 𝓦)(fe : swelldef 𝓥 𝓦)

         -- truncation assumptions:
         (Bset : is-set ∣ 𝑩 ∣)
         (buip : blk-uip ∣ 𝑨 ∣ ∣ kercon fe {𝑩} h ∣)
         where

 FirstHomCorollary|Set : (ker[ 𝑨 ⇒ 𝑩 ] h ↾ fe) IsSubalgebraOf 𝑩
 FirstHomCorollary|Set = ϕhom , ϕinj
  where
   hh = FirstHomTheorem|Set 𝑨 𝑩 h pe fe Bset buip
   ϕhom : hom (ker[ 𝑨 ⇒ 𝑩 ] h ↾ fe) 𝑩
   ϕhom = ∣ hh ∣

   ϕinj : IsInjective ∣ ϕhom ∣
   ϕinj = ∣ snd ∥ hh ∥ ∣

\end{code}

If we apply the foregoing theorem to the special case in which the `𝑨` is term algebra `𝑻 X`, we obtain the following result which will be useful later.

\begin{code}

module _ (X : Type 𝓧)(𝑩 : Algebra 𝓦 𝑆)(h : hom (𝑻 X) 𝑩)
         -- extensionality assumptions:
         (pe : pred-ext (ov 𝓧) 𝓦)(fe : swelldef 𝓥 𝓦)

         -- truncation assumptions:
         (Bset : is-set ∣ 𝑩 ∣)
         (buip : blk-uip (Term X) ∣ kercon fe {𝑩} h ∣)
         where

 free-quot-subalg : (ker[ 𝑻 X ⇒ 𝑩 ] h ↾ fe) IsSubalgebraOf 𝑩
 free-quot-subalg = FirstHomCorollary|Set{𝓤 = ov 𝓧}(𝑻 X) 𝑩 h pe fe Bset buip

\end{code}

**Notation**. For convenience, we define the following shorthand for the subalgebra relation.

\begin{code}

_≤_ : Algebra 𝓦 𝑆 → Algebra 𝓤 𝑆 → Type(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⊔ 𝓦)
𝑩 ≤ 𝑨 = 𝑩 IsSubalgebraOf 𝑨

\end{code}

From now on we will use `𝑩 ≤ 𝑨` to express the assertion that `𝑩` is a subalgebra of `𝑨`.


#### <a id="subalgebras-of-a-class">Subalgebras of a class</a>

One of our goals is to formally express and prove properties of classes of algebraic structures.  Fixing a signature `𝑆` and a universe `𝓤`, we represent classes of `𝑆`-algebras with domains of type `Type 𝓤` as predicates over the `Algebra 𝓤 𝑆` type. In the syntax of the [UniversalAlgebra][] library, such predicates inhabit the type `Pred (Algebra 𝓤 𝑆) 𝓩`, for some universe 𝓩.

Suppose `𝒦 : Pred (Algebra 𝓤 𝑆) 𝓩` denotes a class of `𝑆`-algebras and `𝑩 : Algebra 𝓦 𝑆` denotes an arbitrary `𝑆`-algebra. Then we might wish to consider the assertion that `𝑩` is a subalgebra of an algebra in the class `𝒦`.  The next type we define allows us to express this assertion as `𝑩 IsSubalgebraOfClass 𝒦`.

\begin{code}

module _ {𝓦 𝓤 𝓩 : Level} where

 _IsSubalgebraOfClass_ : Algebra 𝓦 𝑆 → Pred (Algebra 𝓤 𝑆) 𝓩 → Type(ov (𝓤 ⊔ 𝓦) ⊔ 𝓩)
 𝑩 IsSubalgebraOfClass 𝒦 = Σ[ 𝑨 ꞉ Algebra 𝓤 𝑆 ] Σ[ sa ꞉ Subalgebra{𝓦} 𝑨 ] ((𝑨 ∈ 𝒦) × (𝑩 ≅ ∣ sa ∣))

\end{code}

Using this type, we express the collection of all subalgebras of algebras in a class by the type `SubalgebraOfClass`, which we now define.

\begin{code}

SubalgebraOfClass : {𝓦 𝓤 : Level} → Pred (Algebra 𝓤 𝑆)(ov 𝓤) → Type(ov (𝓤 ⊔ 𝓦))
SubalgebraOfClass {𝓦} 𝒦 = Σ[ 𝑩 ꞉ Algebra 𝓦 𝑆 ] 𝑩 IsSubalgebraOfClass 𝒦

\end{code}




#### <a id="subalgebra-lemmas">Subalgebra lemmas</a>

We conclude this module by proving a number of useful facts about subalgebras. Some of the formal statements below may appear to be redundant, and indeed they are to some extent. However, each one differs slightly from the next, if only with respect to the explicitness or implicitness of their arguments.  The aim is to make it as convenient as possible to apply the lemmas in different situations.  (We're in the [UniversalAlgebra][] utility closet now; elegance is not the priority.)

First we show that the subalgebra relation is a *preorder*; i.e., it is a reflexive, transitive binary relation.<sup>[2](Subalgebras.Subalgebras.html#fn2)</sup>

\begin{code}

≤-reflexive : (𝑨 : Algebra 𝓤 𝑆) → 𝑨 ≤ 𝑨
≤-reflexive 𝑨 = (𝑖𝑑 ∣ 𝑨 ∣ , λ 𝑓 𝑎 → refl) , id-is-injective

≤-refl : {𝑨 : Algebra 𝓤 𝑆} → 𝑨 ≤ 𝑨
≤-refl {𝑨 = 𝑨} = ≤-reflexive 𝑨


≤-transitivity : (𝑨 : Algebra 𝓧 𝑆)(𝑩 : Algebra 𝓨 𝑆)(𝑪 : Algebra 𝓩 𝑆)
 →               𝑪 ≤ 𝑩 → 𝑩 ≤ 𝑨 → 𝑪 ≤ 𝑨

≤-transitivity 𝑨 𝑩 𝑪 CB BA = (∘-hom 𝑪 𝑨 ∣ CB ∣ ∣ BA ∣) , γ
 where
  γ : IsInjective ∣ (∘-hom 𝑪 𝑨 ∣ CB ∣ ∣ BA ∣) ∣
  γ = ∘-injective ∥ CB ∥ ∥ BA ∥

≤-trans : (𝑨 : Algebra 𝓧 𝑆){𝑩 : Algebra 𝓨 𝑆}{𝑪 : Algebra 𝓩 𝑆} → 𝑪 ≤ 𝑩 → 𝑩 ≤ 𝑨 → 𝑪 ≤ 𝑨
≤-trans 𝑨 {𝑩}{𝑪} = ≤-transitivity 𝑨 𝑩 𝑪

\end{code}

Next we prove that if two algebras are isomorphic and one of them is a subalgebra of `𝑨`, then so is the other.

\begin{code}

iso→injective : {𝑨 : Algebra 𝓤 𝑆}{𝑩 : Algebra 𝓦 𝑆}
 →              ((f , _ , _ , _) : 𝑨 ≅ 𝑩) → IsInjective ∣ f ∣
iso→injective {𝑨 = 𝑨} (f , g , f∼g , g∼f) {x}{y} fxfy =
 x                  ≡⟨ (g∼f x)⁻¹ ⟩
 (∣ g ∣ ∘ ∣ f ∣) x  ≡⟨ cong ∣ g ∣ fxfy ⟩
 (∣ g ∣ ∘ ∣ f ∣) y  ≡⟨ g∼f y ⟩
 y                  ∎

≤-iso : (𝑨 : Algebra 𝓧 𝑆){𝑩 : Algebra 𝓨 𝑆}{𝑪 : Algebra 𝓩 𝑆}
 →      𝑪 ≅ 𝑩 → 𝑩 ≤ 𝑨 → 𝑪 ≤ 𝑨

≤-iso 𝑨 {𝑩} {𝑪} CB BA = (g ∘ f , gfhom) , gfinj
 where
  f : ∣ 𝑪 ∣ → ∣ 𝑩 ∣
  f = fst ∣ CB ∣
  g : ∣ 𝑩 ∣ → ∣ 𝑨 ∣
  g = fst ∣ BA ∣

  gfinj : IsInjective (g ∘ f)
  gfinj = ∘-injective (iso→injective CB)(∥ BA ∥)

  gfhom : is-homomorphism 𝑪 𝑨 (g ∘ f)
  gfhom = ∘-is-hom 𝑪 𝑨 {f}{g} (snd ∣ CB ∣) (snd ∣ BA ∣)


≤-trans-≅ : (𝑨 : Algebra 𝓧 𝑆){𝑩 : Algebra 𝓨 𝑆}(𝑪 : Algebra 𝓩 𝑆)
 →          𝑨 ≤ 𝑩 → 𝑨 ≅ 𝑪 → 𝑪 ≤ 𝑩

≤-trans-≅ 𝑨 {𝑩} 𝑪 A≤B B≅C = ≤-iso 𝑩 (≅-sym B≅C) A≤B


≤-TRANS-≅ : (𝑨 : Algebra 𝓧 𝑆){𝑩 : Algebra 𝓨 𝑆}(𝑪 : Algebra 𝓩 𝑆)
 →          𝑨 ≤ 𝑩 → 𝑩 ≅ 𝑪 → 𝑨 ≤ 𝑪
≤-TRANS-≅ 𝑨 𝑪 A≤B B≅C = (∘-hom 𝑨 𝑪 ∣ A≤B ∣ ∣ B≅C ∣) , γ
 where
 γ : IsInjective ∣ (∘-hom 𝑨 𝑪 ∣ A≤B ∣ ∣ B≅C ∣) ∣
 γ = ∘-injective (∥ A≤B ∥)(iso→injective B≅C)


≤-mono : (𝑩 : Algebra 𝓦 𝑆){𝒦 𝒦' : Pred (Algebra 𝓤 𝑆) 𝓩}
 →       𝒦 ⊆ 𝒦' → 𝑩 IsSubalgebraOfClass 𝒦 → 𝑩 IsSubalgebraOfClass 𝒦'

≤-mono 𝑩 KK' KB = ∣ KB ∣ , fst ∥ KB ∥ , KK' (∣ snd ∥ KB ∥ ∣) , ∥ (snd ∥ KB ∥) ∥

\end{code}


#### <a id="lifts-of-subalgebras">Lifts of subalgebras</a>


\begin{code}

module _ {𝒦 : Pred (Algebra 𝓤 𝑆)(ov 𝓤)}{𝑩 : Algebra 𝓤 𝑆} where

 Lift-is-sub : 𝑩 IsSubalgebraOfClass 𝒦 → (Lift-alg 𝑩 𝓤) IsSubalgebraOfClass 𝒦
 Lift-is-sub (𝑨 , (sa , (KA , B≅sa))) = 𝑨 , sa , KA , ≅-trans (≅-sym Lift-≅) B≅sa


Lift-≤ : (𝑨 : Algebra 𝓧 𝑆){𝑩 : Algebra 𝓨 𝑆}{𝓩 : Level} → 𝑩 ≤ 𝑨 → Lift-alg 𝑩 𝓩 ≤ 𝑨
Lift-≤ 𝑨 B≤A = ≤-iso 𝑨 (≅-sym Lift-≅) B≤A

≤-Lift : (𝑨 : Algebra 𝓧 𝑆){𝓩 : Level}{𝑩 : Algebra 𝓨 𝑆} → 𝑩 ≤ 𝑨 → 𝑩 ≤ Lift-alg 𝑨 𝓩
≤-Lift 𝑨 {𝓩} {𝑩} B≤A = ≤-TRANS-≅ 𝑩 {𝑨} (Lift-alg 𝑨 𝓩) B≤A Lift-≅


module _ {𝓧 𝓨 𝓩 𝓦 : Level} where

 Lift-≤-Lift : {𝑨 : Algebra 𝓧 𝑆}(𝑩 : Algebra 𝓨 𝑆) → 𝑨 ≤ 𝑩 → Lift-alg 𝑨 𝓩 ≤ Lift-alg 𝑩 𝓦
 Lift-≤-Lift {𝑨} 𝑩 A≤B = ≤-trans (Lift-alg 𝑩 𝓦) (≤-trans 𝑩 lAA A≤B) B≤lB
   where

   lAA : (Lift-alg 𝑨 𝓩) ≤ 𝑨
   lAA = Lift-≤ 𝑨 {𝑨} ≤-refl

   B≤lB : 𝑩 ≤ Lift-alg 𝑩 𝓦
   B≤lB = ≤-Lift 𝑩 ≤-refl

\end{code}


---------------------------------

<sup>1</sup> <span class="footnote" id="fn1">An alternative which could end up being simpler and easier to work with would be to proclaim that `𝑩` is a subalgebra of `𝑨` iff there is a *monic* homomorphism from `𝐵` into `𝑨`. In preparation for the next major release of the [UniversalAlgebra][] library, we will investigate the consequences of taking that path instead of the stricter embedding requirement we chose for the definition of the type `IsSubalgebraOf`.</span>

<sup>2</sup> <span class="footnote" id="fn2"> Recall, in the [Relations.Quotients][] module, we defined *preorder* for binary relation types. Here, however, we will content ourselves with merely proving reflexivity and transitivity of the subalgebra relation `_≤_`, without worry about first defining it as an inhabitant of an honest-to-goodness binary relation type, of the sort introduced in the [Relations.Discrete][] module. Perhaps we will address this matter in a future release of the [UniversalAlgebra][] library.</span>

<br>
<br>

[← Subalgebras.Subuniverses](Subalgebras.Subuniverses.html)
<span style="float:right;">[Varieties →](Varieties.html)</span>

{% include UALib.Links.md %}