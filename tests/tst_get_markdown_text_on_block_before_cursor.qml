import QtQuick 2.15
import QtTest 1.2
import "../js/MdArray.js" as MdArray
import "../js/TextBlock.js" as Block

TestCase {
    name: "get_markdown_text_on_block_before_cursor"

    function test_case1() {
        const array = [{markdown: "this is a paragraph<br/>another"}, {markdown: "\n#\u00A0title"}]
        compare(MdArray.getMarkdownTextOnBlockBeforeCursor(array, array[0].markdown, 4), "this");
    }

    function test_case2() {
        const array = [{markdown: "this is a paragraph"}, {markdown: "\n#\u00A0title"}]
        compare(MdArray.getMarkdownTextOnBlockBeforeCursor(array, array[1].markdown, 23), "\n#\u00A0tit");        
    }

    function test_case3() {
        const array = [{markdown: "#\u00A0title"}, {markdown: "\nthis is a paragraph"}]
        compare(MdArray.getMarkdownTextOnBlockBeforeCursor(array, array[1].markdown, 10), "\nthis");
    }

    function test_case4() {
         const array = [{markdown: "#\u00A0title"}, {markdown: "\n*this* is a paragraph"}]
         compare(MdArray.getMarkdownTextOnBlockBeforeCursor(array, array[1].markdown, 10), "\n*this*");
    }

    function test_case5() {
         const array = [{markdown: "#\u00A0title"}, {markdown: "\n*this* *isa paragraph"}]
         compare(MdArray.getMarkdownTextOnBlockBeforeCursor(array, array[1].markdown, 14), "\n*this* *is");
    }

    function test_case6() {
         const array = [{markdown: "#\u00A0title"}, {markdown: "\n*this* other *isa paragraph"}]
         compare(MdArray.getMarkdownTextOnBlockBeforeCursor(array, array[1].markdown, 16), "\n*this* other");
    }

    function test_case7() {
        const array = [{markdown: "#\u00A0Hi"}, {markdown: "\n*You*"}]
        compare(MdArray.getMarkdownTextOnBlockBeforeCursor(array, array[1].markdown, 6), "\n*You*");
    }
}
