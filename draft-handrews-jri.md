---
title: JSON Reference and Identification
abbrev:
docname: draft-handrews-jri-latest
workgroup: Internet Engineering Task Force
submissionType: IETF
category: info

ipr: trust200902
area: Applications and Real-Time
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline, docmapping]

author:
 -
    ins: H. Andrews
    name: Henry Andrews
    email: andrews_henry@yahoo.com
    country: U.S.A.

normative:
  # all normative references generated automatically

informative:
  oas3.1:
    title: OpenAPI Specification v3.1.0
    date: 2021-02-15
    target: "https://spec.openapis.org/oas/v3.0.1.html"
    author:
    - ins: Darrel Miller
    - ins: Jeremy Whitlock
    - ins: Marsh Gardiner
    - ins: Mike Ralphson
    - ins: Ron Ratovsky
    - ins: Uri Sarid
  # AsyncAPI does not date their specs or list authors
  # Dates are from GitHub release commits
  async2.0:
    title: AsyncAPI Specification v2.0.0
    date: 2019-09-11
    target: "https://www.asyncapi.com/docs/reference/specification/v2.0.0"

--- abstract

JSON Reference and Identification (JRI) provides a way for media types and
other data formats that lack native identification and referencing mechanisms
to implement them in a familiar and interoperable way.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

This specification is a response to the usage of these keywords both inside and outside of JSON Schema during the decade since `id` (which was later split into `"$id"` and `"$anchor"`) and `"$ref"` were first introduced in JSON Schema draft-03 {{?I-D.zyp-json-schema-03}}.  The `definitions` keyword (which later became `"$defs"`) was introduced in JSON Schema Validation draft-04 {{?I-D.fge-json-schema-validation-00}}, at which point `"$ref"` had been split into its own short-lived but influential JSON Reference {{?I-D.pbryan-zyp-json-ref-03}} proposal.

The full and rather complex history of these keywords, including their usage in OpenAPI and AsyncAPI, as well as other proposals to split some or all of them back into a separate specification, is detailed in the [BACKGROUND.md](https://github.com/json-schema-org/referencing/tree/main/BACKGROUND.md) file in the repository containing this document.

Use cases have been compiled from popular tools that support JSON Reference (and sometimes other keywords in this specification) without being full JSON Schema implementations, and from specification requirements regarding non-JSON Schema use.  Notably, some of the tools support additional JRI keywords that were not included in JSON Reference, motivating a larger specification than simply a revival of JSON Reference.  These requirements and use cases are also available in the [BACKGROUND.md](https://github.com/json-schema-org/referencing/tree/main/BACKGROUND.md) file.

Discussion of this draft takes place in the [GitHub repository](https://github.com/json-schema-org/referencing) and on the `"#referencing"` channel of the [JSON Schema Slack server](https://json-schema.org/slack).

--- middle

# Introduction

JSON Reference and Identification (JRI) offers a modular set of features to enable interoperable support of identification and referencing across a wide range of formats.  These features are necessary to create data formats across a set of linked documents, but are often incidental to the primary functionality of a data format specification.  Offloading these features to common libraries and tools based on a standardized approach allows data format implementations to focus on the format's purpose with minimal need to understand complex and potentially multi-document structures.

Standalone JRI use cases include a variety of document transformations, transparent in-memory representations of linked documents, and locating, caching, and serving resources identified within or referenced from a set of documents.

While {{?RFC8288}} web linking solves this problem in a more general way, a simplified, concise, and self-contained linking and identification system is better-suited to many specifications.  This allows those specifications to avoid complexity, and to avoid constraining their syntax to match any one of the many competing web linking-enabled JSON formats.

To support a variety of use cases, JRI supports trade-offs between generic interoperability and tight integration with the context in which it is used.  JRI defines an interoperable subset of its features for standalone use while encouraging specifications that need reference and/or identification features to incorporate as much or as little of JRI as suits their needs, as long as they do not redefine the parts not incorporated.  JRI also defines mechanisms for resources to indicate their JRI usage, allowing generic or standalone implementations to understand how to safely process a document without knowledge of its underlying data format.

## Notational Conventions

{::boilerplate bcp14+}

The terms "primary resource" and "secondary resource" in this specification are to be interpreted as in {{!RFC3986, Section 3.5}}.

Due to the distinction that this specification makes between documents and resources, the term "same-resource reference" is to be interpreted in the same way as "same-document reference" as defined in {{!RFC3986, Section 4.4}}.  The term "same-document reference" is not used in this specification.

The terms "IRI", "IRI-reference", "relative reference", "absolute-IRI", and "base IRI" in this specification are to be interpreted as in {{!RFC3987}}.

## Definitions

In addition to the terms from other specifications listed in the previous section, this document uses the following terminology:

* _data format:_ any specification for structuring data within a document, including but not limited to formal media types
* _JSON-based format:_ any data format using {{?RFC8259}} JSON as its syntax, including but not limited to formats defined with an `application/json` or `+json` structured suffix media type
* _JSON Pointer-compatible document:_ any document with a structure that can be unambiguously addressed by JSON Pointer as described in {{jsonpointer}}
* _root object:_ the object, if any, containing the entirety of a JSON-compatible document[^2]
* _keyword:_ an object property name with specification-defined behavior, as opposed to object properties which are simply data
* _processing a data format:_ performing any actions required by the format, typically based on the format's structure and keywords, beyond simply parsing the format into an in-memory representation
* _evaluation path:_ the path, including reference keywords traversed, taken to reach a particular point of processing from the document root at which processing started; the exact nature of this path depends on the reference semantics chosen as defined in {{ref-semantics}}

For formats that incorporate JRI, "processing" includes resolving relative IRI-references and either associating the resulting IRI with the appropriate resource, or resolving the IRI to the resource with which it is already associated.

[^2]: How should formats without a root object be handled?  Some formats might have a root array.  For interoperability, being able to define how processing starts in terms of a root object is unambiguous.  It is also valid to reference a document that is neither an object or array (early JSON specifications restricted documents to objects or arrays, but that restriction was lifted at least as early as RFC 4627).

### JRI Context

* _context specification:_ a data format specification that normatively references this specification, making use of some or all of its keywords in a complaint manner, and optionally defining context-specific behavior for them where this specification allows or requires such definition
* _context-independent format:_ a data format that only allows the use of JRI in an interoperable manner as defined in {{interop}}
* _context-independent document:_ a document, which may or may not be written in a context-independent format, that only uses JRI in an interoperable manner as defined in {{interop}}
* _standalone JRI implementation:_ an implementation that in its default configuration only understands how to process context-independent documents

### Simple and Compound Documents

* _simple document:_ a document that is also a single primary resource
* _compound document:_ a document consisting of multiple primary resources
* _root resource:_ the first resource encountered while parsing a compound document, corresponding to the root object if one is present, but excluding any embedded resources
* _embedded resource:_ a primary resource within a compound document that is not the root resource
* _encapsulating resource:_ the immediate primary resource in which an embedded resource is contained; a resource can be both embedded and encapsulating
* _uniform compound document:_ a compound document in which all primary resources are of the same data format
* _mixed compound document:_ a compound document in which the primary resources are of different data formats

# JRI Fundamentals

## IRI Behavior in JRI {#iri-behavior}

All IRI behavior within JRI is governed by {{!RFC3987}}, {{!RFC3986}}, and any relevant standards specifying IRI (or URI) scheme-specific syntax and semantics or media type-specific IRI fragment syntax and semantics.

In particular, JRI identifier keywords indicate how they impact base IRI determination, as allowed by those two RFCs.  Relative IRI-reference resolution in each JRI keyword therefore does not have any direct dependence on any other JRI keyword.

### Base IRI

To support the full base IRI determination process defined in {{!RFC3987, Section 6.5}} and {{!RFC3986, Section 5.1}}, a JRI implementation SHOULD be able to accept a non-relative base IRI prior to processing a document, unless it is part of the implementation of a context specification for which one of the following is true:

* the context specification requires an absolute base IRI defined within each primary resource
* the context specification requires all IRI-references to be non-relative or fragment-only

Such a base IRI is necessary if the implementation encounters a relative IRI-reference prior to determining a non-relative base IRI defined within the content.  It is assumed that any provided base IRI has been determined in accordance with the relevant specifications.

An implementation that does not meet either of the above criteria yet still disregards this recommendation MUST document the limitation and treat unresolvable relative references as an error.

Defining a default base IRI as allowed by {{!RFC3986, Section 5.1.4}} is deferred to context specifications.

### Identifiers vs Locators {#id-vs-loc}

IRIs used in JRI keywords are identifiers (IRIs/URIs) and not necessarily locators (IRLs/URLs), even if they specify a scheme indicating a protocol suitable for resource retrieval.  Context specifications SHOULD indicate under what circumstances a reference can be treated as a locator and retrieved on demand, and address the security concerns related to automatic retrieval.

Standalone implementations of context-independent JRI MUST NOT attempt to automatically retrieve references by default.  They MAY offer a configuration option to do so, and MAY offer a mechanism to register handlers based on the IRI scheme or other IRI components.

### Duplicate IRIs {#duplicate-iris}

A resource MAY (and likely will) have multiple IRIs, but there is no way for an IRI to identify more than one resource.  When multiple primary or secondary resources attempt to identify as the same IRI through any combination of JRI keywords and context specification features, implementations SHOULD raise an error condition.  Otherwise the result is undefined, and even if documented will not be interoperable.

## JRI Keywords

JRI defines keywords in three behavior categories:

* Identifiers, which assign IRIs to primary or secondary resources and (for primary resources) set the resource's base IRI
* Locations, which indicate which locations are referenceable and can contain identifiers
* References, which link one part of a document to another part of the same document or to a different document

Context specifications MAY define their own keywords or other mechanisms within these three categories, as discussed in {{context}}.  They also MAY restrict reference targets to those identified by JRI and/or context specification identifier or location keywords.

### General syntax

JRI keyword names and string values are defined to be representable as {{?RFC3629}} UTF-8 strings, with keyword names representable in {{?RFC20}} ASCII.  As such, JRI keywords can be used as object properties in interoperable JSON documents as prescribed by {{?RFC8259, Sections 4, 7, and 8.1}}, as well as in any other JSON Pointer-compatible data formats.

JRI keywords MAY be used in data formats that are only capable of representing a subset of UTF-8 string values, with the obvious limitation that only the representable subset of JRI keyword values will be usable.

As {{!RFC3987, Section 3}} defines mappings between IRI and URI syntax, JRI MAY be used in data formats that can only directly represent URIs.

#### The "$" prefix

JRI keywords MUST start with a "$" character.  Context specifications MAY define their own "$"-prefixed keywords, however this is NOT RECOMMENDED as future specifications that extend JRI as discussed in {{extending}} will use that prefix.[^8]

[^8]: The usage of "$" as a prefix in the JSON Schema Core Vocabulary pre-dates JRI, and is expected to continue.  Some older JSON Schema proposals from immediately post-draft-04 also used a "$" prefix, but none were adopted and JSON Schema now discourages the use of that prefix.

#### Exclusion of "$comment"

For compatibility with JSON Schema {{?I-D.bhutton-json-schema-01, Section 8.3}}, JRI requires that a `"$comment"` keyword present in the same object as any JRI keywords MUST NOT impact the semantics of those JRI keywords.  In particular, `"$comment"` MUST NOT be used as a semantic disambiguator as described in {{disambiguator}}.

However, `"$comment"` is not itself considered to be a JRI keyword.  JRI does not place any requirements on the usage, data type, syntax, or other semantics of `"$comment"` in context specifications.  JRI implementations MUST NOT require that a `"$comment"` adjacent to JRI keywords conform to JSON Schema's `"$comment"` keyword, unless explicitly required to do so by a context specification.

### Evaluation order

JRI behaviors, whether implemented by JRI keywords or by context specification features, MUST be evaluated in the following order when present:

1. Primary resource identifiers (`"$id"`)
1. Secondary resource identifiers (`"$anchor"`)
1. Locations (`"$defs"`)
1. References (`"$ref"`, `"$extRef"`)

The logic of this ordering is that primary resources must be identified first as all other keywords depend having the correct base IRI.  Next, secondary resources can be identified once the primary resource is known.  Finally, nested locations which can be reference targets or have additional identifier keywords can be discovered within the primary resource.

### Identification

JRI offers two identification keywords:  one for primary resources, and one for secondary resources.

#### `"$id"`

The value of the `"$id"` property MUST be a string, and MUST be a valid IRI-reference as defined by {{!RFC3987, Section 2.2}}, and MUST NOT contain a fragment.

The object containing the `"$id"` property MUST be considered to be a primary resource and to be identified by the IRI produced by resolving the IRI-reference against the current base IRI.  This IRI MUST be considered the base IRI for the newly identified primary resource, in accordance with {{!RFC3986, Section 5.1.1}}.

If the object containing the `"$id"` property is not the root object of the document, the encapsulating resource MUST be considered to be an "encapsulating entity" per {{!RFC3986, Section 5.1.2}}.

#### `"$anchor"`

The value of the `"$anchor"` property MUST be a string, and MUST be a valid IRI fragment according to the `ifragment` ABNF production in {{!RFC3987, Section 2.2}}.

### Location

Location behavior is necessary when not all locations within a data format are valid reference targets, or when object properties that appear to be JRI keywords are only actually JRI keywords in certain locations.  In formats where most locations cause automatic actions (such as applying a schema to an instance), location behavior can also create areas where the automatic actions do not apply.  These reserved locations can safely hold re-usable objects separate from any single use.

The passive nature of location behavior makes it particularly suitable to be defined directly by context specifications, as noted in {{context-loc}}.  However, not all uses of JRI involve a context specification.

JRI reserves the `"$defs"` keyword in order to make no-automatic-action location behavior available within the `"$"`-prefixed namespace.  This keyword also enables safe interoperable bundling by standalone tools as described in {{bundling-interop}}.[^70]

[^70]: It's also possible to bundle documents that do not use `"$defs"` into a document that does, and can therefore be un-bundled by a generic bundling tool.  I'm not sure of the best way to talk about that, as I did not want to get into defining a bundling media type.

#### `"$defs"`

The value of the `"$defs"` property MUST be an object, which MUST have objects as the values of all of its properties.  JRI keywords MUST be allowed in these objects.  Aside from their use in JSON Pointers or similar structural identifiers, the property names within the `"$defs"` object MUST NOT be considered to impose specific semantics to the property values.

### Referencing

JRI reference usage has two components: resolving the reference target and interpreting its semantics.  JRI offers several keywords for determining a reference target.  Once determined, regardless of which keywords are used, the possible semantics are as described in {{ref-semantics}}.

#### `"$ref"`

The value of the `"$ref"` property MUST be a string, and MUST be a valid IRI-reference as defined by {{!RFC3987, Section 2.2}}.  The IRI produced by resolving this IRI-reference against the current base IRI identifies the reference target.

By default, the reference target MAY be assumed to be of whatever media type would otherwise be present inline, and fragments MAY be evaluated accordingly.  Context specifications MAY set other requirements regarding the nature of reference targets but MUST NOT expect these requirements to be interoperable with standalone JRI implementations.

#### `"$extRef"`

To avoid overloading the behavior of `"$ref"` or relying on non-interoperable context-specific behavior, `"$extRef"` (for "extensible reference") allows specifying additional metadata as well as alternative mechanisms for secondary resource identification.[^90]

[^90]: It is not yet clear how this should work, or how many meta-data sub-keywords should be defined in this specification.  I have asked the AsyncAPI team some clarifying questions.  An object value in which an IRI (without fragment) is provided in one member, and a (non-fragment) JSON Pointer or other fragment-substitute is provided in another would seem to solve some problems.  However, there is also a need to set a per-reference media type, and such a media type might have a fragment syntax.  We also don't want it to be easy to define both a fragment and a fragment alternative in the same reference, as the result of that would be unintuitive at best.

#### Reference semantics {#ref-semantics}

Reference semantics come in two varieties, object-level and keyword-level.  Object-level semantics are, under certain circumstances, both safe and interoperable in a context-independent manner.  Keyword-level semantics allow for more flexible semantic integration of referencing with a context-specification through allowing adjacent keywords.  However, this flexibility comes at the cost of interoperability, at least when adjacent keywords are actually present.

##### Object-level semantics {#object-level}

With object-level semantics, an object containing a JRI reference keyword is effectively replaced with its target.  This results in an evaluation path in which the reference keyword does not appear.

Object-level semantics are generally safe to assume when the object only contains JRI reference keywords.  Context specifications SHOULD ensure this safety even if their intended reference semantics are keyword-level.

##### Keyword-level semantics {#keyword-level}

With keyword-level semantics, a JRI reference keyword remains part of the evaluation path, and has the effect of evaluating its target in the current context, as defined by the context specification.  See {{context-ref}} for further guidance.

##### Falling back to object-level semantics

Context specifications that use keyword-level semantics SHOULD ensure that, in the absence of keywords adjacent to JRI reference keywords, object-level JRI reference semantics can be assumed without changing the semantics of the document according to the context specification.  This requires that the difference in evaluation paths not impact the context semantics, as is further discussed in {{context-fallback}}.

## Extending JRI {#extending}

[^40]

[^40]: This section is something of a placeholder.  I'm not quite sure how much to say, although it is important to specify that adjacent keywords can disambiguate semantics _within the context usage_ but not change them such that the semantics no longer match this specification.  Otherwise that is a gray area with respect to the requirement to not impact JRI semantics.

Rather than being directly extensible, JRI is intended to work alongside other specifications that might provide similar functionality.  An example would be JSON Schema's concept of dynamic references and anchors, which could be a companion specification to JRI.  In order for any combination to be interoperable, it MUST define its own set of interoperability constraints spanning the constituent functionalities.

# Standalone JRI implementations

By definition, a standalone JRI implementation is an implementation that, in its default configuration, can only correctly process JRI in context-independent documents.

Such implementations MAY offer non-default configurations that incorporate context-aware behavior from any known context specification(s).  Implementations SHOULD document the conditions under which such non-default configurations are safe to use, and any assumptions involved that could produce unexpected behavior if used with a document that does not conform to the relevant context specification.

## The interoperable JRI Subset {#interop-subset}

Context-independent interoperability places several additional requirements on any document that needs to be processed by a context-independent JRI implementation.  Most of these requirements are not enforceable by a context-independent implementation.  Users of context-independent implementations MUST NOT expect documents that violate these requirements to be detected by the implementation, and MUST NOT expect predictable, interoperable behavior
from processing such documents.

A document that can be interoperably processed by a context-independent JRI implementation will be referred to in this section as a _context-independent document_.  A data format for which all valid documents are context-independent documents will be referred to in this section as a _context-independent format._

The requirements below are stated for context-independent formats.  A document in a non-context-independent format can be context-independent if it avoids using any features forbidden by the context-independent format requirements.

### Restricting base IRI changes and IRI assignment {#interop-overlap}

A context-independent format MUST NOT offer features for assigning IRIs to primary or secondary resources, or changing the base IRI from within a document.

### Recognizing JRI keywords

The property names in the value of `"$defs"` are known to be non-keyword properties as this object syntax is defined by JRI.  These property names therefore MUST be considered exempt from the other requirements in this section regarding property names.

A context-independent format MUST NOT allow object properties with names matching JRI keywords and values that appear valid for that keyword that are not intended to function as JRI keywords anywhere within the format.

Note that as JRI implementations are not required to validate keyword values, simply having the correct value type (e.g. string) is enough to make such a keyword appear to be a valid JRI keyword.  Context-independent JRI implementations MAY offer a non-default configuration option to validate potential JRI keyword values and ignore (rather than treat as an error) those that do not have valid values.

### Ensuring consistent reference semantics

A context-independent format MUST NOT allow any non-JRI-reference keywords in the same object as any JRI reference keyword.[^11]

[^11]: Should we allow a context-independent format to allow non-JRI keywords in reference objects as long as it mandates that they are, in all circumstances, ignored?  Aside from `"$comment"`, this seems like asking for trouble, and OpenAPI and AsyncAPI notably forbid any properties other than `"$ref"` in their Reference Objects.  But it would be closer to JSON Reference behavior.

### Finding JRI identifiers

A context-independent format MUST NOT allow JRI identifiers anywhere other than its root object or under a `"$defs"` keyword appearing (recursively) in the root object.[^10]

[^10]:Alternatively, we could treat them like the reference keywords and require that they be allowed anywhere.  Neither approach works with JSON Schema, but the JSON Schema vocabulary for JRI proposed in a later section would provide a way to do so.

### Interoperable bundling and un-bundling {#bundling-interop}

A context-independent bundling tool can un-bundle a document meeting the following requirements:

* The root object MUST contain `"$defs"`, and each bundled resource MUST be embedded in the `"$defs"` object; the names of the `"$defs"` properties are irrelevant
* If the embedded resources' `"$id"` values are relative IRI-reference, the root object MAY contain an absolute-IRI `"$id"` so that the resources can be bundled and un-bundled without changing their `"$id"`s; when un-bundled, such resources are expected to be in a directory structure appropriate to their `"$id"`s relative to the shared base

## Implementing a subset of interoperable JRI

The popularity of tools devoted only to processing `"$ref"` demonstrates a substantial market for simple standalone implementations of a JRI subset.  Standalone implementations that only support a subset of JRI MUST NOT claim to be full implementations of JRI, and MUST document what subset is supported.

## JRI Applications

JRI exists to facilitated interoperable tooling.  Therefore, several common applications of JRI here are described to encourage common functionality.

### Locating, caching, and serving resources

A primary use case for JRI involves removing the need for downstream tools to track base IRIs and retrieve identified resources.  We will refer to a tool that fulfills this use case as a _JRI cache_.  In this use case, downstream tooling still encounters JRI references, but they have already been resolved to full IRIs (with a scheme), and the implementation resolves all IRIs by requesting them from the JRI cache.

Depending on the exact functionality offered, the "cache" could be as simple as a look-up table.  It could also perform actual caching tasks such as managing a working set in limited memory, or integrating with a caching system such as one offered by HTTP clients in accordance with {{?RFC9111}}.  JRI does not impose any requirements in this regard.

A JRI cache implementation MUST:

* Be able to associate a document, including non-JRI documents that could be JRI reference targets, with an IRI
* Locate all JRI identifiers (primary and secondary resources) within any document and automatically include them in the cache
* Locate all JRI references and resolve any relative IRI-references to full IRIs in the cached representation
* In its default configuration, treat cache misses as errors, since JRI reference IRIs are be assumed to be locators
* Resolve IRIs that use JSON Pointer fragments as long as the primary resource is in the cache (when such fragments are appropriate for the resource.

JSON Pointer fragment resolution can either be done by indexing valid JSON Pointers, which typically involves understanding JRI location keywords and any similar context-specific locations, or by matching the primary resource and evaluating the JSON Pointer on that resource on demand.  However, locating JRI identifiers generally needs to be done in advance, as compound documents mean that the location of a primary resource might only be detectable by scanning a document that appears to be a different resource.

A JRI cache implementation SHOULD:

* Keep track of each resource's media type and handle fragments accordingly, unless the cache is implementing a context specification that guarantees consistent media types
* Respect any cache controls on retrieved resources to avoid burdening servers with superfluous requests; this can often be deferred to a caching network protocol client

A JRI cache implementation MAY:

* Offer a plugin interface for resolving cache misses, keyed off of the IRI scheme or other IRI components
    * Such a system SHOULD allow plugins that locate resources other than by retrieving the IRI; for example in a development environment it might be preferable to resolve `https:` resources from the local file system
    * Registering a plugin is sufficient to consider the JRI cache implementation "non-default" with respect to the requirement to treat IRIs as non-locators by default

### Document set transformations

A common family of use cases involves reading one or more JRI-using documents and transforming them in a way that makes them usable by a wider range of tooling.  Note that circular references can cause problems for these use cases, as discussed in {{infinite}}.

#### Reference removal

This use case attempts to remove all references with object-level semantics by replacing the reference objects with their targets, resulting in a plain JSON (or other underlying format) document that requires no knowledge of JRI.

Object-level replacement MAY be implemented by producing a copy of the source document with the reference object replaced by the contents of its target.

Removing references from a set of documents with differing base IRIs, or involving fragments that are to be resolved within a specific primary resource carries additional restrictions.  References MUST be traversed in a depth-first fashion and removed from the leaf to the root, so that each removal takes place in the proper primary resource context and with the proper base IRI.

#### Bundling to JSON Pointer fragment references only

Despite implementing specifications that allow multi-document sets, in practice a significant number of tools only support same-resource references using JSON Pointer fragments (the only fragment syntax listed by name in older JSON Reference specifications).

This form of bundling creates a single document and adjusts all references to only point to the newly bundled locations using JSON Pointers.

#### Bundling with stable references

A set of documents that each define `"$id"` in their root objects, and that only refer to each other using the primary resource identifiers set that way (plus any appropriate fragment syntax) can be bundled into a single compound document that satisfies all references internally without the need to edit them.

Unlike the previous two use cases, this type of bundling can be un-bundled.  An interoperable bundling format that can be safely un-bundled regardless of context is defined in {{bundling-interop}}.

### Transparent in-memory representation of document sets

This use case aims to present a set of linked documents as if no references were present at all (if object-level semantics are used), or as if the reference values are their targets rather than IRIs (if keyword-level semantics are used).  Typically, this involves some sort of lazy proxy object to ensure cyclic references do not automatically cause infinite recursion.

Depending on the intended scope of support (e.g. a single self-referential document vs document sets that link to each other and possibly external resources), this use case can benefit from being implemented on top of a JRI cache.

# Incorporating JRI into a context specification {#context}

A context specification incorporates JRI into a data format that describes JSON Pointer-compatible documents.  Such a specification MUST normatively reference this specification, and MUST specify any relevant context-specific requirements that this specification defers to context specifications.[^3]

[^3]: Should a root object be mandated?  If not, how much variation to accommodate.  Should a root object have to allow JRI keywords?  **No, because OAS does not (and probably AsyncAPI does not either).**

## Fragments and secondary resources

Context specifications that do not define media types, or that define media types without a defined fragment syntax, SHOULD NOT incorporate `"$anchor"` into the specification.

Context media types that define a fragment syntax SHOULD further constrain the syntax of `"$anchor"` to the set of fragments valid for that media type.  Any fragment syntax that correlates with the inherent structure of the document SHOULD be forbidden to avoid defining a fragment that conflicts with the document structure.

## Locations {#context-loc}

Context specifications MAY define location keywords that impose specific semantics within their values.  This is demonstrated by the `components` keyword used in both OpenAPI {{oas3.1}} and AsyncAPI {{async2.0}}, which has subsections for different component types.

Context specifications MAY assign location behavior to keywords with other behaviors.  JSON Schema's inline applicator keywords {{?I-D.bhutton-json-schema-01, Section 7.5}} demonstrate this approach.

If the data format described by the context specification has a root object that allows JRI keywords, the structure of the objects under under location keywords SHOULD have the same structure as the root object, and MUST allow all JRI keywords that are allowed in the root object.

## References and adjacent keywords {#context-ref}

Context specifications MAY define how such reference effects are combined with the effects of non-JRI keywords in the same object as the JRI reference keywords.  Such combined effects MUST NOT involve changing the behavior of JRI keywords to conflict with this specification in any way.

There is no universally safe way to edit a document containing a reference to contain the reference target instead, even without circular references, although context specifications MAY define such edits.[^30]

[^30]: At one point in JSON Schema spec development, we discussed allowing reference "removal" by replacing `"$ref"` and its IRI value with `"$inline"` and the reference target value.  This allows inlining at the keyword level without needing to understand a context specification.  `"$inline"` was essentially a one-element `allOf` that conveyed that a reference had been inlined.  Is this worth reviving in JRI?  Doing so would not force JSON Schema to adopt it.  One complexity would be that if there are multiple JRI reference keywords, we would either need one inlining keyword per reference if we want it to be reversible, or `"$inline"` would have to support meta-data along with the target.

### Disambiguating reference semantics {#disambiguator}

Context specifications MAY define keywords that, when appearing adjacent to JRI referencing keywords, clarify the semantics of that reference within the semantics of that context specification.  For example, a specification for code generation might want to indicate whether a reference indicates linking two distinct pieces of generated code in a particular way rather than simply being an artifact of document organization that should be ignored.

### Context-specific fallback to object-level semantics {#context-fallback}

Context specifications that use keyword-level semantics SHOULD define whether and under what circumstances it is safe for tooling to fall back to object-level semantics.  Whether or not this is feasible depends in part over whether an evaluation path that does not include the reference keyword (e.g. `"$ref"`) changes the context semantics.  This might be safe if there are no adjacent keywords to the reference keyword, and the presence of the reference is not considered inherently semantically meaningful.

To a significant degree, this is a less a question of JRI behavior, and more a question of what documents are considered equivalent according to the context specification.

## Incorporating a subset of JRI

Since, as noted in {{iri-behavior}}, JRI keywords do not directly interact with each other, context specifications MAY restrict their usage of JRI in any of the following ways:

* Incorporating only a subset of the JRI keywords
* Restricting the locations within a document in which each JRI keyword can appear
* Further restricting the syntax of JRI keywords

Context specifications MUST NOT change the behavior of JRI keywords in any way, including by making their behavior dependent on non-JRI keywords.  Context specifications MAY indirectly impact JRI keyword behavior as dictated by {{!RFC3986}} and {{!RFC3987}} in accordance with those specifications, such as by setting a base IRI.

Additionally, context specifications MUST NOT define keyword behavior for any JRI keyword that they do not incorporate.  This is to ensure that context-independent implementations of JRI can reliably process any keyword that appears to be a JRI keyword.

Extensible context specifications SHOULD NOT syntactically forbid the use of JRI keywords that they do not incorporate, as extensions might wish to incorporate additional JRI functionality.

## Avoiding behavioral overlap

If a context specification defines or inherits (e.g. as a structured-suffix media type) functionality that overlaps with JRI care must be taken to avoid unintuitive or even undefined behavior.

It is RECOMMENDED that context formats with functionality that overlaps with JRI not use any keywords that duplicate native functionality, and restrict the syntax of any keywords that partially overlap in order to minimize if not eliminate the overlap.

For further interoperability concerns see {{interop-overlap}}.

## Processing JRI keywords alongside of context specification keywords

Context specifications that define keywords with analogous functionality to JRI keywords SHOULD process each of them at the same point in the processing order as their analogous JRI keyword.  Changing the ordering of identifiers and references in particular is likely to produce counter-intuitive behavior, and reduces the interoperability of the JRI keywords with tools that are not context-aware.

Context specifications that define keywords with other behaviors MAY define any processing order for them.  However, it is RECOMMENDED that any keywords that might be impacted by the behavior of JRI identifier and location keywords be processed after those keywords.

JRI referencing is only interoperable if all non-JRI keywords (other than those overlapping in functionality with JRI identifiers and locations) are processed after JRI referencing keywords.  However, the semantics of keywords appearing alongside of JRI references is determined by context specifications, which therefore MAY define other ordering requirements.

# Relationship to Web Linking

The functionality of JRI could mostly be implemented using {{?RFC8288}} web linking.  However, there are a variety of competing JSON-based formats for linking, many of which impose structural constraints likely to conflict with the needs of context specifications.  JRI is a simpler and more focused specification, intended to be easily incorporated into a variety of possible formats.

The following keywords are roughly analogous to web links:

* The `"$id"` keyword effectively defines a link with relation type "self".
* Reference keywords with object semantics effectively defines a link with relation type "full".
* Reference keywords with keyword semantics effectively defines a link with the generic relation type "related".

In the absence of other link metadata or context specification guidance, the target of a reference keyword MAY be treated as carrying a target media type hint (as in {{?RFC8288, Section 3.4.1}}) suggesting that the target media type is identical to the media type of the document containing the reference.

# Interoperability Considerations {#interop}

See also {{interop-subset}}.

## JRI behavior negotiation

To maximize the usefulness of standalone tooling, such tools need to be able to determine the degree to which JRI is used and the interoperability assurances on which it can rely.[^41]

[^41]: This section is more-or-less brainstorming.  The problem it is solving is real, but whether these solutions belong in this specification or not is open to question.

### Media type parameters for safe processing

Context specifications defining media types SHOULD define the `jri-safety` and `jri-keywords` media type parameters to enable standalone implementations, including standalone subset implementations, to determine whether they can safely process the document.

These parameters are intended for use in environments where a standalone implementation is likely to encounter documents with unexpected media types involving unpredictable JRI usage.  Standalone implementations MAY use other heuristics and information sources to determine whether to process a document.

Non-media type context data formats MAY define a mechanism analogous to these media type parameters, but such mechanisms will not be interoperable.

#### The "jri-safety" media type parameter

The value of the `jri-safety` parameter MUST be case-insensitive, and MUST be either `interoperable` or `contextual`.  The default value is `contextual`, indicating that an implementation MUST be aware of and support the relevant context specification in order to safely process JRI keywords in the document.  A value of `interoperable` indicates that the document is context-independent, and safe to process by a standalone implementation.

### The "jri-keywords" media type parameter

The value of the `jri-keywords` parameter MUST be a case-sensitive comma-separated list of JRI keyword names, which MUST NOT contain whitespace.  These keywords MAY be in any order.  This indicates that only the listed keywords are used in the document. In the absence of this parameter, an implementation MUST assume that any JRI keyword can be used.

### A JSON Schema vocabulary for safe processing

[^42]

[^42]: A simple annotation vocabulary could indicate where exactly in a document JRI keywords can appear, and what behavior they might have.  Unlike the media type parameters, this approach could distinguish between `"$ref"`/`"$id"`/`"$anchor"` within a schema vs those property names with JRI-correct values within `enum`, `const`, or `examples`.  This would make it possible to use a generic JRI cache as the base for a JSON Schema implementation.

# Security Considerations

On-demand retrieval and processing of referenced resources brings the security risks inherent in handling any data from an untrusted source.  It is RECOMMENDED that implementations supporting this behavior support defining allow/deny lists for limiting retrieval to trusted sources.

Implementations of a JRI cache that implement a functional caching system (rather than a simple lookup table) need to address the security considerations of the caching process(es) that they support.

## Guarding Against Infinite Recursion {#infinite}

An implementation MUST guard against infinite reference loops.

Processing rules for context specifications MAY make it safe to have cyclic references by creating conditions under which a reference will or will not be followed.

Cyclic references cannot safely be processed in a way that is both interoperable and context-independent.  Seeing a specific reference while processing the target of that same reference MUST be considered an error by context-unaware implementations.

# IANA Considerations

--- back

# Media types, IRI fragments, and non-fragment JSON Pointers

As stated by {{!RFC3986, Section 3.5}}, fragment syntax and semantics are defined by media types.  Attempting to use fragments other than as defined by a media type is behavior that is not in compliance with internet standards.

In particular, {{?RFC8259}} does not define a fragment syntax for `application/json`, and {{!RFC6901, Section 6}} explicitly notes that JSON Pointer is not the fragment identifier syntax for `application/json`.

JRI is also intended to be usable with resources that do not define a media type, and therefore do not have a defined fragment syntax.[^20]

[^20]: It's unclear what the best approach to this is right now, but I have come up with several possible ways to specify a primary resource IRI (no-fragment) and a piece of data (JSON Pointer or otherwise) that performs the secondary resouce identification.

# JSON Pointer compatibility {#jsonpointer}

This section defines how to determine if a format is compatible with JSON Pointer by specifying what aspects of a format do and do not need to be mapped to JSON concepts.  It is up to individual implementations and context specifications to determine if any particular format is JSON Pointer-compatible, and how to support evaluating pointers that use JSON Pointer syntax for documents in that format.  An example of how to do this is the YAML media type's correlation of YAML and JSON in {{?I-D.ietf-httpapi-yaml-mediatypes, Section 3.3}}

JSON Pointer is only defined for JSON Documents.  However, the evaluation algorithm defined in {{!RFC6901, Section 4}} is written in terms of JSON Arrays and JSON Objects with Unicode member names.  Notably, non-object/array JSON data is not involved at all, except as the result of the evaluation which does not depend on the type of the result value.

{{!RFC8259}} defines JSON Objects and Arrays sufficiently to determine whether an in-memory data structure can be serialized into JSON.

If a data format's parsed in-memory representation can be serialized according to JSON's requirements, using unique placeholder values for scalar values that are not serializable in JSON, then JSON Pointer can be evaluated on that serialization to determine the location of the result.  If necessary, the unique placeholder value(s) could then be used to recreate the corresponding value from the original (non-JSON) document.

Any document that can be converted as described in the previous paragraph could equivalently evaluate syntactically valid JSON Pointers by substituting its own object and array definitions for JSON Objects and Arrays, and adjusting the string comparison rules as needed if it does not use Unicode.

Note even in a non-JSON Pointer-compatible format, many individual documents can still be JSON Pointer-compatible.  For example, YAML is not compatible due to allowing non-string property values, but the very commonly used JSON-compatible subset of YAML is, of course, JSON Pointer-compatible.  The proposed YAML media type registration {{?I-D.ietf-httpapi-yaml-mediatypes-03, Section 3.3}} addresses this, including the evaluation of JSON Pointers over YAML documents.

On the other hand, the mixture of elements and attributes in XML means that XML is never JSON Pointer-compatible.  There is no obvious single way to map XML to JSON-like objects and arrays, as demonstrated by the need for the `xml` keyword in {{oas3.1}}.

# Acknowledgements

# FAQ
{: numbered="false"}

Q: Why this document?
:

# Change Log {#changelog}
{: numbered="false"}

RFC EDITOR PLEASE DELETE THIS SECTION.
