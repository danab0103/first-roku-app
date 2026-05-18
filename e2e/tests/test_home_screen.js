const rokuLibrary = require("../library/rokuLibrary");
const expect = require("chai").expect;
const { spawn } = require('child_process');
const path = require('path');

const childProcess = spawn('./bin/RokuWebDriver_linux');

let library;

describe('Test home screen', () => {
    before(async function () {
        this.timeout(50000);
        library = new rokuLibrary.Library("192.168.20.108");
        await library.sideLoad(path.resolve(__dirname, "../../out/hello-world.zip"), "rokudev", "rokudev");
    });

    it('should launch the channel', async function () {
        this.timeout(15000);
        await library.verifyIsChannelLoaded('dev');
    });

    it('should focus the Play Video button on launch', async function () {
        this.timeout(20000);
        const focusedElement = await library.getFocusedElement();
        expect(focusedElement.XMLName.Local).to.equal('CustomButton');

        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Play Video' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should display all navigation buttons after content loads', async function () {
        this.timeout(30000);
        const buttonTexts = ['Play Video', 'To Pokeballs', 'Get Random Dog', 'Search Pokemon'];

        for (const buttonText of buttonTexts) {
            const isButtonLoaded = await library.verifyIsScreenLoaded({
                'elementData': [{ 'using': 'text', 'value': buttonText }]
            });
            expect(isButtonLoaded, `expected to find button "${buttonText}"`).to.equal(true);
        }
    });

    it('should display the pokemon row list', async function () {
        this.timeout(15000);
        const isPokemonRowListLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(isPokemonRowListLoaded).to.equal(true);
    });

    it('should move focus to the To Pokeballs button when pressing right', async function () {
        this.timeout(15000);
        await library.sendKey('right');
        const focusedElement = await library.getFocusedElement();
        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'To Pokeballs' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should move focus to the Get Random Dog button when pressing right again', async function () {
        this.timeout(15000);
        await library.sendKey('right');
        const focusedElement = await library.getFocusedElement();
        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Get Random Dog' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should move focus to the Search Pokemon button when pressing right again', async function () {
        this.timeout(15000);
        await library.sendKey('right');
        const focusedElement = await library.getFocusedElement();
        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Search Pokemon' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should keep focus on the Search Pokemon button when pressing right at the end of the chain', async function () {
        this.timeout(15000);
        await library.sendKey('right');
        const focusedElement = await library.getFocusedElement();
        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Search Pokemon' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should move focus back through the buttons when pressing left repeatedly', async function () {
        this.timeout(20000);
        const buttonTexts = ['Get Random Dog', 'To Pokeballs', 'Play Video'];

        for (const buttonText of buttonTexts) {
            await library.sendKey('left');
            const focusedElement = await library.getFocusedElement();
            const focusedElementLabels = library.getChildNodes(focusedElement, [
                { 'using': 'text', 'value': buttonText }
            ]);
            expect(focusedElementLabels.length, `expected focus on "${buttonText}"`).to.equal(1);
        }
    });

    it('should keep focus on the Play Video button when pressing left at the start of the chain', async function () {
        this.timeout(15000);
        await library.sendKey('left');
        const focusedElement = await library.getFocusedElement();
        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Play Video' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should move focus to the pokemon row list when pressing down', async function () {
        this.timeout(15000);
        await library.sendKey('down');
        const focusedElement = await library.getFocusedElement();
        expect(focusedElement.XMLName.Local).to.equal('BaseItem');
    });

    it('should keep focus on the pokemon row list when pressing down again', async function () {
        this.timeout(15000);
        await library.sendKey('down');
        const focusedElement = await library.getFocusedElement();
        expect(focusedElement.XMLName.Local).to.equal('BaseItem');
    });

    it('should move focus back to the Play Video button when pressing up', async function () {
        this.timeout(15000);
        await library.sendKey('up');
        const focusedElement = await library.getFocusedElement();
        expect(focusedElement.XMLName.Local).to.equal('CustomButton');

        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Play Video' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should keep focus on the Play Video button when pressing up again', async function () {
        this.timeout(15000);
        await library.sendKey('up');
        const focusedElement = await library.getFocusedElement();
        expect(focusedElement.XMLName.Local).to.equal('CustomButton');

        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Play Video' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    it('should open the Pokeballs screen when selecting the To Pokeballs button', async function () {
        this.timeout(20000);
        await library.sendKey('right');
        await library.sendKey('select');
        const isPokeballsScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(isPokeballsScreenLoaded).to.equal(true);
    });

    it('should open the Get Random Dog screen when selecting the Get Random Dog button', async function () {
        this.timeout(20000);
        await library.sendKey('back');
        await library.sendKey('right');
        await library.sendKey('select');
        const isGetRandomDogScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'text', 'value': 'Get a random dog image' }]
        });
        expect(isGetRandomDogScreenLoaded).to.equal(true);
    });

    it('should open the Search screen when selecting the Search Pokemon button', async function () {
        this.timeout(20000);
        await library.sendKey('back');
        await library.sendKey('right');
        await library.sendKey('select');
        const isSearchScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'text', 'value': 'Open Keyboard' }]
        });
        expect(isSearchScreenLoaded).to.equal(true);
    });

    it('should return to the home screen when pressing back from Search screen', async function () {
        this.timeout(15000);
        await library.sendKey('back');
        const focusedElement = await library.getFocusedElement();
        const focusedElementLabels = library.getChildNodes(focusedElement, [
            { 'using': 'text', 'value': 'Search Pokemon' }
        ]);
        expect(focusedElementLabels.length).to.equal(1);
    });

    after(async () => {
        await library.close();
        childProcess.kill();
    });
});
