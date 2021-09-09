package es.urjc.escet.gsyc.http;

import es.urjc.escet.gsyc.rmi.Registrable;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.concurrent.ThreadLocalRandom;

@ExtendWith(MockitoExtension.class)
class HttpServerTest {

  private int port;
  @Mock
  private Registrable registrable;

  @BeforeEach
  void before() {
    port = ThreadLocalRandom.current().nextInt(2000, 3000);
  }

  @Test
  void testHttServerRun() {
    HttpServer httpServer = new HttpServer(port, registrable);
    httpServer.start();
  }
}
