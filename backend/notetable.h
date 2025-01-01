#ifndef NOTETABLE_H
#define NOTETABLE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlTableModel>
#include <QDir>
#include <QStandardPaths>
#include <QSqlQuery>

class NoteTable
{

    QSqlTableModel * model;

    QString getDatabasePath();
    bool createConnection();

public:
    NoteTable(const QString & tableName);
};

#endif // NOTETABLE_H
