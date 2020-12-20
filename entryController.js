const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');

admin.initializeApp();
const database = admin.firestore();
const entryApp = express();
const entryApp1 = express();
entryApp.use(cors({ origin: true }));
entryApp1.use(cors({ origin: true }));

/*    Cloud functions:

    - createNewEntry(object entry)              --> Adds a new entry to the collection.
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

  if (req.body.overAllRating < 1 || req.body.overAllRating > 6) {

    res.status(400).send();
    return;
  }

  await database.collection('entries').doc(req.params.id).update({
    "data.overAllRating": req.body.overAllRating
  });

  /*const body = req.body;

  await database.collection('entries').doc(req.params.id).update({
    ...body
  });*/

  res.status(200).send();
});

/*
*  Returns all entries with userId.
*/
entryApp.get('/:userId', async (req, res) => {

  let entries = [];
  let id = req.params.userId;

  const result = database.collection('entries');
  const ids = await result.where('data.userIdRate', 'array-contains', id).get();

  ids.forEach(item => {

    let id = item.id;
    let data = item.data();

    entries.push({ id, ...data });
    //entries.push(data);
  });

  // Die JSON.stringify() Methode konvertiert einen JavaScript-Wert in einen JSON-String.
  let jsonString = JSON.stringify(entries);

  // Die Methode JSON.parse() erzeugt aus einem JSON-formatierten Text ein entsprechendes Javascript-Objekt.
  let jsonObject = JSON.parse(jsonString);

  //JSON.stringify(entries)
  res.status(200).send(jsonObject);
});

/*
*  Returns all entries (by the entry name) that start with the filter string.
*/
entryApp1.get('/:filter', async (req, res) => {

  let entries = [];
  let searchString = req.params.filter;

  const result = database.collection('entries');
  const names = await result.where('data.name', '>=', searchString).where('data.name', '<=', searchString + '\uf8ff').get();

  names.forEach(name => {

    let id = name.id;
    let data = name.data();

    entries.push({ id, ...data });
  });

  // Die JSON.stringify() Methode konvertiert einen JavaScript-Wert in einen JSON-String.
  let jsonString = JSON.stringify(entries);

  // Die Methode JSON.parse() erzeugt aus einem JSON-formatierten Text ein entsprechendes Javascript-Objekt.
  let jsonObject = JSON.parse(jsonString);

  //JSON.stringify(entries)
  res.status(200).send(jsonObject);
});

/*
*  Exports functions to google cloud server.
*/
exports.createNewEntry = functions.https.onRequest(entryApp);
exports.updateEntryRating = functions.https.onRequest(entryApp);
exports.getAlreadyRatedEntries = functions.https.onRequest(entryApp);
exports.getEntriesStartsWith = functions.https.onRequest(entryApp1);     