import 'package:tuple/tuple.dart';
import 'jogador.dart';
import 'valorCarta.dart';

class Jogo {
  late String nome;

  static Jogador? compararCartas(List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa) {
    if (cartasJogadasNaMesa.isEmpty) {
      return null; // Se não houver cartas jogadas na mesa, não há vencedor
    }
    
    Tuple2<Jogador, Map<String, dynamic>> primeiraCartaJogada = cartasJogadasNaMesa[0];
    var cartaVencedoraInfo = primeiraCartaJogada.item2;
    Jogador jogadorVencedor = primeiraCartaJogada.item1;

    for (var cartaJogada in cartasJogadasNaMesa) {
      var cartaInfo = cartaJogada.item2;
      Jogador jogador = cartaJogada.item1;
      if (cartaInfo['valor'] > cartaVencedoraInfo['valor']) {
        cartaVencedoraInfo = cartaInfo;
        jogadorVencedor = jogador;
      }
    }

    return jogadorVencedor;
  }

   void contabilizarPontos(Jogador? jogadorVencedor) {
    if (jogadorVencedor != null) {
      jogadorVencedor.adicionarPonto(); // Chamando o método para adicionar ponto do jogador vencedor
      if (jogadorVencedor.getPontos() >= 2) {
        jogadorVencedor.adicionarPontuacaoTotal(); // Adiciona a pontuação da rodada à pontuação total do jogador
        print('${jogadorVencedor.nome} ganhou a rodada com ${jogadorVencedor.getPontos()} pontos!');
        jogadorVencedor.reiniciarPontos(); // Reinicia os pontos da rodada
        return;
      }
    } else {
      print('Empate! Ninguém ganhou ponto.');
    }
  }

  void iniciarJogo(List<Jogador> jogadores) {
    bool jogoContinua = true;
    List<Carta> mesa = [];
    List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];

    while (jogoContinua) {
      cartasJogadasNaMesa.clear(); // Limpa as cartas jogadas na mesa a cada rodada
      for (var jogador in jogadores) {
        Map<String, dynamic>? infoCarta = jogador.obterCartaDaMao();

        if (infoCarta != null) {
          Carta cartaJogada = infoCarta['carta'];
          jogador.jogarCarta(mesa, cartaJogada);
          cartasJogadasNaMesa.add(Tuple2(jogador, infoCarta));
        } else {
          jogoContinua = false;
          break;
        }
      }

      // Verifica se todos os jogadores jogaram suas cartas
      if (mesa.length == (jogadores.length * 3)) {
        jogoContinua = false;
        print('Todos os jogadores jogaram suas cartas!');

        // Verifica se algum jogador alcançou 2 pontos ou 12 pontos no total
        for (var jogador in jogadores) {
          if (jogador.getPontos() >= 2 || jogador.getPontuacaoTotal() >= 12) {
            jogoContinua = false;
            print('O jogador ${jogador.nome} alcançou a pontuação necessária para vencer: ${jogador.getPontos()} pontos na rodada, ${jogador.getPontuacaoTotal()} pontos no total.');
            break;
          }
        }

        if (!jogoContinua) {
          break;
        }
      }

      // Verifica se algum jogador venceu
      Jogador? jogadorVencedor = compararCartas(cartasJogadasNaMesa);
      print('${jogadorVencedor?.nome} ganhou a rodada!');
      contabilizarPontos(jogadorVencedor);
    }
  }
}