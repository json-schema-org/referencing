# The `"$ref"` (&amp; Friends) Story So Far

**Table of Contents**

1. [Notable discussions and issues](#notable-discussions-and-issues)
2. [Select tools and their features](#select-tools-and-their-features)
3. [History of reference and identification keywords](#history-of-reference-and-identification-keywords)

The contents of the following sections were chosen in a rather idiosyncratic manner and are not comprehensive.  PRs for important missing links are welcome.

## Notable discussions and issues

* **AsyncAPI**
    * discussion #485: [Reference tooling discussion and requirements](https://github.com/orgs/asyncapi/discussions/485)
* **OAI/OpenAPI-Specification**
    * discussion #3045: [Path Item Object $ref - how does it work?](https://github.com/OAI/OpenAPI-Specification/issues/3045)
    * issue #2936: [Compose all component types, not just schemas](https://github.com/OAI/OpenAPI-Specification/issues/2936)
    * issue #2685: [OpenAPI bundling proposal](https://github.com/OAI/OpenAPI-Specification/issues/2685)
    * issue #2635: [Ambiguity between Reference Object and PathItem Object](https://github.com/OAI/OpenAPI-Specification/issues/2635)
    * issue #2038: [Internal references pointing out of the Components Object fixed fields](https://github.com/OAI/OpenAPI-Specification/issues/2038)
* **ietf-wg-httpapi/mediatypes**
    * issue #2: [Define fragment identifier specifications for OAS / Schema](https://github.com/ietf-wg-httpapi/mediatypes/issue/2)
    * issue #50: [+yaml fragment parsing compatibility](https://github.com/ietf-wg-httpapi/mediatypes/issues/50)
* **ietf-wg-jsonpath/draft-ietf-jsonpath-base**
    * issue #124: [JsonInclude Processing Extension](https://github.com/ietf-wg-jsonpath/draft-ietf-jsonpath-base/issue/124)
* **APIDevTools/json-schema-ref-parser** [numerous issues](https://github.com/APIDevTools/json-schema-ref-parser/issue) illustrate interoperability and implementation challenges, including but not limited to:
    * issue #271: [Immediately circular schema causes a maximum call stack trace exception](https://github.com/APIDevTools/json-schema-ref-parser/issue/271)
    * issue #200: [Fails to resolve correct path/filename for extended $ref](https://github.com/APIDevTools/json-schema-ref-parser/issue/200) (adjacent properties challenges)
    * issue #199: [References to references resolve relative to self, not baseUrl](https://github.com/APIDevTools/json-schema-ref-parser/issue/199) (base URI properties challenges)
    * issue #145: ["$id" and "$ref" changes in JSON Schema draft 2019-09 and OAS 3.1](https://github.com/APIDevTools/json-schema-ref-parser/issue/145)


## Select tools and their features

The following implementations demonstrate pre-existing demand for various features relevant to the topic of referencing and identification.  Their appearance here does not indicate any sort of endorsement or guarantee of suitability for purpose.  Feature lists come from the packages' documentation and have not been verified.

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

## History of reference and identification keywords

All of the pre-existing `$`-prefixed keywords that might become part of a referencing and identification specification (`$ref`, `id`/`$id`, `$anchor`, `definitions`/`$defs`) were originally introduced as part of JSON Schema.  However, `$ref` in particular has a complex history, appearing in numerous other specifications.  Additionally, some specifications use `components` with a two-level system rather than `$defs`.

### 2010-11-22 JSON Schema [draft-zyp-json-schema-03](https://datatracker.ietf.org/doc/html/draft-zyp-json-schema-03) (draft-03)

* `$ref` keyword introduced as "a URI of a schema that contains the full representation of this schema"
* `$ref` behavior as replacing the current schema with the target "if known and available" and re-validating
* `id` keyword introduced as "the current URI of this schema (this attribute is effectively a "self" link)"
* `id` defines behavior of inheriting the URI from the parent schema if `id` not present in the current schema
* Behavior of keywords adjacent to `$ref` not mentioned
* Neither keyword uses the term "base URI"

### 2011-11-14 JSON Reference [draft-pbryan-zyp-json-ref-00](https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-00)

* `$ref` split out from JSON Schema: "This provides a basis for transclusion in JSON: the use of a target resource as an effective substitute for the reference."
* Defines a JSON Reference as an object containing a single `$ref` property
* URI-reference resolution performed relative to the referring document's base URI
* Fragment resolved according to the referrant document
* Fragment to be interpreted as JSON Pointer if referrant document is JSON
* Defines media type parameter `profile=http://json-schema.org/json-ref` for `application/json`
* Defines a schema `http://json-schema.org/json-ref`

### 2011-11-24 JSON Reference [draft-pbryan-zyp-json-ref-01](https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-01)

* JSON Reference contains a `$ref` property ("single property" no longer specified)
* Objects that do not conform to this should not be treated as a JSON Reference
* Implementations MAY choose to replace the JSON Reference with the target

### 2012-03-09 JSON Reference [draft-pbryan-zyp-json-ref-02](https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-02)

* Any properties adjacent to `$ref` SHALL be ignored

### 2012-09-16 JSON Reference [draft-pbryan-zyp-json-ref-03](https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-03)

* `profile` media type parameter no longer defined
* Schema for JSON Reference no longer defined

### 2013-01-31 JSON Schema Core [draft-zyp-json-schema-04](https://datatracker.ietf.org/doc/html/draft-zyp-json-schema-04) (draft-04)

* The only JSON Schema draft to defer `$ref` to the JSON Reference specification
* `id` described as enabling "URI resolution scope alteration"
* "Extends" JSON Reference by allowing `id` to change the base URI
* "Extends" JSON Reference with "inline dereferencing" allowing non-JSON Pointer fragments
* `id` now capable of defining plain name fragments
* Defines optional "inline dereferencing" mechanism for implementations that "notice" `id` usage
* Defines mandatory "canonical dereferencing" mechanism for retrieving reference targets

### 2013-02-01 JSON Schema Validation [draft-fge-json-schema-validation-00](https://datatracker.ietf.org/doc/html/draft-fge-json-schema-validation-00) (draft-04)

* Introduces `definitions` keyword as "a standardized location for schema authors to inline JSON Schemas into a more general schema"

### 2014-03-14 Swagger Specification [v1.2](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/1.2.md)

* Adapts several keywords from JSON Schema draft-04, not including `id` or `definitions`
* Uses `$ref` without noting a specific source, draft-04 uses JSON Reference so JSON Reference is assumed

### 2014-09-08 OpenAPI (formerly known as Swagger) Specification [v2.0](https://spec.openapis.org/oas/v2.0.html)

* Uses an extended subset of JSON Schema draft-04, without `id` or `definitions`
* Uses JSON Reference draft-03, both inside and outside of schemas
* Base URI not mentioned
* Uses `definitions` at root level instead of within schemas

### 2016-10-13 JSON Schema Core [draft-wright-json-schema-00](https://datatracker.ietf.org/doc/html/draft-wright-json-schema-00) ~~(draft-05)~~

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

### 2017-04-15 JSON Schema Core [draft-wright-json-schema-01](https://datatracker.ietf.org/doc/html/draft-wright-json-schema-01) (draft-06)

* `id` renamed to `$id`

### 2017-07-26 OpenAPI Specification [v3.0.0](https://spec.openapis.org/oas/v3.0.0.html)

* Uses extended subset of JSON Schema draft-wright-json-schema-00, without `id`, `definitions`, or JSON Schema's `$ref`
* Uses JSON Reference draft-03, both inside and outside of schemas
* Uses `components` at root level with typed sub-objects instead of `definitions`
* Base URI not mentioned

### 2017-09-20 AsyncAPI Specification [v1.0.0](https://github.com/asyncapi/spec/blob/1.0.0/README.md)

* Uses extended subset of JSON Schema draft-wright-json-schema-00, without `id`, `definitions`, or JSON Schema's `$ref`
* Uses JSON Reference draft-03, both inside and outside of schemas
* Uses `components` at root level with typed sub-objects instead of `definitions`
* Base URI not mentioned

### 2017-11-19 JSON Schema Core [draft-handrews-json-schema-00](https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-00) (draft-07)

* Wording improvements for `$id`

### 2018-03-19 JSON Schema Core [draft-handrews-json-schema-01](https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-01) (draft-07 clarification)

* `$id`-created plain name fragments described as "location-independent identifiers"
*  Recommends that the root schema contain an absolute-URI `$id`
*  Exhaustive schema identification examples showing all possible `$id`-crossing JSON Pointer fragments
*  Replaced "external referencing" with how and when an implementation might know of a schema from another doucment
*  Replaced "internal referencing" with how an implementation should recognized schema identifiers during parsing
*  Dereferencing the former "internal" or "external" references is always the same process

### 2019-08-13 [JSON Reference (draft revival proposal)](https://github.com/hyperjump-io/browser/blob/master/lib/json-reference/README.md)

* Proposes reviving and extending JSON Reference
* Uses `$href` and `$embedded` for `$ref` and `$id` to avoid collision with JSON Schema
* Defines behavior in terms of HTTP, web linking, and URLs
* `$href` based on JSON Reference's `$ref`
* `$embedded` introduces the embedded resource behavior of that `$id` adopted in the following JSON Schema draft
* JSON Pointer fragments not allowed to cross `$embedded`
* Tentatively proposes `$header` to further describe resource relationships

### 2019-09-11 AsyncAPI Specification [v2.0.0](https://www.asyncapi.com/docs/reference/specification/v2.0.0)

* Uses superset of JSON Schema draft-07
* Uses JSON Reference draft-03, both inside and outside of schemas
* Base URI not mentioned

### 2019-09-16 JSON Schema Core [draft-handrews-json-schema-02](https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-02) (draft 2019-09)

* `$ref` now treated as a normal JSON Schema applicator keyword
* Therefore `$ref` sibling keywords have normal behavior as with any other applicator
* `$id` no longer defines fragments, and cannot contain one (except empty fragment for compatibility)
* `$id` considered to define an embedded resource, allowing schema behavior (`$schema`) to be resource-scoped
* `$anchor` takes over plain name fragment definition, syntax is just the name, not a URI-reference
* `definitions` renamed to `$defs` and moved to this specification from JSON Schema Validation
* Behavior of JSON Pointer fragments crossing a resource boundary (`$id`) is implementation-defined and therefore not interoperable

### 2021-02-15 OpenAPI Specification [v3.1.0](https://spec.openapis.org/oas/v3.0.1.html)

* Uses superset of JSON Schema draft 2020-12
* Uses modified JSON Reference draft-03, but only outside of schemas
* The JSON Ref modification is allowing "summary" and "description" alongside "$ref"
* Base URI determined by "the referring document" in accordance with RFC 3986 (but `$id` has normal base URI-modifying behavior inside of schemas)

### 2020-12-08 JSON Schema Core [draft-bhutton-json-schema-00](https://datatracker.ietf.org/doc/html/draft-bhutton-json-schema-00) (draft 2020-12)

* No changes for referencing and identification-related keywords

### 2022-06-10 JSON Schema Core [draft-bhutton-json-schema-01](https://datatracker.ietf.org/doc/html/draft-bhutton-json-schema-01) (draft 2020-12 clarification)

* No changes for referencing and identification-related keywords


