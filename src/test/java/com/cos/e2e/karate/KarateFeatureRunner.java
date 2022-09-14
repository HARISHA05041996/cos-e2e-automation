package com.cos.e2e.karate;

import com.cos.e2e.karate.config.AbstractApplicationContextLoader;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;
import org.springframework.boot.system.SystemProperties;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class KarateFeatureRunner extends AbstractApplicationContextLoader {

    private static final String targetDir= "build/reports/karate-reports";
    @Test
    public void testParallelFeatures(){
        String path = "classpath:com/cos/e2e/karate/features/PayforOrder.feature";
        if (SystemProperties.get("TARGET_FEATURES") != null) {
            path =path+"/"+SystemProperties.get("TARGET_FEATURE");
        }
        String targetEnv =SystemProperties.get("TARGET_ENV")==null?"ppe":SystemProperties.get("TARGET_ENV");
        Results results = Runner.path(path).reportDir(targetDir).
                tags("~@ignore","@"+targetEnv) .parallel(5);
        generateReport(results.getReportDir());
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File(targetDir), "cos-e2e-automation");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

}