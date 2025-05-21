import QtQuick 2.15
import QtTest 1.2
import "../js/TextBlock.js" as Block

TestCase {
    name: "count_italics_asterisks_before_cursor"

    function test_case1() {
        const markdown = "\n*You* *graph*"
        const prevItalics = [{start: 7, end: 13}, {start: 1, end: 5}]
        compare(Block.countItalicsAsterisksBeforeCursor(markdown, 10, prevItalics), 4)
    }
}
