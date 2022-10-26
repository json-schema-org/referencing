# JRef Specification

## Introduction
This specification defines the JSON Reference (JRef) media type. JRef is an
extension of the [JSON](https://www.rfc-editor.org/rfc/rfc8259) media type that
adds the "reference" type. A "reference" type represents a web-style
uni-directional link to a location in either the current document or a different
resource.

## Media Type
The JRef media type is identified as `application/reference+json` and uses the
`jref` file extension.

### Fragments
A URI [fragment](https://www.rfc-editor.org/rfc/rfc3986#section-3.5) that is
empty or starts with a `/` MUST be interpreted as a [JSON
Pointer](https://www.rfc-editor.org/rfc/rfc6901). A JSON Pointer fragment
represents a secondary resource that is the result of applying the JSON Pointer
to the full document. Implementations MUST raise an error if the JSON Pointer
does not successfully resolve to a location within the document.

Specifications that extend this media type MAY define semantics for fragments
that are not JSON Pointers, but if the fragment semantics are not understood,
implementations MUST raise an error.

### Profiles
This media type allows the "profile" media type parameter as defined by [RFC
6906](https://www.rfc-editor.org/rfc/rfc6906).

## The "reference" Type

### Syntax
A "reference" type is represented as a JSON object with a `$href` property whose
value is string. Specifications that extend this media type MAY define semantics
for additional properties, but implementations MUST raise an error if they
encounter a property that is not defined.

```json
{ "$href": "https://example.com/example.json#/foo/bar" }
```

Although the "reference" type has syntactic overlap with the JSON "object" type,
it MUST NOT be interpreted as a JSON object. The "reference" type is a scalar
value that can not be indexed into like a JSON object.

A JSON object is considered a "reference" rather than an "object" if it has a
`$href` property and the value of that property is a string.

### Following References
The value of `$href` in a reference MUST be interpreted as a [URI
reference](https://www.rfc-editor.org/rfc/rfc3986#section-4.1). The process for
determining a base URI for resolving to a full
[URI](https://www.rfc-editor.org/rfc/rfc3986#section-3) is defined by [RFC 3986
Section 5.1](https://www.rfc-editor.org/rfc/rfc3986#section-5.1). Specifications
that extend this media type MAY add keywords that effect the base URI, but if
they do, they MUST do so in a way that is compatible with [RFC 3986 Section
5.1](https://www.rfc-editor.org/rfc/rfc3986#section-5.1).

Following a reference may result in media types other than JRef being returned.
While implementations are not limited to only handling JRef responses, they MUST
raise an error if they encounter a media type they do not support.

When following a URI that uses a protocol where the response is self describing
of its media type, implementations MUST NOT assume the response is a JRef
document or use heuristics including file extensions to determine the media type
of the response. For example, an HTTP response for `https://example.com/example`
that has `Content-Type: application/json` should not be treated as a JRef media
type. That means that any objects with a `$href` property should not be
considered a reference. It would just be a JSON object that looks like a JRef
reference.

When following a URI using a protocol where the response is not self describing
of its media type (such as file system access), implementations MAY use whatever
heuristic they deem necessary to determine the media type of the response
including context hints from the referring document. If implementations use file
extensions as a heuristic, they SHOULD use the [IANA media types
registry](https://www.iana.org/assignments/media-types/media-types.xhtml) to
determine which file extensions map to which media types.

A reference may point to a secondary resource within the referred to document as
defined by the [fragment](https://www.rfc-editor.org/rfc/rfc3986#section-3.5)
semantics of the media type of the referred to document.

## Values
The "value" of a reference is the JSON-compatible value of the result of
following the reference. Implementations MAY define how non-JSON media types
translate to a JSON-compatible value. Implementations MAY provide an API for
working with media types that do not translate to a JSON compatible value.
