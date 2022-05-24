import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting; 
  late IO.Socket _socket;

  SocketService(){
    _initConfig();
  }


  ServerStatus get serverStatus =>  _serverStatus;
  IO.Socket  get socket =>  _socket;
  

  void _initConfig(){

    

    /* IO.Socket socket = IO.io('http://localhost:3000/',{
      'transports':['websocket'],
      'autoConnect':true
    }); */

    _socket = IO.io('http://192.168.0.101:3000',
      OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .enableAutoConnect()// optional
      .build());

    _socket.connect();


    _socket.onConnect((_) {
      print('Client connect');  
      _serverStatus = ServerStatus.online;    
      notifyListeners(); 
    });
  
    _socket.onDisconnect((_)  {
      print('Client disconnect'); 
      _serverStatus = ServerStatus.offline; 
      notifyListeners();
    });


    

    _socket.on('server-message',( data )  {
      print('Server message ${data['msg']}'); 
      
      notifyListeners();
    });

  
   
  }
}