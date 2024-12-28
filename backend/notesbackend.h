#ifndef NOTESBACKEND_H
#define NOTESBACKEND_H

#include <QObject>
#include <QQmlEngine>

class NotesBackend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString markdown READ markdown WRITE updateMarkdown NOTIFY markdownChanged)
    Q_PROPERTY(QString html READ html WRITE updateHtml NOTIFY htmlChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE updateCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int isInputFromBackend READ isInputFromBackend WRITE updateInputFromBackend NOTIFY inputFromBackendChanged)
    Q_PROPERTY(bool hasDescription READ hasDescription WRITE updateHasDescription NOTIFY hasDescriptionChanged)
    Q_PROPERTY(bool spacePressed READ spacePressed WRITE updateSpacePressed NOTIFY spacePressedChanged)
    Q_PROPERTY(int titleLength READ titleLength WRITE updateTitleLength)
    Q_PROPERTY(QString noteTitle READ noteTitle WRITE updateNoteTitle)

    QString noBreakSpace = "\u00a0";
    QString paragraphSeparator = "\u2029";

    QString m_markdown;
    QString m_html;
    int m_cursorPosition;
    bool m_isInputFromBackend;
    bool m_hasDescription;
    bool m_spacePressed;
    int m_titleLength;
    QString m_noteTitle;
    bool isAddingText;
    QString plainText;

    QString markdown();
    QString html();
    int cursorPosition();
    bool isInputFromBackend();
    bool hasDescription();
    bool spacePressed();
    int titleLength();
    QString noteTitle();

    void updateMarkdown(QString &markdownText);
    void updateHtml(QString &keyboardInput);
    void updateCursorPosition(const int &cursorPosition);
    void updateInputFromBackend(const bool &isInputFromBackend);
    void updateHasDescription(const bool &hasDescription);
    void updateSpacePressed(const bool &spacePressed);
    void updateTitleLength(const int & titleLength);
    void updateNoteTitle(const QString & noteTitle);

    void processMarkdown(QString text);
    void transformKeyboardInput(QString text);
    bool isChangingTitle();
    bool isChangingDescription(QString text);
    bool isEndOfTitle();
    int descriptionLength();
    bool containOnlyParagraphSeparatorCharacter(QString text);

public:

    explicit NotesBackend(QObject *parent = nullptr);
    Q_INVOKABLE void sendNoteDescription(QString description);

signals:

    void markdownChanged();
    void htmlChanged();
    void cursorPositionChanged();
    void inputFromBackendChanged();
    void hasDescriptionChanged();
    void spacePressedChanged();
    void titleLengthChanged();
};

#endif // NOTESBACKEND_H
