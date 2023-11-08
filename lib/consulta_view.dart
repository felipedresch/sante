import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sante/container_all.dart';
import 'package:sante/models/picture_model.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/track_screens.dart';
import 'models/consulta_model.dart';

class ConsultaView extends StatefulWidget {
  const ConsultaView({super.key});

  @override
  State<ConsultaView> createState() => _ConsultaViewState();
}

class _ConsultaViewState extends State<ConsultaView> {
  String title = "Visualização de Consulta";
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _pagamentoController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _estomagoController = TextEditingController();
  final TextEditingController _cinturaController = TextEditingController();
  final TextEditingController _quadrilController = TextEditingController();
  final TextEditingController _umbigoController = TextEditingController();
  final TextEditingController _queixaController = TextEditingController();
  final TextEditingController _alimentacaoController = TextEditingController();
  final TextEditingController _tratamentoController = TextEditingController();
  int _exFisico = 0;
  int _hidratacao = 0;

  late ClienteRepository clienteRepository;
  late TrackScreens tracks;
  bool fetching = true;
  List<Sessao> consultaList = [];
  List<Picture> listaFotos = [];
  List<Picture> listaFotosFiltradas = [];
  List<Sessao> consultasFiltradas = [];
  int? index;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    clienteRepository = ClienteRepository();
    tracks = TrackScreens();
    clienteRepository.initDB().whenComplete(() async {
      getData();
      setState(() {});
    });
  }

  void getData() async {
    consultaList = await clienteRepository.recuperarConsultas();
    listaFotos = await clienteRepository.getPictures();
    setState(() {
      fetching = false;
      filtrarFotos();
    });
  }

  List<Picture> filtrarFotos(){
    for (var element in listaFotos) {
      if (element.consultaID == clienteRepository.consultaSelected!.id!) {
        listaFotosFiltradas.add(element);
      }
    }
    return listaFotosFiltradas;
  }

  @override
  Widget build(BuildContext context) {
    tracks = Provider.of<TrackScreens>(context);

    if (clienteRepository.indexConsulta != null) {
      consultaList = tracks.consultasCliente;
      index = clienteRepository.indexConsulta;
      _dataController.text = consultaList[index!].data;
      _valorController.text = consultaList[index!].valor.toString();
      _pagamentoController.text =
          consultaList.elementAt(index!).pagamento ?? "";
      _pesoController.text = consultaList[index!].peso ?? "";
      _alturaController.text = consultaList[index!].altura ?? "";
      _estomagoController.text = consultaList[index!].estomago ?? "";
      _cinturaController.text = consultaList[index!].cintura ?? "";
      _quadrilController.text = consultaList[index!].quadril ?? "";
      _umbigoController.text = consultaList[index!].umbigo ?? "";
      _queixaController.text = consultaList[index!].queixa;
      _alimentacaoController.text = consultaList[index!].alimentacao ?? "";
      _tratamentoController.text = consultaList[index!].tratamento ?? "";
      _observacoesController.text = consultaList[index!].observacoes ?? "";
      _exFisico = consultaList[index!].exFisico ?? 0;
      _hidratacao = consultaList[index!].hidratacao ?? 0;
      if (_valorController.text.contains('null')) {
        _valorController.text = "";
      }
    }

    //(index == 0)
    //? infoSection()
    //: imageSection()
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          //backgroundColor: Color.fromARGB(255, 203, 145, 230),
          height: 60,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.text_snippet_outlined), label: "Informações"),
            NavigationDestination(icon: Icon(Icons.filter), label: "Imagens anexadas")
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                //Exibir mensagem pedindo se deseja sair sem salvar as alterações no cadastro
                clienteRepository.indexConsulta = null;
                Navigator.popAndPushNamed(context, "/view");
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Visualizar Consulta")),
        body: <Widget> [
          infoSection(),
          imageSection()][currentPageIndex],
      ),
    );
  }

  Widget imageSection(){
    //return Image.memory(listaFotos.elementAt(0).picture);
    if (listaFotosFiltradas.isNotEmpty) {
      return ContainerAll(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
             mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              
            ),
          itemCount: listaFotosFiltradas.length,
          itemBuilder: (context, index){
            return Material(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: InkWell(
                splashColor: Theme.of(context).primaryColor.withOpacity(0.25),
                onTap: () {
                  //exibir imgagens fullscreen
                },
                onLongPress: () {
                  //exibir opção de apagar imagem
                },
                child: Ink.image(
                  image: FileImage(File(listaFotosFiltradas[index].path)),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          ),
      );
    }
    return const Center(child: Text("Sem imagens para essa consulta"));
    
  }

  Widget infoSection(){
    return ContainerAll(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                //form 1: Data da Consulta
                child: Form(
                  child: TextFormField(
                    readOnly: true,
                    controller: _dataController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: "Data da Consulta",
                      prefixIcon: Icon(Icons.date_range_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter()
                    ],
                    validator: (value) {
                      if (value!.isNotEmpty && value.length != 10) {
                        return "Data inválida!";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _valorController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Valor",
                            prefixIcon: Icon(Icons.attach_money),
                            prefix: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text("R\$:"),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            RealInputFormatter()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _pagamentoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Pagamento",
                            prefixIcon: Icon(Icons.payment),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form 6: Peso
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _pesoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Peso",
                            prefixIcon: Icon(Icons.scale),
                            suffix: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text('Kg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form 7: Altura
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _alturaController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            labelText: "Altura",
                            prefixIcon: Icon(Icons.height),
                            suffix: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text('metros'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form 8: Estomago
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _estomagoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Estômago",
                              prefixIcon: Icon(Icons.compare_arrows_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form 9: Cintura
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _cinturaController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Cintura",
                              prefixIcon: Icon(Icons.swap_horiz_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form 10: Quadril
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _quadrilController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Quadril",
                              prefixIcon: Icon(Icons.compare_arrows_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      //form 11: Umbigo
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Form(
                        child: TextFormField(
                          readOnly: true,
                          controller: _umbigoController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Umbigo",
                              prefixIcon: Icon(Icons.swap_horiz_rounded),
                              suffix: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text('cm'),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                //form 16: Queixa Principal
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    child: TextFormField(
                      readOnly: true,
                      maxLines: null,
                      controller: _queixaController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Queixa Principal",
                        prefixIcon: Icon(Icons.mood_bad),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                //form 17: Alimentacao
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    child: TextFormField(
                      readOnly: true,
                      maxLines: null,
                      controller: _alimentacaoController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Alimentação",
                        prefixIcon: Icon(Icons.restaurant_menu_rounded),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                //form 18: Plano de Tratamento
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    child: TextFormField(
                      readOnly: true,
                      maxLines: null,
                      controller: _tratamentoController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Plano de Tratamento",
                        prefixIcon: Icon(Icons.my_library_books_outlined),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                //form 19: Observações
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(7)),
                  child: Form(
                    child: TextFormField(
                      readOnly: true,
                      maxLines: null,
                      controller: _observacoesController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: "Informações Adicionais",
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                //Form Exercicio Físico
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      width: MediaQuery.of(context).size.width * 0.94,
                      height: 85,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(width: 0.5)),
                      child: Column(
                        children: [
                          const Text("Pratica atividades físicas regularmente?",
                              style: TextStyle(fontSize: 16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Form(
                                child: Radio(
                                    value: 1,
                                    groupValue: _exFisico,
                                    onChanged: (value) {
                                      setState(() {
                                        _exFisico = value!;
                                      });
                                    }),
                              ),
                              const Text("Sim"),
                              Form(
                                child: Radio(
                                    value: 2,
                                    groupValue: _exFisico,
                                    onChanged: (value) {
                                      setState(() {
                                        _exFisico = value!;
                                      });
                                    }),
                              ),
                              const Text("Não"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.94,
                  height: 85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(width: 0.5)),
                  child: Column(
                    children: [
                      const Text("Hidratação está adequada?",
                          style: TextStyle(fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            child: Radio(
                                value: 1,
                                groupValue: _hidratacao,
                                onChanged: (value) {
                                  setState(() {
                                    _hidratacao = value!;
                                  });
                                }),
                          ),
                          const Text("Sim"),
                          Form(
                            child: Radio(
                                value: 2,
                                groupValue: _hidratacao,
                                onChanged: (value) {
                                  setState(() {
                                    _hidratacao = value!;
                                  });
                                }),
                          ),
                          const Text("Não"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                //Botão de EDITAR consulta
                margin: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                child: OutlinedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      tracks.fromConsulta = true;
                      Navigator.popAndPushNamed(context, '/consulta');
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Icon(Icons.edit),
                      ),
                      const Text("Editar Consulta"),
                    ],
                  ),
                ),
              ),
              Container(
                //Botão de excluir consulta
                margin: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                child: OutlinedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    foregroundColor: MaterialStatePropertyAll(Colors.red),
                  ),
                  onPressed: () async {
                    clienteRepository.indexConsulta = null;
                    await clienteRepository
                        .removerConsulta(consultaList.elementAt(index!).id!);
                    consultaList.removeAt(index!);
                    tracks.consultasCliente.removeAt(index!);
                    //EXIBIR NOTIFICACAO PERGUNTANDO SE DESEJA EXCLUIR
                    //Navigator.popAndPushNamed(context, "/home");
                    setState(() {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Consulta Excluída!")));
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Icon(Icons.delete),
                      ),
                      const Text("Excluir Consulta"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
