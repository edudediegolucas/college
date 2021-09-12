package sounds;

import javazoom.jl.player.Player;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.io.FileInputStream;

@Slf4j
public class SoundEngine {

  private static final String SOUND_PATH = "src/main/resources/sounds/";
  private static SoundEngine instance;

  private SoundEngine() {
  }

  public static SoundEngine getInstance() {
    if (instance == null) {
      instance = new SoundEngine();
    }
    return instance;
  }

  /**
   * Play a mp3 sound given its fileSound name. It must be used in a new thread context.
   *
   * @param fileSound
   */
  @SneakyThrows
  public void playSound(String fileSound) {
    Player player = new Player(new FileInputStream(SOUND_PATH.concat(fileSound)));
    player.play();
  }
}
