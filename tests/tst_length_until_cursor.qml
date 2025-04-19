import QtQuick 2.15
import QtTest 1.2
import "../js/MdArray.js" as MdArray

TestCase {
    name: "length_until_cursor"


    // cursor index: 0
    // #\u00A0tit|le
    function test_case1() {

        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        const length = MdArray.getLengthUntilCursor(array, 3)
        compare(length, 3);

    }

    // cursor index: 1
    // \nthis| is a paragraph<br/>another paragraph
    function test_case2() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        const length = MdArray.getLengthUntilCursor(array, 10)
        compare(length, 10);
    }

    // cursor index: 1
    // \n#\u00A0this| is a title
    function test_case3() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\n#\u00A0this is a title"}]
        const length = MdArray.getLengthUntilCursor(array, 10)
        compare(length, 10);
    }
}
