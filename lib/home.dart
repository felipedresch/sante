import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sante/cadastro.dart';
import 'package:sante/cliente_list.dart';
import 'package:sante/container_all.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/track_screens.dart';
import 'consulta.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ClienteRepository clienteRepository;

  @override
  void initState() {
    super.initState();
    clienteRepository = ClienteRepository();
    clienteRepository.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    TrackScreens track = Provider.of<TrackScreens>(context);
    late ClienteRepository clienteRepository = ClienteRepository();
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "./assets/images/sante-fora.jpg",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0,
                    left: 4.0,
                    child: Text(
                      "Clínica Santè",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text("Backup"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text("Clientes"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text("Delete Database"),
              onTap: () async {
                await clienteRepository.deleteDatabase('sante.db');
                const AlertDialog(
                  title: Text("FOOI"),
                );
              },
            ),
          ],
        ),
      ),
      //backgroundColor: Color.fromRGBO(233, 218, 250, 1),
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Inicio")),
      body: ContainerAll(
        child: Center(
          child: SizedBox(
            width: 250,
            height: 165,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Cadastro()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.create)),
                      const Text("Criar Cadastro"),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    track.fromHome = true;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Consulta()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.add)),
                      const Text("Nova Consulta"),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    track.fromConsulta = false;
                    track.fromHome = true;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const ClienteList()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.list)),
                      const Text("Lista de Clientes"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
                OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Pesquisa()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.search)),
                      const Text("Pesquisar Cadastro"),
                    ],
                  ),
                ),
*/