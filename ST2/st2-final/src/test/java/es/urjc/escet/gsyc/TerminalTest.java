package es.urjc.escet.gsyc;

import com.ginsberg.junit.exit.ExpectSystemExit;
import org.junit.jupiter.api.Test;

class TerminalTest {

  @ExpectSystemExit
  @Test
  void testTerminalMainNoArguments() {
    Terminal.main(new String[0]);
  }

  @Test
  void testTerminalMain() {
    Terminal.main(new String[]{"src/test/resources/p2p-test.cfg"});
  }
}
