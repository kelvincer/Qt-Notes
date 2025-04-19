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
    Q_PROPERTY(QString html READ html WRITE updateHtml NOTIFY htmlChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE updateCursorPosition NOTIFY editorCursorPositionChanged)
    Q_PROPERTY(int isInputFromBackend READ isInputFromBackend WRITE updateInputFromBackend NOTIFY inputFromBackendChanged)
    Q_PROPERTY(bool spacePressed READ spacePressed WRITE updateSpacePressed NOTIFY spacePressedChanged)
    Q_PROPERTY(Format* format READ format WRITE updateFormat NOTIFY formatChanged)

    Q_PROPERTY(QString md READ md WRITE setMd NOTIFY mdChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(QStringList blocks READ blocks WRITE setBlocks NOTIFY blocksChanged FINAL)

    QString noBreakSpace = "\u00a0";
    QString paragraphSeparator = "\u2029";
    std::u16string u16ParagraphSeparator = u"\u2029";
    QString titleStarted = "#\u00A0";
    QString newline = "\n";

    QStringList m_blocks;
    int m_cursorPosition = 0;
    QString m_md;
    QString mdText;
    QString m_html;
    bool m_isInputFromBackend;
    bool m_spacePressed;
    int m_titleLength;
    Format * m_format;
    bool isAddingText;
    QString plainText;
    QList<Note> notes = QList<Note>(10);
    int currentIndex;
    QString itemTitle;
    QString itemDescription = "";

    QStringList blocks();
    QString md();
    QString html();
    int cursorPosition();
    bool isInputFromBackend();
    bool spacePressed();
    Format * format();

    void updateHtml(QString &keyboardInput);
    void updateCursorPosition(const int &cursorPosition);
    void updateInputFromBackend(const bool &isInputFromBackend);
    void updateHasDescription(const bool &hasDescription);
    void updateSpacePressed(const bool &spacePressed);
    void updateFormat(Format * format);
    void setMd(QString md);
    void setCursorPosition(int position);
    void setBlocks(QStringList blocks);

    void transformKeyboardInput(QString text);
    bool isChangingTitle(const QString &text);
    bool isChangingDescription(QString text);
    int descriptionLength();
    bool containOnlyParagraphSeparatorCharacter(QString &text);
    bool keyboardInputContainsDescription(const QString &text);
    bool isEnterPressedOnTitle(const QString &text);
    QString getNewTitleFromKeyboardInput(const QString & text);

    std::string remove_non_breaking_spaces(const std::string &in) const;
    bool isH1Title(QString title) const;
    bool isH1Title(std::string & title) const;
    bool isStartingH1Title(QString title) const;
    bool isH1TitleWithNewline(std::string & title) const;
    bool isStartingH1TitleWithNewLine(QString title) const;

public:
    explicit NotesBackend(QObject *parent = nullptr);
    Q_INVOKABLE void setNoteTitle(QString title);
    Q_INVOKABLE void setTitleLength(int length);
    Q_INVOKABLE void setCurrentIndex(int index);
    Q_INVOKABLE void setBoldFormat(QString text, int selectionStart, int selectionEnd);

signals:

    void htmlChanged();
    void editorCursorPositionChanged();
    void inputFromBackendChanged();
    void spacePressedChanged();
    void titleLengthChanged();
    void formatChanged();
    void mdChanged();
    void cursorPositionChanged();
    void blocksChanged();

    void titleOrDescriptionChanged(QString title, QString description);
};

#endif // NOTESBACKEND_H
