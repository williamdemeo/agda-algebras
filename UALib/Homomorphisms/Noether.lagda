---
layout: default
title : Homomorphisms.Noether module (The Agda Universal Algebra Library)
date : 2021-01-13
author: William DeMeo
---

### <a id="homomorphism-theorems">Homomorphism Theorems</a>

This chapter presents the [Homomorphisms.Noether][] module of the [Agda Universal Algebra Library][].

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import Algebras.Signatures using (Signature; 𝓞; 𝓥)
open import MGS-Subsingleton-Theorems using (global-dfunext)

module Homomorphisms.Noether {𝑆 : Signature 𝓞 𝓥} where

open import Homomorphisms.Basic{𝑆 = 𝑆} public

\end{code}


#### <a id="the-first-homomorphism-theorem">The First Homomorphism Theorem</a>

Here we formalize a version of the *first homomorphism theorem*, sometimes called *Noether's first homomorphism theorem*, after Emmy Noether who was among the first proponents of the abstract approach to the subject that we now call "modern algebra").

Informally, the theorem states that every homomorphism from `𝑨` to `𝑩` (`𝑆`-algebras) factors through the quotient algebra `𝑨 ╱ ker h` (`𝑨` modulo the kernel of the given homomorphism).  In other terms, given `h : hom 𝑨 𝑩` there exists `φ : hom (𝑨 ╱ ker h) 𝑩` which, when composed with the canonical projection `πker : 𝑨 ↠ 𝑨 ╱ ker h`, is equal to `h`; that is, `h = φ ∘ πker`.  Moreover, `φ` is a *monomorphism* (injective homomorphism) and is unique.

Our formal proof of this theorem will require function extensionality as well as a couple of truncation assumptions. The function extensionality postulate (`fe`) will be clear enough.  As for truncation, proving that `φ` is monic will require the following postulates:<sup>[1](Homomorphisms.Noether.html#fn1)</sup>

+ *Uniqueness of (kernel) Relation Proofs* (`URPk`): the kernel of `h` inhabits the type `Pred₂` of *binary propositions* so there is at most one proof that a given pair belongs to the kernel relation;
+ *Uniqueness of (block) Identity Proofs* (`UIPb`): given any pair of blocks of the kernel there is at most one proof that the given blocks are equal;

And proving that `φ` is an embedding requires

+ *Uniqueness of (codomain) Identity Proofs* (`UIPc`): the codomain `∣ 𝑩 ∣` is a *set*, that is, has unique identity proofs.

Note that the classical, informal statement of the theorem does not demand that `φ` be an embedding (in our sense of having subsingleton fibers), and if we left this out of the consequent of the formal theorem statement below, then we could omit from the antecedent the assumption that ∣ 𝑩 ∣ is a set.

Without further ado, we present our formalization of the first homomorphism theorem.<sup>[2](Homomorphisms.Noether.html#fn2)</sup>

\begin{code}

open Congruence

module first-hom-thm {𝓤 𝓦 : Universe}(𝑨 : Algebra 𝓤 𝑆)(𝑩 : Algebra 𝓦 𝑆)(h : hom 𝑨 𝑩)
 -- extensionality assumptions:
    (pe : prop-ext 𝓤 𝓦)(fe : dfunext 𝓥 𝓦)

 -- truncation assumptions:
    (UIPc : is-set ∣ 𝑩 ∣)
    (URPk : ∀ a x → is-subsingleton (⟨ kercon fe 𝑩 h ⟩ a x))
    (UIPb : ∀ C → is-subsingleton (𝒞 ⟨ kercon fe 𝑩 h ⟩ C))
 where

 FirstHomomorphismTheorem :
  Σ φ ꞉ hom ((𝑨 [ 𝑩 ]/ker h) {fe}) 𝑩 , (∣ h ∣ ≡ ∣ φ ∣ ∘ ∣ πker 𝑩 h {fe} ∣) × Monic ∣ φ ∣ × is-embedding ∣ φ ∣

 FirstHomomorphismTheorem = (φ , φhom) , φcom , φmon , φemb
  where
  θ : Congruence 𝑨
  θ = kercon fe 𝑩 h

  φ : ∣ (𝑨 [ 𝑩 ]/ker h) {fe} ∣ → ∣ 𝑩 ∣
  φ a = ∣ h ∣ ⌜ a ⌝

  𝑹 : Pred₂ ∣ 𝑨 ∣ 𝓦
  𝑹 = ⟨ kercon fe 𝑩 h ⟩ , URPk

  φhom : is-homomorphism ((𝑨 [ 𝑩 ]/ker h){fe}) 𝑩 φ
  φhom 𝑓 𝒂 =  ∣ h ∣ ( (𝑓 ̂ 𝑨) (λ x → ⌜ 𝒂 x ⌝) ) ≡⟨ ∥ h ∥ 𝑓 (λ x → ⌜ 𝒂 x ⌝)  ⟩
             (𝑓 ̂ 𝑩) (∣ h ∣ ∘ (λ x → ⌜ 𝒂 x ⌝)) ≡⟨ ap (𝑓 ̂ 𝑩) (fe λ x → refl) ⟩
             (𝑓 ̂ 𝑩) (λ x → φ (𝒂 x))             ∎

  φmon : Monic φ
  φmon (.(⟨ θ ⟩ u) , u , refl) (.(⟨ θ ⟩ v) , v , refl) φuv =
   class-extensionality' {𝑹 = 𝑹} pe UIPb (IsEquiv θ) φuv

  φcom : ∣ h ∣ ≡ φ ∘ ∣ πker 𝑩 h {fe} ∣
  φcom = refl

  φemb : is-embedding φ
  φemb = monic-is-embedding|sets φ UIPc φmon

\end{code}

Below we will prove that the homomorphism `φ`, whose existence we just proved, is unique (see `NoetherHomUnique`).
But first we show that if we add that `h` is epic to the hypotheses of the first homomorphism theorem, then we get the so-called *first isomorphism theorem*.

\begin{code}

 FirstIsomorphismTheorem : dfunext 𝓦 𝓦 → Epic ∣ h ∣

  →    Σ f ꞉ (epi ((𝑨 [ 𝑩 ]/ker h) {fe}) 𝑩) , (∣ h ∣ ≡ ∣ f ∣ ∘ ∣ πker 𝑩 h {fe} ∣) × is-embedding ∣ f ∣

 FirstIsomorphismTheorem fev hE = (fmap , fhom , fepic) , refl , femb
  where
  θ : Congruence 𝑨
  θ = kercon fe 𝑩 h

  fmap : ∣ (𝑨 [ 𝑩 ]/ker h){fe} ∣ → ∣ 𝑩 ∣
  fmap ⟪a⟫ = ∣ h ∣ ⌜ ⟪a⟫ ⌝

  fhom : is-homomorphism ((𝑨 [ 𝑩 ]/ker h){fe}) 𝑩 fmap
  fhom 𝑓 𝒂 =  ∣ h ∣((𝑓 ̂ 𝑨) λ x → ⌜ 𝒂 x ⌝)   ≡⟨ ∥ h ∥ 𝑓 (λ x → ⌜ 𝒂 x ⌝)  ⟩
              (𝑓 ̂ 𝑩)(∣ h ∣ ∘ λ x → ⌜ 𝒂 x ⌝) ≡⟨ ap(𝑓 ̂ 𝑩)(fe λ _ → refl)⟩
              (𝑓 ̂ 𝑩) (fmap ∘ 𝒂)              ∎

  fepic : Epic fmap
  fepic b = γ where
   a : ∣ 𝑨 ∣
   a = EpicInv ∣ h ∣ hE b

   bfa : b ≡ fmap ⟪ a ⟫
   bfa = (cong-app (EpicInvIsRightInv {fe = fev} ∣ h ∣ hE) b)⁻¹

   γ : Image fmap ∋ b
   γ = Image_∋_.eq b ⟪ a ⟫ bfa

  fmon : Monic fmap
  fmon (.(⟨ θ ⟩ u) , u , refl) (.(⟨ θ ⟩ v) , v , refl) fuv =
   class-extensionality' {𝑹 = ⟨ kercon fe 𝑩 h ⟩ , URPk} pe UIPb (IsEquiv θ) fuv

  femb : is-embedding fmap
  femb = monic-is-embedding|sets fmap UIPc fmon

\end{code}

Now we prove that the homomorphism `φ`, whose existence is guaranteed by `FirstHomomorphismTheorem`, is unique.

\begin{code}

module _ {𝓤 𝓦 : Universe}(fe : dfunext 𝓥 𝓦)(𝑨 : Algebra 𝓤 𝑆)(𝑩 : Algebra 𝓦 𝑆)(h : hom 𝑨 𝑩) where

 NoetherHomUnique : (f g : hom ((𝑨 [ 𝑩 ]/ker h) {fe} ) 𝑩)
  →                 ∣ h ∣ ≡ ∣ f ∣ ∘ ∣ πker 𝑩 h {fe} ∣ → ∣ h ∣ ≡ ∣ g ∣ ∘ ∣ πker 𝑩 h {fe} ∣
                    ------------------------------------------------------------------------
  →                 ∀ a  →  ∣ f ∣ a ≡ ∣ g ∣ a

 NoetherHomUnique f g hfk hgk (.(⟨ kercon fe 𝑩 h ⟩ a) , a , refl) =
  ∣ f ∣ (⟨ kercon fe 𝑩 h ⟩ a , a , refl) ≡⟨ cong-app(hfk ⁻¹)a ⟩
  ∣ h ∣ a                                ≡⟨ cong-app(hgk)a ⟩
  ∣ g ∣ (⟨ kercon fe 𝑩 h ⟩ a , a , refl) ∎

\end{code}

If, in addition, we postulate extensionality of functions defined on the domain `𝑨 [ 𝑩 ]/ker h`, then we obtain the following variation of the last result.<sup>[1](Homomorphisms.Noether.html#fn1)</sup>

\begin{code}

 fe-NoetherHomUnique : funext (𝓤 ⊔ 𝓦 ⁺) 𝓦 → (f g : hom ((𝑨 [ 𝑩 ]/ker h){fe}) 𝑩)
  →                    ∣ h ∣ ≡ ∣ f ∣ ∘ ∣ πker 𝑩 h {fe} ∣ → ∣ h ∣ ≡ ∣ g ∣ ∘ ∣ πker 𝑩 h {fe} ∣
                       ----------------------------------------------------------------------
  →                    ∣ f ∣ ≡ ∣ g ∣

 fe-NoetherHomUnique qfe f g hfk hgk = qfe (NoetherHomUnique f g hfk hgk)

\end{code}

Clearly the proof of `NoetherHomUnique` goes through for the special case of epimorphisms. Indeed, the epimorphism `f` found in the isomorphism theorem above is unique as we now verify.

\begin{code}

 NoetherIsoUnique : (f g : epi ((𝑨 [ 𝑩 ]/ker h){fe}) 𝑩)
  →                 ∣ h ∣ ≡ ∣ f ∣ ∘ ∣ πker 𝑩 h{fe} ∣ → ∣ h ∣ ≡ ∣ g ∣ ∘ ∣ πker 𝑩 h{fe} ∣
                    ---------------------------------------------------------------------
  →                 ∀ a → ∣ f ∣ a ≡ ∣ g ∣ a

 NoetherIsoUnique f g hfk hgk = NoetherHomUnique (epi-to-hom 𝑩 f) (epi-to-hom 𝑩 g) hfk hgk

\end{code}





#### <a id="homomorphism-composition">Homomorphism composition</a>

The composition of homomorphisms is again a homomorphism.  We formalize this in a number of alternative ways.

\begin{code}

module _ {𝓧 𝓨 𝓩 : Universe} (𝑨 : Algebra 𝓧 𝑆){𝑩 : Algebra 𝓨 𝑆}(𝑪 : Algebra 𝓩 𝑆) where

 ∘-hom : hom 𝑨 𝑩  →  hom 𝑩 𝑪  →  hom 𝑨 𝑪

 ∘-hom (g , ghom) (h , hhom) = h ∘ g , γ where

  γ : ∀ 𝑓 a → (h ∘ g)((𝑓 ̂ 𝑨) a) ≡ (𝑓 ̂ 𝑪)(h ∘ g ∘ a)

  γ 𝑓 a = (h ∘ g) ((𝑓 ̂ 𝑨) a) ≡⟨ ap h ( ghom 𝑓 a ) ⟩
          h ((𝑓 ̂ 𝑩) (g ∘ a)) ≡⟨ hhom 𝑓 ( g ∘ a ) ⟩
          (𝑓 ̂ 𝑪) (h ∘ g ∘ a) ∎


 ∘-is-hom : {f : ∣ 𝑨 ∣ → ∣ 𝑩 ∣} {g : ∣ 𝑩 ∣ → ∣ 𝑪 ∣}
  →         is-homomorphism 𝑨 𝑩 f → is-homomorphism 𝑩 𝑪 g
  →         is-homomorphism 𝑨 𝑪 (g ∘ f)

 ∘-is-hom {f} {g} fhom ghom = ∥ ∘-hom (f , fhom) (g , ghom) ∥

\end{code}



#### <a id="homomorphism-decomposition">Homomorphism decomposition</a>

If `g : hom 𝑨 𝑩`, `h : hom 𝑨 𝑪`, `h` is surjective, and `ker h ⊆ ker g`, then there exists `φ : hom 𝑪 𝑩` such that `g = φ ∘ h`, that is, such that the following diagram commutes;

```
𝑨---- h -->>𝑪
 \         .
  \       .
   g     ∃φ
    \   .
     \ .
      V
      𝑩
```

This, or some variation of it, is sometimes referred to as the Second Isomorphism Theorem.  We formalize its statement and proof as follows. (Notice that the proof is constructive.)

\begin{code}

homFactor : {𝓤 : Universe} → funext 𝓤 𝓤 → {𝑨 𝑩 𝑪 : Algebra 𝓤 𝑆}
            (g : hom 𝑨 𝑩) (h : hom 𝑨 𝑪)
 →          kernel ∣ h ∣ ⊆ kernel ∣ g ∣  →   Epic ∣ h ∣
            -------------------------------------------
 →          Σ φ ꞉ (hom 𝑪 𝑩) , ∣ g ∣ ≡ ∣ φ ∣ ∘ ∣ h ∣

homFactor fe{𝑨}{𝑩}{𝑪}(g , ghom)(h , hhom) Kh⊆Kg hEpi = (φ , φIsHomCB) , gφh
 where
 hInv : ∣ 𝑪 ∣ → ∣ 𝑨 ∣
 hInv = λ c → (EpicInv h hEpi) c

 φ : ∣ 𝑪 ∣ → ∣ 𝑩 ∣
 φ = λ c → g ( hInv c )

 ξ : ∀ x → kernel h (x , hInv (h x))
 ξ x = (cong-app (EpicInvIsRightInv {fe = fe} h hEpi) (h x))⁻¹

 gφh : g ≡ φ ∘ h
 gφh = fe  λ x → Kh⊆Kg (ξ x)

 ζ : (𝑓 : ∣ 𝑆 ∣)(𝒄 : ∥ 𝑆 ∥ 𝑓 → ∣ 𝑪 ∣)(x : ∥ 𝑆 ∥ 𝑓) →  𝒄 x ≡ (h ∘ hInv)(𝒄 x)
 ζ  𝑓 𝒄 x = (cong-app (EpicInvIsRightInv {fe = fe} h hEpi) (𝒄 x))⁻¹

 ι : (𝑓 : ∣ 𝑆 ∣)(𝒄 : ∥ 𝑆 ∥ 𝑓 → ∣ 𝑪 ∣) →  𝒄 ≡ h ∘ (hInv ∘ 𝒄)
 ι 𝑓 𝒄 = ap (λ - → - ∘ 𝒄)(EpicInvIsRightInv {fe = fe} h hEpi)⁻¹

 useker : ∀ 𝑓 𝒄 → g(hInv (h((𝑓 ̂ 𝑨)(hInv ∘ 𝒄)))) ≡ g((𝑓 ̂ 𝑨)(hInv ∘ 𝒄))
 useker 𝑓 c = Kh⊆Kg (cong-app (EpicInvIsRightInv{fe = fe} h hEpi)
                              (h ((𝑓 ̂ 𝑨)(hInv ∘ c))) )

 φIsHomCB : (𝑓 : ∣ 𝑆 ∣)(𝒄 : ∥ 𝑆 ∥ 𝑓 → ∣ 𝑪 ∣) → φ((𝑓 ̂ 𝑪) 𝒄) ≡ (𝑓 ̂ 𝑩)(φ ∘ 𝒄)

 φIsHomCB 𝑓 𝒄 =  g (hInv ((𝑓 ̂ 𝑪) 𝒄))              ≡⟨ i   ⟩
                g (hInv ((𝑓 ̂ 𝑪)(h ∘ (hInv ∘ 𝒄)))) ≡⟨ ii  ⟩
                g (hInv (h ((𝑓 ̂ 𝑨)(hInv ∘ 𝒄))))   ≡⟨ iii ⟩
                g ((𝑓 ̂ 𝑨)(hInv ∘ 𝒄))              ≡⟨ iv  ⟩
                (𝑓 ̂ 𝑩)(λ x → g (hInv (𝒄 x)))      ∎
  where
  i   = ap (g ∘ hInv) (ap (𝑓 ̂ 𝑪) (ι 𝑓 𝒄))
  ii  = ap (g ∘ hInv) (hhom 𝑓 (hInv ∘ 𝒄))⁻¹
  iii = useker 𝑓 𝒄
  iv  = ghom 𝑓 (hInv ∘ 𝒄)

\end{code}

Here's a more general version.

```
𝑨 --- γ ->> 𝑪
 \         .
  \       .
   β     ∃φ
    \   .
     \ .
      V
      𝑩
```

\begin{code}

module _ {𝓧 𝓨 𝓩 : Universe}(fe : funext 𝓧 𝓨)(fey : funext 𝓨 𝓨)(fez : funext 𝓩 𝓩)
         (𝑨 : Algebra 𝓧 𝑆){𝑩 : Algebra 𝓨 𝑆}{𝑪 : Algebra 𝓩 𝑆}(α : hom 𝑨 𝑩) (β : hom 𝑨 𝑪)
 where

 HomFactor : Epic ∣ β ∣ → kernel ∣ β ∣ ⊆ kernel ∣ α ∣ → Σ φ ꞉ (hom 𝑪 𝑩) , ∣ α ∣ ≡ ∣ φ ∣ ∘ ∣ β ∣
 HomFactor βE Kβα = (φ , φIsHomCB) , αφβ
  where
  βInv : ∣ 𝑪 ∣ → ∣ 𝑨 ∣
  βInv = λ y → (EpicInv ∣ β ∣ βE) y

  φ : ∣ 𝑪 ∣ → ∣ 𝑩 ∣
  φ = λ y → ∣ α ∣ ( βInv y )

  ξ : (x : ∣ 𝑨 ∣) → kernel ∣ β ∣ (x , βInv (∣ β ∣ x))
  ξ x =  ( cong-app (EpicInvIsRightInv {fe = fez} ∣ β ∣ βE) ( ∣ β ∣ x ) )⁻¹

  αφβ : ∣ α ∣ ≡ φ ∘ ∣ β ∣
  αφβ = fe λ x → Kβα (ξ x)

  ι : (𝑓 : ∣ 𝑆 ∣)(𝒄 : ∥ 𝑆 ∥ 𝑓 → ∣ 𝑪 ∣) → 𝒄 ≡  ∣ β ∣ ∘ (βInv ∘ 𝒄)
  ι 𝑓 𝒄 = ap (λ - → - ∘ 𝒄) (EpicInvIsRightInv{fe = fez} ∣ β ∣ βE)⁻¹

  useker : ∀ 𝑓 𝒄 → ∣ α ∣ (βInv (∣ β ∣((𝑓 ̂ 𝑨)(βInv ∘ 𝒄)))) ≡ ∣ α ∣((𝑓 ̂ 𝑨)(βInv ∘ 𝒄))
  useker 𝑓 𝒄 = Kβα (cong-app (EpicInvIsRightInv {fe = fez} ∣ β ∣ βE)
                             (∣ β ∣ ((𝑓 ̂ 𝑨)(βInv ∘ 𝒄))))

  φIsHomCB : ∀ 𝑓 𝒄 → φ ((𝑓 ̂ 𝑪) 𝒄) ≡ ((𝑓 ̂ 𝑩)(φ ∘ 𝒄))

  φIsHomCB 𝑓 𝒄 = ∣ α ∣ (βInv ((𝑓 ̂ 𝑪) 𝒄))                   ≡⟨ i   ⟩
                ∣ α ∣ (βInv ((𝑓 ̂ 𝑪)(∣ β ∣ ∘ (βInv ∘ 𝒄)))) ≡⟨ ii  ⟩
                ∣ α ∣ (βInv (∣ β ∣ ((𝑓 ̂ 𝑨)(βInv ∘ 𝒄))))   ≡⟨ iii ⟩
                ∣ α ∣ ((𝑓 ̂ 𝑨)(βInv ∘ 𝒄))                  ≡⟨ iv  ⟩
                ((𝑓 ̂ 𝑩)(λ x → ∣ α ∣ (βInv (𝒄 x))))        ∎
   where
   i   = ap (∣ α ∣ ∘ βInv) (ap (𝑓 ̂ 𝑪) (ι 𝑓 𝒄))
   ii  = ap (∣ α ∣ ∘ βInv) (∥ β ∥ 𝑓 (βInv ∘ 𝒄))⁻¹
   iii = useker 𝑓 𝒄
   iv  = ∥ α ∥ 𝑓 (βInv ∘ 𝒄)

\end{code}

If, in addition, both α and β are epic, then so is φ.

\begin{code}

 HomFactorEpi : (αe : Epic ∣ α ∣)(βe : Epic ∣ β ∣) → kernel ∣ β ∣ ⊆ kernel ∣ α ∣
  →             Σ φ ꞉ (epi 𝑪 𝑩) , ∣ α ∣ ≡ ∣ φ ∣ ∘ ∣ β ∣

 HomFactorEpi αe βe kerincl = (fst ∣ φF ∣ , (snd ∣ φF ∣ , φE)) , ∥ φF ∥
  where
  φF : Σ φ ꞉ (hom 𝑪 𝑩) , ∣ α ∣ ≡ ∣ φ ∣ ∘ ∣ β ∣
  φF = HomFactor βe kerincl

  βinv : ∣ 𝑪 ∣ → ∣ 𝑨 ∣
  βinv = λ c → (EpicInv ∣ β ∣ βe) c

  αinv : ∣ 𝑩 ∣ → ∣ 𝑨 ∣
  αinv = λ b → (EpicInv ∣ α ∣ αe) b

  φ : ∣ 𝑪 ∣ → ∣ 𝑩 ∣
  φ = λ c → ∣ α ∣ ( βinv c )

  φE : Epic φ
  φE = epic-factor {fe = fey} ∣ α ∣ ∣ β ∣ φ ∥ φF ∥ αe

\end{code}


--------------------------------------

<sup>1</sup><span class="footnote" id="fn1"> See [Relations.Truncation][] for a discussion of *truncation*, *sets*, and *uniqueness of proofs*.</span>

<sup>2</sup><span class="footnote" id="fn2"> In this module we are already assuming *global* function extensionality (`gfe`), and we could just appeal to `gfe` (e.g., in the proof of `FirstHomomorphismTheorem`) instead of adding local function extensionality (\ab{fe}) to the list of assumptions.  However, we sometimes add an extra extensionality postulate in order to highlight where and how the principle is applied.}</span>

<br>
<br>

[← Homomorphisms.Basic](Homomorphisms.Basic.html)
<span style="float:right;">[Homomorphisms.Isomorphisms →](Homomorphisms.Isomorphisms.html)</span>

{% include UALib.Links.md %}
