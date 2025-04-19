import QtQuick 2.15
import QtTest 1.2
import "../js/MdArray.js" as MdArray
import "../js/TextBlock.js" as Block

TestCase {
    name: "total_length"

    function test_OneTitleArray_ReturnLength() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}]
        let length = Block.getTitleLength(array[0].markdown)
                + Block.getParagraphLength(array[1].markdown)
        compare(MdArray.getTotalLength(array), length);
    }

    function test_TwoTitleArray_ReturnLength() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph<br/>another paragraph"}
                       , {markdown: "#\u00A0Another title"}]
        let length = Block.getTitleLength(array[0].markdown)
                + Block.getParagraphLength(array[1].markdown)
            + Block.getTitleLength(array[2].markdown)
        compare(MdArray.getTotalLength(array), length);
    }

    function test_FirstAParagraph_ReturnLength() {
        const array = [{markdown: "\nthis is a paragraph<br/>another paragraph"}, {markdown: "#\u00A0title"}]
        let length =  Block.getParagraphLength(array[0].markdown)
                + Block.getTitleLength(array[1].markdown)
        compare(MdArray.getTotalLength(array), length);
    }
}
