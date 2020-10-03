import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'StateStatusScroller.dart';
import 'models.dart';

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
            Text('Place holder'),
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
