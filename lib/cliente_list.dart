import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sante/container_all.dart';
import 'package:sante/home.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/track_screens.dart';
import 'cadastro.dart';
import 'models/cliente_model.dart';
import 'package:all_validations_br/all_validations_br.dart';

class ClienteList extends StatefulWidget {
  const ClienteList({super.key});

  @override
  State<ClienteList> createState() => _ClienteListState();
}

class _ClienteListState extends State<ClienteList> {
  final TextEditingController _pesquisaController = TextEditingController();
  late List<Cliente> clienteList;
  List<Cliente> clienteListFiltrado = [];
  late ClienteRepository clienteRepository;
  late TrackScreens tracks;
  //late Cliente _cliente;
  Cadastro forms = const Cadastro();
  Home home = const Home();
  String? nomeCliente;
  String? get getNome => nomeCliente;
  String titulo = "";
  bool fetch = false;

  @override
  void initState() {
    super.initState();
    clienteRepository = ClienteRepository();
    tracks = TrackScreens();
    clienteRepository.initDB().whenComplete(() async {
      clienteList = await clienteRepository.recuperarClientes();
      setState(() {});
    });
    fetch = true;
  }

  @override
  Widget build(BuildContext context) {
    tracks = Provider.of<TrackScreens>(context);
    if (tracks.fromConsulta) {
      titulo = "Nova Consulta";
      tracks.fromHome = false;
    } else {
      titulo = "Lista de clientes";
      tracks.fromConsulta = false;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                clienteRepository.indexCliente = null;
                Navigator.popAndPushNamed(context, "/home");
              },
            ),
            title: Text(titulo),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: (fetch)
              ? corpo()
              : const Center(child: CircularProgressIndicator())),
    );
  }

  Widget corpo() {
    return ContainerAll(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: SizedBox(
              height: 45,
              child: SearchBar(
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                  controller: _pesquisaController,
                  hintText: "Digite o nome ou CPF do cliente",
                  onChanged: (value) => setState(() {
                        _pesquisaController;
                        filtroDaPesquisa();
                      }),
                  leading: const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Icon(Icons.search),
                  )),
            ),
          ),
          (_pesquisaController.text.isNotEmpty)
              ? corpoComFiltro()
              : corpoSemFiltro()
        ],
      ),
    );
  }

  void filtroDaPesquisa() {
    clienteListFiltrado.clear();

    if (_pesquisaController.text.contains(RegExp(r'^[0-9]+$'))) {
      for (var i = 0; i < clienteList.length; i++) {
        if (AllValidations.removeCharacters(clienteList.elementAt(i).cpf)
            .contains(_pesquisaController.text)) {
          clienteListFiltrado.add(clienteList.elementAt(i));
        }
      }
      clienteListFiltrado.sort((a, b) => AllValidations.removeCharacters(a.cpf)
          .compareTo(_pesquisaController.text));
      clienteListFiltrado = clienteListFiltrado.reversed.toList();
    } else {
      for (var i = 0; i < clienteList.length; i++) {
        if (AllValidations.removeAccents(clienteList.elementAt(i).nome.toLowerCase())
            .contains(
                AllValidations.removeAccents(_pesquisaController.text.toLowerCase()))) {
          clienteListFiltrado.add(clienteList.elementAt(i));
        }
      }
      clienteListFiltrado.sort((a, b) => a.nome
          .toLowerCase()
          .compareTo(_pesquisaController.text.toLowerCase()));
      clienteListFiltrado = clienteListFiltrado.reversed.toList();
    }
  }

  Widget corpoComFiltro() {
    if (clienteListFiltrado.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
            itemCount: clienteListFiltrado.length,
            itemBuilder: (context, position) {
              //return const CircularProgressIndicator();
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: const Color.fromARGB(255, 217, 193, 238),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.arrow_forward_rounded),
                    ),
                    key: UniqueKey(),
                    //abrir nova consulta ondismissed
                    onDismissed: (DismissDirection direction) async {
                      //await clienteRepository
                      //.remover(snapshot.data![position].id!);
                    },
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (tracks.fromConsulta) {
                          //tracks.cliente =
                          //snapshot.data![position];
                          tracks.cliente =
                              clienteListFiltrado.elementAt(position);
                          tracks.fromConsulta = false;
                          tracks.fromClienteList = true;
                          Navigator.popAndPushNamed(context, "/consulta");
                        } else {
                          //Veio da home
                          clienteRepository.clienteSelected =
                              clienteListFiltrado.elementAt(position);
                          clienteRepository.indexCliente = position;
                          Navigator.popAndPushNamed(context, "/view");
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 6.0),
                                child: Text(
                                  overflow: TextOverflow.clip,
                                  //softWrap: true,
                                  clienteListFiltrado
                                      .elementAt(position)
                                      .nome, //overflowing
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 6.0, 12.0, 12.0),
                                child: Text(
                                  clienteListFiltrado
                                      .elementAt(position)
                                      .cpf
                                      .toString(),
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ),
                              (!tracks.fromConsulta)
                                  ? ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 145),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 22,
                                              //visualizar cadastro
                                              onPressed: () {
                                                clienteRepository
                                                        .clienteSelected =
                                                    clienteListFiltrado
                                                        .elementAt(position);
                                                clienteRepository.indexCliente =
                                                    position;
                                                Navigator.popAndPushNamed(
                                                    context, "/view");
                                              },
                                              icon: const Icon(Icons.visibility,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 22,
                                              onPressed: () {
                                                clienteRepository
                                                        .clienteSelected =
                                                    clienteListFiltrado
                                                        .elementAt(position);
                                                clienteRepository.indexCliente =
                                                    position;
                                                Navigator.popAndPushNamed(
                                                    context, "/cadastrar");
                                              },
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              iconSize: 22,
                                              //excluir cadastro
                                              onPressed: () async {
                                                //MSG PEDINDO SE QUER DELETAR
                                                clienteRepository.indexCliente =
                                                    null;
                                                await clienteRepository
                                                    .removerClientes(
                                                        clienteListFiltrado
                                                            .elementAt(position)
                                                            .id!);
                                                setState(() {
                                                  Navigator.popAndPushNamed(
                                                      context, "/home");
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Cadastro Excluído!")));
                                                });
                                              },
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Row(),
                            ],
                          ),
                          const Divider(
                            height: 2.0,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    )),
              );
            }),
      );
    }
    return const Text("Sem resultados");
  }

  Widget corpoSemFiltro() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: clienteRepository.recuperarClientes(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, position) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: const Color.fromARGB(255, 217, 193, 238),
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: const Icon(Icons.arrow_forward_rounded),
                            ),
                            key: UniqueKey(),
                            //abrir nova consulta ondismissed
                            onDismissed: (DismissDirection direction) async {
                              //await clienteRepository
                              //.remover(snapshot.data![position].id!);
                            },
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (tracks.fromConsulta) {
                                  tracks.cliente = snapshot.data![position];
                                  tracks.fromConsulta = false;
                                  tracks.fromClienteList = true;
                                  Navigator.popAndPushNamed(
                                      context, "/consulta");
                                } else {
                                  //Veio da home
                                  clienteRepository.clienteSelected =
                                      snapshot.data?[position];
                                  clienteRepository.indexCliente = position;
                                  Navigator.popAndPushNamed(context, "/view");
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 12.0, 12.0, 6.0),
                                        child: Text(
                                          overflow: TextOverflow.clip,
                                          //softWrap: true,
                                          snapshot.data![position]
                                              .nome, //overflowing
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 6.0, 12.0, 12.0),
                                        child: Text(
                                          snapshot.data![position].cpf
                                              .toString(),
                                          style:
                                              const TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      (!tracks.fromConsulta)
                                          ? ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 145),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      iconSize: 22,
                                                      //visualizar cadastro
                                                      onPressed: () {
                                                        clienteRepository
                                                                .clienteSelected =
                                                            snapshot.data?[
                                                                position];
                                                        clienteRepository
                                                                .indexCliente =
                                                            position;
                                                        Navigator
                                                            .popAndPushNamed(
                                                                context,
                                                                "/view");
                                                      },
                                                      icon: const Icon(
                                                          Icons.visibility,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      iconSize: 22,
                                                      onPressed: () {
                                                        clienteRepository
                                                                .clienteSelected =
                                                            snapshot.data?[
                                                                position];
                                                        clienteRepository
                                                                .indexCliente =
                                                            position;
                                                        Navigator
                                                            .popAndPushNamed(
                                                                context,
                                                                "/cadastrar");
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      iconSize: 22,
                                                      //excluir cadastro
                                                      onPressed: () async {
                                                        //MSG PEDINDO SE QUER DELETAR
                                                        clienteRepository
                                                                .indexCliente =
                                                            null;
                                                        await clienteRepository
                                                            .removerClientes(
                                                                snapshot
                                                                    .data![
                                                                        position]
                                                                    .id!);
                                                        setState(() {
                                                          Navigator
                                                              .popAndPushNamed(
                                                                  context,
                                                                  "/home");
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "Cadastro Excluído!")));
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const Row(),
                                    ],
                                  ),
                                  const Divider(
                                    height: 2.0,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            )),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
