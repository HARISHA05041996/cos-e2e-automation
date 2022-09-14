@E2E
@parallel=false
@ppe
Feature: Generate Token for User - Reusable feature

  Background:
    * url baseUrl

  @getTokenNegativeScenario
  Scenario: Test Token Generation Negative Scenarios - Create and Use Token for Authorization
    * configure headers = {cache-control: 'no-cache', Content-Type: 'application/json'}

    # Generate Customer Token without client_Id
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token Without Client_ID | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def customerPayload = {"client_id": "","grant_type": "password","scope": "service","username":"yesh@ppe.com","password":"Pa$$w0rd"}
    And request customerPayload
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'invalid_request'

    # Generate Customer Token with Invalid Client_Id
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token With Invalid Client_ID | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def customerPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e","grant_type": "password","scope": "service","username":"yesh@ppe.com","password":"Pa$$w0rd"}
    And request customerPayload
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 401
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'invalid_client'

    # Generate Customer Token with Invalid Grant_Type
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token With Invalid Client_ID | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def customerPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "test","scope": "service","username":"yesh@ppe.com","password":"Pa$$w0rd"}
    And request customerPayload
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'unsupported_grant_type'

    # Generate Customer Token with Invalid Scope
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token With Invalid Scope | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def customerPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "password","scope": "xyz","username":"yesh@ppe.com","password":"Pa$$w0rd"}
    And request customerPayload
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == '#notnull'

    # Generate Customer Token with Invalid User
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token With Invalid User | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def customerPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "password","scope": "service","username":"abcd@ppe.com","password":"Pa$$w0rd"}
    And request customerPayload
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == '#invalid_grant'

    # Generate Customer Token with Invalid Password
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token With Invalid Password | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def customerPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "password","scope": "service","username":"yesh@ppe.com","password":"Pass"}
    And request customerPayload
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == '#invalid_grant'

    # Generate Service Token with Invalid Client_Id
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Service Token with Invalid Client_Id | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def userPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a","grant_type": "password","scope": "service","username":"COSLegacyIntegration_Client","password":"S1uQ2J2tVzciKA@yZnBqxfCYVS$K"}
    And request userPayload
    * print karate.pretty(userPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 401
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'invalid_client'

    # Generate Service Token with Invalid Grant_Type
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Service Token with Invalid Grant_Type | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def userPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "abcd","scope": "service","username":"COSLegacyIntegration_Client","password":"S1uQ2J2tVzciKA@yZnBqxfCYVS$K"}
    And request userPayload
    * print karate.pretty(userPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'unsupported_grant_type'

    # Generate Service Token with Invalid Scope
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Service Token with Invalid Scope | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def userPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "password","scope": "abcd","username":"COSLegacyIntegration_Client","password":"S1uQ2J2tVzciKA@yZnBqxfCYVS$K"}
    And request userPayload
    * print karate.pretty(userPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == '#notnull'

    # Generate Service Token with Invalid User
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Service Token with Invalid User | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def userPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "password","scope": "service","username":"COSLegacy","password":"S1uQ2J2tVzciKA@yZnBqxfCYVS$K"}
    And request userPayload
    * print karate.pretty(userPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'invalid_grant'

    # Generate Service Token with Invalid Password
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Service Token with Invalid Password | Negative'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    * def userPayload = {"client_id": "trn:tesco:cid:86399c49-0f4c-477b-8d9b-e7bb9f61b31f:5ICCSN17bb875bb5938fca751abeb68b48358f29db42937c6a6c21669bc0e7f4a8c8c","grant_type": "password","scope": "service","username":"COSLegacy","password":"S1uQ2J2tVzciKA@yZnBqxS$K"}
    And request userPayload
    * print karate.pretty(userPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'invalid_grant'

