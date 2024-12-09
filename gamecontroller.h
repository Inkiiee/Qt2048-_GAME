#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#include <QObject>
#include <QRandomGenerator>
#include <QVector>
#include <QTime>

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int score READ score NOTIFY scoreChanged)
public:
    explicit GameController(QObject* parent = nullptr): QObject(parent){
        random_gen = new QRandomGenerator(QTime::currentTime().second() + QTime::currentTime().msec());
    }
    int score() const {return m_score;}

    Q_INVOKABLE QVector<int> get_map();
    Q_INVOKABLE void init();
    Q_INVOKABLE void move_left();
    Q_INVOKABLE void move_right();
    Q_INVOKABLE void move_up();
    Q_INVOKABLE void move_down();
    Q_INVOKABLE void make_random();
    Q_INVOKABLE int get_max_score(){return m_max_score;}
    void check_game_state();

    ~GameController(){delete random_gen;}

signals:
    void scoreChanged();
    void mapChanged();
    void gameOver(int win);
    void createBlock(int idx);

private:
    QRandomGenerator * random_gen;
    QVector<int> m_map;
    int m_score = 0;
    int m_max_score = 0;
    bool hasInitData = false;

    bool game_over_check();
    void cal_score();
};

#endif // GAMECONTROLLER_H
