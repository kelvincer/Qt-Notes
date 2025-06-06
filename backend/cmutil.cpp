#include "cmutil.h"

std::string CMUtil::html_to_plaintext_simple(const std::string &html)
{
    std::string result;
    bool in_tag = false;

    for (char c : html) {
        if (c == '<') {
            in_tag = true;
        } else if (c == '>') {
            in_tag = false;
        } else if (!in_tag) {
            result += c;
        }
    }

    // Collapse whitespace and trim
    result.erase(std::unique(result.begin(), result.end(),
                             [](char a, char b) { return isspace(a) && isspace(b); }),
                 result.end());
    result.erase(result.find_last_not_of(" \n\r\t") + 1);
    result.erase(0, result.find_first_not_of(" \n\r\t"));

    return result;
}

std::string CMUtil::html_to_plaintext_simple(const QString &html)
{
    std::string htmlString = html.toStdString();
    std::string result;
    bool in_tag = false;

    for (char c : htmlString) {
        if (c == '<') {
            in_tag = true;
        } else if (c == '>') {
            in_tag = false;
        } else if (!in_tag) {
            result += c;
        }
    }

    // Collapse whitespace and trim
    result.erase(std::unique(result.begin(), result.end(),
                             [](char a, char b) { return isspace(a) && isspace(b); }),
                 result.end());
    result.erase(result.find_last_not_of(" \n\r\t") + 1);
    result.erase(0, result.find_first_not_of(" \n\r\t"));

    return result;
}

// void CMUtil::replaceOrAppendStringList(QList<QStringList>& list, int index, const QStringList& value) {
//     if (index >= 0 && index < list.size()) {
//         list[index] = value; // Replace
//     } else {
//         list.append(value);  // Append
//     }
// }

// template <typename T>
//     void replaceOrAppend(QList<T>& list, int index, const T& value) {
//         if (index >= 0 && index < list.size()) {
//             list[index] = value;
//         } else {
//             list.append(value);
//         }
//     }
