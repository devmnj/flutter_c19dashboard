import 'dart:collection';

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'customFloatingButon.dart';

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

  Future<List<StateInfo>> _getdata() async {
    List<StateInfo> jlist = [];
    List<DistInfo> dlist = [];
    try {
      var data = await http
          .get('https://api.covid19india.org/state_district_wise.json');
      // var data=DefaultAssetBundle.of(context).loadString('assets/state_district_wise.json');
      var jdata = json.decode(data.body) as Map;

      //Test Data
      var test_data =
          await http.get('https://api.covid19india.org/state_test_data.json');
      var tdata = json.decode(test_data.body);

      FilterDistrict(String state, String dname) {
        var data = jdata[state]['districtData'][dname] as Map;
        Status status = Status(data['active'], data['confirmed'],
            data['recovered'], data['deceased']);

        return status;
      }

      DateTime today = DateTime.now();
      FilterState(String sname) {
        int act = 0, con = 0, rec = 0, dec = 0;
        List<DistInfo> districs = [];
        //test data

        var ddata = jdata[sname]['districtData'] as Map;
        var t_data = tdata['states_tested_data'] as List;

        FilterTest(String name, {DateTime dt = null}) {
          double tpo = 0,
              tne = 0,
              tunc = 0,
              tp_p = 0,
              r_fr_q = 0,
              c_in_q = 0,
              ttested = 0;
          var ye = new DateFormat("dd/MM/yyyy")
              .format(DateTime.now().subtract(Duration(days: 1)).toLocal());

          var l = t_data
              .where((element) =>
                  element['updatedon'] == ye && element['state'] == name)
              .toList();
          for (LinkedHashMap t in l) {
            t.forEach((key, value) {
              if (key == 'positive' && value != "" && value != null) {
                tpo += double.tryParse(t['positive']);
              }
              if (key == 'negative' && value != "" && value != null) {
                try {
                  tne += double.tryParse(t['negative']);
                  ;
                } catch (e) {}
              }
              if (key == 'unconfirmed' && value != "") {
                try {
                  tunc += int.tryParse(t['unconfirmed']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'totaltested' && value != "") {
                try {
                  ttested += int.tryParse(t['totaltested']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'totalpeoplecurrentlyinquarantine' && value != "") {
                try {
                  c_in_q += int.tryParse(t['totalpeoplecurrentlyinquarantine']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'totalpeoplereleasedfromquarantine' && value != "") {
                try {
                  r_fr_q +=
                      int.tryParse(t['totalpeoplereleasedfromquarantine']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'testsperpositivecase' && value != "") {
                try {
                  tp_p += int.tryParse(t['testsperpositivecase']);
                } catch (e) {
                  // TODO
                }
              }
            });
          }
          TestResult testResult =
              new TestResult(tpo, tne, tunc, tp_p, r_fr_q, c_in_q, ttested);
          return testResult;
        }

        var tests = FilterTest(sname);

        for (var dn in ddata.keys) {
          var data = FilterDistrict(sname, dn);

          act += data.active;
          con += data.confirmed;
          rec += data.recovered;
          dec += data.deceased;
          districs.add(new DistInfo(dn, data));
        }
        StateInfo stateInfo = new StateInfo(
            sname,
            jdata[sname]['statecode'],
            new Status(
              act,
              con,
              rec,
              dec,
            ),
            districs,
            tests);

        return stateInfo;
      }

      for (var s in jdata.keys) {
        var stateInfo = FilterState(s);
        jlist.add(stateInfo);
      }
    } catch (e) {}
    return jlist;
  }

  Future<List<StateInfo>> _getdataOffline(BuildContext context) async {
    var data = await DefaultAssetBundle.of(context)
        .loadString('assets/state_district_wise.json');
    var jdata = json.decode(data) as Map;

    //Test Data
    var test_data = await DefaultAssetBundle.of(context)
        .loadString('assets/state_test_data.json');
    JsonDecoder decoder = null;
    var tdata = json.decode(test_data);

    List<StateInfo> jlist = [];
    List<DistInfo> dlist = [];

    FilterDistrict(String state, String dname) {
      var data = jdata[state]['districtData'][dname] as Map;
      Status status = Status(data['active'], data['confirmed'],
          data['recovered'], data['deceased']);

      return status;
    }

    DateTime today = DateTime.now();
    FilterState(String sname) {
      int act = 0, con = 0, rec = 0, dec = 0;
      List<DistInfo> districs = [];
      //test data

      var ddata = jdata[sname]['districtData'] as Map;
      var t_data = tdata['states_tested_data'] as List;

      FilterTest(String name, {DateTime dt = null}) {
        double tpo = 0,
            tne = 0,
            tunc = 0,
            tp_p = 0,
            r_fr_q = 0,
            c_in_q = 0,
            ttested = 0;
        var ye = new DateFormat("dd/MM/yyyy")
            .format(DateTime.now().subtract(Duration(days: 1)).toLocal());

        var l = t_data
            .where((element) =>
                element['updatedon'] == ye && element['state'] == name)
            .toList();
        for (LinkedHashMap t in l) {
          bool flag = false;

          t.forEach((key, value) {
            if (key == 'state' && value == name) {
              flag = true;
            }
          });
          if (flag == true) {
            t.forEach((key, value) {
              if (key == 'positive' && value != "" && value != null) {
                tpo += double.tryParse(t['positive']);
              }
              if (key == 'negative' && value != "" && value != null) {
                try {
                  tne += double.tryParse(t['negative']);
                  ;
                } catch (e) {}
              }
              if (key == 'unconfirmed' && value != "") {
                try {
                  tunc += int.tryParse(t['unconfirmed']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'totaltested' && value != "") {
                try {
                  ttested += int.tryParse(t['totaltested']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'totalpeoplecurrentlyinquarantine' && value != "") {
                try {
                  c_in_q += int.tryParse(t['totalpeoplecurrentlyinquarantine']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'totalpeoplereleasedfromquarantine' && value != "") {
                try {
                  r_fr_q +=
                      int.tryParse(t['totalpeoplereleasedfromquarantine']);
                } catch (e) {
                  // TODO
                }
              }
              if (key == 'testsperpositivecase' && value != "") {
                try {
                  tp_p += int.tryParse(t['testsperpositivecase']);
                } catch (e) {
                  // TODO
                }
              }
            });
          }
        }
        TestResult testResult =
            new TestResult(tpo, tne, tunc, tp_p, r_fr_q, c_in_q, ttested);
        return testResult;
      }

      var tests = FilterTest(sname);

      for (var dn in ddata.keys) {
        var data = FilterDistrict(sname, dn);

        act += data.active;
        con += data.confirmed;
        rec += data.recovered;
        dec += data.deceased;
        districs.add(new DistInfo(dn, data));
      }
      StateInfo stateInfo = new StateInfo(
          sname,
          jdata[sname]['statecode'],
          new Status(
            act,
            con,
            rec,
            dec,
          ),
          districs,
          tests);

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
    //Style constants
    const TextStyle all_india_sub_title = TextStyle(
        fontSize: 12, color: Colors.yellow, fontWeight: FontWeight.bold);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'C19 Dashboard',
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

      floatingActionButton: (MButon(
        title: 'About',
        style: TextStyle(color: Colors.black),
        background_color: Colors.deepOrange,
        splash: Colors.orange,
        // newshape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(10))),
        onPressed: () {
          showAboutDialog(
              context: context,
              applicationName: "Dashboard - This is an open source project based on the data provide by http://api.covid19india.org",
              applicationVersion: "1.0.0",
              children: [
                Text('Developer: Manoj A.P'),
                Text('can be reached @ manojap@outlook.com'),
                Text('Web:' + 'http://manojap.github.io')
              ],
              applicationIcon: Icon(Icons.games));
        },
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown,
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Wrap(
            children: [
              GestureDetector(
                child: Tooltip(
                  message: 'Refresh',
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.home,
                      size: 40,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => MyApp()));
                },
              ),
              SizedBox(
                width: 35,
              ),
              GestureDetector(
                child: Tooltip(
                  message: 'Test Results',
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.control_point_duplicate,
                      size: 40,color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => StatesTests()));
                },
              ),

            ],
          ),
          height: 50,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getdata(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: StadiumBorder(),
                    trailing: Icon(Icons.more_horiz),
                    hoverColor: Colors.cyan,
                    leading: CircleAvatar(
                      child: Text(
                        snapshot.data[index].abr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(snapshot.data[index].sname,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    focusColor: Colors.deepOrangeAccent,
                    subtitle: Text(
                      "Recovered:" +
                          snapshot.data[index].status.recovered.toString() +
                          " | " +
                          "Dead:" +
                          snapshot.data[index].status.deceased.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
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
