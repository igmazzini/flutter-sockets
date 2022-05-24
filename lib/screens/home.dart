import 'dart:io';

import 'package:band_names_app/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
   
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  List<Band> bands = [
    /* Band(id: '1', name: 'Sumo', votes: 5),
    Band(id: '2', name: 'Divididos', votes: 5),
    Band(id: '3', name: 'Patricio rey', votes: 5),
    Band(id: '4', name: 'Las Pelotas', votes: 5),
    Band(id: '5', name: 'La Renga', votes: 5), */
  ];

  @override
  void initState() {
    

    final socketService = Provider.of<SocketService>(context,listen: false);

    socketService.socket.on('active-bands',_handleActiveBands);

    super.initState();
    
  }

  _handleActiveBands( dynamic data ) {

    bands = (data as List)
      .map((b) => Band.fromMap(b) )
      .toList();
        
    setState(() {}); 

  }

  @override
  void dispose() {

    final socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('active-bands');
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context); 

    
    return  Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.online)
              ? Icon(Icons.check_circle, color:Colors.blue[300], semanticLabel: 'Online')
              : const Icon(Icons.offline_bolt, color:Colors.red, semanticLabel: 'Offline',),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: ( BuildContext context, int index) => _bandTile(bands[index])
              ),
          ),
        ],
      ),
        floatingActionButton: FloatingActionButton(onPressed: () => addNewBand(),
        elevation: 1,
        child: const Icon(Icons.add),),
        
    );
  }

  Widget _showGraph() {

    
    if (bands.isNotEmpty) {

      Map<String, double> dataMap =  {};

      for (final band in bands) {
        dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      }


      return Container(
        padding: const EdgeInsets.all(8),
         width:double.infinity,
          height: 200 , 
          child: PieChart(dataMap: dataMap,chartType: ChartType.ring,));

    }else {

      return Container(height: 20,);
    }
    

  }
  Widget _bandTile( Band  band) {

    final socketService = Provider.of<SocketService>(context,listen: false); 

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ){
       
        socketService.socket.emit('delete-band',{'id':band.id});

      },
      background: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.red,
        child: const  Align( alignment: Alignment.centerLeft, child:  Text('Delete band', style: TextStyle(color: Colors.white),)),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text( band.name ),
            trailing: Text('${ band.votes }', style: const TextStyle( fontSize: 20),),
            onTap: (){
              print(band.name);
              socketService.socket.emit('vote-band',{'id':band.id});
             /*  band.votes++;
              setState(() {
                
              }); */
            },
          ),
    );
  }


  addNewBand() {
  
   

    final textController =  TextEditingController();


    if (kIsWeb) {
      
      print('Web!!');
        showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('New band name:'),
          content:  TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: const Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: (){

                addBandToList(textController.text);
              }
              )
          ],
        );
      } );

    } else if(Platform.isAndroid){

      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('New band name:'),
          content:  TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: const Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: (){

                addBandToList(textController.text);
              }
              )
          ],
        );
      } );

    }else{
      showCupertinoDialog(context: context, builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(child: const Text('Add'), isDefaultAction: true, onPressed: addBandToList(textController.text),),
            CupertinoDialogAction(child: const Text('Dismiss'), isDestructiveAction: true, onPressed: () => Navigator.pop(context),)
          ],
        );
      });
    }
  }

  addBandToList( String name ) {
    
    if(name.length > 1){

      final socketService = Provider.of<SocketService>(context,listen: false); 

      socketService.socket.emit('add-band',{'name':name});
    
     
    }

    Navigator.pop(context);
  }
}