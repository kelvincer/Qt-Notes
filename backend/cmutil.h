#ifndef CMUTIL_H
#define CMUTIL_H

#include <string>
#include <cmark.h>
#include <QString>

class CMUtil
{
public:
    CMUtil();

    static std::string html_to_plaintext_simple(const std::string& html);
    static std::string html_to_plaintext_simple(const QString& html);
};

#endif // CMUTIL_H
