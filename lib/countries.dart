import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:iso_countries/iso_countries.dart';
import 'country_data.dart';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class CountriesWidget extends StatefulWidget {
  CountriesWidget();
  @override
  CountriesWidgetState createState() => CountriesWidgetState();
}

class CountriesWidgetState extends State<CountriesWidget> {

  CountriesWidgetState();
  static List<Country> mainDataList ;
  @override
  void initState() {
    super.initState();
    prepareDefaultCountries();
  }

  Future<void> prepareDefaultCountries() async {
    print("Getting");
     List<Country> countries;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      countries = await IsoCountries.iso_countries;
    } catch(exception) {
      countries = null;
    }

    if (!mounted) return;


    setState(() {
      mainDataList = countries;

    });
  }

  List<Country> newDataList;
  Future<List<Country>> search(String search) async {
    await Future.delayed(Duration(seconds: 1));
    return newDataList = mainDataList
        .where((Country) => Country.name.toLowerCase().startsWith(search.toLowerCase()) || Country.countryCode.toLowerCase().startsWith(search.toLowerCase()) )
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Country>(
            onSearch: search,
            minimumChars: 0,
            emptyWidget: Center(
              child: ListView.builder(itemBuilder: (BuildContext context, int index){
                final Country country = mainDataList[index];
                return ListTile(
                  title: Text(country.name),
                  subtitle: Text(country.countryCode),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountryDataWidget(country.countryCode)),
                    );
                  }
                );
              },
                itemCount: mainDataList != null ? mainDataList.length : 0,
              ),
            ),
            onItemFound: (Country val , int index) {
              return ListTile(
                title: Text(val.name),
                subtitle: Text(val.countryCode),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountryDataWidget(val.countryCode)),
                    );
                  }
              );
            },
          ),
        ),
      ),
    );
  }
}