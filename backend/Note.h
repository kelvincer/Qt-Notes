#ifndef NOTE_H
#define NOTE_H

#endif // NOTE_H

#include <QString>

struct Note {

    QString title;
    QString description;
    QString time;

    Note(QString title, QString description, QString time): title{title}, description{description}, time{time}{

    };
    Note():title{""}, description{""}, time{""}{

    };
};
