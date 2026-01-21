import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:news_app/common/colors.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/screens/news_info/news_info.dart';

class NewsCard extends StatelessWidget {
  final News article;

  const NewsCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => NewsInfo(
              news: article,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                /// Refactor + UI improvements by Thida
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        article.urlToImage ??
                            'https://via.placeholder.com/400x200',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),

                    /// SOURCE BADGE
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.source?.name ?? 'News',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// TITLE
                Text(
                  article.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// AUTHOR + TIME
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
                              article.author ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// TIME (safe handling)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppColors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          article.publishedAt != null &&
                              article.publishedAt!.isNotEmpty
                              ? Jiffy.parse(
                            article.publishedAt!,
                          ).fromNow()
                              : 'Unknown',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
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
                  article.description ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.grey[800],
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
