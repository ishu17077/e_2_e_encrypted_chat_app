import {
    getFirestore,
    collection,
    addDoc,
    Timestamp,
} from 'firebase/firestore';

import readline from "readline"

import serviceAccount from './google-services.json' with {type: "json"};
import {
    initializeApp
}
from 'firebase/app';

// const serviceAccount = require("./google-services.json");
const app = initializeApp(serviceAccount);
const db = getFirestore(app);

async function sendMessage(senderUid, recipientUid, messageContent) {
    try {
        const newMessageRef = await addDoc(collection(db, 'messages'), {
            contents: messageContent == null || messageContent == "" ? 'Hola amigoooo' : messageContent,
            from: senderUid,
            time: Timestamp.now(), // Firestore's native Timestamp object
            to: recipientUid
        });
        console.log("Document written with ID: ", newMessageRef.id);
        return newMessageRef;
    } catch (e) {
        console.error("Error adding document: ", e);
    }
}

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
})

rl.question("Enter message: ", (answer) => {

    sendMessage("1oSLDBOyjANs6BsBURTV52aM5s33", "4kuXe3r67mfRDVSsZ82idPF1Srh2", answer);
    rl.close()
})