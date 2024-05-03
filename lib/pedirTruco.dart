import 'jogador.dart';

class Truco {
  Jogador? jogadorQuePediuTruco;
  Jogador? jogadorQueAceitouTruco;
  int pontosTruco = 3;

  void pedirTruco(Jogador jogador, Jogador outroJogador) {
    jogadorQuePediuTruco = jogador;
    print('${jogador.nome} pediu truco!');
    bool aceitou = outroJogador.responderTruco(jogador, pontosTruco);
    if (aceitou) {
      jogadorQueAceitouTruco = outroJogador;
      print('O truco foi aceito! A mão passa a valer $pontosTruco pontos.');
    } else {
      // Equipe adversária recusou o truco
      print('O truco foi recusado. A equipe que trucou recebe um ponto.');
      // Lógica para incrementar a pontuação da equipe que trucou
    }
  }

  void pedirAumentoTruco(Jogador jogador, Jogador outroJogador) {
    print('${jogador.nome} pediu aumento de truco para ${pontosTruco * 2}.');
    bool aceitou = outroJogador.responderTruco(jogador, pontosTruco * 2);
    if (aceitou) {
      pontosTruco *= 2;
      print('O aumento de truco foi aceito! A mão passa a valer $pontosTruco pontos.');
    } else {
      // Equipe adversária recusou o aumento de truco
      print('O aumento de truco foi recusado. A equipe que pediu o aumento recebe ${pontosTruco * 2 - 3} pontos.');
      // Lógica para incrementar a pontuação da equipe que pediu o aumento
    }
  }

  void aceitarTruco() {
    print('${jogadorQueAceitouTruco!.nome} aceitou o truco! A mão passa a valer $pontosTruco pontos.');
  }

  void aceitarAumentoTruco() {
    print('${jogadorQueAceitouTruco!.nome} aceitou o aumento de truco para ${pontosTruco * 2} pontos.');
    pontosTruco *= 2;
  }

  void recusarTruco() {
    print('${jogadorQuePediuTruco!.nome} recusou o truco! A equipe adversária recebe um ponto.');
    // Lógica para incrementar a pontuação da equipe adversária
  }

  void recusarAumentoTruco() {
    print('${jogadorQuePediuTruco!.nome} recusou o aumento de truco para ${pontosTruco * 2} pontos.');
    // Lógica para incrementar a pontuação da equipe adversária
  }
}
