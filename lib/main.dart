import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(TotalWidget());

class TotalWidget extends StatefulWidget {
  @override
  _TotalWidgetState createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<TotalWidget> {


  var data;

  void setTotal() async{
    data = await getTotalData();
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    if(data == null){
      setTotal();
      return new MaterialApp(
          home: new Scaffold(
            appBar: new AppBar(
              title: new Text("Go Corona"),
              backgroundColor: Colors.red,
            ),
             body: new Text("Loading Data"),
          ),
    );

    }else{
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("Go Corona"),
            backgroundColor: Colors.red,
          ),

          body:
          RefreshIndicator(
            onRefresh: () async {
              setTotal();
            },
            child: new Card(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.filter_vintage),
                    title: new Text("Active"),
                    subtitle: new Text(data[0]['confirmed']),
                  ),
                  ListTile(
                    leading: Icon(Icons.accessibility_new),
                    title: new Text("Recovered"),
                    subtitle: new Text(data[0]['recovered']),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: new Text("Critical"),
                    subtitle: new Text(data[0]['critical']),
                  ),
                  ListTile(
                    leading: Icon(Icons.airline_seat_flat),
                    title: new Text("Deaths"),
                    subtitle: new Text(data[0]['deaths']),
                  ),
                ],
              ),
            ),
          ),
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
  }) async {
    Uri uri = Uri.https(_baseUrl, endpoint);
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

getTotalData() {
  APIService apiService = APIService();
  Future data = apiService.get(endpoint:'/totals');
  return data;
}




