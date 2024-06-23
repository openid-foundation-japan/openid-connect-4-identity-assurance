%%%
title = "OpenID Connect for Identity Assurance Claims Registration 1.0 draft"
abbrev = "openid-connect-4-ida-claims-1_0"
ipr = "none"
workgroup = "eKYC-IDA"
keyword = ["security", "openid", "identity assurance", "ekyc", "claims"]

[seriesInfo]
name = "Internet-Draft"

value = "openid-connect-4-ida-claims-1_0-00"

status = "standard"

[[author]]
initials="T."
surname="Lodderstedt"
fullname="Torsten Lodderstedt"
organization="sprind.org"
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

<!-- This specification defines an extension of OpenID Connect that registers new JWT claims about end-users. This extension defines new claims relating to the identity of a natural person that were originally defined within earlier drafts of OpenID Connect for Identity Assurance. The work and the preceding drafts are the work of the eKYC and Identity Assurance working group of the OpenID Foundation. -->
この仕様では, エンドユーザーに関する新しい JWT クレーム を登録するための OpenID Connect の拡張機能を定義する. この拡張は, 元々 OpenID Connect for Identity Assurance の以前のドラフトで定義されていた, 自然人のアイデンティティに関連する新しいクレームを定義している. この取り組み及び以前のドラフトは, OpenID Foundation の eKYC & IDA ワーキンググループの取り組みである.

.# Foreword

The OpenID Foundation (OIDF) promotes, protects and nurtures the OpenID community and technologies. As a non-profit international standardizing body, it is comprised by over 160 participating entities (workgroup participant). The work of preparing implementer drafts and final international standards is carried out through OIDF workgroups in accordance with the OpenID Process. Participants interested in a subject for which a workgroup has been established have the right to be represented in that workgroup. International organizations, governmental and non-governmental, in liaison with OIDF, also take part in the work. OIDF collaborates closely with other standardizing bodies in the related fields.

Final drafts adopted by the Workgroup through consensus are circulated publicly for the public review for 60 days and for the OIDF members for voting. Publication as an OIDF Standard requires approval by at least 50% of the members casting a vote. There is a possibility that some of the elements of this document may be subject to patent rights. OIDF shall not be held responsible for identifying any or all such patent rights.

.# Introduction {#Introduction}

<!-- This specification defines additional JWT claims about the natural person.  The claims defined can be used in various contexts including an ID Token. -->
この仕様では, 自然人に関する追加の JWT クレームを定義する. この定義されたクレームは ID Token を含む様々なコンテキストで使用できる. 

.# Warning
This document is not an OIDF International Standard. It is distributed for
review and comment. It is subject to change without notice and may not be
referred to as an International Standard.
Recipients of this draft are invited to submit, with their comments,
notification of any relevant patent rights of which they are aware and to
provide supporting documentation.

.# Notational conventions

The keywords "shall", "shall not", "should", "should not", "may", and "can" in
this document are to be interpreted as described in ISO Directive Part 2
[@!ISODIR2]. These keywords are not used as dictionary terms such that any
occurrence of them shall be interpreted as keywords and are not to be
interpreted with their natural language meanings.

{mainmatter}

# Scope

<!-- This specification only defines claims to be maintained in the IANA "JSON Web Token Claims Registry" established by [@!RFC7519].  These claims should be used in any context that needs to describe these characteristics of the end-user in a JWT as per [@RFC7519]. -->
この仕様では, [@!RFC7519] によって定義され, IANA によって管理される "JSON Web Token Claims Registry" のみを定義している. これらのクレームは, [@RFC7519] に従い JWT でエンドユーザーの特性を記述する必要があるあらゆるコンテキストで使われるべきである. (SHOULD)

# Normative references

See section 5 for normative references.

# Terms and definitions

For the purposes of this document, the following terms and definitions apply.

## claim
piece of information asserted about an entity

[SOURCE: [@!OpenID], 1.2]

## identity proofing
process in which an end-user provides evidence to an OP or claim provider reliably identifying themselves, thereby allowing the OP or claim provider to assert that identification at a useful assurance level

## identity verification
process conducted by the OP or a claim provider to verify the end-user's identity

## identity assurance
process in which the OP or a claim provider asserts identity data of a certain end-user with a certain assurance towards an RP, typically expressed by way of an assurance level. Depending on legal requirements, the OP can be required to provide evidence of the identity verification process to the RP

## verified claims
claims about an end-user, typically a natural person, whose binding to a particular end-user account was verified in the course of an identity verification process

# Claims {#claims}

## Additional claims about end-users {#userclaims}

<!-- This specification defines the following claims for conveying end-user data in addition to the claims defined in the OpenID Connect specification [@!OpenID] and the OpenID Connect for Identity Assurance specification [@!OpenID4IDA] and in any other context that a JWT (as per [@RFC7519]) may be used: -->
この仕様は, OpenID Connect 仕様[@!OpenID]及び OpenID Connect for Identity Assurance の仕様[@!OpenID4IDA]で定義される Claim に加えて, ([@RFC7519]に従う) JWT が使われるかもしれないあらゆるコンテキストにおいて, エンドユーザーデータを伝達するための次の Claim を定義している.

<!--
| Claim | Type | Description |
|:------|:-----|:------------|
|`place_of_birth`| JSON object | End-user’s place of birth. The value of this member is a JSON structure containing some or all of the following members:|
| | |`country`: String representing country in [@!ISO3166-1] Alpha-2  or [@!ISO3166-3] syntax.|
| | |`region`: String representing state, province, prefecture, or region component. This field might be required in some jurisdictions.|
| | |`locality`: String representing city or locality component.|
|`nationalities`| array | End-user’s nationalities using ICAO 3-letter codes [@!ICAO-Doc9303], 2-letter ICAO codes may be used in some circumstances for compatibility reasons. |
|`birth_family_name`| string | End-user’s family name(s) when they were born, or at least from the time they were a child. This term can be used by a person who changes the family name later in life for any reason. Note that in some cultures, people can have multiple family names or no family name; all can be present, with the names being separated by space characters.|
|`birth_given_name`| string | End-user’s given name(s) when they were born, or at least from the time they were a child. This term can be used by a person who changes the given name later in life for any reason. Note that in some cultures, people can have multiple given names; all can be present, with the names being separated by space characters.|
|`birth_middle_name`| string | End-user’s middle name(s) when they were born, or at least from the time they were a child. This term can be used by a person who changes the middle name later in life for any reason. Note that in some cultures, people can have multiple middle names; all can be present, with the names being separated by space characters. Also note that in some cultures, middle names are not used.|
|`salutation`| string | End-user’s salutation|
|`title`| string | End-user’s title|
|`msisdn`| string | End-user’s mobile phone number formatted according to ITU-T recommendation [@!E.164] |
|`also_known_as`| string | Stage name, religious name or any other type of alias/pseudonym with which a person is known in a specific context besides their legal name.|
-->

| Claim | Type | Description |
|:------|:-----|:------------|
|`place_of_birth`| JSON object | エンドユーザーの出生地. このメンバー値は，次のメンバーの一部またはすべてを含む JSON 構造である:|
| | |`country`: [@!ISO3166-1] Alpha-2 または [@!ISO3166-3] 構文で国を表す文字列. |
| | |`region`: State, province, prefecture, または他の地域コンポーネントを表す文字列. 一部の管轄区域ではこのフィールドは必須かもしれない.|
| | |`locality`: city, または別の地域を表す文字列.|
|`nationalities`| array | ICAO 3-letter codes [@!ICAO-Doc9303] を用いてエンドユーザーの国籍を表す. 互換性の理由から，状況によっては 2-letter ICAO codes が使われるかもしれない.|
|`birth_family_name`| string | エンドユーザーが生まれたとき, あるいは少なくとも子供の時から持っている姓. この用語は人生の途中に何らかの理由で姓を変更した人が利用できる. 一部の文化では，人々は複数の姓を持つことも，姓を持たないこともあることに注意すること．全ての名前はスペース文字で区切って存在する．|
|`birth_given_name`| string | エンドユーザーが生まれたとき, あるいは少なくとも子供の時から持っている名前. この用語は人生の途中に何らかの理由で名前を変更した人が利用できる．一部の文化では，人々は複数の名を持つことに注意すること．全ての名前はスペース文字で区切って存在する．|
|`birth_middle_name`| string | エンドユーザーが生まれたとき, あるいは少なくとも子供の時から持っているミドルネーム. この用語は人生の途中に何らかの理由でミドルネームを変更した人が利用できる.一部の文化では，人々は複数のミドルネームを持つことができることに注意すること．全ての名前はスペース文字で区切って存在する．また，一部の文化ではミドルネームが使用されていないことにも注意すること． |
|`salutation`| string | エンドユーザの敬称． |
|`title`| string | エンドユーザの肩書． |
|`msisdn`| string | ITU-T recommendation [@!E.164] に従って表現されたエンドユーザーの携帯電話番号．|
|`also_known_as`| string | 芸名，宗教名，または実名以外の特定の文脈で人が知られているその他の種類の別名/仮名． |

## Extended address claim

<!-- This specification extends the `address` claim as defined in [@!OpenID] by another sub field containing the country as ISO code. -->
この仕様は，[@!OpenID] で定義されている `address` クレームを，国を ISO コードとして含む別のサブフィールドによって拡張する．

<!-- `country_code`: Optional. country part of an address represented using an ISO 3-letter code [@!ISO3166-3], e.g., "USA" or "JPN". 2-letter ISO codes [@!ISO3166-1] may be used for compatibility reasons. `country_code` may be used as alternative to the existing `country` field. -->
`country_code`: Optional. ISO 3-letter code [@!ISO3166-3]  (例: "USA" や "JPN") を使用して表される住所の国部分．2-letter ISO codes [@!ISO3166-1] は，互換性の理由から使用されるかもしれない (NAY)．`country_code` は，既存の` country` フィールドの代わりに使用してもよい (MAY)．

## Examples

<!-- This section contains JSON snippets showing examples of end-user claims described in this document. -->
このセクションには, このドキュメントで説明される End-User Claim の例を示す, JSON スニペットが含まれている.

```
{
"place_of_birth": {
  "country": "GB",
  "locality": "London"
  }
}
```

```
{
"nationalities": ["GB", "SL"]
}
```

```
{
"birth_family_name": "Elba"
}
```

```
{
"birth_given_name": "Idrissa"
}
```

```
{
"birth_middle_name": "Akuna"
}
```

```
{
"salutation": "Mr"
}
```

```
{
"title": "Dr"
}
```

```
{
"msisdn": "1999550123"
}
```

```
{
"also_known_as": "DJ Big Driis"
}
```

```
"address": {
  "locality": "Leavesden",
  "postal_code": "WD25 7LR",
  "country": "United Kingdom",
  "street_address": "4 Privet Drive",
  "country_code": "GBR"
}
```

{backmatter}

<reference anchor="ISODIR2" target="https://www.iso.org/sites/directives/current/part2/index.xhtml">
<front>
<title>ISO/IEC Directives, Part 2 - Principles and rules for the structure and drafting of ISO and IEC documents</title>
    <author fullname="ISO/IEC">
      <organization>ISO/IEC</organization>
    </author>
</front>
</reference>

<reference anchor="OpenID" target="https://openid.net/specs/openid-connect-core-1_0.html">
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

<reference anchor="OpenID4IDA" target="https://openid.net/specs/openid-connect-4-identity-assurance-1_0.html">
  <front>
    <title>OpenID Connect for Identity Assurance 1.0</title>
    <author initials="T." surname="Lodderstedt" fullname="Torsten Lodderstedt">
      <organization>sprind.org</organization>
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
    <author surname="International Civil Aviation Organization">
      <organization>International Civil Aviation Organization</organization>
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

# IANA considerations

## JSON Web Token claims registration

<!-- This specification requests registration of the following value in the IANA "JSON Web Token Claims Registry" established by [@!RFC7519]. -->
この仕様は [@!RFC7519] によって確立された IANA における "JSON Web Token Claims Registry" に次の値を登録することを要求している.

### Registry contents

#### Claim `place_of_birth`

Claim Name:
: `place_of_birth`

Claim Description:
<!-- : A structured claim representing the end-user’s place of birth. -->
: エンドユーザーの出生地を表現する構造化クレーム

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `nationalities`

Claim Name:
: `nationalities`

Claim Description:
<!-- : String array representing the end-user’s nationalities. -->
: エンドユーザーの国籍を表現する文字列配列

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `birth_family_name`

Claim Name:
: `birth_family_name`

Claim Description:
<!-- : Family name(s) someone has when they were born, or at least from the time they were a child. This term can be used by a person who changes the family name(s) later in life for any reason. Note that in some cultures, people can have multiple family names or no family name; all can be present, with the names being separated by space characters. -->
: 誰かがが生まれたとき, あるいは少なくとも子供の時から持っている姓. この用語は人生の途中に何らかの理由で姓を変更した人が利用できる. 一部の文化では，人々は複数の姓を持つことも，姓を持たないこともあることに注意すること．全ての名前はスペース文字で区切って存在する．

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `birth_given_name`

Claim Name:
: `birth_given_name`

Claim Description:
<!-- : Given name(s) someone has when they were born, or at least from the time they were a child. This term can be used by a person who changes the given name later in life for any reason. Note that in some cultures, people can have multiple given names; all can be present, with the names being separated by space characters. -->
: 誰かが生まれたとき, あるいは少なくとも子供の時から持っている名前. この用語は人生の途中に何らかの理由で名前を変更した人が利用できる．一部の文化では，人々は複数の名を持つことに注意すること．全ての名前はスペース文字で区切って存在する．

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `birth_middle_name`

Claim Name:
: `birth_middle_name`

Claim Description:
<!-- : Middle name(s) someone has when they were born, or at least from the time they were a child. This term can be used by a person who changes the middle name later in life for any reason. Note that in some cultures, people can have multiple middle names; all can be present, with the names being separated by space characters. Also note that in some cultures, middle names are not used. -->
: 誰かが生まれたとき, あるいは少なくとも子供の時から持っているミドルネーム. この用語は人生の途中に何らかの理由でミドルネームを変更した人が利用できる.一部の文化では，人々は複数のミドルネームを持つことができることに注意すること．全ての名前はスペース文字で区切って存在する．また，一部の文化ではミドルネームが使用されていないことにも注意すること．

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `salutation`

Claim Name:
: `salutation`

Claim Description:
<!-- : End-user’s salutation, e.g., “Mr” -->
: エンドユーザーの敬称, 例えば, "Mr"

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `title`

Claim Name:
: `title`

Claim Description:
<!-- : End-user’s title, e.g., “Dr” -->
: エンドユーザーの肩書, 例えば, "Dr"

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `msisdn`

Claim Name:
: `msisdn`

Claim Description:
<!-- : End-user’s mobile phone number formatted according to ITU-T recommendation [@!E.164] -->
: ITU-T勧告[@!E.164] に従ってフォーマットされたエンドユーザーの電話番号.

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

#### Claim `also_known_as`

Claim Name:
: `also_known_as`

Claim Description:
<!-- : Stage name, religious name or any other type of alias/pseudonym with which a person is known in a specific context besides its legal name. -->
: 芸名, 宗教名, または実名以外の特定の文脈で人が知られているその他の種類の別名/仮名.

Change Controller:
: eKYC and Identity Assurance Working Group - openid-specs-ekyc-ida@lists.openid.net

Specification Document(s):
<!-- : Section [Claims](#claims) of this document -->
: このドキュメントの [Claims](#claims) セクション

# Acknowledgements {#Acknowledgements}

<!-- The following people at yes.com and partner companies contributed to the concept described in the initial contribution to this specification: Karsten Buch, Lukas Stiebig, Sven Manz, Waldemar Zimpfer, Willi Wiedergold, Fabian Hoffmann, Daniel Keijsers, Ralf Wagner, Sebastian Ebling, Peter Eisenhofer. -->
この仕様に対する初期の寄稿で説明されている概念は, yes.com とパートナー企業の次の人々の貢献によるものである: Karsten Buch, Lukas Stiebig, Sven Manz, Waldemar Zimpfer, Willi Wiedergold, Fabian Hoffmann, Daniel Keijsers, Ralf Wagner, Sebastian Ebling, Peter Eisenhofer.

<!-- We would like to thank Julian White, Bjorn Hjelm, Stephane Mouy, Alberto Pulido, Joseph Heenan, Vladimir Dzhuvinov, Azusa Kikuchi, Naohiro Fujie, Takahiko Kawasaki, Sebastian Ebling, Marcos Sanz, Tom Jones, Mike Pegman, Michael B. Jones, Jeff Lombardo, Taylor Ongaro, Peter Bainbridge-Clayton, Adrian Field, George Fletcher, Tim Cappalli, Michael Palage, Sascha Preibisch, Giuseppe De Marco, Nick Mothershaw, Hodari McClain, and Nat Sakimura for their valuable feedback and contributions that helped to evolve this specification. -->
我々は, この仕様を進化させる助けとなる, 価値あるフィードバックを与えて貢献してくれた Julian White, Bjorn Hjelm, Stephane Mouy, Alberto Pulido, Joseph Heenan, Vladimir Dzhuvinov, Azusa Kikuchi, Naohiro Fujie, Takahiko Kawasaki, Sebastian Ebling, Marcos Sanz, Tom Jones, Mike Pegman, Michael B. Jones, Jeff Lombardo, Taylor Ongaro, Peter Bainbridge-Clayton, Adrian Field, George Fletcher, Tim Cappalli, Michael Palage, Sascha Preibisch, Giuseppe De Marco, Nick Mothershaw, Hodari McClain, Nat Sakimura に感謝する.

# Notices

Copyright (c) 2024 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document history

   [[ To be removed from the final specification ]]


   -00 (WG document)

   *  Split this content from openid-connect-4-identity-assurance-1_0-13 WG document

# Translator {#translator}

本仕様の翻訳は, OpenID ファウンデーションジャパン [@oidfj] KYC ワーキンググループ [@oidfj-kycwg], 翻訳・教育ワーキンググループ [@oidfj-trans] を主体として, 有志のメンバーによって行われました.
質問や修正依頼などについては, Github レポジトリー [@oidfj-github] にご連絡ください.

* Muneomi Sakuta (SoftBank Corp.)
* Yuu Kikuchi (OPTiM Corp.)
* Nov Matake (YAuth.jp)
* Hitoshi Sakurada (Deloitte Tohmatsu Cyber LLC)
* Shigetatsu Kashiwai (Deloitte Tohmatsu Cyber LLC)
* Takaaki Miyazaki (Deloitte Tohmatsu Cyber LLC)
