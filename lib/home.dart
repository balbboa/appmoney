import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  double price = 0.00;
  String name = "";
  String symbol = "";

  handleClick() async {
    Uri url = Uri.parse(
        "https://api.hgbrasil.com/finance/stock_price?key=2b27854f&symbol=${_textController.text}");

    Response res = await get(url);
    Map data = json.decode(res.body);
    setState(() {
      symbol = data["results"][_textController.text.toUpperCase()]["symbol"];
      price = data["results"][_textController.text.toUpperCase()]["price"];
      name =
          data["results"][_textController.text.toUpperCase()]["company_name"];
    });

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text('Dados da ação ' + symbol + ':'),
              contentPadding: const EdgeInsets.all(20.0),
              children: [
                Text("Preço: " + price.toString() + " BRL"),
                Text("Empresa: " + name),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Voltar'))
              ],
            ));
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bit.jpg"),
                  fit: BoxFit.cover),
            ),
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'Insira o código da ação',
                      fillColor: Colors.white,
                      border: OutlineInputBorder()),
                ),
                MaterialButton(
                    onPressed: handleClick,
                    color: Colors.redAccent,
                    child: const Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            )));
  }
}
