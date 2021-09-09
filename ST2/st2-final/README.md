# ST2 (Sistemas Telemáticos II) - 2007

This is the final assignment for ST2 subject in 2007. It was based
on [RMI](https://www.oracle.com/java/technologies/javase/remote-method-invocation-distributed-computing.html)
technology.

## Before anything...

First two commits of this project are the original structure of the code (no mayor changes). Later changes are big
changes to the project:

* Update to Maven project
* Several refactors in code, imports, etc
* Improvements
* Added html pages
* Some jUnit5 tests

You can build it:

* via Maven, executing ````mvn clean install```` command for example

## What is this about?

We have two main classes, both with ```main``` method:

* ```CentralServer.java```, this class starts an RMI central server at 1099 (or chosen by the user) port.
* ```Terminal.java```, this class starts an RMI client that connects to the RMI central server and opens an HTTP
  connection in other port specified by a configuration file (```p2p.cfg```).

When a __terminal__ is connected, we can launch now a webpage at ```IP:terminal_port```, where a registration page shows
up. After the registration, the user can browse a menu with different options.

## How to run it

### CentralServer

$ java CentralServer [IP] [PORT]

```java CentralServer 127.0.0.1 1099```

```
[main] INFO es.urjc.escet.gsyc.CentralServer - *** LAUNCHING CENTRAL-SERVER ***
[main] INFO es.urjc.escet.gsyc.CentralServer - Preparing CentralServer at 127.0.0.1:1099
[main] INFO es.urjc.escet.gsyc.CentralServer - *** UP & RUNNING! in 447 ms
```

### Terminal

Make sure you have at least one p2p.cfg file with all the configuration. This code has the original (in Spanish)
configuration of that moment.

$ java Terminal [path-of-p2p.cfg]

```java Terminal src/main/resources/p2p-1.cfg```

```
[main] INFO es.urjc.escet.gsyc.Terminal - *** TERMINAL STARTED!***
[main] INFO es.urjc.escet.gsyc.Terminal - *** UP & RUNNING! in 408 ms
[Thread-0] INFO es.urjc.escet.gsyc.http.HttpServer - ---> HttpServer started at 2345 port
[pool-1-thread-1] INFO es.urjc.escet.gsyc.http.RequestHttpProvider - [7ca08fe4-97b6-4176-aa6a-37cb22644380] Request #1 -> GET / HTTP/1.1
```

Once you have one ```Terminal``` up and running, go to a web browser and write the host and port provided. For example:

```localhost:2345```

