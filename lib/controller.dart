
//Classe para implementar regras do jogo








//   // Cria instâncias de Jogador para representar os jogadores do jogo
//   List<Jogador> jogadores = [];
//   for (int i = 1; i <= numeroJogadores; i++) {
//     Jogador jogador = Jogador('Jogador $i');
//     jogador.mao = todasMaosJogadores[i - 1];
//     jogadores.add(jogador);
//   }

//   // Mostra as cartas, valores e qual é a manilha
 // List<List<dynamic>> informacoesCartas = obterInformacoesCartas(todasMaosJogadores);
  
//   //for apenas para mostras as cartas que estão nas mãos dos jogadores
//   for (var i = 0; i < informacoesCartas.length; i++) {
//     print('\nCartas na mão do Jogador ${i + 1}:');
//     for (var info in informacoesCartas[i]) {
//       print('${info['contador']} ${info['carta']} - Valor: ${info['valor']}${info['marcador']}');
//     }
//   }

//   print('\n\r');
//   //print(informacoesCartas);

//  // Inicia a lógica do jogo
// bool jogoContinua = true;
// List<Carta> mesa = [];
// List<Tuple2<Jogador, Map<String, dynamic>>> cartasJogadasNaMesa = [];

// while (jogoContinua) {
//   cartasJogadasNaMesa.clear(); // Limpa as cartas jogadas na mesa a cada rodada
  
//   // Jogadores jogam suas cartas na mesa
//   for (var i = 0; i < jogadores.length; i++) {
//     Jogador jogador = jogadores[i];
//     Map<String, dynamic>? infoCarta = jogador.obterCartaDaMao();

//     if (infoCarta != null) {
//       Carta cartaJogada = infoCarta['carta'];
//       jogador.jogarCarta(mesa, cartaJogada);
//       // Adiciona o jogador junto com a carta jogada na mesa
//       cartasJogadasNaMesa.add(Tuple2(jogador, infoCarta));
//       //print(cartasJogadasNaMesa);
//     } else {
//       jogoContinua = false; // Se um jogador não tem mais cartas, o jogo termina
//       break;
//     }
//   }

//   // Se o jogo não continuar, interrompe o loop
//   if (!jogoContinua) break;

//   // Chama a função para comparar as cartas jogadas e determinar o vencedor
//   Jogador? jogadorVencedor = Jogo.compararCartas(cartasJogadasNaMesa);
  

//   // Exibe o vencedor ou indica empate
//   if (jogadorVencedor != null) {
//     print('${jogadorVencedor.nome} ganhou a rodada!');
//     Jogo.contabilizarPontos(jogadorVencedor);
    
    
//   } else {
//     print('Empate!');
//   }
// }
// }

