package es.urjc.escet.gsyc.rmi;

import es.urjc.escet.gsyc.p2p.User;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

public interface Registrable extends Remote {

  void signUp(User user, char[] password) throws RemoteException;

  void dismiss(String nick) throws RemoteException;

  User getUser(String nick) throws RemoteException;

  List<User> getAllUser() throws RemoteException;

  List<String> getFiles(String nick) throws RemoteException;
}
