%%%
title = "OpenID Connect txn claim 1.0 draft"
abbrev = "openid-connect-txn-claim-1_0"
ipr = "none"
workgroup = "eKYC-IDA"
keyword = ["security", "openid", "identity assurance", "claims"]

[seriesInfo]
name = "Internet-Draft"

value = "openid-connect-txn-claim-1_0-00"

status = "standard"

[[author]]
initials="D."
surname="Postnikov"
fullname="Dima Postnikov"
organization="ConnectID"
    [author.address]
    email = "dima@postnikov.net"

%%%

.# Abstract

<!-- This specification defines an extension of OpenID Connect that defines a use of txn claim. -->
この仕様では, `txn` claim の利用を定義している OpenID の拡張について定義する.

{mainmatter}

# Introduction {#Introduction}

<!-- Strong identity verification typically requires the participants to keep an audit trail of the whole process.
The `txn` Claim as defined in [@!RFC8417] is used in the context of this extension to build audit trails across the parties involved in an OpenID Connect transaction. -->
一般的に, 強固な identity verification は参加者がプロセス全体の監査証跡を保持する必要がある.
[@!RFC8417] で定義されている `txn` Claim はこの拡張のコンテキストで使用され, OpenID Connect トランザクションに関わるの関係者全体の監査証跡を構築する.

# txn request
<!-- The RP requests this Claim like any other Claim via the `claims` parameter or as part of a default claim set identified by a scope value, for example: -->
RPは, Claimと同様に`claims`パラメータを介するか, あるいはスコープ値によって特定されるデフォルトのクレームセットの一部として, このClaimを要求する. 例えば:

```
"txn": null
```

# txn issuance, response and processing

<!-- The OP generates txn claim as a unique identifier, for example: -->
OPは`txn` Claimをユニークな識別子として生成する. 例えば:

```
{
  "txn": "2c6fb585-d51b-465a-9dca-b8cd22a11451"
}
```

<!-- If the OP issues a `txn`, it MUST maintain a corresponding audit trail, which at least consists of the following details: -->
OP が `txn` を発行する場合, 対応する監査証跡を維持する必要があり (MUST), 少なくとも次の詳細で構成される.

<!--
* the transaction ID,
* the transaction date and time,
* the transaction parties,
* the authentication method employed, and
* the transaction details (e.g., the set of Claims returned).
-->
* transaction ID,
* the transaction date and time,
* the transaction parties,
* 採用されている authentication methods, および
* the transaction details (e.g., the set of Claims returned).

<!-- This transaction data MUST be stored as long as it is required to store transaction data for auditing purposes by the respective regulation or ecoysystem governance rules and procedures. -->
このトランザクションデータは, それぞれの規定による監査目的またはエコシステムガバナンスのルールと手順のために，トランザクションデータを保存する必要がある限り保存し続けなければならない (MUST).

<!-- The `txn` value MUST allow an RP to obtain these transaction details if needed. -->
`txn` 値は必要に応じて RP がこれらのトランザクションを参照できるようにしなければならない (MUST).

<!-- Note: The mechanism to obtain the transaction details from the OP and their format is out of scope of this specification. -->
注：トランザクションの詳細を, OP および, それらのフォーマットから取得するメカニズムはこの仕様の範囲外である.

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

# Acknowledgements {#Acknowledgements}

<!-- We would like to thank Mark Haine, Andres Uribe for their valuable feedback and contributions that helped to evolve this specification. -->
我々は, この仕様を進化させる助けとなる, 価値あるフィードバックを与えて貢献してくれた Mark Haine と Andres Uribe に感謝する.

# Notices

Copyright (c) 2023 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document History

   [[ To be removed from the final specification ]]


   -00 (WG document)

   *  New spec

# Translator {#translator}

本仕様の翻訳は, OpenID ファウンデーションジャパン [@oidfj] KYC ワーキンググループ [@oidfj-kycwg], 翻訳・教育ワーキンググループ [@oidfj-trans] を主体として, 有志のメンバーによって行われました.
質問や修正依頼などについては, Github レポジトリー [@oidfj-github] にご連絡ください.

* Muneomi Sakuta (SoftBank Corp.)
* Yuu Kikuchi (OPTiM Corp.)
* Nov Matake (YAuth.jp)
* Hitoshi Sakurada (Deloitte Tohmatsu Cyber LLC)
* Shigetatsu Kashiwai (Deloitte Tohmatsu Cyber LLC)
* Takaaki Miyazaki (Deloitte Tohmatsu Cyber LLC)
