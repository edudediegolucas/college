package es.urjc.escet.gsyc;

import es.urjc.escet.gsyc.rmi.Registrable;
import es.urjc.escet.gsyc.rmi.Registration;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.io.Serializable;
import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;

@Slf4j
public class CentralServer implements Serializable {

  public static void main(String[] args) {
    if (args.length != 2) {
      log.error("USAGE: java CentralServer [IP] [port]");
      log.error("ERROR!, you must specified IP and port to start CentralServer");
      System.exit(-1);
    }

    //this system properties allows to run an RMI server
    System.setProperty("java.rmi.server.hostname", "127.0.0.1");
    System.setProperty("java.security.policy", "src/main/resources/policy.txt");

    log.info("*** LAUNCHING CENTRAL-SERVER ***");
    long start = System.currentTimeMillis();
    if (System.getSecurityManager() == null) {
      System.setSecurityManager(new SecurityManager());
    }

    try {
      String rmiHost = args[0];
      int rmiPort = Integer.parseInt(args[1]);
      log.info("Preparing CentralServer at {}:{}", rmiHost, rmiPort);
      Registrable registration = Registration.getInstance();
      LocateRegistry.createRegistry(1099);
      Naming.rebind("//" + rmiHost + ":" + rmiPort + "/registration", registration);
      long end = System.currentTimeMillis();
      log.info("*** UP & RUNNING! in {} ms", (end - start));
    } catch (MalformedURLException malformedURLException) {
      log.error("ERROR! RMI url is not correct", malformedURLException);
      System.exit(-1);
    } catch (RemoteException remoteException) {
      log.error("ERROR! Cannot create RMI connection", remoteException);
      System.exit(-1);
    } catch (IOException ioException) {
      log.error("ERROR! Something went wrong!", ioException);
      System.exit(-1);
    } catch (NumberFormatException numberFormatException) {
      log.error("ERROR! Port is not a number", numberFormatException);
      System.exit(-1);
    } catch (RuntimeException runtimeException) {
      log.error("ERROR! ", runtimeException);
      System.exit(-1);
    }
  }
} 