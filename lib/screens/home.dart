
import 'package:flutter/material.dart';
import 'package:stemnews/model/news.dart';
import 'package:stemnews/service/news_service.dart';

import 'news_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
List<News> newsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: getNewsList('trending'),
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(newsList.length==0){
                return Center(child: Text('No News Found'),);
              }else{
                return ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index){
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return NewsDetail(news: newsList[index],);
                      },));
                    },
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                          placeholder: AssetImage(
                            "assets/break.jpg"
                          ),
                          image: NetworkImage(
                            newsList[index].urlToImage,
                          ),
                        ),
                      ),
                      title: Text(newsList[index].title),
                      subtitle: Text(
                        newsList[index].description,
                        maxLines: 2,
                      ),
                    ),
                  );
                },);
              }
            }else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'),);
            }else {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }

  getNewsList(String s) async{
    newsList = await NewsService().getNewsList(s);
    return newsList;
  }
}
