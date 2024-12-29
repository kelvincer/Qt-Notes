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
    for (QChar i : keyboardInput)
    {
        qDebug() << i;
    }

    if (spacePressed())
    {
        keyboardInput.removeAt(cursorPosition() - 1);
        keyboardInput.insert(cursorPosition() - 1, noBreakSpace);
        m_spacePressed = false;
        emit spacePressedChanged();
    }

    qDebug() << "cursor:" << cursorPosition();

    qDebug() << "titlelength before:" << m_titleLength << "title:" << m_noteTitle;

    qDebug() << "isAddingText:" << isAddingText << " isChangingTitle:" << isChangingTitle();

    // Starting processing text
    if (isAddingText)
    {
        if (isChangingTitle())
        {
            // When press enter in the middle of title
            if (std::count(keyboardInput.begin(), keyboardInput.end(), paragraphSeparator) >= 1 && keyboardInput[0] != paragraphSeparator)
            {
                m_noteTitle = keyboardInput.mid(0, keyboardInput.indexOf(paragraphSeparator));
                m_titleLength = m_noteTitle.length();
            }
            else
            {
                // If cursor position is less than title length
                if (cursorPosition() < m_titleLength)
                {
                    m_titleLength++;
                    m_noteTitle = keyboardInput.mid(0, m_titleLength);
                } // If cursor position is greater than title length
                else
                {
                    m_titleLength = textContainsTitle(keyboardInput) ? keyboardInput.indexOf(paragraphSeparator) : cursorPosition();
                    m_noteTitle = keyboardInput.mid(0, m_titleLength);
                }
            }
            // If cursor position is less than title length
            // if (cursorPosition() < m_titleLength)
            // {
            //     m_titleLength++;
            //     m_noteTitle = keyboardInput.mid(0, m_titleLength);
            // } // If cursor position is greater than title length
            // else
            // {
            //     m_titleLength = textContainsTitle(keyboardInput) ? keyboardInput.indexOf(paragraphSeparator) : cursorPosition();
            //     m_noteTitle = keyboardInput.mid(0, m_titleLength);
            // }
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
                m_noteTitle = keyboardInput.mid(0, m_titleLength);
            }
            else
            {
                // We joined title and description
                if (hasDescription() && !keyboardInput.contains(paragraphSeparator))
                {
                    m_noteTitle = keyboardInput;
                    m_titleLength = keyboardInput.length();
                }
                else
                {
                    qDebug() << "end para:" << isEndOfTitle(keyboardInput) << keyboardInput.indexOf(paragraphSeparator);

                    m_titleLength = textContainsTitle(keyboardInput) ? keyboardInput.indexOf(paragraphSeparator) : cursorPosition();
                    m_noteTitle = keyboardInput.mid(0, m_titleLength);
                }
            }
        }
        else
        {
        }
    }

    qDebug() << "titleLength after update:" << m_titleLength << "noteTitle after update:" << m_noteTitle;

    if (m_noteTitle == keyboardInput)
    {
        m_hasDescription = false;
        emit hasDescriptionChanged();
    }

    // Showing input
    if (hasDescription())
    {
        QString desc = plainText.mid(m_titleLength + 1, plainText.length());

        qDebug() << "Description: " << plainText.mid(m_titleLength + 1, plainText.length());

        m_html = ("<h2>" + m_noteTitle + "</h2>").append(("<p>" + keyboardInput.mid(m_titleLength + 1, keyboardInput.length()) + "</p>"));
    }
    else
    {
        m_html = "<h2>" + m_noteTitle + "</h2>";
    }

    qDebug() << "processHTML m_html: " << m_html;

    for (QChar t : m_noteTitle)
    {
        qDebug() << "t:" << t;
    }

    plainText = keyboardInput;

    qDebug() << "plainText: " << plainText;
}

bool NotesBackend::isChangingTitle()
{
    // if (std::count(plainText.begin(), plainText.end(), paragraphSeparator) >= 2)
    // {
    //     return false;
    // }

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

    // When joining title and description
    if (m_cursorPosition == m_titleLength && hasDescription())
    {
        return true;
    }

    return false;
}

bool NotesBackend::isChangingDescription(QString text)
{
    return m_titleLength < cursorPosition();
}

bool NotesBackend::isEndOfTitle(QString text)
{
    return text.endsWith(paragraphSeparator) && m_titleLength != 0;
}

int NotesBackend::descriptionLength()
{
    return plainText.mid(m_titleLength + 1, plainText.length()).length();
}

bool NotesBackend::textContainsTitle(QString &text)
{
    return text.contains(paragraphSeparator) && m_titleLength != 0;
}

bool NotesBackend::containOnlyParagraphSeparatorCharacter(QString &text)
{
    for (QChar c : text)
    {
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
        m_noteTitle = "";
        m_titleLength = 0;
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

    qDebug() << "updateCursorPosition func: " << m_cursorPosition;

    emit editorCursorPositionChanged();
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
