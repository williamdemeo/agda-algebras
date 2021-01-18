---
layout: default
title : UALib.Algebras.Lifts module (Agda Universal Algebra Library)
date : 2021-01-12
author: William DeMeo
---

### <a id="agdas-universe-hierarchy">Agda's Universe Hierarchy</a>

This section presents the [UALib.Algebras.Lifts][] module of the [Agda Universal Algebra Library][].

<pre class="Agda">

<a id="319" class="Symbol">{-#</a> <a id="323" class="Keyword">OPTIONS</a> <a id="331" class="Pragma">--without-K</a> <a id="343" class="Pragma">--exact-split</a> <a id="357" class="Pragma">--safe</a> <a id="364" class="Symbol">#-}</a>

<a id="369" class="Keyword">module</a> <a id="376" href="UALib.Algebras.Lifts.html" class="Module">UALib.Algebras.Lifts</a> <a id="397" class="Keyword">where</a>

<a id="404" class="Keyword">open</a> <a id="409" class="Keyword">import</a> <a id="416" href="UALib.Algebras.Products.html" class="Module">UALib.Algebras.Products</a> <a id="440" class="Keyword">public</a>
</pre>

#### The noncumulative hierarchy

The hierarchy of universe levels in Agda looks like this:

𝓤₀ : 𝓤₁, &nbsp; 𝓤₁ : 𝓤₂, &nbsp; 𝓤₂ : 𝓤₃, …

This means that the type level of 𝓤₀ is 𝓤₁, and for each `n` The type level of 𝓤ₙ is 𝓤ₙ₊₁.

It is important to note, however, this does *not* imply that 𝓤₀ : 𝓤₂ and 𝓤₀ : 𝓤₃, and so on.  In other words, Agda's universe hierarchy is **noncummulative**.  This makes it possible to treat universe levels more generally and precisely, which is nice. On the other hand (in this author's experience) a noncummulative hierarchy can sometimes make for a nonfun proof assistant.

Luckily, there are ways to overcome this technical issue, and we describe some such techniques we developed specifically for our domain.

#### Lifting and lowering

Let us be more concrete about what is at issue here by giving an example. Agda will often complain with errors like the following:

```
Birkhoff.lagda:498,20-23
(𝓤 ⁺) != (𝓞 ⁺) ⊔ (𝓥 ⁺) ⊔ ((𝓤 ⁺) ⁺)
when checking that the expression SP𝒦 has type
Pred (Σ (λ A → (f₁ : ∣ 𝑆 ∣) → Op (∥ 𝑆 ∥ f₁) A)) _𝓦_2346
```

First of all, we must know how to interpret such errors. The one above means that Agda encountered a type at universe level `𝓤 ⁺`, on line 498 (columns 20--23) of the file `Birkhoff.lagda` file, but was expecting a type at level `𝓞 ⁺ ⊔ 𝓥 ⁺ ⊔ 𝓤 ⁺ ⁺` instead.

To make these situations easier to deal with, we developed some domain specific tools for the lifting and lowering of universe levels of our algebra types. (Later we do the same for other domain specific types like homomorphisms, subalgebras, products, etc).  Of course, this must be done carefully to avoid making the type theory inconsistent.  In particular, we cannot lower the level of a type unless it was previously lifted to a (higher than necessary) universe level.

A general `Lift` record type, similar to the one found in the [Agda Standard Library][] (in the `Level` module), is defined as follows.

<pre class="Agda">

<a id="2420" class="Keyword">record</a> <a id="Lift"></a><a id="2427" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a> <a id="2432" class="Symbol">{</a><a id="2433" href="UALib.Algebras.Lifts.html#2433" class="Bound">𝓤</a> <a id="2435" href="UALib.Algebras.Lifts.html#2435" class="Bound">𝓦</a> <a id="2437" class="Symbol">:</a> <a id="2439" href="universes.html#551" class="Postulate">Universe</a><a id="2447" class="Symbol">}</a> <a id="2449" class="Symbol">(</a><a id="2450" href="UALib.Algebras.Lifts.html#2450" class="Bound">X</a> <a id="2452" class="Symbol">:</a> <a id="2454" href="UALib.Algebras.Lifts.html#2433" class="Bound">𝓤</a> <a id="2456" href="universes.html#758" class="Function Operator">̇</a><a id="2457" class="Symbol">)</a> <a id="2459" class="Symbol">:</a> <a id="2461" href="UALib.Algebras.Lifts.html#2433" class="Bound">𝓤</a> <a id="2463" href="Agda.Primitive.html#636" class="Primitive Operator">⊔</a> <a id="2465" href="UALib.Algebras.Lifts.html#2435" class="Bound">𝓦</a> <a id="2467" href="universes.html#758" class="Function Operator">̇</a>  <a id="2470" class="Keyword">where</a>
 <a id="2477" class="Keyword">constructor</a> <a id="lift"></a><a id="2489" href="UALib.Algebras.Lifts.html#2489" class="InductiveConstructor">lift</a>
 <a id="2495" class="Keyword">field</a> <a id="Lift.lower"></a><a id="2501" href="UALib.Algebras.Lifts.html#2501" class="Field">lower</a> <a id="2507" class="Symbol">:</a> <a id="2509" href="UALib.Algebras.Lifts.html#2450" class="Bound">X</a>
<a id="2511" class="Keyword">open</a> <a id="2516" href="UALib.Algebras.Lifts.html#2427" class="Module">Lift</a>

</pre>

Next, we give various ways to lift function types.

<pre class="Agda">

<a id="lift-dom"></a><a id="2600" href="UALib.Algebras.Lifts.html#2600" class="Function">lift-dom</a> <a id="2609" class="Symbol">:</a> <a id="2611" class="Symbol">{</a><a id="2612" href="UALib.Algebras.Lifts.html#2612" class="Bound">𝓧</a> <a id="2614" href="UALib.Algebras.Lifts.html#2614" class="Bound">𝓨</a> <a id="2616" href="UALib.Algebras.Lifts.html#2616" class="Bound">𝓦</a> <a id="2618" class="Symbol">:</a> <a id="2620" href="universes.html#551" class="Postulate">Universe</a><a id="2628" class="Symbol">}{</a><a id="2630" href="UALib.Algebras.Lifts.html#2630" class="Bound">X</a> <a id="2632" class="Symbol">:</a> <a id="2634" href="UALib.Algebras.Lifts.html#2612" class="Bound">𝓧</a> <a id="2636" href="universes.html#758" class="Function Operator">̇</a><a id="2637" class="Symbol">}{</a><a id="2639" href="UALib.Algebras.Lifts.html#2639" class="Bound">Y</a> <a id="2641" class="Symbol">:</a> <a id="2643" href="UALib.Algebras.Lifts.html#2614" class="Bound">𝓨</a> <a id="2645" href="universes.html#758" class="Function Operator">̇</a><a id="2646" class="Symbol">}</a> <a id="2648" class="Symbol">→</a> <a id="2650" class="Symbol">(</a><a id="2651" href="UALib.Algebras.Lifts.html#2630" class="Bound">X</a> <a id="2653" class="Symbol">→</a> <a id="2655" href="UALib.Algebras.Lifts.html#2639" class="Bound">Y</a><a id="2656" class="Symbol">)</a> <a id="2658" class="Symbol">→</a> <a id="2660" class="Symbol">(</a><a id="2661" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a><a id="2665" class="Symbol">{</a><a id="2666" href="UALib.Algebras.Lifts.html#2612" class="Bound">𝓧</a><a id="2667" class="Symbol">}{</a><a id="2669" href="UALib.Algebras.Lifts.html#2616" class="Bound">𝓦</a><a id="2670" class="Symbol">}</a> <a id="2672" href="UALib.Algebras.Lifts.html#2630" class="Bound">X</a> <a id="2674" class="Symbol">→</a> <a id="2676" href="UALib.Algebras.Lifts.html#2639" class="Bound">Y</a><a id="2677" class="Symbol">)</a>
<a id="2679" href="UALib.Algebras.Lifts.html#2600" class="Function">lift-dom</a> <a id="2688" href="UALib.Algebras.Lifts.html#2688" class="Bound">f</a> <a id="2690" class="Symbol">=</a> <a id="2692" class="Symbol">λ</a> <a id="2694" href="UALib.Algebras.Lifts.html#2694" class="Bound">x</a> <a id="2696" class="Symbol">→</a> <a id="2698" class="Symbol">(</a><a id="2699" href="UALib.Algebras.Lifts.html#2688" class="Bound">f</a> <a id="2701" class="Symbol">(</a><a id="2702" href="UALib.Algebras.Lifts.html#2501" class="Field">lower</a> <a id="2708" href="UALib.Algebras.Lifts.html#2694" class="Bound">x</a><a id="2709" class="Symbol">))</a>

<a id="lift-cod"></a><a id="2713" href="UALib.Algebras.Lifts.html#2713" class="Function">lift-cod</a> <a id="2722" class="Symbol">:</a> <a id="2724" class="Symbol">{</a><a id="2725" href="UALib.Algebras.Lifts.html#2725" class="Bound">𝓧</a> <a id="2727" href="UALib.Algebras.Lifts.html#2727" class="Bound">𝓨</a> <a id="2729" href="UALib.Algebras.Lifts.html#2729" class="Bound">𝓦</a> <a id="2731" class="Symbol">:</a> <a id="2733" href="universes.html#551" class="Postulate">Universe</a><a id="2741" class="Symbol">}{</a><a id="2743" href="UALib.Algebras.Lifts.html#2743" class="Bound">X</a> <a id="2745" class="Symbol">:</a> <a id="2747" href="UALib.Algebras.Lifts.html#2725" class="Bound">𝓧</a> <a id="2749" href="universes.html#758" class="Function Operator">̇</a><a id="2750" class="Symbol">}{</a><a id="2752" href="UALib.Algebras.Lifts.html#2752" class="Bound">Y</a> <a id="2754" class="Symbol">:</a> <a id="2756" href="UALib.Algebras.Lifts.html#2727" class="Bound">𝓨</a> <a id="2758" href="universes.html#758" class="Function Operator">̇</a><a id="2759" class="Symbol">}</a> <a id="2761" class="Symbol">→</a> <a id="2763" class="Symbol">(</a><a id="2764" href="UALib.Algebras.Lifts.html#2743" class="Bound">X</a> <a id="2766" class="Symbol">→</a> <a id="2768" href="UALib.Algebras.Lifts.html#2752" class="Bound">Y</a><a id="2769" class="Symbol">)</a> <a id="2771" class="Symbol">→</a> <a id="2773" class="Symbol">(</a><a id="2774" href="UALib.Algebras.Lifts.html#2743" class="Bound">X</a> <a id="2776" class="Symbol">→</a> <a id="2778" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a><a id="2782" class="Symbol">{</a><a id="2783" href="UALib.Algebras.Lifts.html#2727" class="Bound">𝓨</a><a id="2784" class="Symbol">}{</a><a id="2786" href="UALib.Algebras.Lifts.html#2729" class="Bound">𝓦</a><a id="2787" class="Symbol">}</a> <a id="2789" href="UALib.Algebras.Lifts.html#2752" class="Bound">Y</a><a id="2790" class="Symbol">)</a>
<a id="2792" href="UALib.Algebras.Lifts.html#2713" class="Function">lift-cod</a> <a id="2801" href="UALib.Algebras.Lifts.html#2801" class="Bound">f</a> <a id="2803" class="Symbol">=</a> <a id="2805" class="Symbol">λ</a> <a id="2807" href="UALib.Algebras.Lifts.html#2807" class="Bound">x</a> <a id="2809" class="Symbol">→</a> <a id="2811" href="UALib.Algebras.Lifts.html#2489" class="InductiveConstructor">lift</a> <a id="2816" class="Symbol">(</a><a id="2817" href="UALib.Algebras.Lifts.html#2801" class="Bound">f</a> <a id="2819" href="UALib.Algebras.Lifts.html#2807" class="Bound">x</a><a id="2820" class="Symbol">)</a>

<a id="lift-fun"></a><a id="2823" href="UALib.Algebras.Lifts.html#2823" class="Function">lift-fun</a> <a id="2832" class="Symbol">:</a> <a id="2834" class="Symbol">{</a><a id="2835" href="UALib.Algebras.Lifts.html#2835" class="Bound">𝓧</a> <a id="2837" href="UALib.Algebras.Lifts.html#2837" class="Bound">𝓨</a> <a id="2839" href="UALib.Algebras.Lifts.html#2839" class="Bound">𝓦</a> <a id="2841" href="UALib.Algebras.Lifts.html#2841" class="Bound">𝓩</a> <a id="2843" class="Symbol">:</a> <a id="2845" href="universes.html#551" class="Postulate">Universe</a><a id="2853" class="Symbol">}{</a><a id="2855" href="UALib.Algebras.Lifts.html#2855" class="Bound">X</a> <a id="2857" class="Symbol">:</a> <a id="2859" href="UALib.Algebras.Lifts.html#2835" class="Bound">𝓧</a> <a id="2861" href="universes.html#758" class="Function Operator">̇</a><a id="2862" class="Symbol">}{</a><a id="2864" href="UALib.Algebras.Lifts.html#2864" class="Bound">Y</a> <a id="2866" class="Symbol">:</a> <a id="2868" href="UALib.Algebras.Lifts.html#2837" class="Bound">𝓨</a> <a id="2870" href="universes.html#758" class="Function Operator">̇</a><a id="2871" class="Symbol">}</a> <a id="2873" class="Symbol">→</a> <a id="2875" class="Symbol">(</a><a id="2876" href="UALib.Algebras.Lifts.html#2855" class="Bound">X</a> <a id="2878" class="Symbol">→</a> <a id="2880" href="UALib.Algebras.Lifts.html#2864" class="Bound">Y</a><a id="2881" class="Symbol">)</a> <a id="2883" class="Symbol">→</a> <a id="2885" class="Symbol">(</a><a id="2886" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a><a id="2890" class="Symbol">{</a><a id="2891" href="UALib.Algebras.Lifts.html#2835" class="Bound">𝓧</a><a id="2892" class="Symbol">}{</a><a id="2894" href="UALib.Algebras.Lifts.html#2839" class="Bound">𝓦</a><a id="2895" class="Symbol">}</a> <a id="2897" href="UALib.Algebras.Lifts.html#2855" class="Bound">X</a> <a id="2899" class="Symbol">→</a> <a id="2901" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a><a id="2905" class="Symbol">{</a><a id="2906" href="UALib.Algebras.Lifts.html#2837" class="Bound">𝓨</a><a id="2907" class="Symbol">}{</a><a id="2909" href="UALib.Algebras.Lifts.html#2841" class="Bound">𝓩</a><a id="2910" class="Symbol">}</a> <a id="2912" href="UALib.Algebras.Lifts.html#2864" class="Bound">Y</a><a id="2913" class="Symbol">)</a>
<a id="2915" href="UALib.Algebras.Lifts.html#2823" class="Function">lift-fun</a> <a id="2924" href="UALib.Algebras.Lifts.html#2924" class="Bound">f</a> <a id="2926" class="Symbol">=</a> <a id="2928" class="Symbol">λ</a> <a id="2930" href="UALib.Algebras.Lifts.html#2930" class="Bound">x</a> <a id="2932" class="Symbol">→</a> <a id="2934" href="UALib.Algebras.Lifts.html#2489" class="InductiveConstructor">lift</a> <a id="2939" class="Symbol">(</a><a id="2940" href="UALib.Algebras.Lifts.html#2924" class="Bound">f</a> <a id="2942" class="Symbol">(</a><a id="2943" href="UALib.Algebras.Lifts.html#2501" class="Field">lower</a> <a id="2949" href="UALib.Algebras.Lifts.html#2930" class="Bound">x</a><a id="2950" class="Symbol">))</a>

</pre>

We will also need to know that lift and lower compose to the identity.

<pre class="Agda">

<a id="lower∼lift"></a><a id="3052" href="UALib.Algebras.Lifts.html#3052" class="Function">lower∼lift</a> <a id="3063" class="Symbol">:</a> <a id="3065" class="Symbol">{</a><a id="3066" href="UALib.Algebras.Lifts.html#3066" class="Bound">𝓧</a> <a id="3068" href="UALib.Algebras.Lifts.html#3068" class="Bound">𝓦</a> <a id="3070" class="Symbol">:</a> <a id="3072" href="universes.html#551" class="Postulate">Universe</a><a id="3080" class="Symbol">}{</a><a id="3082" href="UALib.Algebras.Lifts.html#3082" class="Bound">X</a> <a id="3084" class="Symbol">:</a> <a id="3086" href="UALib.Algebras.Lifts.html#3066" class="Bound">𝓧</a> <a id="3088" href="universes.html#758" class="Function Operator">̇</a><a id="3089" class="Symbol">}</a> <a id="3091" class="Symbol">→</a> <a id="3093" href="UALib.Algebras.Lifts.html#2501" class="Field">lower</a><a id="3098" class="Symbol">{</a><a id="3099" href="UALib.Algebras.Lifts.html#3066" class="Bound">𝓧</a><a id="3100" class="Symbol">}{</a><a id="3102" href="UALib.Algebras.Lifts.html#3068" class="Bound">𝓦</a><a id="3103" class="Symbol">}</a> <a id="3105" href="MGS-MLTT.html#3813" class="Function Operator">∘</a> <a id="3107" href="UALib.Algebras.Lifts.html#2489" class="InductiveConstructor">lift</a> <a id="3112" href="UALib.Prelude.Preliminaries.html#5705" class="Datatype Operator">≡</a> <a id="3114" href="MGS-MLTT.html#3778" class="Function">𝑖𝑑</a> <a id="3117" href="UALib.Algebras.Lifts.html#3082" class="Bound">X</a>
<a id="3119" href="UALib.Algebras.Lifts.html#3052" class="Function">lower∼lift</a> <a id="3130" class="Symbol">=</a> <a id="3132" href="UALib.Prelude.Preliminaries.html#5741" class="InductiveConstructor">refl</a> <a id="3137" class="Symbol">_</a>

<a id="lift∼lower"></a><a id="3140" href="UALib.Algebras.Lifts.html#3140" class="Function">lift∼lower</a> <a id="3151" class="Symbol">:</a> <a id="3153" class="Symbol">{</a><a id="3154" href="UALib.Algebras.Lifts.html#3154" class="Bound">𝓧</a> <a id="3156" href="UALib.Algebras.Lifts.html#3156" class="Bound">𝓦</a> <a id="3158" class="Symbol">:</a> <a id="3160" href="universes.html#551" class="Postulate">Universe</a><a id="3168" class="Symbol">}{</a><a id="3170" href="UALib.Algebras.Lifts.html#3170" class="Bound">X</a> <a id="3172" class="Symbol">:</a> <a id="3174" href="UALib.Algebras.Lifts.html#3154" class="Bound">𝓧</a> <a id="3176" href="universes.html#758" class="Function Operator">̇</a><a id="3177" class="Symbol">}</a> <a id="3179" class="Symbol">→</a> <a id="3181" href="UALib.Algebras.Lifts.html#2489" class="InductiveConstructor">lift</a> <a id="3186" href="MGS-MLTT.html#3813" class="Function Operator">∘</a> <a id="3188" href="UALib.Algebras.Lifts.html#2501" class="Field">lower</a> <a id="3194" href="UALib.Prelude.Preliminaries.html#5705" class="Datatype Operator">≡</a> <a id="3196" href="MGS-MLTT.html#3778" class="Function">𝑖𝑑</a> <a id="3199" class="Symbol">(</a><a id="3200" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a><a id="3204" class="Symbol">{</a><a id="3205" href="UALib.Algebras.Lifts.html#3154" class="Bound">𝓧</a><a id="3206" class="Symbol">}{</a><a id="3208" href="UALib.Algebras.Lifts.html#3156" class="Bound">𝓦</a><a id="3209" class="Symbol">}</a> <a id="3211" href="UALib.Algebras.Lifts.html#3170" class="Bound">X</a><a id="3212" class="Symbol">)</a>
<a id="3214" href="UALib.Algebras.Lifts.html#3140" class="Function">lift∼lower</a> <a id="3225" class="Symbol">=</a> <a id="3227" href="UALib.Prelude.Preliminaries.html#5741" class="InductiveConstructor">refl</a> <a id="3232" class="Symbol">_</a>

</pre>

Now, getting more "domain-specific," we show how to lift algebraic operation types and then, finally, algebra types themselves.

<pre class="Agda">

<a id="3390" class="Keyword">module</a> <a id="3397" href="UALib.Algebras.Lifts.html#3397" class="Module">_</a> <a id="3399" class="Symbol">{</a><a id="3400" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a> <a id="3402" class="Symbol">:</a> <a id="3404" href="MGS-MLTT.html#3074" class="Function">Σ</a> <a id="3406" href="UALib.Algebras.Lifts.html#3406" class="Bound">F</a> <a id="3408" href="MGS-MLTT.html#3074" class="Function">꞉</a> <a id="3410" href="universes.html#613" class="Generalizable">𝓞</a> <a id="3412" href="universes.html#758" class="Function Operator">̇</a> <a id="3414" href="MGS-MLTT.html#3074" class="Function">,</a> <a id="3416" class="Symbol">(</a> <a id="3418" href="UALib.Algebras.Lifts.html#3406" class="Bound">F</a> <a id="3420" class="Symbol">→</a> <a id="3422" href="universes.html#617" class="Generalizable">𝓥</a> <a id="3424" href="universes.html#758" class="Function Operator">̇</a><a id="3425" class="Symbol">)}</a> <a id="3428" class="Keyword">where</a>

 <a id="3436" href="UALib.Algebras.Lifts.html#3436" class="Function">lift-op</a> <a id="3444" class="Symbol">:</a> <a id="3446" class="Symbol">{</a><a id="3447" href="UALib.Algebras.Lifts.html#3447" class="Bound">𝓤</a> <a id="3449" class="Symbol">:</a> <a id="3451" href="universes.html#551" class="Postulate">Universe</a><a id="3459" class="Symbol">}{</a><a id="3461" href="UALib.Algebras.Lifts.html#3461" class="Bound">I</a> <a id="3463" class="Symbol">:</a> <a id="3465" href="UALib.Algebras.Lifts.html#3422" class="Bound">𝓥</a> <a id="3467" href="universes.html#758" class="Function Operator">̇</a><a id="3468" class="Symbol">}{</a><a id="3470" href="UALib.Algebras.Lifts.html#3470" class="Bound">A</a> <a id="3472" class="Symbol">:</a> <a id="3474" href="UALib.Algebras.Lifts.html#3447" class="Bound">𝓤</a> <a id="3476" href="universes.html#758" class="Function Operator">̇</a><a id="3477" class="Symbol">}</a>
  <a id="3481" class="Symbol">→</a>        <a id="3490" class="Symbol">((</a><a id="3492" href="UALib.Algebras.Lifts.html#3461" class="Bound">I</a> <a id="3494" class="Symbol">→</a> <a id="3496" href="UALib.Algebras.Lifts.html#3470" class="Bound">A</a><a id="3497" class="Symbol">)</a> <a id="3499" class="Symbol">→</a> <a id="3501" href="UALib.Algebras.Lifts.html#3470" class="Bound">A</a><a id="3502" class="Symbol">)</a> <a id="3504" class="Symbol">→</a> <a id="3506" class="Symbol">(</a><a id="3507" href="UALib.Algebras.Lifts.html#3507" class="Bound">𝓦</a> <a id="3509" class="Symbol">:</a> <a id="3511" href="universes.html#551" class="Postulate">Universe</a><a id="3519" class="Symbol">)</a>
  <a id="3523" class="Symbol">→</a>        <a id="3532" class="Symbol">((</a><a id="3534" href="UALib.Algebras.Lifts.html#3461" class="Bound">I</a> <a id="3536" class="Symbol">→</a> <a id="3538" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a><a id="3542" class="Symbol">{</a><a id="3543" href="UALib.Algebras.Lifts.html#3447" class="Bound">𝓤</a><a id="3544" class="Symbol">}{</a><a id="3546" href="UALib.Algebras.Lifts.html#3507" class="Bound">𝓦</a><a id="3547" class="Symbol">}</a><a id="3548" href="UALib.Algebras.Lifts.html#3470" class="Bound">A</a><a id="3549" class="Symbol">)</a> <a id="3551" class="Symbol">→</a> <a id="3553" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a><a id="3557" class="Symbol">{</a><a id="3558" href="UALib.Algebras.Lifts.html#3447" class="Bound">𝓤</a><a id="3559" class="Symbol">}{</a><a id="3561" href="UALib.Algebras.Lifts.html#3507" class="Bound">𝓦</a><a id="3562" class="Symbol">}</a><a id="3563" href="UALib.Algebras.Lifts.html#3470" class="Bound">A</a><a id="3564" class="Symbol">)</a>
 <a id="3567" href="UALib.Algebras.Lifts.html#3436" class="Function">lift-op</a> <a id="3575" href="UALib.Algebras.Lifts.html#3575" class="Bound">f</a> <a id="3577" href="UALib.Algebras.Lifts.html#3577" class="Bound">𝓦</a> <a id="3579" class="Symbol">=</a> <a id="3581" class="Symbol">λ</a> <a id="3583" href="UALib.Algebras.Lifts.html#3583" class="Bound">x</a> <a id="3585" class="Symbol">→</a> <a id="3587" href="UALib.Algebras.Lifts.html#2489" class="InductiveConstructor">lift</a> <a id="3592" class="Symbol">(</a><a id="3593" href="UALib.Algebras.Lifts.html#3575" class="Bound">f</a> <a id="3595" class="Symbol">(λ</a> <a id="3598" href="UALib.Algebras.Lifts.html#3598" class="Bound">i</a> <a id="3600" class="Symbol">→</a> <a id="3602" href="UALib.Algebras.Lifts.html#2501" class="Field">lower</a> <a id="3608" class="Symbol">(</a><a id="3609" href="UALib.Algebras.Lifts.html#3583" class="Bound">x</a> <a id="3611" href="UALib.Algebras.Lifts.html#3598" class="Bound">i</a><a id="3612" class="Symbol">)))</a>

 <a id="3618" class="Keyword">open</a> <a id="3623" href="UALib.Algebras.Algebras.html#2393" class="Module">algebra</a>

 <a id="3633" href="UALib.Algebras.Lifts.html#3633" class="Function">lift-alg-record-type</a> <a id="3654" class="Symbol">:</a> <a id="3656" class="Symbol">{</a><a id="3657" href="UALib.Algebras.Lifts.html#3657" class="Bound">𝓤</a> <a id="3659" class="Symbol">:</a> <a id="3661" href="universes.html#551" class="Postulate">Universe</a><a id="3669" class="Symbol">}</a> <a id="3671" class="Symbol">→</a> <a id="3673" href="UALib.Algebras.Algebras.html#2393" class="Record">algebra</a> <a id="3681" href="UALib.Algebras.Lifts.html#3657" class="Bound">𝓤</a> <a id="3683" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a> <a id="3685" class="Symbol">→</a> <a id="3687" class="Symbol">(</a><a id="3688" href="UALib.Algebras.Lifts.html#3688" class="Bound">𝓦</a> <a id="3690" class="Symbol">:</a> <a id="3692" href="universes.html#551" class="Postulate">Universe</a><a id="3700" class="Symbol">)</a> <a id="3702" class="Symbol">→</a> <a id="3704" href="UALib.Algebras.Algebras.html#2393" class="Record">algebra</a> <a id="3712" class="Symbol">(</a><a id="3713" href="UALib.Algebras.Lifts.html#3657" class="Bound">𝓤</a> <a id="3715" href="Agda.Primitive.html#636" class="Primitive Operator">⊔</a> <a id="3717" href="UALib.Algebras.Lifts.html#3688" class="Bound">𝓦</a><a id="3718" class="Symbol">)</a> <a id="3720" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a>
 <a id="3723" href="UALib.Algebras.Lifts.html#3633" class="Function">lift-alg-record-type</a> <a id="3744" href="UALib.Algebras.Lifts.html#3744" class="Bound">𝑨</a> <a id="3746" href="UALib.Algebras.Lifts.html#3746" class="Bound">𝓦</a> <a id="3748" class="Symbol">=</a> <a id="3750" href="UALib.Algebras.Algebras.html#2474" class="InductiveConstructor">mkalg</a> <a id="3756" class="Symbol">(</a><a id="3757" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a> <a id="3762" class="Symbol">(</a><a id="3763" href="UALib.Algebras.Algebras.html#2491" class="Field">univ</a> <a id="3768" href="UALib.Algebras.Lifts.html#3744" class="Bound">𝑨</a><a id="3769" class="Symbol">))</a> <a id="3772" class="Symbol">(λ</a> <a id="3775" class="Symbol">(</a><a id="3776" href="UALib.Algebras.Lifts.html#3776" class="Bound">f</a> <a id="3778" class="Symbol">:</a> <a id="3780" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a> <a id="3782" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a> <a id="3784" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a><a id="3785" class="Symbol">)</a> <a id="3787" class="Symbol">→</a> <a id="3789" href="UALib.Algebras.Lifts.html#3436" class="Function">lift-op</a> <a id="3797" class="Symbol">((</a><a id="3799" href="UALib.Algebras.Algebras.html#2505" class="Field">op</a> <a id="3802" href="UALib.Algebras.Lifts.html#3744" class="Bound">𝑨</a><a id="3803" class="Symbol">)</a> <a id="3805" href="UALib.Algebras.Lifts.html#3776" class="Bound">f</a><a id="3806" class="Symbol">)</a> <a id="3808" href="UALib.Algebras.Lifts.html#3746" class="Bound">𝓦</a><a id="3809" class="Symbol">)</a>

 <a id="3813" href="UALib.Algebras.Lifts.html#3813" class="Function">lift-∞-algebra</a> <a id="3828" href="UALib.Algebras.Lifts.html#3828" class="Function">lift-alg</a> <a id="3837" class="Symbol">:</a> <a id="3839" class="Symbol">{</a><a id="3840" href="UALib.Algebras.Lifts.html#3840" class="Bound">𝓤</a> <a id="3842" class="Symbol">:</a> <a id="3844" href="universes.html#551" class="Postulate">Universe</a><a id="3852" class="Symbol">}</a> <a id="3854" class="Symbol">→</a> <a id="3856" href="UALib.Algebras.Algebras.html#811" class="Function">Algebra</a> <a id="3864" href="UALib.Algebras.Lifts.html#3840" class="Bound">𝓤</a> <a id="3866" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a> <a id="3868" class="Symbol">→</a> <a id="3870" class="Symbol">(</a><a id="3871" href="UALib.Algebras.Lifts.html#3871" class="Bound">𝓦</a> <a id="3873" class="Symbol">:</a> <a id="3875" href="universes.html#551" class="Postulate">Universe</a><a id="3883" class="Symbol">)</a> <a id="3885" class="Symbol">→</a> <a id="3887" href="UALib.Algebras.Algebras.html#811" class="Function">Algebra</a> <a id="3895" class="Symbol">(</a><a id="3896" href="UALib.Algebras.Lifts.html#3840" class="Bound">𝓤</a> <a id="3898" href="Agda.Primitive.html#636" class="Primitive Operator">⊔</a> <a id="3900" href="UALib.Algebras.Lifts.html#3871" class="Bound">𝓦</a><a id="3901" class="Symbol">)</a> <a id="3903" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a>
 <a id="3906" href="UALib.Algebras.Lifts.html#3813" class="Function">lift-∞-algebra</a> <a id="3921" href="UALib.Algebras.Lifts.html#3921" class="Bound">𝑨</a> <a id="3923" href="UALib.Algebras.Lifts.html#3923" class="Bound">𝓦</a> <a id="3925" class="Symbol">=</a> <a id="3927" href="UALib.Algebras.Lifts.html#2427" class="Record">Lift</a> <a id="3932" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a> <a id="3934" href="UALib.Algebras.Lifts.html#3921" class="Bound">𝑨</a> <a id="3936" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a> <a id="3938" href="UALib.Prelude.Preliminaries.html#5814" class="InductiveConstructor Operator">,</a> <a id="3940" class="Symbol">(λ</a> <a id="3943" class="Symbol">(</a><a id="3944" href="UALib.Algebras.Lifts.html#3944" class="Bound">f</a> <a id="3946" class="Symbol">:</a> <a id="3948" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a> <a id="3950" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a> <a id="3952" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a><a id="3953" class="Symbol">)</a> <a id="3955" class="Symbol">→</a> <a id="3957" href="UALib.Algebras.Lifts.html#3436" class="Function">lift-op</a> <a id="3965" class="Symbol">(</a><a id="3966" href="UALib.Prelude.Preliminaries.html#10366" class="Function Operator">∥</a> <a id="3968" href="UALib.Algebras.Lifts.html#3921" class="Bound">𝑨</a> <a id="3970" href="UALib.Prelude.Preliminaries.html#10366" class="Function Operator">∥</a> <a id="3972" href="UALib.Algebras.Lifts.html#3944" class="Bound">f</a><a id="3973" class="Symbol">)</a> <a id="3975" href="UALib.Algebras.Lifts.html#3923" class="Bound">𝓦</a><a id="3976" class="Symbol">)</a>
 <a id="3979" href="UALib.Algebras.Lifts.html#3828" class="Function">lift-alg</a> <a id="3988" class="Symbol">=</a> <a id="3990" href="UALib.Algebras.Lifts.html#3813" class="Function">lift-∞-algebra</a>

</pre>

Finally,  we will we want to make the blanket assumption throughout the library that we always have an arbitrary large collection `X` of variable symbols and, no matter in what type the domain of our algebra lies, we can always find a surjective map h₀ : X → ∣ 𝑨 ∣ from our arbitrary collection of variables onto the domain of 𝑨.

<pre class="Agda">

 <a id="4364" href="UALib.Algebras.Lifts.html#4364" class="Function Operator">_↠_</a> <a id="4368" class="Symbol">:</a> <a id="4370" class="Symbol">{</a><a id="4371" href="UALib.Algebras.Lifts.html#4371" class="Bound">𝓤</a> <a id="4373" href="UALib.Algebras.Lifts.html#4373" class="Bound">𝓧</a> <a id="4375" class="Symbol">:</a> <a id="4377" href="universes.html#551" class="Postulate">Universe</a><a id="4385" class="Symbol">}</a> <a id="4387" class="Symbol">→</a> <a id="4389" href="UALib.Algebras.Lifts.html#4373" class="Bound">𝓧</a> <a id="4391" href="universes.html#758" class="Function Operator">̇</a> <a id="4393" class="Symbol">→</a> <a id="4395" href="UALib.Algebras.Algebras.html#811" class="Function">Algebra</a> <a id="4403" href="UALib.Algebras.Lifts.html#4371" class="Bound">𝓤</a> <a id="4405" href="UALib.Algebras.Lifts.html#3400" class="Bound">𝑆</a> <a id="4407" class="Symbol">→</a> <a id="4409" href="UALib.Algebras.Lifts.html#4373" class="Bound">𝓧</a> <a id="4411" href="Agda.Primitive.html#636" class="Primitive Operator">⊔</a> <a id="4413" href="UALib.Algebras.Lifts.html#4371" class="Bound">𝓤</a> <a id="4415" href="universes.html#758" class="Function Operator">̇</a>
 <a id="4418" href="UALib.Algebras.Lifts.html#4418" class="Bound">X</a> <a id="4420" href="UALib.Algebras.Lifts.html#4364" class="Function Operator">↠</a> <a id="4422" href="UALib.Algebras.Lifts.html#4422" class="Bound">𝑨</a> <a id="4424" class="Symbol">=</a> <a id="4426" href="MGS-MLTT.html#3074" class="Function">Σ</a> <a id="4428" href="UALib.Algebras.Lifts.html#4428" class="Bound">h</a> <a id="4430" href="MGS-MLTT.html#3074" class="Function">꞉</a> <a id="4432" class="Symbol">(</a><a id="4433" href="UALib.Algebras.Lifts.html#4418" class="Bound">X</a> <a id="4435" class="Symbol">→</a> <a id="4437" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a> <a id="4439" href="UALib.Algebras.Lifts.html#4422" class="Bound">𝑨</a> <a id="4441" href="UALib.Prelude.Preliminaries.html#10288" class="Function Operator">∣</a><a id="4442" class="Symbol">)</a> <a id="4444" href="MGS-MLTT.html#3074" class="Function">,</a> <a id="4446" href="UALib.Prelude.Inverses.html#2305" class="Function">Epic</a> <a id="4451" href="UALib.Algebras.Lifts.html#4428" class="Bound">h</a>

</pre>

---------------

[← UALib.Algebras.Products](UALib.Algebras.Products.html)
<span style="float:right;">[UALib.Relations →](UALib.Relations.html)</span>

{% include UALib.Links.md %}