package com.cos.e2e.karate.config;

import com.cos.e2e.karate.COSAutomationApplication;
import org.apache.commons.math3.analysis.function.Cos;
import org.springframework.boot.test.context.SpringBootContextLoader;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;

@WebAppConfiguration
@SpringBootTest(classes = COSAutomationApplication.class)
@ContextConfiguration(classes = Cos.class, loader= SpringBootContextLoader.class)
public class AbstractApplicationContextLoader {

}
