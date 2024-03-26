import 'dart:math';

class Carta {
  final String valor;
  final String naipe;
  bool ehManilha;
  int valorManilha;

  // Construtor da classe Carta
  Carta(this.valor, this.naipe, {this.ehManilha = false}) : valorManilha = 0;

  // Método toString para representação em string da carta
  @override
  String toString() {
    return '{$valor,$naipe}';
  }

  // Método para converter o valor da carta em inteiro
  int valorToInt() {
    switch (valor) {
      case '3':
        return 10;
      case '2':
        return 9;
      case 'A':
        return 8;
      case 'K':
        return 7;
      case 'J':
        return 6;
      case 'Q':
        return 5;
      case '7':
        return 4;
      case '6':
        return 3;
      case '5':
        return 2;
      case '4':
        return 1;
      default:
        return 0;
    }
  }
}

class Baralho {
  List<Carta> _cartas = [];

  // Construtor da classe Baralho
  Baralho() {
    // Cria as cartas do baralho
    final naipes = ['Paus', 'Copas', 'Espadas', 'Ouros'];
    final valores = ['2', '3', '4', '5', '6', '7', 'Q', 'J', 'K', 'A'];

    // Cria todas as combinações de cartas
    for (final naipe in naipes) {
      for (final valor in valores) {
        _cartas.add(Carta(valor, naipe));
      }
    }
  }

  // Método para embaralhar as cartas
  void embaralhar() {
    _cartas.shuffle();
  }

  // Método para definir a manilha do jogo
  void definirManilha() {
    int indexManilha = _cartas.indexWhere((carta) => carta.ehManilha);
    if (indexManilha != -1) {
      String valorManilha = _cartas[indexManilha].valor;
      String naipeManilha = _cartas[indexManilha].naipe;
      for (var i = 0; i < _cartas.length; i++) {
        if (_cartas[i].valor == valorManilha && _cartas[i].naipe != naipeManilha) {
          _cartas[i].ehManilha = true;
          break;
        }
      }
    }
  }

  // Método para definir as cartas que representam a manilha real
  List<Carta> definirManilhaReal(Carta cartaVirada) {
    int valorManilhaVirada = cartaVirada.valorToInt();
    int valorProximaManilha = (valorManilhaVirada + 1) % 11;

    // Verificar se a manilha virada é o 3 e definir a próxima como o 4
    if (valorManilhaVirada == 10) {
      valorProximaManilha = 1; // Valor do 4
    }

    // Lista para armazenar as cartas que representam a manilha real
    List<Carta> manilhasReais = [];

    // Encontrar todas as cartas que representam a manilha real com base nos valores definidos
    for (var valor in ['2', '3', '4', '5', '6', '7', 'Q', 'J', 'K', 'A']) {
      for (var naipe in ['Paus', 'Copas', 'Espadas', 'Ouros']) {
        var cartaPossivel = Carta(valor, naipe);
        if (cartaPossivel.valorToInt() == valorProximaManilha) {
          manilhasReais.add(cartaPossivel);
        }
      }
    }

    // Retorna as cartas que representam a manilha real
    return manilhasReais;
  }

  // Método para distribuir cartas aos jogadores
  List<Carta> distribuirCartas(int quantidade) {
    List<Carta> cartasDistribuidas = [];
    for (var i = 0; i < quantidade; i++) {
      if (_cartas.isEmpty) {
        print('O baralho está vazio!');
        break;
      }
      cartasDistribuidas.add(_cartas.removeAt(0));
    }
    return cartasDistribuidas;
  }
}

// Função para atribuir pontos às manilhas nas mãos dos jogadores
void pontosManilhas(List<Carta> maoJogador, List<Carta> manilhasReais) {
  for (var carta in maoJogador) {
    for (var manilha in manilhasReais) {
      if (manilha.valor == carta.valor && manilha.naipe == carta.naipe) {
        carta.ehManilha = true;
        // Atribuir valores às manilhas
        switch (manilha.naipe) {
          case 'Paus':
            carta.valorManilha = 14;
            break;
          case 'Copas':
            carta.valorManilha = 13;
            break;
          case 'Espadas':
            carta.valorManilha = 12;
            break;
          case 'Ouros':
            carta.valorManilha = 11;
            break;
        }
      }
    }
  }
}


// Função para mostrar os valores das cartas da mão dos jogadores
void mostrarValoresCartas(List<Carta> maoJogador) {
  for (var carta in maoJogador) {
    // Valor da carta considerando a manilha
    int valorCarta = carta.valorToInt();
    String marcador = carta.ehManilha ? ' M' : ''; // Marcador "M" para manilhas
    if (carta.ehManilha) {
      valorCarta = carta.valorManilha;
    }
    print('Carta: $carta - Valor: $valorCarta$marcador');
  }
}


void main() {
  // CRIA AS CARTAS
  Baralho baralho = Baralho();

  //EMBARALHA AS CARTAS
  baralho.embaralhar();

  //DISTRIBUI DAS CARTAS
  List<Carta> maoJogador1 = baralho.distribuirCartas(3);
  List<Carta> maoJogador2 = baralho.distribuirCartas(3);

  // Simula a carta virada como manilha
  baralho._cartas[0].ehManilha = true;
  //Define qual carta será virada na mesa
  Carta manilha = baralho._cartas.firstWhere((carta) => carta.ehManilha);
  print('A manilha VIRADA é: $manilha');

  //DEFINE QUAL
  List<Carta> manilhasReais = baralho.definirManilhaReal(manilha);

  print('\nManilhas reais são: $manilhasReais \n'); 

  // Marcar as manilhas reais nas mãos dos jogadores
  pontosManilhas(maoJogador1, manilhasReais);
  pontosManilhas(maoJogador2, manilhasReais);

  // Mostrar os valores das cartas nas mãos dos jogadores
  print('\nValores das cartas na mão do Jogador 1:');
  mostrarValoresCartas(maoJogador1);

  print('\nValores das cartas na mão do Jogador 2:');
  mostrarValoresCartas(maoJogador2);
}