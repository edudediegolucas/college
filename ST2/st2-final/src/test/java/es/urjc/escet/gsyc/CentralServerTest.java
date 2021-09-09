package es.urjc.escet.gsyc;

import com.ginsberg.junit.exit.ExpectSystemExit;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

class CentralServerTest {

  @ExpectSystemExit
  @Test
  void testCentralServerMainNoArguments() {
    CentralServer.main(new String[0]);
  }

  @Test
  void testCentralServerMain() {
    CentralServer.main(new String[]{"127.0.0.1", "1099"});
  }

  @ExpectSystemExit
  @Test
  @Disabled("RMI Exception")
  void testCentralServerMainInvalidIp() {
    CentralServer.main(new String[]{RandomStringUtils.randomAlphabetic(4), "1099"});
  }

  @ExpectSystemExit
  @Test
  @Disabled("RMI Exception")
  void testCentralServerMainInvalidPort() {
    CentralServer.main(new String[]{"127.0.0.1", RandomStringUtils.randomAlphabetic(4)});
  }
}
