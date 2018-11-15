const { app, BrowserWindow} = require('electron')

let win;

function creatWindow() {
    win = new BrowserWindow({width: 800, height: 600})

    win.loadFile('index.html')

    win.webContents.openDevTools()

    win.on('closed', () => {
        win = null

    })

}

app.on('ready', creatWindow);

app.on('window-all-closed', () =>{
    if(process.platform !== 'darwin'){
        app.quit()
    }
})
