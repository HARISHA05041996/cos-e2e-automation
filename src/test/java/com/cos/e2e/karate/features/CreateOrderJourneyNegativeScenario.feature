@E2E
@parallel=false
@ppe
Feature: Create Customer Order Negative Journey - Reusable feature

  Background:
    * url baseUrl
    * callonce read('classpath:com/cos/e2e/karate/features/AuthenticateUser.feature@getToken')

  @createOrderNegative
  Scenario: Test Negative Order Creation - Create and verify order placement
    * def COSKarateUtils = Java.type('com.cos.e2e.karate.util.COSKarateUtils');
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/createOrderNegative.json')
    * configure headers = { Authorization: '#(authTokens)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * print authTokens

    # Create Order without providing Currency Type
    * print 'Test ID : XYZ'
    * print 'TestCase : Create New Order without Providing Currency Type | Negative'
    * header traceId = traceId
    * url baseUrl
    Given path '/customerorder/v2/orders/'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/?channel=online'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.message == 'Currency value is empty or invalid'
    * print $.message

    # Create Order with NULL locationId
    * print 'Test ID : XYZ'
    * print 'TestCase : Create New Order with NULL LocationId | Negative'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/createOrderNegative2.json')
    * url baseUrl
    Given path '/customerorder/v2/orders/'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/?channel=online'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.message == 'Location value is empty or invalid'
    * print $.message

    # Create Order with Invalid locationId
    * print 'Test ID : XYZ'
    * print 'TestCase : Create New Order with Invalid LocationId | Negative'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/createOrderNegative3.json')
    * url baseUrl
    Given path '/customerorder/v2/orders/'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/?channel=online'
    Then status 503
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.message == 'Dependent Service Not Available'
    * print $.message

    # Get Order State - Open Status Check with wrong Order Id
    * print 'Test ID : XYZ'
    * print 'TestCase : Check Order Status with Invalid Order Id | Negative'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/customerorder/v2/orders/trn:tesco:order:uuid:0a832b96-bef7-40d0-a74a-01b39f7f'
    And param channel = 'online'
    And param details = 'all'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.message == 'Order identifier is empty or invalid'

    # Get Quote Info with wrong Quote Id
    * print 'Test ID : XYZ'
    * print 'TestCase : Get Quote Info with Wrong QuoteId | Negative'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/price/v4/quote/834e1794-ab50-4436-b42b-52a0ae793'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/price/v4/quote/'+quoteId
    Then status 404
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.error == 'Document with Id - quote::834e1794-ab50-4436-b42b-00052a0ae793 not found'

    # Add Product to the basket with wrong product Id
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Product to Basket with Wrong Product Id | Negative'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProduct3.json')
    Given path '/customerorder/v2/orders/trn:tesco:order:uuid:0a832b96-bef7-40d0-a74a-01b39f7fe18e','/product'
    And param channel = 'online'
    And request requestPayload
    * print getOrderId.orderId
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/product?channel=online'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.message == 'Product not found.'

    # Add another Product to the basket without Providing Null Unit
    * print 'Test ID : XYZ'
    * print 'TestCase : Add another Product to Basket without providing Null Unit | Negative'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProduct4.json')
    Given path '/customerorder/v2/orders/trn:tesco:order:uuid:0a832b96-bef7-40d0-a74a-01b39f7fe18e','/product'
    And param channel = 'online'
    And request requestPayload
    * print getOrderId.orderId
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/product?channel=online'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.message == 'Incorrect number of units for the specfied unit of measure.'

    # Add Delivery Option with Invalid OrderId
    * print 'Test ID : XYZ'
    * print 'TestCase : Adding Delivery Option With Invalid OrderId | Negative'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/deliveryOption.json')
    Given path '/customerorder/v2/orders/834e1794-ab50-4436-b42b-52a0ae793','/products/deliveryoption'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/product?channel=online'
    Then status 400
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.message == 'Order identifier is empty or invalid'

#    # Check Fulfilment is Not Null
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Check Fulfilment is Not NULL | Positive'
#    * header traceId = traceId
#    * header testTransaction = 'true'
#    Given path '/customerorder/v2/orders/',getOrderId.orderId
#    And param channel = 'online'
#    And param details = 'all'
#    When method GET
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
#    Then status 200
#    * print karate.pretty(response)
#    And match response $ == '#notnull'
#    And match $.fulfilment == '#notnull'
#
#    # Add Additional Charges
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Add Additional Charges | Positive'
#    * header traceId = traceId
#    * def requestPayload = read('classpath:com/cos/e2e/karate/template/additionalCharges.json')
#    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/additionalCharges'
#    And param channel = 'online'
#    And request requestPayload
#    * print karate.pretty(requestPayload)
#    When method POST
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/additionalCharges?channel=online'
#    Then status 204
#    * print karate.pretty(response)
#    And match response $ == ''
#
#    # Add Preferences
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Add Preferences | Positive'
#    * header traceId = traceId
#    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addPreferences.json')
#    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/preferences'
#    And param channel = 'online'
#    And request requestPayload
#    * print karate.pretty(requestPayload)
#    When method POST
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/preferences?channel=online'
#    Then status 204
#    * print karate.pretty(response)
#    And match response $ == ''
#
#    # Check Fulfilment is Not Null Again
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Check Fulfilment is Not NULL | Positive'
#    * header traceId = traceId
#    * header testTransaction = 'true'
#    Given path '/customerorder/v2/orders/',getOrderId.orderId
#    And param channel = 'online'
#    And param details = 'all'
#    When method GET
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
#    Then status 200
#    * print karate.pretty(response)
#    And match response $ == '#notnull'
#    And match $.fulfilment == '#notnull'
#
#    # Commit Order
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Commit Order | Positive'
#    * header traceId = traceId
#    * header cache-control = 'no-cache'
#    * def requestPayload = ''
#    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/commit'
#    And param channel = 'online'
#    And request requestPayload
#    * print karate.pretty(requestPayload)
#    When method POST
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/commit?channel=online'
#    Then status 204
#    * print karate.pretty(response)
#    And match response $ == ''
#
#    # Check Order State is Committed or Not
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Check Order State - Committed | Positive'
#    * header traceId = traceId
#    * header testTransaction = 'true'
#    Given path '/customerorder/v2/orders/',getOrderId.orderId
#    And param channel = 'online'
#    And param details = 'all'
#    When method GET
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
#    Then status 200
#    * print karate.pretty(response)
#    And match getOrderId.orderId == $.orderId
#    And match $.orderState == 'Committed'
#    And match $.products == '#notnull'
#    And match $.total == '#notnull'
#
#    # Create Payment Request
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Create Payment Request | Positive'
#    * header traceId = traceId
#    * def Auth = 'Tesco Client='+authToken.access_token+',Customer='+authToken.access_token
#    * print Auth
#    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
#    * def requestPayload = read('classpath:com/cos/e2e/karate/template/paymentRequest.json')
#    * url 'https://payment-ppe.api.tesco.com'
#    Given path '/payments/',getOrderId.orderId
#    And request requestPayload
#    * print karate.pretty(requestPayload)
#    When method POST
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', paymentUrl+'/payments/'+getOrderId.orderId
#    Then status 202
#    * print karate.pretty(response)
#    And match response $ == ''
#
#    # Check Payment Status as Chargeable or Created
#    * print 'Test ID : XYZ'
#    * print 'TestCase : Check Payment Status - Chargeable OR Created | Positive'
#    * header traceId = traceId
#    * def Auth = 'Tesco Client='+authToken.access_token+',Customer='+authToken.access_token
#    * print Auth
#    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
#    * url 'https://payment-ppe.api.tesco.com'
#    Given path '/payments/',getOrderId.orderId
#    And request requestPayload
#    When method GET
#    * print 'headers:', karate.prevRequest.headers
#    * print 'URL:', paymentUrl+'/payments/'+getOrderId.orderId
#    Then status 200
#    * print karate.pretty(response)
#    And match response $ == '#notnull'
#    And match $.status == 'created'
    # Status must be chargeable to make payment
