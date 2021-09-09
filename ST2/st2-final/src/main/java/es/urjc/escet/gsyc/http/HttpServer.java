package es.urjc.escet.gsyc.http;

import es.urjc.escet.gsyc.rmi.Registrable;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
@RequiredArgsConstructor
public class HttpServer extends Thread {

  private final int port;
  private final Registrable remote;

  @Override
  public void run() {
    ServerSocket server;
    try {
      server = new ServerSocket(port);
      log.info("---> HttpServer started at {} port", port);
      ExecutorService executorService = Executors.newFixedThreadPool(2);
      RequestHttpProvider requestHttpProvider = new RequestHttpProvider(remote, new HashMap<>(), new HashMap<>());
      while (true) {
        Socket socket = server.accept();
        executorService.execute(() -> requestHttpProvider.processHttpRequest(socket));
        // as it is an infinite loop, cannot call executorService.shutdown()
      }
    } catch (IOException e) {
      log.error("ERROR at HttpServer!", e);
      System.exit(-1);
    }
  }
}
