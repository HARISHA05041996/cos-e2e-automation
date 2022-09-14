package com.cos.e2e.karate.util;

import lombok.extern.slf4j.Slf4j;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Random;

@Slf4j
public class COSKarateUtils {

    public static String masterBaseUrl;
    public static String paymentBaseUrl;
    public static String cardBaseUrl;

    public static String generateRandomAlphaNumericNumber() {
        Random r = new Random();
        return Long.toString(Math.abs(r.nextLong()) & Long.MAX_VALUE, 36);
    }

    public static String generateAlphaNumericNumber() {
        Random r = new Random();
        return Long.toString(Math.abs(r.nextLong()) & Long.MAX_VALUE, 15);
    }

    public static String generateRandomInteger() {
        Random rand = new Random();
        int num = rand.nextInt(900000000) + 100000000;
        return String.valueOf(num);
    }

    public static String getCurrentDate() {
        log.info(LocalDate.now().toString());
        return LocalDate.now().toString();
    }

    public static String sleep(Integer millis) throws InterruptedException {
        Thread.sleep(millis);
        return "";
    }

    public static LocalDateTime getCurrentTime() {
        return LocalDateTime.now();
    }

    public static LocalDateTime getPreviousDayDateTime() {
        return LocalDateTime.now().minusDays(1);
    }

    public static LocalDateTime getStartTime() {
        LocalDate localDate = LocalDate.now();
        return localDate.atStartOfDay();
    }

    public static LocalDateTime getEndTime() {
        LocalDate localDate = LocalDate.now();
        return localDate.atTime(LocalTime.MAX);
    }

    public static String getMasterBaseUrl() {
        return masterBaseUrl;
    }

    public static String getPaymentBaseUrl() { return paymentBaseUrl; }

    public static String getCardBaseUrl() { return cardBaseUrl; }

}
