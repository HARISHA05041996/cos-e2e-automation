function fn() {
    var COSKarateUtils = Java.type('com.cos.e2e.karate.util.COSKarateUtils');

    var config = {
        baseUrl: COSKarateUtils.getMasterBaseUrl(),
        paymentUrl: COSKarateUtils.getPaymentBaseUrl(),
        cardUrl: COSKarateUtils.getCardBaseUrl(),
       }

     return config;
}