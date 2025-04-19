#include <string>
#include <cmark.h>
#include <QString>
#include <QList>
#include <QStringList>  

namespace CMUtil {
    std::string html_to_plaintext_simple(const std::string& html);
    std::string html_to_plaintext_simple(const QString& html);
    template <typename T>
    void replaceOrAppend(QList<T>& list, int index, const T& value);
}