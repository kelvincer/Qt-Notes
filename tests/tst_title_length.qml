import QtQuick 2.15
import QtTest 1.0
import "../js/TextBlock.js" as Block
import "../js/Constants.js" as Constants

TestCase {
    name: "title_length"

    function test_UndefinedTitle_ReturnZero() {
        const title = undefined
        compare(Block.getH1TitleLength(title), 0)
    }

    function test_InititalizedTitle_ReturnLength() {
        const title = Constants.titleStarted
        compare(Block.getH1TitleLength(title), title.length)
    }

    function test_NormalTitle_ReturnLength() {
        const title = "# My title"
        compare(Block.getH1TitleLength(title), title.length - 2)
    }
}
