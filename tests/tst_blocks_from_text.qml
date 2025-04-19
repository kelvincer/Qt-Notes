import QtQuick 2.15
import QtTest 1.2
import "../js/Constants.js" as Constants
import "../js/TextBlock.js" as Block

TestCase {
    name: "blocks_from_text"

    function test_case1() {
        const blocks = Block.getBlocksFromText("paragraph" + Constants.newline + "paragraph");
        compare(blocks, ["paragraph", "paragraph"], "sanity check");
    }

    function test_case2() {
        const blocks = Block.getBlocksFromText("paragraph" + Constants.newline + Constants.titleStarted + "paragraph");
        compare(blocks, ["paragraph", Constants.titleStarted + "paragraph"]);
    }

    function test_case3() {
        const blocks = Block.getBlocksFromText("paragraph" + Constants.newline + Constants.titleStarted + "paragraph" + Constants.newline + "paragraph");
        compare(blocks, ["paragraph", Constants.titleStarted + "paragraph", "paragraph"]);
    }
}
