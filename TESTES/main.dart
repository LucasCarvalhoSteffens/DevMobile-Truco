import 'carta.dart';
import 'baralho.dart'; 
import 'consoles.dart';
import 'jogador.dart';
import 'jogo.dart';

void main() {
  // Cria o baralho
  Baralho baralho = Baralho();

  // Embaralha as cartas, garantindo jogos diferentes
  baralho.embaralhar();

  // Pergunta ao usuário quantos jogadores deseja
  int numeroJogadores = obterNumeroJogadores();
  print('Número de jogadores selecionado: $numeroJogadores');

  // Distribui as cartas para os jogadores
  List<List<Carta>> todasMaosJogadores = baralho.distribuirCartasParaJogadores(numeroJogadores, baralho);


  // Define a última carta virada como manilha
  baralho.cartas[0].ehManilha = true;

  // Define qual carta será virada na mesa
  Carta manilha = baralho.cartas.firstWhere((carta) => carta.ehManilha);

  print('\nA manilha VIRADA é: $manilha');

  // Define as manilhas reais, que poderão estar nas mãos dos jogadores
  List<Carta> manilhasReais = baralho.definirManilhaReal(manilha);

  print('\nManilhas REAIS são: $manilhasReais \n');

  // Atribui pontos nas manilhas para todas as mãos de jogadores
  baralho.verificarManilha(todasMaosJogadores, manilhasReais);

  // Cria instâncias de Jogador para representar os jogadores do jogo
  List<Jogador> jogadores = [];
  for (int i = 1; i <= numeroJogadores; i++) {
    Jogador jogador = Jogador('Jogador $i');
    jogador.mao = todasMaosJogadores[i - 1];
    jogadores.add(jogador);
  }

  // Mostra as cartas, valores e qual é a manilha
  List<List<dynamic>> informacoesCartas = obterInformacoesCartas(todasMaosJogadores);
  for (var i = 0; i < informacoesCartas.length; i++) {
    print('\nCartas na mão do Jogador ${i + 1}:');
    for (var info in informacoesCartas[i]) {
      print('${info['contador']} ${info['carta']} - Valor: ${info['valor']}${info['marcador']}');
    }
  }

  // Inicia a lógica do jogo
  bool jogoContinua = true;
  List<Carta> mesa = [];
  List<List<Carta>> cartasJogadasNaMesa = [];

  while (jogoContinua) {
  cartasJogadasNaMesa.clear(); // Limpa as cartas jogadas na mesa a cada rodada
  for (var jogador in jogadores) {
    Carta? cartaJogada = jogador.obterCartaDaMao();

    if (cartaJogada != null) {
      jogador.jogarCarta(mesa, cartaJogada);
      // Adiciona a carta jogada na mesa
      cartasJogadasNaMesa.add([jogador, cartaJogada]); // Adiciona o jogador junto com a carta jogada
    } else {
      jogoContinua = false;
      break;
    }
  }

  if (!jogoContinua) {
    break; // Se o jogo acabou, sai do loop
  }

  // Chama a função para comparar as cartas jogadas e determinar o vencedor
  Jogador? jogadorVencedor = Jogo.compararCartas(cartasJogadasNaMesa);

  if (jogadorVencedor != null) {
    print('${jogadorVencedor.nome} ganhou a rodada!');
  } else {
    print('Empate!');
  }
}
}