--FILE: closure.agda
--AUTHOR: William DeMeo and Siva Somayyajula
--DATE: 4 Aug 2020

{-# OPTIONS --without-K --exact-split --safe #-}

open import basic
open import congruences
open import prelude using (global-dfunext; dfunext; 𝓤ω)

module closure
 {𝑆 : Signature 𝓞 𝓥}
 {𝕏 : {𝓤 𝓧 : Universe}{X : 𝓧 ̇}(𝑨 : Algebra 𝓤 𝑆) → X ↠ 𝑨}
 {gfe : global-dfunext} where

open import homomorphisms {𝑆 = 𝑆} public

open import subuniverses
 {𝑆 = 𝑆}
 {𝕏 = 𝕏}
 {fe = gfe}

open import terms
 {𝑆 = 𝑆}
 {𝕏 = 𝕏}
 {gfe = gfe} renaming (generator to ℊ) public

_⊧_≈_ : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → Algebra 𝓦 𝑆
 →      Term{𝓤}{X} → Term{𝓤}{X} → 𝓤 ⊔ 𝓦 ̇

𝑨 ⊧ p ≈ q = (p ̇ 𝑨) ≡ (q ̇ 𝑨)

_⊧_≋_ : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
 →      Pred (Algebra 𝓦 𝑆) (𝓦 ⁺)
 →      Term{𝓤}{X} → Term → 𝓞 ⊔ 𝓥 ⊔ 𝓤 ⊔ 𝓦 ⁺ ̇

_⊧_≋_ {𝓤} {𝓦} 𝒦 p q = {𝑨 : Algebra 𝓦 𝑆} → 𝒦 𝑨 → 𝑨 ⊧ p ≈ q


----------------------------------------------------------------------
--Closure under products
data PClo {𝓤 : Universe}(𝒦 : Pred (Algebra 𝓤 𝑆) 𝓤) : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) where
 pbase : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ PClo 𝒦
 prod : {I : 𝓤 ̇ }{𝒜 : I → Algebra _ 𝑆}
  →     (∀ i → 𝒜 i ∈ PClo 𝒦)
  →     ⨅ 𝒜 ∈ PClo 𝒦

P-closed : (ℒ𝒦 : (𝓣 : Universe) → Pred (Algebra 𝓣 𝑆) (𝓣 ⁺ ))
 →      (𝓘 : Universe)(I : 𝓘 ̇ ) (𝒜 : I → Algebra 𝓘 𝑆)
 →      (( i : I ) → 𝒜 i ∈ ℒ𝒦 𝓘 ) → 𝓘 ⁺ ̇
P-closed ℒ𝒦 = λ 𝓘 I 𝒜 𝒜i∈ℒ𝒦 →  ⨅ 𝒜  ∈ (ℒ𝒦 𝓘)

----------------------------------------------------------------------
--Closure under subalgebras
data SClo {𝓤 : Universe} (𝒦 : Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)) :
 Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) where
  sbase : {𝑨 : Algebra 𝓤 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ SClo 𝒦
  sub : {𝑨 : Algebra 𝓤 𝑆} → 𝑨 ∈ SClo 𝒦 → (sa : SubalgebrasOf 𝑨) → ∣ sa ∣ ∈ SClo 𝒦

S-closed : (ℒ𝒦 : (𝓤 : Universe) → Pred (Algebra 𝓤 𝑆) (𝓤 ⁺))
 →         (𝓤 : Universe) → (𝑩 : Algebra 𝓤 𝑆) → 𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺ ̇
S-closed ℒ𝒦 =
 λ 𝓤 B → (B is-subalgebra-of-class (ℒ𝒦 𝓤)) → (B ∈ ℒ𝒦 𝓤)

----------------------------------------------------------------------
--Closure under hom images
data HClo {𝓤 : Universe} (𝒦 : Pred (Algebra 𝓤 𝑆)(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)) :
 Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) where
  hbase : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ HClo 𝒦
  hhom : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ HClo 𝒦 → ((𝑩 , _ ) : HomImagesOf 𝑨) → 𝑩 ∈ HClo 𝒦

------------------------------------------------------------------------
-- Equational theories and classes
TH : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
 →   Pred (Algebra 𝓦 𝑆) (𝓦 ⁺)  → _ ̇
TH {𝓤}{𝓦}{X} 𝒦 = Σ (p , q) ꞉ (Term{𝓤}{X} × Term{𝓤}{X}) , 𝒦 ⊧ p ≋ q

Th : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
 →   Pred (Algebra 𝓦 𝑆) (𝓦 ⁺)
 →   Pred (Term{𝓤}{X} × Term{𝓤}{X}) _
Th 𝒦 = λ (p , q) → 𝒦 ⊧ p ≋ q

MOD : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
      (ℰ : Pred (Term{𝓤}{X} × Term{𝓤}{X}) 𝓤)
 →    𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺ ⊔ 𝓦 ⁺ ̇

MOD {𝓤}{𝓦} ℰ =
 Σ A ꞉ (Algebra 𝓦 𝑆) ,
    ∀ p q → (p , q) ∈ ℰ → A ⊧ p ≈ q

Mod : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
 →    Pred (Term{𝓤}{X} × Term{𝓤}{X}) 𝓤
 →    Pred (Algebra 𝓦 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺ ⊔ 𝓦)

Mod {𝓤}{𝓦} ℰ =
 λ A → ∀ p q → (p , q) ∈ ℰ → A ⊧ p ≈ q

products-preserve-identities :
       {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
       {fevw : dfunext 𝓥 𝓦}
       (p q : Term{𝓤}{X})
       (I : 𝓦 ̇ ) (𝒜 : I → Algebra 𝓦 𝑆)
  →    ((i : I) → (𝒜 i) ⊧ p ≈ q)
      -----------------------------------
  →     ⨅ 𝒜 ⊧ p ≈ q

products-preserve-identities
 {𝓤}{𝓦}{X}{fevw} p q I 𝒜 𝒜⊧p≈q = γ
  where
   γ : (p ̇ ⨅ 𝒜) ≡ (q ̇ ⨅ 𝒜)
   γ = gfe λ a →
    (p ̇ ⨅ 𝒜) a
        ≡⟨ interp-prod{𝓤}{𝓦} fevw p 𝒜 a ⟩
    (λ i → ((p ̇ (𝒜 i)) (λ x → (a x) i)))
        ≡⟨ gfe (λ i → cong-app (𝒜⊧p≈q i) (λ x → (a x) i)) ⟩
    (λ i → ((q ̇ (𝒜 i)) (λ x → (a x) i)))
        ≡⟨ (interp-prod gfe q 𝒜 a)⁻¹ ⟩
    (q ̇ ⨅ 𝒜) a
        ∎

products-in-class-preserve-identities :
      {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
      {fevw : dfunext 𝓥 𝓦}
      (𝒦 : Pred (Algebra 𝓦 𝑆) (𝓦 ⁺))
      (p q : Term{𝓤}{X})
      (I : 𝓦 ̇ ) (𝒜 : I → Algebra 𝓦 𝑆)
  →   𝒦 ⊧ p ≋ q  →  ((i : I) → 𝒜 i ∈ 𝒦)
      ------------------------------------
  →    ⨅ 𝒜 ⊧ p ≈ q

products-in-class-preserve-identities
 {𝓤}{𝓦}{X}{fevw} 𝒦 p q I 𝒜 𝒦⊧p≋q all𝒜i∈𝒦 = γ
  where
   𝒜⊧p≈q : ∀ i → (𝒜 i) ⊧ p ≈ q
   𝒜⊧p≈q i = 𝒦⊧p≋q (all𝒜i∈𝒦 i)

   γ : (p ̇ ⨅ 𝒜) ≡ (q ̇ ⨅ 𝒜)
   γ = products-preserve-identities {𝓤}{𝓦}{X}{fevw} p q I 𝒜 𝒜⊧p≈q

module subalgebra-compatibility
 {𝓤 : Universe}
 {X : 𝓤 ̇ } where

 subalgebras-preserve-identities :
     (𝒦 : Pred (Algebra 𝓤 𝑆)(𝓤 ⁺))
     (p q : Term)
     (p≋q : 𝒦 ⊧ p ≋ q)
     (SAK : SubalgebrasOfClass 𝒦)
    ----------------------------------
  →  (pr₁ ∥ (pr₂ SAK) ∥) ⊧ p ≈ q

 subalgebras-preserve-identities 𝒦 p q p≋q SAK = γ
  where

   𝑨 : Algebra 𝓤 𝑆
   𝑨 = ∣ SAK ∣

   A∈𝒦 : 𝑨 ∈ 𝒦
   A∈𝒦 = ∣ pr₂ SAK ∣

   A⊧p≈q : 𝑨 ⊧ p ≈ q
   A⊧p≈q = p≋q A∈𝒦

   subalg : SubalgebrasOf 𝑨
   subalg = ∥ pr₂ SAK ∥

   𝑩 : Algebra 𝓤 𝑆
   𝑩 = pr₁ subalg

   h : ∣ 𝑩 ∣ → ∣ 𝑨 ∣
   h = ∣ pr₂ subalg ∣

   hem : is-embedding h
   hem = pr₁ ∥ pr₂ subalg ∥

   hhm : is-homomorphism 𝑩 𝑨 h
   hhm = pr₂ ∥ pr₂ subalg ∥

   ξ : (b : X → ∣ 𝑩 ∣ ) → h ((p ̇ 𝑩) b) ≡ h ((q ̇ 𝑩) b)
   ξ b =
    h ((p ̇ 𝑩) b)  ≡⟨ comm-hom-term gfe 𝑩 𝑨 (h , hhm) p b ⟩
    (p ̇ 𝑨)(h ∘ b) ≡⟨ intensionality A⊧p≈q (h ∘ b) ⟩
    (q ̇ 𝑨)(h ∘ b) ≡⟨ (comm-hom-term gfe 𝑩 𝑨 (h , hhm) q b)⁻¹ ⟩
    h ((q ̇ 𝑩) b)  ∎

   hlc : {b b' : domain h} → h b ≡ h b' → b ≡ b'
   hlc hb≡hb' = (embeddings-are-lc h hem) hb≡hb'

   γ : 𝑩 ⊧ p ≈ q
   γ = gfe λ b → hlc (ξ b)



-- ⇒ (the "only if" direction)
identities-compatible-with-homs :
        {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
        {fevw : funext 𝓥 𝓦}
        {𝒦 : Pred (Algebra 𝓦 𝑆) (𝓦 ⁺)}
        (p q : Term{𝓤}{X})
        (p≋q : 𝒦 ⊧ p ≋ q)
       ----------------------------------------------------
 →     ∀ (𝑨 : Algebra 𝓦 𝑆)
         (KA : 𝒦 𝑨)
         (h : hom (𝑻{𝓤}{X}) 𝑨)
        → ∣ h ∣ ∘ (p ̇ 𝑻{𝓤}{X}) ≡ ∣ h ∣ ∘ (q ̇ 𝑻)

identities-compatible-with-homs
 {𝓤}{𝓦}{X}{fevw} {𝒦} p q p≋q 𝑨 KA h = γ
  where
   pA≡qA : p ̇ 𝑨 ≡ q ̇ 𝑨
   pA≡qA = p≋q KA

   pAh≡qAh : ∀(𝒂 : X → ∣ 𝑻 ∣ )
    →        (p ̇ 𝑨)(∣ h ∣ ∘ 𝒂) ≡ (q ̇ 𝑨)(∣ h ∣ ∘ 𝒂)
   pAh≡qAh 𝒂 = intensionality pA≡qA (∣ h ∣ ∘ 𝒂)

   hpa≡hqa : ∀(𝒂 : X → ∣ 𝑻 ∣ )
    →        ∣ h ∣ ((p ̇ 𝑻) 𝒂) ≡ ∣ h ∣ ((q ̇ 𝑻) 𝒂)
   hpa≡hqa 𝒂 =
    ∣ h ∣ ((p ̇ 𝑻) 𝒂)  ≡⟨ comm-hom-term{𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺}{𝓦}{𝓤}{X} fevw (𝑻{𝓤}{X}) 𝑨 h p 𝒂 ⟩
    (p ̇ 𝑨)(∣ h ∣ ∘ 𝒂) ≡⟨ pAh≡qAh 𝒂 ⟩
    (q ̇ 𝑨)(∣ h ∣ ∘ 𝒂) ≡⟨ (comm-hom-term{𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺}{𝓦}{𝓤}{X} fevw 𝑻 𝑨 h q 𝒂)⁻¹ ⟩
    ∣ h ∣ ((q ̇ 𝑻) 𝒂)  ∎

   γ : ∣ h ∣ ∘ (p ̇ 𝑻) ≡ ∣ h ∣ ∘ (q ̇ 𝑻)
   γ = gfe hpa≡hqa


-- ⇐ (the "if" direction)
homs-compatible-with-identities :
        {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
        {fevw : funext 𝓥 𝓦}
        {𝒦 : Pred (Algebra 𝓦 𝑆) (𝓦 ⁺)}
        (p q : Term{𝓤}{X})
        (hp≡hq : ∀ (𝑨 : Algebra 𝓦 𝑆)
                   (KA : 𝑨 ∈ 𝒦)
                   (h : hom (𝑻{𝓤}{X}) 𝑨)
                  → ∣ h ∣ ∘ (p ̇ 𝑻) ≡ ∣ h ∣ ∘ (q ̇ 𝑻))
       ------------------------------------------------------
 →      𝒦 ⊧ p ≋ q
 --inferred types: 𝑨 : Algebra 𝓤 𝑆, KA : 𝑨 ∈ 𝒦, h : hom 𝑻 𝑨

homs-compatible-with-identities
 {𝓤}{𝓦}{X}{fevw}{𝒦} p q hp≡hq {𝑨} KA = γ
 where
  h : (𝒂 : X → ∣ 𝑨 ∣) → hom 𝑻 𝑨
  h 𝒂 = lift-hom{𝑨 = 𝑨} 𝒂

  γ : 𝑨 ⊧ p ≈ q
  γ = gfe λ 𝒂 →
   (p ̇ 𝑨) 𝒂
     ≡⟨ 𝓇ℯ𝒻𝓁 ⟩
   (p ̇ 𝑨)(∣ h 𝒂 ∣ ∘ ℊ)
     ≡⟨(comm-hom-term gfe 𝑻 𝑨 (h 𝒂) p ℊ)⁻¹ ⟩
   (∣ h 𝒂 ∣ ∘ (p ̇ 𝑻)) ℊ
     ≡⟨ ap (λ - → - ℊ) (hp≡hq 𝑨 KA (h 𝒂)) ⟩
   (∣ h 𝒂 ∣ ∘ (q ̇ 𝑻)) ℊ
     ≡⟨ (comm-hom-term gfe 𝑻 𝑨 (h 𝒂) q ℊ) ⟩
   (q ̇ 𝑨)(∣ h 𝒂 ∣ ∘ ℊ)
     ≡⟨ 𝓇ℯ𝒻𝓁 ⟩
   (q ̇ 𝑨) 𝒂
     ∎

compatibility-of-identities-and-homs :
    {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
    {fevw : funext 𝓥 𝓦}
    {𝒦 : Pred (Algebra 𝓦 𝑆) (𝓦 ⁺)}
    (p q : Term{𝓤}{X})
   -------------------------------------------------
 →  (𝒦 ⊧ p ≋ q)
     ⇔ (∀(𝑨 : Algebra 𝓦 𝑆)
          (KA : 𝑨 ∈ 𝒦)
          (hh : hom (𝑻{𝓤}{X}) 𝑨)
       →  ∣ hh ∣ ∘ (p ̇ 𝑻) ≡ ∣ hh ∣ ∘ (q ̇ 𝑻))

compatibility-of-identities-and-homs
 {𝓤}{𝓦}{X} {fevw} {𝒦} p q =
  identities-compatible-with-homs {𝓤}{𝓦}{X}{fevw}{𝒦} p q ,
  homs-compatible-with-identities {𝓤}{𝓦}{X}{fevw}{𝒦} p q

---------------------------------------------------------------

--Compatibility of identities with interpretation of terms
hom-id-compatibility :
        {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
        {fevw : funext 𝓥 𝓦}
        (p q : ∣ 𝑻{𝓤}{X} ∣ )
        (𝑨 : Algebra 𝓦 𝑆)
        (ϕ : hom 𝑻 𝑨)
        (p≈q : 𝑨 ⊧ p ≈ q)
        -------------------
 →      ∣ ϕ ∣ p ≡ ∣ ϕ ∣ q

hom-id-compatibility
 {𝓤}{𝓦}{X}{fevw} p q 𝑨 ϕ p≈q =
    ∣ ϕ ∣ p              ≡⟨ ap ∣ ϕ ∣ (term-agreement p) ⟩
    ∣ ϕ ∣ ((p ̇ 𝑻) ℊ)  ≡⟨ (comm-hom-term fevw (𝑻{𝓤}{X}) 𝑨 ϕ p ℊ) ⟩
    (p ̇ 𝑨) (∣ ϕ ∣ ∘ ℊ)  ≡⟨ intensionality p≈q (∣ ϕ ∣ ∘ ℊ)  ⟩
    (q ̇ 𝑨) (∣ ϕ ∣ ∘ ℊ)  ≡⟨ (comm-hom-term fevw (𝑻{𝓤}{X}) 𝑨 ϕ q ℊ)⁻¹ ⟩
    ∣ ϕ ∣ ((q ̇ 𝑻) ℊ)  ≡⟨ (ap ∣ ϕ ∣ (term-agreement q))⁻¹ ⟩
    ∣ ϕ ∣ q  ∎

data vclo {𝓤 𝓘 : Universe}
           (𝒦 : Pred (Algebra (𝓤 ⊔ 𝓘) 𝑆) (𝓞 ⊔ 𝓥 ⊔ (𝓤 ⊔ 𝓘) ⁺)) :
            Pred (Algebra (𝓤 ⊔ 𝓘) 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⊔ (𝓤 ⊔ 𝓘) ⁺) where
 vbase : {𝑨 : Algebra (𝓤 ⊔ 𝓘) 𝑆} → 𝑨 ∈ 𝒦 → 𝑨 ∈ vclo 𝒦
 vprod : {I : 𝓘 ̇ }{𝒜 : I → Algebra (𝓤 ⊔ 𝓘) 𝑆} → (∀ i → 𝒜 i ∈ vclo{𝓤}{𝓘} 𝒦) → ⨅ 𝒜 ∈ vclo 𝒦
 vsub : {𝑨 : Algebra (𝓤 ⊔ 𝓘) 𝑆} → 𝑨 ∈ vclo{𝓤}{𝓘} 𝒦 → (sa : SubalgebrasOf 𝑨) → ∣ sa ∣ ∈ vclo 𝒦
 vhom : {𝑨 : Algebra (𝓤 ⊔ 𝓘) 𝑆} → 𝑨 ∈ vclo{𝓤}{𝓘} 𝒦 → ((𝑩 , _ , _) : HomImagesOf 𝑨) → 𝑩 ∈ vclo 𝒦


module _
 {ℒ𝒦 : (𝓤 : Universe) → Pred (Algebra 𝓤 𝑆) (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)}
 {ℒ𝒦' : (𝓤 : Universe) → Pred (Algebra 𝓤 𝑆) 𝓤} where

 -- ==========================================================
 -- The free algebra in Agda
 -- ------------------------
 -- 𝑻HI = HomImagesOf 𝑻

 𝑻img : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → _ ̇

 𝑻img {𝓤}{𝓦}{X} =
  Σ 𝑨 ꞉ (Algebra 𝓦 𝑆) ,
    Σ ϕ ꞉ hom (𝑻{𝓤}{X}) 𝑨 ,
      (𝑨 ∈ SClo{𝓤 = 𝓦}(ℒ𝒦 𝓦)) × Epic ∣ ϕ ∣


 𝑻𝑨 : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
      (ti : 𝑻img{𝓤}{𝓦}{X})
  →   Algebra 𝓦 𝑆

 𝑻𝑨 ti = ∣ ti ∣


 𝑻𝑨∈SClo : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
           (ti : 𝑻img{𝓤}{𝓦}{X})
  →        (𝑻𝑨{𝓤}{𝓦}{X} ti) ∈ SClo (ℒ𝒦 𝓦)
 𝑻𝑨∈SClo ti = ∣ pr₂ ∥ ti ∥ ∣

 𝑻ϕ : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
      (ti : 𝑻img{𝓤}{𝓦}{X})
  →   hom (𝑻{𝓤}{X}) (𝑻𝑨{𝓤}{𝓦}{X} ti)

 𝑻ϕ ti = pr₁ ∥ ti ∥


 𝑻ϕE : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
       (ti : 𝑻img{𝓤}{𝓦}{X})
  →    Epic ∣ (𝑻ϕ ti) ∣

 𝑻ϕE ti = ∥ pr₂ ∥ ti ∥ ∥


 𝑻KER : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → ? ̇

 𝑻KER {𝓤}{𝓦}{X} = Σ (p , q) ꞉ (∣ 𝑻{𝓤}{X} ∣ × ∣ 𝑻{𝓤}{X} ∣) ,
    ∀ ti → (p , q) ∈ KER-pred{B = ∣ (𝑻𝑨{𝓤}{𝓦}{X} ti) ∣} ∣ 𝑻ϕ{𝓤}{𝓦}{X} ti ∣


 Ψ : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → Rel ∣ 𝑻{𝓤}{X} ∣ (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺ ⊔ 𝓦 ⁺)
 Ψ {𝓤}{𝓦}{X} p q =
    ∀ (ti : 𝑻img{𝓤}{𝓦}{X}) → ∣ (𝑻ϕ ti) ∣ ∘ (p ̇ 𝑻) ≡ ∣ (𝑻ϕ ti) ∣ ∘ (q ̇ 𝑻)


 Ψ-IsEquivalence : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
  →                IsEquivalence{𝓤 = (𝓞 ⊔ 𝓥 ⊔ 𝓤)}{A = ∣ 𝑻 ∣} Ψ

 Ψ-IsEquivalence =
  record { rfl = λ p ti → 𝓇ℯ𝒻𝓁
         ; sym = λ p q p≡q ti → (p≡q ti)⁻¹
         ; trans = λ p q r p≡q q≡r ti → (p≡q ti) ∙ (q≡r ti)
         }

 𝑻compatible-op : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
  →               ∣ 𝑆 ∣ → Rel ∣ 𝑻{𝓤}{X} ∣ (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) → (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ̇
 𝑻compatible-op f R = (lift-rel R) =[ (f ̂ 𝑻) ]⇒ R

 𝑻compatible : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
  →            Rel ∣ 𝑻{𝓤}{X} ∣ (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) → (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ̇
 𝑻compatible R = ∀ f → 𝑻compatible-op f R

 record 𝑻Congruence {𝓤 𝓦 : Universe}{X : 𝓤 ̇} : (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺ ̇  where
  constructor mk𝑻con
  field
   ⟨_⟩ : Rel ∣ 𝑻 ∣ (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
   Compatible : 𝑻compatible ⟨_⟩
   IsEquiv : IsEquivalence ⟨_⟩

 open 𝑻Congruence

 tcongruence : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺ ̇
 tcongruence {𝓤}{𝓦}{X} = Σ θ ꞉ (Rel ∣ 𝑻{𝓤}{X} ∣ (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)) , IsEquivalence θ × 𝑻compatible θ

 Ψ-𝑻compatible : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → 𝑻compatible Ψ
 Ψ-𝑻compatible {𝓤}{𝓦}{X} f {𝒕}{𝒔} 𝒕𝒔∈Ψ ti = gfe λ x → γ x
  where
   𝑨 : Algebra 𝓤 𝑆
   𝑨 = 𝑻𝑨 ti

   ϕ : hom 𝑻 𝑨
   ϕ = 𝑻ϕ ti

   𝒕s 𝒔s : (i : ∥ 𝑆 ∥ f) → (X → ∣ 𝑻 ∣) → ∣ 𝑻 ∣
   𝒕s i = 𝒕 i ̇ 𝑻
   𝒔s i = 𝒔 i ̇ 𝑻

   𝒕≡𝒔 : (i : ∥ 𝑆 ∥ f) → ∣ ϕ ∣ ∘ (𝒕s i) ≡ ∣ ϕ ∣ ∘ (𝒔s i)
   𝒕≡𝒔 i = 𝒕𝒔∈Ψ i ti

   γ : ∀ x
    →  ∣ ϕ ∣((f ̂ 𝑻) (λ i → (𝒕 i ̇ 𝑻) x))
         ≡ ∣ ϕ ∣ ((f ̂ 𝑻)(λ i → (𝒔 i ̇ 𝑻) x))
   γ x =
    ∣ ϕ ∣ ((f ̂ 𝑻) (λ i → 𝒕s i x)) ≡⟨ ∥ ϕ ∥ f (λ i → 𝒕s i x) ⟩
    ((f ̂ 𝑨) (λ i → ∣ ϕ ∣ (𝒕s i x))) ≡⟨  ap (f ̂ 𝑨) (gfe λ i → intensionality (𝒕≡𝒔 i) x) ⟩
    ((f ̂ 𝑨) (λ i → ∣ ϕ ∣ (𝒔s i x))) ≡⟨  (∥ ϕ ∥ f (λ i → 𝒔s i x))⁻¹ ⟩
    ∣ ϕ ∣ ((f ̂ 𝑻) (λ i → (𝒔s i x))) ∎

 ConΨ : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → 𝑻Congruence
 ConΨ = mk𝑻con Ψ Ψ-𝑻compatible Ψ-IsEquivalence

 conΨ : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → tcongruence
 conΨ = Ψ , (Ψ-IsEquivalence , Ψ-𝑻compatible)

 𝔽 : {𝓤 𝓦 : Universe}{X : 𝓤 ̇} → Algebra ((𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺) 𝑆
 𝔽 = (
        -- carrier
        (  ∣ 𝑻 ∣ // ⟨ ConΨ ⟩  ) ,

        -- operations
        (  λ f args
            → ([ (f ̂ 𝑻) (λ i₁ → ⌜ args i₁ ⌝) ] ⟨ ConΨ ⟩) ,
                ((f ̂ 𝑻) (λ i₁ → ⌜ args i₁ ⌝) , 𝓇ℯ𝒻𝓁 )   )
      )

 𝔽-is-universal-for : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}(𝑨 : Algebra 𝓦 𝑆) → hom 𝔽 𝑨
 𝔽-is-universal-for {𝓤}{𝓦}{X} 𝑨 = ϕ , ϕhom
  where
   h₀ : X → ∣ 𝑨 ∣
   h₀ = fst (𝕏{𝓦}{𝓤}{X} 𝑨)
 
   hE : Epic h₀
   hE = snd (𝕏 𝑨)

   h : hom 𝑻 𝑨
   h = lift-hom{𝑨 = 𝑨} h₀

   ϕ : ∣ 𝑻 ∣ // ⟨ ConΨ ⟩ → ∣ 𝑨 ∣
   ϕ = λ 𝒂 → ∣ h ∣ ⌜ 𝒂 ⌝

   ϕhom : is-homomorphism 𝔽 𝑨 ϕ
   ϕhom f a = γ
    where
     γ : ϕ ((f ̂ 𝔽) a) ≡ (f ̂ 𝑨) (λ x → ϕ (a x))
     γ = ϕ ((f ̂ 𝔽) a) ≡⟨ 𝓇ℯ𝒻𝓁 ⟩
         ϕ (([ (f ̂ 𝑻) (λ i → ⌜ a i ⌝) ] ⟨ ConΨ ⟩) ,
           ((f ̂ 𝑻) (λ i → ⌜ a i ⌝) , refl _ ))
                        ≡⟨ 𝓇ℯ𝒻𝓁 ⟩
         ∣ h ∣ ((f ̂ 𝑻) (λ i → ⌜ a i ⌝))
                        ≡⟨ ∥ h ∥ f ((λ i → ⌜ a i ⌝)) ⟩
         (f ̂ 𝑨) (∣ h ∣ ∘ (λ i → ⌜ a i ⌝))
                        ≡⟨ 𝓇ℯ𝒻𝓁 ⟩
         (f ̂ 𝑨) (ϕ ∘ a) ∎

 𝔽∈vclo : {𝓤 𝓦 : Universe}{X : 𝓤 ̇}
  →        𝔽 ∈ vclo{(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺}{(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺}(ℒ𝒦 ((𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺))

 --We will prove this by showing that 𝔽 is a subalgebra of 𝑨{𝓜}{𝓜}, where
 --𝑨{𝓜}{𝓜} is a product of elements from the type Σ 𝑨 ꞉ (Algebra 𝓜 𝑆) , 𝑨 ∈ (ℒ𝒦 𝓜 𝓜).
 --Note that the *index* of the product has type Σ 𝑨 ꞉ (Algebra 𝓜 𝑆) , 𝑨 ∈ (ℒ𝒦 𝓜 𝓜),
 --which is 𝓘 = 𝓞 ⊔ 𝓥 ⊔ 𝓜 ⊔ 𝓜 ⁺.
 --𝑨{𝓜}{𝓜} ∈ vclo{𝓜 ⁺}{𝓜 ⁺} (ℒ𝒦 (𝓜 ⁺) (𝓜 ⁺))
 -- vsub : {𝑨 : Algebra 𝓤 𝑆} → 𝑨 ∈ vclo 𝒦 → (sa : SubalgebrasOf 𝑨) → ∣ sa ∣ ∈ vclo 𝒦
 -- γ : 𝔽 ∈ vclo{𝓜 ⁺}{𝓜 ⁺} (ℒ𝒦 (𝓜 ⁺)(𝓜 ⁺))
 -- γ = vsub 𝑨∈vclo 𝔽sub


 𝔽∈vclo {𝓤}{𝓦}{X} = γ
  where
   ΣP : {𝓘 : Universe} → Pred (Algebra (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) 𝑆) ((𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) ⁺) → (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) ⁺ ̇
   ΣP {𝓘} K = Σ 𝑨 ꞉ (Algebra (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) 𝑆) , 𝑨 ∈ K

   𝒜ΣP : {𝓘 : Universe}{K : Pred (Algebra (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) 𝑆) ((𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) ⁺)}
    →    ΣP{𝓘} K → Algebra (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) 𝑆
   𝒜ΣP i = ∣ i ∣

   ⨅𝒜ΣP : {𝓘 : Universe} → Algebra ((𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) ⁺) 𝑆
   ⨅𝒜ΣP {𝓘} = ⨅ (𝒜ΣP{𝓘 = 𝓘}{K = (ℒ𝒦 (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺))})

   𝑨 : Algebra ((𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺) 𝑆
   𝑨 = ⨅𝒜ΣP {𝓘 = 𝓤}
   -- 𝑨 : Algebra (𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) 𝑆
   -- 𝑨 = ⨅ (λ (i : ΣP{𝓤} (ℒ𝒦 𝓤)) → ∣ i ∣ )
   -- Where should 𝑨∈vclo live?

   𝑨∈vclo : {𝓘 : Universe}
    →       ⨅𝒜ΣP{𝓘 = 𝓘} ∈ vclo{(𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) ⁺}{(𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) ⁺} (ℒ𝒦 ((𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺) ⁺))
   𝑨∈vclo {𝓘} = {!!}

   ⨅ℒ𝒦 : {𝓤 𝓘 : Universe}{I : 𝓘 ̇}{𝒜 : I → Algebra (𝓤 ⊔ 𝓘) 𝑆}
    →      (∀ (i : I) → 𝒜 i ∈ vclo{𝓤}{𝓘} (ℒ𝒦 (𝓤 ⊔ 𝓘)))
    →      Algebra (𝓤 ⊔ 𝓘) 𝑆
   ⨅ℒ𝒦 {𝒜 = 𝒜} _ = ⨅ 𝒜

   ⨅𝒦∈vclo : {𝓤 𝓘 : Universe}{I : 𝓘 ⁺ ̇}{𝒜 : I → Algebra (𝓤 ⊔ 𝓘 ⁺) 𝑆}
              (p : ∀ (i : I) → 𝒜 i ∈ vclo{𝓤}{𝓘 ⁺} (ℒ𝒦 (𝓤 ⊔ 𝓘 ⁺)))
     →        ⨅ 𝒜 ∈ vclo{𝓤}{𝓘 ⁺} (ℒ𝒦 (𝓤 ⊔ 𝓘 ⁺))

   ⨅𝒦∈vclo p = vprod p

   --{!⨅𝒦∈vclo{𝓤 = (𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺)}{𝓘 = ((𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺))}{I = (ΣP{𝓘 = 𝓘} (ℒ𝒦 ((𝓞 ⊔ 𝓥 ⊔ 𝓘 ⁺)  )))} ? !}
   -- vprod{𝒜 = (λ (i : ΣP (ℒ𝒦 ((𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺))) → ∣ i ∣)} {!!}  -- vprod {!!}
   -- {I =  ΣP{𝓜 ⁺}{𝓜} (ℒ𝒦 (𝓜 ⁺) 𝓜)}{𝒜 = (𝒜ΣP{𝓜}{𝓜 ⁺})} ?
   --vprod : {I : 𝓤 ̇ }{𝒜 : I → Algebra 𝓤 𝑆} → (∀ i → 𝒜 i ∈ vclo 𝒦) → ⨅ 𝒜 ∈ vclo 𝒦

   ϕ : hom 𝔽 𝑨
   ϕ = 𝔽-is-universal-for 𝑨

   h : ∣ 𝔽 ∣ → ∣ 𝑨 ∣
   h = ∣ ϕ ∣

   kerh : Rel (∣ 𝑻 ∣ // ⟨ ConΨ ⟩ ) ((𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺)
   kerh [s] [t] = h [s] ≡ h [t]

   kerh⊆Ψ : ∀(s t : ∣ 𝑻 ∣)(ti : 𝑻img)
    →       kerh ⟦ s ⟧ ⟦ t ⟧
    →       ∣ (𝑻ϕ ti) ∣ ∘ (s ̇ 𝑻) ≡ ∣ (𝑻ϕ ti) ∣ ∘ (t ̇ 𝑻)
   kerh⊆Ψ s t ti kerhst = γ
    where
     𝑩 : Algebra ((𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺) 𝑆
     𝑩 = 𝑻𝑨 ti

     𝑩∈SCloℒ𝒦 : 𝑩 ∈ SClo(ℒ𝒦 𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
     𝑩∈SCloℒ𝒦 = 𝑻𝑨∈SClo ti

     𝑩∈ΣP : ΣP{𝓘 = 𝓤} (ℒ𝒦 𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺)
     𝑩∈ΣP = 𝑩 , ?

     hAB : hom 𝑨 𝑩
     hAB = {!!}

 -- 𝑻img : _ ̇
 -- 𝑻img = Σ 𝑨 ꞉ (Algebra 𝓤 𝑆) ,
 --           Σ ϕ ꞉ hom 𝑻 𝑨 , (𝑨 ∈ SClo(ℒ𝒦 𝓤)) × Epic ∣ ϕ ∣

     γ : ∣ 𝑻ϕ ti ∣ ∘ (s ̇ 𝑻) ≡ ∣ 𝑻ϕ ti ∣ ∘ (t ̇ 𝑻)
     γ = {!!}

   hembe : is-embedding h
   hembe = λ a fibhy fibhy' → {!!}

   hhomo : is-homomorphism 𝔽 𝑨 h
   hhomo = ∥ ϕ ∥

   𝔽sub : SubalgebrasOf 𝑨
   𝔽sub = (𝔽 , h , (hembe , hhomo))

   γ : 𝔽 ∈ vclo{(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺}{(𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺}(ℒ𝒦 ((𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺) ⁺))
   γ = vsub (𝑨∈vclo{𝓘 = 𝓤}) 𝔽sub
 -- vsub : {𝑨 : Algebra 𝓤 𝑆} → 𝑨 ∈ vclo 𝒦 → (sa : SubalgebrasOf 𝑨) → ∣ sa ∣ ∈ vclo 𝒦

 -- To get the full universality of 𝔽, we should also prove that the hom described above
 -- (in the proof of 𝔽-is-universal-for) is actually unique.
 -- We'll postpone that for now, but here's a stub.
 -- 𝔽-hom-unique : {𝑨 : Algebra 𝓦 𝑆}(g h : hom 𝔽 𝑨)
 --  →              ∣ g ∣ ≡ ∣ h ∣
 -- 𝔽-hom-unique g h = gfe λ x → {!γ x!}
 --  where γ : ∀ x → ∣ g ∣ x ≡ ∣ h ∣ x
 --        γ = {!!}

--  SClo→𝑻img : {𝑪 : Algebra 𝔖 𝑆}
--   →          (𝑪 ∈ SClo 𝒦++) → 𝑻img
--  SClo→𝑻img {𝑪 = 𝑪} 𝑪∈SClo𝒦 =
--   𝑪 , (fst (𝑻hom-gen 𝑪)) , (𝑪∈SClo𝒦 , (snd (𝑻hom-gen 𝑪)))

--  Ψ⊆ThSClo : Ψ ⊆ Th (SClo 𝒦++)
--  Ψ⊆ThSClo {p , q} pΨq {𝑪} 𝑪∈SClo𝒦 = 𝑪⊧p≈q
--   where
--    ti : 𝑻img
--    ti = SClo→𝑻img {𝑪 = 𝑪} 𝑪∈SClo𝒦

--    ϕ : hom 𝑻 𝑪
--    ϕ = 𝑻ϕ ti

--    ϕE : Epic ∣ ϕ ∣
--    ϕE = 𝑻ϕE ti

--    ϕsur : (𝒄 : X → ∣ 𝑪 ∣ )(x : X) → Image ∣ ϕ ∣ ∋ (𝒄 x)
--    ϕsur 𝒄 x = ϕE (𝒄 x)

--    preim : (𝒄 : X → ∣ 𝑪 ∣)(x : X) → ∣ 𝑻 ∣
--    preim 𝒄 x = (Inv ∣ ϕ ∣ (𝒄 x) (ϕsur 𝒄 x))

--    ζ : (𝒄 : X → ∣ 𝑪 ∣) → ∣ ϕ ∣ ∘ (preim 𝒄) ≡ 𝒄
--    ζ 𝒄 = gfe λ x → InvIsInv ∣ ϕ ∣ (𝒄 x) (ϕsur 𝒄 x)

--    γ : ∣ ϕ ∣ ∘ (p ̇ 𝑻) ≡ ∣ ϕ ∣ ∘ (q ̇ 𝑻)
--    γ = pΨq ti

--    𝑪⊧p≈q : (p ̇ 𝑪) ≡ (q ̇ 𝑪)
--    𝑪⊧p≈q = gfe λ 𝒄 →
--     (p ̇ 𝑪) 𝒄               ≡⟨ (ap (p ̇ 𝑪) (ζ 𝒄))⁻¹ ⟩
--     (p ̇ 𝑪) (∣ ϕ ∣ ∘ (preim 𝒄)) ≡⟨ (comm-hom-term gfe 𝑻 𝑪 ϕ p (preim 𝒄))⁻¹ ⟩
--     ∣ ϕ ∣ ((p ̇ 𝑻)(preim 𝒄))     ≡⟨ (intensionality γ (preim 𝒄)) ⟩
--     ∣ ϕ ∣ ((q ̇ 𝑻)(preim 𝒄))     ≡⟨ comm-hom-term gfe 𝑻 𝑪 ϕ q (preim 𝒄) ⟩
--     (q ̇ 𝑪)(∣ ϕ ∣ ∘ (preim 𝒄))  ≡⟨ ap (q ̇ 𝑪) (ζ 𝒄) ⟩
--     (q ̇ 𝑪) 𝒄 ∎


--  Ψ⊆Th : ∀ p q → (p , q) ∈ Ψ → 𝒦++ ⊧ p ≋ q
--  Ψ⊆Th p q pΨq {𝑨} KA = Ψ⊆ThSClo {p , q} pΨq (sbase KA)





--  data SPClo : Pred (Algebra (OVU+ ⁺ ⁺ ⁺) 𝑆) (OVU+ ⁺ ⁺ ⁺ ⁺) where
--   spbase : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ 𝒦4 → 𝑨 ∈ SPClo
--   sprod : {I : _ ̇ }{𝒜 : I → Algebra _ 𝑆}
--    →     (∀ i → 𝒜 i ∈ SPClo) → ⨅ 𝒜 ∈ SPClo
--   ssub : {𝑨 : Algebra _ 𝑆} → 𝑨 ∈ SPClo
--    →    (sa : SubalgebrasOf 𝑨) → ∣ sa ∣ ∈ SPClo

--  -- claim: 𝔽 belongs to SPClo
--  -- {𝒦 : Pred (Algebra (OVU+ ⁺ ) 𝑆) (OVU+ ⁺ ⁺ )}
--  -- 𝔽 : Algebra (OVU+ ⁺ ⁺ ⁺) 𝑆
--  -- 𝔽∈SPClo : 𝔽 ∈ SClo{𝓤 = (OVU+ ⁺ ⁺)} PClo{𝓤 = (OVU+ ⁺)} 𝒦
-- -- SubalgebrasOf : {𝓤 : Universe} → Algebra 𝓤 𝑆 → 𝓞 ⊔ 𝓥 ⊔ 𝓤 ⁺ ̇
-- -- SubalgebrasOf {𝓤} 𝑨 = Σ 𝑩 ꞉ (Algebra 𝓤 𝑆) ,
-- --                 Σ h ꞉ (∣ 𝑩 ∣ → ∣ 𝑨 ∣) ,
-- --                   is-embedding h × is-homomorphism 𝑩 𝑨 h

--  -- we will show 𝔽 is a subalgebra of ⨅ 𝒜 where
--  -- {I : 𝓤 ̇ }{𝒜 : I → Algebra _ 𝑆}(∀ i → 𝒜 i ∈ SPClo)
--  𝔽∈SPClo : 𝔽 ∈ SPClo
--  𝔽∈SPClo = γ
--   where

--    ΣP : Pred (Algebra (OVU+ ⁺ ) 𝑆) (OVU+ ⁺ ⁺ ) → OVU+ ⁺ ⁺  ̇
--    ΣP 𝒦 = Σ 𝑨 ꞉ (Algebra _ 𝑆) , 𝑨 ∈ 𝒦

--    ⨅P : Pred (Algebra (OVU+ ⁺ ) 𝑆) (OVU+ ⁺ ⁺ ) → Algebra (OVU+ ⁺ ⁺ ) 𝑆
--    ⨅P 𝒦 = ⨅ (λ (A : (ΣP 𝒦)) → ∣ A ∣ )

--    ⨅𝒦 : Algebra (OVU+ ⁺ ⁺) 𝑆
--    ⨅𝒦 = ⨅P 𝒦++

--    ⨅𝒦∈SPClo : ⨅𝒦 ∈ SPClo
--    ⨅𝒦∈SPClo = {!sprod {I = Pred (Algebra (OVU+ ⁺ ⁺) 𝑆) (OVU+ ⁺ ⁺ ⁺)}{𝒜 = ⨅P} ?!}

--    h : ∣ 𝔽 ∣ → ∣ ⨅𝒦 ∣
--    h = {!!}

--    hembe : is-embedding h
--    hembe = {!!}

--    hhomo : is-homomorphism 𝔽 ⨅𝒦 h
--    hhomo = {!!}

--    𝔽sub : SubalgebrasOf ⨅𝒦
--    𝔽sub = (𝔽 , h , (hembe , hhomo))

--    γ : 𝔽 ∈ SPClo
--    γ = ssub ⨅𝒦∈SPClo 𝔽sub

--  open product-compatibility {𝓤 = OVU+}

--  pclo-id1 : ∀ {p q} → (𝒦+ ⊧ p ≋ q) → (PClo 𝒦+ ⊧ p ≋ q)
--  pclo-id1 {p} {q} α (pbase x) = α x
--  pclo-id1 {p} {q} α (prod{I}{𝒜} 𝒜-P𝒦 ) = γ
--   where
--    IH : (i : I)  → (p ̇ 𝒜 i) ≡ (q ̇ 𝒜 i)
--    IH = λ i → pclo-id1{p}{q} α  ( 𝒜-P𝒦  i )
--    γ : p ̇ (⨅ 𝒜)  ≡ q ̇ (⨅ 𝒜)
--    γ = products-preserve-identities p q I 𝒜 IH

--  pclo-id2 : ∀{p q} → ((PClo 𝒦+) ⊧ p ≋ q ) → (𝒦+ ⊧ p ≋ q)
--  pclo-id2 p A∈𝒦 = p (pbase A∈𝒦)

--  sclo-id1 : ∀{p q} → (𝒦+ ⊧ p ≋ q) → (SClo 𝒦+ ⊧ p ≋ q)
--  sclo-id1 {p} {q} 𝒦⊧p≋q (sbase A∈𝒦) = 𝒦⊧p≋q A∈𝒦
--  sclo-id1 {p} {q} 𝒦⊧p≋q (sub {𝑨 = 𝑨} A∈SClo𝒦 sa) = γ
--   where
--    A⊧p≈q : 𝑨 ⊧ p ≈ q
--    A⊧p≈q = sclo-id1{p}{q} 𝒦⊧p≋q A∈SClo𝒦

--    B : Algebra 𝔖 𝑆
--    B = ∣ sa ∣

--    h : ∣ B ∣ → ∣ 𝑨 ∣
--    h = pr₁ ∥ sa ∥

--    hem : is-embedding h
--    hem = ∣ pr₂ ∥ sa ∥ ∣

--    hhm : is-homomorphism B 𝑨 h
--    hhm = ∥ pr₂ ∥ sa ∥ ∥

--    ξ : (b : X → ∣ B ∣ ) → h ((p ̇ B) b) ≡ h ((q ̇ B) b)
--    ξ b =
--     h ((p ̇ B) b)  ≡⟨ comm-hom-term gfe B 𝑨 (h , hhm) p b ⟩
--     (p ̇ 𝑨)(h ∘ b) ≡⟨ intensionality A⊧p≈q (h ∘ b) ⟩
--     (q ̇ 𝑨)(h ∘ b) ≡⟨ (comm-hom-term gfe B 𝑨 (h , hhm) q b)⁻¹ ⟩
--     h ((q ̇ B) b)  ∎

--    hlc : {b b' : domain h} → h b ≡ h b' → b ≡ b'
--    hlc hb≡hb' = (embeddings-are-lc h hem) hb≡hb'

--    γ : p ̇ B ≡ q ̇ B
--    γ = gfe λ b → hlc (ξ b)

--  sclo-id2 : ∀ {p q} → (SClo 𝒦+ ⊧ p ≋ q) → (𝒦+ ⊧ p ≋ q)
--  sclo-id2 p A∈𝒦 = p (sbase A∈𝒦)

--  hclo-id1 : ∀{p q} → (𝒦+ ⊧ p ≋ q) → (HClo 𝒦+ ⊧ p ≋ q)
--  hclo-id1 {p}{q} 𝒦⊧p≋q (hbase A∈𝒦) = 𝒦⊧p≋q A∈𝒦
--  hclo-id1 {p}{q} 𝒦⊧p≋q (hhom{𝑨} A∈HClo𝒦 𝑩ϕhE) = γ
--   where
--    A⊧p≈q : 𝑨 ⊧ p ≈ q
--    A⊧p≈q = (hclo-id1{p}{q} 𝒦⊧p≋q ) A∈HClo𝒦

--    𝑩 : Algebra ℌ 𝑆
--    𝑩 = ∣ 𝑩ϕhE ∣

--    ϕ : ∣ 𝑨 ∣ → ∣ 𝑩 ∣
--    ϕ = ∣ ∥ 𝑩ϕhE ∥ ∣

--    ϕhom : is-homomorphism 𝑨 𝑩 ϕ
--    ϕhom = ∣ pr₂ ∥ 𝑩ϕhE ∥ ∣

--    ϕsur : (𝒃 : X → ∣ 𝑩 ∣ )(x : X) → Image ϕ ∋ (𝒃 x)
--    ϕsur 𝒃 x = ∥ pr₂ ∥ 𝑩ϕhE ∥ ∥ (𝒃 x)

--    preim : (𝒃 : X → ∣ 𝑩 ∣)(x : X) → ∣ 𝑨 ∣
--    preim 𝒃 x = (Inv ϕ (𝒃 x) (ϕsur 𝒃 x))

--    ζ : (𝒃 : X → ∣ 𝑩 ∣) → ϕ ∘ (preim 𝒃) ≡ 𝒃
--    ζ 𝒃 = gfe λ x → InvIsInv ϕ (𝒃 x) (ϕsur 𝒃 x)

--    γ : (p ̇ 𝑩) ≡ (q ̇ 𝑩)
--    γ = gfe λ 𝒃 →
--     (p ̇ 𝑩) 𝒃               ≡⟨ (ap (p ̇ 𝑩) (ζ 𝒃))⁻¹ ⟩
--     (p ̇ 𝑩) (ϕ ∘ (preim 𝒃)) ≡⟨ (comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕhom) p (preim 𝒃))⁻¹ ⟩
--     ϕ((p ̇ 𝑨)(preim 𝒃))     ≡⟨ ap ϕ (intensionality A⊧p≈q (preim 𝒃)) ⟩
--     ϕ((q ̇ 𝑨)(preim 𝒃))     ≡⟨ comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕhom) q (preim 𝒃) ⟩
--     (q ̇ 𝑩)(ϕ ∘ (preim 𝒃))  ≡⟨ ap (q ̇ 𝑩) (ζ 𝒃) ⟩
--     (q ̇ 𝑩) 𝒃 ∎

--  hclo-id2 : ∀ {p q} → (HClo 𝒦+ ⊧ p ≋ q) → (𝒦+ ⊧ p ≋ q)
--  hclo-id2 p A∈𝒦 = p (hbase A∈𝒦)

--  vclo-id1 : ∀ {p q} → (𝒦+ ⊧ p ≋ q) → (VClo 𝒦+ ⊧ p ≋ q)
--  vclo-id1 {p} {q} α (vbase A∈𝒦) = α A∈𝒦
--  vclo-id1 {p} {q} α (vprod{I = I}{𝒜 = 𝒜} 𝒜∈VClo𝒦) = γ
--   where
--    IH : (i : I) → 𝒜 i ⊧ p ≈ q
--    IH i = vclo-id1{p}{q} α (𝒜∈VClo𝒦 i)

--    γ : p ̇ (⨅ 𝒜)  ≡ q ̇ (⨅ 𝒜)
--    γ = products-preserve-identities p q I 𝒜 IH

--  vclo-id1 {p} {q} α ( vsub {𝑨 = 𝑨} A∈VClo𝒦 sa ) = γ
--   where
--    A⊧p≈q : 𝑨 ⊧ p ≈ q
--    A⊧p≈q = vclo-id1{p}{q} α A∈VClo𝒦

--    𝑩 : Algebra 𝔙 𝑆
--    𝑩 = ∣ sa ∣

--    h : ∣ 𝑩 ∣ → ∣ 𝑨 ∣
--    h = pr₁ ∥ sa ∥

--    hem : is-embedding h
--    hem = ∣ pr₂ ∥ sa ∥ ∣

--    hhm : is-homomorphism 𝑩 𝑨 h
--    hhm = ∥ pr₂ ∥ sa ∥ ∥

--    ξ : (b : X → ∣ 𝑩 ∣ ) → h ((p ̇ 𝑩) b) ≡ h ((q ̇ 𝑩) b)
--    ξ b =
--     h ((p ̇ 𝑩) b)  ≡⟨ comm-hom-term gfe 𝑩 𝑨 (h , hhm) p b ⟩
--     (p ̇ 𝑨)(h ∘ b) ≡⟨ intensionality A⊧p≈q (h ∘ b) ⟩
--     (q ̇ 𝑨)(h ∘ b) ≡⟨ (comm-hom-term gfe 𝑩 𝑨 (h , hhm) q b)⁻¹ ⟩
--     h ((q ̇ 𝑩) b)  ∎

--    hlc : {b b' : domain h} → h b ≡ h b' → b ≡ b'
--    hlc hb≡hb' = (embeddings-are-lc h hem) hb≡hb'

--    γ : p ̇ 𝑩 ≡ q ̇ 𝑩
--    γ = gfe λ b → hlc (ξ b)

--  vclo-id1 {p}{q} α (vhom{𝑨 = 𝑨} A∈VClo𝒦 𝑩ϕhE) = γ
--   where
--    A⊧p≈q : 𝑨 ⊧ p ≈ q
--    A⊧p≈q = vclo-id1{p}{q} α A∈VClo𝒦

--    𝑩 : Algebra 𝔙 𝑆
--    𝑩 = ∣ 𝑩ϕhE ∣

--    ϕ : ∣ 𝑨 ∣ → ∣ 𝑩 ∣
--    ϕ = ∣ ∥ 𝑩ϕhE ∥ ∣

--    ϕh : is-homomorphism 𝑨 𝑩 ϕ
--    ϕh = ∣ pr₂ ∥ 𝑩ϕhE ∥ ∣

--    ϕE : (𝒃 : X → ∣ 𝑩 ∣ )(x : X) → Image ϕ ∋ (𝒃 x)
--    ϕE 𝒃 x = ∥ pr₂ ∥ 𝑩ϕhE ∥ ∥ (𝒃 x)

--    preim : (𝒃 : X → ∣ 𝑩 ∣)(x : X) → ∣ 𝑨 ∣
--    preim 𝒃 x = (Inv ϕ (𝒃 x) (ϕE 𝒃 x))

--    ζ : (𝒃 : X → ∣ 𝑩 ∣) → ϕ ∘ (preim 𝒃) ≡ 𝒃
--    ζ 𝒃 = gfe λ x → InvIsInv ϕ (𝒃 x) (ϕE 𝒃 x)

--    γ : (p ̇ 𝑩) ≡ (q ̇ 𝑩)
--    γ = gfe λ 𝒃 →
--     (p ̇ 𝑩) 𝒃               ≡⟨ (ap (p ̇ 𝑩) (ζ 𝒃))⁻¹ ⟩
--     (p ̇ 𝑩) (ϕ ∘ (preim 𝒃)) ≡⟨ (comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕh) p (preim 𝒃))⁻¹ ⟩
--     ϕ((p ̇ 𝑨)(preim 𝒃))     ≡⟨ ap ϕ (intensionality A⊧p≈q (preim 𝒃)) ⟩
--     ϕ((q ̇ 𝑨)(preim 𝒃))     ≡⟨ comm-hom-term gfe 𝑨 𝑩 (ϕ , ϕh) q (preim 𝒃) ⟩
--     (q ̇ 𝑩)(ϕ ∘ (preim 𝒃))  ≡⟨ ap (q ̇ 𝑩) (ζ 𝒃) ⟩
--     (q ̇ 𝑩) 𝒃 ∎

--  vclo-id2 : ∀ {p q} → (VClo 𝒦+ ⊧ p ≋ q) → (𝒦+ ⊧ p ≋ q)
--  vclo-id2 p A∈𝒦 = p (vbase A∈𝒦)

--  -- Th (VClo 𝒦) is precisely the set of identities modeled by 𝒦
--  ThHSP-axiomatizes : (p q : ∣ 𝑻 ∣)
--            -----------------------------------------
--   →         𝒦+ ⊧ p ≋ q  ⇔  ((p , q) ∈ Th (VClo 𝒦+))

--  ThHSP-axiomatizes p q =
--   (λ 𝒦⊧p≋q 𝑨∈VClo𝒦 → vclo-id1{p = p}{q = q} 𝒦⊧p≋q 𝑨∈VClo𝒦) ,
--   λ pq∈Th 𝑨∈𝒦 → pq∈Th (vbase 𝑨∈𝒦)

-- -----------------------------------------------------
-- -- Old, unused stuff

--  --Compatibility of identities with interpretation of terms
--  compatibility-of-interpretations : (p q : Term)
--   →        (𝒦 ⊧ p ≋ q)
--   →        ∀ 𝑨 (ka : 𝑨 ∈ 𝒦) (hh : hom 𝑻 𝑨)
--   →        ∣ hh ∣ ((∣ term-gen p ∣ ̇ 𝑻) ℊ)
--          ≡ ∣ hh ∣ ((∣ term-gen q ∣ ̇ 𝑻) ℊ)

--  compatibility-of-interpretations p q 𝒦⊧p≋q 𝑨 ka hh = γ
--   where
--    𝓅 𝓆 : ∣ 𝑻 ∣  -- Notation: 𝓅 = \Mcp
--    𝓅 = ∣ tg p ∣
--    𝓆 = ∣ tg q ∣

--    p≡𝓅 : p ≡ (𝓅 ̇ 𝑻) ℊ
--    p≡𝓅 = ∥ tg p ∥

--    q≡𝓆 : q ≡ (𝓆 ̇ 𝑻) ℊ
--    q≡𝓆 = ∥ tg q ∥

--    pA≡qA : p ̇ 𝑨 ≡ q ̇ 𝑨
--    pA≡qA = 𝒦⊧p≋q ka

--    γ : ∣ hh ∣ ((𝓅 ̇ 𝑻) ℊ) ≡ ∣ hh ∣ ((𝓆 ̇ 𝑻) ℊ)
--    γ =
--     ∣ hh ∣ ((𝓅 ̇ 𝑻) ℊ)  ≡⟨ (ap ∣ hh ∣ (term-gen-agreement p))⁻¹ ⟩
--     ∣ hh ∣ ((p ̇ 𝑻) ℊ)  ≡⟨ (comm-hom-term gfe 𝑻 𝑨 hh p ℊ) ⟩
--     (p ̇ 𝑨) (∣ hh ∣ ∘ ℊ)  ≡⟨ intensionality pA≡qA (∣ hh ∣ ∘ ℊ)  ⟩
--     (q ̇ 𝑨) (∣ hh ∣ ∘ ℊ)  ≡⟨ (comm-hom-term gfe 𝑻 𝑨 hh q ℊ)⁻¹ ⟩
--     ∣ hh ∣ ((q ̇ 𝑻) ℊ)  ≡⟨ ap ∣ hh ∣ (term-gen-agreement q) ⟩
--     ∣ hh ∣ ((𝓆 ̇ 𝑻) ℊ)  ∎












































 -- 𝑻img→𝑻⊧ : ∀ p q → (p , q) ∈ Ψ' → (ti : 𝑻img)
 --          ------------------------------------------------------
 --  →        ∣ (𝑻ϕ ti) ∣ ((p ̇ 𝑻) ℊ) ≡ ∣ (𝑻ϕ ti) ∣ ((q ̇ 𝑻) ℊ)

 -- 𝑻img→𝑻⊧ p q pΨq ti = goal1
 --  where
 --   𝑪 : Algebra 𝓤 𝑆
 --   𝑪 = ∣ ti ∣

 --   ϕ : hom 𝑻 𝑪
 --   ϕ = 𝑻ϕ ti

 --   pCq : ∣ ϕ ∣ p ≡ ∣ ϕ ∣ q
 --   pCq = pΨq ti

 --   𝓅 𝓆 : ∣ 𝑻 ∣  -- Notation: 𝓅 = \Mcp
 --   𝓅 = ∣ tg{X = X}{gfe = gfe} p ∣
 --   𝓆 = ∣ tg{X = X}{gfe = gfe} q ∣

 --   p≡𝓅 : p ≡ (𝓅 ̇ 𝑻) ℊ
 --   p≡𝓅 = ∥ tg p ∥

 --   q≡𝓆 : q ≡ (𝓆 ̇ 𝑻) ℊ
 --   q≡𝓆 = ∥ tg q ∥

 --   ξ : ∣ ϕ ∣ ((𝓅 ̇ 𝑻) ℊ) ≡ ∣ ϕ ∣ ((𝓆 ̇ 𝑻) ℊ)
 --   ξ = (ap ∣ ϕ ∣ p≡𝓅)⁻¹ ∙ pCq ∙ (ap ∣ ϕ ∣ q≡𝓆)

 --   goal1 : ∣ ϕ ∣ ((p ̇ 𝑻) ℊ) ≡ ∣ ϕ ∣ ((q ̇ 𝑻) ℊ)
 --   goal1 = (ap ∣ ϕ ∣ (term-gen-agreement p))
 --            ∙ ξ ∙ (ap ∣ ϕ ∣ (term-gen-agreement q))⁻¹

-- module _
--  {𝒦 : Pred (Algebra 𝓤 𝑆) (𝓤 ⊔ 𝓦)} where

 -- 𝒦subset : (𝑩 : Algebra 𝓤 𝑆)
 --  →           𝑩 ∈ 𝒦  →  Σ 𝑨 ꞉ (Algebra 𝓤 𝑆) , 𝑨 ∈ 𝒦
 -- 𝒦subset 𝑩 𝑩∈𝒦 = 𝑩 , 𝑩∈𝒦

 -- 𝒦supset : (BK : Σ 𝑨 ꞉ (Algebra 𝓤 𝑆) , 𝑨 ∈ 𝒦) → ∣ BK ∣ ∈ 𝒦
 -- 𝒦supset BK = ∥ BK ∥

 -- 𝒦prod : (I : 𝓤 ̇ ) (𝒜 : I → Algebra 𝓤 𝑆) → hom (𝔽) (⨅ 𝒜)
 -- 𝒦prod I 𝒜  = 𝔽-is-universal-for (⨅ 𝒜)

--  𝔽∈SP : hom 𝔽 ⨅

-- {𝒜 : I → Algebra _ 𝑆}
