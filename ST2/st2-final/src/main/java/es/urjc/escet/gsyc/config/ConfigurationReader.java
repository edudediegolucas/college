package es.urjc.escet.gsyc.config;

import lombok.Getter;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

public class ConfigurationReader {

  public static final String HTTP_PORT = "PUERTO_HTTP";
  public static final String HOST_RMI_REGISTRY = "HOST_RMI_REGISTRY";
  public static final String PORT_RMI_REGISTRY = "PUERTO_RMI_REGISTRY";
  public static final String PATH_RMI_REGISTRATOR = "PATH_RMI_REGISTRADOR";
  private static final String REGEX = "\\W+";

  private static ConfigurationReader instance;
  @Getter
  private Map<String, String> configurationMap;

  private ConfigurationReader() {
    this.configurationMap = new HashMap<>();
  }

  public static ConfigurationReader getInstance() {
    if (instance == null) {
      instance = new ConfigurationReader();
    }
    return instance;
  }

  public void readConfigurationFile(String filePath) throws ConfigurationException {
    try (var streamLines = Files.lines(Path.of(filePath))) {
      streamLines
              .forEach(line -> {
                if (line.contains(HTTP_PORT)) {
                  configurationMap.put(HTTP_PORT, line.split(REGEX)[1]);
                }
                if (line.contains(HOST_RMI_REGISTRY)) {
                  configurationMap.put(HOST_RMI_REGISTRY, line.split(REGEX)[1]);
                }
                if (line.contains(PORT_RMI_REGISTRY)) {
                  configurationMap.put(PORT_RMI_REGISTRY, line.split(REGEX)[1]);
                }
                if (line.contains(PATH_RMI_REGISTRATOR)) {
                  configurationMap.put(PATH_RMI_REGISTRATOR, line.split(REGEX)[1]);
                }
              });
    } catch (IOException e) {
      throw new ConfigurationException("Cannot read configuration file", e);
    }
  }
}