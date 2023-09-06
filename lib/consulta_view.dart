import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sante/container_all.dart';
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
  TextEditingController _dataController = TextEditingController();
  TextEditingController _valorController = TextEditingController();

  TextEditingController _pagamentoController = TextEditingController();

  TextEditingController _observacoesController = TextEditingController();

  TextEditingController _pesoController = TextEditingController();

  TextEditingController _alturaController = TextEditingController();

  TextEditingController _estomagoController = TextEditingController();

  TextEditingController _cinturaController = TextEditingController();

  TextEditingController _quadrilController = TextEditingController();

  TextEditingController _umbigoController = TextEditingController();

  TextEditingController _queixaController = TextEditingController();

  TextEditingController _alimentacaoController = TextEditingController();

  TextEditingController _tratamentoController = TextEditingController();
  int _exFisico = 0;
  int _hidratacao = 0;

  late ClienteRepository clienteRepository;
  late Sessao _consulta;
  bool fetching = true;
  List<Sessao> consultaList = [];
  int? index;

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
    consultaList = await clienteRepository.recuperarConsultas();
    setState(() {
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TrackScreens track = Provider.of<TrackScreens>(context);

    if (clienteRepository.indexConsulta != null) {
      consultaList = track.consultasCliente;
      //getData();
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
        body: ContainerAll(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                //form 1: Data da Consulta
                child: Form(
                  child: TextFormField(
                    readOnly: true, //aawaefefredededfedrtf
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
                      track.fromConsulta = true;
                      Navigator.popAndPushNamed(context, '/consulta');
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
                    track.consultasCliente.removeAt(index!);
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
        ),
      ),
    );
  }
}