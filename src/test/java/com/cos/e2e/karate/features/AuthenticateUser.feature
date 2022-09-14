@E2E
@parallel=false
@ppe
Feature: Generate Token for User - Reusable feature

  Background:
    * url baseUrl

  @getToken
  Scenario: Test Token Generation - Create and Use Token for Authorization
    * def COSKarateUtils = Java.type('com.cos.e2e.karate.util.COSKarateUtils');
    * def customerPayload = read('classpath:com/cos/e2e/karate/template/customerToken.json')
    * def customerPayloadNew = read('classpath:com/cos/e2e/karate/template/customertokennew.json')
    * def userPayload = read('classpath:com/cos/e2e/karate/template/serviceToken.json')
    * configure headers = {cache-control: 'no-cache', Content-Type: 'application/json'}

    # Generate Customer Token
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token | Positive'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    And request customerPayload
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 200
    * print karate.pretty(response)
    And def authToken = response
    And def accessToken = 'Bearer '+ authToken.access_token
    And def traceIds = 'Bearer '+ authToken.refresh_token
    And match response $ == '#notnull'
    * def userKey = $.Claims[2]["value"]
    * print accessToken
    * print traceIds
    * print userKey

    # Generate Client Token
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Service Token | Positive'
    * url baseUrl
    Given path '/identity/v3/api/auth/oauth/v2/token'
    And request userPayload
    * print karate.pretty(userPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v3/api/auth/oauth/v2/token'
    Then status 200
    * print karate.pretty(response)
    And def authToken = response
    And def authTokens = 'Bearer '+ authToken.access_token
    And def serviceToken = 'Bearer '+ authToken.access_token
    And def traceId = 'Bearer '+ authToken.refresh_token
    * print authTokens
    * print traceId

     # Generate Customer Token
    * print 'Test ID : Xyz'
    * print 'TestCase : Generate Customer Token | Positive'
    * url baseUrl
    Given path '/identity/v4/issue-token/token'
    And request customerPayloadNew
    * print karate.pretty(customerPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/identity/v4/issue-token/token'
    Then status 200
    * print karate.pretty(response)
    And def authToken = response
    And def Token = 'Bearer '+ authToken.access_token
    And def traceIds = 'Bearer '+ authToken.refresh_token
    And match response $ == '#notnull'
    * def userKey = $.Claims[2]["value"]
    * print Token