package es.urjc.escet.gsyc.config;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class ConfigurationReaderTest {

  private ConfigurationReader configurationReader;

  @BeforeEach
  void before() {
    configurationReader = ConfigurationReader.getInstance();
  }

  @Test
  void testReadConfigurationFile() {
    configurationReader.readConfigurationFile("src/test/resources/p2p-test.cfg");
    var readerConfigurationMap = configurationReader.getConfigurationMap();
    Assertions.assertNotNull(readerConfigurationMap);
  }

  @Test
  void testReadConfigurationFileException() {
    Assertions.assertThrows(ConfigurationException.class, () -> configurationReader.readConfigurationFile("src/test/resources/do-not-exist.cfg"));
  }
}
