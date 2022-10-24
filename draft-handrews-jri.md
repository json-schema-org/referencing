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
  # For some reason, I-D.pbryan-zyp-json-ref-00 won't resolve automatically
  #
  # This produces the following warning in the build which should be disregarded:
  #
  # *** warning: explicit settings completely override canned bibxml in reference I-D.pbryan-zyp-json-ref-00
  #
  # Without doing this, if you use s {{?...}} reference the following error appears instead:
  # /.../.cache/xml2rfc/reference.I-D.pbryan-zyp-json-ref-00.xml: fetching from https://datatracker.ietf.org/doc/bibxml3/draft-pbryan-zyp-json-ref-00.xml
  # *** Can't get with persistent HTTP: Status code 404 while fetching https://datatracker.ietf.org/doc/bibxml3/draft-pbryan-zyp-json-ref-00.xml
  # *** 404 Not Found while fetching https://datatracker.ietf.org/doc/bibxml3/draft-pbryan-zyp-json-ref-00.xml
  # *** No such file or directory @ rb_sysopen - /.../.cache/xml2rfc/reference.I-D.pbryan-zyp-json-ref-00.xml for /Users/handrews/.cache/xml2rfc/reference.I-D.pbryan-zyp-json-ref-00.xml
  # ** Can't manipulate reference XML: undefined method `attributes' for nil:NilClass
  #
  #              d.root.attributes["anchor"] = anchor
  #                    ^^^^^^^^^^^
  # *** KRAMDOWN_OFFLINE: Inserting broken reference for reference.I-D.pbryan-zyp-json-ref-00.xml
  #
  # This way, you need to use {{...}} instead of {{?...}} and you get a warning,
  # but it works and looks the same as the others in the rendered HTML.
  I-D.pbryan-zyp-json-ref-00:
    title: JSON Reference
    date: 2011-11-14
    target: "https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-00"
    author:
    - ins: P. C. Bryan
    - ins: K. Zyp

  # The rest of these have to be manual as they are not tracked by the IETF bibliography.
  json-ref-2019:
    title: JSON Reference (draft proposal)
    date: 2019-08-13
    target: "https://github.com/hyperjump-io/browser/blob/master/lib/json-reference/README.md"
    author:
    - ins: Jason Desrosiers
  swagger1.2:
    # Swagger 1.2 does not credit any authors
    title: Swagger RESTful API Documentation Specification v1.2
    date: 2014-03-14
    target: "https://github.com/OAI/OpenAPI-Specification/blob/main/versions/1.2.md"
  oas2.0:
    title: OpenAPI Specification v2.0 (fka Swagger RESTful API Documentation Specification)
    date: 2014-09-08
    target: "https://spec.openapis.org/oas/v2.0.html"
    author:
    - ins: Darrel Miller
    - ins: Jeremy Whitlock
    - ins: Marsh Gardiner
    - ins: Ron Ratovsky
  oas3.0:
    title: OpenAPI Specification v3.0.0
    date: 2017-07-26
    target: "https://spec.openapis.org/oas/v3.0.0.html"
    author:
    - ins: Darrel Miller
    - ins: Jeremy Whitlock
    - ins: Marsh Gardiner
    - ins: Mike Ralphson
    - ins: Ron Ratovsky
    - ins: Uri Sarid
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
  # Git blame on 1.0 shows moslty Fran Méndez plus contributions from Mike Ralphson,
  # but I am not sure they would want that author listing
  # I have not run Git blame or otherwise looked into 2.x authorship
  async1.0:
    title: AsyncAPI Specification v1.0.0
    date: 2017-09-20
    target: "https://github.com/asyncapi/spec/blob/1.0.0/README.md"
  async2.0:
    title: AsyncAPI Specification v2.0.0
    date: 2019-09-11
    target: "https://www.asyncapi.com/docs/reference/specification/v2.0.0"
  jref-nonj-linking:
    title: JSON Reference and non-JSON Linking (draft proposal)
    date: 2022-08-04
    target: "https://github.com/asyncapi/spec/pull/825"

--- abstract

JSON Reference and Identification (JRI) provides a way for media types and
other data formats that lack native identification and referencing mechanisms
to implement them in a familiar and interoperable way.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

This specification is a response to the usage of these keywords both inside and outside of JSON Schema during the decade since `id` (which was later split into `$id` and `$anchor`) and `$ref` were first introduced in [JSON Schema draft-03](#I-D.zyp-json-schema-03).  The `definitions` keyword (which later became `$defs`) was introduced in [JSON Schema Validation draft-04](#I-D.fge-json-schema-validation-00), at which point `$ref` had been split into its own short-lived but influential [JSON Reference](#I-D.pbryan-zyp-json-ref-03) proposal.

The full and rather complex history of these keywords, including their usage in OpenAPI and AsyncAPI, as well as other proposals to split some or all of them back into a separate specification, is detailed in {{changelog}}.

Use cases have been compiled from popular tools that support JSON Reference (and sometimes other keywords in this specification) without being full JSON Schema implementations, and from specification requirements regarding non-JSON Schema use.  Notably, some of the tools support additional JRI keywords that were not included in JSON Reference, motivating a larger specification than simply a revival of JSON Reference.  These requirements and use cases are detailed in {{reasons}}.

Discussion of this draft takes place on the [JSON Schema Slack server](https://json-schema.org/slack).

--- middle

# Introduction

JSON Reference and Identification offers a modular set of features to enable interoperable support of identification and referencig across a wide range of formats.  These features are necessary to create data formats across a set of linked documents, but are often incidental to the primary functionality of a data format specification.  Offloading these features to common libraries and tools based on a standardized approach allows data format implementations to focus on the format's purpose with minimal need to understand complex and potentially multi-document structures.

Standalone JRI use cases include a variety of document transformations, transparent in-memory representations of linked documents, and locating, caching, and serving resources identified within or reference from a set of documents.

While {{?RFC8288}} web linking solves this problem in a more general way, a simplified, concise, and self-contained linking and identification system is better-suited to many specifications.  This allows those specifications to avoid complexity, and to avoid constraining their syntax to match any one of the many competing web linking-enabled JSON formats.

To support a variety of use cases, JRI supports trade-offs between generic interoperability and tight integration with the context in which it is used.  JRI defines an interoperable subset of its features for standalone use, while encouraging specifications that need reference and/or identification features to incorporate as much or as little of JRI as suits their needs.  JRI also defines mechanisms for resources to indicate their JRI usage, allowing generic or standalone implementations to understand how to safely process a document without knowledge of its underlying data format.

## Notational Conventions

{::boilerplate bcp14+}

The terms "primary resource" and "secondary resource" in this specification are to be interpreted as in {{!RFC3986, Section 3.5}}.

Due to the distinction that this specification makes between documents and resources, the term "same-resource reference" is to be interpreted in the same way as "same-document reference" as defined in {{!RFC3986, Section 4.4}}.  The term "same-document reference" is not used in this specification.

The terms "IRI", "IRI-reference", "relative reference", "absolute-IRI", and "base IRI" in this specification are to be interpreted as in {{!RFC3987}}.

## Definitions

* _data format:_ any specification for structuring data within a document, including but not limited to formal media types
* _JSON-based format:_ any data format using {{?RFC8259}} JSON as its syntax, including but not limted to formats defined with an `application/json` or `+json` structured suffix media type
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

## JRI Keyword Syntax

JRI keywords are defined with names and values representable as {{?RFC3629}} UTF-8 strings, with keyword names representable in {{?RFC20}} ASCII.  As such, they can be used as object properties in interoperable JSON documents as precribed by {{?RFC8259, Sections 4, 7, and 8.1}}, as well as any other JSON Pointer-compatible documents.

JRI keywords MAY be used in data formats that are only capable of representing a subset of UTF-8 string values, with the obvious limitation that only the representable subset of JRI keyword values will be usable.

As {{!RFC3987, Section 3}} defines mappings between IRI and URI syntax, JRI MAY be used in data formats that can only directly represent URIs.

### The "$" prefix

JRI keywords MUST start with a "$" character.  Context specifications MAY define their own "$"-prefixed keywords, however this is NOT RECOMMENDED as future specifications that extend JRI as discussed in {{extending}} will use that prefix.[^8]

[^8]: The usage of "$" as a prefix in the JSON Schema Core Vocabulary pre-dates JRI, and is expected to continue.  Some older JSON Schema proposals from immediately post-draft-04 also used a "$" prefix, but none were adopted and JSON Schema now discourages the use of that prefix.

### Exclusion of "$comment"

For compatibility with JSON Schema {{?I-D.bhutton-json-schema-01, Section 8.3}}, JRI requires that a `$comment` keyword present in the same object as any JRI keywords MUST NOT impact the semantics of those JRI keywords.  In particular, `$comment` MUST NOT be used as a semantic disambiguator as described in {{disambiguator}}.

However, `$comment` is not itself considered to be a JRI keyword.  JRI does not place any requirements on the usage, data type, syntax, or other semantics of `$comment` in context specifications.  JRI implementations MUST NOT require that a `$comment` adjacent to JRI keywords conform to JSON Schema's `$comment` keyword, unless explicitly required to do so by a context specification.

## IRI Behavior in JRI {#iri-behavior}

All IRI behavior within JRI is governed by {{!RFC3987}}, {{!RFC3986}}, and any relevant standards specifying IRI (or URI) scheme-specific syntax and semantics or media type-specific IRI fragment syntax and semantics.

In particular, JRI identifier keywords indicate how they impact base IRI determination, as allowed by those two RFCs.  Relative IRI-reference resolution in each JRI keyword therefore does not have any direct dependence on any other JRI keyword.

### Base IRI

To support the full base IRI determination process defined in {{!RFC3987, Section 6.5}} and {{!RFC3986, Section 5.1}}, a JRI implementation SHOULD be able to accept a non-relative base IRI prior to processing a document, unless it is part of the implementation of a context specification for which one of the following is true:

* the context specification requires an absolute base IRI defined within each primary resource
* the context specification requires all IRI-references to be non-relative or fragment-only

Such a base IRI is necessary if the implementation encounters a relative IRI-reference prior to determining a non-relative a base IRI defined within the content.  It is assumed that any provided base IRI has been determined in accordance with the relevant specifications.

An implementation that does not meet either of the above critiria yet still disregards this recommendation MUST document the limitation and treat unresolvable relative references as an error.

Defining a default base IRI as allowed by {{!RFC3986, Section 5.1.4}} is deferred to context specifications.

### Identifiers vs Locators {#id-vs-loc}

IRIs used in JRI keywords are identifiers and not necessarily locators, even if they specify a scheme indicating a protocol suitable for resource retrieval.  Context specifications SHOULD indicate under what circumstances a reference can be treated as a locator and retrieved on demand, and address the security concerns related to automatic retrieval.

Standalone implementations of context-independent JRI MUST NOT attempt to automatically retrieve references by default.  They MAY offer a configuration option to do so, and MAY offer a mechanism to register handlers based on the IRI scheme or other IRI components.

### Duplicate IRIs {#duplicate-iris}

A resource MAY (and likely will) have multiple IRIs, but there is no way for an IRI to identify more than one resource.  When multiple primary or secondary resources attempt to identify as the same IRI through any combination of JRI keywords and context specification features, implementations SHOULD raise an error condition.  Otherwise the result is undefined, and even if documented will not be interoperable.

# Incorporating JRI into a context specification

A context specification incorporates JRI into a data format that describes JSON Pointer-compatible documents.  Such a specification MUST normatively reference this specification, and MUST specify any relevant context-specific requirements that this specification defers to context specifications.[^3]

[^3]: Should a root object be mandated?  If not, how much variation to accommondate.  Should a root object have to allow JRI keywords?  **No, because OAS does not (and probably AsyncAPI does not either).**

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

# Standalone JRI implementations

By definition, a standalone JRI implementation is an implementation that, in its default configuration, can only correctly process JRI in context-independent documents.

Such implementations MAY offer non-default configurations that incorporate context-aware behavior from any known context specification(s).  Implementations SHOULD document the conditions under which such non-default configurations are safe to use, and any assumptions involved that could produce unexpected behavior if used with a document tha does not conform to the relevant context specification.

## Implementing a standalone subset of JRI

The popularity of tools devoted only to processing `$ref` demonstrates a substantial market for simple standalone implementations of a JRI subset.  Standalone implementations that only support a subset of JRI MUST NOT claim to be full implementations of JRI, and MUST document what subset is supported.

# JRI Keywords

JRI defines several keywords, which fall into the categories of identification (`$id`, `$anchor`), location (`$defs`), and referencing (`$ref`).  These keywords MUST be evaluated in the following order when present:

1. `$id`, which assigns an IRI to a primary resource, and sets it as the resource's base IRI
1. `$anchor`, which assigns a fragment identifier to a secondary resource
1. `$defs`, which provides a location for reference targets
1. `$ref`, which references another resource using an IRI-reference

The logic of this ordering is that primary resources must be identified as all other keywords depend having the correct base IRI.  Secondary resources and other possible nested reference targets must be located and identified before attempting to reference them.  And fragment-like functionality requires having first found the target resource to which the functionality will be applied.

To ensure that as many references as possible are resolvable within a set of documents, all identification and location keywords within those documents SHOULD be processed prior to processing any reference keywords.

## Processing JRI keywords alongside of context specification keywords

Context specifications that define keywords with analogous functionality to JRI keywords SHOULD process each of them at the same point in the processing order as their analogous JRI keyword.  Changing the ordering of identifiers and references in particular is likely to produce counter-intuitive behavior, and reduces the interoperability of the JRI keywords with tools that are not context-aware.

Context specifications that define keywords with other behaviors MAY define any processing order for them.  However, it is RECOMMENDED that any keywords that might be impacted by the behavior of JRI identifier and location keywords be processed after those keywords.

JRI referencing is only interoperable if all non-JRI keywords (other than those overlapping in functionality with JRI identifiers and locations) are processed after JRI referencing keywords.  However, the semantics of keywords appearing alongside of JRI references is determined by context specifications, which therefore MAY define other ordering requirements.

## Identification

JRI offers two identification keywords:  one for primary resources, and one for secondary resources.

### `$id`

The value of the `$id` property MUST be a string, and MUST be a valid IRI-reference as defined by {{!RFC3987, Section 2.2}}, and MUST NOT contain a fragment.

The object containing the `$id` property MUST be considered to be a primary resource and to be identified by the IRI produced by resolving the IRI-reference against the current base IRI.  This IRI MUST be considered the base IRI for the newly identified primary resource, in accordance with {{!RFC3986, Section 5.1.1}}.

If the object containing the `$id` property is not the root object of the document, the encapsulating resource MUST be considered to be an "encapsulating entity" per {{!RFC3986, Section 5.1.2}}.

### `$anchor`

The value of the `$anchor` property MUST be a string, and MUST be a valid IRI fragment according to the `ifragment` ABNF production in {{!RFC3987, Section 2.2}}.

Context specifications that do not define media types, or that define media types without a defined fragment syntax, SHOULD NOT incorporate `$anchor` into the specification.

Context media types that define a fragment syntax SHOULD further constrain the syntax of `$anchor` to the set of fragments valid for that media type.  Any fragment syntax that correlates with the inherent structure of the document SHOULD be forbidden to avoid defining a fragment that conflicts with the document structure.

## Location

Many data formats perform some sort of action for each object that might contain JRI keywords.  For example, JSON Schema allows JRI keywords in schema objects, but most schema objects are automatically applied to instances.  To facilitate re-use, such formats need a location where re-usable objects can be stored without causing an action to happen unless and until they are referenced.

Context specifications will likely define their own such keywords, such as the `components` keyword used in both OpenAPI {{oas3.1}} and AsyncAPI {{async2.0}}, which has subsections for different component types.  Using the JRI standard location keyword (`$defs`) is not required, but enables safe interoperable bundling by standalone tools as described in {{bundling-interop}}.[^70]

[^70]: It's also possible to bundle documents that do not use `$defs` into a document that does, and can therefore be un-bundled by a generic bundling tool.  I'm not sure of the best way to talk about that, as I did not want to get into defining a bundling media type.

### `$defs`

The value of the `$defs` property MUST be an object, which MUST have objects as the values of all of its properties.

If the data format described by the context specification has a root object that allows JRI keywords, the structure of the objects under `$defs` SHOULD have the same structure as the root object, and MUST allow all JRI keywords that are allowed in the root object.  This is necessary to support bundling, which places resource root objects under `$defs`

## Referencing

JRI reference usage has two components: resolving the reference target and interpreting its semantics.  JRI offers several keywords for determining a reference target.  Once determined, regardless of which keywords are used, the possible semantics are as described in {{ref-semantics}}.

### `$ref`

The value of the `$ref` property MUST be a string, and MUST be a valid IRI-reference as defined by {{!RFC3987, Section 2.2}}.  The IRI produced by resolving this IRI-reference against the current base IRI identifies the reference target.

By default, the reference target MAY be assumed to be of whatever media type would otherwise be present inline, and fragments MAY be evaluated accordingly.  Context specifications MAY set other requirements regarding the nature of reference targets but MUST NOT expect these requirements to be interoperable with standalone JRI implementations.

### `$extRef`

To avoid overloading the behavior of `$ref` or relying on non-interoperable context-specific behavior, `$extRef` (for "extensible reference") allows specifying additional metadata as well as alternative mechanisms for secondary resource identifiecation.[^90]

[^90]: It is not yet clear how this should work.  I have asked the AsyncAPI team some clarifying questions.  An object value in which an IRI (without fragment) is provided in one member, and a (non-fragment) JSON Pointer or other fragment-substitute is provided in another would seem to solve some problems.  However, there is also a need to set a per-reference media type, and such a media type might have a fragment syntax.  We also don't want it to be easy to define both a fragment and a fragment alternative in the same reference, as the result of that would be unintuitive at best.  This is why I dropped `$refPtr` as a modifier of `$ref` (plus it made it impossible to guarantee that `$ref` was being evaluated properly without knowing more than otherwise necessary about how a document uses JRI.

### Reference semantics {#ref-semantics}

Reference semantics come in two varieties, object-level and keyword-level.  Object-level semantics are, under certain circumstances, both safe and interoperable in a context-independent manner.  Keyword-level semantics allow for more flexible semantic integration of referencing with a context-specification through allowing adjacent keywords.  However, this flexibility comes at the cost of interoperability, at least when adjacent keywords are actually present.

#### Object-level semantics {#object-level}

With object-level semantics, an object containing a JRI reference keyword is effectively replaced with its target.  This results in an evaluation path in which the reference keyword does not appear.

Object-level semantics are generally safe to assume when the object only contains JRI reference keywords.  Context specifications SHOULD ensure this safety even if their intended reference semantics are keyword-level.

Object-level replacement MAY be implemented by producing a copy of the source document with the reference object replaced by the contents of its target.  When a reference target itself contains references, an implementation MUST replace all references in the target prior to replacing the source reference with the target or otherwise keep track of the resolution context to avoid improperly evaluating a relative reference.

#### Keyword-level semantics {#keyword-level}

With keyword-level semantics, a JRI reference keyword remains part of the evaluation path, and has the effect of evaluating its target in the current context, as defined by the context specification.  Context specifications MAY define how such effects are combined with the effects of non-JRI keywords in the same object as the JRI reference keywords.  Such combined effects MUST NOT involve changing the behavior of JRI keywords to conflict with this specification in any way.

There is no universally safe way to edit a document containing a reference to contain the reference target instead, even without circular references, although context specifications MAY define such edits.[^30]

[^30]: At one point in JSON Schema spec development, we discussed allowing reference "removal" by replacing `$ref` and its IRI value with `$inline` and the reference target value.  This allows inlining at the keyword level without needing to understand a context specification.  `$inline` was essentially a one-element `allOf` that conveyed that a reference had been inlined.  Is this worth reviving in JRI?  Doing so would not force JSON Schema to adopt it.  One complexity would be that if there are multiple JRI reference keywords, we would either need one inlinng keyword per reference if we want it to be reversible, or `$inline` would have to support meta-data along with the target.

#### Falling back to object-level semantics

Context specifications that use keyword-level semantics SHOULD ensure that, in the absence of keywords adjacent to JRI reference keywords, object-level JRI reference semantics can be assumed without changing the semantics of the document according to the context specification.  This requires that the difference in evaluation paths not impact the context semantics.

For example, in JSON Schema, replacing an object that contains only `$ref` is guaranteed to not change the validation outcome, and only changes the evaluation path of annotations.  Since the presence of `$ref` in the evaluation path is used to determine whether keywords are present adjacent to `$ref`, omitting it when no such adjacent keywords are present is safe.  While JSON Schema specifies keyword-level semantics, a tool that replaced `$ref`-only objects with their targets according to object-level semantics prior to JSON Schema evaluation would not break the schema's behavior.

# JRI Applications

JRI exists to faciliated interoperable tooling.  Therefore, several common applications of JRI here are described to encourage common functionality.

## Locating, caching, and serving resources

A primary use case for JRI involves removing the need for downstream tools to track base IRIs and retrieve identified resources.  We will refer to a tool that fulfills this use case as a _JRI cache_.  In this use case, downstream tooling still encounters JRI references, but they have already been resolved to full IRIs (with a scheme), and the implementation resolves all IRIs by requesting them from the JRI cache.

Depending on the exact functionality offered, the "cache" could be as simple as a look-up table.  It could also perform actual cachign tasks such as managing a working set in limited memory, or integrating with a caching system such as one offered by HTTP clients in accordance with {{?RFC9111}}.  JRI does not impose any requirements in this regard.

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

## Document set transformations

A common family of use cases involves reading one or more JRI-using documents and transforming them in a way that makes them usable by a wider range of tooling.

### Reference removal

This use case attempts to remove all references with object-level semantics by replacing the reference objects with their targets, resulting in a plain JSON (or other underlying format) document that requires no knowledge of JRI.

Removing references from a set of documents with differing base IRIs, or involving fragments that are to be resolved within a specific primary resource carries additional restrictions.  References MUST be traversed in a depth-first fashion and removed from the leaf to the root, so that each removal takes place in the proper primary resource context and with the proper base IRI.

### Bundling to JSON Pointer fragment references only

Despite implementing specifications that allow multi-document sets, in practice a significant number of tools only support same-resource references using JSON Pointer fragments (the only fragmenty syntax listed by name in older JSON Reference specifications).

This form of bundling creates a single document and adjusts all references to only point to the newly bundled locations using JSON Pointers.

### Bundling with stable references

A set of documents that each set `$id` in their root objects, and that only refer to each other using the primary resource identifiers set that way (plus any approriate fragment syntax) can be bundled into a single compound document that satisfies all references internally without the need to edit them.

Unlike the previous two use cases, this type of bundling can be un-bundled.  An interoperable bundling format that can be safely un-bundled regardless of context is defined in {{bundling-interop}}.

## Transparent in-memory representation of document sets

This use case aims to present a set of linked documents as if no references were present at all (if object-level semantics are used), or as if the reference values are their targets rather than IRIs (if keyword-level semantics are used).  Typically, this involves some sort of lazy proxy object to ensure cyclic references do not automatically cause infinite recursion.

Depending on the intended scope of support (e.g. a single self-referential document vs document sets that link to each other and possibly external resources), this use case can benefit from being implemented on top of a JRI cache.

# Extending JRI {#extending}

[^40]

[^40]: This section is something of a placeholder.  I'm not quite sure how much to say, although it is important to specify that adjacent kewyords can disambiguate semantics _within the context usage_ but not change them such that the semantics no longer match this specification.  Otherwise that is a gray area with respect to the requirement to not impact JRI semantics.

Rather than being directly extensible, JRI is intended to work alongside other specifications that might provide similar functionality.  An example would be JSON Schema's concept of dynamic references and anchors, which could be a companion specification to JRI.  In order for any combination to be interoperable, it MUST define its own set of interoperability constraints spanning the constituent functionalities.

## Disambiguatingn reference semantics {#disambiguator}

Context specifications MAY define keywords that, when appearing adjacent to JRI referencing keywords, clarify the semantics of that reference within the semantics of that context specification.  For example, a specification for code generation might want to indicate whether a reference indicates linking two distinct pieces of generated code in a particular way rather than simply being an artifact of document organization that should be ignored.

# Relationship to Web Linking

The functionality of JRI could mostly be implemented using {{?RFC8288}} web linking.  However, there are a variety of competing JSON-based formats for linking, many of which impose structural constraints likely to conflict with the needs of context specifications.  JRI is a simpler and more focused specification, intended to be easily incorporated into a variety of possible formats.

* The `$id` keyword effectively defines a link with relation type "self".
* The `$ref` keyword effectively defines (and asks implementations to automatically follow) a link with the generic relation type "related".

# Interoperability Considerations {#interop}

Context-independent interoperability places several additional requirements on any document that needs to be processed by a context-independent JRI implementation.  Most of these requirements are not enforceable by a context-independent implementation.  Users of context-independent implementations MUST NOT expect documents that violate these requirements to be detected by the implementation, and MUST NOT expect predictable, interoperable behavior
from processing such documents.

A document that can be interoperably processed by a context-independent JRI implementation will be referred to in this section as a _context-independent document_.  A data format for which all valid documents are context-independent documents will be referred to in this section as a _context-independent format._

The requirements below are stated for context-independent formats.  A document in a non-context-indpendent format can be context-independent if it avoids using any features forbidden by the context-independent format requirements.

## Restricting base IRI changes and IRI assignment {#interop-overlap}

A context-independent format MUST NOT offer features for assigning IRIs to primary or secondary resources, or changing the base IRI from within a document.

A context-independent document MUST NOT use any such features if the data format offers them.

## Recognizing JRI keywords

The property names in the value of `$defs` are known to be non-keyword properties as this object syntax is defined by JRI.  These property names therefore MUST be considered exempt from the other requirements in this section regarding property names.

A context-independent format MUST NOT allow object properties with names matching JRI keywords and values that appear valid for that keyword that are not intended to function as JRI keywords anywhere within the format.

Note that as JRI implementations are not required to validate keyword values, simply having the correct value type (e.g. string) is enough to make such a keyword appear to be a valid JRI keyword.  Context-independent JRI implementations MAY offer a non-default configuration option to validate potential JRI keyword values and ignore (rather than treat as an error) those that do not have valid values.

## Ensuring consistent reference semantics

A context-independent format MUST NOT allow any non-JRI-reference keywords in the same object as any JRI reference keyword.[^11]

[^11]: Should we allow a context-independent format to allow non-JRI keywords in reference objects as long as it mandates that they are, in all circumstances, ignored?  Aside from `$comment`, this seems like asking for trouble, and OpenAPI and AsyncAPI notably forbid any properties other than `$ref` in their Reference Objects.  But it would be closer to JSON Reference behavior.

## Finding JRI identifiers

A context-independent format MUST NOT allow JRI identifiers anywhere other than its root object or under a `$defs` keyword appearing (recursively) in the root object.[^10]

[^10]:Alternatively, we could treat them like the reference keywords and require that they be allowed anywhere.  Neither approach works with JSON Schema, but the JSON Schema vocabulary for JRI proposed in a later section would provide a way to do so.

A context-independent document MUST NOT use JRI identifiers outside of these locations.

## Interoperable bundling and un-bundling {#bundling-interop}

A context-independent bundling tool can un-bundle a document meeting the following requirements:

* The root object MUST contain `$defs`, and each bundled resource MUST be embedded in the `$defs` object; the names of the `$defs` properties are irrelevant
* If the embedded resources' `$id` values are relative IRI-reference, the root object MAY contain an absolute-IRI `$id` so that the resources can be bundled and un-bundled without changing their `$id`s; when un-bundled, such resources are expected to be in a directory structure appropriate to their `$id`s relative to the shared base

## JRI behavior negotiation

To maximize the usefulness of standalone tooling, such tools need to be able to determine the degree to which JRI is used and the interoperability assurances on which it can rely.[^41]

[^41]: This section is more-or-less brainstorming.  The problem it is solving is real, but whether these solutions belong in this specification or not is open to question.

### Media type parameters for safe processing

Context specifications defining media types SHOULD define the `jri-safety` and `jri-keywords` media type parameters to enable standalone implementations, including standalone subset implementations, to determine whether they can safely process the document.

These parameters are intended for use in environments where a standalone implementation is likely to encounter documents with unexpected media types involving unpredictable JRI usage.  Standalone implementations MAY use other heuristics and information sources to determine whether to process a document.

Non-media type context data formats MAY define a mechanism analogous to these media type parameters, but such mechanisms will not be interoperable.

#### The "jri-safety" media type paramter

The value of the `jri-safety` parameter MUST be case-insensitive, and MUST be either `interoperable` or `contextual`.  The default value is `contextual`, indicating that an implementation MUST be aware of and support the relevant context specification in order to safely process JRI keywors in the document.  A value of `interoperable` indicates that the document is context-independent, and safe to process by a standalone implementation.

### The "jri-keywords" media type parameter

The value of the `jri-keywords` parameter MUST be a case-senstive comma-separated list of JRI keyword names, which MUST NOT contain whitespace.  These keywords MAY be in any order.  This indicates that only the listed keywords are used in the document. In the absence of this parameter, an implementation MUST assume that any JRI keyword can be used.

### A JSON Schema vocabulary for safe processing

[^42]

[^42]: A simple annotation vocabulary could indicate where exactly in a document JRI keywords can appear, and what behavior they might have.  Unlike the media type parameters, this approach could distinguish between `$ref`/`$id`/`$anchor` within a schema vs those property names with JRI-correct values within `enum`, `const`, or `examples`.  This would make it possible to use a generic JRI cache as the base for a JSON Schema impementation.

# Security Considerations

On-demand retrieval and processing of referenced resources brings the security risks inherent in handling any data from an untrusted source.  It is RECOMMENDED that implementations supporting this behavior support defining allow/deny lists for limiting retrieval to trusted sources.

Implementations of a JRI cache that implement a functional caching system (rather than a simple lookup table) need to address the security considerations of the caching process(es) that they support.

## Guarding Against Infinite Recursion

An implementation MUST guard against infinite reference loops.

Processing rules for context specifications MAY make it safe to have cyclic references by creating conditions under which a reference will or will not be followed.

Cyclic references cannot safely be processed in a way that is both interoperable and context-independent.  Seeing a specific reference while processing the target of that same reference MUST be considered an error by context-unaware implementations.

# IANA Considerations

--- back

# Example usages with schemas

# Media types, IRI fragments, and non-fragment JSON Pointers

As stated by {{!RFC3986, Section 3.5}}, fragment syntax and semantics are defined by media types.  Attempting to use fragments other than as defined by a media type is behavior that is not in compliance with internet standards.

In particular, {{?RFC8259}} does not define a fragment syntax for `application/json`, and {{!RFC6901, Section 6}} explicitly notes that JSON Pointer is not the fragment identifier syntax for `application/json`.

JRI is also intended to be usable with resources that do not define a media type, and therefore do not have a defined fragment syntax.[^20]

[^20]: It's unclear what the best approach to this is right now, but I have come up with several possible ways to specify a primary resource IRI (no-fragment) and a piece of data (JSON Pointer or otherwise) that performs the secondary resouce identification.

# JSON Pointer compatiblity {#jsonpointer}

This section defines how to determine if a format is compatible with JSON Pointer by specifying what aspects of a format do and do not need to be mapped to JSON concepts.  It is up to individual implementations and context specifications to determine if any particular format is JSON Pointer-compatible, and how to support evaluating pointers that use JSON Pointer syntax for documents in that format.  An example of how to do this is the YAML media type's correlation of YAML and JSON in {{?I-D.ietf-httpapi-yaml-mediatypes, Section 3.3}}

JSON Pointer is only defined for JSON Documents.  However, the evaluation algorithm defined in {{!RFC6901, Section 4}} is written in terms of JSON Arrays and JSON Objects with Unicode member names.  Notably, non-object/array JSON data is not involved at all, except as the result of the evaluation which does not depend on the type of the result value.

{{!RFC8259}} defines JSON Objects and Arrays sufficiently to determine whether an in-memory data structure can be serialized into JSON.

If a data format's parsed in-memory representation can be serialized according to JSON's requirements, using unique placeholder values for scalar values that are not serializable in JSON, then JSON Pointer can be evaluated on that serialization to determine the location of the result.  If necessary, the unique placeholder value(s) could then be used to recreate the corresponding value from the original (non-JSON) document.

Any document that can be converted as described in the previous paragraph could equivalently evaluate syntactically valid JSON Pointers by substituting its own object and array definitions for JSON Objects and Arrays, and adjusting the string comparison rules as needed if it does not use Unicode.

Note that a many documents in a format can be JSON Pointer-compatible, even if the format in general is not.  For example, YAML is not compatible due to allowing non-string property values, but the very commonly used JSON-compatible subset of YAML is, of course, JSON Pointer-compatible.  The proposed YAML media type registration {{?I-D.ietf-httpapi-yaml-mediatypes-03, Section 3.3}} addresses this, including the evaluation of JSON Pointers over YAML documents.

On the other hand, the mixure of elements and attributes in XML means that XML is never JSON Pointer-compatible.  There is no obvious single way to map XML to JSON-like objects and arrays, as demonstrated by the need for the `xml` keyword in {{oas3.1}}.


# Reasons {#reasons}

## AsyncAPI requirements

After most of this document was written, AsyncAPI began a discussion on reference [tooling requirements](https://github.com/orgs/asyncapi/discussions/485r) which turns out to line up rather well.

## Survey of JSON Reference implementations

RFC EDITOR PLEASE DELETE THIS SECTION.

The following implementations demonstrate pre-existing demand for various features in this specification.  Their appearance here does not indicate any sort of endorsement or guarantee of suitability for purpose.  Feature lists come from the packages' documentation and have not been verified.

Some of these projects are no longer in active development but still have high daily download/installation numbers.  This indicates that demand remains high for a stable library, rather than that the library has fallen out of use due to lack of demand.

* JavaScript
    * [jsonref](https://www.npmjs.com/package/jsonref)
        * Supports `id` (draft-04) and `$ref` (JSON Reference)
        * Supports supplying a mapping store object that can be shared among a document set
        * Supports plugins for on-demand resource retrieval
    * [json-refs](https://www.npmjs.com/package/json-refs)
        * Supports `$ref` only
        * Collects and stores metadata on references
        * Metadata tracks circular references
        * Metadata for overall resolution includes evaluation path, but with `$ref` itself elided
        * Supports transclusion
        * Supports resource caching
        * Supports finding references (returned as JSON Pointers to the reference objects, with metadata)
        * Supports filtering on local/remote/relative/invalid references
        * Allows pre/post-processing hooks for reference objects
    * [@apidevtools/json-schema-ref-parser](https://www.npmjs.com/package/@apidevtools/json-schema-ref-parser)
        * Originally just called [json-schema-ref-parser](https://www.npmjs.com/package/json-schema-ref-parser)
        * Supports `$ref` only
        * Supports circular references via lazy proxies
        * Supports transclusion
        * Supports "bundling" to internal-only references (different from "bundling" in this spec)
        * `id`/`$id` support has been [requested](https://github.com/APIDevTools/json-schema-ref-parser/issues/22), [multiple](https://github.com/APIDevTools/json-schema-ref-parser/issues/136), including in the context of [bundling](https://github.com/APIDevTools/json-schema-ref-parser/issues/97)
        * `$anchor` support has been [requested](https://github.com/APIDevTools/json-schema-ref-parser/issues/222)
        * The proper behavior of `$ref` with adjacent keywords has also [been discussed](https://github.com/APIDevTools/json-schema-ref-parser/issues/168)
    * [@apidevtools/json-schema-reader](https://github.com/APIDevTools/json-schema-reader)
        * Apparently never published (but the basics are well-documented)
        * Handles `id`/`$id`, `$anchor`, and `$ref`
        * Reads sets of JSON Schema documents and [maps their structure](https://github.com/APIDevTools/json-schema-reader/blob/main/docs/schema-structure.md)
        * Distinguishes between resource location (URL) and identifier (URI)
        * Seems to have very customizable resource retrieval and external resource support, but this was not documented before the project seems to have been abandoned
        * Seems like it may be being re-absorbed into a revamped json-schema-ref-parser
* PHP
    * [League\JsonReference](https://json-reference.thephpleague.com/)
        * Supports `id` (draft-04), `$id` (draft-06+) and `$ref` (JSON Reference)
        * Supports plugins for on-demand resource retrieval
        * Supports caching of retrieved resources using a shared cache object
        * Supports circular references via lazy proxies
        * Supports transclusion (inlining on serialization to JSON) if no circular references
        * Supports custom serializers
* Python
    * [json-ref-dict](https://github.com/jacksmith15/json-ref-dict)
        * Supports `$ref` only
        * Lazy proxy objects
        * Some basic document transformation features (include/exclude keys, value map)
    * [jsonref](https://jsonref.readthedocs.io/en/latest/)
        * Supports `$ref` only
        * Uses proxy references and transcludes on access
        * implements json module's interface for parsing/serializing with automatic reference replacement
    * [jsonspec.reference](https://json-spec.readthedocs.io/reference.html)
        * Supports `$ref` only
        * Supports transclusion
        * Notes that further relative references in an extracted/transcluded JSON value will not work
        * Supports plugins for on-demand resource retrieval
* Go
    * [jsref](https://github.com/lestrrat-go/jsref)
        * Supports `ref` only
        * Supports plugins for resource retrieval, including from in-memory map

There are also tools in Ruby, Java and Go that either have basic transclusion support or aren't sufficiently well-documented to easily determine their feature set.


The more recent shift to allowing JSON Schema keywords adjacent to `$ref` has caused some confusion and difficulty (while solving other confusions and difficulties):

* https://github.com/APIDevTools/json-schema-ref-parser/issues/200 (adjacent properties challenges)
* https://github.com/APIDevTools/json-schema-ref-parser/issues/199 (base URI challenges)
* https://github.com/APIDevTools/json-schema-ref-parser/issues/145 (implement 2019-09+ $ref, $id, $anchor)

# Acknowledgements

# FAQ
{: numbered="false"}

Q: Why this document?
: Reasons.

# Change Log {#changelog}
{: numbered="false"}

RFC EDITOR PLEASE DELETE THIS SECTION.

Due to the long an complex history of these keywords in general, and `$ref` in particular, this change log takes the unusual approach of treating all known formal and informal specifications that defined or adapt these keywords as part of this specification's history.  Unlike most I-D change logs, the other specifications are linked as informative reference to make it easier to examine the historical context.

## JSON Referencing and Identification draft-handrews-jri-00
{: numbered="false"}

* Extract `$id`, `$anchor`, `$ref`, and `$defs` from JSON Schema
* `$id` no longer allows any fragment at all
* All keywords work with IRI-references rather than only URI-references
* Add `$extRef` for working around fragment limitations and other difficulties
* Defines evaluation order for keywords
* Defines behavior for JSON Pointer-compatible documents
* Defines how other specifications can use these keywords
* Defines allowable restrictions within other specifications
* Defines interoperable context-independent behavior
* Defines what context-specific behavior can be defined by other specifications

## JSON Reference and non-JSON Linking (draft proposal)
{: numbered="false"}

* {{jref-nonj-linking}}
* Proposes reviving JSON Reference with additional `referenceFormat` keyword
* Distinguishes between "referencing" (for JSON targets) and "linking" (for non-JSON targets)
* "Referencing" behavior matches that of draft-pbryan-zyp-json-ref-03
* "Linking" requires setting `referenceFormat` to a media type adjacent to the reference object (not to `$ref)
* Resolving "linking" behavior produces a `content` keyword alongside of `$ref` with the target contents as its value in string form
* Fragments for JSON targets still interpreted as JSON Pointer
* Fragments for non-JSON targets MUST be ignored

## JSON Schema Core draft-bhutton-json-schema-01 (draft 2020-12 clarification)
{: numbered="false"}

* {{?I-D.bhutton-json-schema-01}}
* No changes for JRI-related keywords

## OpenAPI Specification v3.1.0
{: numbered="false"}

* {{oas3.1}}
* Uses superset of JSON Schema draft 2020-12
* Uses JSON Reference draft-03, but only outside of schemas
* Base URI determined by "the referring document" in accordance with RFC 3986 (but `$id` has normal base URI-modifying behavior inside of schemas)

## JSON Schema Core draft-bhutton-json-schema-00 (draft 2020-12)
{: numbered="false"}

* {{?I-D.bhutton-json-schema-00}}
* No changes for JRI-related keywords

## JSON Schema Core draft-handrews-json-schema-02 (draft 2019-09)
{: numbered="false"}

* {{?I-D.handrews-json-schema-02}}
* `$ref` now treated as a normal JSON Schema applicator keyword
* Therefore `$ref` sibling keywords have normal behavior as with any other applicator
* `$id` no longer defines fragments, and cannot contain one (except empty fragment for compatibility)
* `$id` considered to define an embedded resource, allowing schema behavior (`$schema`) to be resource-scoped
* `$anchor` takes over plain name fragment definition, syntax is just the name, not a URI-reference
* `definitions` renamed to `$defs` and moved to this specification from JSON Schema Validation
* Behavior of JSON Pointer fragments crossing a resource boundary (`$id`) is implementation-defined and therefore not interoperable

## AsyncAPI Specification v2.0.0
{: numbered="false"}

* {{async2.0}}
* Uses superset of JSON Schema draft-07
* Uses JSON Reference draft-03, both inside and outside of schemas
* Base URI not mentioned

## JSON Reference (draft proposal)
{: numbered="false"}

* {{json-ref-2019}}
* Proposes reviving and extending JSON Reference
* Uses `$href` and `$embedded` for `$ref` and `$id` to avoid collision with JSON Schema
* Defines behavior in terms of HTTP, web linking, and URLs
* `$href` based on JSON Reference's `$ref`
* `$embedded` uses the embedded resource behavior of `$id` in the about-to-be-publishd draft of JSON Schema
* `$embedded` restricted to absolute-URIs (with scheme, without fragment)
* JSON Pointer fragments not allowed to cross `$embedded`
* Tentativley proposes `$header` to further describe resource relationships

## JSON Schema Core draft-handrews-json-schema-01 (draft-07 clarification)
{: numbered="false"}

* {{?I-D.handrews-json-schema-01}}
* `$id`-created plain name fragments described as "location-independent identifiers"
*  Recommends that the root schema contain an absolute-URI `$id`
*  Exhaustive schema identification examples showing all possible `$id`-crossing JSON Pointer fragments
*  Replaced "external referencing" with how and when an implementation might know of a schema from another doucment
*  Replaced "internal referencing" with how an implementation should recognized schema identifiers during parsing
*  Dereferencing the former "internal" or "external" references is always the same process

## JSON Schema Core draft-handrews-json-schema-00 (draft-07)
{: numbered="false"}

* {{?I-D.handrews-json-schema-00}}
* Wording improvements for `$id`

## AsyncAPI Specification v1.0.0
{: numbered="false"}

* {{async1.0}}
* Uses extended subset of JSON Schema draft-wright-json-schema-00, without `id`, `definitions`, or JSON Schema's `$ref`
* Uses JSON Reference draft-03, both inside and outside of schemas
* Uses `components` at root level with typed sub-objects instead of `definitions`
* Base URI not mentioned

## OpenAPI Specification v3.0.0
{: numbered="false"}

* {{oas3.0}}
* Uses extended subset of JSON Schema draft-wright-json-schema-00, without `id`, `definitions`, or JSON Schema's `$ref`
* Uses JSON Reference draft-03, both inside and outside of schemas
* Uses `components` at root level with typed sub-objects instead of `definitions`
* Base URI not mentioned

## JSON Schema Core draft-wright-json-schema-01 (draft-06)
{: numbered="false"}

* {{?I-D.wright-json-schema-01}}
* `id` renamed to `$id`

## JSON Schema Core draft-wright-json-schema-00 _(there is no draft-05)_
{: numbered="false"}

* {{?I-D.wright-json-schema-00}}
* Returns `$ref` to this specification, value is a URI-reference
* No special handling of fragments defined for `$ref`
* `$ref` is "not a network locator, only an identifier"
* `$ref` limited to schemas
* Implementations SHOULD NOT assume a network operation for `$ref`
* Defines `id` as setting the URI and base URI of the schema, as well as plain name fragments
* Defines initial base URI in terms of RFC 3986
* Shows JSON Pointer URI fragments that cross `id` as valid schema URIs
* "Internal references" (SHOULD support) replaces "inline dereferencing"
* "External references" (SHOULD support) replaces "canonical dereferencing"

## OpenAPI (formerly known as Swagger) Specification v2.0
{: numbered="false"}

* {{oas2.0}}
* Uses an extended subset of JSON Schema draft-04, without `id` or `definitions`
* Uses JSON Reference draft-03, both inside and outside of schemas
* Base URI not mentioned
* Uses `definitions` at root level instead of within schemas

## Swagger Specification v1.2
{: numbered="false"}

* {{swagger1.2}}
* Adapts several keywords from JSON Schema draft-04, not including `id` or `definitions`
* Uses `$ref` without noting a specific source, draft-04 uses JSON Reference so JSON Reference is assumed

## JSON Schema Validation  draft-fge-json-schema-validation (draft-04)
{: numbered="false"}

* {{?I-D.fge-json-schema-validation-00}}
* Introduces `definitions` keyword as "a standardized location for schema authors to inline JSON Schemas into a more general schema"

## JSON Schema Core draft-zyp-json-schema-04 (draft-04)
{: numbered="false"}

* {{?I-D.zyp-json-schema-04}}
* The only JSON Schema draft to defer `$ref` to the JSON Reference specification
* `id` described as enabling "URI resolution scope alteration"
* "Extends" JSON Reference by allowing `id` to change the base URI
* "Extends" JSON Reference with "inline dereferencing" allowing non-JSON Pointer fragments
* `id` now capable of defining plain name fragments
* Defines optional "inline dereferencing" mechanism for implementations that "notice" `id` usage
* Defines mandatory "canonical dereferencing" mechanism for retrieving reference targets

## JSON Reference draft-pbryan-zyp-json-ref-03
{: numbered="false"}

* {{?I-D.pbryan-zyp-json-ref-03}}
* `profile` media type parameter no longer defined
* Schema for JSON Reference no longer defined

## JSON Reference draft-pbryan-zyp-json-ref-02
{: numbered="false"}

* {{?I-D.pbryan-zyp-json-ref-02}}
* Any properties adjacent to `$ref` SHALL be ignored

## JSON Reference draft-pbryan-zyp-json-ref-01
{: numbered="false"}

* {{?I-D.pbryan-zyp-json-ref-01}}
* JSON Reference contains a `$ref` property ("single property" no longer specified")
* Objects that do not conform to this should not be treated as a JSON Reference
* Implementations MAY choose to replace the JSON Reference with the target

## JSON Reference draft-pbryan-zyp-json-ref-00
{: numbered="false"}

<!---
  Do not use "?" on pbryan-zyp-json-ref-00 because this is a manual link, auto is broken
-->
* {{I-D.pbryan-zyp-json-ref-00}}
* `$ref` split out from JSON Schema: "This provides a basis for transclusion in JSON: the use of a target resource as an effective substitute for the reference."
* Defines a JSON Reference as an object containing a single `$ref` property
* Relative URI-reference performed relative to the referring document's base URI
* Fragment resolved according to the referrant document
* Fragment to be interpreted as JSON Pointer if referrant document is JSON
* Defines media type parameter `profile=http://json-schema.org/json-ref` for `application/json`
* Defines a schema `http://json-schema.org/json-ref`

## JSON Schema draft-zyp-json-schema-03 (draft-03)
{: numbered="false"}

* {{?I-D.zyp-json-schema-03}}
* `$ref` keyword introduced as "a URI of a schema that contains the full representation of this schema"
* `$ref` behavior as replacing the current schema with the target "if known and available" and re-validating
* `id` keyword introduced as "the current URI of this schema (this attribute is effectively a "self" link)"
* `id` defines behavior of ineriting the URI from the parent schema if `id` not present in the current schema
* Behavior of keywords adjacent to `$ref` not mentioned
* Neither keyword uses the term "base URI"

