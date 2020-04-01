import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'custom_icons.dart' as CustomIcons;

void main() => runApp(TotalWidget());

class TotalWidget extends StatefulWidget {
  @override
  _TotalWidgetState createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<TotalWidget> {

  int _currentIndex = 1;

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
             )
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

          body: Container(
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
                              makeDashboardItem(data[0]['confirmed'], Icons.book),
                              makeDashboardItem(data[0]['recovered'], Icons.alarm),
                              makeDashboardItem(data[0]['critical'], Icons.alarm),
                              makeDashboardItem(data[0]['deaths'], Icons.alarm),
                            ],
                          ),
              ),
            ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.CustomIcons.earth),
                title: Text('Gobal'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag),
                title: Text('Country'),
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

Card makeDashboardItem(String title, IconData icon) {
  return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
        child: new InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.black,
                  )),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(title,
                    style:
                    new TextStyle(fontSize: 18.0, color: Colors.black)),
              )
            ],
          ),
        ),
      ));
}

getTotalData() {
  APIService apiService = APIService();
  Future data = apiService.get(endpoint:'/totals');
  return data;
}




