#ifndef FORMAT_H
#define FORMAT_H

#include <QObject>
#include <QQmlEngine>

class Format : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    QList<std::pair<int, int>> boldList;

    QString subString(QString string, int start, int end);
    friend bool operator==(const std::pair<int, int> p1, const std::pair<int, int> p2);

public:
    explicit Format(QObject *parent = nullptr);

    void setSelectionBold(QString & text, int selectionStart, int selectionEnd);
    void setDescriptionBold(QString & text, int selectionStart, int selectionEnd);


signals:
};

#endif // FORMAT_H
