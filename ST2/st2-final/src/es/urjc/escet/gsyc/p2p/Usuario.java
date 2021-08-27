package es.urjc.escet.gsyc.p2p;

import java.io.Serializable;

public class Usuario implements Serializable {

  //Clase de intercambio a traves de RMI
  private String nick;
  private String correoElectronico;
  private String nombreCompleto;
  private String host;
  private int puertop2p;

  public Usuario(String nick, String correoElectronico, String nombreCompleto, String host, int puertop2p) {
    this.nick = nick;
    this.correoElectronico = correoElectronico;
    this.nombreCompleto = nombreCompleto;
    this.host = host;
    this.puertop2p = puertop2p;

  }

  public String getNick() {
    return nick;
  }

  public String getCorreoElectronico() {
    return correoElectronico;
  }

  public String getNombreCompleto() {
    return nombreCompleto;
  }

  public String getHost() {
    return host;
  }

  public int getPuertop2p() {
    return puertop2p;
  }

}//usuario
