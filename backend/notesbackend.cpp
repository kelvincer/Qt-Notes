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

bool NotesBackend::spacePressed()
{
    return m_spacePressed;
}

int NotesBackend::titleLength()
{
    return m_titleLength;
}

QString NotesBackend::noteTitle()
{
    return m_noteTitle;
}

void NotesBackend::updateMarkdown(QString &markdownText)
{
    if (markdownText == m_markdown)
        return;

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

    for (QChar i : keyboardInput) {
        qDebug() << i;
    }
    
    if (spacePressed())
    {
        plainText.removeAt(cursorPosition() - 1);
        plainText.insert(cursorPosition() - 1, noBreakSpace);
        m_spacePressed = false;
        emit spacePressedChanged();
    }

    qDebug() << "title lengh 12:" << m_titleLength << "auto cursorPosition:" << cursorPosition();

    qDebug() << "isAddingText: " << isAddingText << " isChangingTitle: " << isChangingTitle();

    // Starting processing text
    if (isAddingText)
    {
        if (isChangingTitle())
        {
            // If cursor position is less than title length
            if (cursorPosition() < m_titleLength)
            {
                m_titleLength++;
                m_noteTitle = plainText.mid(0, m_titleLength);
            } // If cursor position is greater than title length
            else
            {
                m_titleLength = isEndOfTitle() ? m_titleLength : cursorPosition();
                m_noteTitle = plainText.mid(0, m_titleLength);
            }
        }
        else
        {
        }
    }
    else
    {
        if (isChangingTitle())
        {
            if (cursorPosition() < m_titleLength)
            {
                m_titleLength--;
                m_noteTitle = plainText.mid(0, m_titleLength);
            }
            else
            {
                m_titleLength = isEndOfTitle() ? m_titleLength : cursorPosition();
                m_noteTitle = plainText.mid(0, m_titleLength);
            }
        }
        else
        {
        }
    }

    qDebug() << "noteTitle: " << m_noteTitle << " titleLength: " << m_titleLength;

    qDebug() << "plainText: " << plainText;

    if (m_noteTitle == plainText)
    {
        m_hasDescription = false;
        emit hasDescriptionChanged();
    }

    // Showing input
    if (hasDescription())
    {

        QString desc = plainText.mid(m_titleLength + 1, plainText.length());

        for (QChar c : desc) {
            qDebug() << c;
        }

        qDebug() << "Description: " << plainText.mid(m_titleLength + 1, plainText.length());

        m_html = ("<h2>" + m_noteTitle.mid(0, m_titleLength) + "</h2>").append(("<p>" + plainText.mid(m_titleLength + 1, plainText.length()) + "</p>"));
    }
    else
    {
        m_html = "<h2>" + m_noteTitle + "</h2>";
    }

    qDebug() << "processHTML m_html: " << m_html;
}

bool NotesBackend::isChangingTitle()
{

    qDebug() << "cursorPosition: " << cursorPosition() << " titleLength: " << m_titleLength;

    // head forward
    if (m_titleLength == cursorPosition() - 1)
    {
        return true;
    }

    // head backward
    if (m_titleLength - 1 == cursorPosition())
    {
        return true;
    }

    // middle
    if (cursorPosition() < m_titleLength)
    {
        return true;
    }

    return false;
}

bool NotesBackend::isChangingDescription(QString text)
{
    return m_titleLength < cursorPosition();
}

bool NotesBackend::isEndOfTitle()
{
    return plainText.endsWith(paragraphSeparator) && titleLength() != 0;
}

int NotesBackend::descriptionLength()
{
    return plainText.mid(m_titleLength + 1, plainText.length()).length();
}

bool NotesBackend::containOnlyParagraphSeparatorCharacter(QString text)
{
    for(QChar c : text) {
        if (c != paragraphSeparator)
        {
            return false;
        }
    }
    return true;
}

void NotesBackend::updateHtml(QString &keyboardInput)
{
    qDebug() << "==================================";

    qDebug() << "plainText: " << plainText;
    qDebug() << "keyboardInput: " << keyboardInput;

    if (plainText == keyboardInput)
    {
        return;
    }

    if (containOnlyParagraphSeparatorCharacter(keyboardInput))
    {
        updateCursorPosition(0);
        updateHasDescription(false);
        updateNoteTitle("");
        updateTitleLength(0);
        plainText = "";
        return;
    }
    


    isAddingText = keyboardInput.length() > plainText.length();

    // const char* markdown = "# Hello, World!\n\nThis is a **Markdown** text.";
    // char* html = cmark_markdown_to_html(markdown, strlen(markdown), CMARK_OPT_DEFAULT);

    // free(html);

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

void NotesBackend::updateSpacePressed(const bool &spacePressed)
{
    if (spacePressed == m_spacePressed)
        return;

    m_spacePressed = spacePressed;

    emit spacePressedChanged();
}

void NotesBackend::updateTitleLength(const int &titleLength)
{
    if(titleLength == m_titleLength)
        return;

    m_titleLength = titleLength;
}

void NotesBackend::updateNoteTitle(const QString &noteTitle)
{
    if(noteTitle == m_noteTitle)
        return;

    m_noteTitle = noteTitle;
}
