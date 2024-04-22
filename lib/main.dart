import 'package:tuple/tuple.dart';
import 'valorCarta.dart';
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

  // Criando uma instância do jogo
  Jogo jogo = Jogo();

  // Criando os jogadores
  List<Jogador> jogadores = [];
  for (int i = 1; i <= numeroJogadores; i++) {
    Jogador jogador = Jogador('Jogador $i');
    jogador.mao = todasMaosJogadores[i - 1];
    jogadores.add(jogador);
  }

  // Chamando a função iniciarJogo
  jogo.iniciarJogo(jogadores);
}
