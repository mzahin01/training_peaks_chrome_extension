// function changeColor(params) {
//     let color = params;
//     console.log('Color: ' + color);
//     chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
//         chrome.tabs.executeScript(
//             tabs[0].id,
//             { code: 'document.body.style.backgroundColor = "' + color + '";' });
//         });
//     return  'result change coloor : ' + color;
// }

async function getData() {
    return new Promise((resolve, reject) => {
        chrome.tabs.query({ active: true, currentWindow: true }, async function (tabs) {
            try {
                const result = await new Promise((innerResolve, innerReject) => {
                    chrome.tabs.executeScript(
                        tabs[0].id,
                        { file: "export_code.js" },
                        function (scriptResult) {
                            if (chrome.runtime.lastError) {
                                innerReject(chrome.runtime.lastError);
                            } else {
                                console.log('Got data from active tab: ' + JSON.stringify(scriptResult[0], null, 2));
                                innerResolve(scriptResult[0]);
                            }
                        }
                    );
                });
                console.log(result);
                resolve(result);
            } catch (error) {
                console.error(error);
                reject(error);
            }
        });
    });
}