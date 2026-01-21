import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:news_app/common/colors.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/screens/news_info/news_info.dart';

class NewsCard extends StatefulWidget {
  final News article;

  const NewsCard({
    super.key,
    required this.article,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => NewsInfo(news: widget.article),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 0.2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.article.urlToImage ??
                        'https://via.placeholder.com/400x200',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// TITLE
                Text(
                  widget.article.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// AUTHOR + TIME ROW
                Row(
                  children: [
                    /// AUTHOR
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 18,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.article.author ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// TIME
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppColors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          Jiffy.parse(
                            widget.article.publishedAt ?? '',
                          ).fromNow(),
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// DESCRIPTION
                Text(
                  widget.article.description ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
