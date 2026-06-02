#include "MainWindow.h"
#include "GridWidget.h"

#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QPushButton>
#include <QTimer>
#include <cstring>
#include <algorithm>

MainWindow::MainWindow(QWidget *parent) : QWidget(parent) {
    QVBoxLayout *mainLayout = new QVBoxLayout(this);
    gridWidget = new GridWidget(this);
    mainLayout->addWidget(gridWidget);

    QHBoxLayout *btnLayout = new QHBoxLayout();
    btnStart = new QPushButton("Старт", this);
    btnStop = new QPushButton("Стоп", this);
    btnClear = new QPushButton("Очистить", this);
    
    btnLayout->addWidget(btnStart);
    btnLayout->addWidget(btnStop);
    btnLayout->addWidget(btnClear);
    mainLayout->addLayout(btnLayout);

    timer = new QTimer(this);

    connect(btnStart, &QPushButton::clicked, this, &MainWindow::startSimulation);
    connect(btnStop, &QPushButton::clicked, this, &MainWindow::stopSimulation);
    connect(btnClear, &QPushButton::clicked, gridWidget, &GridWidget::clearGrid);
    connect(timer, &QTimer::timeout, this, &MainWindow::computeNextGeneration);

    btnStop->setEnabled(false);
}

void MainWindow::startSimulation() {
    btnStart->setEnabled(false);
    btnClear->setEnabled(false);
    btnStop->setEnabled(true);
    timer->start(1000);
}

void MainWindow::stopSimulation() {
    timer->stop();
    btnStart->setEnabled(true);
    btnClear->setEnabled(true);
    btnStop->setEnabled(false);
}

void MainWindow::computeNextGeneration() {
    std::memset(nextGrid, 0, sizeof(nextGrid));

    alignas(32) uint8_t vec3[32];
    alignas(32) uint8_t vec2[32];
    alignas(32) uint8_t vec1[32];
    std::fill_n(vec3, 32, 3);
    std::fill_n(vec2, 32, 2);
    std::fill_n(vec1, 32, 1);

    for (int r = 1; r <= 64; ++r) {
        for (int c : {1, 33}) {
            const uint8_t* t = &gridWidget->grid[r - 1][c];
            const uint8_t* m = &gridWidget->grid[r][c];
            const uint8_t* b = &gridWidget->grid[r + 1][c];
            uint8_t* d = &nextGrid[r][c];

            __asm {
                mov rax, t
                mov rcx, m
                mov rdx, b
                mov r8, d

                vmovdqu ymm0, [rax - 1]
                vmovdqu ymm1, [rax]
                vmovdqu ymm2, [rax + 1]
                vpaddb ymm1, ymm1, ymm0
                vpaddb ymm1, ymm1, ymm2

                vmovdqu ymm3, [rcx - 1]
                vmovdqu ymm4, [rcx]
                vmovdqu ymm5, [rcx + 1]
                vpaddb ymm3, ymm3, ymm4
                vpaddb ymm3, ymm3, ymm5

                vmovdqu ymm5, [rdx - 1]
                vmovdqu ymm6, [rdx]
                vmovdqu ymm7, [rdx + 1]
                vpaddb ymm6, ymm6, ymm5
                vpaddb ymm6, ymm6, ymm7

                vpaddb ymm1, ymm1, ymm3
                vpaddb ymm1, ymm1, ymm6

                vpsubb ymm1, ymm1, ymm4

                lea r9, vec3
                vmovdqa ymm5, [r9]
                vpcmpeqb ymm2, ymm1, ymm5

                lea r9, vec2
                vmovdqa ymm6, [r9]
                vpcmpeqb ymm3, ymm1, ymm6
                vpand ymm3, ymm3, ymm4

                vpor ymm2, ymm2, ymm3

                lea r9, vec1
                vmovdqa ymm7, [r9]
                vpand ymm2, ymm2, ymm7

                vmovdqu [r8], ymm2
            }
        }
    }

    std::memcpy(gridWidget->grid, nextGrid, sizeof(nextGrid));
    gridWidget->update();
}
