%%%
title = "OpenID Identity Assurance schema definition 1.0 draft"
abbrev = "openid-ida-verified-claims-1_0"
ipr = "none"
workgroup = "eKYC-IDA"
keyword = ["security", "openid", "identity assurance", "ekyc", "claims"]

[seriesInfo]
name = "Internet-Draft"

value = "openid-ida-verified-claims-1_0-00"

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

<!-- This specification defines a payload schema that can be used to describe a wide variety of identity assurance metadata about a number of Claims that have been assessed as meeting a given assurance level. -->
本仕様では, 特定の保証レベルを満たすと評価された多数の Claim に関する様々なアイデンティティ保証メタデータを記述するために使用できる, ペイロードスキーマを定義している.

<!-- It is intended that this payload schema is re-usable across many different contexts and application layer protocols including but not limited to [@!OpenID] and [@VerifiableCredentials]. -->
このペイロードスキーマは [@!OpenID] と [@VerifiableCredentials] を含むがこれらに限らず, 様々な文脈やアプリケーション層プロトコルにわたって再利用可能であることを目的としている.

<!-- This document defines a new claim relating to the identity assurance of a natural person called "verified_claims".  This was originally developed within earlier drafts of OpenID Connect for Identity Assurance. The work and the preceding drafts are the work of the eKYC and Identity Assurance working group of the OpenID Foundation. -->
本ドキュメントでは "verifid_claims" と呼ばれる自然人のアイデンティティ保証に関連する新しいクレームを定義している. これは元々 OpenID Connect for Identity Assurance の以前のドラフトで開発されていたものである. この取り組みと以前のドラフトは, OpenID Foundation eKYC & IDA ワーキンググループの取り組みである.

{mainmatter}

# Introduction {#Introduction}

<!-- This specification defines a schema for describing assured identity Claims and a range of associated identity assurance metadata. Much of this definition will be optional as it depends on which processes were run, and the operational requirements for data-minimisation, which elements of the JSON schema described in this document will be needed for a specific transaction. -->
本仕様では, 保障されたidentity Claims と関連する一連のidentity assurance メタデータを記述するためのスキーマを定義している. この定義の多くは, どのプロセスが実行されるか, データ最小化のための運用要件, このドキュメントで説明される JSON スキーマのどの要素が特定のトランザクションに必要になるのかに依存しており任意となっている.

# Scope

<!-- This specification defines the schema of JSON objects used to describe identity assurance relating to a natural person.  It consists of the definition of a new claim called `verified_claims` that will be registered with the IANA "JSON Web Token Claims Registry" established by [@!RFC7519].  As part of the definition of the `verified_claims` claim there is also be an element defined called `verification` that provides a flexible container for identity assurance metadata. It is anticipated that the `verification` element may be used by other spec authors and implementers where the verification metadata is needed independantly of the end-user verified Claims. -->

本仕様では, 自然人に関連するidentity assurance を記述するために使用されるJSON オブジェクトのスキーマを定義している. これは[@!RFC7519]で確立されたIANA の"JSON Web Token Claims Registry"に登録される予定である, `verified_claims` と呼ばれる新しいクレームの定義を構成している. `verified_claims` クレームの定義の一部として, identity assurance メタデータのための柔軟なコンテナを提供する, `verification` と呼ばれる要素も定義されている. `verification` 要素は End-User が検証した Claim に依存しないverification メタデータが必要とされる場合に, 他の仕様の著者や実装者によって使用されるかもしれないことが予期される.

## Terminology

<!-- This section defines some terms relevant to the topic covered in this document, inspired by NIST SP 800-63A [@NIST-SP-800-63a]. -->
このセクションでは, NIST SP 800-63A [@NIST-SP-800-63a] の影響を受けた, このドキュメントで扱われているトピックに関連するいくつかの用語を定義する.

<!-- * Claim - as per definition is section 1.2 of [@!OpenID] -->
* Claim - [@!OpenID] セクション 1.2 の定義に従う

<!-- * Claims Provider - as per definition is section 1.2 of [@!OpenID] with the additional requirement that they support the schema described in this document. Note: this could be an OpenID Connect Provider, a Verifiable Claims Issuer or other application component that provides verified claims. -->
* Claims Provider - [@!OpenID]  セクション1.2 で定義されている通りであり, このドキュメントで記述されているスキーマをサポートするという要件が追加される.
Note: これは, OpenID Connect Provider, Verifiable Claims Issuer または検証済みクレームを提供する他のアプリケーションコンポーネントである可能性がある.

<!-- * Claims Recipient - an application that receives claims from the Claims provider -->
* Claims Recipient - Claims Provider からクレームを受け取るアプリケーション

<!-- * Identity Proofing - process in which an End-User provides evidence to a provider reliably identifying themselves, thereby allowing the provider to assert that identification at a useful assurance level. -->
* Identity Proofing - End-User が自分自身を確実に識別できるエビデンスをプロバイダーに提供することにより, プロバイダーが有用な保証レベルで識別できるようにするプロセス.

<!-- * Identity Verification - process conducted by the provider to verify the End-User's identity. -->
* Identity Verification - End-User identity を verifiacation するためにプロバイダーによって実行されるプロセス

<!-- * Identity Assurance - process in which the provider asserts identity data of a certain End-User with a certain assurance towards another consuming entity (such as an OpenID Connect Relying Party or Verifier as described in [@VerifiableCredentials]), typically expressed by way of an assurance level. Depending on legal requirements, the provider may also be required to provide evidence of the identity verification process to the consuming entity. -->
* Identity Assurance - プロバイダーが, 別の消費エンティティ([@VerifiableCredentials]で記述される OpenID Connect Relying Party やVerifier など)に対して特定の保証を持つ特定のエンドユーザーの Identity データを主張するプロセスで, 通常は assurance レベルで表される. 法的要件に応じて,プロバイダーは identity verification プロセスのエビデンスを消費エンティティに提供する必要がある場合もある.


<!-- * Verified Claims - Claims about an End-User, typically a natural person, whose binding to a particular End-User account was verified in the course of an identity verification process. -->
* Verified Claims - 特定のエンドユーザーアカウントへのバインドが identity verification プロセスの過程で検証された End-User (通常は自然人) に関する Claim.

# Requirements

<!-- The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 [RFC2119]. -->
本ドキュメントにおける "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", "OPTIONAL" のキーワードは, RFC 2119 [RFC2119] で説明されているように読み替えられる.

<!-- The specified JSON structures defined in this document should be useable by any protocol that needs to pass assured digital identity attributes or needs to transfer identity assurance metadata between systems using the [@JSON] Data Interchange Format. -->
本ドキュメントで定義されている特定の JSON 構造は, 保証される digital identity attributes を渡す必要があるプロトコル, または [@JSON] データ交換フォーマットを用いてシステム間で Identity assurance メタデータを転送する必要があるプロトコルで使用可能である必要がある.

# Verified Claims {#verified_claims}

<!-- This specification defines a generic mechanism to add Verified Claims to JSON-based assertions. It uses a container element, called `verified_claims`, to provide the Claims Recipient with a set of Claims along with the respective metadata and verification evidence related to the verification of these Claims. This way, Claims Recipients cannot mix up Verified Claims and unverified Claims and accidentally process unverified Claims as Verified Claims. -->
本仕様は Verified Claim を JSON ベースのアサーションに追加するための汎用的なメカニズムを定義している. これは `verified_claims` と呼ばれるコンテナ要素を使用し, Claims Recipient に一連の Claim と, これらの Claim の検証に関連するそれぞれのメタデータ及び検証のエビデンスを提供することである. これにより, Claims Recipient が Verified Claims と Unverified Claims を混同したり, Unverified Claims を誤って Verified Claims として処理したりすることがなくなる.

<!-- The following example would assert to the Claims Recipient that the Claims Provider has verified the Claims provided (`given_name` and `family_name`) according to an example trust framework `trust_framework_example`: -->
次の例では, トラストフレームワーク `trust_framework_example` の例に従って, Claims Provider が提供された Claim (`given_name` と`family_name`)を検証したことを Claims Recipient に表明する:

<{{examples/response/verified_claims_simple.json}}

<!-- The normative definition is given in the following. -->
基準となる定義を以下に示す．

<!-- `verified_claims`: A single object or an array of objects, each object comprising the following sub-elements: -->
`verified_claims`: 単一のオブジェクトまたはオブジェクトの配列で，各オブジェクトは以下のサブ要素で構成される:

<!--
* `claims`: REQUIRED. Object that is the container for the Verified Claims about the End-User.
* `verification`: REQUIRED. Object that contains data about the verification process.
-->
* `claims`: 必須 (REQUIRED). エンドユーザに関するの検証済 Claim のためのコンテナであるオブジェクト.
* `verification`: 必須 (REQUIRED). 検証プロセスに関するすべてのデータを含むオブジェクト.

<!-- Note: Implementations MUST ignore any sub-element not defined in this specification or extensions of this specification. Extensions to this specification that specify additional sub-elements under the `verified_claims` element MAY be created by the OpenID Foundation, ecosystem or scheme operators or indeed singular implementers using this specification. -->
注: 実装は, この仕様またはこの仕様の拡張で定義されていないサブ要素を無視しなければならない (MUST). `verified_claims` 要素の下に追加のサブ要素を指定するこの仕様の拡張は，OpenID Foundation, エコシステムまたはスキーマのオペレータ，あるいはこの仕様を利用する実際の単一の実装者によって作成されてもよい (MAY)．

<!-- A machine-readable syntax definition of `verified_claims` is given as JSON schema in [@verified_claims.json], it can be used to automatically validate JSON documents containing a `verified_claims` element. The provided JSON schema files are a non-normative implementation of this specification and any discrepancies that exist are either implementation bugs or interpretations. -->
`verified_claims` の機械可読な構文定義は [@verified_claims.json] で JSON スキーマとして提供され，これは `verified_claims` 要素を含む JSON ドキュメントを自動的に検証するために使用できる．提供される JSON スキーマファイルは本仕様の標準ではない実装であり，存在する矛盾は実装のバグか，解釈のいずれかである．

<!-- Extensions of this specification, including trust framework definitions, can define further constraints on the data structure. -->
トラストフレームワークの定義を含む本仕様の拡張は，データ構造に対するさらなる制約を定義できる．

## claims Element {#claimselement}

<!-- The `claims` element contains the Claims about the End-User which were verified by the process and according to the policies determined by the corresponding `verification` element described in the next section. -->
`claims` 要素にはプロセスによって検証され, 次のセクションで説明する，対応した `verification` 要素によって決定されたポリシーに従って検証された End-User についての Claim が含まれる.

<!-- The `claims` element MAY contain any of the following Claims as defined in Section 5.1 of the OpenID Connect specification [@!OpenID] -->
`claims` 要素には OpenID Connect specification [@!OpenID] の Section 5.1 で定義されている以下の Claim のいずれかが含まれるかもしれない (MAY)

* `name`
* `given_name`
* `middle_name`
* `family_name`
* `birthdate`
* `address`

<!-- and the Claims defined in [@OpenID4IDAClaims].-->
また, Claim は[@OpenID4IDAClaims] で定義されている.

<!-- The `claims` element MAY also contain other Claims provided the value of the respective Claim was verified in the verification process represented by the sibling `verification` element. -->
`claims` 要素は, 兄弟要素の `verification` で提示された検証プロセスでそれぞれの Claim の値が検証された場合, 他の Claim も含むかもしれない (MAY).

<!-- Claim names MAY be annotated with language tags as specified in Section 5.2 of the OpenID Connect specification [@!OpenID]. -->
Claim 名は, OpenID Connect 仕様 [@!OpenID] の Section 5.2 で指定されている言語タグで注釈を付けてもよい (MAY).

<!-- The `claims` element MAY be empty, to support use cases where verification is required but no Claims data needs to be shared. -->
`claims` 要素は, 検証は要求されるが共有するClaimを必要としないユースケースをサポートするために, 空になるかもしれない (MAY).

## verification Element {#verification}

<!-- This element contains the information about the process conducted to verify a person's identity and bind the respective person data to a user account. -->
この要素には, 個人の身元を確認し, それぞれの個人データをユーザーアカウントにバインドするために実行されたプロセスに関する情報が含まれる.

<!-- The `verification` element can be used independently of OpenID Connect and OpenID Connect for Identity Assurance where there is a need for representation of identity assurance metadata in a different application protocol or digital identity data format such as [@VerifiableCredentials]. -->
`Verification` 要素は異なるアプリケーションプロトコル又は [@VerifiableCredentials] のようなデジタルアイデンティティデータフォーマットで Identity assurance メタデータの表現が必要な場合, OpenID Connect 及び OpenID Connect for Identity Assurance とは独立して使用できる.

<!-- The `verification` element consists of the following elements: -->
`verification` 要素は以下の要素を含む:

<!--
* `trust_framework`: REQUIRED. String determining the trust framework governing the identity verification process of the Claims Provider.
An example value is `eidas`, which denotes a notified eID system under eIDAS [@eIDAS].
Claims Recipients SHOULD ignore `verified_claims` Claims containing a trust framework identifier they do not understand.
The `trust_framework` value determines what further data is provided to the Claims Recipient in the `verification` element. A notified eID system under eIDAS, for example, would not need to provide any further data whereas an Claims Provider not governed by eIDAS would need to provide verification evidence in order to allow the Claims Recipient to fulfill its legal obligations. An example of the latter is an Claims Provider acting under the German Anti-Money Laundering Law (`de_aml`).

* `assurance_level`: OPTIONAL. String determining the assurance level associated with the End-User Claims in the respective `verified_claims`. The value range depends on the respective `trust_framework` value. For example, the trust framework `eidas` can have the identity assurance levels `low`, `substantial` and `high`. For information on predefined trust framework and assurance level values see [@!predefined_values_page].

* `assurance_process`: OPTIONAL. JSON object representing the assurance process that was followed. This reflects how the evidence meets the requirements of the `trust_framework` and `assurance_level`. The factual record of the evidence and the procedures followed are recorded in the `evidence` element, this element is used to cross reference the `evidence` to the `assurance_process` followed. This has one or more of the following sub-elements:
  * `policy`: OPTIONAL. String representing the standard or policy that was followed.
  * `procedure`: OPTIONAL. String representing a specific procedure from the `policy` that was followed.
  * `assurance_details`: OPTIONAL. JSON array denoting the details about how the evidence complies with the `policy`. When present this array MUST have at least one member. Each member can have the following sub-elements:
     * `assurance_type`: OPTIONAL. String denoting which part of the `assurance_process` the evidence fulfils.
    * `assurance_classification`: OPTIONAL. String reflecting how the `evidence` has been classified or measured as required by the `trust_framework`.
    * `evidence_ref`: OPTIONAL. JSON array of the evidence being referred to. When present this array MUST have at least one member.
      * `check_id`: REQUIRED. Identifier referring to the `check_id` key used in the `check_details` element of members of the `evidence` array. The Claims Provider MUST ensure that `check_id` is present in the `check_details` when `evidence_ref` element is used.
      * `evidence_metadata`: OPTIONAL. Object indicating any meta data about the `evidence` that is required by the `assurance_process` in order to demonstrate compliance with the `trust_framework`. It has the following sub-elements:
        * `evidence_classification`: OPTIONAL. String indicating how the process demonstrated by the `check_details` for the `evidence` is classified by the `assurance_process` in order to demonstrate compliance with the `trust_framework`.

* `time`: OPTIONAL. Time stamp in ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date and time when the identity verification process took place. This time might deviate from (a potentially also present) `document/time` element since the latter represents the time when a certain evidence was checked whereas this element represents the time when the process was completed. Moreover, the overall verification process and evidence verification can be conducted by different parties (see `document/verifier`). Presence of this element might be required for certain trust frameworks.

* `verification_process`: OPTIONAL. Unique reference to the identity verification process as performed by the Claims Provider. Used for identifying and retrieving details in case of disputes or audits. Presence of this element might be required for certain trust frameworks.

* `evidence`: OPTIONAL. JSON array containing information about the evidence the Claims Provider used to verify the End-User's identity as separate JSON objects. Every object contains the property `type` which determines the type of the evidence. The Claims Recipient uses this information to process the `evidence` property appropriately.
-->
* `trust_framework`: 必須 (REQUIRED). OP の identity verification プロセスを管理する trust framework を定める文字列.
例としては `eidas` で, これは eIDAS [@?eIDAS] 公認 eID システムを示す.
Claims Recipients は理解できないトラストフレームワーク識別子を含む `verified_claims` Claim を無視しなければならない (SHOULD)．
`trust_framework` は, `verification` 要素の中で Claims Recipient に提供される追加のデータを決定する. たとえば, eIDAS 公認 eID システムは, データを追加する必要はないが, eIDAS に管理されていない Claims Provider は Claims Recipient が法的義務を果たすために verification evidence を提供する必要がある. 後者の例としては, ドイツのマネーロンダリング防止法 (`de_aml`) に基づいて行動する Claims Provider である.

* `assurance_level`: OPTIONAL. それぞれの `verified_claims` のEnd-User Claimに関連付けられた assurance レベルを決定する文字列. 値の範囲は，それぞれの `trust_framework` 値によって異なる.例えば，トラストフレームワーク `eidas` は，identity assurance level `low`, `substantial` と `high` を持つことができる．事前定義されたトラストフレームワークと assurance level については [@!predefined_values_page] を参照すること. 

* `assurance_process`: OPTIONAL. 実行された保証プロセスを表す JSON オブジェクト．これはエビデンスが `trust_framework` and `assurance_level`の要件をどのように満たしているかを反映する．エビデンスの事実記録と従った手順は `evidence` 要素に記録され，この要素は `evidence` と `assurance_process` を相互参照するために利用される．これには次の1つ以上のサブ要素がある:
  * `policy`: OPTIONAL. 準拠した標準またはポリシーを表す文字列．
  * `procedure`: OPTIONAL. 準拠した `policy` からの特定の手順を表す文字列．
  * `assurance_details`: OPTIONAL. エビデンスが `policy` にどのように準拠しているかに関する詳細を示す JSON 配列. この配列が存在する場合, 少なくとも一つの要素を持たなければならない. 各要素は以下のサブ要素を持つ可能性がある:
     * `assurance_type`: OPTIONAL. エビデンスが `assurance_process` のどの部分を満たしているのかを示す文字列.
    * `assurance_classification`: OPTIONAL. `trust_framework`　の要求に応じて `evidence` がどのように分類又は評価されたのか反映する文字列.
    * `evidence_ref`: OPTIONAL. 参照されているエビデンスの JSON 配列. この配列が存在する場合, 少なくとも一つの要素が存在しなければならない (MUST).
      * `check_id`: REQUIRED. `evidence` 配列の要素である `check_details` で用いられる `check_id` キーを参照する識別子. Claim Provider は, `evidence_ref` が用いられる場合, `check_id` が `check_details` に存在することを確認しなければならない (MUST).
      * `evidence_metadata`: OPTIONAL. `trust_framework` への準拠を示すために, `assurance_process` が必要とする `evidence` についてのメタデータを指すオブジェクト. 次のサブ要素を持つ:
        * `evidence_classification`: OPTIONAL. `trust_framework` への準拠を示すために, `evidence` の `check_details` で示されたプロセスがどのように `assurance_process` によって分類されるのか示すオブジェクト.

* `time`: OPTIONAL. Identity verification が行われた日時を示す ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．この時間は, (潜在的に存在する) `document/time` 要素とは異なるかもしれない．なぜなら，後者はあるエビデンスがチェックされた時間を表すのに対し，この要素はプロセスが完了した時間を表すためである．さらに，全体の verification プロセスとエビデンスの検証は，異なる当事者が行うことができる（`document/verifier` を参照）．特定のトラストフレームワークでは，この要素の存在が要求される場合がある．

* `verification_process`: OPTIONAL. Claims Provider が実行する identity verification process への一意な参照．紛争や監査の際に詳細を識別して取り出すために使用される．特定のトラストフレームワークでは，この要素の存在が要求される場合がある．

* `evidence`: OPTIONAL. End-User の identity を確認するために Claims Provider が使用したエビデンスに関する情報を個別の JSON オブジェクトとして含む JSON 配列．すべてのオブジェクトには，エビデンスの種類を決めるプロパティ `type` が含まれる．Claims Recipient は `evidence` プロパティを適切に処理するためにこの情報を使用する．

<!-- Important: Implementations MUST ignore any sub-element not defined in this specification or extensions of this specification. -->
重要: 実装は本仕様または本仕様の拡張で定義されていないサブ要素を無視しなければならない (MUST)．

### Minimum conformant

<!-- Based on the definition above and that there are a significant number of optional sub-elements it is informative to show a minimum conformant `verified_claims` payload.  There can be optionally much more detail included in an openid-ida-verified-claims conformant `verified_claims` element when further detail needs to be transferred. The example is not normative. -->
上記の定義及び相当数の任意のサブ要素が存在することに基づき, 最低限の適合性を持つ`verified_claims` のペイロードを示すことは有益である. さらに詳細な内容を転送する必要がある場合は, openid-ida-verified-claims に準拠した`verified_claims` 要素を, さらに任意で詳細に含めることができる. この例は規範的なものではない.

<{{examples/response/ida_minimum.json}}

### evidence Element {#evidence_element}

<!-- Members of the `evidence` array are structured with the following elements: -->
`evidence` 配列の要素は, 次の要素で構成されている:

<!-- `type`: REQUIRED. The value defines the type of the evidence. -->
`type`: REQUIRED. エビデンスのタイプを定義する値．

<!-- The following types of evidence are defined: -->
以下のエビデンスのタイプが定義されている:

<!--
* `document`: Verification based on the content of a physical or electronic document provided by the End-User, e.g. a passport, ID card, PDF signed by a recognized authority, etc.
* `electronic_record`: Verification based on data or information obtained electronically from an approved, recognized, regulated or certified source, e.g. a Government organization, bank, utility provider, credit reference agency, etc.
* `vouch`: Verification based on an attestation given by an approved or recognized natural person declaring they believe that the Claim(s) presented by the End-User are, to the best of their knowledge, genuine and true.
* `electronic_signature`: Verification based on the use of an electronic signature that can be uniquely linked to the End-User and is capable of identifying the signatory, e.g. an eIDAS Advanced Electronic Signature (AES) or Qualified Electronic Signature (QES).
-->
* `document`: End-User から提供されたパスポート，ID カード，公的機関が署名した PDF など，物理的または電子的文章に基づく検証．
* `electronic_record`: 政府機関，銀行，公共事業者，信用調査機関など，承認，認知，規制，または認定されたソースから電子的に取得したデータまたは情報に基づく検証．
* `vouch`: 承認または認知された自然人が，Claim(s) が正規かつ真実であると彼らの知る限り信じていることを宣言することによって与えられた証明に基づく検証．
* `electronic_signature`: End-User に一意にリンク可能で, かつ署名者を識別できる電子署名の使用に基づく Verification. eIDAS 高度電子署名 (AES) または適格電子署名 (QES).

<!-- `attachments`: OPTIONAL. Array of JSON objects representing attachments like photocopies of documents or certificates. Structure of members of the `attachments` array is described in [@!Attachments]. -->
`attachments`: OPTIONAL. ドキュメントや証明書のコピーなどの添付ファイルを表す JSON オブジェクトの配列． Structure of members of the `attachments` array is described in [@!Attachments].

<!-- Depending on the evidence type additional elements are defined, as described in the following. -->
エビデンスの種類に応じて，以下で説明するように追加の要素が定義される．
#### Evidence Type `document`

<!-- The following elements are contained in an evidence sub-element where type is `document`. -->
以下の要素は，タイプが `document` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to `document`. -->
`type`: REQUIRED. 値は `document` に設定しなければならない (MUST).

<!-- `check_details`: OPTIONAL. JSON array representing the checks done in relation to the `evidence`. When present this array MUST have at least one member. -->
`check_details`: OPTIONAL. `evidence` に関連して行われたチェックを表す JSON 配列．この配列が存在する場合，少なくとも1つのメンバがなければならない (MUST)．

<!--
  * `check_method`: REQUIRED. String representing the check done, this includes processes such as checking the authenticity of the document, or verifying the user's biometric against an identity document. For information on predefined `check_details` values see [@!predefined_values_page].
  * `organization`: OPTIONAL. String denoting the legal entity that performed the check. This SHOULD be included if the Claims Provider did not perform the check itself.
  * `check_id`: OPTIONAL. Identifier referring to the event where a check (either verification or validation) was performed. The Claims Provider MUST ensure that this is present when `evidence_ref` element is used. The Claims Provider MUST ensure that the transaction identifier can be resolved into transaction details during an audit.
  * `time`: OPTIONAL. Time stamp in ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date when the check was completed.
-->
  * `check_method`: REQUIRED. 完了したチェックを表す文字列で，これにはドキュメントの信頼性の確認や，ユーザーの生体認証を identity document と照合するなどのプロセスが含まれる．事前定義された `check_details` 値の詳細については，[@!predefined_values_page] 参照．
  * `organization`: OPTIONAL. チェックを実行した法人を示す文字列．Claims Provider 自身がチェックを実行していない場合，これを含むべきである (SHOULD)．
  * `check_id`: OPTIONAL. チェック (verification または validation) が実行されたイベントを参照する識別子．Claims Provider は `evidence_ref` 要素が使用されるときにこれが存在することを保証しなければならない (MUST)．Claims Provider は監査中にトランザクション識別子をトランザクションの詳細に解決できることを確認しなければならない (MUST)．
  * `time`: OPTIONAL. チェックが完了した日付を表す ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．

<!-- `document_details`: OPTIONAL. JSON object representing the document used to perform the identity verification. It consists of the following properties: -->
`document_details`: OPTIONAL. identity verification の実行に使用されたドキュメントを表す JSON オブジェクト．これは以下のプロパティで構成される:

<!--
* `type`: REQUIRED. String denoting the type of the document. For information on predefined document values see [@!predefined_values_page]. The Claims Provider MAY use other predefined values in which case the Claims Recipients will either be unable to process the assertion, just store this value for audit purposes, or apply bespoke business logic to it.
* `document_number`: OPTIONAL. String representing an identifier/number that uniquely identifies a document that was issued to the End-User. This is used on one document and will change if it is reissued, e.g., a passport number, certificate number, etc.
* `serial_number`: OPTIONAL. String representing an identifier/number that identifies the document irrespective of any personalization information (this usually only applies to physical artifacts and is present before personalization).
* `date_of_issuance`: OPTIONAL. The date the document was issued as ISO 8601 [@!ISO8601] `YYYY-MM-DD` format.
* `date_of_expiry`: OPTIONAL. The date the document will expire as ISO 8601 [@!ISO8601] `YYYY-MM-DD` format.
* `issuer`: OPTIONAL. JSON object containing information about the issuer of this document. This object consists of the following properties:
    * `name`: OPTIONAL. Designation of the issuer of the document.
    * All elements of the OpenID Connect `address` Claim (see [@!OpenID])
    * `country_code`: OPTIONAL. String denoting the country or supranational organization that issued the document as ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303], e.g., "USA" or "JPN". 2-letter ICAO codes MAY be used in some circumstances for compatibility reasons.
    * `jurisdiction`: OPTIONAL. String containing the name of the region(s)/state(s)/province(s)/municipality(ies) that issuer has jurisdiction over (if this information is not common knowledge or derivable from the address).
-->
* `type`: REQUIRED. ドキュメントのタイプを表す文字列．事前定義されたドキュメント値については [@!predefined_values_page] 参照. Claims Provider は Claims Recipients がアサーションを処理できないか，監査目的でこの値を保存するか，特注のビジネスロジックを適用する場合，事前定義された値以外を使用してもよい (MAY).
* `document_number`: OPTIONAL. エンドユーザーに発行されたドキュメントを一意に識別する識別子/番号を表す文字列．これはパスポート番号や証明書番号などのように，1つのドキュメントで利用され，再発行されると変更される．
* `personal_number`: OPTIONAL. 国民識別番号，個人識別番号，市民番号，社会保障番号，運転免許証番号，口座番号，顧客番号，ライセンシー番号のような，エンドユーザーに割り当てられ，1つのドキュメントで使用されることに限定されない識別子を表す文字列．
* `serial_number`: OPTIONAL. パーソナライズ情報に関係なくドキュメントを識別する識別子/番号を表す文字列 (これは通常，物理的中間生成物にのみ適用され，パーソナライゼーションの前に存在する).
* `date_of_issuance`: OPTIONAL. ISO 8601 [@!ISO8601] `YYYY-MM-DD` 形式で表す，ドキュメントの発行された日付.
* `date_of_expiry`: OPTIONAL. ISO 8601 [@!ISO8601] `YYYY-MM-DD` 形式で表す，ドキュメントの有効期限の日付.
* `issuer`: OPTIONAL. ドキュメントの発行者に関する情報を含む JSON オブジェクト．このオブジェクトは下記のプロパティで構成される:
    * `name`: OPTIONAL. ドキュメントの発行者を指定する．
    * OpenID Connect `address` Claim (see [@!OpenID]) のすべての要素
    * `country_code`: OPTIONAL. "USA" や "JPN" のような ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303] で，ドキュメントを発行した国や超国家組織を表す文字列．状況によっては，互換性の理由から 2-letter ICAO codes が使用されるかもしれない (MAY)．
    * `jurisdiction`: OPTIONAL. 発行者が管轄する地域/州/件/市町村の名前を含む文字列 (この情報が一般的な知識でないか，住所から導き出せない場合)．

<!-- * `derived_claims`: OPTIONAL. JSON object containing Claims about the End-User which were derived from the document described in the evidence array member it is part of. When used the `derived_claims` element has the following conditions:
    * The `derived_claims` element MAY contain any of the Claims defined in Section 5.1 of the OpenID Connect specification [@!OpenID] and the Claims defined in [@OpenID4IDAClaims].
    * The `derived_claims` element MAY also contain other End-User Claims (not defined in the OpenID Connect specification [@!OpenID] nor in [@OpenID4IDAClaims]) derived from the document described in the evidence array member it is part of.
    * End-User Claims contained in a `derived_claims` element MUST have corresponding Claims in the `claims` element of `verified_claims`.
    * When the `derived_claims` element is used it SHOULD be present in all members of the `evidence` array and all Claims under the `claims` element of `verified_claims` SHOULD have a corresponding Claim in at least one `derived_claims` element.
    * Claim names MAY be annotated with language tags as specified in Section 5.2 of the OpenID Connect specification [@!OpenID].
    * When it is present the `derived_claims` element MUST NOT be empty. -->
 
* `derived_claims`: OPTIONAL. evidence 配列のメンバーの一部として記述された, ドキュメントに由来する End-User に関する Claim を含む JSON オブジェクト. `derived_claims` 要素を使用する場合, 次の条件が存在する:
    * `derived_claims` 要素は, OpenID Connect の仕様 [@!OpenID] または [@OpenID4IDAClaims] で定義される Claim のいずれかを含めることができる(MAY).
    * `derived_claims` 要素は, evidence 配列のメンバーの一部として記述された, ドキュメントに由来する (OpenID Connect の仕様[@!OpenID] でも[@OpenID4IDAClaims] でも定義されていない) 他の End-User に関する Claim を含めることもできる(MAY).
    * `derived_claims` 要素に含まれるEnd-User Claim は, `verified_claims` の `claims` 要素に対応する Claim を持たなければならない(MUST).
    * `derived_claims` 要素が使用される場合, `evidence` 配列の全ての要素が存在している必要があり, `verified_claims` の`claims` 要素の下にあるすべての Claim は少なくとも一つの `derived_claims` に対応する Claim を持っている必要がある (SHOULD).
    * Claim 名には, OpenID Connect の仕様 [@!OpenID] のセクション5.2で指定されているように, 言語タグの注釈をつけることができる(MAY).
    * `derived_claims` 要素が存在する場合, 空欄になってはならない(MUST).

#### Evidence Type `electronic_record`

<!-- The following elements are contained in an evidence sub-element where type is `electronic_record`. -->
以下の要素は，タイプが `electronic_record` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to `electronic_record`. -->
`type`: REQUIRED. 値は `electronic_record` に設定しなければならない (MUST).

<!-- `check_details`: OPTIONAL. JSON array representing the checks done in relation to the `evidence`. -->
`check_details`: OPTIONAL. `evidence` に関連して行われたチェックを表す JSON 配列．

<!--
  * `check_method`: REQUIRED. String representing the check done. For information on predefined `check_method` values see [@!predefined_values_page].
  * `organization`: OPTIONAL. String denoting the legal entity that performed the check. This SHOULD be included if the Claims Provider did not perform the check itself.
  * `check_id`: OPTIONAL. Identifier referring to the event where a check (either verification or validation) was performed. The Claims Provider MUST ensure that this is present when `evidence_ref` element is used. The Claims Provider MUST ensure that the transaction identifier can be resolved into transaction details during an audit.
  * `time`: OPTIONAL. Time stamp in ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date when the check was completed.
-->
  * `check_method`: REQUIRED. 完了したチェックを表す文字列．事前定義された `check_method` 値については [@!predefined_values_page] 参照．
  * `organization`: OPTIONAL. チェックを実行した法人を示す文字列．Claims Provider 自身がチェックを実行していない場合，これを含むべきである (SHOULD)．
  * `check_id`: OPTIONAL. チェック (verification または validation) が実行されたイベントを参照する識別子．Claims Provider は `evidence_ref` 要素が使用されるときにこれが存在することを保証しなければならない (MUST)．Claims Provider は監査中にトランザクション識別子をトランザクションの詳細に解決できることを確認しなければならない (MUST)．
  * `time`: OPTIONAL. チェックが完了した日付を表す ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．

<!-- `record`: OPTIONAL. JSON object representing the record used to perform the identity verification. It consists of the following properties: -->
`record`: OPTIONAL. identity verification の実行に使用されたレコードを表す JSON オブジェクト．これは以下のプロパティで構成される:

<!--
* `type`: REQUIRED. String denoting the type of electronic record. For information on predefined identity evidence values see [@!predefined_values_page]. The Claims Provider MAY use other predefined values in which case the Claims Recipients will either be unable to process the assertion, just store this value for audit purposes, or apply bespoke business logic to it.
* `created_at`: OPTIONAL. The time the record was created as ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` format.
* `date_of_expiry`: OPTIONAL. The date the evidence will expire as ISO 8601 [@!ISO8601] `YYYY-MM-DD` format.
* `source`: OPTIONAL. JSON object containing information about the source of this record. This object consists of the following properties:
    * `name`: OPTIONAL. Designation of the source of the electronic_record.
    * All elements of the OpenID Connect `address` Claim (see [@!OpenID]): OPTIONAL.
    * `country_code`: OPTIONAL. String denoting the country or supranational organization that issued the evidence as ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303], e.g., "USA" or "JPN". 2-letter ICAO codes MAY be used in some circumstances for compatibility reasons.
    * `jurisdiction`: OPTIONAL. String containing the name of the region(s) / state(s) / province(s) / municipality(ies) that source has jurisdiction over (if it is not common knowledge or derivable from the address).
* `derived_claims`: OPTIONAL. JSON object containing Claims about the End-User which were derived from the electronic record described in the evidence array member it is part of.
    * The `derived_claims` element MAY contain any of the Claims defined in Section 5.1 of the OpenID Connect specification [@!OpenID] and the Claims defined in [@OpenID4IDAClaims].
    * The `derived_claims` element MAY also contain other End-User Claims (not defined in the OpenID Connect specification [@!OpenID] nor in [@OpenID4IDAClaims]) derived from the electronic record described in the evidence array member it is part of.
    * Claim names MAY be annotated with language tags as specified in Section 5.2 of the OpenID Connect specification [@!OpenID].
    * When it is present the `derived_claims` element MUST NOT be empty.
-->
* `type`: REQUIRED. 電子記録のタイプを表す文字列．事前定義された identity エビデンス値については [@!predefined_values_page] 参照. Claims Provider は Claims Recipients がアサーションを処理できないか，監査目的でこの値を保存するか，特注のビジネスロジックを適用する場合，事前定義された値以外を使用してもよい (MAY).
* `created_at`: OPTIONAL. ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` 形式で表す，レコードの作成された日付.
* `date_of_expiry`: OPTIONAL. ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` 形式で表す，ドキュメントの有効期限の日付.
* `source`: OPTIONAL. レコードのソースに関する情報を含む JSON オブジェクト．このオブジェクトは下記のプロパティで構成される:
    * `name`: OPTIONAL. electronic_record のソースの指定.
    * OpenID Connect `address` Claim (see [@!OpenID]) のすべての要素: OPTIONAL.
    * `country_code`: OPTIONAL. "USA" や "JPN" のような ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303] で，エビデンスを発行した国や超国家組織を表す文字列．状況によっては，互換性の理由から 2-letter ICAO codes が使用されるかもしれない (MAY)．
    * `jurisdiction`: OPTIONAL. ソースが管轄する地域/州/件/市町村の名前を含む文字列 (一般的な知識でないか，住所から導き出せない場合)．
* `derived_claims`: OPTIONAL. evidence 配列のメンバーの一部として記述された, 電子記録に由来する End-User に関する Claim を含む JSON オブジェクト.
    * `derived_claims` 要素は, OpenID Connect の仕様[@!OpenID] または[@OpenID4IDAClaims] で定義されるClaim のいずれかを含めることができる(MAY).
    * `derived_claims` 要素は, evidence 配列のメンバーの一部として記述された, 電子記録に由来する (OpenID Connect の仕様[@!OpenID] でも[@OpenID4IDAClaims] でも定義されていない) 他の End-User に関する Claim を含めることができる (MAY).
    * Claim 名には, OpenID Connect の仕様[@!OpenID] のセクション5.2で指定されているように, 言語タグの注釈をつけることができる(MAY).
    * `derived_claims` 要素が存在する場合, 空欄になってはならない(MUST).

#### Evidence Type `vouch`

<!-- The following elements are contained in an evidence sub-element where type is `vouch`. -->
以下の要素は，タイプが `vouch` であるエビデンス サブ要素に含まれる．

<!-- `type`: REQUIRED. Value MUST be set to `vouch`. -->
`type`: REQUIRED. 値は `vouch` に設定しなければならない (MUST).

<!-- `check_details`: OPTIONAL. JSON array representing the checks done in relation to the `vouch`. -->
`check_details`: OPTIONAL. `vouch` に関連して行われたチェックを表す JSON 配列．

<!--
  * `check_method`: REQUIRED. String representing the check done, this includes processes such as checking the authenticity of the vouch, or verifing the user as the person referenced in the vouch. For information on predefined `check_method` values see [@!predefined_values_page].
  * `organization`: OPTIONAL. String denoting the legal entity that performed the check. This SHOULD be included if the Claims Provider did not perform the check itself.
  * `check_id`: OPTIONAL. Identifier referring to the event where a check (either verification or validation) was performed. The Claims Provider MUST ensure that this is present when `evidence_ref` element is used. The Claims Provider MUST ensure that the transaction identifier can be resolved into transaction details during an audit.
  * `time`: OPTIONAL. Time stamp in ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` format representing the date when the check was completed.
-->
  * `check_method`: REQUIRED. 完了したチェックを表す文字列で，これには vouch の信頼性の確認や，ユーザーが vouch で参照されている自分つであるかどうかの確認などのプロセスが含まれる．事前定義された `check_details` 値の詳細については，[@!predefined_values_page] 参照．
  * `organization`: OPTIONAL. チェックを実行した法人を示す文字列．Claims Provider 自身がチェックを実行していない場合，これを含むべきである (SHOULD)．
  * `check_id`: OPTIONAL. チェック (verification または validation) が実行されたイベントを参照する識別子．Claims Provider は `evidence_ref` 要素が使用されるときにこれが存在することを保証しなければならない (MUST)．Claims Provider は監査中にトランザクション識別子をトランザクションの詳細に解決できることを確認しなければならない (MUST)．
  * `time`: OPTIONAL. チェックが完了した日付を表す ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` フォーマットのタイムスタンプ．

<!-- `attestation`: OPTIONAL. JSON object representing the attestation that is the basis of the vouch. It consists of the following properties: -->
`attestation`: OPTIONAL. 証拠の基礎となるアテステーションを表す JSON オブジェクト．これは以下のプロパティで構成される:

<!--
* `type`: REQUIRED. String denoting the type of vouch. For information on predefined vouch values see [@!predefined_values_page]. The Claims Provider MAY use other than the predefined values in which case the Claims Recipients will either be unable to process the assertion, just store this value for audit purposes, or apply bespoke business logic to it.
* `reference_number`: OPTIONAL. String representing an identifier/number that uniquely identifies a vouch given about the End-User.
* `date_of_issuance`: OPTIONAL. The date the vouch was made as ISO 8601 [@!ISO8601] `YYYY-MM-DD` format.
* `date_of_expiry`: OPTIONAL. The date the evidence will expire as ISO 8601 [@!ISO8601] `YYYY-MM-DD` format.
* `voucher`: OPTIONAL. JSON object containing information about the entity giving the vouch. This object consists of the following properties:
    * `name`: OPTIONAL. String containing the name of the person giving the vouch/reference in the same format as defined in Section 5.1 (Standard Claims) of the OpenID Connect Core specification.
    * `birthdate`: OPTIONAL. String containing the birthdate of the person giving the vouch/reference in the same format as defined in Section 5.1 (Standard Claims) of the OpenID Connect Core specification.
    * All elements of the OpenID Connect `address` Claim (see [@!OpenID]): OPTIONAL.
    * `country_code`: OPTIONAL. String denoting the country or supranational organization that issued the evidence as ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303], e.g., "USA" or "JPN". 2-letter ICAO codes MAY be used in some circumstances for compatibility reasons.
    * `occupation`: OPTIONAL. String containing the occupation or other authority of the person giving the vouch/reference.
    * `organization`: OPTIONAL. String containing the name of the organization the voucher is representing.
* `derived_claims`: OPTIONAL. JSON object containing Claims about the End-User which were derived from the vouch described in the evidence array member it is part of (an example is presented later in this document)
    * The `derived_claims` element MAY contain any of the Claims defined in Section 5.1 of the OpenID Connect specification [@!OpenID] and the Claims defined in [@OpenID4IDAClaims].
    * The `derived_claims` element MAY also contain other End-User Claims (not defined in the OpenID Connect specification [@!OpenID] nor in [@OpenID4IDAClaims]) derived from the vouch described in the evidence array member it is part of.
    * Claim names MAY be annotated with language tags as specified in Section 5.2 of the   OpenID Connect specification [@!OpenID].
    * When it is present the `derived_claims` element MUST NOT be empty.
-->
* `type`: REQUIRED. 証拠のタイプを表す文字列．事前定義された証拠値については [@!predefined_values_page] 参照. Claims Provider は Claims Recipients がアサーションを処理できないか，監査目的でこの値を保存するか，特注のビジネスロジックを適用する場合，事前定義された値以外を使用してもよい (MAY).
* `reference_number`: OPTIONAL. End-User について与えられた証拠を一意に識別する識別子/番号を表す文字列．
* `date_of_issuance`: OPTIONAL. ISO 8601 [@!ISO8601] `YYYY-MM-DD` 形式で表す，vouch が作成されたされた日付.
* `date_of_expiry`: OPTIONAL. ISO 8601 [@!ISO8601] `YYYY-MM-DD` 形式で表す，エビデンスの有効期限の日付.
* `voucher`: OPTIONAL. 証拠を提供するエンティティに関する情報を含む JSON オブジェクト．このオブジェクトは下記のプロパティで構成される:
    * `name`: OPTIONAL. OpenID Connect 仕様の Section 5.1 で定義されているのと同じ形式で，End-User Claim の証拠/参照を提供する人の名前を含む文字列．
    * `birthdate`: OPTIONAL. OpenID Connect 仕様の Section 5.1 で定義されているのと同じ形式で，End-User Claim の証拠/参照を提供する人の誕生日を含む文字列．
    * OpenID Connect `address` Claim (see [@!OpenID]) のすべての要素: OPTIONAL.
    * `country_code`: OPTIONAL. "USA" や "JPN" のような ISO 3166/ICAO 3-letter codes [@!ICAO-Doc9303] で，エビデンスを発行した国や超国家組織を表す文字列．状況によっては，互換性の理由から 2-letter ICAO codes が使用されるかもしれない (MAY)．
    * `occupation`: OPTIONAL. 証拠/参照を与える人の職業または他の権限を含む文字列 .
    * `organization`: OPTIONAL. voucher が表す組織の名前を含む文字列．
* `derived_claims`: OPTIONAL. evidence 配列のメンバーの一部として記述された, vouch に由来する End-User に関する Claim を含む JSON オブジェクト. `derived_claims` 要素を使用する場合, 次の条件が存在する:
    * `derived_claims` 要素は OpenID Connectの仕様 [@!OpenID] のセクション5.1及び[@OpenID4IDAClaims] で定義されたClaim のいずれかを含むことができる(MAY).
    * `derived_claims` 要素は, evidence 配列のメンバーの一部として記述された, vouch に由来する (OpenID Connect の仕様[@!OpenID] でも[@OpenID4IDAClaims] でも定義されていない) 他の End-User に関する Claim も含めることができる(MAY).
    * Claim 名には, OpenID Connect の仕様 [@!OpenID] のセクション5.2で指定されているように, 言語タグの注釈をつけることができる(MAY).
    * `derived_claims` 要素が存在する場合, 空欄になってはならない(MUST).

#### Evidence Type `electronic_signature`

<!-- The following elements are contained in a `electronic_signature` evidence sub-element. -->
以下の要素は，タイプが `electronic_signature` であるエビデンス サブ要素に含まれる．

<!--
* `type`: REQUIRED. Value MUST be set to `electronic_signature`.
* `signature_type`: REQUIRED. String denoting the type of signature used as evidence. The value range might be restricted by the respective trust framework.
* `issuer`: REQUIRED. String denoting the certification authority that issued the signer's certificate.
* `serial_number`: REQUIRED. String containing the serial number of the certificate used to sign.
* `created_at`: OPTIONAL. The time the signature was created as ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` format.
* `derived_claims`: OPTIONAL. JSON object containing Claims about the End-User which were derived from the electronic signature described in the evidence array member it is part of.
    * The `derived_claims` element MAY contain any of the Claims defined in Section 5.1 of the OpenID Connect specification [@!OpenID] and the Claims defined in [@OpenID4IDAClaims].
    * The `derived_claims` element MAY also contain other End-User Claims derived from the electronically signed object described in the evidence array member it is part of, such as elements of an advanced electronic signature described under eIDAS used to uniquely link the signed object to the signatory.
    * Claim names MAY be annotated with language tags as specified in Section 5.2 of the OpenID Connect specification [@!OpenID].
    * When it is present the `derived_claims` element MUST NOT be empty.
-->
* `type`: REQUIRED. 値は `electronic_signature` に設定しなければならない (MUST).
* `signature_type`: REQUIRED. エビデンスとして使用される署名のタイプを表す文字列. 値の範囲は，それぞれのトラストフレームワークによって制限されるかもしれない．
* `issuer`: REQUIRED. 署名者の証明書を発行した認証局を表す文字列.
* `serial_number`: REQUIRED. 署名に使用される証明書のシリアル番号を表す文字列.
* `created_at`: OPTIONAL. ISO 8601 [@!ISO8601] `YYYY-MM-DDThh:mm[:ss]TZD` 形式で表す，署名の作成された日付.
* `derived_claims`: OPTIONAL. evidence 配列のメンバーの一部として記述された, 電子署名に由来する End-User に関する Claim を含む JSON オブジェクト. `derived_claims` 要素を使用する場合, 次の条件が存在する:
    * `derived_claims` 要素は OpenID Connect の仕様 [@!OpenID] のセクション5.1及び[@OpenID4IDAClaims] で定義された Claim のいずれかを含むことができる(MAY).
    * `derived_claims` 要素は署名者に対して署名されたオブジェクトを一意に紐づけるために使用される eIDAS で説明される高度電子署名の要素などの, evidence 配列のメンバーの一部として記述された, 電子的に署名されたオブジェクトに由来する他の End-User に関する Claim も含めることができる(MAY).
    * Claim 名には, OpenID Connect の仕様 [@!OpenID] のセクション5.2で指定されているように, 言語タグの注釈をつけることができる(MAY).
    * `derived_claims` 要素が存在する場合, 空欄になってはならない(MUST).

### Attachments {#attachments}

<!-- During the identity verification process, specific document artifacts may be collected and depending on the trust framework, will be required to be stored for a specific duration. These artifacts can later be reviewed during audits or quality control for example. These artifacts include, but are not limited to: -->
identity verification プロセス中に，特定のドキュメントアーティファクトが収集される場合があり，トラストフレームワークに応じて特定の期間保存する必要がある．これらのアーティファクトは，後で監査や品質管理などの際に確認することができる．これらのアーティファクトには次のものが含まれるが，これらに限定されない:

<!--
* scans of filled and signed forms documenting/certifying the verification process itself,
* scans or photocopies of the documents used to verify the identity of End-Users,
* video recordings of the verification process,
* certificates of electronic signatures.
-->
* 検証プロセス自体を文章化/証明する，記入済みかつ署名済みフォームのスキャン
* End-User の identity を確認するために使用されるドキュメントのスキャンまたは写真コピー
* 検証プロセスのビデオ録画
* 電子署名の証明書

<!-- When supported by the Claims Provider and requested by the Claims Recipient, these elements can be included in the Verified Claims response allowing the Claims Recipient to store these artifacts along with the Verified Claims information. -->
Claims Provider によってサポートされ，Claims Recipient から要求された場合，Claims Recipient が検証済み Claim 情報とともにこれらのアーティファクトを保存できるように，これらの要素を検証済み Claim のレスポンスに含めることができる．

<!-- An attachment is represented by a JSON element.  The definition of attachements and the schema representing them are described in [@Attachments]. -->
添付ファイルは JSON オブジェクト形式で表現される．The definition of attachements and the schema representing them are described in [@Attachments].

## Examples

<!-- This section contains JSON snippets showing further examples of `verified_claims` described in this document. -->
このセクションには, 本ドキュメントで説明されている`verified_claims` の追加の例を示す JSON スニペットが含まれている.

### Framework with assurance level and associated claims

<{{examples/response/eidas.json}}

### Document + utility statement

<{{examples/response/document_and_utility_statement.json}}

### Array of Verified Claims

<{{examples/response/multiple_verified_claims.json}}

### Derived Claims

<{{examples/response/derived_claims_1.json}}

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

<reference anchor="OpenID4IDAClaims" target="http://openid.net/specs/openid-connect-4-ida-claims-1_0.html">
  <front>
    <title>OpenID Connect for Identity Assurance Claims Registration 1.0</title>
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

<reference anchor="Attachments" target="http://openid.net/specs/openid-connect-4-ida-attachments-1_0.html">
  <front>
    <title>OpenID Connect for Identity Assurance Attachments 1.0</title>
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
   <date day="19" month="July" year="2023"/>
  </front>
</reference>

<reference anchor="JSON" target="https://www.rfc-editor.org/rfc/rfc8259">
    <front>
      <title>The JavaScript Object Notation (JSON) Data Interchange Format</title>
      <author>
        <organization abbrev="IETF">Internet Engineering Task Force</organization>
      </author>
      <date year="2017" />
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

<reference anchor="ISO8601" target="http://www.iso.org/iso/catalogue_detail?csnumber=40874">
    <front>
      <title>ISO 8601. Data elements and interchange formats - Information interchange - Representation of dates and times</title>
      <author surname="International Organization for Standardization">
        <organization abbrev="ISO">International Organization for Standardization</organization>
      </author>
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

<reference anchor="eIDAS" target="https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32014R0910">
  <front>
    <title>REGULATION (EU) No 910/2014 OF THE EUROPEAN PARLIAMENT AND OF THE COUNCIL on electronic identification and trust services for electronic transactions in the internal market and repealing Directive 1999/93/EC</title>
    <author initials="" surname="European Parliament">
      <organization>European Parliament</organization>
    </author>
   <date day="23" month="July" year="2014"/>
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

<reference anchor="NIST-SP-800-63a" target="https://doi.org/10.6028/NIST.SP.800-63a">
  <front>
    <title>NIST Special Publication 800-63A, Digital Identity Guidelines, Enrollment and Identity Proofing Requirements</title>
    <author initials="Paul. A." surname="Grassi" fullname="Paul A. Grassi">
      <organization>NIST</organization>
    </author>
    <author initials="James L." surname="Fentony" fullname="James L. Fentony">
      <organization>Altmode Networks</organization>
    </author>
    <author initials="Naomi B." surname="Lefkovitz" fullname="Naomi B. Lefkovitz">
      <organization>NIST</organization>
    </author>
    <author initials="Jamie M." surname="Danker" fullname="Jamie M. Danker">
      <organization>Department of Homeland Security</organization>
    </author>
    <author initials="Yee-Yin" surname="Choong" fullname="Yee-Yin Choong">
      <organization>NIST</organization>
    </author>
    <author initials="Kristen K." surname="Greene" fullname="Kristen K. Greene">
      <organization>NIST</organization>
    </author>
    <author initials="Mary F." surname="Theofanos" fullname="Mary F. Theofanos">
      <organization>NIST</organization>
    </author>
   <date month="June" year="2017"/>
  </front>
</reference>

<reference anchor="predefined_values_page" target="https://openid.net/wg/ekyc-ida/identifiers/">
  <front>
    <title>Overview page for predefined values</title>
    <author>
      <organization>OpenID Foundation</organization>
    </author>
    <date year="2021"/>
  </front>
</reference>

<reference anchor="verified_claims.json" target="https://openid.net/wg/ekyc-ida/references/">
  <front>
    <title>JSON Schema for assertions using verified_claims</title>
    <author>
        <organization>OpenID Foundation</organization>
    </author>
   <date year="2020"/>
  </front>
</reference>

<reference anchor="VerifiableCredentials" target="https://www.w3.org/TR/vc-data-model/">
  <front>
    <title>Verifiable Credentials Data Model v1.1</title>
    <author initials="M" surname="Sporny" fullname="Manu Sporny">
      <organization>Digital Bazaar</organization>
    </author>
    <author initials="D" surname="Longley" fullname="Dave Longley">
      <organization>Digital Bazaar</organization>
    </author>
    <author initials="D" surname="Chadwick" fullname="David Chadwick">
      <organization>Digital Bazaar</organization>
    </author>
   <date month="March" year="2022"/>
  </front>
</reference>

# IANA Considerations

## JSON Web Token Claims Registration

<!-- This specification requests registration of the following value in the IANA "JSON Web Token Claims Registry" established by [@!RFC7519]. -->
この仕様は [@!RFC7519] によって確立された IANA の "JSON Web Token Claims Registry" に次の値を登録することを要求している.

### Registry Contents

#### Claim `verified_claims`

Claim Name:
: `verified_claims`

<!--
Claim Description:
: A structured Claim containing end-user claims and the details of how those end-user claims were assured.
-->
Claim Description:
: End-User Claim とそれらの Claim がどのように保証されているかの詳細を含む構造化された Claim.

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

<!--
Specification Document(s):
: Section [Claims](#claims) of this document
-->
Specification Document(s):
: 本ドキュメントの [Claims](#claims) セクション


# Acknowledgements {#Acknowledgements}

<!--
The following people at yes.com and partner companies contributed to the concept described in the initial contribution to this specification: Karsten Buch, Lukas Stiebig, Sven Manz, Waldemar Zimpfer, Willi Wiedergold, Fabian Hoffmann, Daniel Keijsers, Ralf Wagner, Sebastian Ebling, Peter Eisenhofer.
-->
本仕様の初稿で説明されている概念には, yes.com の次の人々とパートナー企業が貢献した: Karsten Buch, Lukas Stiebig, Sven Manz, Waldemar Zimpfer, Willi Wiedergold, Fabian Hoffmann, Daniel Keijsers, Ralf Wagner, Sebastian Ebling, Peter Eisenhofer.

<!--
We would like to thank Julian White, Bjorn Hjelm, Stephane Mouy, Joseph Heenan, Vladimir Dzhuvinov, Azusa Kikuchi, Naohiro Fujie, Takahiko Kawasaki, Sebastian Ebling, Marcos Sanz, Tom Jones, Mike Pegman, Michael B. Jones, Jeff Lombardo, Taylor Ongaro, Peter Bainbridge-Clayton, Adrian Field, George Fletcher, Tim Cappalli, Michael Palage, Sascha Preibisch, Giuseppe De Marco, Nick Mothershaw, Hodari McClain, Dima Postnikov and Nat Sakimura for their valuable feedback and contributions that helped to evolve this specification.
-->
我々は本仕様の発展の助けとなる, 価値あるフィードバックと貢献をしてくれたJulian White, Bjorn Hjelm, Stephane Mouy, Joseph Heenan, Vladimir Dzhuvinov, Azusa Kikuchi, Naohiro Fujie, Takahiko Kawasaki, Sebastian Ebling, Marcos Sanz, Tom Jones, Mike Pegman, Michael B. Jones, Jeff Lombardo, Taylor Ongaro, Peter Bainbridge-Clayton, Adrian Field, George Fletcher, Tim Cappalli, Michael Palage, Sascha Preibisch, Giuseppe De Marco, Nick Mothershaw, Hodari McClain, Dima Postnikov, Nat Sakimura に感謝する.


# Notices

Copyright (c) 2023 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document History

   [[ To be removed from the final specification ]]


   -00 (WG document)

   *  Split this content from openid-connect-4-identity-assurance-1_0-13 WG document

