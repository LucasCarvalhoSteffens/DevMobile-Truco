import 'package:tuple/tuple.dart';
import 'dart:io';
import 'valorCarta.dart';
import 'pedirTruco.dart';

class Jogador {
  Truco truco = Truco();
  
  late String nome;
  List<Carta> mao = [];
  List<int> indicesSelecionados = [];
  int pontos = 0;
  int pontuacaoTotal = 0;
  int grupo;
  List<Carta> mesa = [];
  List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];

  Jogador(this.nome, this.grupo);

  void obterCartaDaMao() {
    if (mao.isEmpty) {
        print('A mão de $nome está vazia!');
        return null;
    }

    print('\nCartas na mão do $nome:');
    for (var i = 0; i < mao.length; i++) {
        if (!indicesSelecionados.contains(i)) {
            var carta = mao[i];
            var valor = carta.ehManilha ? carta.valorManilha : carta.valorToInt();
            print('${i + 1} ${carta} - Valor: $valor${carta.ehManilha ? ' (M)' : ''}');
        }
    }
  }

  Tuple3<Jogador, Jogador?, int>? acaoDoJogador(Jogador jogador, List<Jogador> jogadores) {
  stdout.write('O jogador ${jogador.nome}, do Grupo: ${jogador.grupo} escolha a carta que deseja jogar (índice), ou "T" para pedir truco: ');
  String? input = stdin.readLineSync();
  
  if (input == null) {
    print('Entrada inválida. Tente novamente.');
    return null;
  }

  if (input.toUpperCase() == 'T') {
        // Verifica se o truco já foi aceito
        if (truco.trucoFoiAceito) {
            print('Você já pediu truco e ele foi aceito. Não é possível realizar outra ação.');
            return null;
        }
        return pedirTruco(jogador, jogadores);
    }

  int indice;
  try {
    indice = int.parse(input);
  } catch (e) {
    print('Entrada inválida. Tente novamente.');
    return null;
  }

  if (indice >= 1 && indice <= jogador.mao.length) {
    indicesSelecionados.add(indice - 1);
    var cartaSelecionada = mao[indice - 1];
    var valorCarta = cartaSelecionada.ehManilha ? cartaSelecionada.valorManilha : cartaSelecionada.valorToInt();

    print('açãojogadorescolhacata: ${valorCarta} cartaSelecionada: ${cartaSelecionada}' );
    // Retorna as informações sobre a carta selecionada
    return Tuple3<Jogador, Jogador?, int>(jogador, null, valorCarta);
  } else {
    print('Opção inválida. Tente novamente.');
    return null;
  }
}


Tuple3<Jogador, Jogador?, int>? selecionarCarta(Jogador jogador, jogadores) {
  stdout.write('Jogador $nome, do Grupo: $grupo selecione a carta que deseja jogar (índice): ');
  String? input = stdin.readLineSync();
  int indice;
  try {
    indice = int.parse(input!);
  } catch (e) {
    print('Entrada inválida. Tente novamente.');
    return null;
  }
  if (indice < 1 || indice > jogador.mao.length || jogador.indicesSelecionados.contains(indice - 1)) {
    print('Índice inválido ou carta já jogada! Escolha um índice válido.');
    return null;
  }

  indicesSelecionados.add(indice - 1);
  var cartaSelecionada = mao[indice - 1];
  var valorCarta = cartaSelecionada.ehManilha ? cartaSelecionada.valorManilha : cartaSelecionada.valorToInt();

  print('selecionarCarta: ${valorCarta}');
  // Retorna as informações em um mapa

  return Tuple3<Jogador, Jogador?, int>(jogador, null, valorCarta);
}



Tuple3<Jogador, Jogador?, int>? pedirTruco(Jogador jogador, List<Jogador> jogadores) {
  // Determina qual jogador está pedindo truco e qual está respondendo
  Jogador jogadorQuePediuTruco = jogador;
  Jogador jogadorQueRespondeTruco = jogadores.firstWhere((element) => element != jogadorQuePediuTruco);

  // Cria uma instância da classe Truco e chama o método pedirTruco
  Truco truco = Truco();
  return truco.pedirTruco(jogadorQuePediuTruco, jogadorQueRespondeTruco, jogadores);
  
}

  

  // Método para limpar a lista de índices das cartas selecionadas
  void limparIndicesSelecionados() {
    indicesSelecionados.clear();
  }

  void jogarCarta(List<Carta> mesa, Carta carta) {
    mesa.add(carta);
    print('$nome jogou a carta: $carta');
  }

  void adicionarPonto() {
    pontos++;
  }

  int getPontos() {
    return pontos;
  }

  void adicionarPontuacaoTotalTruco(int pontosTruco) {
    pontuacaoTotal += pontosTruco;
    print('pontuacaoTotal = $pontuacaoTotal');
  }

  void adicionarPontuacaoTotal() {
    pontuacaoTotal += 1;
    print('pontuacaoTotal = $pontuacaoTotal');
  }


  int getPontuacaoTotal() {
    return pontuacaoTotal;
  }

  void reiniciarPontos() {
    pontos = 0;
  }

  String? escolherAcao() {
    print('\n$nome, escolha a ação desejada:');
    print('1. Jogar uma carta');
    print('2. Pedir truco');
    stdout.write('Opção: ');
    String? escolha = stdin.readLineSync();
    return escolha;
  }

   bool responderTruco(Jogador jogadorQuePediuTruco, int pontosTruco) {
    print('${jogadorQuePediuTruco.nome} pediu truco! Você aceita? (S/N)');
    String? resposta = stdin.readLineSync()?.toUpperCase();
    return resposta == 'S';
  }

}