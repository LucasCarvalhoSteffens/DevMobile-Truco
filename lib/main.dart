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
    for (int i = 1; i <= numeroJogadores; i++) {
      Jogador jogador = Jogador('Jogador $i');
      jogadores.add(jogador);
    }

    // Chamando o método para finalizar a rodada e distribuir novas cartas no início do jogo e ao final de cada rodada
  jogo.finalizarRodada(jogadores, baralho, numeroJogadores);

  // Chamando a função iniciarJogo
  jogo.iniciarJogo(jogadores, numeroJogadores);
  
}