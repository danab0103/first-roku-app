const rokuLibrary = require("../library/rokuLibrary");
const expect = require("chai").expect;
const { spawn } = require('child_process');
const path = require('path');

const childProcess = spawn('./bin/RokuWebDriver_linux');

let library;

describe('Test deep linking', () => {
    before(async function () {
        this.timeout(50000);
        library = new rokuLibrary.Library("192.168.20.108");
        await library.sideLoad(path.resolve(__dirname, "../../out/hello-world.zip"), "rokudev", "rokudev");
    });

    it('should launch the channel', async function () {
        this.timeout(15000);
        await library.verifyIsChannelLoaded('dev');
    });

    it('should open the details screen when receiving an episode deep link', async function () {
        this.timeout(30000);
        await library.inputDeepLinkingData('dev', '0', 'episode');

        const isDetailsScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [
                { 'using': 'tag', 'value': 'Label' },
                { 'using': 'text', 'value': 'Bulbasaur made its video game debut on February 27' }
            ]
        });
        expect(isDetailsScreenLoaded).to.equal(true);
    });

    it('should return to the home screen when pressing back from a deep-linked details screen', async function () {
        this.timeout(15000);
        await library.sendKey('back');

        const isHomeScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(isHomeScreenLoaded).to.equal(true);
    });

    it('should start playback when receiving a movie deep link', async function () {
        this.timeout(30000);
        await library.inputDeepLinkingData('dev', '0', 'movie');

        const isPlaybackStarted = await library.verifyIsPlaybackStarted();
        expect(isPlaybackStarted).to.equal(true);
    });

    it('should return to the home screen when pressing back from a deep-linked video screen', async function () {
        this.timeout(15000);
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
