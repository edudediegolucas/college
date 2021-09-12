package network;

import graphics.GameObject;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;


public class EchoWorker {//implements Runnable {
//  private final List queue = new LinkedList();
//
//
//  public static byte[] aplanarArray(ArrayList<GameObject> objects) {
//    ByteArrayOutputStream bos = new ByteArrayOutputStream();
//    ObjectOutputStream oos;
//    try {
//      oos = new ObjectOutputStream(bos);
//      oos.writeObject(objects);
//      oos.flush();
//      oos.close();
//      bos.close();
//    } catch (IOException e) {
//      e.printStackTrace();
//    }
//    byte[] data = bos.toByteArray();
//    return data;
//
//  }
//
//  public ArrayList<GameObject> desaplanarArray(byte[] data) {
//    ArrayList<GameObject> objects = null;
//    try {
//      ByteArrayInputStream bis = new ByteArrayInputStream(data);
//      ObjectInputStream ois = new ObjectInputStream(bis);
//      objects = (ArrayList<GameObject>) ois.readObject();
//    } catch (IOException ex) {
//      ex.printStackTrace();
//    } catch (ClassNotFoundException ex) {
//      ex.printStackTrace();
//    }
//    return objects;
//  }
//
//  public void processData(NioServer server, SocketChannel socket, byte[] data, int count) {
//    byte[] dataCopy = new byte[count];
//    System.arraycopy(data, 2, dataCopy, 0, count);
//
//    //Procesar el canal
//    String msg = new String(dataCopy);
//    byte[] response = null;
//    ArrayList<GameObject> objects = null;
//    ArrayList<GameObject> allObjects = null;
//    ByteBuffer buf = null;
//
//    if (msg.equals("VELOCIDAD")) {
//      //El cliente nos pregunta si ha cambiado la velocidad. Le enviamos si ha cambiado la velocidad
//      Float v = server.gEngine.objects.get(1).getV();
//      response = v.toString().getBytes();
//
//      short tam = (short) response.length;
//      buf = ByteBuffer.allocate(response.length + 2);
//      buf.clear();
//      buf.putShort(tam);
//      buf.put(response);
//
//    } else {
//      int n = 0;
//      allObjects = null;
//      response = new byte[count];
//      System.arraycopy(data, 2, response, 0, count);
//      objects = desaplanarArray(response);
//
//      synchronized (server.gEngine.outObjects) {
//        if (server.gEngine.outObjects.size() == 0) { //No tengo ningun objeto
//          for (GameObject obj : objects) {
//            if (!obj.esEspacio)
//              server.gEngine.addOutObject(obj);
//          }
//        } else { //ya tengo objectos, actualizo o meto
//          for (GameObject obj : objects) {
//            n = 0;
//            if (!obj.esEspacio) {
//              for (GameObject old : server.gEngine.outObjects) {
//                if (!old.esEspacio) {
//                  if (obj.getID() == old.getID())
//                    n++;
//                }
//              }
//              if (n == 0) //no esta en outObjects, lo meto
//                server.gEngine.addOutObject(obj);
//              else { //esta, actualizo
//                for (GameObject old : server.gEngine.outObjects) {
//                  if (!old.esEspacio) {
//                    if (obj.getID() == old.getID()) {
//                      old.setExactx(obj.getExactx());
//                      old.setExacty(obj.getExacty());
//                      old.setAngle(obj.getAngle());
//                    }
//                  }
//                }
//              }
//            }
//          }
//        }
//      }
//
//      allObjects = null; //(List<GameObject>) server.gEngine.objects.clone();
//
//      for (GameObject obj : server.gEngine.outObjects)
//        allObjects.add(obj);
//
//
//      //Mando TODOS los objetos
//      response = null;
//      response = aplanarArray(allObjects);
//      short tam = (short) response.length;
//      buf = ByteBuffer.allocate(response.length + 2);
//      buf.clear();
//      buf.putShort(tam);
//      buf.put(response);
//
//    }
//
//    synchronized (queue) {
//      queue.add(new ServerDataEvent(server, socket, buf.array()));
//      queue.notify();
//    }
//
//  }
//
//  public void run() {
//    ServerDataEvent dataEvent;
//
//    while (true) {
//      // Wait for data to become available
//      synchronized (queue) {
//        while (queue.isEmpty()) {
//          try {
//            queue.wait();
//          } catch (InterruptedException e) {
//          }
//        }
//        dataEvent = (ServerDataEvent) queue.remove(0);
//      }
//
//      // Return to sender
//      dataEvent.server.send(dataEvent.socket, dataEvent.data);
//    }
//  }
}
