---
layout: default
title : Relations.Big module (The Agda Universal Algebra Library)
date : 2021-02-28
author: William DeMeo
---

### <a id="continuous-relations">Continuous Relations*</a>

This is the [Relations.Continuous][] module of the [Agda Universal Algebra Library][].<sup>[*](Relations.Continuous.html#fn0)</sup>

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

module Relations.Continuous where

open import Relations.Discrete public

\end{code}

#### <a id="motivation">Motivation</a>
In set theory, an n-ary relation on a set `A` is simply a subset of the n-fold product `A × A × ⋯ × A`.  As such, we could model these as predicates over the type `A × A × ⋯ × A`, or as relations of type `A → A → ⋯ → A → 𝓦 ̇` (for some universe 𝓦).  To implement such a relation in type theory, we would need to know the arity in advance, and then somehow form an n-fold arrow →.  It's easier and more general to instead define an arity type `I : 𝓥 ̇`, and define the type representing `I`-ary relations on `A` as the function type `(I → A) → 𝓦 ̇`.  Then, if we are specifically interested in an n-ary relation for some natural number `n`, we could take `I` to be a finite set (e.g., of type `Fin n`).

Below we will define `ContRel` to be the type `(I → A) → 𝓦 ̇` and we will call `ContRel` the type of *continuous relations*.  This generalizes the discrete relations we defined in [Relations.Discrete] (unary, binary, etc.) since continuous relations can be of arbitrary arity.  They are not completely general, however, since they are defined over a single type. Said another way, they are *single-sorted* relations. We will remove this limitation when we define the type of *dependent continuous relations* at the end of this module.

Just as `Rel A 𝓦` was the single-sorted special case of the multisorted `REL A B 𝓦` type, so too will `ContRel I A 𝓦` be the single-sorted version of a completely general type of relations. The latter will represent relations that not only have arbitrary arities, but also are defined over arbitrary families of types.

To be more concrete, given an arbitrary family `A : I → 𝓤 ̇` of types, we may have a relation from `A i` to `A j` to `A k` to …, where the collection represented by the "indexing" type `I` might not even be enumerable.<sup>[1](Relations.Continuous.html#fn1)</sup>

We refer to such relations as *dependent continuous relations* (or *dependent relations* for short) because the definition of a type that represents them requires depedent types.  The `DepRel` type that we define [below](Relations.Continuous.html#dependent-relations) manifests this completely general notion of relation.

#### <a id="continuous-relations">Continuous relations</a>

We now define the type `ContRel` which represents predicates of arbitrary arity over a single type `A`. We call this the type of *continuous relations*.

**Notation**. For consistency and readability, throughout the [UALib][] we reserve two universe variables for special purposes.  The first of these is 𝓞 which shall be reserved for types that represent *operation symbols* (see [Algebras.Signatures][]). The second is 𝓥 which we reserve for types representing *arities* of relations or operations.

\begin{code}

ContRel : 𝓥 ̇ → 𝓤 ̇ → (𝓦 : Universe) → 𝓥 ⊔ 𝓤 ⊔ 𝓦 ⁺ ̇
ContRel I A 𝓦 = (I → A) → 𝓦 ̇

\end{code}


<!-- #### <a id="compatibility-with-continuous-relations">Compatibility with continuous relations</a> -->

Next we present types that are useful for asserting and proving facts about *compatibility* of functions with continuous relations.  The first is an *evaluation* function which "lifts" an `I`-ary relation to an `(I → J)`-ary relation. The lifted relation will relate an `I`-tuple of `J`-tuples when the "`I`-slices" (or "rows") of the `J`-tuples belong to the original relation.

\begin{code}

module _ {I J : 𝓥 ̇} {A : 𝓤 ̇} where

 eval-cont-rel : ContRel I A 𝓦 → (I → J → A) → 𝓥 ⊔ 𝓦 ̇
 eval-cont-rel R 𝒶 = Π j ꞉ J , R λ i → 𝒶 i j

 cont-compatible-fun : ((J → A) → A) → ContRel I A 𝓦 → 𝓥 ⊔ 𝓤 ⊔ 𝓦 ̇
 cont-compatible-fun 𝑓 R  = Π 𝒶 ꞉ (I → J → A) , (eval-cont-rel R 𝒶 → R λ i → (𝑓 (𝒶 i)))

\end{code}

To readers who find the syntax of the last two definitions nauseating, we recommend focusing on the semantics. First, internalize the fact that `𝒶 : I → J → A` denotes an `I`-tuple of `J`-tuples of inhabitants of `A`. Next, recall that a continuous relation `R` represents a certain collection of `I`-tuples. Specifically, if `x : I → A` is an `I`-tuple, then `R x` denotes the assertion that "`x` belongs to `R`" or "`x` satisfies `R`."  For each continuous relation `R`, the type `eval-cont-rel R` represents a certain collection of `I`-tuples of `J`-tuples, namely, the tuples `𝒶 : I → J → A` for which `eval-cont-rel R 𝒶` holds. For simplicity, pretend that `J` is a finite set, say, `{1, 2, ..., J}`, so that we can write down a couple of the `J`-tuples as columns. For example, here are the i-th and k-th columns (for some `i k : I`).

```
𝒶 i 1      𝒶 k 1
𝒶 i 2      𝒶 k 2
𝑎 i 3      𝒶 k 3    <-- (a row of I such columns forms an I-tuple)
  ⋮          ⋮
𝒶 i J      𝒶 k J
```

Now `eval-cont-rel R 𝒶` is defined by `∀ j → R (λ i → 𝒶 i j)` which represents the assertion that each row of the `I` columns shown above belongs to the original relation `R`. Finally, `cont-compatible-fun` takes a `J`-ary operation `𝑓 : (J → A) → A` and an `I`-tuple `𝒶 : I → J → A` of `J`-tuples, and determines whether the `I`-tuple `λ i → 𝑓 (𝑎 i)` belongs to `R`.

<!-- Finally, digest all the types involved in these definitions and note how nicely they align (as they must if type-checking is to succeed!).  For example, `𝒶 : I → (J → A)` is precisely the type on which the relation `eval-cont-rel R` is defined. -->


#### <a id="dependent-relations">Dependent relations</a>

In this section we exploit the power of dependent types to define a completely general relation type.  Specifically, we let the tuples inhabit a dependent function type `𝒜 : I → 𝓤 ̇`, where the codomain may depend upon the input coordinate `i : I` of the domain. Heuristically, think of the inhabitants of the following type as relations from `𝒜 i` to `𝒜 j` to `𝒜 k` to …. (This is only an heuristic since \ab I can represent an uncountable collection.\cref{uncountable}.<sup>[1](Relations.Continuous.html#fn1)</sup>)

\begin{code}

DepRel : (I : 𝓥 ̇) → (I → 𝓤 ̇) → (𝓦 : Universe) → 𝓥 ⊔ 𝓤 ⊔ 𝓦 ⁺ ̇
DepRel I 𝒜 𝓦 = Π 𝒜 → 𝓦 ̇

\end{code}

We call `DepRel` the type of *dependent relations*.

#### <a id="compatibility-with-dependent-relations">Compatibility with dependent relations</a>

Above we saw lifts of continuous relations and what it means for such relations to be compatible with functions. We conclude this module by defining the (only slightly more complicated) lift of dependent relations, and the type that represents compatibility of an operation with a dependent relation.

\begin{code}

module _ {I J : 𝓥 ̇} {𝒜 : I → 𝓤 ̇} where

 eval-dep-rel : DepRel I 𝒜 𝓦 → (∀ i → (J → 𝒜 i)) → 𝓥 ⊔ 𝓦 ̇
 eval-dep-rel R 𝒶 = ∀ j → R (λ i → (𝒶 i) j)

 -- equivalent definition using Π notation
 eval-dep-rel' : DepRel I 𝒜 𝓦 → (Π i ꞉ I , (J → 𝒜 i)) → 𝓥 ⊔ 𝓦 ̇
 eval-dep-rel' R 𝒶 = Π j ꞉ J , R (λ i → (𝒶 i) j)

 dep-compatible-fun : (∀ i → (J → 𝒜 i) → 𝒜 i) → DepRel I 𝒜 𝓦 → 𝓥 ⊔ 𝓤 ⊔ 𝓦 ̇
 dep-compatible-fun 𝑓 R  = ∀ 𝒶 → (eval-dep-rel R) 𝒶 → R λ i → (𝑓 i)(𝒶 i)

 -- equivalent definition using Π notation
 dep-compatible-fun' : (Π i ꞉ I , ((J → 𝒜 i) → 𝒜 i)) → DepRel I 𝒜 𝓦 → 𝓥 ⊔ 𝓤 ⊔ 𝓦 ̇
 dep-compatible-fun' 𝑓 R  =  Π 𝒶 ꞉ (Π i ꞉ I , (J → 𝒜 i)) , ((eval-dep-rel R) 𝒶 → R λ i → (𝑓 i)(𝒶 i))

\end{code}

In the definition of `dep-compatible-fun`, we let Agda infer the type of `𝒶`, which is `Π i ꞉ I , (J → 𝒜 i)` in this case.


--------------------------------------

<sup>[*]</sup><span class="footnote" id="fn0"> Sections marked with an asterisk include new types that are more abstract and general (and frankly more interesting) than the ones presented in other sections.  Consequently, such sections expect a higher degree of sophistication and/or effort from the reader/user. Moreover, the types defined in starred sections are used in only a few other places in the [Agda UALib][], so they may be safely skimmed over or skipped.</span>

<sup>[1]</sup><span class="footnote" id="fn1"> Because the collection represented by the indexing type `I` might not even be enumerable, technically speaking, instead of `A i` to `A j` to `A k` to ..., we should have written something like `TO (i : I) , A i`.</span>

<br>
<br>

[← Relations.Discrete](Relations.Discrete.html)
<span style="float:right;">[Relations.Quotients →](Relations.Quotients.html)</span>

{% include UALib.Links.md %}
