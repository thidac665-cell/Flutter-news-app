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
  final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  int activeCategory = 0;
  int page = 1;
  bool isLoading = false;
  bool isFinish = false;

  List<m.News> articles = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivityAndLoad();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        !isFinish) {
      _getNewsData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivityAndLoad() async {
    if (await getInternetStatus()) {
      _getNewsData();
    } else {
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const NoConnectivity()),
      );
      _checkConnectivityAndLoad();
    }
  }

  Future<void> _getNewsData() async {
    if (isLoading || isFinish) return;

    setState(() => isLoading = true);

    final listData = await NewsProvider()
        .GetEverything(categories[activeCategory], page);

    if (listData.status) {
      final items = listData.data as List<m.News>;

      if (items.isEmpty) {
        isFinish = true;
      } else {
        articles.addAll(items);
        page++;
        if (articles.length >= listData.totalContent) {
          isFinish = true;
        }
      }
    }

    setState(() => isLoading = false);
  }

  void onCategoryChange(int index) {
    if (index == activeCategory) return;

    setState(() {
      activeCategory = index;
      page = 1;
      isFinish = false;
      articles.clear();
    });

    _getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            "assets/images/logo.png",
            color: AppColors.white,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search, color: AppColors.white, size: 30),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// Categories
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryItem(
                      index: index,
                      categoryName: categories[index],
                      activeCategory: activeCategory,
                      onClick: () => onCategoryChange(index),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              /// News List
              Expanded(
                child: articles.isEmpty && isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : articles.isEmpty
                    ? const Center(
                  child: Text(
                    "No articles found",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: articles.length + 1,
                  itemBuilder: (context, index) {
                    if (index < articles.length) {
                      return NewsCard(article: articles[index]);
                    }

                    if (isFinish) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "You're all caught up",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
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
