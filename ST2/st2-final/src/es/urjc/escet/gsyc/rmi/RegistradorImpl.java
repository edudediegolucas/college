package es.urjc.escet.gsyc.rmi;

import es.urjc.escet.gsyc.p2p.ListaUsuarios;
import es.urjc.escet.gsyc.p2p.Usuario;

import java.io.File;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.HashMap;


public class RegistradorImpl extends UnicastRemoteObject implements Registrador {

  private HashMap<String, Usuario> usuarios;
  private HashMap<String, String> claves;

  public RegistradorImpl() throws RemoteException {
    usuarios = new HashMap<String, Usuario>();
    claves = new HashMap<String, String>();
  }

  public synchronized String registrar(Usuario usuario, String clave) throws RemoteException {
    if (usuarios.containsKey(usuario.getNick())) {
      //el usuario esta registrado y por tanto aparece en el HashMap de registro
      String claveGuardada = claves.get(usuario.getNick());
      if (claveGuardada != null && claveGuardada.contentEquals(clave)) {
        //si la clave no es la misma...se registra otra vez
        //dentro del HashMap de RMI vamos metiendo los usuarios que se van registrando
        usuarios.put(usuario.getNick(), usuario);
        //hacemos lo mismo con las contrasenias/claves
        claves.put(usuario.getNick(), clave);

        System.out.println("Usuario " + usuario.getNick() + " registrado con exito!");
        return null;
      } else {
        return "Ya existe un usuario registrado con el nick " + usuario.getNick();//Ya existe un usuario registrado...
      }
    } else {
      //el usuario no esta registrado y por tanto hay que registrarlo
      usuarios.put(usuario.getNick(), usuario);
      claves.put(usuario.getNick(), clave);

      System.out.println("Usuario " + usuario.getNick() + " registrado con exito!");
    }
    return null;
  }

  public synchronized String darDeBaja(String nick, String clave) throws RemoteException {
    if (usuarios.get(nick) == null) {
      return "No existe un usuario con tal nick";//no existe el usuario registrado asi
    }
    if (claves.get(nick).contentEquals(clave)) {
      System.out.println("Se va a proceder a la eliminacion del usuario " + nick);
      //Se procede a dar de baja mediante el comando remove del HashMap de Java
      usuarios.remove(nick);
      claves.remove(nick);

      String nombrecfg = new String("/home/al-05-06/edulucas/ST2/usuarios/" + nick + ".cfg");
      //String nombrecfg = new String(ConfiguracionGeneral.getDirectorioDeUsuarios()+ nick + ".cfg");
      //System.out.println(ConfiguracionGeneral.getDirectorioDeUsuarios());
      File archivocfg = new File(nombrecfg);

      if (archivocfg.exists()) {
        try {
          archivocfg.delete();
          System.out.println("Se ha borrado el archivo...");
        } catch (Exception e) {
          System.out.println("ERROR!, No existe el archivo!");
        }
      } else {
        System.out.println("No existe un usuario con tal nick, por tanto el archivo no existe!");
      }

      return null;
    } else {
      System.out.println("ERROR!, claves distintas");
      return "La clave especificada no es valida...lo siento"; //clave no valida...
    }
  }

  public synchronized ListaUsuarios getTodos() throws RemoteException {
    ListaUsuarios lista_usuarios = new ListaUsuarios(new ArrayList<Usuario>(usuarios.values()));
    return lista_usuarios;
  }

  public synchronized Usuario getUsuario(String nick) throws RemoteException {
    return usuarios.get(nick);
  }

}
