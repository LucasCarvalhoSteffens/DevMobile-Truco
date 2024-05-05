import 'package:tuple/tuple.dart';
import 'jogador.dart';
import 'valorCarta.dart';
import 'ResultadoRodada.dart';
import 'baralho.dart';
import 'consoles.dart';
import 'dart:io';
import 'pedirTruco.dart';



class Jogo {
  late String nome;
  List<Carta> mesa = [];

  Truco truco = Truco();

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

  void finalizarRodada(List<Jogador> jogadores, Baralho baralho, int numeroJogadores) {
      // Limpa as mãos dos jogadores
    for (var jogador in jogadores) {
        jogador.mao = []; // Atribui uma lista vazia para limpar a mão do jogador
    }

    baralho.embaralhar();

    // Distribui as cartas para os jogadores
    List<List<Carta>> todasMaosJogadores = baralho.distribuirCartasParaJogadores(numeroJogadores, baralho);

    // Atualiza as mãos dos jogadores
    for (int i = 0; i < jogadores.length; i++) {
        jogadores[i].mao = todasMaosJogadores[i];
        //print(jogadores[i].grupo);
    }
    
    // Define a última carta virada como manilha
    baralho.cartas[0].ehManilha = true;

    // Define qual carta será virada na mesa
    Carta manilha = baralho.cartas.firstWhere((carta) => carta.ehManilha);

    print('\nA manilha VIRADA é: $manilha');

    // Define as manilhas reais, que poderão estar nas mãos dos jogadores
    List<Carta> manilhasReais = baralho.definirManilhaReal(manilha);

    print('\nManilhas REAIS são: $manilhasReais \n');

    // Atribui pontos de manilha para todas as cartas do baralho
    for (var carta in baralho.cartas) {
      carta.atribuirPontosManilha(manilhasReais);
    }

    // Atribui pontos de manilha para todas as mãos de jogadores
    for (var maosJogador in todasMaosJogadores) {
      for (var carta in maosJogador) {
        carta.atribuirPontosManilha(manilhasReais);
      }
    }
  }

  String? perguntarProximaRodada() {
    // Pergunta ao jogador se deseja continuar para a próxima rodada
    print('\nDeseja continuar para a próxima rodada? (S/N)');
    String? continuar = stdin.readLineSync();
    return continuar?.toUpperCase();
  }

  void iniciarProximaRodada(List<Jogador> jogadores, Baralho baralho, int numeroJogadores, List<ResultadoRodada> resultadosRodadas) {
    // Limpa a lista de índices das cartas selecionadas para cada jogador
    for (var jogador in jogadores) {
      jogador.limparIndicesSelecionados();
    }

    // Limpa a mesa para a próxima rodada
    mesa.clear();

    // Limpa os resultados das rodadas
    limparResultadosRodadas(resultadosRodadas);

    // Chama o método para finalizar a rodada e distribuir novas cartas no início da próxima rodada
    finalizarRodada(jogadores, baralho, numeroJogadores);
  }

  void limparResultadosRodadas(List<ResultadoRodada> resultadosRodadas) {
    resultadosRodadas.clear();
  }


 // Loop principal para controlar o jogo
 String? iniciarJogo(List<Jogador> jogadores, int numeroJogadores, gruposDeJogadores) {
  bool jogoContinua = true;
  List<Carta> mesa = [];
  int numeroRodada = 1;
  bool algumJogadorAtingiuPontuacaoTotal = false;
  List<ResultadoRodada> resultadosRodadas = [];
  int jogadorAtualIndex = 0;

  while (jogoContinua) {
    List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];

    for (var i = 0; i < jogadores.length; i++) {
      int jogadorIndex = (jogadorAtualIndex + i) % jogadores.length;
      var jogador = jogadores[jogadorIndex];

      jogador.obterCartaDaMao();

      Tuple3<Jogador, Jogador?, int>? infoAcao = jogador.acaoDoJogador(jogador, jogadores);

      // Se houve uma ação do jogador (jogada ou pedido de truco)
      if (infoAcao != null) {
        // Se o jogador pediu truco e o truco não foi aceito, verifica se o outro jogador respondeu
        if (infoAcao.item2 != null && !truco.trucoFoiAceito) {
          // Lógica para tratar a resposta do outro jogador ao truco
          // (já implementado anteriormente)

        } else {
          // Se não houve pedido de truco ou o truco foi aceito, adiciona a carta jogada à mesa
          var cartaSelecionada = infoAcao.item1;
          var valorCarta = infoAcao.item3; // Adicionando valor da carta
          var jogadorQueAceitouTruco = infoAcao.item2;
          var pontosTruco = infoAcao.item3;
          cartasJogadasNaMesa.add(Tuple2<Jogador, Map<String, dynamic>>(jogador, {
            'carta': cartaSelecionada,
            'valor': valorCarta, // Passando o valor da carta
            'jogadorQueAceitouTruco': jogadorQueAceitouTruco,
            'pontosTruco': pontosTruco,
          }));

          // Atualiza as informações do truco se o truco foi aceito
          if (truco.trucoFoiAceito) {
            truco.jogadorQuePediuTruco = jogador;
          }
        }
      }
    }

    // Verificações e lógica após os jogadores jogarem...
    // Atualiza o índice do jogador atual para o próximo jogador
    jogadorAtualIndex = (jogadorAtualIndex + 1) % jogadores.length;

    // Verifica se houve empate
    Jogador? jogadorVencedor = compararCartas(cartasJogadasNaMesa);
    print('jogadorVencedor: ${jogadorVencedor}');
    if (jogadorVencedor != null) {
      
      print('\n\rGrupo ${jogadorVencedor.grupo} ganhou a rodada!');
    } else {
      print('\n\rEmpate! Ninguém ganhou a rodada $numeroRodada.');
    }

    // Adiciona o resultado da rodada atual à lista de resultados
    resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));

    // Determinar o vencedor do jogo até a rodada atual
    Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
    if (vencedorJogo != null) {
      print('\n\rO vencedor do jogo é: ${vencedorJogo.nome} e do grupo ${vencedorJogo.grupo}');
      
      for (var jogador in jogadores) {
        int pontuacaoTotal = jogador.getPontuacaoTotal();
        print('\n\rPontuação total de ${jogador.nome}: $pontuacaoTotal');
        
        // Verifica se algum jogador atingiu a pontuação total desejada
        if (pontuacaoTotal >= 2) {
          // Encerra o jogo
          print('\nO Grupo ${jogador.grupo} atingiu a pontuação máxima de 2 pontos e ganhou o jogo!');
          jogoContinua = false;
          break; // Sai do loop, já que o jogo será encerrado
        }
      }
    
      // Se o jogo foi encerrado, não precisa perguntar ao usuário se deseja continuar
      if (jogoContinua) {
        // Chama o método para iniciar a próxima rodada
        Baralho baralho = Baralho();
        iniciarProximaRodada(jogadores, baralho, numeroJogadores, resultadosRodadas);
      }
    }

      // Incrementa o número da rodada para a próxima iteração
      numeroRodada++;
      }
    }

}
