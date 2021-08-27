package es.urjc.escet.gsyc;

import es.urjc.escet.gsyc.config.ConfigException;
import es.urjc.escet.gsyc.config.ConfiguracionGeneral;
import es.urjc.escet.gsyc.config.LectorDeConfiguracion;
import es.urjc.escet.gsyc.http.ServidorHttpDelTerminal;
import es.urjc.escet.gsyc.peer.Peer;
import es.urjc.escet.gsyc.rmi.Registrador;

import java.rmi.Naming;
import java.util.HashMap;
import java.util.Random;

public class Terminal {

  public static void main(String[] args) {

    if (args.length != 1) {
      System.out.println("Modo de uso:");
      System.out.println("> java Terminal <fichero.cfg>");
      System.exit(-1);
    }

    try {
      LectorDeConfiguracion.LeeConfiguracionGeneral(args[0]);
    } catch (ConfigException e) {
      System.out.println(e.getMensajeDeError());
      System.exit(-1);
    }
    //Creamos variables credencial y los hashmap necesarios para guardar los usuarios y las terminales
    Random credencial = new Random();
    HashMap<String, String> usuarios = new HashMap<String, String>();
    HashMap<String, Peer> terminales = new HashMap<String, Peer>();
    //Creamos el registro RMI para poder recuperar de ahi los objetos que se iran pidiendo una vez establecida la conexion
    String location = "//" + ConfiguracionGeneral.getHostRmiRegistry() + ":" + ConfiguracionGeneral.getPuertoRmiRegistry() + "/" + ConfiguracionGeneral.getPathRmiDelRegistrador();
    Registrador registro = null;
    try {

      registro = (Registrador) Naming.lookup(location);//se busca o se intenta buscar por la localizacion dada
    } catch (Exception e) {
      System.out.println("No se puede recuperar el objeto que se encuentra en " + location);
      e.printStackTrace();
      System.exit(-1);
    }


    ServidorHttpDelTerminal httpServer = new ServidorHttpDelTerminal(ConfiguracionGeneral.getPuertoHttp(), credencial, usuarios, terminales, ConfiguracionGeneral.getDirectorioDeUsuarios(), registro);
    //Comienza el servidor!
    httpServer.start();

    while (true) {
      try {
        Thread.sleep(1000);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
  }
}


