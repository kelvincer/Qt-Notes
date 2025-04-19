import QtQuick 2.15
import QtTest 1.2
import "../js/TextBlock.js" as Block

TestCase {
    name: "first_char_of_title"

    function test_case1() {
        const markdown = "#\u00A0"
        compare(Block.isFirstCharOfTitle(markdown), true, "sanity check");
    }

    function test_case2() {
        const markdown = "#\u00A0r"
        compare(Block.isFirstCharOfTitle(markdown), false, "sanity check");
    }
}
