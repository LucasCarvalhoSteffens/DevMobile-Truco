import 'package:tuple/tuple.dart';
import 'jogador.dart';
import 'valorCarta.dart';
import 'ResultadoRodada.dart';

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


  String? iniciarJogo(List<Jogador> jogadores) {
  bool jogoContinua = true;
  List<Carta> mesa = [];
  int numeroRodada = 1; // Variável para controlar o número da rodada

  // Lista para armazenar os resultados das rodadas
  List<ResultadoRodada> resultadosRodadas = [];

  // Loop principal para controlar o jogo
  while (jogoContinua) {
    // Lista para armazenar as cartas jogadas na mesa
    List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];

    // Loop para que cada jogador jogue uma carta
    for (var jogador in jogadores) {
      // Verifica se o jogador ainda tem cartas para jogar
      Map<String, dynamic>? infoCarta = jogador.obterCartaDaMao();

      if (infoCarta != null) {
        Carta cartaJogada = infoCarta['carta'];
        jogador.jogarCarta(mesa, cartaJogada);
        cartasJogadasNaMesa.add(Tuple2(jogador, infoCarta));
      }
    }

    // Verifica se houve empate
    Jogador? jogadorVencedor = compararCartas(cartasJogadasNaMesa);
    if (jogadorVencedor != null) {
      print('${jogadorVencedor.nome} ganhou a rodada!');
    } else {
      print('Empate! Ninguém ganhou a rodada $numeroRodada.');
    }

    // Adiciona o resultado da rodada atual à lista de resultados
    resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));

    // Determinar o vencedor do jogo até a rodada atual
    Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
    if (vencedorJogo != null) {
      print('\n\rO vencedor do jogo é: ${vencedorJogo.nome}');
      vencedorJogo.adicionarPontuacaoTotal();
      for (var jogador in jogadores) {
        int pontuacaoTotal = jogador.getPontuacaoTotal();
        print('\n\rPontuação total de ${jogador.nome}: $pontuacaoTotal');
      }

      return vencedorJogo.nome;
    } else {
      print('O jogo continua!');
    }

    // Incrementa o número da rodada para a próxima iteração
    numeroRodada++;
    }
  }

}