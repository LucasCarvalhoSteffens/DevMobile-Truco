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

  while (true) {
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
      continue;
    }

    int indice;
    try {
      indice = int.parse(input);
    } catch (e) {
      print('Entrada inválida. Tente novamente.');
      continue;
    }

    if (indice < 1 || indice > mao.length || indicesSelecionados.contains(indice - 1)) {
      print('Índice inválido ou carta já jogada! Escolha um índice válido.');
      continue;
    }

    indicesSelecionados.add(indice - 1);
    var cartaSelecionada = mao[indice - 1];
    var valorCarta = cartaSelecionada.ehManilha ? cartaSelecionada.valorManilha : cartaSelecionada.valorToInt();

    return {
      'carta': cartaSelecionada,
      'valor': valorCarta,
    };
  }
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
    print('\r\nPontuação total: $pontuacaoTotal');
    return pontuacaoTotal;
  }

  void reiniciarPontos() {
    pontos = 0;
  }

}


// Função definir os valores
List<List<dynamic>> obterInformacoesCartas(List<List<Carta>> maosJogadores) {
  List<List<dynamic>> informacoesJogadores = [];

  for (var i = 0; i < maosJogadores.length; i++) {
    List<dynamic> informacoesJogador = [];

    int contador = 1; // Inicializa o contador de índice
    for (var carta in maosJogadores[i]) {
      // Valor da carta considerando a manilha
      int valorCarta = carta.ehManilha ? carta.valorManilha : carta.valorToInt();
      String marcador = carta.ehManilha ? ' (M)' : ''; // Adiciona "(M)" se for manilha
      
      // Adiciona as informações do jogador atual à lista
      informacoesJogador.add({'contador': contador, 'carta': carta.toString(), 'valor': valorCarta, 'marcador': marcador});

      contador++; // Incrementa o contador de índice
    }

    // Adiciona as informações do jogador atual à lista de todos os jogadores
    informacoesJogadores.add(informacoesJogador);
  }
  print('informacoesJogadores: $informacoesJogadores');
  return informacoesJogadores;
}

