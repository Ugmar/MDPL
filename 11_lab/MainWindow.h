#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QWidget>
#include <cstdint>

class GridWidget;
class QPushButton;
class QTimer;

class MainWindow : public QWidget {
public:
    explicit MainWindow(QWidget *parent = nullptr);
private:
    GridWidget *gridWidget;
    QPushButton *btnStart;
    QPushButton *btnStop;
    QPushButton *btnClear;
    QTimer *timer;
    uint8_t nextGrid[66][66];
    void startSimulation();
    void stopSimulation();
    void computeNextGeneration();
};

#endif // MAINWINDOW_H
