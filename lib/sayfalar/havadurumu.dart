import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:socialapp/modeller/kombin.dart';
import 'package:socialapp/sayfalar/teklikombin.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class HavaDurumu extends StatefulWidget {
  @override
  _HavaDurumuState createState() => _HavaDurumuState();
}

class _HavaDurumuState extends State<HavaDurumu> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double latitude;
  double longitude;
  var cityname;
  var havadurumu;
  var havaderecesi;
  var backgroundimage;
  var havaYorumu;
  bool veriVarmi = false;
  String data;
  List<Kombin> _kombinler = [];

  /* Future<void> _kullaniciKombinleriGetir() async {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    List<Kombin> kombinler =
        await FireStoreServisi().kullaniciKombinleriGetir(aktifKullaniciId);

    if (mounted) {
      setState(() {
        _kombinler = kombinler;
      });
    }
  }*/
  Future<void> _kullaniciKombinleriGetir(mevsim) async {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifkullaniciid;
    List<Kombin> kombinler = await FireStoreServisi()
        .kullaniciMevsimlikKombinleriGetir(aktifKullaniciId, mevsim);

    if (mounted) {
      setState(() {
        _kombinler = kombinler;
      });
    }
  }

  Future<void> getData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    print("asdsad");
    print(latitude);
    // Response response = await get(
    //     'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=bdb2256199732631b2b81c93bba1539a');
    Response response = await get(
        'https://api.openweathermap.org/data/2.5/weather?lat=40.2216569&lon=28.9622494&appid=bdb2256199732631b2b81c93bba1539a&units=metric');
    print(response.body);
    String data = response.body;
    havadurumu = jsonDecode(data)['weather'][0]['description'];
    cityname = jsonDecode(data)['name'];
    havaderecesi = jsonDecode(data)['main']['temp'];
    print(havadurumu);
    print(cityname);
    print(havaderecesi);
    veriVarmi = true;
    havadurumuGetir();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getData().then((data) => {havaderecesi = havaderecesi});
    //_kullaniciKombinleriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (veriVarmi == false) {
          return Center(child: CircularProgressIndicator());
        }
        return mainScreen();
      },
    );
  }

  Scaffold mainScreen() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: Text(
          "Hava Durumu",
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 22,
            fontFamily: 'LobsterTwoItalic',
          ),
        ),
        backgroundColor: Colors.orange[300],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstATop),
                  image: NetworkImage(backgroundimage),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    '$havaderecesi°',
                    style: TextStyle(
                      fontSize: 70,
                      fontFamily: 'RobotoLightItalic',
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    '$cityname',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'RobotoLightItalic',
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    '$havadurumu',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'RobotoLightItalic',
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '$havaYorumu',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'RobotoLightItalic',
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Kombin Önerileri',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'RobotoLightItalic',
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _kombinler.isEmpty
                      ? Container(
                          child: Text(
                          "Heniz Hiç Kombininiz Yok",
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'RobotoLightItalic',
                            color: Colors.grey[900],
                          ),
                        ))
                      : Container(
                          height: 120.0,
                          child: kombinOneri(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // return Center(
    //   child: ListView(
    //     children: [
    //       Container(
    //         child: Text('Derece: $havaderecesi'),
    //       ),
    //       Container(
    //         child: Text('Şehir: $cityname'),
    //       ),
    //       Container(
    //         child: Text('Hava Durumu: $havadurumu'),
    //       ),
    //     ],
    //   ),
    // );
  }

  ListView kombinOneri() {
    return ListView.builder(
      itemCount: _kombinler.length,
      //shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        Kombin kombin = _kombinler[index];
        if (_kombinler.isEmpty) {
          return Text(
            "Heniz Hiç Kombininiz Yok",
            style: TextStyle(color: Colors.black),
          );
        }
        return kombinKarti(kombin);
      },
    );
  }

  // Text havaDurumuGetir() {
  //   if (havadurumu == "clear sky") {
  //     return Text(
  //       "Hava Durumu clear sky",
  //       style: TextStyle(
  //         color: Colors.grey[100],
  //         fontSize: 22,
  //         fontFamily: 'LobsterTwoItalic',
  //       ),
  //     );
  //   } else {
  //     return Text(
  //       "havaDurumu gelmedi",
  //       style: TextStyle(
  //         color: Colors.grey[500],
  //         fontSize: 22,
  //         fontFamily: 'LobsterTwoItalic',
  //       ),
  //     );
  //   }
  // }
  havadurumuGetir() {
    if (havadurumu == "clear sky") {
      backgroundimage =
          "https://images.unsplash.com/photo-1581224463294-908316338239?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80";
      havadurumu = "Açık ☀";
      _kullaniciKombinleriGetir("Yaz");
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      //return Icon(FontAwesomeIcons.sun);
    } else if (havadurumu == "few clouds") {
      backgroundimage =
          "https://images.unsplash.com/photo-1514454529242-9e4677563e7b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80";
      havadurumu = "Bulutlu 🌤";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("İlkbahar");
      //return Icon(FontAwesomeIcons.cloudSun);
    } else if (havadurumu == "scattered clouds") {
      backgroundimage =
          "https://images.unsplash.com/photo-1596612265825-f7d7506ae4ad?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80";
      havadurumu = "Parçalı Bulutlu ☁";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("İlkbahar");
      //return Icon(FontAwesomeIcons.cloud);
    } else if (havadurumu == "broken clouds") {
      backgroundimage =
          "https://images.unsplash.com/photo-1513069020900-a162c4db0762?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=282&q=80";
      havadurumu = "Parçalı Bulutlu ☁";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("Sonbahar");
      // return Icon(FontAwesomeIcons.cloudflare);
    } else if (havadurumu == "shower rain") {
      backgroundimage =
          "https://images.unsplash.com/photo-1512511708753-3150cd2ec8ee?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80";
      havadurumu = "Sağanak Yağmurlu 🌧️";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("Yaz");
      // return Icon(FontAwesomeIcons.cloudShowersHeavy);
    } else if (havadurumu == "rain") {
      backgroundimage =
          "https://images.unsplash.com/photo-1525087740718-9e0f2c58c7ef?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=334&q=80";
      havadurumu = "Yağmurlu ☔";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("Kış");
      // return Icon(FontAwesomeIcons.cloudRain);
    } else if (havadurumu == "thunderstorm") {
      backgroundimage =
          "https://images.unsplash.com/photo-1605727216801-e27ce1d0cc28?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1051&q=80";
      havadurumu = "Rüzgarlı 💨";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("İlkbahar");
      _kullaniciKombinleriGetir("Sonbahar");
      // return Icon(FontAwesomeIcons.pooStorm);
    } else if (havadurumu == "snow") {
      backgroundimage =
          "https://images.unsplash.com/photo-1516715094483-75da7dee9758?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=967&q=80";
      havadurumu = "Karlı 🌨️";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("Kış");
      // return Icon(FontAwesomeIcons.cloudMeatball);
    } else if (havadurumu == "mist") {
      backgroundimage =
          "https://images.unsplash.com/photo-1459496330497-25b1010dd9c8?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1053&q=80";
      havadurumu = "Sisli 🌫️";
      havaYorumu = "Bugün Tshirt kombinlerini deneyebilirsin. ";
      _kullaniciKombinleriGetir("İlkbahar");
      // return Icon(FontAwesomeIcons.smog);
    } else {
      // return Icon(FontAwesomeIcons.smile);
    }
  }

  Column kombinKarti(Kombin kombin) {
    if (kombin == null) {
      return Column(
        children: [
          Text("Henüz Kombininiz Yok"),
        ],
      );
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          width: 80.0,
          height: 60.0,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 2), blurRadius: 6.0)
          ]),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TekliKombin(
                            kombin: kombin,
                          )));
            },
            child: CircleAvatar(
              backgroundColor: Colors.orange[300],
              //radius: 500,
              child: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(kombin.kombinResmiUrl),
                // width: 60.0,
                // height: 60.0,
                // image: ,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
