import QtQuick 2.4
import QtQuick.Controls.Universal
import QtQuick.Layouts

ColumnLayout {

    anchors.fill: parent

    RowLayout {

        Layout.preferredWidth: parent.width
        Layout.preferredHeight: parent.height

        Rectangle {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            color: itemColor
            radius: 10
            Layout.alignment: Qt.AlignTop
        }

        Item {
            Layout.preferredWidth: 8
        }

        ColumnLayout {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height

            Text {
                text: "### " + title
                elide: Text.ElideMiddle
                maximumLineCount: 1
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                textFormat: Text.MarkdownText
                Layout.alignment: Qt.AlignTop
            }

            Text {
                text: description
                elide: Text.ElideRight
                //maximumLineCount: 7
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.fillHeight: true
                Component.onCompleted: {
                    console.log("description", description)
                }
            }

            Text {
                text: time
                color: "silver"
                font.pointSize: 12
            }
        }
    }

    Rectangle {
        color: "#DFDFDF"
        Layout.preferredHeight: 1
        Layout.preferredWidth: parent.width
        visible: true //(index !== (list.count - 1))
    }
}
