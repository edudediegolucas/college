package es.urjc.escet.gsyc.config;

public class ConfiguracionGeneral {
  static int puertoHttp;
  static String directorioDeUsuarios;
  static String hostRmiRegistry;
  static int puertoRmiRegistry;
  static String pathRmiDelRegistrador;

  public static int getPuertoHttp() { //obtener puerto de conexion
    return puertoHttp;
  }

  public static String getDirectorioDeUsuarios() { //obtener Directorio de usuarios
    return directorioDeUsuarios;
  }

  public static String getHostRmiRegistry() { //obtener el servicio de registro RMI de Java
    return hostRmiRegistry;
  }

  public static int getPuertoRmiRegistry() { //puerto en el que se encuentra el servicio RMI de Java
    return puertoRmiRegistry;
  }

  public static String getPathRmiDelRegistrador() { //nombre por el que se recupera el objeto registrador desde registro RMI de Java
    return pathRmiDelRegistrador;
  }
}
