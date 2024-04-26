import 'package:tuple/tuple.dart';
import 'valorCarta.dart';
import 'baralho.dart'; 
import 'consoles.dart';
import 'jogador.dart';
import 'jogo.dart';

void main() {
  List<List<Jogador>> gruposDeJogadores = [];

  // Pergunta ao usuário quantos jogadores deseja
  int? numeroJogadores = obterNumeroJogadores();
  print('Número de jogadores selecionado: $numeroJogadores');

  // Cria o baralho
  Baralho baralho = Baralho();

  Jogo jogo = Jogo();

  // Criando os jogadores
  List<Jogador> jogadores = [];
  int numeroGrupos = (numeroJogadores! / 2).toInt(); // Definindo o número de grupos

    // Criando os jogadores e agrupando conforme a lógica especificada
    for (int i = 1; i <= numeroJogadores; i++) {
    int grupo = (i <= numeroGrupos) ? 1 : 2; // Determina o grupo do jogador
    Jogador jogador = Jogador('$i', grupo);
    jogadores.add(jogador);
  }

  // Agrupa os jogadores conforme a lógica especificada
  for (int i = 0; i < numeroGrupos; i++) {
    gruposDeJogadores.add([
      jogadores[i],
      jogadores[i + numeroGrupos],
    ]);
  }

    // Chamando o método para finalizar a rodada e distribuir novas cartas no início do jogo e ao final de cada rodada
  jogo.finalizarRodada(jogadores, baralho, numeroJogadores);

  // Chamando a função iniciarJogo
  jogo.iniciarJogo(jogadores, numeroJogadores, numeroGrupos, gruposDeJogadores);
  
}
