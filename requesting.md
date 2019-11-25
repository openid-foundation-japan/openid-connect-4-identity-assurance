# Requesting Verified Claims

## Requesting End-User Claims {#req_claims}

Verified Claims can be requested on the level of individual Claims about the End-User by utilizing the `claims` parameter as defined in Section 5.5. of the OpenID Connect specification [@!OpenID]. 

To request verified claims, the `verified_claims` element is added to the `userinfo` or the `id_token` element of the `claims` parameter. 

Since `verified_claims` contains the effective Claims about the End-User in a nested `claims` element, the syntax is extended to include expressions on nested elements as follows. The `verified_claims` element includes a `claims` element, which in turn includes the desired Claims as keys with a `null` value. An example is shown in the following:

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":{  
            "given_name":null,
            "family_name":null,
            "birthdate":null
         }
      }
   }	
}
```

Use of the `claims` parameter allows the RP to exactly select the Claims about the End-User needed for its use case. This extension therefore allows RPs to fulfill the requirement for data minimization.

RPs MAY indicate that a certain Claim is essential to the successful completion of the user journey by utilizing the `essential` field as defined in Section 5.5.1. of the OpenID Connect specification [@!OpenID]. The following example designates both given as well as family name as being essential.

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":{  
            "given_name":{"essential": true},
            "family_name":{"essential": true},
            "birthdate":null
         }
      }
   }	
}
```

This specification introduces the additional field `purpose` to allow a RP 
to state the purpose for the transfer of a certain End-User Claim it is asking for. 
The field `purpose` can be a member value of each individually requested 
Claim, but a Claim cannot have more than one associated purpose.

`purpose` OPTIONAL. String describing the purpose for obtaining a certain End-User Claim from the OP. The purpose MUST NOT be shorter than 3 characters or 
longer than 300 characters. If this rule is violated, the authentication 
request MUST fail and the OP returns an error `invalid_request` to the RP.
The OP MUST display this purpose in the respective user consent screen(s) 
in order to inform the user about the designated use of the data to be 
transferred or the authorization to be approved. If the parameter `purpose` 
is not present in the request, the OP MAY display a 
value that was pre-configured for the respective RP. For details on UI 
localization see (#purpose).

Example:

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":{  
            "given_name":{  
               "essential":true,
               "purpose":"To make communication look more personal"
            },
            "family_name":{  
               "essential":true
            },
            "birthdate":{  
               "purpose":"To send you best wishes on your birthday"
            }
         }
      }
   }
}
```

Note: A `claims` sub-element with value `null` is interpreted as a request for all possible Claims. An example is shown in the following:

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "claims":null
      }
   }	
}
```

Note: The `claims` sub-element can be omitted, which is equivalent to a `claims` element whose value is `null`.

Note: If the `claims` sub-element is empty or contains a Claim not fulfilling the requirements defined in (#claimselement), the OP will abort the transaction with an `invalid_request` error.

## Requesting Verification Data {#req_verification}

The content of the `verification` element is basically determined by the respective `trust_framework` and the Claim source's policy. 

This specification also defines a way for the RP to explicitly request certain data to be present in the `verification` element. The syntax is based on the rules given in (#req_claims) and extends them for navigation into the structure of the `verification` element.

Elements within `verification` can be requested in the same way as defined in (#req_claims) by adding the respective element as shown in the following example:

```json
{  
   "verified_claims":{  
      "verification":{  
         "time":null,
         "evidence":null
      },
      "claims":null
   }
}
```

It requests the date of the verification and the available evidence to be present in the issued assertion. 

Note: the RP does not need to explicitly request the `trust_framework` field as it is a mandatory element of the `verified_claims` Claim. 

The RP may also dig one step deeper into the structure and request certain data to be present within every `evidence`. A single entry is used as prototype for all entries in the result array:

```json
{  
   "verified_claims":{  
      "verification":{  
         "time":null,
         "evidence":[  
            {  
               "method":null,
               "document":null
            }
         ]
      },
      "claims":null
   }
}
```

This example requests the `method` element and the `document` element for every evidence available for a certain user account.

Note: the RP does not need to explicitly request the `type` field as it is a mandatory element of any `evidence` entry. 

The RP may also request certain data within the `document` element to be present. This again follows the syntax rules used above. 

```json
{  
   "verified_claims":{  
      "verification":{  
         "time":null,
         "evidence":[  
            {  
               "method":null,
               "document":{  
                  "issuer":null,
                  "number":null,
                  "date_of_issuance":null
               }
            }
         ]
      },
      "claims":null
   }
}
```

Note: the RP does not need to explicitly request the `type` field as it is a mandatory element of any `document` entry. 

It is at the discretion of the Claim source to decide whether the requested verification data is provided to the RP.

## Defining constraints on Verification Data {#constraintedclaims}

The RP MAY express requirements regarding the elements in the `verification` sub-element.

This, again, requires an extension to the syntax as defined in Section 5.5. of the OpenID Connect specification [@!OpenID] due to the nested nature of the `verified_claims` claim.

Section 5.5.1 of the OpenID Connect specification [@!OpenID] defines a query syntax that allows for the member value of the Claim being requested to be a JSON object with additional information/constraints on the Claim. For doing so it defines three members (`essential`, `value` and `values`) with special query 
meanings and allows for other special members to be defined (while stating that any members that are not understood must be ignored).

This specification re-uses that mechanism and introduces a new such member `max_age` (see below).

To start with, the RP MAY limit the possible values of the elements `trust_framework`, `evidence/type`, `evidence/method`, and `evidence/document/type` by utilizing the `value` or `values` fields. 

The following example shows that the RP wants to obtain an attestation based on AML and limited to users who were identified in a bank branch in person using government issued id documents.

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "verification":{  
            "trust_framework":{  
               "value":"de_aml"
            },
            "evidence":[  
               {  
                  "type":{  
                     "value":"id_document"
                  },
                  "method":{  
                     "value":"pipp"
                  },
                  "document":{  
                     "type":{  
                        "values":[  
                           "idcard",
                           "passport"
                        ]
                     }
                  }
               }
            ]
         },
         "claims":null
      }
   }
}
```

The RP MAY also express a requirement regarding the age of the verification data, i.e., the time elapsed since the verification process asserted in the `verification` element has taken place. 

This specification therefore defines a new member `max_age`.

`max_age`: OPTIONAL. Is a JSON number value only applicable to Claims that contain dates or timestamps. It defines the maximum time (in seconds) to be allowed to elapse since the value of the date/timestamp up to the point in time of the request. The OP should make the calculation of elapsed time starting from the last valid second of the date value. The following is an example of a request for Claims where the verification process of the data is not allowed to be older than 63113852 seconds.

The following is an example:

```json
{  
   "userinfo":{  
      "verified_claims":{  
         "verification":{  
            "date":{  
               "max_age":63113852
            }
         },
         "claims":null
      }
   }
}
```

The OP SHOULD try to fulfill this requirement. If the verification data of the user is older than the requested `max_age`, the OP MAY attempt to refresh the user’s verification by sending her through a online identity verification process, e.g. by utilizing an electronic ID card or a video identification approach. 

If the OP is unable to fulfill any of the requirements stated in this section (even in case it is marked as being `essential`), it will provide the RP with the data available and the RP may decide how to use the data. The OP MUST NOT return an error in case it cannot return all Claims requested as essential Claims.
