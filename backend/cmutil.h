#ifndef CMUTIL_H
#define CMUTIL_H

#include <string>
#include <cmark.h>
#include <QString>
#include <QList>
#include <QStringList>  

class CMUtil
{
public:
    CMUtil();

    static std::string html_to_plaintext_simple(const std::string& html);
    static std::string html_to_plaintext_simple(const QString& html);
    //static void replaceOrAppendStringList(QList<QStringList>& list, int index, const QStringList& value);

    template <typename T>
    static void replaceOrAppend(QList<T>& list, int index, const T& value);
};

#endif // CMUTIL_H

template <typename T>
inline void CMUtil::replaceOrAppend(QList<T> &list, int index, const T &value) {
    if (index >= 0 && index < list.size()) {
        list[index] = value; // Replace
    } else {
        list.append(value);  // Append
    }       
}
