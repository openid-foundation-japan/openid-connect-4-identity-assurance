%%%
title = "OpenID Connect Authority claims extension"
abbrev = "openid-connect-authority-1_0"
ipr = "none"
area = "Identity"
workgroup = "eKYC_IDA"
keyword = ["security", "openid", "authorization", "trust", "legal entity", "authority", "delegate"]

[seriesInfo]
name = "Internet-Draft"

value = "openid-authority-00"

status = "standard"

[[author]]
initials="M."
surname="Haine"
fullname="Mark Haine"
organization="considrd.consulting"
    [author.address]
    email = "mark@considrd.consulting"

[[author]]
initials="J."
surname="White"
fullname="Julian White"
organization="Beruku"
    [author.address]
    email = "julian.white@beruku.com"

%%%

.# Abstract

This document defines an extension of OpenID Connect for providing Relying Parties with verified claims about the relationships between legal persons (humans and other humans or organisations), in a secure way, using OIDC and OAuth 2.0 protocols.  This extension is intended to be used to communicate a relationship between a natural person and another natural person or legal entity in a way that can be relied upon.

{mainmatter}

# Introduction {#Introduction}

Building upon the work done in the OIDF [@!OpenID] eKYC & IDA Working group on verified claims for natural persons there is a need to be able to deliver verified claims about the authority a natural person has to act on behalf of another natural person or legal entity.  As described in Section 1 of the OpenID Connect specification [@!OpenID], OpenID Connect "enables clients to verify the identity of the end-user" This extension will therefore focus on communicating details of a natural person's authority over another natural person or legal entity.

Note: Work to define how direct claims of a legal entity are transferred could use elements of eKYC & IDA specifications such as the structure of the verified_claims element and there are specific claims added as part of this document to enable legal entities to be uniquely defined.

## Terminology

This section defines some terms relevant to the topic covered in this document

> Legal person:
>  - [Cornell Law School](https://www.law.cornell.edu/wex/legal_person) "Legal person refers to a human or non-human entity that is treated as a person for limited legal purposes. Typically, a legal persons can sue and be sued, own property, and enter into contracts."

> Natural person:
>  - [Termly](https://termly.io/legal-dictionary/natural-person/) "A natural person (also sometimes referred to as a physical person) is a title used to identify an individual human being. This is different from a legal person, which can be an individual or a company."

> Legal entity:
>  - [Cambridge dictionary](https://dictionary.cambridge.org/dictionary/english/legal-entity) "a company or organization that has legal rights and responsibilities"
>  - [ISO 17442](https://www.iso.org/standard/75998.html) "legal entities, which include, but are not limited to, unique parties that are legally or financially responsible for the performance of financial transactions or have the legal right in their jurisdiction to enter independently into legal contracts, regardless of whether they are incorporated or constituted in some other way (e.g. trust, partnership, contractual). It includes governmental organizations, supranationals and individuals when acting in a business capacity, but excludes natural persons."
Note: the term "legal entity" is used in this specification to mean an organisation, rather than "legal person", since "legal person" can also refer to a "natural person".

> Authority:
>  - [Britannica Dictionary](https://www.britannica.com/dictionary/authority) "the power or right to direct or control someone or something"
Note: the "someone" for the purposes of this specification is a "natural person", and the "something" is a "legal entity".

This specification uses the terms:
* "Access Token",
* "Authorization Code",
* "Authorization Endpoint",
* "Authorization Grant",
* "Authorization Server",
* "Client",
* "Client Authentication",
* "Client Identifier",
* "Client Secret",
* "Grant Type",
* "Protected Resource",
* "Redirection URI",
* "Refresh Token",
* "Response Type",
* and "Token Endpoint"
defined by [@!RFC6749]

the terms:
* "Claim Name",
* "Claim Value"
* and "JSON Web Token (JWT)"
defined by [@!RFC7519]

the terms:
* "Header Parameter",
* "JOSE Header"
* and "JSON Web Signature (JWS)"
defined by [@!RFC7519]

the term "User Agent" defined by [@!RFC2616]

the terms:
* "Authentication",
* "Authentication Request",
* "Authorization Request",
* "Claim",
* "Claim Type",
* "Claims Provider",
* "Credential",
* "End-User",
* "Entity",
* "ID Token",
* "Identifier",
* "Identity",
* "Issuer",
* "OpenID Provider (OP)",
* "Request Object",
* "Request URI",
* "Relying Party (RP)",
* "UserInfo Endpoint",
* "Validation",
* "Verification"
defined by OpenID Connect [@!OpenID]

This specification also use to the following terms:

OpenID
: References to "openid" in this documentation are about OpenID connect specification [@!OpenID]

# Scope and Requirements

Use cases relating to legal entities and initiated by an end-user relate to "authority to act" where the end-user themselves is authorizing the presentation of the claims.  In one example a director of a company has the authority to act on its behalf.  When communicating data in this example there will be data about the authority including:

* Which entity the authority applies to
* Claims about the entity that has the authority to act
* Claims that define the scope of the authority
* Claims that apply limitations of the authority
* Claims about how the authority is granted

## In Scope Use Cases

There are a number of use cases that were considered when writing this document as detailed below.  However, this document is to deliver a specification for "authority to act" related use cases.

### Get authority of natural person over legal entity
"As a relying party I require specific attributes about the relationship a natural person has to a legal entity and how the details of the relationship were established"

> - Key attributes relating to the natural person e.g.
>   - name
>   - address
>   - date of birth
>   - personal identification number (e.g. social security number)
> - Key attributes relating to the legal entity itself e.g.
>   - company number
>   - registered name
>   - registered address
>   - country of registration
> - The nature of the relationship between natural person and legal entity
>   - The scope of the authority e.g.
>     - shareholder
>     - director
>     - staff member (e.g. regulatory matters, public relations)
>   - Any limitations of the authority e.g.
>     - time (can only use authority on weekdays)
>     - audience (tax authority or accountant)
>     - budget (up to £5000)
>     - functional domain (finance, human resources)
>     - other dependencies (2nd approver)
>   - How the authority was granted
>     - delegated by director as part of job
>     - documented at company register
>     - appointed by legal process (e.g. insolvency court)

This use case is the focus of this document


### Get authority of natural person over another natural person
"As a relying party I require specific attributes about the relationship a natural person has to a another natural person and how the details of the relationship were established"

> - Key attributes relating to the natural person who has the authority e.g.
>   - name
>   - address
>   - date of birth
>   - personal identification number (e.g. social security number)
> - Key attributes relating to the natural person to which the authority applies e.g.
>   - name
>   - address
>   - date of birth
>   - personal identification number (e.g. social security number)
> - The nature of the relationship between the natural persons
>   - The scope of the authority e.g.
>     - financial
>     - medical
>     - familial
>     - legal
>   - Any limitations of the authority e.g.
>     - time (e.g. can only use authority on weekdays)
>     - audience (e.g. tax authority or accountant)
>     - budget (e.g. up to £5000)
>     - other dependencies (e.g. 2nd approver)
>   - How the authority was granted
>     - delegated by the natural person to whom the authority applies to (e.g. giving authority to a spouse to access an account)
>     - appointed by a legal process (e.g. power of attorney)
>     - asserted by a person (e.g. parent of a minor)

This use case is the secondary focus of this document


## Out of Scope Use Cases

### Get details of legal entity
"As a relying party I require specific attributes about a legal entity"

While this use case is important it is not within the scope of this specification as it is not a fit for OpenID Connect due to the fact that OpenID Connect is focussed on claims about the end-user.

### Details of the relationship of legal entity to another legal entity
"As a relying party I require specific attributes about the relationship between two legal entities and how that relationship was established"

While this use case is important it is not within the scope of this specification as it is not a fit for OpenID Connect due to the fact that OpenID Connect is focussed on claims about the end-user.

# Claims

In order to fulfill the requirements of some jurisdictions on identity assurance, this specification defines the following claims for conveying data in addition to the claims defined in the OpenID Connect specification [@!OpenID]:

## Claims about a legal entity

| Claim | Type | Description |
|:------|:-----|:------------|
|`organization_name`|String|Legal entity name|
|`trading_as`|Array|Trading name(s)|
|`registered_address`| JSON object |Registered address. The value of this member is a JSON structure containing Claims as defined in Section 5.1.1 of the OpenID Connect specification [@!OpenID]|
|`registration_number`|String|The unique number that the legal entity is assigned by a Registration Authority when the legal entity is formed|
|`registration_authority_code`|String|Globally unique code for the authority that registered the organisation, from the GLEIF registration authorities list [@!GLEIF-RA]|
|`legal_jurisdiction`|String|The legal jurisdiction that the legal entity is registered in, from the GLEIF legal jurisdiction list [@!GLEIF-LJ]|
|`entity_legal_form`|String|The legal entity form as allowed in the legal jurisdiction (limited, charity, not-for-profit), from the GLEIF Entity Legal Forms list [@!GLEIF-ELF], based on [@!ISO20275]|
|`organization_status`|String|status (active, dormant, closed)|
|`incorporation_date`|String| A reference date in [@!ISO8601-2004] YYYY-MM-DD format that is used to represent the date of incorporation of the legal entity|
|`organization_identifiers`|Array|One or more JSON objects containing identifier type (`identifier_type`, e.g., LEI, DUNS number, BIC code), the legal entity organization identifier (`identifier`, which is unique within the issuer domain) and issuing body (`issuer`) each of which are of type String|

An LEI is a Legal Entity Identifier as defined in [@!ISO17442-1-2020]|


## authority element {#authority}

This specification defines a generic mechanism to allow communication of authority claims via JSON-based assertions. The basic idea is to use a container element, called `authority` to provide the RP with a set of claims that expresses the authority that may exist of one entity over another.
This set of `authority` claims are presented as claims about the end-user and it allows for the use of the sub-elements `applies_to`, `permission`, and `granted_by`.

The following example uses the verified claims structure from the draft eKYC & Identity assurance specification:

<{{examples/response/authority_claims_simple.json}}

This would assert to the RP that the OP has verified the claims provided (`given_name`, `family_name`, `birthdate`, and the `authority` sub-element) according to an example trust framework `authority_claims_example_framework`.

The normative definition is given of the following.

`authority`: Object or array containing one or more authority objects.

A single `authority` object consists of the following sub-elements:

* `applies_to`: Required. Object that contains data about the entity that the authority applies to.
* `permission`: Required. Object that is the container used for defining the actions that the end-user is permitted to take in relation to the entity defined in the `applies_to` sub element of `authority`.
* `granted_by`: Optional. Object that is the container for definition of how the authority was granted to the end-user.

Note: Implementations shall ignore any sub-element not defined in this specification or extensions of this specification.

Note: If not stated otherwise, the sub-elements in `authority` are as defined above. Extensions of this specification, including trust framework definitions, can define further constraints on the data structure by changing `granted_by` from "optional" to "required".

A machine-readable syntax definition of `authority` is given as a JSON schema in [@!authority.json]. It can be used to automatically validate JSON documents containing an `authority` element.

## `applies_to` element

The `applies_to` sub-element is intended to convey claims that allow unique identification of the entity that the authority applies to.  The `applies_to` sub-element contains a number of different claims and those will depend on the particular use case and will, in particular, depend on whether the `applies_to` sub-element is identifying a legal entity or a natural person.

In the case that the authority applies to a legal entity the `applies_to` element may contain one or more of the claims in the 'Claims about a legal entity' section above (and others as required) providing it allows for sufficient confidence that the legal entity can be uniquely identified from that set of claims.

In the case that the authority applies to a natural person the `applies_to` element may contain one or more of the following claims as defined in Section 5.1 of the OpenID Connect specification [@!OpenID] (and others as required) providing it allows for sufficient confidence that the natural person can be uniquely identified from that set of claims:

* `name`
* `given_name`
* `middle_name`
* `family_name`
* `birthdate`
* `address`

## `permission` element

The `permission` sub-element is intended to convey the range of actions that the end-user is allowed to take when acting for the entity identified in the `applies_to` sub-element.

The `permission` sub-element consists of an array of objects that contain the following objects and may contain further objects that describe any additional extensions or restrictions of the authority over the target entity:

* `role`: Required. Object that reflects the role held by the end-user in relation to the target entity, e.g., roles defined by GLEIF based on [@!ISO5009]
* `validity`: Optional. Object that contains an array that shall have either a `start` or `end` and can optionally have both.  Both the `start` and `end` objects are a reference date in [@!ISO8601-2004] YYYY-MM-DD format that is used to represent and are used to define the date limits of the authority being conveyed.
* `budget`: Optional. Object that contains an array that shall have both `value` and `currency` elements. This object is intended to describe the maximum extent of the end-user's financial authority. The `value` object will be a string that includes a decimal point and accurate to two decimal places. The `currency` object will contain the alphabetic format defined in [@!ISO4217-2015] (Currency codes) and defines which financial currency the value is in.
* `audience`: Optional. Limitation of the scope of entity or entities that the end-user communicates with when acting on behalf of the entity defined in the `applies_to` element
* `function`: Optional. Limitation of the scope of action that the end-user takes by functional domain.
* `may_delegate`: Optional. A boolean value that indicates whether the authority or components of the authority can be delegated by the subject to other entities or not.


## `granted_by` element

The `granted_by` sub-element is intended to convey the manner in which the permission came to be associated with the end-user.
The `granted_by` sub-element may contain the claims described below and may contain further objects that describe any additional data about how the authority was vested in the end-user:

* `method`: Required. The `method` claim is a definition of how the authority came to lie with the end-user.  In an implementation there should be a defined set of valid values, these values may include:
 * "delegated": Where a holder of authority passes some or all of their authority on to the end-user. e.g. director of company delegates some authority to a member of staff
 * "appointed": Where a legal authority such as a court of law defined that the authority will be vested in the end-user.  e.g. administrators are appointed by the court to manage a company in difficulties or social services are appointed as guardians of a vulnerable person
 * "self-asserted": Where the end-user themselves has stated that the authority belongs to them.  e.g. the claim of parenthood over a child
* `granting_body`: Optional.  The `granting_body` claim is used to identify the body that vested the authority in the end-user.  e.g. The High Court of London or another member of staff at the end-user's employer that already has the authority and has the authority to delegate that authority.
* `reason`: Optional. The `reason` claim is a description of why the authority was granted to the end-user.

** Question - should there be a chain of authority built or should it just be a summary of the overall grant process? perhaps with clearer definition in the trust framework **

# Requesting authority claims

Making a request for authority claims and related verification data can be explicitly requested on the level of individual data elements by utilizing the `claims` parameter as defined in Section 5.5 of the OpenID Connect specification [@!OpenID].

It is also possible to use the `scope` parameter to request one or more specific predefined claim sets as defined in Section 5.4 of the OpenID Connect specification [@!OpenID].

## Error Handling

The OP has the discretion to decide whether the requested verification data is to be provided to the RP. An OP shall not return an error in case it cannot return a requested verification data, even if it was marked as essential, regardless of the data being unavailable or the end-user not authorizing its release.

# Examples

> Incomplete, insert 'company director, power of attorney idToken & userInfo response examples here


## Responses


### Parent and Child

In this example a parent with the parent/guardian responsibility is represented in the following JSON that would be returned in a UserInfo response.

<{{examples/response/authority_parent_child.json}}

### Company director

### Power of Attorney

### Company Pensions administrator

### Company accountant... ** Chain - person, accountancy firm, client

### Legal counsel

### Official Receiver


## Requests

### Company director

### Power of Attourney

### Executor

### Guardian of child

### Company Pensions administrator

### Company accountant... ** Chain - person, accountancy firm, client

### Legal counsel

### Official Receiver





## Verified Claims in ID Tokens


## UserInfo



# OP Metadata {#opmetadata}

The OP advertises its capabilities with respect to authority Claims in its openid-configuration (see [@!OpenID-Discovery]) using the following new elements:

`authority_claims_supported`: Boolean value indicating support for `authority`, i.e. the OpenID Connect authority claims extension.

`authority_permissions_supported`: JSON array containing all values for the `role` claim utilized by the OP for authority permissions.

`authority_granted_methods_supported`: JSON array containing all values for the `method` claim utilized by the OP for commmunicating how authority was confered.

`authority_claims_supported`: JSON array containing all claims supported within `authority`.

This is an example openid-configuration snippet:

```json
{
...
   "authority_claims_supported":true,
   "authority_permissions_supported":[
     "Director",
     "Finance Officer",
     "Member of Staff"
   ],
   "authority_granted_methods_supported":[
      "delegated",
      "appointed",
      "self-asserted"
   ],
   "documents_supported":[
       "idcard",
       "passport",
       "driving_permit"
   ],
   "document_check_methods_supported":[
       "pipp",
       "sripp",
       "eid"
   ],
   "authority_claims_supported":[
         { "applies_to": [
                "organization_name",
                "registration_number",
                "legal_jurisdiction"
            ]
         },
        { "permission": [
                "role",
                { "validity":[
                    "start",
                    "end"
                    ]
                }
            ],
        }
        { "granted_by": [
                "method",
                "granting_body",
                "reason"
                ]
        }
   ],
...
}
```

The OP shall support the `claims` parameter and needs to publish this in its openid-configuration using the `claims_parameter_supported` element.

# Privacy Consideration {#Privacy}

The use of scopes is a potential shortcut to request a pre-defined set of claims, however, the use of scopes might result in more data being returned to the RP than is strictly necessary and not achieving the goal of data minimisation. The RP should only request end-user claims and metadata it requires.

# Security Considerations {#Security}

This specification focuses on mechanisms to carry end-user claims and accompanying metadata in JSON objects and JSON web tokens, typically as part of an OpenID Connect protocol exchange. Since such an exchange is supposed to take place in security sensitive use cases, implementers shall combine this specification with an appropriate security profile for OpenID Connect.

This specification does not define or require a particular security profile since there are several security
profiles and new security profiles under development. Implementers shall be given flexibility to select the security profile that best suits their needs. Implementers might consider [@?FAPI-1-RW] or [@?FAPI-2-BL].

Implementers should select a security profile that has a certification program
or other resources that allow both OpenID Providers and Relying Parties to ensure they have complied with the profile’s security and
interoperability requirements, such as the OpenID Foundation Certification Program, https://openid.net/certification/.

The integrity and authenticity of the issued assertions shall be ensured in order to prevent identity spoofing.
The claims source shall therefore cryptographically sign all assertions.

The confidentiality of all end-user data exchanged between the protocol parties shall be ensured using suitable
methods at transport or application layer.

# Predefined Values {#predefined_values}

This specification focuses on the technical mechanisms to convey authority claims and thus does not define any identifiers for trust frameworks, id documents, or verification methods. This is left to adopters of the technical specification, e.g. implementers, identity schemes, or jurisdictions.

Each party defining such identifiers shall ensure the collision resistance of those identifiers. This is achieved by including a domain name under the control of this party into the identifier name, e.g. `https://mycompany.com/identifiers/cool_check_method`.

The eKYC and Identity Assurance Working Group maintains a wiki page [@!predefined_values_page] that can be utilized to share predefined values with other parties.

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

<reference anchor="FAPI-1-RW" target="https://bitbucket.org/openid/fapi/src/master/Financial_API_WD_002.md">
  <front>
    <title>Financial-grade API - Part 2: Read and Write API Security Profile</title>
    <author initials="" surname="OpenID Foundation's Financial API (FAPI) Working Group">
      <organization>OpenID Foundation's Financial API (FAPI) Working Group</organization>
    </author>
   <date day="9" month="Sep" year="2020"/>
  </front>
</reference>

<reference anchor="FAPI-2-BL" target="https://bitbucket.org/openid/fapi/src/master/FAPI_2_0_Baseline_Profile.md">
  <front>
    <title>FAPI 2.0 Baseline Profile </title>
    <author initials="" surname="OpenID Foundation's Financial API (FAPI) Working Group">
      <organization>OpenID Foundation's Financial API (FAPI) Working Group</organization>
    </author>
   <date day="9" month="Sep" year="2020"/>
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

<reference anchor="eIDAS" target="https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32014R0910">
  <front>
    <title>REGULATION (EU) No 910/2014 OF THE EUROPEAN PARLIAMENT AND OF THE COUNCIL on electronic identification and trust services for electronic transactions in the internal market and repealing Directive 1999/93/EC</title>
    <author initials="" surname="European Parliament">
      <organization>European Parliament</organization>
    </author>
   <date day="23" month="July" year="2014"/>
  </front>
</reference>

<reference anchor="FATF-Digital-Identity" target="https://www.fatf-gafi.org/media/fatf/documents/recommendations/Guidance-on-Digital-Identity.pdf">
  <front>
    <title>Guidance on Digital Identity</title>
    <author initials="" surname="FATF">
      <organization>Financial Action Task Force (FATF)</organization>
    </author>
   <date month="March" year="2020"/>
  </front>
</reference>

<reference anchor="JPAML" target="https://elaws.e-gov.go.jp/document?lawid=419AC0000000022_20211122_503AC0000000046">
  <front>
    <title>Act on Prevention of Transfer of Criminal Proceeds</title>
    <author surname="Japanese Parliament">
      <organization>Japanese Parliament</organization>
    </author>
   <date day="1" month="October" year="2016"/>
  </front>
</reference>

<reference anchor="GLEIF-RA" target="https://www.gleif.org/en/about-lei/code-lists/gleif-registration-authorities-list#">
  <front>
    <title>GLEIF Registration Authorities</title>
    <author surname="GLEIF">
      <organization>Global Legal Entity Identifier Foundation</organization>
    </author>
   <date year="2022"/>
  </front>
</reference>

<reference anchor="GLEIF-LJ" target="https://www.gleif.org/en/about-lei/code-lists/gleif-accepted-legal-jurisdictions-code-list#">
  <front>
    <title>GLEIF Legal Jurisdictions</title>
    <author surname="GLEIF">
      <organization>Global Legal Entity Identifier Foundation</organization>
    </author>
   <date year="2022"/>
  </front>
</reference>

<reference anchor="GLEIF-ELF" target="https://www.gleif.org/en/about-lei/code-lists/iso-20275-entity-legal-forms-code-list#">
  <front>
    <title>GLEIF Entity Legal Forms</title>
    <author surname="GLEIF">
      <organization>Global Legal Entity Identifier Foundation</organization>
    </author>
   <date year="2022"/>
  </front>
</reference>

<reference anchor="ISO5009" target="https://www.iso.org/standard/80603.html">
	<front>
	  <title>ISO 5009. Financial services — Official organizational roles — Scheme for official organizational roles</title>
	  <author surname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2022" />
	</front>
</reference>

<reference anchor="ISO8601-2004" target="http://www.iso.org/iso/catalogue_detail?csnumber=40874">
	<front>
	  <title>ISO 8601:2004. Data elements and interchange formats - Information interchange -
	  Representation of dates and times</title>
	  <author surname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2004" />
	</front>
</reference>

<reference anchor="ISO4217-2015" target="https://www.iso.org/en/contents/data/standard/06/47/64758.html">
	<front>
	  <title>ISO 4217:2015. Codes for the representation of currencies</title>
	  <author surname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2015" />
	</front>
</reference>

<reference anchor="ISO3166-1" target="https://www.iso.org/standard/63545.html">
	<front>
	  <title>ISO 3166-1:1997. Codes for the representation of names of
	  countries and their subdivisions -- Part 1: Country codes</title>
	  <author surname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2013" />
	</front>
</reference>

<reference anchor="ISO3166-3" target="https://www.iso.org/standard/63547.html">
	<front>
	  <title>ISO 3166-1:2013. Codes for the representation of names of countries and their subdivisions -- Part 3: Code for formerly used names of countries</title>
	  <author surname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2013" />
	</front>
</reference>

<reference anchor="ISO17442-1-2020" target="https://www.iso.org/standard/78829.html">
	<front>
	  <title>ISO 17442-1:2020. Financial services — Legal entity identifier (LEI) — Part 1: Assignment</title>
	  <author surname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2020" />
	</front>
</reference>

<reference anchor="ISO20275" target="https://www.iso.org/obp/ui/#iso:std:iso:20275:ed-1:v1:en">
	<front>
	  <title>ISO 20275. Financial services — Entity legal forms (ELF)</title>
	  <author surname="International Organization for Standardization">
	    <organization abbrev="ISO">International Organization for
	    Standardization</organization>
	  </author>
	  <date year="2013" />
	</front>
</reference>

<reference anchor="OxfordPassport" target="http://www.oxfordreference.com/view/10.1093/acref/9780199290543.001.0001/acref-9780199290543-e-1616">
  <front>
    <title>The New Oxford Companion to Law. ISBN 9780199290543.</title>
    <author initials="P" surname="Cane" fullname="P. Cane">
    </author>
    <author initials="Mary F." surname="Conaghan" fullname="J. Conaghan">
    </author>
   <date year="2008"/>
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

<reference anchor="authority.json" target="https://openid.net/schemas/authority-00.json">
  <front>
    <title>JSON Schema for assertions using authority claims</title>
    <author>
	    <organization>OpenID Foundation</organization>
	  </author>
   <date year="2020"/>
  </front>
</reference>

<reference anchor="predefined_values_page" target="https://openid.net/wg/ekyc-ida/identifiers/">
  <front>
    <title>Overview page for predefined values</title>
    <author>
      <organization>OpenID Foundation</organization>
    </author>
    <date year="2020"/>
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

# IANA Considerations

## JSON Web Token Claims Registration

This specification requests registration of the following value in the IANA "JSON Web Token Claims Registry" established by [@!RFC7519].

### Registry Contents

> Incomplete


# Acknowledgements {#Acknowledgements}

The following people at Considrd.consulting, partner companies and OpenID Foundation contributed to the the initial draft of this specification: Edmund Sutcliffe, Seinar Noem, Ben Helps, Torsten Lodderstedt, Alberto Pulido, Taylor Ongaro, Tom Jones, Adam Cooper, Jim Willeke, Don Thibeau, Nat Sakimura and Kai Lehmann.

We would also like to thank Naohiro Fujie,  Bjorn Hjelm, Stephane Mouy, Joseph Heenan, Vladimir Dzhuvinov, Kosuke Koiwai, Takahiko Kawasaki, Edmund Jay, and Hodari McClain for their valuable feedback and contributions that helped to evolve this specification.

# Notices

Copyright (c) 2020 The OpenID Foundation.

The OpenID Foundation (OIDF) grants to any Contributor, developer, implementer, or other interested party a non-exclusive, royalty free, worldwide copyright license to reproduce, prepare derivative works from, distribute, perform and display, this Implementers Draft or Final Specification solely for the purposes of (i) developing specifications, and (ii) implementing Implementers Drafts and Final Specifications based on such documents, provided that attribution be made to the OIDF as the source of the material, but that such attribution does not indicate an endorsement by the OIDF.

The technology described in this specification was made available from contributions from various sources, including members of the OpenID Foundation and others. Although the OpenID Foundation has taken steps to help ensure that the technology is available for distribution, it takes no position regarding the validity or scope of any intellectual property or other rights that might be claimed to pertain to the implementation or use of the technology described in this specification or the extent to which any license under such rights might or might not be available; neither does it represent that it has made any independent effort to identify any such rights. The OpenID Foundation and the contributors to this specification make no (and hereby expressly disclaim any) warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to this specification, and the entire risk as to implementing this specification is assumed by the implementer. The OpenID Intellectual Property Rights policy requires contributors to offer a patent promise not to assert certain patent claims against other contributors and against implementers. The OpenID Foundation invites any interested party to bring to its attention any copyrights, patents, patent applications, or other proprietary rights that may cover technology that may be required to practice this specification.

# Document History

   -00 (Initial draft of the specification document)

   *  created new document

# Translator {#translator}

本仕様の翻訳は, OpenID ファウンデーションジャパン [@oidfj] KYC ワーキンググループ [@oidfj-kycwg], 翻訳・教育ワーキンググループ [@oidfj-trans] を主体として, 有志のメンバーによって行われました.
質問や修正依頼などについては, Github レポジトリー [@oidfj-github] にご連絡ください.

* Muneomi Sakuta (SoftBank Corp.)
* Yuu Kikuchi (OPTiM Corp.)
* Nov Matake (YAuth.jp)
