import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'item_info.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Detalhes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ItemInfo> _items = [];
  late final List<charts.Series<dynamic, String>> seriesList;

  final MethodChannel channel = const MethodChannel('your_channel_name');

  @override
  void initState() {
    channel.setMethodCallHandler((call) async {
      if (call.method == "yourMethodName") {
        String jsonString = call.arguments;

        try {
          List<dynamic> jsonList = json.decode(jsonString);
          final itemInfoList =
              jsonList.map((jsonItem) => ItemInfo.fromJson(jsonItem)).toList();

          setState(() {
            _items = itemInfoList;
            seriesList = [
              charts.Series<ItemInfo, String>(
                id: 'Variação',
                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                domainFn: (ItemInfo item, _) => item.day,
                measureFn: (ItemInfo item, _) => item.stockVariation.max,
                data: itemInfoList,
              )
            ];
          });
        } catch (e, stackTrace) {
          print(e);
          print(stackTrace);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: charts.BarChart(
              seriesList,
              animate: false,
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  final current = _items[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dia: ${current.day}"),
                      Text("Data: ${current.date}"),
                      Text(
                          "Variação em relaçào a D-1: ${current.dailyVariation == "0.00%" ? "-" : current.dailyVariation}"),
                      Text(
                          "Variação em relação a primeira data ${current.totalVariation == "0.00%"? "-": current.totalVariation}"),
                      const Divider()
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
