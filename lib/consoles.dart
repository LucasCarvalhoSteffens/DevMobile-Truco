import 'carta.dart';
import 'dart:io';

// Função para mostrar os valores das cartas da mão dos jogadores
void mostrarValoresCartas(List<List<Carta>> maosJogadores) {
  for (var i = 0; i < maosJogadores.length; i++) {
    print('\nCartas na mão do Jogador ${i + 1}:');
    for (var carta in maosJogadores[i]) {
      // Valor da carta considerando a manilha
      int valorCarta = carta.valorToInt();
      String marcador = carta.ehManilha ? ' (M)' : ''; // Adiciona "(M)" se for manilha
      if (carta.ehManilha) {
        valorCarta = carta.valorManilha;
      }
      print('$carta - Valor: $valorCarta$marcador');
    }
  }
}

//Interage com o jogador para obter a quantidade de jogadores
int obterNumeroJogadores() {
  int? numeroJogadores;
  bool numeroValido = false;
  
  while (!numeroValido) {
    stdout.write('Quantos jogadores deseja (2 ou 4)? ');
    String? entrada = stdin.readLineSync();

    // Verifica se a entrada não é nula
    if (entrada != null) {
      numeroJogadores = int.tryParse(entrada);
    }

    // Verifica se o número de jogadores é válido
    if (numeroJogadores != 2 && numeroJogadores != 4) {
      print('Número de jogadores inválido.');
    } else {
      numeroValido = true;
    }
  }
  return numeroJogadores!;
}

