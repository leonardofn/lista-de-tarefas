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

  TextEditingController _controllerTarefa = TextEditingController();
  List _listTarefas = [];

  Future<File> _getFile () async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa () {
    String _textoDigitado = _controllerTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = _textoDigitado;
    tarefa["realizada"] = false;
    setState(() {
      _listTarefas.add("tarefa");
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
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

  Widget criarItemLista (context, index) {
    final item = _listTarefas[index]["titulo"];
    return Dismissible(
      key: Key(item),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        _listTarefas.removeAt(index);
        _salvarArquivo();
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),

      child: CheckboxListTile(
        title: Text(_listTarefas[index]["titulo"]),
        value: _listTarefas[index]["realizada"],
        onChanged: (valorAlterado){
          setState(() {
            _listTarefas[index]["realizada"] = valorAlterado;
          });
          _salvarArquivo();
        },
      ),
    );
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
                  controller: _controllerTarefa,
                  decoration: InputDecoration(
                    labelText: "Digite sua tarefa",
                  ),
                  onChanged: (text){
                    _salvarTarefa();
                  }
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("Salvar"),
                    onPressed: (){
                      Navigator.pop(context);
                    }
                  ),
                ],
              );
            },
          );
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listTarefas.length,
              itemBuilder: criarItemLista,
            ),
          )
        ],
      ),
    );
  }
}
