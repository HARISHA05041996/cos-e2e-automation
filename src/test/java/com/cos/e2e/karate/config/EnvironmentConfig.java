package com.cos.e2e.karate.config;


import com.cos.e2e.karate.util.COSKarateUtils;
import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Setter
@Getter
@Service
public class EnvironmentConfig {
	
	@Value("${api.master-url.baseUrl}")
	private String masterBaseUrl;

	@Value("${api.payment-url.baseUrl}")
	private String paymentBaseUrl;

	@Value("${api.card-url.baseUrl}")
	private String cardBaseUrl;

	@PostConstruct
	public void setup() {
		COSKarateUtils.masterBaseUrl = masterBaseUrl;
		COSKarateUtils.paymentBaseUrl = paymentBaseUrl;
		COSKarateUtils.cardBaseUrl = cardBaseUrl;
	}
}
