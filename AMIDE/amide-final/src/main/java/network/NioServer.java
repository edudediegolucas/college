package network;

public class NioServer {//implements Runnable {
//  //Lista de objetos
//  public ArrayList<GameObject> objects = new ArrayList<GameObject>();
//  public GameEngine gEngine;
//  // The host:port combination to listen on
//  private final InetAddress hostAddress;
//  private final int port;
//  // The channel on which we'll accept connections
//  private ServerSocketChannel serverChannel;
//  // The selector we'll be monitoring
//  private final Selector selector;
//  // The buffer into which we'll read data when it's available
//  private final ByteBuffer readBuffer = ByteBuffer.allocate(8192);
//  //Lista de workers
//  private final ArrayList<EchoWorker> workers;
//  private int conexiones = 0;
//  // A list of PendingChange instances
//  private final List<ChangeRequest> pendingChanges = new LinkedList<ChangeRequest>();
//  // Maps a SocketChannel to a list of ByteBuffer instances
//  private final Map<SocketChannel, List<ByteBuffer>> pendingData = new HashMap<SocketChannel, List<ByteBuffer>>();
//  //Mapa de workers y conexiones
//  private final Map<SocketChannel, EchoWorker> mapaWorkers = new HashMap<SocketChannel, EchoWorker>();
//
//  public NioServer(InetAddress hostAddress, int port, ArrayList<EchoWorker> workers, GameEngine gEngine) throws IOException {
//    this.hostAddress = hostAddress;
//    this.port = port;
//    this.selector = this.initSelector();
//    this.workers = workers;
//    this.gEngine = gEngine;
//  }
//
//  public ArrayList<GameObject> getObjects() {
//    return this.objects;
//  }
//
//  public void send(SocketChannel socket, byte[] data) {
//    synchronized (this.pendingChanges) {
//      // Indicate we want the interest ops set changed
//      this.pendingChanges.add(new ChangeRequest(socket, ChangeRequest.CHANGEOPS, SelectionKey.OP_WRITE));
//
//      // And queue the data we want written
//      synchronized (this.pendingData) {
//        List<ByteBuffer> queue = this.pendingData.get(socket);
//        if (queue == null) {
//          queue = new ArrayList<ByteBuffer>();
//          this.pendingData.put(socket, queue);
//        }
//        queue.add(ByteBuffer.wrap(data));
//      }
//    }
//
//    // Finally, wake up our selecting thread so it can make the required changes
//    this.selector.wakeup();
//  }
//
//  public void run() {
//    while (true) {
//      try {
//
//        // Process any pending changes
//        synchronized (this.pendingChanges) {
//          Iterator<ChangeRequest> changes = this.pendingChanges.iterator();
//          while (changes.hasNext()) {
//            ChangeRequest change = changes.next();
//            switch (change.type) {
//              case ChangeRequest.CHANGEOPS:
//                SelectionKey key = change.socket.keyFor(this.selector);
//                key.interestOps(change.ops);
//            }
//          }
//          this.pendingChanges.clear();
//        }
//
//        // Wait for an event one of the registered channels
//        this.selector.select();
//
//        // Iterate over the set of keys for which events are available
//        Iterator<SelectionKey> selectedKeys = this.selector.selectedKeys().iterator();
//        while (selectedKeys.hasNext()) {
//          SelectionKey key = selectedKeys.next();
//          selectedKeys.remove();
//
//          if (!key.isValid()) {
//            continue;
//          }
//
//          // Check what event is available and deal with it
//          if (key.isAcceptable()) {
//            this.accept(key);
//          } else if (key.isReadable()) {
//            this.read(key);
//          } else if (key.isWritable()) {
//            this.write(key);
//          }
//        }
//      } catch (Exception e) {
//        e.printStackTrace();
//      }
//    }
//  }
//
//  private void accept(SelectionKey key) throws IOException {
//    // For an accept to be pending the channel must be a server socket channel.
//    ServerSocketChannel serverSocketChannel = (ServerSocketChannel) key.channel();
//
//    // Accept the connection and make it non-blocking
//    SocketChannel socketChannel = serverSocketChannel.accept();
//    //Socket socket = socketChannel.socket();
//    socketChannel.configureBlocking(false);
//
//    // Register the new SocketChannel with our Selector, indicating
//    // we'd like to be notified when there's data waiting to be read
//    socketChannel.register(this.selector, SelectionKey.OP_READ);
//
//    //Vemos cuantas conexiones hay abiertas
//    this.conexiones++;
//    System.out.println("SERVIDOR: tengo " + conexiones + " conexion abierta(s).");
//    //Cada hilo worker llevara como mucho 3 conexiones abiertas
//    if (this.conexiones <= 3)
//      this.mapaWorkers.put(socketChannel, this.workers.get(0));
//    else if (this.conexiones <= 6)
//      this.mapaWorkers.put(socketChannel, this.workers.get(1));
//    else if (this.conexiones <= 9)
//      this.mapaWorkers.put(socketChannel, this.workers.get(2));
//    else if (this.conexiones <= 12)
//      this.mapaWorkers.put(socketChannel, this.workers.get(3));
//    else if (this.conexiones <= 15)
//      this.mapaWorkers.put(socketChannel, this.workers.get(4));
//
//  }
//
//  private void read(SelectionKey key) throws IOException {
//    SocketChannel socketChannel = (SocketChannel) key.channel();
//
//    // Clear out our read buffer so it's ready for new data
//    this.readBuffer.clear();
//
//    while (!readAndParse(socketChannel)) {
//
//    }
//
//  }
//
//  private final boolean readAndParse(SocketChannel socketchannel) {
//
//    EchoWorker w;
//    //
//    // Try to read from the socket.
//    // If it fails, close the connection.
//    //
//    int nbytes;
//    try {
//      nbytes = socketchannel.read(this.readBuffer);
//
//      if (-1 == nbytes) {
//        //Channel has EOF, closing channel.
//        return true;
//      }
//    } catch (AsynchronousCloseException acex) {
//      //Channel has been closed asynchronously, closing channel
//      //el canal.close();
//      return true;                        // --> LEAVE
//    } catch (ClosedChannelException ccex) {
//      //Channel has been closed, closing channel
//
//      //el canal.close();
//      return true;                        // --> LEAVE
//    } catch (IOException ioex) {
//      //Problem reading from channel, closing channel
//      //el canal.close();
//      return true;                        // --> LEAVE
//    }
//    //
//    // Prepare buffer for reading.
//    //
//    this.readBuffer.flip();
//    //
//    // Parse the buffer and make BusTickets from it.
//    // Notify the listeners about what happened.
//    //
//    ByteBuffer ticketbuffer = null;
//    short ticketlen = 0;
//
//    while (this.readBuffer.position() + 1 < this.readBuffer.limit()) {
//      // Can we read at least one short completely?
//      if (this.readBuffer.remaining() < 2) {
//        this.readBuffer.compact();
//        return false;                   // --> LEAVE, we are NOT ready!
//      }
//
//      // Retrieve length of the message.
//      ticketlen = this.readBuffer.getShort();
//
//      //
//      // Is the following ticket completely in the buffer?
//      //
//      //System.out.println("ticketlen:" + ticketlen);
//      //System.out.println("this.readBuffer.remaining():" + this.readBuffer.remaining());
//
//      if (ticketlen > this.readBuffer.remaining()) {
//
//        // Step back two byte to set reading position at the length-short again.
//
//        this.readBuffer.position(this.readBuffer.position() - 2);
//        this.readBuffer.compact();
//        return false;                   // --> LEAVE, we are NOT ready!
//      }
//
//      // Grap a suitable copy of the buffer.
//      //System.out.println("position"+this.readBuffer.position());
//      ticketbuffer = this.readBuffer.slice();
//
//      // Configure it to its nominal size.
//      ticketbuffer.limit(ticketlen);
//
//      // Move buffer reading position forward
//      this.readBuffer.position(this.readBuffer.position() + ticketlen);
//    }
//
//    //Se lo paso al worker correspondiente del socketChannel
//    w = this.mapaWorkers.get(socketchannel);
//    w.processData(this, socketchannel, ticketbuffer.array(), ticketlen);
//
//    return true;
//
//  }
//
//
//  private void write(SelectionKey key) throws IOException {
//    SocketChannel socketChannel = (SocketChannel) key.channel();
//
//    synchronized (this.pendingData) {
//      List<ByteBuffer> queue = this.pendingData.get(socketChannel);
//
//      // Write until there's not more data ...
//      while (!queue.isEmpty()) {
//        ByteBuffer buf = queue.get(0);
//        socketChannel.write(buf);
//        if (buf.remaining() > 0) {
//          // ... or the socket's buffer fills up
//          break;
//        }
//        queue.remove(0);
//      }
//
//      if (queue.isEmpty()) {
//        // We wrote away all data, so we're no longer interested
//        // in writing on this socket. Switch back to waiting for
//        // data.
//        key.interestOps(SelectionKey.OP_READ);
//      }
//    }
//  }
//
//  private Selector initSelector() throws IOException {
//    // Create a new selector
//    Selector socketSelector = SelectorProvider.provider().openSelector();
//
//    // Create a new non-blocking server socket channel
//    this.serverChannel = ServerSocketChannel.open();
//    serverChannel.configureBlocking(false);
//
//    // Bind the server socket to the specified address and port
//    InetSocketAddress isa = new InetSocketAddress(this.hostAddress, this.port);
//    serverChannel.socket().bind(isa);
//
//    // Register the server socket channel, indicating an interest in
//    // accepting new connections
//    serverChannel.register(socketSelector, SelectionKey.OP_ACCEPT);
//
//    return socketSelector;
//  }
}
