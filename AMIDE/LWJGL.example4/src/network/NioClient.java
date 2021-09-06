package network;


import graphics.Asteroid;
import graphics.GameEngine;
import graphics.GameObject;
import graphics.Space;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.channels.AsynchronousCloseException;
import java.nio.channels.ClosedChannelException;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.nio.channels.spi.SelectorProvider;
import java.util.*;

public class NioClient implements Runnable {
	// The host:port combination to connect to
	private InetAddress hostAddress;
	private int port;

SocketChannel socket = null;
	
	// The selector we'll be monitoring
	private Selector selector;

	// The buffer into which we'll read data when it's available
	private ByteBuffer readBuffer = ByteBuffer.allocate(8192);

	// A list of PendingChange instances
	private List<ChangeRequest> pendingChanges = new LinkedList<ChangeRequest>();

	// Maps a SocketChannel to a list of ByteBuffer instances
	private Map<SocketChannel,List<ByteBuffer>> pendingData = new HashMap<SocketChannel,List<ByteBuffer>>();
	
	// Maps a SocketChannel to a RspHandler
	private Map<SocketChannel,RspHandler> rspHandlers = Collections.synchronizedMap(new HashMap<SocketChannel,RspHandler>());
	
	//Lista de objetos
	private static ArrayList<GameObject> objects = new ArrayList<GameObject>();
	
	public NioClient(InetAddress hostAddress, int port, ArrayList<GameObject> objects) throws IOException {
		this.hostAddress = hostAddress;
		this.port = port;
		this.selector = this.initSelector();
		this.connect();
		this.objects = objects;
	}
	
	public void connect() throws IOException{
		// Start a new connection
		socket = this.initiateConnection();
		
		// Apuntamos el socket a pendingData.
		List<ByteBuffer> queue = this.pendingData.get(socket);
		if (queue == null) {
			queue = new ArrayList<ByteBuffer>();
			this.pendingData.put(socket, queue);
		}
		
		// Wake up our selecting thread so it can make the required changes
		this.selector.wakeup();		
	}

	public void send(byte[] data, RspHandler handler) throws IOException {
		// Start a new connection
		//SocketChannel socket = this.initiateConnection();
		
		synchronized (this.pendingChanges) {
			// Indicate we want the interest ops set changed
			this.pendingChanges.add(new ChangeRequest(socket, ChangeRequest.CHANGEOPS, SelectionKey.OP_WRITE));
			// Register the response handler
			this.rspHandlers.put(socket, handler);
			
			// And queue the data we want written
			synchronized (this.pendingData) {
				List<ByteBuffer> queue = this.pendingData.get(socket);
				if (queue == null) {
					queue = new ArrayList<ByteBuffer>();
					this.pendingData.put(socket, queue);
				}
				queue.add(ByteBuffer.wrap(data));
			}
		}

		// Finally, wake up our selecting thread so it can make the required changes
		this.selector.wakeup();
	}

	public void run() {
		while (true) {
			try {
				// Process any pending changes
				synchronized (this.pendingChanges) {
					Iterator<ChangeRequest> changes = this.pendingChanges.iterator();
					while (changes.hasNext()) {
						ChangeRequest change = (ChangeRequest) changes.next();
						switch (change.type) {
						case ChangeRequest.CHANGEOPS:
							SelectionKey key = change.socket.keyFor(this.selector);
							key.interestOps(change.ops);
							break;
						case ChangeRequest.REGISTER:
							change.socket.register(this.selector, change.ops);
							break;
						}
					}
					this.pendingChanges.clear();
				}

				// Wait for an event one of the registered channels
				this.selector.select();

				// Iterate over the set of keys for which events are available
				Iterator<SelectionKey> selectedKeys = this.selector.selectedKeys().iterator();
				while (selectedKeys.hasNext()) {
					SelectionKey key = (SelectionKey) selectedKeys.next();
					selectedKeys.remove();

					if (!key.isValid()) {
						continue;
					}

					// Check what event is available and deal with it
					if (key.isConnectable()) {
						this.finishConnection(key);
					} else if (key.isReadable()) {
						this.read(key);
					} else if (key.isWritable()) {
						this.write(key);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	
	/*
	private void read(SelectionKey key) throws IOException {
		SocketChannel socketChannel = (SocketChannel) key.channel();

		// Clear out our read buffer so it's ready for new data
		this.readBuffer.clear();

		// Attempt to read off the channel
		int numRead;
		try {
			numRead = socketChannel.read(this.readBuffer);
		} catch (IOException e) {
			// The remote forcibly closed the connection, cancel
			// the selection key and close the channel.
			key.cancel();
			socketChannel.close();
			return;
		}

		if (numRead == -1) {
			// Remote entity shut the socket down cleanly. Do the
			// same from our end and cancel the channel.
			key.channel().close();
			key.cancel();
			return;
		}

		// Handle the response
		this.handleResponse(socketChannel, this.readBuffer.array(), numRead);
	}
	*/
	
	private void read(SelectionKey key) throws IOException {
		SocketChannel socketChannel = (SocketChannel) key.channel();

		// Clear out our read buffer so it's ready for new data
		this.readBuffer.clear();
		
		while (!readAndParse(socketChannel)) {
			
        }
		
	}

	private final boolean readAndParse(SocketChannel socketchannel) {

		//
		// Try to read from the socket.
		// If it fails, close the connection.
		//
		int nbytes;
		try {
			nbytes = socketchannel.read(this.readBuffer);

			if (-1 == nbytes) {
				//Channel has EOF, closing channel.
				return true;
			}
		}catch (AsynchronousCloseException acex) {
			//Channel has been closed asynchronously, closing channel
			//el canal.close();
			return true;                        // --> LEAVE
		}catch (ClosedChannelException ccex) {
			//Channel has been closed, closing channel

			//el canal.close();
			return true;                        // --> LEAVE
		}catch (IOException ioex) {
			//Problem reading from channel, closing channel
			//el canal.close();
			return true;                        // --> LEAVE
		}
		//
		// Prepare buffer for reading.
		//
		this.readBuffer.flip();
		//
		// Parse the buffer and make BusTickets from it.
		// Notify the listeners about what happened.
		//
		ByteBuffer ticketbuffer = null;
		short ticketlen = 0;
		
		while (this.readBuffer.position()+1 < this.readBuffer.limit()) {
			// Can we read at least one short completely?
			if (this.readBuffer.remaining() < 2) {
				this.readBuffer.compact();
				return false;                   // --> LEAVE, we are NOT ready!
			}
			
			// Retrieve length of the message.
			ticketlen = this.readBuffer.getShort();
 
			//
			// Is the following ticket completely in the buffer?
			//
			//System.out.println("ticketlen:" + ticketlen);
			//System.out.println("this.readBuffer.remaining():" + this.readBuffer.remaining());
           
			if (ticketlen > this.readBuffer.remaining()) {
            
				// Step back two byte to set reading position at the length-short again.

				this.readBuffer.position(this.readBuffer.position() - 2);
				this.readBuffer.compact();
				return false;                   // --> LEAVE, we are NOT ready!
			}

			// Grap a suitable copy of the buffer.
			//System.out.println("position"+this.readBuffer.position());
			ticketbuffer = this.readBuffer.slice();

			// Configure it to its nominal size.
			ticketbuffer.limit((int) ticketlen);

			// Move buffer reading position forward
			this.readBuffer.position(this.readBuffer.position() + ticketlen);
		}
		
		//String message = new String(ticketbuffer.array());
		//System.out.println("mensaje:"+message);
		
		try {
			this.handleResponse(socketchannel, ticketbuffer.array(), ticketlen);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return true;
		
    }
	
	private void handleResponse(SocketChannel socketChannel, byte[] data, int numRead) throws IOException {
		// Make a correctly sized copy of the data before handing it
		// to the client
		byte[] rspData = new byte[numRead];
		System.arraycopy(data, 2, rspData, 0, numRead);
		
		// Look up the handler for this channel
		RspHandler handler = (RspHandler) this.rspHandlers.get(socketChannel);
		
		// And pass the response to it
		handler.handleResponse(rspData, numRead);
	}

	private void write(SelectionKey key) throws IOException {
		SocketChannel socketChannel = (SocketChannel) key.channel();

		synchronized (this.pendingData) {
			List<ByteBuffer> queue = this.pendingData.get(socketChannel);

			// Write until there's not more data ...
			while (!queue.isEmpty()) {
				ByteBuffer buf = (ByteBuffer) queue.get(0);
				socketChannel.write(buf);
				if (buf.remaining() > 0) {
					// ... or the socket's buffer fills up
					break;
				}
				queue.remove(0);
			}

			if (queue.isEmpty()) {
				// We wrote away all data, so we're no longer interested
				// in writing on this socket. Switch back to waiting for
				// data.
				key.interestOps(SelectionKey.OP_READ);
			}
		}
	}

	private void finishConnection(SelectionKey key) throws IOException {
		SocketChannel socketChannel = (SocketChannel) key.channel();
	
		// Finish the connection. If the connection operation failed
		// this will raise an IOException.
		try {
			socketChannel.finishConnect();
		} catch (IOException e) {
			// Cancel the channel's registration with our selector
			System.out.println(e);
			key.cancel();
			return;
		}
	
		// Register an interest in writing on this channel
		key.interestOps(SelectionKey.OP_WRITE);
	}

	private SocketChannel initiateConnection() throws IOException {
		// Create a non-blocking socket channel
		SocketChannel socketChannel = SocketChannel.open();
		socketChannel.configureBlocking(false);
	
		// Kick off connection establishment
		socketChannel.connect(new InetSocketAddress(this.hostAddress, this.port));
	
		// Queue a channel registration since the caller is not the 
		// selecting thread. As part of the registration we'll register
		// an interest in connection events. These are raised when a channel
		// is ready to complete connection establishment.
		synchronized(this.pendingChanges) {
			this.pendingChanges.add(new ChangeRequest(socketChannel, ChangeRequest.REGISTER, SelectionKey.OP_CONNECT));
		}
		
		return socketChannel;
	}

	private Selector initSelector() throws IOException {
		// Create a new selector
		return SelectorProvider.provider().openSelector();
	}
	
	public static byte[] aplanarArray(ArrayList<GameObject> objects){
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		ObjectOutputStream oos;
		try {
			oos = new ObjectOutputStream(bos);
			oos.writeObject(objects);
			oos.flush();
			oos.close();
			bos.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		byte[] data = bos.toByteArray();
		return data;
		
	}

	public static void main(String[] args) {
		try {
			//Parte grafica			
			GameEngine gEngine = new GameEngine();
			new Thread(gEngine).start();
			
			//Se crea el cliente
			NioClient client = new NioClient(InetAddress.getByName("192.168.1.33"),9090, gEngine.objects);
			Thread t = new Thread(client);
			t.setDaemon(true);
			t.start();
			
			//Manejador
			Random generator = new Random();
			int id = generator.nextInt(50);
			RspHandler handler = new RspHandler(id,objects);
			
			//Otras variables
			int n = 0;
			Float f;
			
			//Espero a que se creen tranquilamente los asteroides
			t.sleep(1500);
			while(true){
				
				//Refresco el mundo cada 50 ms
				t.sleep(50);
				
				//Enviamos todos los objetos una vez nos conectamos...
				byte[] data = null;
				handler.clearRsp();
				data = aplanarArray(gEngine.objects);
				short tam = (short) data.length;
				ByteBuffer buf = ByteBuffer.allocate(data.length+2);
				buf.clear();
				buf.putShort(tam);
				buf.put(data);
				client.send(buf.array(), handler);
				
				//Espero los asteroides desde el servidor
				handler.clearRsp();
				objects = handler.repuestaServer();
				
				synchronized(gEngine.objects){
					for(GameObject obj : objects){
						for(GameObject old : gEngine.objects){
							if(!obj.esEspacio)
								if(obj.getID() != old.getID())
									n++;
						}
						if(n == gEngine.objects.size()){
							if(!obj.esEspacio){
								gEngine.addObject(obj);
								n = 0;
							}
						}else{
							n = 0;
							//Actualizar objeto
							for(GameObject old : gEngine.objects){
								if(old.getID() == obj.getID()){
									old.setExactx(obj.getExactx());
									old.setExacty(obj.getExacty());
								}
							}
						}
					}
				}
				
				
				//Queremos saber si ha cambiado la velocidad
				data = null;
				handler.clearRsp();
				String msg = "VELOCIDAD";
				data = msg.getBytes();
				tam = (short) data.length;
				buf = ByteBuffer.allocate(data.length+2);
				buf.clear();
				buf.putShort(tam);
				buf.put(data);
				client.send(buf.array(), handler);
				
				//Esperamos la respuesta
				f = handler.waitForFloat();
				synchronized(gEngine.objects){
					for(GameObject obj: gEngine.objects){
						obj.setV(f);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
