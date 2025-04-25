#ifndef NOTESBACKEND_H
#define NOTESBACKEND_H

#include <QObject>
#include <QQmlEngine>
#include <Note.h>
#include <notetable.h>
#include <format.h>
#include <string>
#include <cmutil.h>
#include <regex>
#include <algorithm>
#include <cmark.h>

class NotesBackend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(Format* format READ format WRITE updateFormat NOTIFY formatChanged)
    Q_PROPERTY(QString md READ md WRITE setMd NOTIFY mdChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)

    QString noBreakSpace = "\u00a0";
    //QString paragraphSeparator = "\u2029";
    //std::u16string u16ParagraphSeparator = u"\u2029";
    QString titleStarted = "#\u00A0";
    QString newline = "\n";
    QString zeroWidthSpace = "\u200B";

    QStringList m_blocks;
    int m_cursorPosition = 0;
    QString m_md;
    Format * m_format;
    int currentNoteIndex;
    QString itemTitle;
    QString itemDescription;

    QString md();
    QString html();
    int cursorPosition();
    bool isInputFromBackend();
    bool spacePressed();
    Format * format();

    QList<std::tuple<QStringList, int>> myNotes;
    bool isSameNote;

    void updateCursorPosition(const int &cursorPosition);
    void updateFormat(Format * format);
    void setMd(QString md);
    void setCursorPosition(int position);

    bool containOnlyParagraphSeparatorCharacter(QString &text);

    std::string remove_non_breaking_spaces(const std::string &in) const;
    bool isH1Title(QString title) const;
    bool isH1Title(std::string & title) const;
    bool isStartingH1Title(QString title) const;
    bool isH1TitleWithNewline(std::string & title) const;
    bool isStartingH1TitleWithNewLine(QString title) const;
    void removeZeroWidthSpace(QStringList & stringList);

public:
    explicit NotesBackend(QObject *parent = nullptr);
    Q_INVOKABLE void setCurrentIndex(int index);
    Q_INVOKABLE void setBoldFormat(QString text, int selectionStart, int selectionEnd);
    Q_INVOKABLE void sendListIndex(int index, bool isSameNote);
    Q_INVOKABLE void sendNoteInfo(QStringList blocks, int cursorPosition, bool isSameNote, int noteIndex);

signals:

    void editorCursorPositionChanged();
    void formatChanged();
    void mdChanged();
    void cursorPositionChanged();
    void updateTextArrayOnEditor(QStringList array);
    void addNewNoteChanged(QString title, QString description);
    void updateNoteChanged(QString title, QString description);
};

#endif // NOTESBACKEND_H
