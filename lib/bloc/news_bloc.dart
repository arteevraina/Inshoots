import 'dart:async';
import 'package:inshoots/models/article_model.dart';
import 'package:inshoots/helper/news.dart';

enum NewsAction {
  Fetch,
  FetchCategory,
}

class CategoryAction {
  String name;
  NewsAction action;

  String get categoryName => name;
  NewsAction get newsAction => action;
}

class NewsBloc {
  ///Define stream controller here.
  final _stateStreamController = StreamController<List<ArticleModel>>();

  // Define sink for _stateStreamController.
  StreamSink<List<ArticleModel>> get newsSink => _stateStreamController.sink;

  // Define stream for _stateStreamController.
  Stream<List<ArticleModel>> get newsStream => _stateStreamController.stream;

  // Define stream controller here.
  final _eventStreamController = StreamController<NewsAction>();

  // Define sink for _eventStreamController.
  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;

  // Define stream for _eventStreamController.
  Stream<NewsAction> get eventStream => _eventStreamController.stream;

  // Define stream controller here.
  final _eventStreamCategoryNameController = StreamController<CategoryAction>();

  // Define sink for _eventStreamCategoryNameController.
  StreamSink<CategoryAction> get categoryNameSink =>
      _eventStreamCategoryNameController.sink;

  // Define stream for _eventStreamCategoryNameController.
  Stream<CategoryAction> get categoryNameStream =>
      _eventStreamCategoryNameController.stream;

  // Defining the constructor.
  NewsBloc() {
    eventStream.listen((event) async {
      if (event == NewsAction.Fetch) {
        try {
          News news = News();
          await news.getNews();
          newsSink.add(news.news);
        } on Exception catch (e) {
          newsSink.addError(
            "Something went wrong : $e",
          );
        }
      }
    });

    categoryNameStream.listen((event) async {
      if (event.action == NewsAction.FetchCategory) {
        try {
          CategoryNewsClass categoryNewsInstance = CategoryNewsClass();
          await categoryNewsInstance.getNews(event.categoryName);
          newsSink.add(categoryNewsInstance.news);
        } on Exception catch (e) {
          newsSink.addError(
            "Something went wrong $e",
          );
        }
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
    _eventStreamCategoryNameController.close();
  }
}
