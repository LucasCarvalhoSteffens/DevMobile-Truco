import 'package:tuple/tuple.dart';
import 'jogador.dart';
import 'valorCarta.dart';

class Jogo {
  late String nome;

  static Jogador? compararCartas(List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa) {
    if (cartasJogadasNaMesa.isEmpty) {
      return null; // Se não houver cartas jogadas na mesa, não há vencedor
    }
    
    // Inicializa a carta vencedora com a primeira carta jogada
    var cartaVencedora = cartasJogadasNaMesa[0];
    
    // Percorre as cartas jogadas na mesa a partir da segunda carta
    for (var i = 1; i < cartasJogadasNaMesa.length; i++) {
      var cartaJogada = cartasJogadasNaMesa[i];
      var valorCarta = cartaJogada.item2['valor'];
      var valorCartaVencedora = cartaVencedora.item2['valor'];
      
      // Se o valor da carta atual for maior que o da carta vencedora atual,
      // atualiza a carta vencedora para a carta atual
      if (valorCarta > valorCartaVencedora) {
        cartaVencedora = cartaJogada;
      }
      // Se houver um empate, retorna null
      else if (valorCarta == valorCartaVencedora) {
        return null;
      }
    }

    // Retorna o jogador associado à carta vencedora
    return cartaVencedora.item1;
  }

  void contabilizarPontos(Jogador? jogadorVencedor, int numeroRodada, List<ResultadoRodada> resultadosRodadas) {
    if (jogadorVencedor != null) {
      jogadorVencedor.adicionarPonto(); // Adiciona ponto ao jogador vencedor
      
      // Verifica se o jogador vencedor alcançou 2 pontos
      if (jogadorVencedor.getPontos() >= 2) {
        jogadorVencedor.adicionarPontuacaoTotal(); // Adiciona pontuação total do jogador
        print('${jogadorVencedor.nome} ganhou a rodada com ${jogadorVencedor.getPontos()} pontos!');
        //jogadorVencedor.reiniciarPontos(); // Reinicia os pontos da rodada
      }
    } else {
      print('Empate! Ninguém ganhou ponto.');
    }

    resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));

    // Imprimir informações da rodada aqui
    print('Rodada $numeroRodada:');
    if (jogadorVencedor != null) {
      print('${jogadorVencedor.nome} ganhou a rodada!');
    } else {
      print('Empate! Ninguém ganhou a rodada.');
    }
  }

  void iniciarJogo(List<Jogador> jogadores) {
    bool jogoContinua = true;
    List<Carta> mesa = [];
    List<ResultadoRodada> resultadosRodadas = [];

    // Loop principal para controlar o jogo
    while (jogoContinua) {
      // Lista para armazenar as cartas jogadas na mesa
      List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];

      // Loop para que cada jogador jogue uma carta
      for (var jogador in jogadores) {
        Map<String, dynamic>? infoCarta = jogador.obterCartaDaMao();

        if (infoCarta != null) {
          Carta cartaJogada = infoCarta['carta'];
          jogador.jogarCarta(mesa, cartaJogada);
          cartasJogadasNaMesa.add(Tuple2(jogador, infoCarta));
        } else {
          // Se um jogador não tiver mais cartas na mão, o jogo termina
          jogoContinua = false;
          break;
        }
      }

      // Verifica se houve empate
      Jogador? jogadorVencedor = compararCartas(cartasJogadasNaMesa);
      if (jogadorVencedor != null) {
        print('${jogadorVencedor.nome} ganhou a rodada!');
      } else {
        print('Empate! Ninguém ganhou a rodada.');
      }
      
      // Contabiliza os pontos da rodada e armazena o resultado
      contabilizarPontos(jogadorVencedor, resultadosRodadas.length + 1, resultadosRodadas);

      // Verifica se todas as rodadas foram jogadas
      if (mesa.length >= (jogadores.length * 3)) {
        jogoContinua = false;
        print('Todos os jogadores jogaram suas cartas!');
      }

      // Verifica se o jogo deve ser interrompido
      if (jogoContinua && resultadosRodadas.length >= 2) {
        // Se algum jogador ganhou duas rodadas seguidas, ou uma terceira rodada,
        // o jogo deve ser interrompido
        if (resultadosRodadas.length >= 3 ||
            (resultadosRodadas.last.jogadorVencedor != null &&
                resultadosRodadas[resultadosRodadas.length - 2].jogadorVencedor != null)) {
          jogoContinua = false;
        }
      }
    }

    // Impressão dos resultados de cada rodada
    print('Resultados das rodadas:');
    for (var resultado in resultadosRodadas) {
      if (resultado.jogadorVencedor != null) {
        print('Rodada ${resultado.numeroRodada}: ${resultado.jogadorVencedor!.nome} ganhou.');
      } else {
        print('Rodada ${resultado.numeroRodada}: Empate.');
      }
    }

    // Determina o vencedor do jogo com base nos resultados das rodadas
    String vencedor = determinarVencedor(resultadosRodadas);
    print('Resultado final: $vencedor');
  }
}

class ResultadoRodada {
  final int numeroRodada;
  final Jogador? jogadorVencedor;

  ResultadoRodada(this.numeroRodada, this.jogadorVencedor);
}

bool empatouRodada(int rodada) {
  return resultadosRodadas[rodada].jogadorVencedor == null;
}

Jogador vencedor(int rodada) {
  return resultadosRodadas[rodada].jogadorVencedor!;
}

Jogador determinarVencedor(List<ResultadoRodada> resultadosRodadas) {

  // Verifica se houve pelo menos duas rodadas
  if (resultadosRodadas.length >= 2) {
    // Verifica se o jogador venceu a segunda rodada, mas não a primeira
    if (empatouRodada(0)) {
      if (empatouRodada(1)) {
        if (empatouRodada(2)) {
          // ganha o pé
        }
        // ganha o vencedor da 2
      }
      // ganha o vencedor da 1
    } 
    if (empatouRodada(1)) {
      // GANHA O vencedor da 0
    }
    if (vencedor(0) != vencedor(1)) {
      if (empatouRodada(2)) {
        // ganha o vencedor da 0
      }
      // ganha quem venceu 2 contando as 3
    }
    // ganha o vencedor da 0 e 1



      // return "O jogador ${resultadosRodadas[1].jogadorVencedor!.nome} ganhou a segunda rodada e é o vencedor!";
    // Verifica se o jogador venceu a primeira rodada, mas não a segunda
    else if (resultadosRodadas[0].jogadorVencedor != null && resultadosRodadas[1].jogadorVencedor == null) {
      return "O jogador ${resultadosRodadas[0].jogadorVencedor!.nome} ganhou a primeira rodada e é o vencedor!";
    }
    // Verifica se o jogador venceu a primeira e a segunda rodadas
    else if (resultadosRodadas[0].jogadorVencedor != null && resultadosRodadas[1].jogadorVencedor != null) {
      return "O jogador ${resultadosRodadas[0].jogadorVencedor!.nome} ganhou as duas primeiras rodadas e é o vencedor!";
    }
  }

  // Verifica se houve pelo menos três rodadas
  //if (resultadosRodadas.length >= 3) {
    // Verifica se nenhum jogador venceu as duas primeiras rodadas, mas venceu a terceira
  if (resultadosRodadas[0].jogadorVencedor == null &&
      resultadosRodadas[1].jogadorVencedor == null &&
      resultadosRodadas[2].jogadorVencedor != null) {
    return "O jogador ${resultadosRodadas[2].jogadorVencedor!.nome} ganhou a terceira rodada e é o vencedor!";
  }
  //}

  // Verifica se houve um vencedor na última rodada
  Jogador? jogadorVencedorUltimaRodada = resultadosRodadas.last.jogadorVencedor;
  if (jogadorVencedorUltimaRodada != null) {
    // Verifica se o jogador vencedor da última rodada ganhou pelo menos uma rodada anterior
    for (int i = 0; i < resultadosRodadas.length - 1; i++) {
      if (resultadosRodadas[i].jogadorVencedor == jogadorVencedorUltimaRodada) {
        return "O jogador ${jogadorVencedorUltimaRodada.nome} ganhou a terceira rodada e é o vencedor!";
      }
    }
  }

  // Se nenhuma das condições anteriores for atendida, retorna que não há vencedor ainda
  return "Nenhum vencedor ainda.";
}


