import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/storageservis.dart';
import 'dart:io';

import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class KombinYukle extends StatefulWidget {
  @override
  _KombinYukleState createState() => _KombinYukleState();
}

class _KombinYukleState extends State<KombinYukle> {
  TextEditingController mevsimcont = TextEditingController();
  String _myActivity;
  // ignore: unused_field
  String _myActivityResult;
  File dosya;
  bool yukleniyor = false;

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: dosya == null ? yukleButonu() : gonderiFormu(),

      //dosya == null ? yukleButonu() : gonderiFormu()
    );
  }

  Widget yukleButonu() {
    return Container(
      decoration: new BoxDecoration(color: Colors.orange[300]),
      child: new IconButton(
          icon: Icon(
            Icons.file_upload,
            size: 50.0,
          ),
          onPressed: () {
            fotografSec();
          }),
    );
  }

  Widget gonderiFormu() {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Kombin Oluştur",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              dosya = null;
            });
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: _gonderiOlustur)
        ],
      ),
      body: ListView(
        children: <Widget>[
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.file(
              dosya,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          DropDownFormField(
            titleText: 'Mevsimler',
            hintText: 'Lütfen bir tane seçin',
            value: _myActivity,
            onSaved: (value) {
              setState(() {
                _myActivity = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _myActivity = value;
              });
            },
            dataSource: [
              {
                "display": "Yaz",
                "value": "Yaz",
              },
              {
                "display": "Kış",
                "value": "Kış",
              },
              {
                "display": "İlkbahar",
                "value": "İlkbahar",
              },
              {
                "display": "Sonbahar",
                "value": "Sonbahar",
              },
            ],
            textField: 'display',
            valueField: 'value',
          ),
        ],
      ),
    );
  }

  void _gonderiOlustur() async {
    if (!yukleniyor) {
      setState(() {
        yukleniyor = true;
      });
      String resimUrl = await StorageServisi().kombinResmiYukle(dosya);
      String aktifkullaniciID =
          Provider.of<YetkilendirmeServisi>(context, listen: false)
              .aktifkullaniciid;
      await FireStoreServisi().kombinOlustur(
        kombinResmiUrl: resimUrl,
        yayinlayanid: aktifkullaniciID,
        mevsim: _myActivity,
      );
      setState(() {
        yukleniyor = false;

        dosya = null;
      });
    }
  }

  fotografSec() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Kombin Oluştur"),
            children: [
              SimpleDialogOption(
                child: Text("Fotoğraf Çek"), //hikayeye ekle
                onPressed: () {
                  fotoCek();
                },
              ),
              SimpleDialogOption(
                child: Text("Galeriden Yükle"), //gönderi ekle
                onPressed: () {
                  galeridenSec();
                },
              ),
              SimpleDialogOption(
                child: Text("İptal"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  fotoCek() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 800.0,
        maxHeight: 600.0,
        imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });
  }

  galeridenSec() async {
    Navigator.pop(context);
    var image = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 800.0,
        maxHeight: 600.0,
        imageQuality: 80);
    setState(() {
      dosya = File(image.path);
    });
  }
}
