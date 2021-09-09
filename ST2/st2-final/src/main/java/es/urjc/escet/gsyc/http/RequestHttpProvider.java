package es.urjc.escet.gsyc.http;

import es.urjc.escet.gsyc.p2p.User;
import es.urjc.escet.gsyc.rmi.Registrable;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import javax.ws.rs.core.Response;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
public class RequestHttpProvider {

  private static final String PATH_INDEX = "src/main/resources/web/index.html";
  private static final String PATH_ERROR = "src/main/resources/web/error.html";
  private static final String PATH_MENU = "src/main/resources/web/menu.html";
  private static final String PATH_REGISTER = "src/main/resources/web/registration.html";
  private static final String PATH_DATA = "src/main/resources/web/data.html";
  private static final String PATH_LIST = "src/main/resources/web/list.html";

  private static final String REGEX_ID = "$ID$";
  private static final String REGEX_NICK = "$NICK$";
  private static final String REGEX_NAME = "$NAME$";
  private static final String REGEX_EMAIL = "$EMAIL$";
  private static final String REGEX_PATH = "$PATH$";
  private static final String REGEX_USERS = "$USERS$";
  private static final String REGEX_FILES = "$FILES$";

  private static final String LOG_USER_ERROR_LOGIN = "User [{}] with session [{}] does not exists. Please re-login";

  private final Registrable remote;
  private final Map<String, String> connectionMap;
  private final Map<String, User> userMap;

  private int requests;

  public void processHttpRequest(Socket socket) {
    UUID connectionId = UUID.randomUUID();
    try (var reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
         var out = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()))) {
      String httpLine = reader.readLine();
      log.info("[{}] Request #{} -> {}", connectionId, ++requests, httpLine);
      String httpPath = httpLine.split(" ")[1].split("\\?")[0];
      switch (httpPath) {
        case "/":
          generateHtmlResponse(out, Path.of(PATH_INDEX), Response.Status.OK);
          break;
        case "/register":
          performRegister(connectionId, out, httpLine);
          break;
        case "/menu":
          performMenu(connectionId, out, httpLine);
          break;
        case "/data":
          performData(out, httpLine);
          break;
        case "/list":
          performList(out, httpLine);
          break;
        case "/dismiss":
          performDismiss(out, httpLine);
          break;
        case "/logout":
          performLogOut(out, httpLine);
          break;
        default:
          out.print(createResponse(new StringBuilder(getHtmlLines(Path.of(PATH_ERROR))), Response.Status.BAD_REQUEST));
      }
    } catch (IOException ioException) {
      log.error("ERROR at RequestHttProvider!", ioException);
    }
  }

  private void performRegister(UUID connectionId, PrintWriter out, String httpLine) throws IOException {
    String[] arguments;
    arguments = checkArgumentsFromUrl(out, httpLine);
    if (arguments.length == 0)
      return;
    if (arguments.length != 2) {
      generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
      return;
    }
    var argumentNick = arguments[0].split("=");
    //check if nick is present in Map
    var argumentPassword = arguments[1].split("=");
    if (checkCorrectArgument(argumentNick, User.Arguments.NICK) && checkCorrectArgument(argumentPassword, User.Arguments.PASSWORD)) {
      connectionMap.put(connectionId.toString(), argumentNick[1]);
      User userFromRemote = remote.getUser(argumentNick[1]);
      if (Objects.nonNull(userFromRemote)) {
        if (!Arrays.equals(userFromRemote.getPassword(), argumentPassword[1].toCharArray())) {
          //wrong credentials
          log.warn("[{}] -> Wrong credentials!", connectionId);
          generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
          return;
        }
        //user exists
        log.info("[{}] -> Valid user!", connectionId);
        userMap.put(userFromRemote.getNick(), userFromRemote);
        generateHtmlResponseAndReplaceId(out, Path.of(PATH_MENU), connectionId.toString(), Response.Status.OK);
      } else {
        // new user
        log.info("[{}] -> New user!", connectionId);
        User user = User.builder()
                .nick(argumentNick[1])
                .password(argumentPassword[1].toCharArray())
                .build();
        userMap.put(argumentNick[1], user);
        generateHtmlResponse(out, Path.of(PATH_REGISTER), Response.Status.OK);
      }
    } else {
      generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
    }
  }

  private void performMenu(UUID connectionId, PrintWriter out, String httpLine) throws IOException {
    String[] arguments;
    String[] argumentNick;
    String[] argumentPassword;
    arguments = checkArgumentsFromUrl(out, httpLine);
    if (arguments.length == 0)
      return;
    if (arguments.length == 5) {
      // new user
      argumentNick = arguments[0].split("=");
      argumentPassword = arguments[1].split("=");
      var argumentName = arguments[2].split("=");
      var argumentEmail = arguments[3].split("=");
      var argumentPath = arguments[4].split("=");
      if (checkCorrectArgument(argumentNick, User.Arguments.NICK)
              && checkCorrectArgument(argumentPassword, User.Arguments.PASSWORD)
              && checkCorrectArgument(argumentName, User.Arguments.NAME)
              && checkCorrectArgument(argumentEmail, User.Arguments.EMAIL)
              && checkCorrectArgument(argumentPath, User.Arguments.USER_PATH)) {
        User user;
        if (userMap.containsKey(argumentNick[1])) {
          user = userMap.get(argumentNick[1]).toBuilder()
                  .password(argumentPassword[1].toCharArray())
                  .name(argumentName[1])
                  .email(URLDecoder.decode(argumentEmail[1], StandardCharsets.UTF_8))
                  .userPath(URLDecoder.decode(argumentPath[1], StandardCharsets.UTF_8))
                  .build();
        } else {
          user = User.builder()
                  .nick(argumentNick[1])
                  .password(argumentPassword[1].toCharArray())
                  .name(argumentName[1])
                  .email(URLDecoder.decode(argumentEmail[1], StandardCharsets.UTF_8))
                  .userPath(URLDecoder.decode(argumentPath[1], StandardCharsets.UTF_8))
                  .build();
        }
        connectionMap.put(connectionId.toString(), argumentNick[1]);
        userMap.put(argumentNick[1], user);
        remote.signUp(user, argumentPassword[1].toCharArray());
        generateHtmlResponseAndReplaceId(out, Path.of(PATH_MENU), connectionId.toString(), Response.Status.OK);
      } else {
        generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
        return;
      }
    }
    if (arguments.length == 1) {
      var argumentId = arguments[0].split("=");
      if (checkCorrectArgument(argumentId, User.Arguments.ID) && connectionMap.containsKey(argumentId[1])) {
        String nick = connectionMap.get(argumentId[1]);
        if (userMap.containsKey(nick)) {
          generateHtmlResponseAndReplaceId(out, Path.of(PATH_MENU), connectionId.toString(), Response.Status.OK);
        }
      } else {
        generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
      }
      generateHtmlResponse(out, Path.of(PATH_MENU), Response.Status.OK);
    } else {
      generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
    }
  }

  private void performData(PrintWriter out, String httpLine) throws IOException {
    String[] arguments = checkArgumentsFromUrl(out, httpLine);
    if (arguments.length == 0)
      return;
    if (arguments.length == 1) {
      var argumentId = arguments[0].split("=");
      if (checkCorrectArgument(argumentId, User.Arguments.ID) && connectionMap.containsKey(argumentId[1])) {
        String nick = connectionMap.get(argumentId[1]);
        if (userMap.containsKey(nick)) {
          User loggedUser = userMap.get(nick);
          generateHtmlResponseAndReplaceUserAndListOfUsers(out, Path.of(PATH_DATA), loggedUser, remote.getAllUser(), argumentId[1], Response.Status.OK);
        } else {
          //this means that id does not belong to user
          log.warn(LOG_USER_ERROR_LOGIN, nick, argumentId[1]);
          generateHtmlResponse(out, Path.of(PATH_INDEX), Response.Status.OK);
        }
      } else {
        generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
      }
    } else {
      generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
    }
  }

  private void performList(PrintWriter out, String httpLine) throws IOException {
    String[] arguments = checkArgumentsFromUrl(out, httpLine);
    if (arguments.length == 0)
      return;
    if (arguments.length == 1) {
      var argumentId = arguments[0].split("=");
      if (checkCorrectArgument(argumentId, User.Arguments.ID) && connectionMap.containsKey(argumentId[1])) {
        String nick = connectionMap.get(argumentId[1]);
        if (userMap.containsKey(nick)) {
          generateHtmlResponseAndReplaceListOfFiles(out, Path.of(PATH_LIST), remote.getFiles(nick), argumentId[1], Response.Status.OK);
        } else {
          //this means that id does not belong to user
          log.warn(LOG_USER_ERROR_LOGIN, nick, argumentId[1]);
          generateHtmlResponse(out, Path.of(PATH_INDEX), Response.Status.OK);
        }
      } else {
        generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
      }
    } else {
      generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
    }
  }

  private void performDismiss(PrintWriter out, String httpLine) throws IOException {
    String[] arguments = checkArgumentsFromUrl(out, httpLine);
    if (arguments.length == 0)
      return;
    if (arguments.length == 1) {
      var argumentId = arguments[0].split("=");
      if (checkCorrectArgument(argumentId, User.Arguments.ID) && connectionMap.containsKey(argumentId[1])) {
        String nick = connectionMap.get(argumentId[1]);
        if (userMap.containsKey(nick)) {
          userMap.remove(nick);
          connectionMap.remove(argumentId[1]);
          remote.dismiss(nick);
        } else {
          //this means that id does not belong to user
          log.warn(LOG_USER_ERROR_LOGIN, nick, argumentId[1]);
        }
        generateHtmlResponse(out, Path.of(PATH_INDEX), Response.Status.OK);
      } else {
        generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
      }
    } else {
      generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
    }
  }

  private void performLogOut(PrintWriter out, String httpLine) throws IOException {
    String[] arguments = checkArgumentsFromUrl(out, httpLine);
    if (arguments.length == 0)
      return;
    if (arguments.length == 1) {
      var argumentId = arguments[0].split("=");
      if (checkCorrectArgument(argumentId, User.Arguments.ID) && connectionMap.containsKey(argumentId[1])) {
        String nick = connectionMap.get(argumentId[1]);
        if (userMap.containsKey(nick)) {
          userMap.remove(nick);
          connectionMap.remove(argumentId[1]);
        } else {
          //this means that id does not belong to user
          log.warn(LOG_USER_ERROR_LOGIN, nick, argumentId[1]);
        }
        generateHtmlResponse(out, Path.of(PATH_INDEX), Response.Status.OK);
      } else {
        generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
      }
    } else {
      generateHtmlResponse(out, Path.of(PATH_ERROR), Response.Status.BAD_REQUEST);
    }
  }

  private String[] checkArgumentsFromUrl(PrintWriter out, String httpLine) throws IOException {
    String[] arguments;
    try {
      arguments = httpLine.split(StringUtils.SPACE)[1].split("\\?")[1].split("&");
    } catch (ArrayIndexOutOfBoundsException | NullPointerException runtimeException) {
      log.error("ERROR at RequestHttProvider! Not valid arguments", runtimeException);
      out.print(createResponse(new StringBuilder(getHtmlLines(Path.of(PATH_ERROR))), Response.Status.BAD_REQUEST));
      return new String[0];
    }
    return arguments;
  }

  private void generateHtmlResponse(PrintWriter out,
                                    Path htmlPagePath,
                                    Response.Status status) throws IOException {
    out.print(createResponse(new StringBuilder(getHtmlLines(htmlPagePath)), status));
  }

  private void generateHtmlResponseAndReplaceId(PrintWriter out,
                                                Path htmlPagePath,
                                                String id,
                                                Response.Status status) throws IOException {
    out.print(createResponse(new StringBuilder(getHtmlLines(htmlPagePath).replace(REGEX_ID, id)), status));
  }

  private void generateHtmlResponseAndReplaceUserAndListOfUsers(PrintWriter out,
                                                                Path htmlPagePath,
                                                                User user, List<User> userList,
                                                                String id,
                                                                Response.Status status) throws IOException {
    out.print(createResponse(new StringBuilder(getHtmlLines(htmlPagePath)
                    .replace(REGEX_NICK, user.getNick())
                    .replace(REGEX_NAME, user.getName())
                    .replace(REGEX_EMAIL, user.getEmail())
                    .replace(REGEX_PATH, user.getUserPath())
                    .replace(REGEX_ID, id)
                    .replace(REGEX_USERS, userList.stream().map(User::getNick).collect(Collectors.joining("</br>")))),
            status));
  }

  private void generateHtmlResponseAndReplaceListOfFiles(PrintWriter out,
                                                         Path htmlPagePath,
                                                         List<String> fileList,
                                                         String id,
                                                         Response.Status status) throws IOException {
    out.print(createResponse(new StringBuilder(getHtmlLines(htmlPagePath)
                    .replace(REGEX_FILES, fileList.stream().collect(Collectors.joining("</br>")))
                    .replace(REGEX_ID, id)),
            status));
  }

  private boolean checkCorrectArgument(String[] argument, User.Arguments userArgument) {
    return StringUtils.isNoneBlank(argument) && argument.length == 2 && argument[0].equals(userArgument.getValue());
  }

  private String getHtmlLines(Path htmlPagePath) throws IOException {
    try (var streamLines = Files.lines(htmlPagePath)) {
      return streamLines.collect(Collectors.joining());
    }
  }

  private StringBuilder createResponse(StringBuilder htmlContent, Response.Status httpStatus) {
    StringBuilder stringBuilder = new StringBuilder("HTTP/1.1" + httpStatus.getStatusCode() + " " + httpStatus.getReasonPhrase() + "\r\n");
    stringBuilder.append("Connection: close\r\n");
    stringBuilder.append("Content-Type: text/html\r\n");
    stringBuilder.append("Content-Length: " + htmlContent.length() + "\r\n");
    stringBuilder.append("\r\n");
    stringBuilder.append(htmlContent);
    return stringBuilder;
  }
}