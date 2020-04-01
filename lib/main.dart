import 'package:flappy_search_bar/flappy_search_bar.dart';
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

  int _currentIndex = 0;

  var data;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
              backgroundColor: Colors.red[800],
            ),
             body: new Text("Loading Data"),
          ),
    );

    }else{
      return new MaterialApp(
        home: new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            title: new Text("Go Corona"),
            backgroundColor: Colors.red[800],
          ),

          body:
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: new Card(
                      child: RefreshIndicator(
                        key: new GlobalKey<RefreshIndicatorState>(),
                        onRefresh: () async {
                          setTotal();
                        },
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

                  new Container(
                    height: 80.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBar(),
                    ),
                  )
                ],
              ),
            ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text('Business'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                title: Text('School'),
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.red[800],
            onTap: onTabTapped,
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




