import 'package:flutter/material.dart';
import '../services/trading_apps.dart';

class StocktwitsCard extends StatelessWidget {
  final String symbol;
  final String name;
  final int watchlistCount;

  StocktwitsCard(this.symbol, this.name, this.watchlistCount);

  final TextStyle textStyle = TextStyle(fontSize: 18, fontFamily: 'Montserrat');

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              TradingApps.installedApps.forEach((element) {
                if (element["app_name"] == "Robinhood") {
                  // leavingAppDialog(stocktwitsTrending[index].symbol);
                  return;
                }
              });
            },
            title: Text(symbol),
            subtitle: Text(name),
            trailing: Text(
              "Watchlist Count:\n" + watchlistCount.toString(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
