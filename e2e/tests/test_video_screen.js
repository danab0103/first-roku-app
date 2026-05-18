const rokuLibrary = require("../library/rokuLibrary");
const expect = require("chai").expect;
const { spawn } = require('child_process');
const path = require('path');

const childProcess = spawn('./bin/RokuWebDriver_linux');

let library;

describe('Test video screen', () => {
    before(async function () {
        this.timeout(50000);
        library = new rokuLibrary.Library("192.168.20.108");
        await library.sideLoad(path.resolve(__dirname, "../../out/hello-world.zip"), "rokudev", "rokudev");
    });

    it('should launch the channel', async function () {
        this.timeout(15000);
        await library.verifyIsChannelLoaded('dev');
    });

    it('should start playback from the home screen when pressing Play Video button', async function () {
        this.timeout(30000);
        await library.sendKey('select');
        const isPlaybackStarted = await library.verifyIsPlaybackStarted();
        expect(isPlaybackStarted).to.equal(true);
    });

    it('should return to the home screen when pressing back during playback', async function () {
        this.timeout(20000);
        await library.sendKey('back');
        const isHomeScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(isHomeScreenLoaded).to.equal(true);
    });

    it('should start playback from the details screen when pressing Play Video button', async function () {
        this.timeout(50000);
        await library.sendKey('down');
        await library.sendKey('select');
        await library.sendKey('select', 6);
        const isPlaybackStarted = await library.verifyIsPlaybackStarted();
        expect(isPlaybackStarted).to.equal(true);
    });

    it('should return to the details screen when pressing back during playback', async function () {
        this.timeout(20000);
        await library.sendKey('back');
        const isDetailsScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'CustomButton' }]
        });
        expect(isDetailsScreenLoaded).to.equal(true);
    });

    it('should return to the home screen when pressing back from details screen', async function () {
        this.timeout(20000);
        await library.sendKey('back');
        const isHomeScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(isHomeScreenLoaded).to.equal(true);
    });

    after(async () => {
        await library.close();
        childProcess.kill();
    });
});
