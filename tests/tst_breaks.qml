import QtQuick 2.15
import QtTest 1.2
import "../js/TextBlock.js" as Block
import "../js/Constants.js" as Constants

TestCase {
    name: "breaks"

    function test_paragraph_with_no_breaks() {
        const paragraph = "paragraph"
        compare(Block.countBreaks(paragraph), 0)
    }

    function test_paragraph_with_one_break() {
        const paragraph = "paragraph" + Constants._break
        compare(Block.countBreaks(paragraph), 1)
    }

    function test_paragraph_with_two_breaks() {
        const paragraph = Constants._break + "paragraph" + Constants._break
        compare(Block.countBreaks(paragraph), 2)
    }

    function test_paragraph_with_three_breaks() {
        const paragraph = Constants._break + "paragraph" + Constants._break + Constants._break
        compare(Block.countBreaks(paragraph), 3)
    }

    function test_paragraph_with_three_breaks_2() {
        const paragraph = Constants._break + "paragraph" + Constants._break + "paragraph"  + Constants._break
        compare(Block.countBreaks(paragraph), 3)
    }

    function test_paragraph_with_three_breaks_3() {
        const paragraph = Constants._break + "paragraph" + Constants._break + Constants._break + "paragraph"  + Constants._break
        compare(Block.countBreaks(paragraph), 4)
    }
}
