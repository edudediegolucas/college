# ST2 (Sistemas Telemáticos II) - 2007

This is the final assignment for ST2 subject in 2007. It was based on [RMI](https://www.oracle.com/java/technologies/javase/remote-method-invocation-distributed-computing.html) technology.

## Before anything...

First two commits of this project are the original structure of the code (no mayor changes).

You can build it:

* via JDK (I've used OpenJDK 11), ```javac``` command
* via IDE (I've used IntelliJ and establishing ```/bin```as output folder for .class files)
* no dependencies or jars are needed

## What is this about?

We have two main classes, both with ```main``` method:

* ```ServidorCentral.java```, this class starts a RMI central server at 1099 (or chosen by the user) port.
* ```Terminal.java```, this class starts a RMI client that connects to the RMI central server and opens an HTTP connection in other port specified by a configuration file.

When a __terminal__ is connected, we can launch now a webpage at ```IP:terminal_port```, where a registration page shows up. After the registration, the user can browse a menu with different options. 