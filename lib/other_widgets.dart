import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_c19dashboard/main.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class StateLeveTestReult {
  final String sname;
  final TestResult tests;

  StateLeveTestReult(this.sname, this.tests);
}

class StatesTests extends StatelessWidget {
  //Styles
  static const TextStyle stylHead = TextStyle(
      color: Colors.yellowAccent, fontSize: 18, fontWeight: FontWeight.w300);
  static const TextStyle stylDName =
      TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.w300);
  static const TextStyle styText =
      TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300);

  const StatesTests({Key key}) : super(key: key);

  Future<List<StateLeveTestReult>> _getdataOffline(BuildContext context) async {
    var data = await DefaultAssetBundle.of(context)
        .loadString('assets/state_district_wise.json');
    var jdata = json.decode(data) as Map;

    //Test Data
    var test_data = await DefaultAssetBundle.of(context)
        .loadString('assets/state_test_data.json');
    JsonDecoder decoder = null;
    var tdata = json.decode(test_data);

    List<StateLeveTestReult> jlist = [];

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
      var stateTest = StateLeveTestReult(sname, tests);

      return stateTest;
    }

    for (var s in jdata.keys) {
      var stateInfo = FilterState(s);
      jlist.add(stateInfo);
    }
    return jlist;
  }

  Future<List<StateLeveTestReult>> _getdata() async {
    List<StateLeveTestReult> jlist = [];
    try {
      var data =
      await http.get('https://api.covid19india.org/state_district_wise.json');
      // var data=DefaultAssetBundle.of(context).loadString('assets/state_district_wise.json');
      var jdata = json.decode(data.body) as Map;

      //Test Data
      var test_data =
      await http.get('https://api.covid19india.org/state_test_data.json');
      var tdata = json.decode(test_data.body);


      DateTime today = DateTime.now();
      FilterState(String sname) {
        int act = 0,
            con = 0,
            rec = 0,
            dec = 0;
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
                    c_in_q +=
                        int.tryParse(t['totalpeoplecurrentlyinquarantine']);
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
          new TestResult(
              tpo,
              tne,
              tunc,
              tp_p,
              r_fr_q,
              c_in_q,
              ttested);
          return testResult;
        }

        var tests = FilterTest(sname);
        var stateTest = StateLeveTestReult(sname, tests);

        return stateTest;
      }

      for (var s in jdata.keys) {
        var stateInfo = FilterState(s);
        jlist.add(stateInfo);
      }
    }
    catch(e){}
    return jlist;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('State Test List'),
      ),
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
                      size: 40,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => StatesTests()));
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
                  return Card(
                    color: Colors.indigo,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Text(
                          snapshot.data[index].sname,
                          style: stylDName,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Row(children: [
                                Column(
                                  children: [
                                    Column(children: [
                                      Text(
                                        'Positive',
                                        style: stylHead,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        snapshot.data[index].tests.positive
                                            .toString(),
                                        style: styText,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ]),
                                  ],
                                ),
                                SizedBox(
                                  width: 48,
                                ),
                                Column(children: [
                                  Text('Negative', style: stylHead),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      snapshot.data[index].tests.negaitive
                                          .toString(),
                                      style: styText),
                                ]),
                                SizedBox(
                                  width: 48,
                                ),
                                Column(children: [
                                  Text('Un Confirmed', style: stylHead),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      snapshot.data[index].tests.unconfirmed
                                          .toString(),
                                      style: styText),
                                ]),
                                SizedBox(
                                  width: 48,
                                ),
                                Column(children: [
                                  Text('In Quarantine', style: stylHead),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      snapshot.data[index].tests
                                          .currently_in_quarantine
                                          .toString(),
                                      style: styText),
                                ]),
                                SizedBox(
                                  width: 48,
                                ),
                                Column(children: [
                                  Text('Left Quarantine', style: stylHead),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      snapshot.data[index].tests
                                          .released_from_quarantine
                                          .toString(),
                                      style: styText),
                                ]),
                                SizedBox(
                                  width: 48,
                                ),
                                Column(children: [
                                  Text('Case v/s +ve', style: stylHead),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      snapshot.data[index].tests
                                          .tests_per_positive_case
                                          .toString(),
                                      style: styText),
                                ]),
                                SizedBox(
                                  width: 48,
                                ),
                                Column(children: [
                                  Text('Total Tests', style: stylHead),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      snapshot.data[index].tests.totaltested
                                          .toString(),
                                      style: styText),
                                ])
                              ]),
                            ],
                          ),
                        ),
                      ]),
                    ),
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

class DistrictDetailPage extends StatelessWidget {
  final DistInfo distInfo;

  const DistrictDetailPage({Key key, this.distInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'District Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.brown,
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: Wrap(
                  children: [
                    GestureDetector(
                      child: Tooltip(
                        message: 'Refressh',
                        child: Icon(
                          Icons.home,
                          size: 55,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => MyApp()));
                      },
                    ),
                  ],
                ),
                height: 50,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        'Active',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      Icon(
                        Icons.airline_seat_recline_extra,
                        color: Colors.orange,
                        size: 45,
                      ),
                      Text(
                        distInfo.status.active.toString(),
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Confirmed',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      Icon(
                        Icons.airline_seat_flat_angled,
                        color: Colors.deepOrange,
                        size: 45,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        distInfo.status.confirmed.toString(),
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Recovered',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      Icon(
                        Icons.airline_seat_recline_normal,
                        color: Colors.greenAccent,
                        size: 45,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        distInfo.status.recovered.toString(),
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Death',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Tooltip(
                        child: Icon(
                          Icons.airline_seat_recline_normal,
                          color: Colors.redAccent,
                          size: 45,
                        ),
                        message: 'No of people dead',
                        waitDuration: Duration(seconds: 2),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        distInfo.status.deceased.toString(),
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}

class DistrictReport extends StatelessWidget {
  final List<DistInfo> distList;

  //Styles
  static const TextStyle stylHead = TextStyle(
      color: Colors.yellowAccent, fontSize: 18, fontWeight: FontWeight.w300);
  static const TextStyle stylDName =
      TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.w300);
  static const TextStyle styText =
      TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300);

  Widget get_data(BuildContext context, int index) {
    return Card(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [Text(
          distList[index].dname.trim(),
          style: stylDName,
        ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Row(children: [
                  Column(
                    children: [
                      Column(children: [
                        Text(
                          'Active',
                          style: stylHead,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          distList[index].status.active.toString(),
                          style: styText,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ]),
                    ],
                  ),
                  SizedBox(
                    width: 48,
                  ),
                  Column(children: [
                    Text('Confirmed', style: stylHead),
                    SizedBox(
                      width: 8,
                    ),
                    Text(distList[index].status.confirmed.toString(),
                        style: styText),
                  ]),
                  SizedBox(
                    width: 48,
                  ),
                  Column(children: [
                    Text('Recovered', style: stylHead),
                    SizedBox(
                      width: 8,
                    ),
                    Text(distList[index].status.recovered.toString(),
                        style: styText),
                  ]),
                  SizedBox(
                    width: 48,
                  ),
                  Column(children: [
                    Text('Deceased', style: stylHead),
                    SizedBox(
                      width: 8,
                    ),
                    Text(distList[index].status.deceased.toString(),
                        style: styText),
                  ])
                ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  const DistrictReport({Key key, this.distList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('District Status'),
      ),
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
                      size: 40,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
          height: 50,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              'All district Data',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: get_data,
                itemCount: distList.length,
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class StateDetailPage extends StatelessWidget {
  @override
  final StateInfo info;

  const StateDetailPage({Key key, this.info}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            info.sname,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.brown,
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Wrap(
              children: [
                GestureDetector(
                  child: Tooltip(
                    message: 'Refressh',
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
                Tooltip(
                  message: 'District Data',
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DistrictReport(distList: info.distInfo)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.recent_actors,
                        color: Colors.brown,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            height: 50,
          ),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            TestStatus(
              result: info.tests,
            ),
            Expanded(
                child: DistrictList(
              dist: info.distInfo,
            ))
          ],
        )));
  }
}

class DistrictList extends StatelessWidget {
  final List<DistInfo> dist;

  const DistrictList({Key key, this.dist}) : super(key: key);

  Widget _buildDistirictInfo(BuildContext context, int index) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => DistrictDetailPage(
                            distInfo: dist[index],
                          )));
            },
            hoverColor: Colors.grey,
            focusColor: Colors.deepOrange,
            leading: CircleAvatar(
              child: Text(dist[index].dname.substring(0, 2).toUpperCase()),
              backgroundColor: Colors.greenAccent,
            ),
            title: Text(
              dist[index].dname,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.apps),
            shape: StadiumBorder(),
            subtitle: Text(
              "Recovered  " +
                  dist[index].status.recovered.toString() +
                  " | " +
                  "Confirmed  " +
                  dist[index].status.confirmed.toString(),
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
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

class TestStatus extends StatelessWidget {
  final TestResult result;

  const TestStatus({Key key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1201,
      child: Row(

          // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(children: [
                    Tooltip(
                        message: 'Positive count',
                        child: Icon(
                          Icons.add,
                          color: Colors.redAccent,
                        )),
                    // Text(
                    //   'Positive',
                    //   style: TextStyle(color: Colors.black, fontSize: 20),
                    // ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      result.positive.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Column(children: [
                    Tooltip(
                      message: 'Negative count',
                      child: Icon(
                        Icons.airline_seat_recline_normal,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      result.negaitive.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Column(children: [
                    Tooltip(
                      message: 'Unconfirmed count',
                      child: Icon(
                        Icons.airline_seat_recline_normal,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      result.unconfirmed.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Column(children: [
                    Tooltip(
                      message: 'Total Tested ',
                      child: Icon(
                        Icons.title,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      result.totaltested.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
    );
  }
}
