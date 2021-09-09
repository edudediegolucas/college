package es.urjc.escet.gsyc.rmi;

import es.urjc.escet.gsyc.p2p.User;
import lombok.SneakyThrows;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.rmi.RemoteException;
import java.util.Objects;

class RegistrationTest {

  private Registrable registrable;
  private String nick;
  private char[] password;
  private User user;

  @SneakyThrows
  @BeforeEach
  void before() {
    registrable = Registration.getInstance();
    nick = RandomStringUtils.randomAlphabetic(5);
    password = RandomStringUtils.randomAlphanumeric(10).toCharArray();
    user = User.builder()
            .nick(nick)
            .name(RandomStringUtils.randomAlphabetic(5))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .password(password)
            .build();
  }

  @SneakyThrows
  @Test
  void testRegistrationCreation() {
    Assertions.assertNotNull(registrable);
  }

  @SneakyThrows
  @Test
  void testSignUp() {
    registrable.signUp(user, password);
    Assertions.assertEquals(nick, registrable.getUser(nick).getNick());
    Assertions.assertEquals(password, registrable.getUser(nick).getPassword());
  }

  @SneakyThrows
  @Test
  void testSignUpChangePassword() {
    final char[] newPassword = RandomStringUtils.randomAlphanumeric(10).toCharArray();
    registrable.signUp(user, password);
    Assertions.assertEquals(nick, registrable.getUser(nick).getNick());
    Assertions.assertEquals(password, registrable.getUser(nick).getPassword());
    user = user.toBuilder()
            .password(newPassword)
            .build();
    registrable.signUp(user, newPassword);
    Assertions.assertEquals(nick, registrable.getUser(nick).getNick());
    Assertions.assertEquals(newPassword, registrable.getUser(nick).getPassword());
  }

  @SneakyThrows
  @Test
  void testDismiss() {
    registrable.signUp(user, password);
    Assertions.assertEquals(nick, registrable.getUser(nick).getNick());
    registrable.dismiss(user.getNick());
    Assertions.assertTrue(Objects.isNull(registrable.getUser(nick)));
  }

  @SneakyThrows
  @Test
  void testDismissUserDoesNotExist() {
    final String fakeNick = RandomStringUtils.randomAlphabetic(1);
    Assertions.assertThrows(IllegalArgumentException.class, () -> registrable.dismiss(fakeNick));
  }

  @Test
  void testGetUser() throws RemoteException {
    registrable.signUp(user, password);
    Assertions.assertEquals(user, registrable.getUser(nick));
  }

  @SneakyThrows
  @Test
  void testGetAllUser() {
    Assertions.assertTrue(registrable.getAllUser().size() > 0);
  }

  @SneakyThrows
  @Test
  void testGetFiles() {
    registrable.signUp(user, password);
    registrable.getFiles(user.getNick());
  }
}
