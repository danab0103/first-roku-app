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
        const focused = await library.getFocusedElement();
        expect(focused.XMLName.Local).to.equal('CustomButton');

        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'Play Video' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should display all navigation buttons after content loads', async function () {
        this.timeout(30000);
        const buttonTexts = ['Play Video', 'To Pokeballs', 'Get Random Dog', 'Search Pokemon'];

        for (const text of buttonTexts) {
            const res = await library.verifyIsScreenLoaded({
                'elementData': [{ 'using': 'text', 'value': text }]
            });
            expect(res, `expected to find button "${text}"`).to.equal(true);
        }
    });

    it('should display the pokemon row list', async function () {
        this.timeout(15000);
        const res = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(res).to.equal(true);
    });

    it('should move focus to the To Pokeballs button when pressing right', async function () {
        this.timeout(15000);
        await library.sendKey('right');
        const focused = await library.getFocusedElement();
        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'To Pokeballs' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should move focus to the Get Random Dog button when pressing right again', async function () {
        this.timeout(15000);
        await library.sendKey('right');
        const focused = await library.getFocusedElement();
        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'Get Random Dog' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should move focus to the Search Pokemon button when pressing right again', async function () {
        this.timeout(15000);
        await library.sendKey('right');
        const focused = await library.getFocusedElement();
        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'Search Pokemon' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should move focus back through the buttons when pressing left repeatedly', async function () {
        this.timeout(20000);
        const reverseChain = ['Get Random Dog', 'To Pokeballs', 'Play Video'];

        for (const text of reverseChain) {
            await library.sendKey('left');
            const focused = await library.getFocusedElement();
            const labels = library.getChildNodes(focused, [
                { 'using': 'text', 'value': text }
            ]);
            expect(labels.length, `expected focus on "${text}"`).to.be.greaterThan(0);
        }
    });

    it('should move focus to the pokemon row list when pressing down', async function () {
        this.timeout(15000);
        await library.sendKey('down');
        const focused = await library.getFocusedElement();
        expect(focused.XMLName.Local).to.equal('BaseItem');
    });

    it('should move focus back to the Play Video button when pressing up', async function () {
        this.timeout(15000);
        await library.sendKey('up');
        const focused = await library.getFocusedElement();
        expect(focused.XMLName.Local).to.equal('CustomButton');

        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'Play Video' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should open the Pokeballs screen when selecting the To Pokeballs button', async function () {
        this.timeout(20000);
        await library.sendKey('right');
        await library.sendKey('select');
        const res = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(res).to.equal(true);
    });

    it('should return to the home screen when pressing back from Pokeballs', async function () {
        this.timeout(15000);
        await library.sendKey('back');
        const focused = await library.getFocusedElement();
        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'To Pokeballs' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should open the Get Random Dog screen when selecting the Get Random Dog button', async function () {
        this.timeout(20000);
        await library.sendKey('right');
        await library.sendKey('select');
        const res = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'text', 'value': 'Get a random dog image' }]
        });
        expect(res).to.equal(true);
    });

    it('should return to the home screen when pressing back from Get Random Dog', async function () {
        this.timeout(15000);
        await library.sendKey('back');
        const focused = await library.getFocusedElement();
        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'Get Random Dog' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should open the Search screen when selecting the Search Pokemon button', async function () {
        this.timeout(20000);
        await library.sendKey('right');
        await library.sendKey('select');
        const res = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'text', 'value': 'Open Keyboard' }]
        });
        expect(res).to.equal(true);
    });

    it('should return to the home screen when pressing back from Search', async function () {
        this.timeout(15000);
        await library.sendKey('back');
        const focused = await library.getFocusedElement();
        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'Search Pokemon' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    after(async () => {
        await library.close();
        childProcess.kill();
    });
});
