---
layout: default
---
<pre class="Agda">
    <a id="1" class="Comment">------------------------------------------------------------------------</a>
<a id="74" class="Comment">-- The Agda standard library</a>
<a id="103" class="Comment">--</a>
<a id="106" class="Comment">-- Operations on nullary relations (like negation and decidability)</a>
<a id="174" class="Comment">------------------------------------------------------------------------</a>

<a id="248" class="Comment">-- Some operations on/properties of nullary relations, i.e. sets.</a>

<a id="315" class="Symbol">{-#</a> <a id="319" class="Keyword">OPTIONS</a> <a id="327" class="Pragma">--without-K</a> <a id="339" class="Pragma">--safe</a> <a id="346" class="Symbol">#-}</a>

<a id="351" class="Keyword">module</a> <a id="358" href="Relation.Nullary.html" class="Module">Relation.Nullary</a> <a id="375" class="Keyword">where</a>

<a id="382" class="Keyword">open</a> <a id="387" class="Keyword">import</a> <a id="394" href="Agda.Builtin.Equality.html" class="Module">Agda.Builtin.Equality</a>

<a id="417" class="Keyword">open</a> <a id="422" class="Keyword">import</a> <a id="429" href="Data.Empty.html" class="Module">Data.Empty</a> <a id="440" class="Keyword">hiding</a> <a id="447" class="Symbol">(</a><a id="448" href="Data.Empty.html#294" class="Function">⊥-elim</a><a id="454" class="Symbol">)</a>
<a id="456" class="Keyword">open</a> <a id="461" class="Keyword">import</a> <a id="468" href="Data.Empty.Irrelevant.html" class="Module">Data.Empty.Irrelevant</a>
<a id="490" class="Keyword">open</a> <a id="495" class="Keyword">import</a> <a id="502" href="Level.html" class="Module">Level</a>

<a id="509" class="Comment">-- Negation.</a>

<a id="523" class="Keyword">infix</a> <a id="529" class="Number">3</a> <a id="531" href="Relation.Nullary.html#535" class="Function Operator">¬_</a>

<a id="¬_"></a><a id="535" href="Relation.Nullary.html#535" class="Function Operator">¬_</a> <a id="538" class="Symbol">:</a> <a id="540" class="Symbol">∀</a> <a id="542" class="Symbol">{</a><a id="543" href="Relation.Nullary.html#543" class="Bound">ℓ</a><a id="544" class="Symbol">}</a> <a id="546" class="Symbol">→</a> <a id="548" class="PrimitiveType">Set</a> <a id="552" href="Relation.Nullary.html#543" class="Bound">ℓ</a> <a id="554" class="Symbol">→</a> <a id="556" class="PrimitiveType">Set</a> <a id="560" href="Relation.Nullary.html#543" class="Bound">ℓ</a>
<a id="562" href="Relation.Nullary.html#535" class="Function Operator">¬</a> <a id="564" href="Relation.Nullary.html#564" class="Bound">P</a> <a id="566" class="Symbol">=</a> <a id="568" href="Relation.Nullary.html#564" class="Bound">P</a> <a id="570" class="Symbol">→</a> <a id="572" href="Data.Empty.html#279" class="Datatype">⊥</a>

<a id="575" class="Comment">-- Decidable relations.</a>

<a id="600" class="Keyword">data</a> <a id="Dec"></a><a id="605" href="Relation.Nullary.html#605" class="Datatype">Dec</a> <a id="609" class="Symbol">{</a><a id="610" href="Relation.Nullary.html#610" class="Bound">p</a><a id="611" class="Symbol">}</a> <a id="613" class="Symbol">(</a><a id="614" href="Relation.Nullary.html#614" class="Bound">P</a> <a id="616" class="Symbol">:</a> <a id="618" class="PrimitiveType">Set</a> <a id="622" href="Relation.Nullary.html#610" class="Bound">p</a><a id="623" class="Symbol">)</a> <a id="625" class="Symbol">:</a> <a id="627" class="PrimitiveType">Set</a> <a id="631" href="Relation.Nullary.html#610" class="Bound">p</a> <a id="633" class="Keyword">where</a>
  <a id="Dec.yes"></a><a id="641" href="Relation.Nullary.html#641" class="InductiveConstructor">yes</a> <a id="645" class="Symbol">:</a> <a id="647" class="Symbol">(</a> <a id="649" href="Relation.Nullary.html#649" class="Bound">p</a> <a id="651" class="Symbol">:</a>   <a id="655" href="Relation.Nullary.html#614" class="Bound">P</a><a id="656" class="Symbol">)</a> <a id="658" class="Symbol">→</a> <a id="660" href="Relation.Nullary.html#605" class="Datatype">Dec</a> <a id="664" href="Relation.Nullary.html#614" class="Bound">P</a>
  <a id="Dec.no"></a><a id="668" href="Relation.Nullary.html#668" class="InductiveConstructor">no</a>  <a id="672" class="Symbol">:</a> <a id="674" class="Symbol">(</a><a id="675" href="Relation.Nullary.html#675" class="Bound">¬p</a> <a id="678" class="Symbol">:</a> <a id="680" href="Relation.Nullary.html#535" class="Function Operator">¬</a> <a id="682" href="Relation.Nullary.html#614" class="Bound">P</a><a id="683" class="Symbol">)</a> <a id="685" class="Symbol">→</a> <a id="687" href="Relation.Nullary.html#605" class="Datatype">Dec</a> <a id="691" href="Relation.Nullary.html#614" class="Bound">P</a>

<a id="694" class="Comment">-- Given an irrelevant proof of a decidable type, a proof can</a>
<a id="756" class="Comment">-- be recomputed and subsequently used in relevant contexts.</a>
<a id="recompute"></a><a id="817" href="Relation.Nullary.html#817" class="Function">recompute</a> <a id="827" class="Symbol">:</a> <a id="829" class="Symbol">∀</a> <a id="831" class="Symbol">{</a><a id="832" href="Relation.Nullary.html#832" class="Bound">a</a><a id="833" class="Symbol">}</a> <a id="835" class="Symbol">{</a><a id="836" href="Relation.Nullary.html#836" class="Bound">A</a> <a id="838" class="Symbol">:</a> <a id="840" class="PrimitiveType">Set</a> <a id="844" href="Relation.Nullary.html#832" class="Bound">a</a><a id="845" class="Symbol">}</a> <a id="847" class="Symbol">→</a> <a id="849" href="Relation.Nullary.html#605" class="Datatype">Dec</a> <a id="853" href="Relation.Nullary.html#836" class="Bound">A</a> <a id="855" class="Symbol">→</a> <a id="857" class="Symbol">.</a><a id="858" href="Relation.Nullary.html#836" class="Bound">A</a> <a id="860" class="Symbol">→</a> <a id="862" href="Relation.Nullary.html#836" class="Bound">A</a>
<a id="864" href="Relation.Nullary.html#817" class="Function">recompute</a> <a id="874" class="Symbol">(</a><a id="875" href="Relation.Nullary.html#641" class="InductiveConstructor">yes</a> <a id="879" href="Relation.Nullary.html#879" class="Bound">x</a><a id="880" class="Symbol">)</a> <a id="882" class="Symbol">_</a> <a id="884" class="Symbol">=</a> <a id="886" href="Relation.Nullary.html#879" class="Bound">x</a>
<a id="888" href="Relation.Nullary.html#817" class="Function">recompute</a> <a id="898" class="Symbol">(</a><a id="899" href="Relation.Nullary.html#668" class="InductiveConstructor">no</a> <a id="902" href="Relation.Nullary.html#902" class="Bound">¬p</a><a id="904" class="Symbol">)</a> <a id="906" href="Relation.Nullary.html#906" class="Bound">x</a> <a id="908" class="Symbol">=</a> <a id="910" href="Data.Empty.Irrelevant.html#327" class="Function">⊥-elim</a> <a id="917" class="Symbol">(</a><a id="918" href="Relation.Nullary.html#902" class="Bound">¬p</a> <a id="921" href="Relation.Nullary.html#906" class="Bound">x</a><a id="922" class="Symbol">)</a>

<a id="Irrelevant"></a><a id="925" href="Relation.Nullary.html#925" class="Function">Irrelevant</a> <a id="936" class="Symbol">:</a> <a id="938" class="Symbol">∀</a> <a id="940" class="Symbol">{</a><a id="941" href="Relation.Nullary.html#941" class="Bound">p</a><a id="942" class="Symbol">}</a> <a id="944" class="Symbol">→</a> <a id="946" class="PrimitiveType">Set</a> <a id="950" href="Relation.Nullary.html#941" class="Bound">p</a> <a id="952" class="Symbol">→</a> <a id="954" class="PrimitiveType">Set</a> <a id="958" href="Relation.Nullary.html#941" class="Bound">p</a>
<a id="960" href="Relation.Nullary.html#925" class="Function">Irrelevant</a> <a id="971" href="Relation.Nullary.html#971" class="Bound">P</a> <a id="973" class="Symbol">=</a> <a id="975" class="Symbol">∀</a> <a id="977" class="Symbol">(</a><a id="978" href="Relation.Nullary.html#978" class="Bound">p₁</a> <a id="981" href="Relation.Nullary.html#981" class="Bound">p₂</a> <a id="984" class="Symbol">:</a> <a id="986" href="Relation.Nullary.html#971" class="Bound">P</a><a id="987" class="Symbol">)</a> <a id="989" class="Symbol">→</a> <a id="991" href="Relation.Nullary.html#978" class="Bound">p₁</a> <a id="994" href="Agda.Builtin.Equality.html#151" class="Datatype Operator">≡</a> <a id="996" href="Relation.Nullary.html#981" class="Bound">p₂</a>
</pre>