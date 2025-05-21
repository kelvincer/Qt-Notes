import QtQuick 2.15
import QtTest 1.2
import "../js/TextBlock.js" as Block

TestCase {
    name: "update_italics"

    function test_case1() {
        const ch = 'a'
        const italics = [{start: 7, end: 13}, {start: 1, end: 5}]
        const cursorPos = 1
        compare(Block.updateItalics(ch, italics, cursorPos), [{start: 8, end: 14}, {start: 2, end: 6}]);
    }
}
