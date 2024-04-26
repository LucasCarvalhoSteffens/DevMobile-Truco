import 'package:tuple/tuple.dart';
import 'jogador.dart';
import 'valorCarta.dart';
import 'ResultadoRodada.dart';
import 'baralho.dart';
import 'consoles.dart';
import 'dart:io';



class Jogo {
  late String nome;
  List<Carta> mesa = [];

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

  bool responderTruco(Jogador jogadorQuePediuTruco, List<Jogador> outroJogador) {
    // Pergunta ao jogador se ele aceita o truco
    print('${outroJogador}, você aceita o truco? (S/N)');
    String? resposta = stdin.readLineSync();
    
    // Verifica a resposta do jogador
    if (resposta?.toUpperCase() == 'S') {
      return true; // O jogador aceitou o truco
    } else {
      return false; // O jogador não aceitou o truco
    }
  }

   // Método para processar a resposta ao truco
  bool processarTruco(Jogador jogador, List<Jogador> outroGrupo) {
    print('${jogador}, você aceita o truco? (S/N/A)');
    String? resposta = stdin.readLineSync()?.toUpperCase();

    switch (resposta) {
      case 'S':
        return true; // Aceitou o truco
      case 'A':
        return processarAumentoTruco(jogador, outroGrupo);
      default:
        return false; // Não aceitou o truco
    }
  }

  // Método para processar o aumento do truco
  bool processarAumentoTruco(Jogador jogador, List<Jogador> outroGrupo) {
    if (jogador.getPontuacaoTotal() >= 6) {
      print('${jogador}, você aceita o aumento para 9? (S/N)');
      String? resposta = stdin.readLineSync()?.toUpperCase();
      return resposta == 'S'; // Aceitou o aumento para 9
    } else {
      print('${jogador} pediu aumento para 6. Você aceita? (S/N)');
      String? resposta = stdin.readLineSync()?.toUpperCase();
      return resposta == 'S' && processarAumentoTruco(outroGrupo[0], [jogador]);
    }
  }

String? iniciarJogo(List<Jogador> jogadores, int numeroJogadores, int numeroGrupos, List<List<Jogador>> gruposDeJogadores) {
  bool jogoContinua = true;
  List<Carta> mesa = [];
  int numeroRodada = 1; 

    bool algumJogadorAtingiuPontuacaoTotal = false;

  // Lista para armazenar os resultados das rodadas
  List<ResultadoRodada> resultadosRodadas = [];
  int indexJogadorAtual = 0;
  bool trucoAceito = false;

  // Loop principal para controlar o jogo
  while (jogoContinua) {
    // Lista para armazenar as cartas jogadas na mesa
    List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];

    for (var jogador in jogadores) {
      Map<String, dynamic>? infoCarta;

      while (infoCarta == null) {
        infoCarta = jogador.obterCartaDaMao();

        if (infoCarta != null) {
          if (infoCarta.containsKey('carta')) {
            // ...
          } else if (infoCarta.containsKey('truco')) {
            print('${jogador.nome} pediu truco!');

            int indexJogadorAtual = jogadores.indexOf(jogador);
            int indexProximoGrupo = (indexJogadorAtual ~/ numeroGrupos) % numeroGrupos;
            List<Jogador> outroGrupo = gruposDeJogadores[indexProximoGrupo];

            bool aceitouTruco = processarTruco(jogador, outroGrupo);

            if (aceitouTruco) {
              print('O truco foi aceito! O jogo continua.');
            } else {
              print('O truco foi recusado. O jogo acabou!');
              jogoContinua = false;
              break;
            }
          }
        }
      }
     
      if (!jogoContinua) {
        break;
      }
      
      // Verifica se houve empate
      Jogador? jogadorVencedor = compararCartas(cartasJogadasNaMesa);

      if (jogadorVencedor != null) {
        print('\n\r${jogadorVencedor.nome} ganhou a rodada!');
      } else {
        print('\n\rEmpate! Ninguém ganhou a rodada $numeroRodada.');
      }
      
      // Adiciona o resultado da rodada atual à lista de resultados
      resultadosRodadas.add(ResultadoRodada(numeroRodada, jogadorVencedor));

      // Determinar o vencedor do jogo até a rodada atual
      Jogador? vencedorJogo = determinarVencedor(resultadosRodadas);
      if (vencedorJogo != null) {
        print('\n\rO vencedor do jogo é: ${vencedorJogo.nome}');
        vencedorJogo.adicionarPontuacaoTotal();
      }    
      
      for (var jogador in jogadores) {
        int pontuacaoTotal = jogador.getPontuacaoTotal();
        print('\n\rPontuação total de ${jogador.nome}: $pontuacaoTotal');
        
        // Verifica se algum jogador atingiu a pontuação total desejada
        if (pontuacaoTotal >= 2) {
          // Encerra o jogo
          print('\nO jogador ${jogador.nome} atingiu a pontuação máxima de 2 pontos e ganhou o jogo!');
          jogoContinua = false;
          break; // Sai do loop, já que o jogo será encerrado
        }
      }
    }

    // Se o jogo foi encerrado, não precisa perguntar ao usuário se deseja continuar
    if (jogoContinua) {
      // Chama o método para iniciar a próxima rodada
      Baralho baralho = Baralho();
      iniciarProximaRodada(jogadores, baralho, numeroJogadores, resultadosRodadas);
    }

    // Incrementa o número da rodada para a próxima iteração
    numeroRodada++;
  }
}
}