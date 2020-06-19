import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listTarefas = [];

  Future<File> _getFile () async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarArquivo () async {
    var arquivo = await _getFile();
    String dados = json.encode(_listTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo () async {
    try{
      final arquivo = await _getFile();
      return arquivo.readAsString();
    }catch(e){
      return null;
    }
  }

  @override
  void initState() { // Executa antes de carregar o método build
    super.initState();
    _lerArquivo().then((dados){
      setState(() {
        _listTarefas = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Adicionar tarefa"),
                content: TextField(
                  decoration: InputDecoration(
                    labelText: "Digite sua tarefa",
                  ),
                  onChanged: (text){
                    FlatButton(
                      child: Text("Cancelar"),
                      onPressed: () => Navigator.pop(context),
                    );
                    FlatButton(
                      child: Text("Salvar"),
                      onPressed: (){

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              );
            }
          );
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listTarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_listTarefas[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
