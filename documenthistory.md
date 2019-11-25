# Document History

   [[ To be removed from the final specification ]]
   
   -08
   
   * added `uripp` verification method
   * small fixes to examples
   
   -07
   
   * fixed typos
   * changed `nationality` String claim to `nationalities` String array claim
   * replaced `agent` in id_document verifier element by `txn` element
   * qes method: fixed error in description of `issuer`
   * qes method: changed `issued_at` to `created_at` since this field applies to the signature (that is created and not issued)
   * Changed format of `nationalities` and issuing `country` to ICAO codes
   * Changed `date` in verification element to `time`
   * Added Japanese trust frameworks to pre-defined values
   * Added Japanese id documents to pre-defined values
   * adapted JSON schema and examples
   
   -06
   
   * Incorporated review feedback by Marcos Sanz and Adam Cooper
   * Added text on integrity, authenticity, and confidentiality for data passed between OP and RP to Security Considerations section
   * added `purpose` field to `claims` parameter
   * added feature to let the RP explicitly requested certain `verification` data
   
   -05
   
   * incorporated review feedback by Mike Jones
   * Added OIDF Copyright Notices
   * Moved Acknowledgements to Appendix A
   * Removed RFC 2119 keywords from scope & requirements section and rephrased section
   * rephrased introduction
   * replaced `birth_name` with `birth_family_name`, `birth_given_name`, and `birth_middle_name`
   * replaced `transaction_id` with `txn` from RFC 8417
   * added references to eIDAS, ISO 3166-1, ISO 3166-3, and ISO 8601-2004
   * added note on `purpose` and locales
   * changed file name and document title to include 1.0 version id
   * corrected evidence plural
   * lots of editorial fixes
   * Alignment with OpenID Connect Core wording
   * Renamed `id` to `verification_process`
   * Renamed `verified_person_data` to `verified_claims`
   
   -04
   
   * incorporated review feedback by Marcos Sanz 
   
   -03
   
   * enhanced draft to support multiple evidence
   * added a JSON Schema for assertions containing the `verified_person_data` Claim
   * added more identity document definitions
   * added `region` field to `place_of_birth` Claim
   * changed `eidas_loa_substantial/high` to `eidas_ial_substantial/high` 
   * fixed typos in examples
   * uppercased all editorial occurences of the term `claims` to align with OpenID Connect Core
   
   -02
   
   * added new request parameter `purpose`
   * simplified/reduced number of verification methods
   * simplfied identifiers
   * added `identity_documents_supported` to metadata section
   * improved examples
   
   -01 

   *  fixed some typos
   *  remove organization element (redundant) (issue 1080)
   *  allow other Claims about the End-User in the `claims` sub element (issue 1079)
   *  changed `legal_context` to `trust_framework`
   *  added explanation how the content of the verification element is determined by the trust framework
   *  added URI-based identifiers for `trust_framework`, `identity_document` and (verification) `method`
   *  added example attestation for notified/regulated eID system
   *  adopted OP metadata section accordingly 
   *  changed error behavior for `max_age` member to alig with OpenID Core
   *  Added feature to let the RP express requirements for verification data (trust framework, identity documents, verification method)
   *  Added privacy consideration section and added text on legal basis for data exchange
   *  Added explanation about regulated and un-regulated eID systems
   
   -00 (WG document)

   *  turned the proposal into a WG document
   *  changed name
   *  added terminology section and reworked introduction
   *  added several examples (ID Token vs UserInfo, unverified & verified claims, aggregated & distributed claims)
   *  incorporated text proposal of Marcos Sanz regarding max_age
   *  added IANA registration for new error code `unable_to_meet_requirement`
