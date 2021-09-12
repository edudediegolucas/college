package network;

import graphics.GameObject;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.util.ArrayList;
import java.util.List;

public class RspHandler {
  private byte[] rsp = null;
  private final int id;
  private int count;
  private List<GameObject> objects;

  public RspHandler(int id, List<GameObject> objects) {
    this.id = id;
    this.objects = objects;
  }

  public ArrayList<GameObject> desaplanar(byte[] data) {
    ArrayList<GameObject> objects = null;
    try {
      ByteArrayInputStream bis = new ByteArrayInputStream(data);
      ObjectInputStream ois = new ObjectInputStream(bis);
      objects = (ArrayList<GameObject>) ois.readObject();
    } catch (IOException ex) {
      ex.printStackTrace();
    } catch (ClassNotFoundException ex) {
      ex.printStackTrace();
    }
    return objects;
  }

  public synchronized boolean handleResponse(byte[] rsp, int count) {
    this.rsp = rsp;
    this.count = count;
    this.notify();
    return true;
  }

  public synchronized void waitForResponse() {
    while (this.rsp == null) {
      try {
        this.wait();
      } catch (InterruptedException e) {
      }
    }
    System.out.println("[HANDLER-CLIENTE #" + id + "]: respuesta desde el servidor -> " + new String(this.rsp));

  }

  public synchronized float waitForFloat() {
    while (this.rsp == null) {
      try {
        this.wait();
      } catch (InterruptedException e) {
      }
    }
    System.out.println("[HANDLER-CLIENTE #" + id + "]: velocidad actualizada -> " + new String(this.rsp));
    float f = Float.valueOf(new String(this.rsp));
    return f;

  }

  public synchronized List<GameObject> repuestaServer() {
    while (this.rsp == null) {
      try {
        this.wait();
      } catch (InterruptedException e) {
      }
    }
    objects = desaplanar(rsp);
    return objects;
  }

  public synchronized void clearRsp() {
    this.rsp = null;
  }
}
