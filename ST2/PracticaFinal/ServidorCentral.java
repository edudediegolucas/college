package PracticaFinal;

import java.rmi.Naming;
import java.rmi.RMISecurityManager;
import java.security.Policy;

import PracticaFinal.es.urjc.escet.gsyc.rmi.*;

public class ServidorCentral {
  
    public static void main(String[] args){
        if (args.length!=2){
            System.out.println("ERROR!, por favor, debe especificar el host y el puerto del servidor de nombres RMI");
            System.exit(-1);
        }
      
        String rmiHost = args[0];
        short rmiPort = (short) Integer.parseInt(args[1]);
      
        if (System.getSecurityManager()==null){
            System.setSecurityManager(new RMISecurityManager());
        }
      
        System.out.println("Lanzando el servidor central..conectado a "+ rmiHost + " con puerto numero "+ rmiPort + "...Esperando conexiones...");
      
        //A continuacion se intenta lanzar el servidor...
       
        try{
            Registrador registro = new RegistradorImpl();
            System.out.println("LANZANDO EL SERVIDOR CENTRAL.................................");
            Naming.rebind("//"+ rmiHost +":"+rmiPort+"/Registrador", registro);
            System.out.println(" ");
            System.out.println("Servidor Iniciado!");
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("ERROR!!, no se ha podido lanzar el servidor....");
          
        }
      
    }

} 