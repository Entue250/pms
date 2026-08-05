// com.pms.util.EnvLoader.java
package com.pms.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Loads WEB-INF/.env at application startup and exposes each entry as a
 * System property, so credentials never need to be hardcoded in source.
 * Real environment variables / -D system properties take precedence over
 * the .env file, so it can still be overridden in production/containers.
 */
@WebListener
public class EnvLoader implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String envPath = sce.getServletContext().getRealPath("/WEB-INF/.env");
        if (envPath == null) {
            return;
        }

        File envFile = new File(envPath);
        if (!envFile.exists()) {
            return;
        }

        Properties props = new Properties();
        try (FileInputStream in = new FileInputStream(envFile)) {
            props.load(in);
        } catch (IOException e) {
            throw new RuntimeException("Failed to load .env file at " + envPath, e);
        }

        for (String key : props.stringPropertyNames()) {
            if (System.getProperty(key) == null) {
                System.setProperty(key, props.getProperty(key));
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // no-op
    }
}
