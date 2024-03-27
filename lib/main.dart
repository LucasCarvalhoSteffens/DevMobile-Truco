import 'carta.dart';
import 'baralho.dart'; 
import 'consoles.dart';


void main() {

  // Cria o baralho
  Baralho baralho = Baralho();

  //Embaralha as castas, garante sempre jogos diferentes
  baralho.embaralhar();

  // Pergunta ao usuário quantos jogadores deseja
  int numeroJogadores = obterNumeroJogadores();
  print('Número de jogadores selecionado: $numeroJogadores');

  //print('baralho antes de distribuir cartas: ${baralho.cartas}');

  // Distribui as cartas para os jogadores
  List<List<Carta>> todasMaosJogadores = baralho.distribuirCartasParaJogadores(numeroJogadores, baralho);

  //print('baralho depois de distruibuir as cartas: ${baralho.cartas}');

  //Define a ultima carta virada como manilha
  baralho.cartas[0].ehManilha = true;
 
  //Define qual carta será virada na mesa
  Carta manilha = baralho.cartas.firstWhere((carta) => carta.ehManilha);
  
  print('\nA manilha VIRADA é: $manilha');

  //Define as manilhas reais, que poderão estar nas mãos dos jogadores
  List<Carta> manilhasReais = baralho.definirManilhaReal(manilha);

  print('\nManilhas REAIS são: $manilhasReais \n'); 

  // Atribui pontos nas manilhas para todas as mãos de jogadores
  baralho.verificarManilha(todasMaosJogadores, manilhasReais);

  //Mostra as cartas, valores e qual é manilha
  mostrarValoresCartas(todasMaosJogadores);
}