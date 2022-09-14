@E2E
@parallel=false
@ppe
Feature: Create Quote Meal Deal

  Background:
    * url baseUrl
    * callonce read('classpath:com/cos/e2e/karate/features/AuthenticateUser.feature@getToken')


  @createOrder
  Scenario: Test Create Quote Meal Deal
    * def COSKarateUtils = Java.type('com.cos.e2e.karate.util.COSKarateUtils');
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/createQuote.json')
    * configure headers = { Authorization: '#(Token)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * print Token

    # Create Quote
    * print 'Test ID : XYZ'
    * print 'TestCase : Create Quote | Positive'
    * header traceId = traceId

    Given path '/v4/quote'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/v4/quote'
    Then status 200
    * print karate.pretty(response)
    And def quoteId = $.quoteId

 # Add Product 1
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Product to Basket | Positive'
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProd.json')
    Given path '/v4/quote/',quoteId,'/products'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    Then status 200
    * print karate.pretty(response)


    # Add Product 2
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Product to Basket | Positive'
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProd1.json')
    Given path '/v4/quote/',quoteId,'/products'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    Then status 200
    * print karate.pretty(response)


    # Add Product 3
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Product to Basket | Positive'
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProd2.json')
    Given path '/v4/quote/',quoteId,'/products'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    Then status 200
    * print karate.pretty(response)


    # Add Product 4
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Product to Basket | Positive'
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProd3.json')
    Given path '/v4/quote/',quoteId,'/products'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    Then status 200
    * print karate.pretty(response)


 # Add Product 5
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Product to Basket | Positive'
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProd4.json')
    Given path '/v4/quote/',quoteId,'/products'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    Then status 200
    * print karate.pretty(response)


     # Get Quote Info
    * print 'Test ID : XYZ'
    * print 'TestCase : Get Quote Info | Positive'
    Given path '/price/v4/quote/',quoteId
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/price/v4/quote/'+quoteId
    Then status 200
    * print karate.pretty(response)
    And match response $.missedRewards == '#null'
    And match response $.rewards == '#notnull'
