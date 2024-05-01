import 'package:tuple/tuple.dart';
import 'valorCarta.dart';
import 'baralho.dart'; 
import 'consoles.dart';
import 'jogador.dart';
import 'jogo.dart';

void main() {
   

  // Pergunta ao usuário quantos jogadores deseja
  int? numeroJogadores = obterNumeroJogadores();
  print('Número de jogadores selecionado: $numeroJogadores');

  // Cria o baralho
  Baralho baralho = Baralho();

  Jogo jogo = Jogo();

  // Criando os jogadores
  List<Jogador> jogadores = [];
  List<List<Jogador>> gruposDeJogadores = [];
 

// Criando os jogadores e agrupando conforme a lógica especificada
int numeroGrupos = (numeroJogadores / 2).ceil();
for (int i = 1; i <= numeroJogadores; i++) {
  int grupo = (i % 2 == 0) ? 2 : 1; // Alterado para intercalar os grupos
  Jogador jogador = Jogador('$i', grupo);
  jogadores.add(jogador);
}

// Adiciona os jogadores agrupados à lista de grupos de jogadores
for (int i = 0; i < numeroGrupos; i++) {
  gruposDeJogadores.add([
    jogadores[i * 2], // Alterado para pegar jogadores de grupos diferentes
    jogadores[i * 2 + 1], // Alterado para pegar jogadores de grupos diferentes
  ]);
}


    // Chamando o método para finalizar a rodada e distribuir novas cartas no início do jogo e ao final de cada rodada
  jogo.finalizarRodada(jogadores, baralho, numeroJogadores);

  // Chamando a função iniciarJogo
  jogo.iniciarJogo(jogadores, numeroJogadores);
  
}
