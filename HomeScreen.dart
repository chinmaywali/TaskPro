import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytodo_app/aboutPage.dart';
import 'package:mytodo_app/db_services/database.dart';
import 'package:random_string/random_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} 
 
class _HomeScreenState extends State<HomeScreen> {
  bool Personal = true, College = false, Office = false;

  bool suggest = false;

  TextEditingController todoController = TextEditingController();

  Stream? todoStream;

  getonTheLoad() async {
    todoStream = await DatabaseServices().getTask(Personal
        ? "Personal"
        : College
            ? "College"
            : "Office");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget getWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot docSnap = snapshot.data.docs[index];
                    return CheckboxListTile(
                      activeColor: Colors.greenAccent.shade400,
                      title: Text(docSnap["work"]),
                      value: docSnap["Yes"],
                      onChanged: (newValue) async {
                        await DatabaseServices().tickMethod(
                            docSnap["Id"],
                            Personal
                                ? "Personal"
                                : College
                                    ? "College"
                                    : "Office");
                        setState(() {
                          Future.delayed(Duration(seconds: 2), () {
                            DatabaseServices().removeMethod(
                                docSnap["Id"],
                                Personal
                                    ? "Personal"
                                    : College
                                        ? "College"
                                        : "Office");
                          });
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  ///logo
                  child: Image.asset(
                    'lib/images/logo.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(
                    color: Colors.grey[800],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      title: Text(
                        'About',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent.shade400,
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 70, left: 20),
        height: MediaQuery.of(context).size.height,
        //for responsive ui based on type of device(tab , phone , etc..)
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white54,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Hii.!,",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              child: Text(
                "User",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "Add your tasks here..!! ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Personal
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          //for color of the button  , covers entire text
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Personal",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = true;
                          College = false;
                          Office = false;

                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text(
                          "Personal",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                College
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          //for color of the button  , covers entire text
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "College",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = true;
                          Office = false;

                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text(
                          "College",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                Office
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          //for color of the button  , covers entire text
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Office",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = false;
                          Office = true;

                          await getonTheLoad();

                          setState(() {});
                        },
                        child: Text(
                          "Office",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            getWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Text(
                      "Add Tasks",
                      style: TextStyle(
                          color: Colors.greenAccent.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Add Text"),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Your Task",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () {
                        String id = randomAlphaNumeric(10);
                        Map<String, dynamic> userTodo = {
                          "work": todoController.text,
                          "Id": id,
                          "Yes": false,
                        };

                        Personal
                            ? DatabaseServices().addPersonalTask(userTodo, id)
                            : College
                                ? DatabaseServices()
                                    .addCollegeTask(userTodo, id)
                                : DatabaseServices()
                                    .addOfficeTask(userTodo, id);
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
