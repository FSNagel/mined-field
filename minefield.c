
#include <stdio.h>

void printScreen(int *m_camp, int size);

int bombValid(int *m_camp, int i, int j, int size);

int areaBombs(int *m_camp, int i, int j, int size);

void calcBombs(int *m_camp, int size);

void insertBombs(int *m_camp, int size);

int play(int *m_camp, int *m_user, int size);

int verifyVictory(int *m_user, int *m_camp, int size);

int main()
{
    char difficult;
    int size = 5;

    int m_camp[81] = {0};
    int m_user[81] = {-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1,};

    int return_play;

    printf("Digite o nível de dificuldade, Fácil(F), intermediário(I), Difícil(D):\n");
    scanf("%c", &difficult);

    if(difficult == 'f'){
        printf("Você selecionou o modulo fácil!\n");
        size = 5;
    } else if(difficult == 'i'){
        printf("Você selecionou o modulo intermediário!\n");
        size = 7;
    } else {
        printf("Você selecionou o modulo difícil!\n");
        size = 9;
    }

    insertBombs(m_camp, size);

    calcBombs(m_camp, size);

    return_play = play(m_camp, m_user, size);

    if(return_play == 1){
        printf("Parabéns você venceu!!!!\n");
    } else {
        printf("GAME OVER!!!!\n");
    }

    printScreen(m_camp, size);

    return 0;
}

void printScreen(int *m_camp, int size){

    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            if(m_camp[i*size+j] == -1){
                printf("x | ");
            } else {
                printf("%d | ", m_camp[i*size+j]);
            }
        }
        printf("\n");
    }
}

int bombValid(int *m_camp, int i, int j, int size){

    if(i >= 0 && j >= 0 && i < size && j < size && m_camp[i*size+j] == 9){
        return 1;
    }

    return 0;

}

int areaBombs(int *m_camp, int i, int j, int size){
    int count = 0;

    if(bombValid(m_camp, (i+1), j, size)) count++;
    if(bombValid(m_camp, (i-1), j, size)) count++;
    if(bombValid(m_camp, i, (j+1), size)) count++;
    if(bombValid(m_camp, i, (j-1), size)) count++;
    if(bombValid(m_camp, (i-1), (j-1), size)) count++;
    if(bombValid(m_camp, (i-1), (j+1), size)) count++;
    if(bombValid(m_camp, (i+1), (j-1), size)) count++;
    if(bombValid(m_camp, (i+1), (j+1), size)) count++;

    return count;
}

void calcBombs(int *m_camp, int size){

    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            if(m_camp[i*size+j] != 9){
                m_camp[i*size+j] = areaBombs(m_camp, i, j, size);
            }
        }
    }
}

void insertBombs(int *m_camp, int size){
    int control_line = 1;
    int control_column = 1;

    while(control_line && control_column){
        printf("Digite onde você quer que tenha bomba, primeiro linha depois coluna: (0 para sair)\n");
        scanf("%d", &control_line);
        scanf("%d", &control_column);

        if(control_line && control_column){
            m_camp[(control_line-1)*size+(control_column-1)] = 9;
        }
    }
}

int play(int *m_camp, int *m_user, int size){
    int control_line = 1;
    int control_column = 1;
    int victory = 0;

    while(control_line && control_column){
        printf("Digite onde você quer abrir, primeiro linha depois coluna: (0 para sair)\n");
        scanf("%d", &control_line);
        scanf("%d", &control_column);

        if(control_line && control_column){
            m_user[(control_line-1)*size+(control_column-1)] = m_camp[(control_line-1)*size+(control_column-1)];
        }

        if(m_camp[(control_line-1)*size+(control_column-1)] == 9){
            return 0;
        }

        victory = verifyVictory(m_user, m_camp, size);

        if(victory == 1){
            return 1;
        }

        printScreen(m_user, size);
    }
}

int verifyVictory(int *m_user, int *m_camp, int size){
    int verify = 0;

    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            if(m_user[i*size+j] == -1 && m_camp[i*size+j] != 9){
                return 1;
            }
        }
    }

    return 0;
}