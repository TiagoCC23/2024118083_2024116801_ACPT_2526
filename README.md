# 🧠 Mastermind MIPS

> Projeto prático desenvolvido em Assembly MIPS para a unidade curricular de Arquitetura de Computadores.

Este repositório contém uma implementação do clássico jogo de tabuleiro **Mastermind**, desenvolvido para correr no simulador **MARS** (MIPS Assembler and Runtime Simulator). O objetivo é adivinhar uma senha secreta de 4 cores gerada aleatoriamente, dentro de um número limitado de tentativas.

## 📋 Sobre o Projeto

* **Instituição:** Universidade Fernando Pessoa (UFP)
* **Disciplina:** Arquitetura de Computadores
* **Ano Letivo:** 2025/2026 
* **Linguagem:** Assembly MIPS
* **Ferramenta:** MARS Simulator

## ✨ Funcionalidades

O projeto cumpre os requisitos propostos, incluindo:

* **Geração Aleatória:** O sistema sorteia uma combinação secreta de 4 cores entre 6 possíveis (Azul, Verde, Vermelho, Amarelo, Branco, Laranja).
* **Validação Inteligente:** Algoritmo de verificação que identifica:
    * Cores corretas na posição certa ("Certas").
    * Cores corretas na posição errada ("Quase").
* **Input Seguro:** Tratamento de erros para entradas com tamanho incorreto e conversão automática de minúsculas para maiúsculas.
* **Menus de Navegação:** Sistema de menus para Iniciar Jogo, Definições e Sair.
* **Condições de Vitória/Derrota:** O jogo termina ao acertar a chave ou ao esgotar as 10 tentativas.

## 🚀 Como Executar (Instalação e Configuração)

Para rodar este projeto, é necessário ter o [MARS MIPS Simulator](http://courses.missouristate.edu/kenvollmar/mars/) instalado (requer Java).

### Passo a Passo

1.  Faça o clone deste repositório ou baixe os ficheiros `.asm`.
2.  Abra o **MARS**.
3.  Vá em **File -> Open** e selecione o ficheiro `main.asm` (ou o ficheiro principal do projeto).

### ⚠️ Configuração Importante (Não salte este passo!)

Como o projeto está dividido em múltiplos ficheiros (ex: `main.asm`, `EF.asm`, `gerador.asm`), você deve configurar o MARS da seguinte forma:

1.  No menu superior, clique em **Settings**.
2.  Ative a opção **"Assemble all files in directory"**.
3.  Ative a opção **"Initialize Program Counter to global 'main' if defined"**.

Sem estas opções ativadas, o programa pode não encontrar as funções externas ou não imprimir a sequência corretamente.

4.  Pressione **F3** (ou o ícone da chave de fendas) para compilar.
5.  Pressione **F5** (ou o botão Play) para iniciar.

## 🎮 Como Jogar

1.  **O Objetivo:** Descobrir a sequência de 4 cores gerada pelo computador.
2.  **As Cores:** As cores disponíveis são representadas pelas suas iniciais (em Inglês):
    * **B** - Blue (Azul)
    * **G** - Green (Verde)
    * **R** - Red (Vermelho)
    * **Y** - Yellow (Amarelo)
    * **W** - White (Branco)
    * **O** - Orange (Laranja)
3.  **Input:** Digite uma sequência de 4 letras e pressione Enter (ex: `RGBY`). O jogo aceita maiúsculas ou minúsculas.
4.  **Feedback:** Após cada tentativa, o jogo dirá:
    * Quantas cores estão **certas na posição certa**.
    * Quantas cores estão **certas mas na posição errada**.
5.  **Fim de Jogo:** Ganha se acertar a sequência exata. Perde se não conseguir após 10 tentativas.

## 👥 Autores

* **Rayssa Santos**
* **Tiago Chousal**

---
*Projeto desenvolvido para fins académicos.*
