import 'jogador.dart';
import 'carta.dart';

class Jogo {
  static Jogador? compararCartas(List<List<dynamic>> cartasJogadasNaMesa) {
    if (cartasJogadasNaMesa.isEmpty) {
      return null; // Se não houver cartas jogadas na mesa, não há vencedor
    }
    
    List<dynamic> primeiraCartaJogada = cartasJogadasNaMesa[0];
    Carta cartaVencedora = primeiraCartaJogada[1];
    Jogador jogadorVencedor = primeiraCartaJogada[0];

    for (var cartaJogada in cartasJogadasNaMesa) {
      Carta carta = cartaJogada[1];
      Jogador jogador = cartaJogada[0];
      if (carta.valorToInt() > cartaVencedora.valorToInt()) {
        cartaVencedora = carta;
        jogadorVencedor = jogador;
      }
    }

    return jogadorVencedor;
  }
}

