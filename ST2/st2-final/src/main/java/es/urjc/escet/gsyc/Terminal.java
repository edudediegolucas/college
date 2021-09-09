package es.urjc.escet.gsyc;

import es.urjc.escet.gsyc.config.ConfigurationException;
import es.urjc.escet.gsyc.config.ConfigurationReader;
import es.urjc.escet.gsyc.http.HttpServer;
import es.urjc.escet.gsyc.rmi.Registrable;
import lombok.extern.slf4j.Slf4j;

import java.rmi.Naming;

@Slf4j
public class Terminal {

  public static void main(String[] args) {
    if (args.length != 1) {
      log.error("USAGE: java Terminal [config_file.cfg]");
      System.exit(-1);
    }

    long start = System.currentTimeMillis();
    ConfigurationReader configurationReader = ConfigurationReader.getInstance();
    try {
      configurationReader.readConfigurationFile(args[0]);
    } catch (ConfigurationException configurationException) {
      log.error(configurationException.getMessage(), configurationException);
      System.exit(-1);
    }
    String rmiLocation = "//"
            .concat(configurationReader.getConfigurationMap().get(ConfigurationReader.HOST_RMI_REGISTRY))
            .concat(":")
            .concat(configurationReader.getConfigurationMap().get(ConfigurationReader.PORT_RMI_REGISTRY))
            .concat("/")
            .concat(configurationReader.getConfigurationMap().get(ConfigurationReader.PATH_RMI_REGISTRATOR));
    try {
      var register = (Registrable) Naming.lookup(rmiLocation);
      HttpServer httpServer = new HttpServer(
              Integer.parseInt(configurationReader.getConfigurationMap().get(ConfigurationReader.HTTP_PORT)),
              register);
      httpServer.start();
      long end = System.currentTimeMillis();
      log.info("*** TERMINAL STARTED!***");
      log.info("*** UP & RUNNING! in {} ms", (end - start));
    } catch (Exception e) {
      log.error("ERROR at Terminal!", e);
    }
  }
}


