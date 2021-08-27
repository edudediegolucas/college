package es.urjc.escet.gsyc.peer;

import es.urjc.escet.gsyc.config.ConfigException;
import es.urjc.escet.gsyc.http.Constantes;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Peer {

  public Peer(String nick, String credencial, File archivo) throws ConfigException {
    PeerConstantes.nick = nick;
    PeerConstantes.credencial = credencial;
    FileInputStream fis = null;
    try {
      fis = new FileInputStream(archivo);
    } catch (IOException e) {
      ConfigException ce = new ConfigException();
      ce.setMensajeDeError("No se puede abrir el fichero de configuracion " + archivo);

      ce.initCause(e);
      throw ce;
    }

    BufferedReader lector = new BufferedReader(new InputStreamReader(fis));
        /*
         * ARCHIVO EJEMPLO:
        PUERTO_P2P: 0
        DIRECTORIO_EXPORTADO: C:/ST2/archivos
        NICK: nick
        NOMBRE_COMPLETO: nombre
        CORREO_ELECTRONICO: alguien@web.com
        CLAVE: clave
		*/
    String puerto = leeParametro(lector, Constantes.PUERTOP2P);
    //transformamos el puerto de String a entero para que se pueda manejar mejor:
    try {
      PeerConstantes.puertop2p = Integer.parseInt(puerto);
    } catch (NumberFormatException e) {
      ConfigException ce = new ConfigException();
      ce.setMensajeDeError("En el fichero de configuracion " +
              archivo +
              " el parametro " +
              Constantes.PUERTOP2P +
              " debe ser un entero");

      throw ce;
    }


    PeerConstantes.directorio_exportado = leeParametro(lector, Constantes.DIRECTORIO_EXPORTADO);
    File nuevo_directorio = new File(PeerConstantes.directorio_exportado);
    if (!nuevo_directorio.isDirectory() || !nuevo_directorio.canRead()) {
      ConfigException ce = new ConfigException();
      ce.setMensajeDeError("En el fichero de configuracion " +
              archivo +
              " el valor " + PeerConstantes.directorio_exportado +
              " del parametro " + Constantes.DIRECTORIO_EXPORTADO +
              " no es un directorio valido");

      throw ce;
    }


    PeerConstantes.nick = leeParametro(lector, Constantes.NICK);
    PeerConstantes.nombre_completo = leeParametro(lector, Constantes.NOMBRE_COMPLETO);
    PeerConstantes.correo_electronico = leeParametro(lector, Constantes.CORREO);
    PeerConstantes.clave = leeParametro(lector, Constantes.CLAVE);

    try {
      lector.close();
    } catch (IOException e) {
      ConfigException ce = new ConfigException();
      ce.setMensajeDeError("No se puede cerrar el fichero de configuracion " + archivo);

      throw ce;
    }

  }

  //creamos un metodo que nos ayudara a leer el archivo guardado durante el registro
  //esta copiado del metodo leeParametro de LectorDeConfiguracion
  private static String leeParametro(BufferedReader config, String parametro) throws ConfigException {
    try {
      String line = config.readLine();
      String regEx = "^" + parametro + "\\s+\"([^\"]*)\"$";

      Pattern p = Pattern.compile(regEx);
      Matcher m = p.matcher(line);
      if (!m.matches()) {
        ConfigException ce = new ConfigException();
        ce.setMensajeDeError("El parametro " + parametro + " no esta definido");
        System.out.println("El parametro " + parametro + " no esta definido");

        throw ce;
      }

      return m.group(1);

    } catch (IOException e) {
      ConfigException ce = new ConfigException();
      ce.setMensajeDeError("No se puede leer el parametro " + parametro + " del fichero de configuracion");

      throw ce;
    }
  }

  private void mostrar_archivos() {
    //Metodo que nos ayudara a mostrar los archivos
    try {
      File todo = new File(PeerConstantes.directorio_exportado);

      PeerConstantes.archivos = todo.list();

    } catch (Exception e) {
      System.out.println("Error al listar los archivos.");
    }
  }

  public void darCredencial(String credencial) {
    PeerConstantes.credencial = credencial;
  }

  public int getPuertoP2P() {
    return PeerConstantes.puertop2p;
  }

  public String getDirectorio() {
    return PeerConstantes.directorio_exportado;
  }

  public String getNick() {
    return PeerConstantes.nick;
  }

  public String getNombre() {
    return PeerConstantes.nombre_completo;
  }

  public String getCorreo() {
    return PeerConstantes.correo_electronico;
  }

  public String getClave() {
    return PeerConstantes.clave;
  }

  public String getCredencial() {
    return PeerConstantes.credencial;
  }

  public String[] getarchivos() {
    mostrar_archivos();
    return PeerConstantes.archivos;
  }


}//PEER


