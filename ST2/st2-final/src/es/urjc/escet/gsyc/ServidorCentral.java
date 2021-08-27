package es.urjc.escet.gsyc;

import es.urjc.escet.gsyc.rmi.Registrador;
import es.urjc.escet.gsyc.rmi.RegistradorImpl;

import java.io.Serializable;
import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

public class ServidorCentral implements Serializable {

  public static void main(String[] args) {
    if (args.length != 2) {
      System.out.println("ERROR!, por favor, debe especificar el host y el puerto del servidor de nombres RMI");
      System.exit(-1);
    }

    String rmiHost = args[0];
    short rmiPort = (short) Integer.parseInt(args[1]);

    if (System.getSecurityManager() == null) {
      System.setSecurityManager(new SecurityManager());
    }
    System.setProperty("java.rmi.server.hostname", "127.0.0.1");

    System.out.println("Lanzando el servidor central..conectado a " + rmiHost + " con puerto numero " + rmiPort + "...Esperando conexiones...");

    //A continuacion se intenta lanzar el servidor...

    try {
      Registrador registro = new RegistradorImpl();
      LocateRegistry.createRegistry(1099);
      System.out.println("LANZANDO EL SERVIDOR CENTRAL.................................");
      Naming.rebind("//" + rmiHost + ":" + rmiPort + "/Registrador", registro);
      System.out.println(" ");
      System.out.println("Servidor Iniciado!");
    } catch (Exception e) {
      e.printStackTrace();
      System.out.println("ERROR!!, no se ha podido lanzar el servidor....");
      System.exit(-1);
    }

  }

} 