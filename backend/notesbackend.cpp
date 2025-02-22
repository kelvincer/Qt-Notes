#include "notesbackend.h"

NotesBackend::NotesBackend(QObject *parent)
    : QObject{parent}
{
    NoteTable notetable("tableName");
}

void NotesBackend::setNoteTitle(QString title)
{
    notes[currentIndex].title = title;
}

void NotesBackend::setTitleLength(int length)
{
    m_titleLength = length;
}

void NotesBackend::setCurrentIndex(int index)
{
    currentIndex = index;
}

void NotesBackend::setBoldFormat(QString text, int selectionStart, int selectionEnd)
{
    if(selectionStart > m_titleLength) 
    {
        QString description = text.mid(m_titleLength + 1, plainText.length() - m_titleLength - 1);
        format()->setDescriptionBold(description, selectionStart - m_titleLength - 1, selectionEnd - m_titleLength - 1);
        m_html = ("<h2>" + notes[currentIndex].title + "</h2>").append(description);
        emit htmlChanged();
    }
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

bool NotesBackend::spacePressed()
{
    return m_spacePressed;
}

Format *NotesBackend::format()
{
    return m_format;
}

void NotesBackend::transformKeyboardInput(QString keyboardInput)
{
    // for (QChar i : keyboardInput)
    // {
    //     qDebug() << i;
    // }

    if (spacePressed())
    {
        keyboardInput.removeAt(cursorPosition() - 1);
        keyboardInput.insert(cursorPosition() - 1, noBreakSpace);
        m_spacePressed = false;
        emit spacePressedChanged();
    }

    // qDebug() << "cursor:" << cursorPosition();

    // qDebug() << "titlelength before:" << m_titleLength << "title:" << m_noteTitle;

    // qDebug() << "isAddingText:" << isAddingText << " isChangingTitle:" << isChangingTitle(keyboardInput);

    // Starting processing text
    if (isAddingText)
    {
        if (isChangingTitle(keyboardInput))
        {
            // When press enter in the middle of title
            if(isEnterPressedOnTitle(keyboardInput))
            {
                notes[currentIndex].title = getNewTitleFromKeyboardInput(keyboardInput);
                //m_noteTitle = keyboardInput.mid(0, keyboardInput.lastIndexOf(paragraphSeparator));
                m_titleLength = notes[currentIndex].title.length();
                qDebug() << "123";
            }
            else
            {
                // If cursor position is less than title length
                if (cursorPosition() < m_titleLength)
                {
                    m_titleLength++;
                    notes[currentIndex].title = keyboardInput.mid(0, m_titleLength);
                    qDebug() << "124";
                }

                // I can't reproduce the below case

                // If cursor position is greater than title length
                // else
                // {
                //     m_titleLength = textContainsTitle(keyboardInput) ? keyboardInput.indexOf(paragraphSeparator) : cursorPosition();
                //     m_noteTitle = keyboardInput.mid(0, m_titleLength);
                //     qDebug() << "125";
                // }
            }
        }
        else
        {
        }
    }
    else
    {
        if (isChangingTitle(keyboardInput))
        {
            if (cursorPosition() < m_titleLength)
            {
                m_titleLength--;
                notes[currentIndex].title = keyboardInput.mid(0, m_titleLength);
                qDebug() << "126";
            }
            else
            {
                // We joined title and description
                if (!keyboardInputContainsDescription(keyboardInput))
                {
                    notes[currentIndex].title = keyboardInput;
                    m_titleLength = notes[currentIndex].title.length();
                    qDebug() << "127";
                }
                else
                {
                    notes[currentIndex].title = getNewTitleFromKeyboardInput(keyboardInput);
                    m_titleLength = notes[currentIndex].title.length();
                    qDebug() << "128";
                }
            }
        }
        else
        {
        }
    }

    // qDebug() << "titleLength after update:" << m_titleLength << "noteTitle after update:" << m_noteTitle;

    // Showing input
    if (keyboardInputContainsDescription(keyboardInput))
    {
        m_html = ("<h2>" + notes[currentIndex].title + "</h2>").append("<p>" + keyboardInput.mid(m_titleLength + 1, keyboardInput.length()) + "</p>");
    }
    else
    {
        m_html = "<h2>" + notes[currentIndex].title + "</h2>";
    }

    // qDebug() << "processHTML m_html: " << m_html;

    plainText = keyboardInput;

    // qDebug() << "plainText: " << plainText;
}

bool NotesBackend::isChangingTitle(const QString &keyboardInput)
{
    // head forward
    if (m_titleLength == cursorPosition() - 1)
    {
        // qDebug() << "isChangingTitle 2";

        if (keyboardInput.length() > m_titleLength && keyboardInput[m_titleLength] == paragraphSeparator)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    // head backward
    if (m_titleLength - 1 == cursorPosition())
    {
        // qDebug() << "isChangingTitle 3";
        return true;
    }

    // middle
    if (cursorPosition() < m_titleLength)
    {
        // qDebug() << "isChangingTitle 4";
        return true;
    }

    // When joining title and description
    if (!keyboardInputContainsDescription(keyboardInput))
    {
        // qDebug() << "isChangingTitle 5";
        return true;
    }

    if(isEnterPressedOnTitle(keyboardInput)) {
        return true;
    }

    return false;
}

bool NotesBackend::isChangingDescription(QString text)
{
    return m_titleLength < cursorPosition();
}

int NotesBackend::descriptionLength()
{
    return plainText.mid(m_titleLength + 1, plainText.length()).length();
}

bool NotesBackend::keyboardInputContainsDescription(const QString &text)
{
    std::u16string textString = text.toStdU16String();

    size_t firstParagraphSeparatorIt = textString.find(u16ParagraphSeparator);

    // Pure title without new paragraph separator
    if(firstParagraphSeparatorIt == std::string::npos)
    {
        // qDebug() << "inputContainsDescription 1";
        return false;
    }
    else
    {
        size_t titleFirstCharPos = textString.find_first_not_of(u16ParagraphSeparator);

        size_t firstParagraphSeparatorBetweenTitleAndDescriptionPos = textString.find_first_of(u16ParagraphSeparator, titleFirstCharPos);

        // Pure title with initials paragraph separators
        if(firstParagraphSeparatorBetweenTitleAndDescriptionPos == std::string::npos)
        {
            // qDebug() << "inputContainsDescription 2";
            return false;
        }
        else
        {
            // qDebug() << "inputContainsDescription 3";
            return true;
        }
    }
}

bool NotesBackend::isEnterPressedOnTitle(const QString &text)
{
    std::u16string textString = text.toStdU16String();

    // qDebug() << "textString" << textString;

    size_t firstNotParagraphSeparatorPosition = textString.find_first_not_of(u16ParagraphSeparator);

    // if(firstNotParagraphSeparatorPosition == std::string::npos)
    //     return true;

    // qDebug() << "first not paragraph" << firstNotParagraphSeparatorPosition << cursorPosition();

    return cursorPosition() - firstNotParagraphSeparatorPosition > 0;
}

QString NotesBackend::getNewTitleFromKeyboardInput(const QString &text)
{
    std::u16string textString = text.toStdU16String();

    size_t firstNotParagraphSeparatorPos = textString.find_first_not_of(u16ParagraphSeparator);

    size_t firstParagraphSeparatorBetweenTitleAndDescriptionPos = textString.find_first_of(u16ParagraphSeparator, firstNotParagraphSeparatorPos);

    std::u16string newTitle = textString.substr(0, firstParagraphSeparatorBetweenTitleAndDescriptionPos);

    return QString::fromStdU16String(newTitle);
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

    // qDebug() << "plainText: " << plainText;
    // qDebug() << "keyboardInput: " << keyboardInput;

    qDebug() << "Changing HTML";

    if (plainText == keyboardInput)
    {
        return;
    }

    if (containOnlyParagraphSeparatorCharacter(keyboardInput))
    {
        updateCursorPosition(0);
        notes[currentIndex].title = "";
        m_titleLength = 0;
        plainText = "";
        return;
    }

    isAddingText = keyboardInput.length() > plainText.length();

    // const char* markdown = "# Hello, World!\n\nThis is a **Markdown** text.";
    // char* html = cmark_markdown_to_html(markdown, strlen(markdown), CMARK_OPT_DEFAULT);

    // free(html);

    int automaticCursorPosition = m_cursorPosition;

    transformKeyboardInput(keyboardInput);

    qDebug() << "m_cursorPosition pre: " << m_cursorPosition;

    emit htmlChanged();

    qDebug() << "m_cursorPosition post: " << m_cursorPosition;

    QString description = plainText.mid(m_titleLength + 1, plainText.length());

    notes[currentIndex] = Note(notes[currentIndex].title, description, "09:85");

    titleOrDescriptionChanged(notes[currentIndex].title, notes[currentIndex].description);

    updateCursorPosition(automaticCursorPosition);
}

void NotesBackend::updateCursorPosition(const int &newCursorPosition)
{
    if (newCursorPosition == m_cursorPosition)
        return;

    m_cursorPosition = newCursorPosition;

    emit editorCursorPositionChanged();
}

void NotesBackend::updateInputFromBackend(const bool &isInputFromBackend)
{
    if (m_isInputFromBackend == isInputFromBackend)
        return;

    m_isInputFromBackend = isInputFromBackend;

    emit inputFromBackendChanged();
}

void NotesBackend::updateSpacePressed(const bool &spacePressed)
{
    if (spacePressed == m_spacePressed)
        return;

    m_spacePressed = spacePressed;

    emit spacePressedChanged();
}

void NotesBackend::updateFormat(Format *format)
{
    if(m_format != format)
    {
        m_format = format;

        emit formatChanged();
    }
}
