package es.urjc.escet.gsyc.http;

import es.urjc.escet.gsyc.p2p.User;
import es.urjc.escet.gsyc.rmi.Registrable;
import lombok.SneakyThrows;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.UUID;

@ExtendWith(MockitoExtension.class)
class RequestHttpProviderTest {

  private static final String REQUEST_INPUT = "GET /";
  private static final String HTTP_1_1 = " HTTP/1.1";

  private RequestHttpProvider requestHttpProvider;
  @Mock
  private Registrable remote;
  @Mock
  private Socket socket;

  @SneakyThrows
  @BeforeEach
  void beforeTest() {
    requestHttpProvider = new RequestHttpProvider(remote, new HashMap<>(), new HashMap<>());
    Mockito.when(socket.getOutputStream()).thenReturn(new ByteArrayOutputStream());
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestIndex() {
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(createRequestUrl(StringUtils.EMPTY).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestRegister() {
    String user = RandomStringUtils.randomAlphabetic(5);
    String password = RandomStringUtils.randomAlphanumeric(10);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("register?nick=".concat(user).concat("&").concat("password=").concat(password)).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestRegisterWrongCredentials() {
    String user = RandomStringUtils.randomAlphabetic(5);
    String password = RandomStringUtils.randomAlphanumeric(10);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("register?nick=".concat(user).concat("&").concat("password=").concat(password)).getBytes(StandardCharsets.UTF_8)));
    Mockito.when(remote.getUser(user)).thenReturn(User.builder()
            .nick(user)
            .password(RandomStringUtils.randomAlphanumeric(10).toCharArray())
            .build());
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestRegisterGoodCredentials() {
    String user = RandomStringUtils.randomAlphabetic(5);
    String password = RandomStringUtils.randomAlphanumeric(10);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("register?nick=".concat(user).concat("&").concat("password=").concat(password)).getBytes(StandardCharsets.UTF_8)));
    Mockito.when(remote.getUser(user)).thenReturn(User.builder()
            .nick(user)
            .password(password.toCharArray())
            .build());
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestRegisterWrongArguments() {
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(createRequestUrl("register").getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestRegisterWrongArgumentsAgain() {
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(createRequestUrl("register?nick=&password").getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestRegisterWrongArgumentsOneOnly() {
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(createRequestUrl("register?nick=NICK").getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestMenu() {
    String user = RandomStringUtils.randomAlphabetic(5);
    String password = RandomStringUtils.randomAlphanumeric(10);
    String name = RandomStringUtils.randomAlphabetic(5);
    String email = RandomStringUtils.randomAlphabetic(5);
    String path = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("menu?nick=".concat(user).concat("&")
                    .concat("password=").concat(password).concat("&")
                    .concat("name=".concat(name).concat("&"))
                    .concat("email=").concat(email).concat("&")
                    .concat("userPath=").concat(path)).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestMenuUpdateUserMap() {
    String user = RandomStringUtils.randomAlphabetic(5);
    String password = RandomStringUtils.randomAlphanumeric(10);
    String name = RandomStringUtils.randomAlphabetic(5);
    String email = RandomStringUtils.randomAlphabetic(5);
    String path = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("menu?nick=".concat(user).concat("&")
                    .concat("password=").concat(password).concat("&")
                    .concat("name=".concat(name).concat("&"))
                    .concat("email=").concat(email).concat("&")
                    .concat("userPath=").concat(path)).getBytes(StandardCharsets.UTF_8)));
    var userMap = new HashMap<String, User>();
    userMap.put(user, User.builder()
            .nick(user)
            .password(password.toCharArray())
            .name(name)
            .email(email)
            .userPath(path)
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, new HashMap<>(), userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestMenuUserAlreadyLogged() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("menu?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder().nick(nick).build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestMenuUserAlreadyLoggedButWrongPathVariable() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("menu?idFake=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder().nick(nick).build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestMenuWrongArguments() {
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("menu").getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestMenuWrongArgumentsAgain() {
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("menu?nick=&password=&name=&email&userPath=").getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestMenuWrongTwoArguments() {
    String user = RandomStringUtils.randomAlphabetic(5);
    String password = RandomStringUtils.randomAlphanumeric(10);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("menu?nick="
                    .concat(user)
                    .concat("&")
                    .concat("password=")
                    .concat(password)
                    .concat("&")).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestData() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("data?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestDataUserNotInSession() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("data?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put("FAKE_NICK", User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestDataWrongPathVariable() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("data?idFake=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestDataMoreThanOneArgument() {
    String id = UUID.randomUUID().toString();
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("data?id=".concat(id).concat("&another=yes")).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestList() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("list?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestListUserNotInSession() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("list?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put("FAKE_NICK", User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestListWrongPathVariable() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("list?idFake=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestListMoreThanOneArgument() {
    String id = UUID.randomUUID().toString();
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("list?id=".concat(id).concat("&another=yes")).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestDismiss() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("dismiss?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestDismissUserNotInSession() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("dismiss?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put("FAKE_NICK", User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestDismissWrongPathVariable() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("dismiss?idFake=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestDismissMoreThanOneArgument() {
    String id = UUID.randomUUID().toString();
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("dismiss?id=".concat(id).concat("&another=yes")).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestLogout() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("logout?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestLogoutUserNotInSession() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("logout?id=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put("FAKE_NICK", User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestLogoutWrongPathVariable() {
    String id = UUID.randomUUID().toString();
    String nick = RandomStringUtils.randomAlphabetic(5);
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("logout?idFake=".concat(id)).getBytes(StandardCharsets.UTF_8)));
    var connectionMap = new HashMap<String, String>();
    connectionMap.put(id, nick);
    var userMap = new HashMap<String, User>();
    userMap.put(nick, User.builder()
            .nick(nick)
            .password(RandomStringUtils.randomAlphabetic(10).toCharArray())
            .name(RandomStringUtils.randomAlphabetic(10))
            .email(RandomStringUtils.randomAlphabetic(10))
            .userPath(RandomStringUtils.randomAlphabetic(10))
            .build());
    requestHttpProvider = new RequestHttpProvider(remote, connectionMap, userMap);
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  @SneakyThrows
  @Test
  void testProcessHttpRequestLogoutMoreThanOneArgument() {
    String id = UUID.randomUUID().toString();
    Mockito.when(socket.getInputStream()).thenReturn(new ByteArrayInputStream(
            createRequestUrl("logout?id=".concat(id).concat("&another=yes")).getBytes(StandardCharsets.UTF_8)));
    requestHttpProvider.processHttpRequest(socket);
    Mockito.verify(socket).getInputStream();
  }

  private String createRequestUrl(String path) {
    return REQUEST_INPUT.concat(path).concat(HTTP_1_1);
  }
}
