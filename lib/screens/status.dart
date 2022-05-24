import 'package:band_names_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
   
  const StatusScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return  Scaffold(
      body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children:  [
             Text('ServerStatus: ${socketService.serverStatus}'),
           ],
         ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          socketService.socket.emit('client-message',{'msg':'Hola desde flutter'});
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}