import QtQuick 2.15
import QtTest 1.2
import "../js/TextBlock.js" as Block
import "../js/Constants.js" as Constants

TestCase {
    name: "find_last_html_break_end_index"

    function test_case1() {
        const paragraph = "paragraph" + Constants._break + "other"
        compare(Block.findLastHTMLBreakEndIndex(paragraph), 13);
    }

    function test_case2() {
        const paragraph = "*paragraph* " + Constants._break + "other"
        compare(Block.findLastHTMLBreakEndIndex(paragraph), 16);
    }
}