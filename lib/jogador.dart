import 'dart:io';
import 'valorCarta.dart';
import 'pedirTruco.dart';

class Jogador {
  late String nome;
  List<Carta> mao = [];
  List<int> indicesSelecionados = [];
  int pontos = 0;
  int pontuacaoTotal = 0;
  int grupo;

  Jogador(this.nome, this.grupo);

  Map<String, dynamic>? obterCartaDaMao() {
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

    return selecionarCarta();
}

Map<String, dynamic>? selecionarCarta() {
    stdout.write('$nome, do Grupo: $grupo a carta que deseja jogar (índice): ');
    String? input = stdin.readLineSync();
    if (input == null) {
        print('Entrada inválida. Tente novamente.');
        return null;
    }

    // // T para pedir truco
    // if (input.toUpperCase() == 'T') {
    //   // Aqui você instancia a classe Truco e chama o método pedirTruco
    //   Truco truco = Truco();
    //   truco.pedirTruco(this, gruposDeJogadores[grupo][1 - grupo]);
    //   return null; // Como o jogador está pedindo truco, não retorna uma carta selecionada
    // }

    int indice;
    try {
        indice = int.parse(input);
    } catch (e) {
        print('Entrada inválida. Tente novamente.');
        return null;
    }

    if (indice < 1 || indice > mao.length || indicesSelecionados.contains(indice - 1)) {
        print('Índice inválido ou carta já jogada! Escolha um índice válido.');
        return null;
    }

    indicesSelecionados.add(indice - 1);
    var cartaSelecionada = mao[indice - 1];
    var valorCarta = cartaSelecionada.ehManilha ? cartaSelecionada.valorManilha : cartaSelecionada.valorToInt();

    return {
        'carta': cartaSelecionada,
        'valor': valorCarta,
    };
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

  void adicionarPontuacaoTotal() {
    pontuacaoTotal++;
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
