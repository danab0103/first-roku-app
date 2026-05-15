const rokuLibrary = require("../library/rokuLibrary");
const expect = require("chai").expect;
const { spawn } = require('child_process');
const path = require('path');

const childProcess = spawn('./bin/RokuWebDriver_linux');

let library;

describe('Test search screen', () => {
    before(async function () {
        this.timeout(50000);
        library = new rokuLibrary.Library("192.168.20.108");
        await library.sideLoad(path.resolve(__dirname, "../../out/hello-world.zip"), "rokudev", "rokudev");
    });

    it('should launch the channel', async function () {
        this.timeout(15000);
        await library.verifyIsChannelLoaded('dev');
    });

    it('should open the search screen from the home screen', async function () {
        this.timeout(30000);
        await library.sendKey('right');
        await library.sendKey('right');
        await library.sendKey('right');
        await library.sendKey('select');

        const isSearchScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'text', 'value': 'Open Keyboard' }]
        });
        expect(isSearchScreenLoaded).to.equal(true);
    });

    it('should focus the mini keyboard on launch', async function () {
        this.timeout(15000);
        const focusedElement = await library.getFocusedElement();
        expect(focusedElement.XMLName.Local).to.equal('VKBKey');
    });

    it('should open the keyboard dialog when selecting the Open Keyboard button', async function () {
        this.timeout(20000);
        const DOWN_PRESSES_TO_REACH_OPEN_KEYBOARD_BUTTON = 7;
        await library.sendKeys(Array(DOWN_PRESSES_TO_REACH_OPEN_KEYBOARD_BUTTON).fill('down'));
        await library.sendKey('select');

        const isKeyboardDialogLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'text', 'value': 'Search Pokemon' }]
        });
        expect(isKeyboardDialogLoaded).to.equal(true);
    });

    it('should close the keyboard dialog and reflect typed text in mini keyboard', async function () {
        this.timeout(20000);
        await library.sendWord('Pikachu');
        await library.sendKey('back');

        const miniKeyboard = await library.getElement({
            'elementData': [{ 'using': 'tag', 'value': 'DynamicMiniKeyboard' }]
        });
        const textNodes = library.getChildNodes(miniKeyboard, [
            { 'using': 'text', 'value': 'Pikachu' }
        ]);
        expect(textNodes.length).to.equal(1);
    });

    it('should open the details screen when selecting a filtered pokemon from the grid', async function () {
        this.timeout(35000);
        const RIGHT_PRESSES_TO_REACH_POKEMON_GRID = 7;
        await library.sendKeys(['up', 'select']);
        await library.sendWord('bulba');
        await library.sendKeys(Array(RIGHT_PRESSES_TO_REACH_POKEMON_GRID).fill('right'));
        await library.sendKey('select');

        const isDetailsScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [
                { 'using': 'tag', 'value': 'Label' },
                { 'using': 'text', 'value': 'Bulbasaur made its video game debut on February 27' }
            ]
        });
        expect(isDetailsScreenLoaded).to.equal(true);
    });

    after(async () => {
        await library.close();
        childProcess.kill();
    });
});
