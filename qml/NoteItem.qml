import QtQuick 2.4
import QtQuick.Controls.Universal
import QtQuick.Layouts

ColumnLayout {

    anchors.fill: parent

    RowLayout {

        width: parent.width
        height: parent.height

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
            height: parent.height

            Text {
                text: "### " + title
                elide: Text.ElideRight
                maximumLineCount: 1
                //font.bold: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                textFormat: Text.MarkdownText
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
                color: "silver"
                Layout.alignment: Qt.AlignLeft
                font.pointSize: 12
            }
        }
    }

    Rectangle {
        color: "#DFDFDF"
        height: 1
        width: parent.width
        visible: true //(index !== (list.count - 1))
    }
}
