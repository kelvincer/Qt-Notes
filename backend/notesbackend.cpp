#include "notesbackend.h"

NotesBackend::NotesBackend(QObject *parent)
    : QObject{parent}
{
    NoteTable notetable("tableName");
}

void NotesBackend::setCurrentIndex(int index)
{
    currentNoteIndex = index;
}

void NotesBackend::setBoldFormat(QString text, int selectionStart, int selectionEnd)
{
    // if(selectionStart > m_titleLength) 
    // {
    //     QString description = text.mid(m_titleLength + 1, plainText.length() - m_titleLength - 1);
    //     format()->setDescriptionBold(description, selectionStart - m_titleLength - 1, selectionEnd - m_titleLength - 1);
    //     m_html = ("<h2>" + notes[currentNoteIndex].title + "</h2>").append(description);
    //     emit htmlChanged();
    // }
}

void NotesBackend::sendListIndex(int index, bool isSameNote) {
    this->isSameNote = isSameNote;
    if(isSameNote) {
        sendNoteInfo(std::get<0>(myNotes[index]), std::get<1>(myNotes[index]), isSameNote, index);
    }
}

void NotesBackend::sendNoteInfo(QStringList blocks, int cursorPosition, bool isSameNote, int noteIndex) {
    if(m_blocks != blocks) { 

        qDebug() << "Blocks" << blocks << isSameNote << noteIndex;
        removeZeroWidthSpace(blocks);

        if (isSameNote) {
            myNotes[noteIndex] = std::make_tuple(blocks, cursorPosition); // Update
        } else {
            myNotes.insert(0, std::make_tuple(blocks, cursorPosition)); // Insert
        }
        
        m_blocks = blocks;

        m_md.clear();

        for (int i = 0; i < blocks.size(); ++i) {

            if(isStartingH1Title(blocks[i])) {

                itemTitle = blocks[i];

                blocks[i].replace(0, 1, "&#35;");

                m_md += QString(blocks[i]);

                qDebug() << "title converted" << m_md;

            }
            else if(isStartingH1TitleWithNewLine(blocks[i])) {

                itemDescription = blocks[i];

                blocks[i].replace(0, 1, "&#10;");

                blocks[i].replace(5, 1, "&#35;");

                //block.replace(10, 1, "&nbsp;");

                m_md += QString(blocks[i]);

                qDebug() << "title newline converted" << m_md;
            }
            else if(isStartingH2Title(blocks[i])) {

                itemDescription = blocks[i];

                blocks[i].replace(0, 1, "&#35;");

                blocks[i].replace(5, 1, "&#35;");

                m_md += QString(blocks[i]);

                qDebug() << "H2 converted" << m_md;

            }
            else if(isStartingH2TitleWithNewLine(blocks[i])) {
                itemDescription = blocks[i];

                blocks[i].replace(0, 1, "&#10;");

                blocks[i].replace(5, 1, "&#35;");

                blocks[i].replace(10, 1, "&#35;");

                //block.replace(10, 1, "&nbsp;");

                m_md += QString(blocks[i]);

                qDebug() << "H2 newline" << m_md;
            }
            else if(isStartingH3Title(blocks[i])) {
                itemDescription = blocks[i];

                blocks[i].replace(0, 1, "&#35;");

                blocks[i].replace(5, 1, "&#35;");

                blocks[i].replace(10, 1, "&#35;");

                m_md += QString(blocks[i]);

                qDebug() << "H3 converted" << m_md;

            }
            else if(isStartingH3TitleWithNewLine(blocks[i])) {
                itemDescription = blocks[i];

                blocks[i].replace(0, 1, "&#10;");

                blocks[i].replace(5, 1, "&#35;");

                blocks[i].replace(10, 1, "&#35;");

                blocks[i].replace(15, 1, "&#35;");

                m_md += QString(blocks[i]);

                qDebug() << "H3 newline" << m_md;
            }
            else if(isStartingWithAsterisk(blocks[i])) {
                blocks[i].replace(1, 1, "&#42;");
                m_md += "<p>" + blocks[i] + "</p>";
                qDebug() << "block saterick";
            }
            else {

                std::string blockString = remove_non_breaking_spaces(blocks[i].toStdString());

                const char * mdtq = blockString.c_str();

                qDebug() << "mdtq" << mdtq;

                char *htmlOutput = cmark_markdown_to_html(mdtq, strlen(mdtq), CMARK_OPT_UNSAFE);

                qDebug() << "HTML" << htmlOutput;

                m_md += QString(htmlOutput).removeLast();

                if (i == 0)
                {
                    std::string plainText = CMUtil::html_to_plaintext_simple(m_md);
                    itemTitle = QString::fromStdString(plainText);
                } 
                else {
                    std::string plainText = CMUtil::html_to_plaintext_simple(QString(htmlOutput).removeLast());
                    itemDescription += plainText  + " ";   
                }
            }
        }

        QString title = "<h3>" + itemTitle + "</h3>";
        QString description = "<p>" + itemDescription.removeLast() + "</p>";
        if(isSameNote) {
            updateNoteChanged(title, description);
        } else {
            addNewNoteChanged(title, description);
        }

        qDebug() << "final converted" << m_md;

        itemDescription.clear();
        itemTitle.clear();

        emit mdChanged();

        qDebug() << "note index" << noteIndex;

        updateTextArrayOnEditor(std::get<0>(myNotes[noteIndex]));
    }

    setCursorPosition(cursorPosition);

    qDebug() << "NOTES" << blocks;
}

int NotesBackend::cursorPosition()
{
    return m_cursorPosition;
}

Format *NotesBackend::format()
{
    return m_format;
}

void NotesBackend::updateCursorPosition(const int &newCursorPosition)
{
    if (newCursorPosition == m_cursorPosition)
        return;

    m_cursorPosition = newCursorPosition;

    emit editorCursorPositionChanged();
}

void NotesBackend::updateFormat(Format *format)
{
    if(m_format != format)
    {
        m_format = format;

        emit formatChanged();
    }
}

std::string NotesBackend::remove_non_breaking_spaces(const std::string &in) const {

    std::regex non_breaking_space("\\xC2\\xA0");
    std::string result = std::regex_replace(in, non_breaking_space, " ");

    int j = 0;

    result.erase(std::remove(result.begin(), result.end(), '\x0A'), result.end());

    if(isH1Title(result)) {
        j = 2;
    } else if(isH1TitleWithNewline(result)) {
        j = 3;
    }
    else if(isH2Title(result)) {
        j = 3;
    }
    else if(isH2TitleWithNewline(result)) {
        j = 4;
    }
    else if(isH3Title(result)) {
        j = 4;
    }
    else if(isH3TitleWithNewline(result)) {
        j = 5;
    }
    else {
        j = 0;
    }

    for(int i = j; i < result.size();) {

        if (result[i] == ' ') {
            result.replace(i, 1, "&nbsp;");
            i += 6;
        }
        else if(result[i] == '\n') {
            // result.replace(i, 1, "<br>");
            i++;
        }
        else if (result[i] == '#') {
            result.replace(i, 1, "&#35;");
            i += 5;
        } else if (result[i] == '<' && result.substr(i, 5) != "<br/>") {
            result.replace(i, 1, "&lt;");
            i += 4;
        } else if (result[i] == '>' && result.substr(i - 4, 5) != "<br/>") {
            result.replace(i, 1, "&gt;");
            i += 4;
        }
        else {
            //result.replace(i, 1, 1, result[i]);
            i++;
        }
    }

    qDebug() << "result:" << result;

    return result;
}

bool NotesBackend::isStartingH1Title(QString title) const
{
    return !title.isEmpty() && title.length() == 1 && title[0] == '#'
           || !title.isEmpty() && title.length() == 2  && title[0] == '#' && title[1] == '\xa0';

}

bool NotesBackend::isStartingH2Title(QString title) const
{
    return !title.isEmpty() && title.length() == 1 && title[0] == '#'
           || !title.isEmpty() && title.length() == 2  && title[0] == '#' && title[1] == '#'
    || !title.isEmpty() && title.length() == 3  && title[0] == '#' && title[1] == '#' && title[2] == '\xa0';
}

bool NotesBackend::isStartingH3Title(QString title) const
{
    return !title.isEmpty() && title.length() == 1 && title[0] == '#'
           || !title.isEmpty() && title.length() == 2  && title[0] == '#' && title[1] == '#'
           || !title.isEmpty() && title.length() == 3  && title[0] == '#' && title[1] == '#' && title[2] == '#'
           || !title.isEmpty() && title.length() == 4  && title[0] == '#' && title[1] == '#' && title[2] == '#' && title[3] == '\xa0';
}

bool NotesBackend::isH1Title(QString title) const
{
    return title.length() >= 2 && title[0] == '#' && title[1] == '\xa0';
}

bool NotesBackend::isH1Title(std::string & title) const
{
    return title.length() >= 2 && title[0] == '#' && title[1] == ' ';
}

bool NotesBackend::isH2Title(std::string &title) const
{
    return title.length() >= 4 && title[0] == '#' && title[1] == '#' && title[2] == ' ';
}

bool NotesBackend::isH3Title(std::string &title) const
{
    return title.length() >= 5 && title[0] == '#' && title[1] == '#' && title[2] == '#' && title[3] == ' ';

}

bool NotesBackend::isH1TitleWithNewline(std::string &title) const
{
    return title.length() >= 3 && title[0] == '\x0a' && title[1] == '#' && title[2] == ' ';
}

bool NotesBackend::isH2TitleWithNewline(std::string &title) const
{
    return title.length() >= 4 && title[0] == '\x0a' && title[1] == '#' && title[2] == '#' && title[3] == ' ';
}

bool NotesBackend::isH3TitleWithNewline(std::string &title) const
{
    return title.length() >= 5 && title[0] == '\x0a' && title[1] == '#' && title[2] == '#' && title[3] == '#' && title[4] == ' ';
}

bool NotesBackend::isStartingH1TitleWithNewLine(QString title) const
{
    return !title.isEmpty() && title.length() == 2 && title[0] == '\x0a' && title[1] == '#'
           || !title.isEmpty() && title.length() == 3 && title[0] == '\x0a' && title[1] == '#' && title[2] == '\xa0';
}

bool NotesBackend::isStartingH2TitleWithNewLine(QString title) const
{
    return !title.isEmpty() && title.length() == 2 && title[0] == '\x0a' && title[1] == '#'
           || !title.isEmpty() && title.length() == 3 && title[0] == '\x0a' && title[1] == '#' && title[2] == '#'
            || !title.isEmpty() && title.length() == 4 && title[0] == '\x0a' && title[1] == '#' && title[2] == '#' && title[3] == '\xa0';
}

bool NotesBackend::isStartingH3TitleWithNewLine(QString title) const
{
    return !title.isEmpty() && title.length() == 2 && title[0] == '\x0a' && title[1] == '#'
           || !title.isEmpty() && title.length() == 3 && title[0] == '\x0a' && title[1] == '#' && title[2] == '#'
           || !title.isEmpty() && title.length() == 4 && title[0] == '\x0a' && title[1] == '#' && title[2] == '#' && title[3] == '\xa0'
           || !title.isEmpty() && title.length() == 5 && title[0] == '\x0a' && title[1] == '#' && title[2] == '#' && title[3] == '#' && title[4] == '\xa0';

}

void NotesBackend::removeZeroWidthSpace(QStringList &stringList) {
    for (auto & s: stringList) {
        if (s.endsWith(zeroWidthSpace) && s.length() > 2) {
            s.removeLast();
        }
    }
}

bool NotesBackend::isStartingWithAsterisk(QString block)
{
    return block.length() == 2 && block[0] == '\x0a' && block[1] == '*';
}

void NotesBackend::setMd(QString userInput) {

    if(userInput != m_md) {

        m_md = userInput;

        emit mdChanged();

    }
}

QString NotesBackend::md()
{
    return m_md;
}

void NotesBackend::setCursorPosition(int position)
{
    //if(m_cursorPosition != position) {

        m_cursorPosition = position;

        emit cursorPositionChanged();
    //}
}
