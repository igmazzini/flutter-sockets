import 'dart:io';

import 'package:band_names_app/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
   
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  List<Band> bands = [
    Band(id: '1', name: 'Sumo', votes: 5),
    Band(id: '2', name: 'Divididos', votes: 5),
    Band(id: '3', name: 'Patricio rey', votes: 5),
    Band(id: '4', name: 'Las Pelotas', votes: 5),
    Band(id: '5', name: 'La Renga', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( BuildContext context, int index) => _bandTile(bands[index])
        ),
        floatingActionButton: FloatingActionButton(onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),),
        
    );
  }

  Widget _bandTile( Band  band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ){
        print('Eliminar: '+band.name);
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
              band.votes++;
              setState(() {
                
              });
            },
          ),
    );
  }


  addNewBand() {

    final textController =  TextEditingController();

    if(Platform.isAndroid){

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
    
      bands.add( Band(id: DateTime.now().toString(), name: name, votes:0) );

      setState(() {
        
      });
    }

    Navigator.pop(context);
  }
}