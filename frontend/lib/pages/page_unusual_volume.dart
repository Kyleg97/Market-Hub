import 'package:MarketHub/providers/reddit_provider.dart';
import 'package:MarketHub/providers/robinhood_provider.dart';
import 'package:MarketHub/providers/stocktwits_provider.dart';
import 'package:MarketHub/providers/unusual_volume_provider.dart';
import 'package:MarketHub/widgets/stocktwits_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MarketHub/services/trading_apps.dart';

class UnusualVolumePage extends StatefulWidget {
  UnusualVolumePage() : super();

  @override
  UnusualVolumePageState createState() => UnusualVolumePageState();
}

class UnusualVolumePageState extends State<UnusualVolumePage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(50, 20),
          ),
        ),
      ),
      body: Container(
        child: ChangeNotifierProvider.value(
          value: UnusualVolumeProvider(),
          child: Consumer<UnusualVolumeProvider>(
            builder: (context, provider, child) {
              return provider.isFetching
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => provider.fetchData(),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(5),
                        itemCount: provider.getItems.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {},
                                  title: Text(provider.getItems[index].ticker),
                                  subtitle:
                                      Text(provider.getItems[index].company),
                                  trailing: Text(
                                    "Volume:\n" +
                                        provider.getItems[index].volume
                                            .toString(),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
