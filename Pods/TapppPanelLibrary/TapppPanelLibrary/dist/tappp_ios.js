
function handleMessage(gameId, bookId, width, broadcasterName, userId, widthUnit) {
    console.log('handleMessage details hai=', gameId, bookId, width, broadcasterName, userId, widthUnit);
    try {
        if(!bookId) {
            bookId = '1000009';
        }
        if(!widthUnit) {
            widthUnit = 'px';
        }
        if(gameId && bookId){
            //            Dynamically create a placeholder div for panel
            createDivForReactNative(gameId, bookId, width, broadcasterName, userId, widthUnit);
            //            Load all the react native scripts
            loadReactLiveScripts(broadcasterName);
            //            Helper functions
            //            helperTapppFn(gameId, bookId, width);
        }
    } catch(e) {
        console.log('...Error on handle message', e);
        document.getElementById('errorTag').innerHTML = "Oops something went wrong ...."+e;
    }
}
    
//    Create root div for the Panel library
    function createDivForReactNative(gameId, bookId, width, broadcasterName, userId, widthUnit) {
        const rootDiv = document.createElement('div');
        const rootTag = "<div id='tappp-panel' userid='"+ userId +"' bookid='"+ bookId +"' gameid='"+ gameId +"' width='"+ width +"' widthunit='" + widthUnit +"' broadcastername='" + broadcasterName + "' ></div>";
        console.log('...rootTag=', rootTag);
        rootDiv.innerHTML = rootTag;

        document.body.appendChild(rootDiv);

    }

// Load react live script
    function loadReactLiveScripts(broadcasterName) {
        const scriptTag = document.createElement('script');
        scriptTag.type = 'text/javascript';
        let tapppURL;
        if(broadcasterName === 'NFL') {
            tapppURL = 'https://dev-demo-nfl.tappp.com/';
        } else if(broadcasterName === 'TRN') {
            tapppURL = 'https://sandbox-mlr.tappp.com/';
        }

        console.log('tapppURL=', tapppURL);

        scriptTag.src = tapppURL + "mobile/bundle.js";
        document.body.appendChild(scriptTag);
    }

    function loadDynamicScriptData(panelData) {
        let scriptTag = document.createElement('script');
        var startTag = "(function () {";
        var endTag = "})();";


        var tapppPanelId = "var findId = document.getElementById('tappp-panel');"
        var setPanelData = "var updateUserId = findId.setAttribute('panel-data', JSON.stringify(panelData));"
        var finalTag = startTag + tapppPanelId + setPanelData + endTag;
        console.log('loadDynamicScriptData=', finalTag);
        scriptTag.innerHTML(finalTag);

        document.body.appendChild(scriptTag);
    }
    
// Load react script tags on
    function loadReactScripts() {
        let reactScripts = ["bundle.js"];
        
        for(let script of reactScripts) {
            if(script) {
                const scriptTag = document.createElement('script');
                scriptTag.type = 'text/javascript';
                scriptTag.src = "./" + script + ".js";
                document.body.appendChild(scriptTag);
            }
        }
    }
    
//    Do specific thing once the script loaded
    function callFunctionFromScript(gameId, bookId, width, calledFrom) {
        console.log('Test');
        const scritpTagFn = 'scriptOnloadTag';
        const divErr = document.createElement('div');
        divErr.innerHTML = calledFrom;
        document.getElementById(scritpTagFn).appendChild(divErr);
    }
    
    function helperTapppFn(gameId, bookId, width) {
        const helperDiv = document.createElement('div');
        let gameTag = "<input type='text' name='value' id='gameId' value='"+gameId+"' />";
        let bookTag = "<input type='text' name='value' id='bookId' value='"+bookId+"' />";
        let widthTag = "<input type='text' name='value' id='widthId' value='"+width+"' />";
        
        helperDiv.innerHTML = gameTag + bookTag + widthTag +`
            <label>
              <input type="checkbox" name="check" value="1" /> Checked?
            </label>
            <input type="button" value="-" onclick="removeRow(this)" />
          `;
        document.getElementById('parentId').appendChild(helperDiv);
    }
    


function callNative() {
    webkit.messageHandlers.callNative.postMessage({
        "message": "callNative method data passes"
    });
}

function nativeToJs(objPanelData){
    console.log("....objPanelData in js=", objPanelData)
}

function showiOSToast() {
    let nameField = document.getElementById('nameField').value;
    webkit.messageHandlers.toggleMessageHandler.postMessage({
        "message": nameField
    });
}
