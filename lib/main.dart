import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Body Mass Index Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int berat = 0;
  int tinggi = 0;
  String result;
  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextField(
                  controller: TextEditingController()..text = '0',
                  decoration: new InputDecoration(labelText: "Tinggi Badan"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (String str) {
                    var stringToInt = int.parse(str);
                    tinggi = stringToInt;
                  },
                ),
                TextField(
                  controller: TextEditingController()..text = '0',
                  decoration: new InputDecoration(labelText: "Berat Badan"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (String str) {
                    var stringToInt = int.parse(str);
                    berat = stringToInt;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    hitungBMI(tinggi, berat);
                    var newPostPush = ref.push();
                    return newPostPush.set(this.result);
                    //ref.child("Result BMI").set(this.result);
                  },
                  child: const Text('Submit'),
                ),
                Container(
                    child: Text(
                  this.result,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
                )),
              ],
            ),
          ),
        ));
  }

  hitungBMI(tinggi, berat) {
    String golonganBerat;
    double convertTinggi = tinggi / 100;
    double rumusBMI = berat / (convertTinggi * convertTinggi);
    // https://superyou.co.id/blog/kesehatan/cara-menghitung-berat-badan-ideal/
    print("hasil perhitungan rumus = $rumusBMI");

    if (rumusBMI < 18.1) {
      golonganBerat = "Underweight";
    } else if (rumusBMI > 18.1 && rumusBMI < 23.1) {
      golonganBerat = "Normal";
    } else if (rumusBMI > 23.1 && rumusBMI < 28.1) {
      golonganBerat = "Overwight";
    } else if (rumusBMI > 28.1) {
      golonganBerat = "Obesitas";
    } else {
      golonganBerat = "error";
    }

    setState(() {
      result = golonganBerat;
    });
  }
}
