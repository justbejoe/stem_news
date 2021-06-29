
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stemnews/model/news.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:url_launcher/url_launcher.dart';
import 'package:stemnews/service/AdmobHelper.dart';

class NewsDetail extends StatefulWidget {
  final News news;
  NewsDetail({this.news});

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {

  BannerAd bannerAd;

  final BannerAdListener listener = BannerAdListener(
    onAdLoaded: (ad) {
      print('ad loaded');
    },
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
    },
  );

  AdmobHelper admobHelper = new AdmobHelper();
  @override
  void initState() {
    bannerAd = BannerAd(size: AdSize.banner,
        adUnitId: "ca-app-pub-2556925170225238/4386677157",
        listener: listener,
        request: AdRequest());
    bannerAd.load();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: bannerAd);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;
    return Scaffold(
      body: extended.NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget> [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              title: Text(widget.news.title),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(widget.news.urlToImage, fit: BoxFit.fill,),

              ),
            )
          ];
        },
        pinnedHeaderSliverHeightBuilder: () => pinnedHeaderHeight,
        body: Container(
          child: Card(
            borderOnForeground: true,
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.news.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    widget.news.description,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: InkWell(
                      onTap: () async{
                        if(await canLaunch(widget.news.url)) {
                          await launch(widget.news.url);
                        }else{
                          log('not launching');
                        }
                      },
                      child: Text(
                        widget.news.url,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: adWidget,
                    alignment: Alignment.center,
                    width: bannerAd.size.width.toDouble(),
                    height: bannerAd.size.height.toDouble(),
                  ),
//                  RaisedButton(
//                    child: Text('click here'),
//                    onPressed: (){
//                      admobHelper.createInterAd();
//                    },
//                    onLongPress: () {
//                      admobHelper.showInterAd();
//                    },
//                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
