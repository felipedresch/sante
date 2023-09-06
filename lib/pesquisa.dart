import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sante/repositories/cliente_repository.dart';

import 'models/cliente_model.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  TextEditingController formController = TextEditingController();
  late ClienteRepository clienteRepository;
  List<Cliente> clienteList = [];
  bool fetching = true;
  String? nome;
  String res = "";

  @override
  void initState() {
    super.initState();
    clienteRepository = ClienteRepository();
    clienteRepository.initDB().whenComplete(() async {
      getData();
      setState(() {});
    });
  }

  void getData() async {
    clienteList = await clienteRepository.recuperarClientes();
    setState(() {
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool verifica() {
      FutureBuilder(
          future: clienteRepository.recuperarClientes(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
            if (snapshot.hasData) {
              for (var i = 0; i < clienteList.length; i++) {
                if (clienteList.elementAt(i).nome == nome) {
                  res = "Achou";
                  break;
                } else {
                  res = "NAo achou";
                }
              }
              return Text(res);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
      if (res == "Achou") {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Consultar Cadastros")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
              width: 300,
              child: Text(
                "Informe o nome ou o CPF do(a) cliente",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 63, 40, 133),
                ),
              ),
            ),
            Form(
              child: TextFormField(
                controller: formController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Maria da Silva",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: OutlinedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  //clienteList.contains(element)
                  nome = formController.text;
                  if (verifica()) {
                    print("FOOOOOOOOOOOI");
                  } else {
                    print("CUUUUUUUUUUUUUUUUUUU");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Icon(Icons.search)),
                    const Text("Pesquisar Cliente"),
                  ],
                ),
              ),
            ),
            (verifica()) ? Text("Sim kkkkk") : Text("Nao achooou"), //função nao ta funcionando
          ],
        ),
      ),
      //minuto 15:00 (https://www.youtube.com/watch?v=xDdAXmAUt6c&t=3s&ab_channel=Prof.DiegoAntunes)
      // a pagina de nova consulta vai exigir pesquisar o cliente e selecionar antes de preencher os dados. Utilizar cards que aparecerão ENQUANTO se digita o nome do cliente (minuto 16:00 de https://www.youtube.com/watch?v=TBhTFXe8f3s&ab_channel=Prof.DiegoAntunes)
    );
  }
}
