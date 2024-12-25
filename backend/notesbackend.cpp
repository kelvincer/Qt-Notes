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
}

QString NotesBackend::markdown()
{
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

void NotesBackend::transformKeyboardInput(QString keyboardInput)
{
    plainText = keyboardInput;

    qDebug() << "title lengh 12:" << titleLength << "auto cursorPosition:" << cursorPosition();

    if (isEndOfTitle())
    {
        qDebug() << "ends with paragraph";
    }

    if (isAddingText)
    {
        if (isChangingTitle())
        {
            titleLength = isEndOfTitle() ? titleLength : cursorPosition();
            noteTitle = plainText.mid(0, titleLength);
        }
        else
        {
        }
    }
    else
    {
        if (isChangingTitle())
        {
            qDebug() << "isChangingTitle";
            titleLength = isEndOfTitle() ? titleLength : cursorPosition();
            noteTitle = plainText.mid(0, titleLength);
        }
        else
        {
        }
    }

    qDebug() << "noteTitle: " << noteTitle;

    qDebug() << "plainText: " << plainText;

    if (noteTitle == plainText)
    {
        m_hasDescription = false;
        emit hasDescriptionChanged();
    }

    if (hasDescription())
    {
        qDebug() << "Description: " << plainText.mid(titleLength - 1, plainText.length());

        m_html = ("<h2>" + noteTitle.mid(0, titleLength) + "</h2>").append(("<p>" + plainText.mid(titleLength + 1, plainText.length()) + "</p>"));
    }
    else
    {
        if (plainText.length() < noteTitle.length())
        {
            m_html = "<h2>" + plainText + "</h2>";
        }
        else
        {
            m_html = "<h2>" + noteTitle + "</h2>";
        }
    }

    qDebug() << "processHTML m_html: " << m_html;
}

bool NotesBackend::isChangingTitle()
{
    qDebug() << "titleLength: " << titleLength << " cursorPosition: " << cursorPosition();

    // forward
    if (titleLength == cursorPosition() - 1)
    {
        return true;
    }

    // backward
    if (titleLength - 1 == cursorPosition())
    {
        return true;
    }

    return false;
}

bool NotesBackend::isChangingDescription(QString text)
{
    return titleLength < cursorPosition();
}

bool NotesBackend::isEndOfTitle()
{
    return plainText.endsWith("\u2029");
}

void NotesBackend::updateHtml(QString &keyboardInput)
{
    // keyboardInput = keyboardInput.trimmed();
    qDebug() << "==================================";

    qDebug() << "plainText: " << plainText;
    qDebug() << "keyboardInput: " << keyboardInput;

    if (plainText == keyboardInput)
    {
        return;
    }

    isAddingText = keyboardInput.length() > plainText.length();

    qDebug() << "updateHtml cursorPosition: " << m_cursorPosition;

    // const char* markdown = "# Hello, World!\n\nThis is a **Markdown** text.";
    // char* html = cmark_markdown_to_html(markdown, strlen(markdown), CMARK_OPT_DEFAULT);

    // free(html);

    qDebug() << "updateHtml ch title: " << isChangingTitle();

    transformKeyboardInput(keyboardInput);

    int automaticCursorPosition = m_cursorPosition;

    qDebug() << "m_cursorPosition pre: " << m_cursorPosition;

    emit htmlChanged();

    qDebug() << "m_cursorPosition post: " << m_cursorPosition;

    updateCursorPosition(automaticCursorPosition);
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
