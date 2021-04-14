import 'package:flutter/material.dart';
import 'package:inshoots/bloc/news_bloc.dart';
import 'package:inshoots/views/blogtile.dart';

class CategoryNews extends StatefulWidget {
  final String category;
  CategoryNews({this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  final newsBloc = NewsBloc();
  final category = CategoryAction();

  @override
  void initState() {
    super.initState();
    category.name = widget.category;
    category.action = NewsAction.FetchCategory;
    newsBloc.categoryNameSink.add(category);
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
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            // Blogs
            children: [
              Container(
                padding: EdgeInsets.only(top: 16),
                child: StreamBuilder(
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
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
