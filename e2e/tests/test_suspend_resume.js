const rokuLibrary = require("../library/rokuLibrary");
const expect = require("chai").expect;
const { spawn } = require('child_process');
const path = require('path');

const childProcess = spawn('./bin/RokuWebDriver_linux');

let library;

describe('Test suspend and resume', () => {
    before(async function () {
        this.timeout(50000);
        library = new rokuLibrary.Library("192.168.20.108");
        await library.sideLoad(path.resolve(__dirname, "../../out/hello-world.zip"), "rokudev", "rokudev");
    });

    it('should launch the channel', async function () {
        this.timeout(15000);
        await library.verifyIsChannelLoaded('dev');
    });

    it('should open the home screen but close the video when suspending from a video opened from home', async function () {
        this.timeout(60000);

        await library.sendKey('select');
        const isPlaybackStarted = await library.verifyIsPlaybackStarted();
        expect(isPlaybackStarted, 'expected playback to start after pressing Play Video on the home screen').to.equal(true);

        await library.sendKey('home');
        await library.launchTheChannel('dev');

        const isHomeScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [{ 'using': 'tag', 'value': 'RowList' }]
        });
        expect(isHomeScreenLoaded).to.equal(true);

        const isPlaybackStillRunning = await library.verifyIsPlaybackStarted();
        expect(isPlaybackStillRunning, 'expected playback to be stopped after suspend/resume').to.equal(false);
    });

    it('should open the details screen but close the video when suspending from a video opened from details', async function () {
        this.timeout(30000);

        await library.sendKey('down');
        await library.sendKey('select');
        await library.sendKey('select', 6);
        const isPlaybackStarted = await library.verifyIsPlaybackStarted();
        expect(isPlaybackStarted, 'expected playback to start after opening the video from details').to.equal(true);

        await library.sendKey('home');
        await library.launchTheChannel('dev');

        const isDetailsScreenLoaded = await library.verifyIsScreenLoaded({
            'elementData': [
                { 'using': 'tag', 'value': 'Label' },
                { 'using': 'text', 'value': 'Bulbasaur made its video game debut on February 27' }
            ]
        });
        expect(isDetailsScreenLoaded).to.equal(true);

        const isPlaybackStillRunning = await library.verifyIsPlaybackStarted(3, 1);
        expect(isPlaybackStillRunning, 'expected playback to be stopped after suspend/resume').to.equal(false);
    });

    after(async () => {
        await library.close();
        childProcess.kill();
    });
});
