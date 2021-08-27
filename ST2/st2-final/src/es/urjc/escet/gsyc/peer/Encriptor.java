package es.urjc.escet.gsyc.peer;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
//import java.io.IOException;

public class Encriptor {

  /**
   * Clase que encripta la URL segun el metodo Caesar
   */
  private int key;

  public Encriptor(int aKey) {
    key = aKey;
  }

  public void encriptarArchivo(File inFile, File outFile) throws IOException {
    InputStream in = null;
    OutputStream out = null;
    try {
      in = new FileInputStream(inFile);
      out = new FileOutputStream(outFile);
      encriptarStream(in, out);
    } finally {
      if (in != null) in.close();
      if (out != null) out.close();
    }
  }

  public void encriptarStream(InputStream in, OutputStream out) throws IOException {
    boolean hecho = false;
    while (!hecho) {
      int next = in.read();
      if (next == -1) hecho = true;
      else {
        byte b = (byte) next;
        byte c = encriptar(b);
        out.write(c);
      }
    }
  }

  public byte encriptar(byte b) {
    return (byte) (b + key);
  }
}
