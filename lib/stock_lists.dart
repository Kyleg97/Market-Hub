import 'package:flutter/services.dart';

class StockLists {
  List<Stock> stockList;

  static void initList() async {
    String file = await rootBundle.loadString('assets/stocklist.csv');
  }
}

class Stock {
  String ticker;
  String name;
  String index;

  Stock(this.ticker, this.name, this.index);
}

/*body: Center(
        child: SafeArea(
          child: trending == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () {
                              TradingApps.installedApps.forEach((element) {
                                if (element["app_name"] == "Robinhood") {
                                  leavingAppDialog(trending[index].symbol);
                                  return;
                                }
                              });
                            },
                            title: Text(trending[index].symbol),
                            subtitle: Text(trending[index].name),
                            trailing:
                                Text(trending[index].watchlistCount.toString()),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),*/
