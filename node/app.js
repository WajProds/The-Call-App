const express = require('express');
const { Socket } = require('socket.io');
const app = express();

const PORT = process.env.PORT || 4000;
const server = app.listen(PORT, ()=>{
    console.log('Server is Started on', PORT);
});

const io = require('socket.io')(server);

io.on('connection', (Socket) => {
    console.log("Connected Successfully", Socket.id);
});