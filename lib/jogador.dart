import 'dart:io';
import 'valorCarta.dart';

class Jogador {
  late String nome;
  List<Carta> mao = [];
  List<int> indicesSelecionados = [];
  int pontos = 0;
  int pontuacaoTotal = 0;


  Jogador(this.nome);

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

    stdout.write('$nome, escolha a carta que deseja jogar (índice): ');
    String? input = stdin.readLineSync();
    if (input == null) {
        print('Entrada inválida. Tente novamente.');
        return null;
    }

    // T para pedir truco
    if (input.toUpperCase() == 'T') {
      return {'truco': true};
    }


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

}
