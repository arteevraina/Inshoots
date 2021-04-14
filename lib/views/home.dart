import 'package:flutter/material.dart';
import 'package:inshoots/bloc/news_bloc.dart';
import 'package:inshoots/helper/data.dart';
import 'package:inshoots/models/article_model.dart';
import 'package:inshoots/models/category_model.dart';
import 'package:inshoots/views/blogtile.dart';
import 'package:inshoots/views/category_tile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];

  final newsBloc = NewsBloc();

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    newsBloc.eventSink.add(NewsAction.Fetch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("In"),
            Text(
              "Shoots",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Categories
              Container(
                height: 70,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      imageUrl: categories[index].imageUrl,
                      categoryName: categories[index].categoryName,
                    );
                  },
                ),
              ),
              // Blogs
              Container(
                padding: EdgeInsets.only(top: 16),
                child: StreamBuilder<List<ArticleModel>>(
                  stream: newsBloc.newsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var article = snapshot.data[index];
                        return BlogTile(
                          imageUrl: article.urlToImage,
                          title: article.title,
                          description: article.description,
                          url: article.url,
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
