#include "GridWidget.h"

#include <QPainter>
#include <QMouseEvent>
#include <cstring>

GridWidget::GridWidget(QWidget *parent) : QWidget(parent) {
    std::memset(grid, 0, sizeof(grid));
    setFixedSize(640, 640);
}

void GridWidget::clearGrid() {
    std::memset(grid, 0, sizeof(grid));
    update();
}

void GridWidget::paintEvent(QPaintEvent *event) {
    Q_UNUSED(event);
    QPainter painter(this);
    int cellW = width() / 64;
    int cellH = height() / 64;

    for (int r = 1; r <= 64; ++r) {
        for (int c = 1; c <= 64; ++c) {
            if (grid[r][c] == 1) {
                painter.fillRect((c - 1) * cellW, (r - 1) * cellH, cellW, cellH, Qt::black);
            } else {
                painter.drawRect((c - 1) * cellW, (r - 1) * cellH, cellW, cellH);
            }
        }
    }
}

void GridWidget::mousePressEvent(QMouseEvent *event) {
    int cellW = width() / 64;
    int cellH = height() / 64;
    auto pos = event->position();
    int c = (static_cast<int>(pos.x()) / cellW) + 1;
    int r = (static_cast<int>(pos.y()) / cellH) + 1;

    if (r >= 1 && r <= 64 && c >= 1 && c <= 64) {
        grid[r][c] ^= 1;
        update();
    }
}
