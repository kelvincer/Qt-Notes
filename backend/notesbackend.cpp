#include "notesbackend.h"

NotesBackend::NotesBackend(QObject *parent)
    : QObject{parent}
{
    qDebug() << "initial: " << m_markdown;
    qDebug() << "len init: " << m_cursorPosition;
}

void NotesBackend::sendNoteDescription(QString description)
{
    if (description == m_markdown)
        return;

    qDebug() << "MARKDOWN 2: " << description;

    processMarkdown(description);

    // QStringList s = description.split("\n\n");

    // for (QString & str : s) {
    //     qDebug() << str;
    // }
}

QString NotesBackend::markdown()
{
    // QString markdown = "# Rosario 3421";

    // markdown.append("\nnew line");

    return m_markdown;
}

QString NotesBackend::html()
{
    return m_html;
}

int NotesBackend::cursorPosition()
{
    return m_cursorPosition;
}

bool NotesBackend::isInputFromBackend()
{
    return m_isInputFromBackend;
}

bool NotesBackend::hasDescription()
{
    return m_hasDescription;
}

void NotesBackend::updateMarkdown(QString &markdownText)
{
    if (markdownText == m_markdown)
        return;

    qDebug() << "MARKDOWN: " << markdownText;
    qDebug() << "local before : " << m_markdown;

    processMarkdown(markdownText);

    // QStringList s = description.split("\n\n");

    // for (QString & str : s) {
    //     qDebug() << str;
    // }

    emit markdownChanged();
}

void NotesBackend::processMarkdown(QString text)
{
    if (text.isEmpty())
    {
        m_markdown = " ";
        return;
    }

    QStringList textList = text.split("\n\n");

    if (textList.size() == 2)
    {
        if (!textList[0].contains("#"))
            textList[0] = "# " + textList[0];
    }

    for (int i = 1; i < textList.size(); ++i)
    {
        // textList[i].replace("# ", "");
    }

    m_markdown = textList.join("\n\n");

    qDebug() << "m: " << m_markdown;
}

void NotesBackend::transformKeyboardInput(QString text)
{

    // int len = 10;

    // QString title = text.mid(0, len);

    qDebug() << "processHTML m_cursorPosition: " << m_cursorPosition;

    // if(isAddingText) {

    //     plainText.insert(m_cursorPosition - 1, );

    // } else {

    //     plainText.removeLast();

    // }

    plainText = text;

    if (!hasDescription())
    {
        titleLength = plainText.length();
    }

    if(text.length() <= titleLength) {
        updateHasDescription(false);
    }
    
    // updateInputFromBackend(true);

    if (m_hasDescription)
    {
        bool c = plainText.contains("\n\n");

        qDebug() << "Contains: " << c;

        qDebug() << "Description: " << plainText.mid(titleLength + 1, plainText.length());

        //m_html = " ";

        m_html = ("<h2>" + plainText.mid(0, titleLength) + "</h2>").append(("<p>" + plainText.mid(titleLength + 1, plainText.length()) + "</p>"));
    }
    else
    {
        m_html = "<h2>" + text + "</h2>";
    }

    qDebug() << "processHTML m_html: " << m_html;
}

void NotesBackend::updateHtml(QString &keyboardInput)
{

    keyboardInput = keyboardInput.simplified();

    qDebug() << "plainText: " << plainText;
    qDebug() << "keyboardInput: " << keyboardInput;

    if (plainText == keyboardInput)
    {
        return;
    }

    isAddingText = keyboardInput.length() > plainText.length();

    qDebug() << "updateHtml Len: " << m_cursorPosition;

    qDebug() << "updateHtml MARKDOWN: " << keyboardInput;

    // const char* markdown = "# Hello, World!\n\nThis is a **Markdown** text.";
    // char* html = cmark_markdown_to_html(markdown, strlen(markdown), CMARK_OPT_DEFAULT);

    // free(html);

    transformKeyboardInput(keyboardInput);

    int previousCursorPosition = m_cursorPosition;

    emit htmlChanged();

    if (keyboardInput.length() == previousCursorPosition - 1)
    {

        updateCursorPosition(keyboardInput.length());
    }
    else
    {
        updateCursorPosition(previousCursorPosition);
    }
}

void NotesBackend::updateCursorPosition(const int &newCursorPosition)
{
    if (newCursorPosition == m_cursorPosition)
        return;

    m_cursorPosition = newCursorPosition;

    qDebug() << "updateCursorPosition Len: " << m_cursorPosition;

    emit cursorPositionChanged();
}

void NotesBackend::updateInputFromBackend(const bool &isInputFromBackend)
{
    if (m_isInputFromBackend == isInputFromBackend)
        return;

    m_isInputFromBackend = isInputFromBackend;

    emit inputFromBackendChanged();
}

void NotesBackend::updateHasDescription(const bool &hasDescription)
{
    if (hasDescription == m_hasDescription)
        return;

    m_hasDescription = hasDescription;

    emit hasDescriptionChanged();
}
