package es.urjc.escet.gsyc.rmi;

import es.urjc.escet.gsyc.p2p.User;
import lombok.EqualsAndHashCode;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@EqualsAndHashCode
public class Registration extends UnicastRemoteObject implements Registrable {

  private static Registration instance;
  private Map<String, User> userMap; // nick, user
  private Map<String, char[]> keyMap; // nick, key

  private Registration() throws RemoteException {
    userMap = new HashMap<>();
    keyMap = new HashMap<>();
  }

  public static Registration getInstance() throws RemoteException {
    if (instance == null) {
      instance = new Registration();
    }
    return instance;
  }

  @Override
  //TODO encrypt key
  public void signUp(@NonNull User user, @NonNull char[] password) {
    if (userMap.containsKey(user.getNick())) {
      if (Arrays.equals(keyMap.get(user.getNick()), password)) {
        log.info("No changes!");
      } else {
        userMap.put(user.getNick(), user);
        keyMap.put(user.getNick(), password);
        log.info("User {} registered!", user.getNick());
      }
    } else {
      userMap.put(user.getNick(), user);
      keyMap.put(user.getNick(), password);
      log.info("User {} registered!", user.getNick());
    }
  }

  @Override
  public void dismiss(@NonNull String nick) {
    if (userMap.containsKey(nick)) {
      userMap.remove(nick);
      keyMap.remove(nick);
    } else {
      throw new IllegalArgumentException(String.format("[%s] does not exist! Cannot dismiss!", nick));
    }
  }

  @Override
  public User getUser(String nick) {
    return userMap.get(nick);
  }

  @Override
  public List<User> getAllUser() {
    return userMap.values().stream().collect(Collectors.toList());
  }

  @Override
  public List<String> getFiles(String nick) throws RemoteException {
    List<String> fileList = Collections.emptyList();
    if (userMap.containsKey(nick)) {
      User user = userMap.get(nick);
      try (var pathStream = Files.list(Path.of(URLDecoder.decode(user.getUserPath(), StandardCharsets.UTF_8)))) {
        fileList = pathStream.map(path -> path.getFileName().toString()).collect(Collectors.toList());
      } catch (IOException ioException) {
        log.error("Cannot read folder [{}]", user.getUserPath(), ioException);
      }
    }
    return fileList;
  }
}
