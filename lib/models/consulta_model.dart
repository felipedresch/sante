class Sessao {
  int? id;
  String data;
  double? valor;
  String? pagamento;
  String? peso;
  String? altura;
  String? estomago;
  String? cintura;
  String? quadril;
  String? umbigo;
  String queixa;
  String? alimentacao;
  String? tratamento;
  String? observacoes;
  int? exFisico;
  int? hidratacao;
  int clienteID;

  Sessao({
    this.id,
    required this.data,
    required this.valor,
    required this.pagamento,
    required this.peso,
    required this.altura,
    required this.estomago,
    required this.cintura,
    required this.quadril,
    required this.umbigo,
    required this.queixa,
    required this.alimentacao,
    required this.tratamento,
    required this.observacoes,
    required this.exFisico,
    required this.hidratacao,
    required this.clienteID,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'valor': valor,
      'pagamento': pagamento,
      'peso': peso,
      'altura': altura,
      'estomago': estomago,
      'cintura': cintura,
      'quadril': quadril,
      'umbigo': umbigo,
      'queixa': queixa,
      'alimentacao': alimentacao,
      'tratamento': tratamento,
      'observacoes': observacoes,
      'exFisico': exFisico,
      'hidratacao': hidratacao,
      'cliente_id': clienteID,
    };
  }

  Sessao.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        data = res["data"],
        valor = res["valor"],
        pagamento = res["pagamento"],
        peso = res["peso"],
        altura = res["altura"],
        estomago = res["estomago"],
        cintura = res["cintura"],
        quadril = res["quadril"],
        umbigo = res["umbigo"],
        queixa = res["queixa"],
        alimentacao = res["alimentacao"],
        tratamento = res["tratamento"],
        observacoes = res["observacoes"],
        exFisico = res["exFisico"],
        hidratacao = res["hidratacao"],
        clienteID = res["cliente_id"];
}
