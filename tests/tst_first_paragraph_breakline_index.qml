import QtQuick 2.15
import QtTest 1.2
import "../js/Constants.js" as Constants
import "../js/TextBlock.js" as Block

TestCase {
    name: "first_paragraph_breakline_index"

    function test_case1() {
        const paragraph = "another" + Constants._break + "paragraph"
        compare(Block.getFirstParagraphBreaklineIndex(paragraph), 7)
    }

    function test_case2() {
        const paragraph = "paragraph"
        compare(Block.getFirstParagraphBreaklineIndex(paragraph), -1)
    }

    function test_case3() {
        const paragraph = "another" + Constants._break + "paragraph" + Constants._break + "another"
        compare(Block.getFirstParagraphBreaklineIndex(paragraph), 7)
    }

    function test_case4() {
        const paragraph = "\nanother" + Constants._break + "paragraph" + Constants._break + "another"
        compare(Block.getFirstParagraphBreaklineIndex(paragraph), 8)
    }
}
