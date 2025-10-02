import {
    getFirestore,
    collection,
    addDoc,
    Timestamp,
} from 'firebase/firestore';
import serviceAccount from './google-services.json' assert {type: "json"};
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
            contents: messageContent,
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

sendMessage("1oSLDBOyjANs6BsBURTV52aM5s33", "4kuXe3r67mfRDVSsZ82idPF1Srh2", "sdsanjldjsalkdsal");
