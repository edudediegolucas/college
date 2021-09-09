package es.urjc.escet.gsyc.p2p;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.io.Serializable;

@Getter
@Builder(toBuilder = true)
@Slf4j
@EqualsAndHashCode
public class User implements Serializable {

  private String nick;
  private String name;
  private String email;
  private String host;
  private int port;
  private char[] password; //TODO encrypt key
  private String userPath;
  
  @Getter
  @AllArgsConstructor(access = AccessLevel.PACKAGE)
  public enum Arguments {
    NICK("nick"),
    NAME("name"),
    EMAIL("email"),
    HOST("host"), PORT("port"),
    PASSWORD("password"),
    USER_PATH("userPath"),
    ID("id");
    private String value;
  }
}
