import 'package:flutter/material.dart';
import 'package:news_app/common/colors.dart';
import 'package:news_app/common/common.dart';
import 'package:news_app/common/widgets/no_connectivity.dart';
import 'package:news_app/models/listdata_model.dart';
import 'package:news_app/models/news_model.dart' as m;
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home/widgets/CategoryItem.dart';
import 'package:news_app/screens/home/widgets/newsCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  int activeCategory = 0;
  int page = 1;
  bool isLoading = false;
  bool isFinish = false;
  bool hasData = false;
  List<m.News> articles = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    checkConnectivity();

    // Auto load more when scroll reaches bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !isLoading &&
          !isFinish) {
        getNewsData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    if (await getInternetStatus()) {
      getNewsData();
    } else {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => const NoConnectivity(),
        ),
      ).then((value) => checkConnectivity());
    }
  }

  Future<void> getNewsData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    ListData listData =
    await NewsProvider().GetEverything(categories[activeCategory], page++);

    if (listData.status) {
      List<m.News> items = listData.data as List<m.News>;
      hasData = true;

      if (items.isNotEmpty) {
        articles.addAll(items);
      }

      if (articles.length >= listData.totalContent) {
        isFinish = true;
      }

      setState(() {});
    }

    setState(() {
      isLoading = false;
    });
  }

  void onCategoryChange(int index) {
    setState(() {
      activeCategory = index;
      articles = [];
      page = 1;
      isFinish = false;
      hasData = false;
    });
    getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
              color: AppColors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.black,
        elevation: 5,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search, size: 34, color: AppColors.white),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => CategoryItem(
                    index: index,
                    categoryName: categories[index],
                    activeCategory: activeCategory,
                    onClick: () => onCategoryChange(index),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: articles.isEmpty && !isLoading
                    ? const Center(child: Text("No articles yet"))
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: articles.length + 1,
                  itemBuilder: (context, index) {
                    if (index < articles.length) {
                      return NewsCard(article: articles[index]);
                    } else {
                      // Show loading or end message
                      if (isFinish) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "No more articles",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16),
                            ),
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
