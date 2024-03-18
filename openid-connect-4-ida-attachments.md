%%%
title = "OpenID Attachments 1.0 draft"
abbrev = "openid-connect-4-ida-attachments-1_0"
ipr = "none"
workgroup = "eKYC-IDA"
keyword = ["security", "openid", "identity assurance", "ekyc", "claims"]

[seriesInfo]
name = "Internet-Draft"

value = "openid-connect-4-ida-attachments-1_0-00"

status = "standard"

[[author]]
initials="T."
surname="Lodderstedt"
fullname="Torsten Lodderstedt"
organization="yes.com"
    [author.address]
    email = "torsten@lodderstedt.net"

[[author]]
initials="D."
surname="Fett"
fullname="Daniel Fett"
organization="Authlete"
    [author.address]
    email = "mail@danielfett.de"

[[author]]
initials="M."
surname="Haine"
fullname="Mark Haine"
organization="Considrd.Consulting Ltd"
    [author.address]
    email = "mark@considrd.consulting"

[[author]]
initials="A."
surname="Pulido"
fullname="Alberto Pulido"
organization="Santander"
    [author.address]
    email = "alberto.pulido@santander.co.uk"

[[author]]
initials="K."
surname="Lehmann"
fullname="Kai Lehmann"
organization="1&1 Mail & Media Development & Technology GmbH"
    [author.address]
    email = "kai.lehmann@1und1.de"

[[author]]
initials="K."
surname="Koiwai"
fullname="Kosuke Koiwai"
organization="KDDI Corporation"
    [author.address]
    email = "ko-koiwai@kddi.com"

%%%

.# Abstract

This specification defines an extension of OpenID Connect that defines new attachments relating to the identity of a natural person. The work and the preceding drafts are the work of the eKYC and Identity Assurance working group of the OpenID Foundation.

{mainmatter}

# Introduction {#Introduction}

This specification defines an attachment element as a JWT claim that MAY be used in various contexts.

Attachment element was inspired by the work done on [@OpenID4IDA] and in particular how to include images of various pieces of evidence used as part of an identity assurance process, however, it is anticipated that there may be other cases where the ability to embed or refer to non-JSON structured data may be useful.

# Scope

This specification defines how embedded and external attachments can be used.

# Attachments {#attachments}

This definition was inspired by the work done on [@OpenID4IDA] and in particular how to include images of various pieces of evidence used as part of an assurance process, however, it is anticipated that there may be other cases where the ability to embed or refer to non-JSON structured data may be useful.

<!-- Where attachments are used in identity verification process, specific document artifacts will be created and depending on the trust framework, will be required to be stored for a specific duration. These artifacts can later be reviewed during audits or quality control for example. These artifacts include, but are not limited to: -->
Identity verification プロセス中で添付ファイルが使用される場合，特定のドキュメントアーティファクトが生成され，トラストフレームワークに応じて特定の期間保存する必要がある．これらのアーティファクトは，後で監査や品質管理などの際に確認することができる．これらのアーティファクトには次のものが含まれるが，これらに限定されない:

<!--
* scans of filled and signed forms documenting/certifying the verification process itself,
* scans or photocopies of the documents used to verify the identity of End-Users,
* video recordings of the verification process,
* certificates of electronic signatures.
-->
* 検証プロセス自体を文章化/証明する，記入済みかつ署名済みフォームのスキャン
* エンドユーザーの identity を確認するために使用されるドキュメントのスキャンまたは写真コピー
* 検証プロセスのビデオ録画
* 電子署名の証明書

<!-- When requested by the RP, these artifacts can be attached to the Verified Claims response allowing the RP to store these artifacts along with the Verified Claims information. -->
RP から要求された場合，RP が検証済み Claim 情報とともにこれらのアーティファクトを保存できるように，これらのアーティファクトを検証済み Claim のレスポンスに添付することができる．

<!-- An attachment is represented by a JSON object. This specification allows two types of representations: -->
添付ファイルは JSON オブジェクト形式で表現される．本仕様では2種類の表現が可能である:

## Embedded Attachments

<!-- All the information of the document (including the content itself) is provided within a JSON object having the following elements: -->
(コンテンツ自身を含む) ドキュメントのすべての情報は，以下の要素を持つ JSON オブジェクト内で提供される:

<!-- `desc`: OPTIONAL. Description of the document. This can be the filename or just an explanation of the content. The used language is not specified, but is usually bound to the jurisdiction of the underlying trust framework of the OP. -->
`desc`: OPTIONAL. ドキュメントの説明. ファイル名または単なるコンテンツの説明にすることができる．使用する言語は指定されていないが，通常 OP の基礎となるトラストフレームワークの管轄に拘束される．

<!-- `content_type`: REQUIRED. Content (MIME) type of the document. See [@!RFC6838]. Multipart or message media types are not allowed. Example: "image/png" -->
`content_type`: REQUIRED. ドキュメントのコンテンツ (MIME) タイプ． [@!RFC6838] 参照．マルチパートまたはメッセージメディアタイプは許可されない．例: "image/png"

<!-- `content`: REQUIRED. Base64 encoded representation of the document content. -->
`content`: REQUIRED. ドキュメントコンテンツの Base64 エンコード表現.

`txn`: OPTIONAL. Identifier referring to the verification or validation transaction that generated a particular attachment. When used in the context of an [@OpenID4IDA] response the OP SHOULD ensure this matches a `txn` contained within `check_method` when `check_method` needs to reference the embedded attachment.

<!-- The following example shows embedded attachments within a UserInfo endpoint response. The actual contents of the attached documents are truncated: -->
以下の例は，UserInfo エンドポイントのレスポンス内に埋め込まれた添付ファイルを示す．添付ドキュメントの実際の内容は切り捨てられている:

<{{examples/response/embedded_attachments.json}}

<!-- Note: Due to their size, embedded attachments may not be appropriate when embedding in objects such as Access Tokens or ID Tokens. -->
注: 埋め込み添付ファイルはサイズが大きいため，アクセストークンまたは ID トークンなどのオブジェクトに埋め込む場合適切ではないかもしれない．

## External Attachments

<!-- External attachments are similar to distributed Claims as defined in [@OpenID]. The reference to the external document is provided in a JSON object with the following elements: -->
External attachments は [@OpenID] で定義されている分散 Claim と似ている．外部ドキュメントへの参照は，以下の要素を持つ JSON オブジェクト内で提供される:

<!-- `desc`: OPTIONAL. Description of the document. This can be the filename or just an explanation of the content. The used language is not specified, but is usually bound to the jurisdiction of the underlying trust framework or the OP. -->
`desc`: OPTIONAL. ドキュメントの説明. ファイル名または単なるコンテンツの説明にすることができる．使用する言語は指定されていないが，通常 OP の基礎となるトラストフレームワークの管轄に拘束される．

`url`: REQUIRED. OAuth 2.0 resource endpoint from which the attachment can be retrieved. Providers MUST protect this endpoint, ensuring that the attachment cannot be retrieved by unauthorized parties (typically by requiring an access token as described below). The endpoint URL MUST return the attachment whose cryptographic hash matches the value given in the `digest` element. The content MIME type of the attachment MUST be indicated in a content-type HTTP response header, as per [@!RFC6838]. Multipart or message media types SHALL NOT be used.

<!-- `access_token`: OPTIONAL. Access Token as type `string` enabling retrieval of the attachment from the given `url`. The attachment MUST be requested using the OAuth 2.0 Bearer Token Usage [@!RFC6750] protocol and the OP MUST support this method, unless another Token Type or method has been negotiated with the Client. Use of other Token Types is outside the scope of this specification. If the `access_token` element is not available, RPs MUST use the Access Token issued by the OP in the Token response and when requesting the attachment the RP MUST use the same method as when accessing the UserInfo endpoint. If the value of this element is `null`, no Access Token is used to request the attachment and the RP MUST NOT use the Access Token issued by the Token response. In this case the OP MUST incorporate other effective methods to protect the attachment and inform/instruct the RP accordingly. -->
`access_token`: OPTIONAL. 与えられた `url` から添付ファイルを取得できるようにする `string` タイプの Access Token．添付ファイルは OAuth 2.0 Bearer Token Usage [@!RFC6750] プロトコルを使用してリクエストしなければならず (MUST)， 別のトークンタイプまたはメソッドが Client とネゴシエートされていない限り，OP はメソッドをサポートしなければならない (MUST)．他のトークンタイプの仕様は本仕様の範囲外である．`access_token` 要素が利用できない場合，RP は Token Response で OP によって発行された Access Token を利用しなければならず (MUST)，添付ファイルを要求する時，RP は UserInfo エンドポイントにアクセスするときと同じ方法を使用しなければならない (MUST)．この要素の値が `null` の場合，添付ファイルを要求するために Access Token は使用されず，RP は Token Response によって発行された Access Token を使用してはならない (MUST NOT)．この場合，OP は添付ファイルを保護するための他の有効な方法を組み込み，それに応じて RP に通知/指示しなければならない (MUST)．

`exp`: OPTIONAL. The "exp" (expiration time) claim identifies the expiration time on or after which the External Attachment will not be available from the resource endpoint defined in the `url` element (e.g. the `access_token` may expire or the document may be removed at that time). Implementers MAY provide for some small leeway, usually no more than a few minutes, to account for clock skew.  Its value MUST be a number containing a NumericDate value as per as per [@!RFC7519].

<!-- `digest`: REQUIRED. JSON object containing details of a cryptographic hash of the document content taken over the bytes of the payload (and not, e.g., the representation in the HTTP response). The JSON object has the following elements: -->
`digest`: REQUIRED. JSON object containing details of a cryptographic hash of the document content taken over the bytes of the payload (and not, e.g., the representation in the HTTP response). JSON オブジェクトは以下の要素を持つ:

<!--
* `alg`: REQUIRED. Specifies the algorithm used for the calculation of the cryptographic hash. The algorithm has been negotiated previously between RP and OP during Client Registration or Management.
* `value`: REQUIRED. Base64-encoded [@RFC4648] bytes of the cryptographic hash.
-->
* `alg`: REQUIRED. 暗号化ハッシュの計算に使用されるアルゴリズムを指定する．アルゴリズムは，Client の登録または管理の間に RP と OP の間で事前にネゴシエートされている．
* `value`: REQUIRED. Base64 エンコード [@RFC4648] された暗号化ハッシュのバイト．

`txn`: OPTIONAL. Identifier referring to the verification or validation transaction that generated a particular attachment. When used in the context of an [@OpenID4IDA] response the OP SHOULD ensure this matches a `txn` contained within `check_method` when `check_method` needs to reference the embedded attachment.

<!-- It is RECOMMENDED that access tokens for external attachments have a binding to the specific resource being requested so that the access token may not be used to retrieve additional external attachments or resources. For example, the value of `url` could be tied to the access token as audience. This enhances security by enabling the resource server to check whether the audience of a presented access token matches the accessed URL and reject the access when they do not match. The same idea is described in Resource Indicators for OAuth 2.0 [@RFC8707], which defines the `resource` request parameter whereby to specify one or more resources which should be tied to an access token being issued. -->
追加の外部添付ファイルやリソースを取得するためにアクセストークンが使用されないために，外部添付ファイルのアクセストークンは要求されている特定のリソースへバインディングすべきである (RECOMMENDED)．例えば，`url` の値を audience としてアクセストークンと関連付けることができる．これにより，リソースサーバーは提示されたアクセストークンの audience がアクセスされた URL と一致するかを確認し，一致しない場合にアクセスを拒否することで，セキュリティを強化する．同じアイデアが Resource Indicators for OAuth 2.0 [@RFC8707] で説明されており，発行されるアクセストークンに関連付けられる1つ以上のリソースを指定するための `resource` リクエストパラメーターを定義している．

<!-- The following example shows external attachments: -->
以下の例は external attachments を示す:

<{{examples/response/external_attachments.json}}

## External Attachment Validation

Clients MUST validate each external attachment they wish to rely on in the following manner:

1. Ensure that the object includes the required elements: `url`, `digest`.
2. Ensure that at the time of the request the time is before the time represented by the `exp` element.
3. Ensure that the URL defined in the `url` element uses the `https` scheme.
4. Retrieve the attachment from the `url` element in the object.
5. Ensure that the content MIME type of the attachment is indicated in a content-type HTTP response header
6. Ensure that the MIME type is not Multipart (see Section 5.1 of [@RFC2046])
7. Ensure that the MIME type is not a "message" media type (see [@RFC5322])
8. Ensure the returned attachment has a cryptographic hash digest that matches the value given in the `digest` object's `value` key.

If any of these requirements are not met the content of the attachment SHOULD NOT be used, SHOULD be discarded and MUST NOT be relied upon.

# Privacy Considerations

<!-- As attachments will most likely contain more personal information than was requested by the RP with specific Claim names, an OP MUST ensure that the End-User is well aware of when and what kind of attachments are about to be transferred to the RP. If possible or applicable, the OP SHOULD allow the End-User to review the content of these attachments before giving consent to the transaction. -->
添付ファイルには，特定の Claim 名を使用して RP から要求されたよりも多くの個人情報が含まれる可能性が高いため，OP はいつどのような種類の添付ファイルが RP に転送されるかを，エンドユーザーが十分に認識していることを確認しなければならない (MUST)．可能であれば，あるいは適用可能であれば，OP はエンドユーザーがトランザクションに同意する前に，これらの添付ファイルのコンテンツを確認できるようにするべきである (SHOULD)．

# Client Registration and Management

During Client Registration (see [@!OpenID-Registration]) as well as during Client Management [@RFC7592] the following additional properties are available:

`digest_algorithm`: String value representing the chosen digest algorithm (for external attachments). The value MUST be one of the digest algorithms supported by the OP as advertised in the [OP metadata](#opmetadata). If this property is not set, `sha-256` will be used by default.

# OP Metadata {#opmetadata}

If attachments are used in [@OpenID] implementations an additional element of OP Metadata is required to advertise its capabilities with respect to supported attachments in its openid-configuration (see [@!OpenID-Discovery]):

`attachments_supported`: REQUIRED when OP supports attachments. JSON array containing all attachment types supported by the OP. Possible values are `external` and `embedded`. When present this array MUST have at least one member. If omitted, the OP does not support attachments.

`digest_algorithms_supported`: REQUIRED when OP supports external attachments. JSON array containing all supported digest algorithms which can be used as `alg` property within the digest object of external attachments. If the OP supports external attachments, at least the algorithm `sha-256` MUST be supported by the OP as well. The list of possible digest/hash algorithm names is maintained by IANA in [@!hash_name_registry] (established by [@RFC6920]).

This is an example openid-configuration snippet:

```json
{
...
  "attachments_supported": [
    "external",
    "embedded"
  ],
    "digest_algorithms_supported": [
    "sha-256"
  ],
...
}
```

# Examples

This section contains JSON snippets showing examples of evidences and attachments described in this document.

## Example Requests
This section shows examples of requests for `verified_claims`.

### Verification of Claims by trust framework with a document and attachments

<{{examples/request/verification_aml_with_attachments.json}}

#### Attachments

RPs can explicitly request to receive attachments along with the Verified Claims:

<{{examples/request/verification_with_attachments.json}}

As with other Claims, the attachment Claim can be marked as `essential` in the request as well.

## Example Responses

This section shows examples of responses containing `verified_claims`.

### Document with external attachments

<{{examples/response/document_with_attachments.json}}

### Utility statement with attachments

<{{examples/response/utility_statement_with_attachments.json}}

### Vouch with embedded attachments

<{{examples/response/vouch_with_attachments.json}}

{backmatter}

<reference anchor="OpenID" target="http://openid.net/specs/openid-connect-core-1_0.html">
  <front>
    <title>OpenID Connect Core 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="M." surname="Jones" fullname="Mike Jones">
      <organization>Microsoft</organization>
    </author>
    <author initials="B." surname="de Medeiros" fullname="Breno de Medeiros">
      <organization>Google</organization>
    </author>
    <author initials="C." surname="Mortimore" fullname="Chuck Mortimore">
      <organization>Salesforce</organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

<reference anchor="OpenID4IDA" target="http://openid.net/specs/openid-connect-4-identity-assurance-1_0.html">
  <front>
    <title>OpenID Connect for Identity Assurance 1.0</title>
    <author initials="T." surname="Lodderstedt" fullname="Torsten Lodderstedt">
      <organization>yes.com</organization>
    </author>
    <author initials="D." surname="Fett" fullname="Daniel Fett">
      <organization>Authlete</organization>
    </author>
    <author initials="M." surname="Haine" fullname="Mark Haine">
      <organization>Considrd.Consulting Ltd</organization>
    </author>
    <author initials="A." surname="Pulido" fullname="Alberto Pulido">
      <organization>Santander</organization>
    </author>
    <author initials="K." surname="Lehmann" fullname="Kai Lehmann">
      <organization>1&amp;1 Mail &amp; Media Development &amp; Technology GmbH</organization>
    </author>
        <author initials="K." surname="Koiwai" fullname="Kosuke Koiwai">
      <organization>KDDI Corporation</organization>
    </author>
   <date day="16" month="Jun" year="2023"/>
  </front>
</reference>

<reference anchor="ISO3166-1" target="https://www.iso.org/standard/72482.html">
    <front>
      <title>ISO 3166-1:2020. Codes for the representation of names of
      countries and their subdivisions -- Part 1: Country codes</title>
      <author surname="International Organization for Standardization">
        <organization abbrev="ISO">International Organization for Standardization</organization>
      </author>
      <date year="2020" />
    </front>
</reference>

<reference anchor="ISO3166-3" target="https://www.iso.org/standard/72482.html">
    <front>
      <title>ISO 3166-3:2020. Codes for the representation of names of countries and their subdivisions -- Part 3: Code for formerly used names of countries</title>
      <author surname="International Organization for Standardization">
        <organization abbrev="ISO">International Organization for
        Standardization</organization>
      </author>
      <date year="2020" />
    </front>
</reference>

<reference anchor="ICAO-Doc9303" target="https://www.icao.int/publications/Documents/9303_p3_cons_en.pdf">
  <front>
    <title>Machine Readable Travel Documents, Seventh Edition, 2015, Part 3: Specifications Common to all MRTDs</title>
      <author surname="INTERNATIONAL CIVIL AVIATION ORGANIZATION">
        <organization>INTERNATIONAL CIVIL AVIATION ORGANIZATION</organization>
      </author>
   <date year="2015"/>
  </front>
</reference>

<reference anchor="E.164" target="https://www.itu.int/rec/T-REC-E.164/en">
  <front>
    <title>Recommendation ITU-T E.164</title>
    <author>
      <organization>ITU-T</organization>
    </author>
    <date year="2010" month="11"/>
  </front>
</reference>

<reference anchor="OpenID-Discovery" target="https://openid.net/specs/openid-connect-discovery-1_0.html">
  <front>
    <title>OpenID Connect Discovery 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="M." surname="Jones" fullname="Mike Jones">
      <organization>Microsoft</organization>
    </author>
    <author initials="E." surname="Jay" fullname="Edmund Jay">
      <organization>Illumila</organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

<reference anchor="OpenID-Registration" target="https://openid.net/specs/openid-connect-registration-1_0.html">
  <front>
    <title>OpenID Connect Dynamic Client Registration 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="M." surname="Jones" fullname="Mike Jones">
      <organization>Microsoft</organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

<reference anchor="RFC4648" target="https://datatracker.ietf.org/doc/html/rfc4648">
  <front>
    <title>The Base16, Base32, and Base64 Data Encodings</title>
    <author initials="S." surname="Josefsson" fullname="S. Josefsson">
      <organization>SJD</organization>
    </author>
   <date month="Oct" year="2006"/>
  </front>
</reference>

<reference anchor="hash_name_registry" target="https://www.iana.org/assignments/named-information/">
  <front>
    <title>Named Information Hash Algorithm Registry</title>
    <author>
      <organization>IANA</organization>
    </author>
    <date year="2016" month="09"/>
  </front>
</reference>

# Acknowledgements {#Acknowledgements}

The following people at yes.com and partner companies contributed to the concept described in the initial contribution to this specification: Karsten Buch, Lukas Stiebig, Sven Manz, Waldemar Zimpfer, Willi Wiedergold, Fabian Hoffmann, Daniel Keijsers, Ralf Wagner, Sebastian Ebling, Peter Eisenhofer.

We would like to thank Julian White, Bjorn Hjelm, Stephane Mouy, Alberto Pulido, Joseph Heenan, Vladimir Dzhuvinov, Azusa Kikuchi, Naohiro Fujie, Takahiko Kawasaki, Sebastian Ebling, Marcos Sanz, Tom Jones, Mike Pegman, Michael B. Jones, Jeff Lombardo, Taylor Ongaro, Peter Bainbridge-Clayton, Adrian Field, George Fletcher, Tim Cappalli, Michael Palage, Sascha Preibisch, Giuseppe De Marco, Nick Mothershaw, Hodari McClain, Nat Sakimura and Dima Postnikov for their valuable feedback and contributions that helped to evolve this specification.

# Notices

Copyright (c) 2023 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document History

   [[ To be removed from the final specification ]]


   -00 (WG document)

   *  Split this content from openid-connect-4-identity-assurance-1_0-13 WG document
   * Add RFC4648 as normative reference

# Translator {#translator}

本仕様の翻訳は, OpenID ファウンデーションジャパン [@oidfj] KYC ワーキンググループ [@oidfj-kycwg], 翻訳・教育ワーキンググループ [@oidfj-trans] を主体として, 有志のメンバーによって行われました.
質問や修正依頼などについては, Github レポジトリー [@oidfj-github] にご連絡ください.

* Muneomi Sakuta (SoftBank Corp.)
* Yuu Kikuchi (OPTiM Corp.)
* Nov Matake (YAuth.jp)
