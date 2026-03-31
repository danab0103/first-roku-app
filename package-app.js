const rokuDeploy = require("roku-deploy");

rokuDeploy.deployAndSignPackage()
    .then((packagePath) => {
        console.log(`Signed package created at ${packagePath}`);
    })
    .catch((error) => {
        console.error(error);
    });
