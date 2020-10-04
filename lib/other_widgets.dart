import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models.dart';

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

class StatesHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

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
