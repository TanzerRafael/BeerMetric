const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');

admin.initializeApp();
const database = admin.firestore();
const entryApp = express();
const entryApp1 = express();
entryApp.use(cors({ origin:true }));
entryApp1.use(cors({ origin:true }));

/*    Cloud functions:

    - createNewEntry(Entry entry)              --> Adds a new entry to the collection.
    - updateEntryRating(string entryId)        --> Updates the overall-rating of a certain entry.
    - getAlreadyRatedEntries(string UserId)    --> Returns all entries with userId.
    - getEntriesStartsWith(string startsWith)  --> Returns all entries (by the entry name) that start with the filter string.
*/

/*
*  Adds a new entry to the collection.
*/
entryApp.post('/', async (req, res) => { 

    const entry = req.body;
    await database.collection('entries').add(entry);

    res.status(201).send();
});

/*
*  Updates the overall-rating of a certain entry.
*/
entryApp.put("/:id", async (req, res) => {

  if(req.body.overAllRating < 1 || req.body.overAllRating > 6) {

    res.status(400).send();
    return;
  }

  const body = req.body;
  
  await database.collection('entries').doc(req.params.id).update({
    ...body
  });

  res.status(200).send();
});

/*
*  Returns all entries with userId.
*/
entryApp.get('/:userId', async (req, res) => { 
    
  let entries = [];
  let id = req.params.userId;

  const result = database.collection('entries');
  const ids = await result.where('userIdRate', 'array-contains', id).get();

  ids.forEach(id => { 

    let data = id.data();
    entries.push(data);
  });

  res.status(200).send(JSON.stringify(entries));
});

/*
*  Returns all entries (by the entry name) that start with the filter string.
*/
entryApp1.get('/:filter', async (req, res) => {

  let entries = [];
  let searchString = req.params.filter;

  const result = database.collection('entries');
  const names = await result.where('name', '>=', searchString).where('name', '<=', searchString + '\uf8ff').get();

  names.forEach(name => {

    let id = name.id;
    let data = name.data();

    entries.push({id, ...data});   
  });

  res.status(200).send(JSON.stringify(entries));
});

/*
*  Exports functions to google cloud server.
*/
exports.createNewEntry = functions.https.onRequest(entryApp);           
exports.updateEntryRating = functions.https.onRequest(entryApp);            
exports.getAlreadyRatedEntries = functions.https.onRequest(entryApp);    
exports.getEntriesStartsWith = functions.https.onRequest(entryApp1);     