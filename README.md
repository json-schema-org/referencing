# Referencing in JSON-Oriented Ecosystems

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](https://github.com/json-schema-org/.github/blob/main/CODE_OF_CONDUCT.md) [![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)


Welcome to the JSON Schema Organizations's Referencing and Identification repository!

## Purpose

This repository contains proposals regarding referencing and identification of documents in JSON-oriented ecosystems.  Currently, there are two specifications that are often referenced:

* [JSON Schema Core](https://www.ietf.org/archive/id/draft-bhutton-json-schema-01.html), which since draft 2019-09 defines `$ref` in a way that only fully works within JSON Schema
* [JSON Reference](https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-03), which is a draft that expired and was abandoned almost a decade ago

This has led to a number of challenges:

* Some specifications (OAS 3.1) use both approaches in different places
* Some specifications (AsyncAPI) need to reference non-JSON systems, which is not addressed by either approach
* JSON Reference-based tools often implement behaviors (bundling and unbundling, assigning URIs) that are not addressed by the JSON Reference draft
* Tools have inconsistent feature sets, resulting in interoperability challenges

**For links to numerous discussions and a complete history of the potentially relevant keywords, see the [BACKGROUND](BACKGROUND.md) file.**

Please note that JSON Schema's dynamic referencing features (e.g. `"$dynamicAnchor"` and `"$dynamicRef"`) are ***not*** within the scope of this repository.

## Proposals

Proposals in this repository are expected to address these concerns for the entire community, including but not limited to the projects mentioned above.

_**The JSON Schema Organization is not backing any specific proposal at this stage.**_

We are hosting this process, which we expect to involve several competing ideas initially.  Merging contributions to this repository does not indicate an endorsement.  We expect a single proposal will emerge through discussion and feedback, and will move into a more formal standards process.

## Process

This repository is also a place to discuss the process and format of this work, and how it can and should interact with other projects.

Due to the focus on interoperability, the initial assumption is to produce IETF RFCs.  If we want to quickly produce an authoritative document covering current behavior, an [informational RFC](https://www.ietf.org/standards/process/informational-vs-experimental/) might be appropriate.  This would not preclude other aspects becoming standards-track RFCs in the future.

## Format

Proposals should be written in Markdown and submitted as PRs from a fork of the repo.

The repository will automatically build [kramdown-rfc](https://github.com/cabo/kramdown-rfc) format documents, which should be named in RFC I-D `draft-{primary-editor}-{draft-name}.md` style.  For example, if JSON Schema Validation were written in this format, the file name would be `draft-bhutton-json-schema-validation.md`.

Plain markdown is also welcome, and such proposals should be named `{primary-editor}-{draft-name}.md`.

If you would like to use the RFC I-D format, you can use the [markdown I-D template](https://github.com/martinthomson/i-d-template) as a starting point.  You will need a reasonably recent version of Python 3 to run a local build, but the makefile will check out everything else it needs using a submodule and automatically create a virtual env for the build.

## License

The contents of this repository are [licensed under](./LICENSE.md) the MIT License.
