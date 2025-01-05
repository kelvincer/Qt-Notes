#include "format.h"

Format::Format(QObject *parent)
    : QObject{parent}
{
}

void Format::setSelectionBold(QString &text, int selectionStart, int selectionEnd)
{
    qDebug() << selectionStart << selectionEnd;

    qDebug() << "before" << text;

    qDebug() << "1" << subString(text, 0, selectionStart);
    qDebug() << "2" << subString(text, selectionStart, selectionEnd);
    qDebug() << "3" << subString(text, selectionEnd, text.length());

    text = subString(text, 0, selectionStart) + "<b>" + subString(text, selectionStart, selectionEnd) + "</b>" + subString(text, selectionEnd, text.length());

    qDebug() << "After" << text;
}

void Format::setDescriptionBold(QString &description, int selectionStart, int selectionEnd)
{
    QList<std::pair<int, int>>::iterator it = std::find(boldList.begin(), boldList.end(), std::make_pair(selectionStart, selectionEnd));

    if (it != boldList.end())
    {
        qDebug() << "bold:" << it - boldList.begin();
        boldList.remove(it - boldList.begin());
    }
    else
    {
        boldList.append(std::make_pair(selectionStart, selectionEnd));
    }

    std::sort(boldList.begin(), boldList.end(),
              [](std::pair<int, int> p1, std::pair<int, int> p2)
              { return p1.first > p2.first; });

    for (std::pair<int, int> pr : boldList)
    {
        setSelectionBold(description, pr.first, pr.second);
    }

    description = "<p>" + description + "</p>";

    qDebug() << "HTML" << description;
}

QString Format::subString(QString text, int start, int end)
{
    return text.mid(start, end - start);
}

bool operator==(const std::pair<int, int> p1, const std::pair<int, int> p2)
{
    if (p1.first == p2.first && p1.second == p2.second)
        return true;

    return false;
}
