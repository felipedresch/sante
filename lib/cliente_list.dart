import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sante/container_all.dart';
import 'package:sante/home.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/track_screens.dart';
import 'cadastro.dart';
import 'models/cliente_model.dart';

class ClienteList extends StatefulWidget {
  const ClienteList({super.key});

  @override
  State<ClienteList> createState() => _ClienteListState();
}

class _ClienteListState extends State<ClienteList> {
  late ClienteRepository clienteRepository;
  //late Cliente _cliente;
  Cadastro forms = const Cadastro();
  Home home = const Home();
  String? nomeCliente;
  String? get getNome => nomeCliente;
  String titulo = "";

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
    if (track.fromConsulta) {
      titulo = "Nova Consulta";
      track.fromHome = false;
    } else {
      titulo = "Lista de clientes";
      track.fromConsulta = false;
    }
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              clienteRepository.indexCliente = null;
              Navigator.pop(context);
            },
          ),
          title: Text(titulo),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: ContainerAll(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
                future: clienteRepository.recuperarClientes(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Cliente>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, position) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color:
                                      const Color.fromARGB(255, 217, 193, 238),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child:
                                      const Icon(Icons.arrow_forward_rounded),
                                ),
                                key: UniqueKey(),
                                //abrir nova consulta ondismissed
                                onDismissed:
                                    (DismissDirection direction) async {
                                  //await clienteRepository
                                  //.remover(snapshot.data![position].id!);
                                },
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (track.fromConsulta) {
                                      track.cliente = snapshot.data![position];
                                      track.fromConsulta = false;
                                      track.fromClienteList = true;
                                      Navigator.popAndPushNamed(
                                          context, "/consulta");
                                    } else {
                                      //Veio da home
                                      clienteRepository.clienteSelected =
                                          snapshot.data?[position];
                                      clienteRepository.indexCliente = position;
                                      Navigator.popAndPushNamed(
                                          context, "/view");
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              style: const TextStyle(
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                          (!track.fromConsulta)
                                              ? ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 145),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      SizedBox(
                                                        width: 40,
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
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
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
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
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
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
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("Cadastro Excluído!")));
                                                            });
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.blue),
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
        ));
  }
}
