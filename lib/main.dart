import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'StateStatusScroller.dart';
import 'models.dart';

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
          new Status(act, con, rec, dec), districs);

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
          new Status(act, con, rec, dec), districs);

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
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            title: Text('About'),
            onTap: () {
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
            leading: Icon(Icons.help),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.help),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
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
                  return ListTile(
                    trailing: Icon(Icons.more_horiz),
                    hoverColor: Colors.cyan,
                    leading: CircleAvatar(
                      child: Text(
                        snapshot.data[index].abr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(snapshot.data[index].sname),
                    focusColor: Colors.deepOrangeAccent,
                    subtitle: Text("Active:" +
                        snapshot.data[index].status.active.toString()),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => StateDetailPage1(
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

class StateDetailPage1 extends StatelessWidget {
  @override
  final StateInfo info;

  const StateDetailPage1({Key key, this.info}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            info.sname,
          ),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            StatusScroller(
              status: info.status,
            ),
            NeattextBox(
              title: 'Districts',
              styl: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            Container(
                child: Expanded(
              child: StackCards(
                dist: info.distInfo,
              ),
            ))
          ],
        )));
  }
}

class StackCards extends StatelessWidget {
  final List<DistInfo> dist;

  StackCards({this.dist});

  Widget _buildDistirictInfo(BuildContext context, int index) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DistrictText(
            dist: dist[index],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildDistirictInfo,
      itemCount: dist.length,
    );
  }
}

class NeattextBox extends StatelessWidget {
  final String title;
  final TextStyle styl;

  const NeattextBox({Key key, @required this.title, this.styl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: styl,
          ),
        ));
  }
}

class DistrictText extends StatelessWidget {
  final DistInfo dist;

  const DistrictText({Key key, this.dist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
              child: NeattextBox(
            title: dist.dname,
            styl: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.lightGreen),
          )),
          Row(
            children: [
              NeattextBox(
                styl: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue),
                title: "Act :" + dist.status.active.toString(),
              ),
              NeattextBox(
                styl: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey),
                title: "Con :" + dist.status.confirmed.toString(),
              )
            ],
          ),
          Row(
            children: [
              NeattextBox(
                styl: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green),
                title: "Rec :" + dist.status.recovered.toString(),
              ),
              NeattextBox(
                styl: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepOrangeAccent),
                title: "Dead :" + dist.status.deceased.toString(),
              )
            ],
          )
        ],
      ),
    );
  }
}
