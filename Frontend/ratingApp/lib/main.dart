/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'UI/Pages/add_item.dart';
import 'register.dart';
import 'signin.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating App',
      home: MyHomePage(title: 'Rating App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Text buttonText = Text(_auth.currentUser == null ? 'Sign in' : 'Sign out');
  final duplicateItems = List<String>.generate(30, (i) => "Beer $i");
  var items = List<String>();
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: buttonText,
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                setState(() {
                  _auth.currentUser;
                });
                final User user = _auth.currentUser;
                if (user == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                  setState(() {
                    buttonText = Text(_auth.currentUser == null ? 'Sign in' : 'Sign out');
                  });
                  return;
                }
                await _auth.signOut();
                final String uid = user.uid;
                setState(() {
                  buttonText = Text(_auth.currentUser == null ? 'Sign in' : 'Sign out');
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddItem()),
                      );
                    },
                    title: Text('${items[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }
}*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/navigation_service.dart';
import 'package:ratingApp/route_paths.dart' as routes;
import 'package:ratingApp/router.dart' as router;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: router.generateRouting,
      initialRoute: _auth.currentUser == null ? routes.SignInRoute : routes.HomeRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
