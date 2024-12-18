import QtQuick 2.4
import QtQuick.Controls.Universal
import QtQuick.Layouts


ColumnLayout {

    width: parent.width

    RowLayout {

        width: parent.width

        Rectangle {
            width: 20
            height: 20
            color: itemColor
            radius: 10
            Layout.alignment: Qt.AlignTop
        }

        Item {
            width: 8
            height: 1
        }

        ColumnLayout {

            Layout.fillWidth: true

            Text {
                text: title
                elide: Text.ElideRight
                maximumLineCount: 1
                font.bold: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Text {
                text: description
                elide: Text.ElideRight
                maximumLineCount: 6
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Text {
                text: time
                color: "lightgray"
                Layout.alignment: Qt.AlignLeft
                font.pointSize: 12
            }
        }
    }

    Rectangle {
        color: "#DFDFDF"
        height: 1
        width: parent.width
        visible: (index !== (list.count - 1))
        Layout.topMargin: 5
        Layout.bottomMargin: 5
    }
}



