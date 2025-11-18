.data
.align 2
MSGBemVindo1: .asciiz "Bem vindo ao Master Mind\n"
MSGBemVindo2: .asciiz "Jogo feito por: Rayssa Santos e Tiago Chousal\n"
MSGCores1: .asciiz "Insira uma combinação de 4 cores para fazer uma tentativa\n"
MSGCores2: .asciiz "Possibilidades de escolhas: \nBlue (B) \nGreen (G) \nRed(R) \nYellow(Y) \nWhite(W) \nOrange(O)"
MSGTentativaInvalida: .asciiz "Tentativa invalida.\n Faça uma tentativa que obedeça as seguintes condições:\n"
MSGTentativaIncorreta1: .asciiz "Oh que pena. Não acertaste a combinação. Volta a tentar\n"
MSGTentativaIncorreta2: .asciiz "Tivestes " # O espaço é para o inteiro que seria ou para as bolas corretas ou incorretas
MSGTentativaIncorreta3: .asciiz "bolas incorretas\n"
MSGTentativaCorreta: .asciiz "bolas corretas\n"
MSGVitoria: .asciiz "PARABÉNS!!! Acertaste a combinação.\nMuito Inteligente"
MSGDerrota1: .asciiz "Oh que pena. Nao acertaste a cobinação ao fim de 10 tentativas\n"
MSGDerrota2: .asciiz "A sequencia correta de cores era: \n"
MSGPontuacao: .asciiz "Pontuação: \n"
MSGSettings1: .asciiz "Nesta parte é possível adicionar cores duplicadas ou remover Cores\n" # Depois vejo melhor essa parte
.text
.globl main

main: