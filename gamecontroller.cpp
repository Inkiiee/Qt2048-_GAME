#include "gamecontroller.h"
#include <QDebug>
#include <QFile>

void GameController::move_left(){
    for(int i=0; i<4; i++){
        for(int d=0; d<3; d++){
            for(int j=d + 1; j<4; j++){
                int idx = 4 * i + j;
                int kidx = 4 * i + d;

                if(m_map[idx] == 0) continue;
                else if(m_map[kidx] == 0){
                    m_map[kidx] = m_map[idx];
                    m_map[idx] = 0;
                    d--;
                    break;
                }
                else if(m_map[idx] == m_map[kidx]){
                    m_map[kidx] *= 2;
                    m_map[idx] = 0;
                    break;
                }
                else if(m_map[kidx] != m_map[idx]){
                    int next_idx = i*4 + d+1;
                    int temp = m_map[next_idx];
                    m_map[next_idx] = m_map[idx];
                    m_map[idx] = temp;
                    break;
                }
            }
        }
    }
    emit mapChanged();

    check_game_state();
}

void GameController::move_right(){
    for(int i=0; i<4; i++){
        for(int d=3; d>0; d--){
            for(int j=d - 1; j>=0; j--){
                int idx = 4 * i + j;
                int kidx = 4 * i + d;

                if(m_map[idx] == 0) continue;
                else if(m_map[kidx] == 0){
                    m_map[kidx] = m_map[idx];
                    m_map[idx] = 0;
                    d++;
                    break;
                }
                else if(m_map[idx] == m_map[kidx]){
                    m_map[kidx] *= 2;
                    m_map[idx] = 0;
                    break;
                }
                else if(m_map[kidx] != m_map[idx]){
                    int next_idx = i*4 + d-1;
                    int temp = m_map[next_idx];
                    m_map[next_idx] = m_map[idx];
                    m_map[idx] = temp;
                    break;
                }
            }
        }
    }
    emit mapChanged();

    check_game_state();
}

void GameController::move_up(){
    for(int j=0; j<4; j++){
        for(int d=0; d<3; d++){
            for(int i=d + 1; i<4; i++){
                int idx = 4 * i + j;
                int kidx = 4 * d + j;

                if(m_map[idx] == 0) continue;
                else if(m_map[kidx] == 0){
                    m_map[kidx] = m_map[idx];
                    m_map[idx] = 0;
                    d--;
                    break;
                }
                else if(m_map[idx] == m_map[kidx]){
                    m_map[kidx] *= 2;
                    m_map[idx] = 0;
                    break;
                }
                else if(m_map[kidx] != m_map[idx]){
                    int next_idx = (d+1) * 4 + j;
                    int temp = m_map[next_idx];
                    m_map[next_idx] = m_map[idx];
                    m_map[idx] = temp;
                    break;
                }
            }
        }
    }
    emit mapChanged();

    check_game_state();
}

void GameController::check_game_state(){
    bool isGameWin = false;
    int empty_panel_count = 0;

    for(int i=0; i<16; i++){
        if(m_map[i] == 2048) isGameWin = true;
        else if(m_map[i] == 0) empty_panel_count++;
    }

    if(isGameWin){
        if(m_score > m_max_score){
            m_max_score = m_score;
            QFile file("init_data");
            file.open(QFile::WriteOnly | QFile::Text);
            QTextStream out(&file);
            out<<"maxScore:"<<QString::number(m_max_score)<<"\n";
            file.close();
        }

        emit gameOver(1);
    }
    else if(empty_panel_count == 0){
        if(game_over_check()){
            if(m_score > m_max_score){
                m_max_score = m_score;
                QFile file("init_data");
                file.open(QFile::WriteOnly | QFile::Text);
                QTextStream out(&file);
                out<<"maxScore:"<<QString::number(m_max_score)<<"\n";
                file.close();
            }

            emit gameOver(0);
        }
    }
    else make_random();
}

void GameController::move_down(){
    for(int j=0; j<4; j++){
        for(int d=3; d>0; d--){
            for(int i=d - 1; i>=0; i--){
                int idx = 4 * i + j;
                int kidx = 4 * d + j;

                if(m_map[idx] == 0) continue;
                else if(m_map[kidx] == 0){
                    m_map[kidx] = m_map[idx];
                    m_map[idx] = 0;
                    d++;
                    break;
                }
                else if(m_map[idx] == m_map[kidx]){
                    m_map[kidx] *= 2;
                    m_map[idx] = 0;
                    break;
                }
                else if(m_map[kidx] != m_map[idx]){
                    int next_idx = (d-1) * 4 + j;
                    int temp = m_map[next_idx];
                    m_map[next_idx] = m_map[idx];
                    m_map[idx] = temp;
                    break;
                }
            }
        }
    }
    emit mapChanged();

    check_game_state();
}

QVector<int> GameController::get_map(){
    return m_map;
}

void GameController::make_random(){
    int idx = -1;
    while(true){
        idx = random_gen->bounded(16);
        if(m_map[idx] == 0) break;
    }

    int block = random_gen->bounded(2);
    if(block == 1) m_map[idx] = 4;
    else if(block == 0) m_map[idx] = 2;

    m_score += m_map[idx];
    emit createBlock(idx);
    emit scoreChanged();
}

void GameController::init(){
    if(!hasInitData){
        QFile file("init_data");
        if(!file.exists()){
            file.open(QFile::WriteOnly | QFile::Text);
            QTextStream out(&file);
            out<<"maxScore:"<<"0\n";
            file.close();
        }

        file.open(QFile::ReadOnly | QFile::Text);
        QTextStream in(&file);
        QString data = QString::fromUtf8(file.readLine());
        m_max_score = (data.split(":")[1].toInt());
    }

    m_map.fill(0, 16);
    m_score = 0;

    make_random();
    make_random();

    emit mapChanged();
}

bool GameController::game_over_check(){
    for(int i =0; i<4; i++)
        for(int j=0; j<4; j++){
            int up = (i > 0) ? (i - 1) * 4 + j : -1;
            int down = (i < 3) ? (i + 1) * 4 + j : -1;
            int left = (j > 0) ? i*4 + (j-1) : -1;
            int right = (j < 3) ? i*4 + (j+1) : -1;
            int cur = i*4 + j;

            if(up != -1 && m_map[cur] == m_map[up]) return false;
            else if(down != -1 && m_map[cur] == m_map[down]) return false;
            else if(left != -1 && m_map[left] == m_map[cur]) return false;
            else if(right != -1 && m_map[right] == m_map[cur]) return false;
        }

    return true;
}
