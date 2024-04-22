import 'dart:io';
import 'carta.dart';

class Jogador {
  late String nome;
  List<Carta> mao = [];
  List<int> indicesSelecionados = [];

  Jogador(this.nome);

  Carta? obterCartaDaMao() {
    if (mao.isEmpty) {
      print('A mão de $nome está vazia!');
      return null;
    }

    print('\nCartas na mão do $nome:');
    for (var i = 0; i < mao.length; i++) {
      if (!indicesSelecionados.contains(i)) {
        print('${i + 1} ${mao[i]} - Valor: ${mao[i].valorToInt()}');
      }
    }

    stdout.write('$nome, escolha a carta que deseja jogar (índice): ');
    int indice = int.parse(stdin.readLineSync()!);

    if (indice < 1 || indice > mao.length || indicesSelecionados.contains(indice - 1)) {
      print('Índice inválido ou carta já jogada! Escolha um índice válido.');
      return null;
    }

    indicesSelecionados.add(indice - 1);
    Carta cartaSelecionada = mao[indice - 1];
    
    if (indicesSelecionados.length == mao.length) {
      // Se todas as cartas foram jogadas, redefina os índices selecionados
      indicesSelecionados.clear();
    }

    return cartaSelecionada;
  }

  void jogarCarta(List<Carta> mesa, Carta carta) {
    mesa.add(carta);
    print('$nome jogou a carta: $carta');
  }
}

