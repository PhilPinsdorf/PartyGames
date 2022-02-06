const express = require('express')

var codeIpAssignment = {}

const app = express();
const router = express.Router();

router.get('/createroom', (req, res) => {
    ip = decodeURIComponent(req.query.ip)
    var code = getNewCode();
    codeIpAssignment[code] = ip;
    console.log("Created code " + code + " for Server " + ip);
    res.send({"code": code}).status(200)
})

router.get('/getip', (req, res) => {
    code = req.query.code
    if(code in codeIpAssignment){
        console.log("Returned Ip " + codeIpAssignment[code] + " for Code " + code);
        res.send({"ip": codeIpAssignment[code]}).status(200)
    } else {
        res.send("Error").status(501)
    }
})

function getNewCode() {
    var new_value = createRoomCode()
    if(new_value in codeIpAssignment){
        return getNewCode();
    }
    return new_value;
}

function createRoomCode() {
    var min = 111111;
    var max = 999999;
    return Math.floor(Math.random() * (max - min + 1) + min);
}

app.use(router)
app.listen(process.env.PORT || 3000, () => console.log('Signaling Server started!'));

