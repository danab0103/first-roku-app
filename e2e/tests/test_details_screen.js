const rokuLibrary = require("../library/rokuLibrary");
const expect = require("chai").expect;
const { spawn } = require('child_process');
const path = require('path');

const childProcess = spawn('./bin/RokuWebDriver_linux');

let library;

describe('Test details screen', () => {
    before(async function () {
        this.timeout(50000);
        library = new rokuLibrary.Library("192.168.20.108");
        await library.sideLoad(path.resolve(__dirname, "../../out/hello-world.zip"), "rokudev", "rokudev");
    });

    it('should launch the channel', async function () {
        this.timeout(15000);
        await library.verifyIsChannelLoaded('dev');
    });

    it('should open the details screen when selecting a pokemon', async function () {
        this.timeout(30000);
        await library.sendKey('down');
        await library.sendKey('select');
        const res = await library.verifyIsScreenLoaded({
            'elementData': [
                { 'using': 'tag', 'value': 'Label' },
                { 'using': 'text', 'value': 'Bulbasaur made its video game debut on February 27' }
            ]
        });
        expect(res).to.equal(true);
    });

    it('should display the "Available in" button on the details screen', async function () {
        this.timeout(20000);
        const res = await library.verifyIsScreenLoaded({
            'elementData': [
                { 'using': 'text', 'value': 'Available in' },
            ]
        });
        expect(res).to.equal(true);
    });

    it('should focus the button with "Play Video" text after countdown', async function () {
        this.timeout(20000);
        
        const focused = await library.getFocusedElement(5);
        expect(focused.XMLName.Local).to.equal('CustomButton');
        
        const labels = library.getChildNodes(focused, [
            { 'using': 'text', 'value': 'Play Video' }
        ]);
        expect(labels.length).to.be.greaterThan(0);
    });

    it('should return to the main screen when pressing back', async function () {
        this.timeout(20000);
        await library.sendKey('back');
        const res = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(res).to.equal(true);
    });

    it('should focus the row list component when returning to main screen', async function () {
        this.timeout(20000);
        const focusedElement = await library.getFocusedElement();
        expect(focusedElement.XMLName.Local).to.equal('BaseItem');
    });

    after(async () => {
        await library.close();
        childProcess.kill();
    });
});
