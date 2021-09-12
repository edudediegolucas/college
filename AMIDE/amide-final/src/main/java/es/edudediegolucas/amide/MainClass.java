package es.edudediegolucas.amide;

import lombok.extern.slf4j.Slf4j;
import sounds.SoundEngine;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
public class MainClass {

  public static void main(String... args) {
    SoundEngine soundEngine = SoundEngine.getInstance();
    ExecutorService executorService = Executors.newSingleThreadExecutor();
    executorService.execute(() -> soundEngine.playSound("lets_rock.mp3"));
    executorService.shutdown();
    log.info("Yeah!");
  }
}
