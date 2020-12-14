import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IpoItem extends StatelessWidget {
  final String tickerName;
  final String companyName;
  final String date;
  final String volume;
  final String priceRange;
  final String sharesNum;
  final int averageVolume;

  IpoItem(this.tickerName, this.companyName, this.date, this.volume,
      this.priceRange, this.sharesNum, this.averageVolume);

  final TextStyle textStyle = TextStyle(fontSize: 18, fontFamily: 'Montserrat');

  final NumberFormat volumeFormatter = new NumberFormat("#,##0", "en_US");
  final DateFormat datetimeFormatter = new DateFormat('MM/dd/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Text(
                  tickerName,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Text(
                  companyName + "\n",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    //color: Theme.of, //Colors.black12,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text("Current Volume:"),
                          Text(volume),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Card(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      elevation: 5,
                      // color: Colors.white, //Colors.black12,
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [],
                          ))),
                ),
              ],
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("IPO Date: " + date,
                      style: textStyle.copyWith(fontSize: 16)),
                ))
          ],
        ),
      ),
    );
  }
}
