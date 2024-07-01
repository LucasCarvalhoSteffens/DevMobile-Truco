import os
import requests

# Função para criar a pasta se não existir
def create_folder(folder_name):
    if not os.path.exists(folder_name):
        os.makedirs(folder_name)

# Função para baixar uma imagem
def download_image(url, file_path):
    response = requests.get(url)
    if response.status_code == 200:
        with open(file_path, 'wb') as file:
            file.write(response.content)

# Função para formatar o nome do arquivo
def format_filename(value, suit):
    suits = {
        "HEARTS": "Copas",
        "SPADES": "Espadas",
        "DIAMONDS": "Ouros",
        "CLUBS": "Paus"
    }
    special_values = {
        "QUEEN": "Q",
        "KING": "K",
        "JACK": "J",
        "ACE": "A"
    }
    
    if value in special_values:
        value_str = special_values[value]
    else:
        value_str = value.lower()
    
    return f"{value_str}.{suits[suit]}.png"

# Obter um novo baralho
response = requests.get('https://deckofcardsapi.com/api/deck/new/draw/?count=52')
if response.status_code == 200:
    cards = response.json()['cards']
    
    # Criar a pasta "imgs"
    create_folder('imgs')
    
    # Baixar cada imagem e salvar na pasta "imgs"
    for card in cards:
        value = card['value']
        suit = card['suit']
        image_url = card['image']
        
        # Formatar o nome do arquivo
        filename = format_filename(value, suit)
        file_path = os.path.join('imgs', filename)
        
        # Baixar a imagem
        download_image(image_url, file_path)
        
        print(f"Baixou {filename}")

    print("Todas as imagens foram baixadas e salvas na pasta 'imgs'.")
else:
    print("Falha ao obter o baralho.")
