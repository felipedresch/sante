import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sante/container_all.dart';
import 'package:sante/models/cliente_model.dart';
import 'package:sante/repositories/cliente_repository.dart';
import 'package:sante/repositories/sessao_repository.dart';
import 'package:sante/repositories/track_screens.dart';
import 'models/consulta_model.dart';

class Consulta extends StatefulWidget {
  const Consulta({super.key});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  final _clienteKey = GlobalKey<FormState>();
  TextEditingController _clienteController = TextEditingController();
  final _dataKey = GlobalKey<FormState>();
  TextEditingController _dataController = TextEditingController();
  final _valorKey = GlobalKey<FormState>();
  TextEditingController _valorController = TextEditingController();
  final _pagamentoKey = GlobalKey<FormState>();
  TextEditingController _pagamentoController = TextEditingController();
  final _observacoesKey = GlobalKey<FormState>();
  TextEditingController _observacoesController = TextEditingController();

  final _pesoKey = GlobalKey<FormState>();
  TextEditingController _pesoController = TextEditingController();
  final _alturaKey = GlobalKey<FormState>();
  TextEditingController _alturaController = TextEditingController();
  final _estomagoKey = GlobalKey<FormState>();
  TextEditingController _estomagoController = TextEditingController();
  final _cinturaKey = GlobalKey<FormState>();
  TextEditingController _cinturaController = TextEditingController();
  final _quadrilKey = GlobalKey<FormState>();
  TextEditingController _quadrilController = TextEditingController();
  final _umbigoKey = GlobalKey<FormState>();
  TextEditingController _umbigoController = TextEditingController();
  final _queixaKey = GlobalKey<FormState>();
  TextEditingController _queixaController = TextEditingController();
  final _alimentacaoKey = GlobalKey<FormState>();
  TextEditingController _alimentacaoController = TextEditingController();
  final _tratamentoKey = GlobalKey<FormState>();
  TextEditingController _tratamentoController = TextEditingController();
  int _exFisico = 0;
  int _hidratacao = 0;
  late ConsultaRepository consultaRepository;
  late ClienteRepository clienteRepository;
  late Sessao _consulta;
  bool fetching = true;
  bool edicao = false;
  String title = " ";
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

  Future<String?> procuraNomeCliente (int id) async{
    List resultado = await clienteRepository.db.rawQuery('SELECT nome FROM clientes WHERE id=?', [id]); //deve ta errado
    //resultado.forEach((row) => print(row));
    return resultado.first; //retorna uma row, por isso da erro
  }

  @override
  Widget build(BuildContext context) {
    TrackScreens track = Provider.of<TrackScreens>(context);

    Future<int> addConsulta(Sessao consulta) async {
      return await clienteRepository.salvarConsultas(consulta);
    }

    Future<int> updateConsultas(Sessao consultas) async {
      return await clienteRepository.atualizarConsultas(consultas);
    }

    void resetData() {
      _dataController.clear();
      _valorController.clear();
      _pagamentoController.clear();
      _pesoController.clear();
      _alturaController.clear();
      _estomagoController.clear();
      _cinturaController.clear();
      _quadrilController.clear();
      _umbigoController.clear();
      _umbigoController.clear();
      _queixaController.clear();
      _alimentacaoController.clear();
      _tratamentoController.clear();
      _queixaController.clear();
      _observacoesController.clear();
      _exFisico = 0;
      _hidratacao = 0;
      edicao = false;
      track.cliente = null;
      track.fromConsulta = false;
    }

    if (track.fromClienteList) {
      //Se vier da lista é pq está escolhendo alguem para nova consulta
      _clienteController.text = track.cliente!.nome;
    }

    if (clienteRepository.indexConsulta != null && !fetching){
      edicao = true;
      setState(() {
        title = "Editar Consulta";
      });
      getData();
      index = clienteRepository.indexConsulta;
      int idCliente = consultaList[index!].clienteID;
      //Future<String?> a = procuraNomeCliente(idCliente);
      //_clienteController.text = a.toString();
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
    } else {
      setState(() {
        title = "Nova Consulta";
      });
    }

    Future<void> save() async {
      _dataKey.currentState?.save();
      _valorKey.currentState?.save();
      _pagamentoKey.currentState?.save();
      _pesoKey.currentState?.save();
      _alturaKey.currentState?.save();
      _estomagoKey.currentState?.save();
      _cinturaKey.currentState?.save();
      _quadrilKey.currentState?.save();
      _umbigoKey.currentState?.save();
      _queixaKey.currentState?.save();
      _alimentacaoKey.currentState?.save();
      _tratamentoKey.currentState?.save();
      _observacoesKey.currentState?.save();

      if (_queixaKey.currentState?.validate() == false ||
          _dataKey.currentState?.validate() == false ||
          _exFisico == 0 ||
          _hidratacao == 0 ||
          _clienteController.text.isEmpty) {
        return;
      }

      //Salvar as informações de todos os campos preenchidos
      if (!edicao) {
        Sessao consulta = Sessao(
            data: _dataController.text,
            valor: double.tryParse(_valorController.text), //se for 0.xx da erro
            pagamento: _pagamentoController.text,
            peso: _pesoController.text,
            altura: _alturaController.text,
            estomago: _estomagoController.text,
            cintura: _cinturaController.text,
            quadril: _quadrilController.text,
            umbigo: _umbigoController.text,
            queixa: _queixaController.text,
            alimentacao: _alimentacaoController.text,
            tratamento: _tratamentoController.text,
            observacoes: _observacoesController.text,
            exFisico: _exFisico,
            hidratacao: _hidratacao,
            clienteID: track.cliente!.id!.toInt());
        await addConsulta(consulta);
        setState(() {
          consultaList.add(consulta);
        });
      } else {
        _consulta.data = _dataController.text;
        _consulta.valor = double.tryParse(_valorController.text);
        _consulta.pagamento = _pagamentoController.text;
        _consulta.peso = _pesoController.text;
        _consulta.altura = _alturaController.text;
        _consulta.estomago = _estomagoController.text;
        _consulta.cintura = _cinturaController.text;
        _consulta.quadril = _quadrilController.text;
        _consulta.umbigo = _umbigoController.text;
        _consulta.queixa = _queixaController.text;
        _consulta.alimentacao = _alimentacaoController.text;
        _consulta.tratamento = _tratamentoController.text;
        _consulta.observacoes = _observacoesController.text;
        _consulta.exFisico = _exFisico;
        _consulta.hidratacao = _hidratacao;
        _consulta.clienteID = track.cliente!.id!;

        await updateConsultas(_consulta);
      }
      if (track.fromClienteList) {
        track.fromClienteList = false;
      }
      track.fromConsulta = false;
      resetData();
      setState(() {
        Navigator.popAndPushNamed(context, "/home");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sucesso!")));
      });
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                if (clienteRepository.indexConsulta != null) {
                  clienteRepository.indexConsulta = null;
                }
                track.fromClienteList = false;
                track.fromConsulta = false;
                Navigator.pop(context);
                //Navigator.popAndPushNamed(context, '/home');
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title)),
        body: ContainerAll(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Padding(
                  //form 1 - digita o nome do cliente e seleciona das opções
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Form(
                    key: _clienteKey,
                    child: TextFormField(
                      controller: _clienteController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: "Nome do Cliente",
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.name,
                      readOnly: edicao ? true : false,
                      onTap: () {
                        if (!edicao) {
                          track.fromConsulta = true;
                          Navigator.popAndPushNamed(context, "/list");
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  //form 1: Data da Consulta
                  child: Form(
                    key: _dataKey,
                    child: TextFormField(
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
                      validator: (value) {
                        if (value!.isEmpty || value.length != 10) {
                          return "Data inválida!";
                        } else {
                          return null;
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DataInputFormatter(),
                      ],
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
                          key: _valorKey,
                          child: TextFormField(
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
                          key: _pagamentoKey,
                          child: TextFormField(
                            controller: _pagamentoController,
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: "Pagamento",
                              prefixIcon: Icon(Icons.payment),
                            ),
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20)
                            ],
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
                          key: _pesoKey,
                          child: TextFormField(
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              PesoInputFormatter()
                            ],
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
                          key: _alturaKey,
                          child: TextFormField(
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              AlturaInputFormatter()
                            ],
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
                          key: _estomagoKey,
                          child: TextFormField(
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                          key: _cinturaKey,
                          child: TextFormField(
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                          key: _quadrilKey,
                          child: TextFormField(
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                          key: _umbigoKey,
                          child: TextFormField(
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                      key: _queixaKey,
                      child: TextFormField(
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
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Campo Obrigatório!";
                          } else {
                            return null;
                          }
                        },
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
                      key: _alimentacaoKey,
                      child: TextFormField(
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
                        keyboardType: TextInputType.multiline,
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
                      key: _tratamentoKey,
                      child: TextFormField(
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
                        keyboardType: TextInputType.multiline,
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
                      key: _observacoesKey,
                      child: TextFormField(
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
                        keyboardType: TextInputType.multiline,
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
                            const Text(
                                "Pratica atividades físicas regularmente?",
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
                  //Botão de salvar
                  margin: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                  child: OutlinedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: save,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: const Icon(Icons.search),
                        ),
                        const Text("Salvar"),
                      ],
                    ),
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
