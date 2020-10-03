import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'customFloatingButon.dart';
import 'StateStatusScroller.dart';
import 'models.dart';
import 'other_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'States'),
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

  Future<List<StateInfo>> _getdataOffline() async {
    var data = await DefaultAssetBundle.of(context)
        .loadString('assets/state_district_wise.json');
    var jdata = json.decode(data) as Map;

    //Test Data
    var test_data = await DefaultAssetBundle.of(context)
        .loadString('assets/state_test_data.json');
    var tdata = json.decode(test_data) as Map;

    List<StateInfo> jlist = [];
    List<DistInfo> dlist = [];

    FilterDistrict(String state, String dname) {
      var data = jdata[state]['districtData'][dname] as Map;
      Status status = Status(data['active'], data['confirmed'],
          data['recovered'], data['deceased']);

      return status;
    }

    FilterState(String sname) {
      int act = 0, con = 0, rec = 0, dec = 0;
      List<DistInfo> districs = [];
      var ddata = jdata[sname]['districtData'] as Map;
      for (var dn in ddata.keys) {
        var data = FilterDistrict(sname, dn);

        act += data.active;
        con += data.confirmed;
        rec += data.recovered;
        dec += data.deceased;
        districs.add(new DistInfo(dn, data));
      }
      StateInfo stateInfo = new StateInfo(sname, jdata[sname]['statecode'],
          new Status(act, con, rec, dec,), districs,null);

      return stateInfo;
    }

    for (var s in jdata.keys) {
      var stateInfo = FilterState(s);
      jlist.add(stateInfo);
    }
    return jlist;
  }

  Future<List<StateInfo>> _getdata() async {
    var data =
        await http.get('https://api.covid19india.org/state_district_wise.json');
    // var data=DefaultAssetBundle.of(context).loadString('assets/state_district_wise.json');
    var jdata = json.decode(data.body) as Map;

    //Map<String,Map<String,Status>> stateMap;

    List<StateInfo> jlist = [];
    List<DistInfo> dlist = [];

    FilterDistrict(String state, String dname) {
      var data = jdata[state]['districtData'][dname] as Map;
      Status status = Status(data['active'], data['confirmed'],
          data['recovered'], data['deceased']);

      return status;
    }

    FilterState(String sname) {
      int act = 0, con = 0, rec = 0, dec = 0;
      List<DistInfo> districs = [];
      var ddata = jdata[sname]['districtData'] as Map;
      for (var dn in ddata.keys) {
        var data = FilterDistrict(sname, dn);

        act += data.active;
        con += data.confirmed;
        rec += data.recovered;
        dec += data.deceased;
        districs.add(new DistInfo(dn, data));
      }
      StateInfo stateInfo = new StateInfo(sname, jdata[sname]['statecode'],
          new Status(act, con, rec, dec), districs,null);

      return stateInfo;
    }

    for (var s in jdata.keys) {
      var stateInfo = FilterState(s);
      jlist.add(stateInfo);
    }

    return jlist;
  }

  void showAboutDialog({
    @required BuildContext context,
    String applicationName,
    String applicationVersion,
    Widget applicationIcon,
    String applicationLegalese,
    List<Widget> children,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
  }) {
    assert(context != null);
    assert(useRootNavigator != null);
    showDialog<void>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: applicationName,
          applicationVersion: applicationVersion,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
          children: children,
        );
      },
      routeSettings: routeSettings,
    );
  }
  // final controler=AnimationController(vsync: this, duration: Duration(seconds: 2));
  // final animation=Tween(begin: 0.0,end: 1.0,).animate(controler);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'States',
          style: TextStyle(color: Colors.black),
        ),
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            tooltip: 'About',
            onPressed: () {},
          )
        ],
      ),
      // drawer: Drawer(
      //     child: ListView(
      //   children: [
      //     ListTile(
      //       title: Text('About'),
      //       onTap: () {
      //         showAboutDialog(
      //             context: context,
      //             applicationName: "Covid Status",
      //             applicationVersion: "Beta",
      //             children: [
      //               Text('Developer: Manoj A.P'),
      //               Text('can be reached @ manojap@outlook.com'),
      //               Text('Web:' + 'http://manojap.github.io')
      //             ],
      //             applicationIcon: Icon(Icons.games));
      //       },
      //       leading: Icon(Icons.help),
      //     )
      //   ],
      // )),
      floatingActionButton: (MButon(
        onPressed: () {
          showAboutDialog(
              context: context,
              applicationName: "Covid Status",
              applicationVersion: "Beta",
              children: [

                Text('Developer: Manoj A.P'),
                Text('can be reached @ manojap@outlook.com'),
                Text('Web:' + 'http://manojap.github.io')
              ],
              applicationIcon: Icon(Icons.games));
        },
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown,
        child: Container(
          height: 50,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getdataOffline(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return    ListTile(  shape: StadiumBorder(),
                    trailing: Icon(Icons.more_horiz),
                    hoverColor: Colors.cyan,
                    leading:  CircleAvatar(

                      child:    Text(
                        snapshot.data[index].abr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(snapshot.data[index].sname,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue)),
                    focusColor: Colors.deepOrangeAccent,
                    subtitle: Text("Recovered:" +
                        snapshot.data[index].status.recovered.toString() + " | " + "Dead:" +
                        snapshot.data[index].status.deceased.toString() ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black54),),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => StateDetailPage(
                                    info: snapshot.data[index],
                                  )));
                    },
                  );
                },
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    ));
  }
}
