#ifndef GRIDWIDGET_H
#define GRIDWIDGET_H

#include <QWidget>
#include <cstdint>

class QPaintEvent;
class QMouseEvent;

class GridWidget : public QWidget {
public:
    explicit GridWidget(QWidget *parent = nullptr);
    void clearGrid();
    uint8_t grid[66][66];
protected:
    void paintEvent(QPaintEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
};

#endif // GRIDWIDGET_H
