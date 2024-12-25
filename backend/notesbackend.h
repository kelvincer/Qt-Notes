#ifndef NOTESBACKEND_H
#define NOTESBACKEND_H

#include <QObject>
#include <QQmlEngine>
#include <cmark.h>

class NotesBackend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString markdown READ markdown WRITE updateMarkdown NOTIFY markdownChanged)
    Q_PROPERTY(QString html READ html WRITE updateHtml NOTIFY htmlChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE updateCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int isInputFromBackend READ isInputFromBackend WRITE updateInputFromBackend NOTIFY inputFromBackendChanged)
    Q_PROPERTY(bool hasDescription READ hasDescription WRITE updateHasDescription NOTIFY hasDescriptionChanged)

    QString m_markdown;
    QString m_html;
    QString plainText;
    int m_cursorPosition;
    bool isAddingText;
    bool m_isInputFromBackend;
    bool m_hasDescription;
    int titleLength;
    QString noteTitle;
    QString titleContent;

    QString markdown();
    QString html();
    int cursorPosition();
    bool isInputFromBackend();
    bool hasDescription();

    void updateMarkdown(QString &markdownText);
    void updateHtml(QString &keyboardInput);
    void updateCursorPosition(const int &cursorPosition);
    void updateInputFromBackend(const bool &isInputFromBackend);
    void updateHasDescription(const bool &hasDescription);

    void processMarkdown(QString text);
    void transformKeyboardInput(QString text);
    bool isChangingTitle();
    bool isChangingDescription(QString text);
    bool isEndOfTitle();

public:

    explicit NotesBackend(QObject *parent = nullptr);
    Q_INVOKABLE void sendNoteDescription(QString description);

signals:

    void markdownChanged();
    void htmlChanged();
    void cursorPositionChanged();
    void inputFromBackendChanged();
    void hasDescriptionChanged();
};

#endif // NOTESBACKEND_H
