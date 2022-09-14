@E2E
@parallel=false
@ppe
Feature: Create Customer Order - Reusable feature

  Background:
    * url baseUrl
    * callonce read('classpath:com/cos/e2e/karate/features/AuthenticateUser.feature@getToken')

  @createOrder
  Scenario: Test Order Creation - Create and verify order placement
    * def COSKarateUtils = Java.type('com.cos.e2e.karate.util.COSKarateUtils');
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/createOrder.json')
    * configure headers = { Authorization: '#(authTokens)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * print authTokens

    # Create Order
    * print 'Test ID : XYZ'
    * print 'TestCase : Create New Order | Positive'
    * header traceId = traceId
    * url baseUrl
    Given path '/customerorder/v2/orders/'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/?channel=online'
    Then status 200
    * print karate.pretty(response)
    And def getOrderId = response
    * print getOrderId.orderId
    And match $ contains {orderId: '#notnull'}

    # Get Order State - Open Status Check
    * print 'Test ID : XYZ'
    * print 'TestCase : Check Order Status - Open | Positive'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/customerorder/v2/orders/',getOrderId.orderId
    And param channel = 'online'
    And param details = 'all'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
    Then status 200
    * print karate.pretty(response)
    And def quoteId = $.quoteId
    And match getOrderId.orderId == $.orderId
    And match $.orderState == 'Open'
    And match $.products == '#notnull'
    And match $.total == '#notnull'

    # Get Quote Info
    * print 'Test ID : XYZ'
    * print 'TestCase : Get Quote Info | Positive'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/price/v4/quote/',quoteId
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/price/v4/quote/'+quoteId
    Then status 200
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match quoteId == $.quoteId

    # Add Product to the basket
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Product to Basket | Positive'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProduct1.json')
    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/product'
    And param channel = 'online'
    And request requestPayload
    * print getOrderId.orderId
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/product?channel=online'
    Then status 204
    * print karate.pretty(response)
    And match response $ == ''

    # Add another Product to the basket
    * print 'Test ID : XYZ'
    * print 'TestCase : Add another Product to Basket | Positive'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addProduct2.json')
    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/product'
    And param channel = 'online'
    And request requestPayload
    * print getOrderId.orderId
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/product?channel=online'
    Then status 204
    * print karate.pretty(response)
    And match response $ == ''

    # Get Quote After Adding Product
    * print 'Test ID : XYZ'
    * print 'TestCase : Get Quote After Adding Product | Positive'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/price/v4/quote/',quoteId
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/price/v4/quote/'+quoteId
    Then status 200
    * print karate.pretty(response)
    And def total = $.totals.grandTotal
    And match response $ == '#notnull'
    And match quoteId == $.quoteId

    # Check Order State - Open Status Check
    * print 'Test ID : XYZ'
    * print 'TestCase : Check Order Status - Open | Positive'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/customerorder/v2/orders/',getOrderId.orderId
    And param channel = 'online'
    And param details = 'all'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
    Then status 200
    * print karate.pretty(response)
    And def quoteId = $.quoteId
    And match getOrderId.orderId == $.orderId
    And match $.orderState == 'Open'
    And match $.products == '#notnull'
    And match $.total == '#notnull'

    # Add Delivery Option
    * print 'Test ID : XYZ'
    * print 'TestCase : Adding Delivery Option | Positive'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/deliveryOption.json')
    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/products/deliveryoption'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/product?channel=online'
    Then status 204
    * print karate.pretty(response)
    And match response $ == ''

    # Check Fulfilment is Not Null
    * print 'Test ID : XYZ'
    * print 'TestCase : Check Fulfilment is Not NULL | Positive'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/customerorder/v2/orders/',getOrderId.orderId
    And param channel = 'online'
    And param details = 'all'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
    Then status 200
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.fulfilment == '#notnull'

    # Add Additional Charges
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Additional Charges | Positive'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/additionalCharges.json')
    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/additionalCharges'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/additionalCharges?channel=online'
    Then status 204
    * print karate.pretty(response)
    And match response $ == ''

    # Add Preferences
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Preferences | Positive'
    * header traceId = traceId
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addPreferences.json')
    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/preferences'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/preferences?channel=online'
    Then status 204
    * print karate.pretty(response)
    And match response $ == ''

    # Check Fulfilment is Not Null Again
    * print 'Test ID : XYZ'
    * print 'TestCase : Check Fulfilment is Not NULL | Positive'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/customerorder/v2/orders/',getOrderId.orderId
    And param channel = 'online'
    And param details = 'all'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
    Then status 200
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.fulfilment == '#notnull'

    # Commit Order
    * print 'Test ID : XYZ'
    * print 'TestCase : Commit Order | Positive'
    * header traceId = traceId
    * header cache-control = 'no-cache'
    * def requestPayload = ''
    Given path '/customerorder/v2/orders/',getOrderId.orderId,'/commit'
    And param channel = 'online'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'/commit?channel=online'
    Then status 204
    * print karate.pretty(response)
    And match response $ == ''

    # Check Order State is Committed or Not
    * print 'Test ID : XYZ'
    * print 'TestCase : Check Order State - Committed | Positive'
    * header traceId = traceId
    * header testTransaction = 'true'
    Given path '/customerorder/v2/orders/',getOrderId.orderId
    And param channel = 'online'
    And param details = 'all'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:', baseUrl+'/customerorder/v2/orders/'+getOrderId.orderId+'?channel=online&details=all'
    Then status 200
    * print karate.pretty(response)
    And match getOrderId.orderId == $.orderId
    And match $.orderState == 'Committed'
    And match $.products == '#notnull'
    And match $.total == '#notnull'
    * def totalValue = $.total.price
    * print 'Total Price : '+totalValue

    * def paymentIds = function(){ var date = new Date(); var formattedDate = date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()+"-"+date.getHours()+"-"+date.getMinutes()+"-"+date.getSeconds(); var paymentId = "papi-"+formattedDate+"-"+Math.floor(Math.random() * 100); return paymentId}
    * def paymentId = call paymentIds

    # Create Payment Request
    * print 'Test ID : XYZ'
    * print 'TestCase : Create Payment Request | Positive'
    * header traceId = 'ti-create-payment-'+ paymentId
    * def Auth = 'Tesco Client='+authToken.access_token+',Customer='+authToken.access_token
    * print Auth
    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * def requestPayload = {"paymentJourney": "tesco:digital:grocery", "paymentDateTime":"2022-07-11T06:08:29.870Z", "externalReference": "order-papi-2022-6-11-11-38-29-80", "amount" : { "value" : "#(totalValue)", "currency": "GBP" }, "sellingLocation": { "id": "cd39ab0b-f441-47c8-9206-938453ddc766" }, "customerData": { "mobilePhoneNumber": "061234567890", "emailAddress": "abc@gmail.com" }}
    * url paymentUrl
    * print paymentId
    Given path '/payments/'+paymentId
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL: '+paymentUrl+'/payments/'+paymentId
    Then status 202
    * print karate.pretty(response)
    And match response $ == ''
    * print responseHeaders
    * def createRequestLocation = responseHeaders['Location'][0]
    * print createRequestLocation

    # Block on request status to wait for create payment,
    * print 'Test ID : XYZ'
    * print 'TestCase : Wait - Create Payment | Positive'
    * header traceId = 'ti-create-payment-'+ paymentId
    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * url createRequestLocation
    Given path '/wait'
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL:'+createRequestLocation+'/wait'
    Then status 200
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.status == 'success'
    And match $.paymentId == '#notnull'
    * def paymentId = $.paymentId
    * print paymentId

    # Create Payment Assurance
    * print 'Test ID : XYZ'
    * print 'TestCase : Create Payment Assurance | Positive'
    * header traceId = 'ti-createAssurance-'+ paymentId
    * def Auth = 'Tesco Client='+authToken.access_token+',Customer='+authToken.access_token
    * configure headers = { Authorization: '#(Auth)', Content-Type: 'application/json', channel: 'online', accept: 'application/json', sync: 'true'}
    * def requestPayload = {"clientData": {"ipAddress": "172.3.7.2"}}
    * url paymentUrl
    Given path '/payments/',paymentId,'/assurance'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL: '+paymentUrl+'/payments/'+paymentId+'/assurance'
    Then status 200
    * print karate.pretty(response)
    And match response $ == '#notnull'
    And match $.status == 'Pending'
    * def assuranceId = $.assuranceId

    # Add Card to Vault
    * print 'Test ID : XYZ'
    * print 'TestCase : Add Card to Vault | Positive'
    * header traceId = 'ti-create-payment-'+ paymentId
    * def Auth = 'Tesco Client='+authToken.access_token+',Customer='+authToken.access_token
    * print Auth
    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * def requestPayload = read('classpath:com/cos/e2e/karate/template/addCard.json')
    * url cardUrl
    Given path '/v1/cards'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL: ,'+cardUrl+'/v1/cards'
    Then status 200
    * print karate.pretty(response)
    And match response $ == '#notnull'
    * def assuranceCardToken = $.id

    # Confirm Payment Assurance
    * print 'Test ID : XYZ'
    * print 'TestCase : Confirm Payment Assurance | Positive'
    * header traceId = 'ti-confirmPayment-'+ paymentId
    * def Auth = 'Tesco Client='+authToken.access_token+',Customer='+authToken.access_token
    * print Auth
    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * def requestPayload = {}
    * url paymentUrl
    Given path '/payments/',paymentId,'/confirm'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL: '+paymentUrl+'/payments/'+paymentId+'/confirm'
    Then status 202
    * print karate.pretty(response)
    And match response $ == ''

    # Check Payment Status as Chargeable or Created
    * print 'Test ID : XYZ'
    * print 'TestCase : Check Payment Status - Chargeable OR Created | Positive'
    * header traceId = 'ti-create-payment-'+ paymentId
    * def Auth = 'Tesco Client='+authToken.access_token
    * print Auth
    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * url paymentUrl
    Given path '/payments/',paymentId
    And request requestPayload
    When method GET
    * print 'headers:', karate.prevRequest.headers
    * print 'URL: '+paymentUrl+'/payments/'+paymentId
    Then status 200
    * print karate.pretty(response)
    And match response $ == '#notnull'
    * def value = $.amount.value

    # Charge the Payment -- Pay
    * print 'Test ID : XYZ'
    * print 'TestCase : Charge the Payment - Pay | Positive'
    * header traceId = 'ti-create-payment-'+ paymentId
    * print traceId
    * def Auth = 'Tesco Client='+authToken.access_token
    * print Auth
    * configure headers = { Authorization: '#(Auth)', Accept-Language: 'en-GB', Content-Type: 'application/json', channel: 'online', accept: 'application/json'}
    * def requestPayload = {"amount" : {"value" : "#(value)","currency": "GBP"},"sellingLocation": {"id": "cd39ab0b-f441-47c8-9206-938453ddc766","pointOfSaleIdentifier": "123"},"transactionTime": "2022-07-11T03:27:10.369Z"}
    * url paymentUrl
    Given path '/payments/',paymentId,'/charge'
    And request requestPayload
    * print karate.pretty(requestPayload)
    When method POST
    * print 'headers:', karate.prevRequest.headers
    * print 'URL: '+paymentUrl+'/payments/'+paymentId+'/charge'
    Then status 202
    * print karate.pretty(response)
    And match response $ == ''
