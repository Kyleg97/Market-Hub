import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:MarketHub/api/api_news.dart';

class NewsPage extends StatefulWidget {
  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  //TextStyle style = TextStyle(
  //fontSize: 14, fontFamily: 'Montserrat', fontWeight: FontWeight.normal);

  List<String> newsSources = [
    "the-wall-street-journal",
    "financial-post",
    "bloomberg"
  ];

  List<Article> articles = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    callNews();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callNews();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*void loadStocktwits() async {
    setState(() {
      trending = null;
    });
    trending = await StocktwitsTrending.fetchStocktwitsTrending();
    setState(() {});
  }*/

  void callNews() {
    articles.clear();
    List<Article> tempList;
    newsSources.forEach((source) async {
      tempList = await News.fetchNews(source);
      tempList.forEach((element) {
        if (element.author != null &&
            element.content != null &&
            element.description != null &&
            element.source != null &&
            element.title != null &&
            element.url != null &&
            element.urlToImage != null) articles.add(element);
      });
      articles.sort(((b, a) => a.publishedAt.compareTo(b.publishedAt)));
      setState(() {});
      print("articles size: " + articles.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: articles.isEmpty
            ? CircularProgressIndicator()
            : SmartRefresher(
                enablePullDown: true,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Text(
                                  articles[index].title,
                                  //style: style,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Text(articles[index].source.name),
                            ),
                            Padding(
                                padding: EdgeInsets.all(15),
                                /*child: Image.network(
                                articles[index].urlToImage,
                              ),*/
                                child: CachedNetworkImage(
                                  imageUrl: articles[index].urlToImage,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                )),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: Text(
                                  articles[index].description,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(DateFormat(
                                            'MMMM dd, yyyy h:mm a')
                                        .format(articles[index].publishedAt))))
                          ],
                        ),
                      ),
                      /*child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () {},
                            title: Text(articles[index].title),
                            /*subtitle: Text(DateFormat('MMMM dd, yyyy h:mm a')
                                .format(articles[index].publishedAt)),*/
                            subtitle: Text(DateFormat('h:mm a')
                                .format(articles[index].publishedAt)),
                            trailing: Text(articles[index].source.name),
                          ),
                        ],
                      ),*/
                    );
                  },
                ),
              ),
      ),
    );
  }
}
