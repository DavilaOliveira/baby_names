import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imóveis',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() {
      return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Imóveis'),),
      body: _buildBody(context),
          );
        }
    
  Widget _buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('imovel').snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data){
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        
        child: ListTile(
          title: Text(record.endereco),
          trailing: Text(record.numero.toString()),
          onTap: () => print(record.reference),
        ),
      ),
    );
  }
}

class Record{
  final int id;
  final int numero;
  final String endereco;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
    : assert(map['id'] != null),
      assert(map['numero'] != null),
      assert(map['endereco'] != null),
      numero = map['numero'],
      id = map['id'],
      endereco = map['endereco'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$id$endereco:$numero>";
}