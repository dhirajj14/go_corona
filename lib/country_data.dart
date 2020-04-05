import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';



class CountryDataWidget extends StatefulWidget {
  final String code;
  CountryDataWidget(this.code);

  @override
  CountryDataWidgetState createState() => CountryDataWidgetState(code);
}

class CountryDataWidgetState extends State<CountryDataWidget> {

  var data;
  final String code;
  CountryDataWidgetState(this.code);

  void setTotal() async{
    data = await getTotalData(code);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    if(data == null){
      setTotal();
      return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("Go Corona"),
          backgroundColor: Colors.red[800],
        ),
        body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset('assets/images/coronavirus.png',
                height: 200.0,
                width: 200.0,),
            ],
          ),
        ],
      ),
      );
    }else{
      return new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
          title: new Text("Go Corona"),
    backgroundColor: Colors.red[800],
    ),
    body: Column(
        children: <Widget>[
          new Container(
            child: new Padding(padding: EdgeInsets.all(10.0),
              child: new Text(data[0]['country'].toString() + " Data",
                style: new TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold, color: Colors.red[800]),
              ),
            ),
          ),
          new Container(
            child: RefreshIndicator(
              key: new GlobalKey<RefreshIndicatorState>(),
              onRefresh: () async {
                setTotal();
              },
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  makeDashboardItem(data[0]['confirmed'].toString(), "Confirmed"),
                  makeDashboardItem(data[0]['recovered'].toString(), "Recovered"),
                  makeDashboardItem(data[0]['critical'].toString(), "Critical"),
                  makeDashboardItem(data[0]['deaths'].toString(), "Deaths"),
                ],
              ),
            ),
          ),
        ],
      ),
      );
    }
  }
}

class APIService {
  // API key
  static const _api_key = "02ff106257msh9ff028f772619c3p18eed9jsnb3720e37cb77";
  // Base API url
  static const String _baseUrl = "covid-19-data.p.rapidapi.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
    "x-rapidapi-key": _api_key,
  };

  // Base API request to get response
  Future <dynamic> get({
    @required String endpoint,
    @required Map<String, String> query,
  }) async {
    Uri uri = Uri.https(_baseUrl, endpoint, query);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}

Card makeDashboardItem(String title, String name) {
  return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.red[800], borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: new InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                child: new Text(name, style: TextStyle(fontSize: 20.0, color: Colors.white,),),
//                  child: Icon(
//                    icon,
//                    size: 40.0,
//                    color: Colors.black,
//                  )
              ),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(NumberFormat("#,##,###", "en_US").format(int.parse(title)),
                  style:
                  new TextStyle(fontSize: 22.0, color: Colors.white, fontFamily: 'Orbitron', fontWeight: FontWeight.w900,letterSpacing: 2.0),
                ),
              )
            ],
          ),
        ),
      ));
}

getTotalData(String code) {
  APIService apiService = APIService();
  Future data = apiService.get(endpoint:'/country/code', query:{"format": "undefined", "code" : code});
  return data;
}