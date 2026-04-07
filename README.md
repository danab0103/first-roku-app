# PokemonApp

A Roku app built as a hands-on learning exercise to explore Roku development: SceneGraph, BrightScript, and BrighterScript. 

## Description

The app main screen consists of two buttons and a RowList that displays Pokemon fetched from an API via a task. Selecting a Pokemon navigates to a details screen, pressing the Play Video button triggers a task that fetches the video URL from the API and starts playback once the data arrives, and the Search button navigates to a dedicated screen where Pokemon can be looked up by name. Beyond the core navigation flow, the app also incorporates an Animation node, a Timer node, rounded corners on RowList and MarkupGrid items, custom focus, and deeplink support through mediaType and contentId arguments.

## Getting Started

### Dependencies

* `brighterscript` ^0.70.3 - [BrighterScript](https://github.com/rokucommunity/brighterscript)
* `@rokucommunity/bslint` ^0.8.38 - [BrighterScript Lint](https://github.com/rokucommunity/bslint)
* `roku-deploy` ^3.16.3 - [An npm module for packaging and deploying to Roku devices](https://github.com/rokucommunity/roku-deploy)

### Installing

* Clone the repository and navigate to the project folder
* Install all dependencies:
```
npm install
```
* Copy the example config files and fill in your own values:
```
cp bsconfig.json.example bsconfig.json
cp rokudeploy.json.example rokudeploy.json
```
* Modify `bsconfig.json` with your project settings
* Modify `rokudeploy.json` with your Roku device credentials and `signingPassword` and `devId` generated via the [genkey](https://developer.roku.com/docs/developer-program/publishing/packaging-channels.md) utility on your Roku device

### Executing program

* To build and deploy the app directly to your Roku device, run:
```
npm run build
```
* To package the app for publishing, run:
```
npm run package
```
* Alternatively, you can sideload the app manually using the Development Application Installer:
  * In your web browser, navigate to your Roku device's IP address and log in with your [dev mode credentials](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md)
  * **Zip** the main files of the project
  * Click **Upload** and select the `.zip`
  * The app will launch on your Roku device
