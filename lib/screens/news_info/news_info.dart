import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:news_app/common/colors.dart';
import 'package:news_app/models/news_model.dart';

class NewsInfo extends StatelessWidget {
  final News news;

  const NewsInfo({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            /// Safe image handling added by Thida
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                news.urlToImage ??
                    'https://via.placeholder.com/400x200',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// TITLE
            Text(
              news.title ?? 'No title available',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 10),

            /// AUTHOR + DATE
            Row(
              children: [
                const Icon(Icons.person, size: 18),
                const SizedBox(width: 6),
                Text(
                  news.author ?? 'Unknown author',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 6),
                Text(
                  news.publishedAt != null &&
                      news.publishedAt!.isNotEmpty
                      ? Jiffy.parse(news.publishedAt!).fromNow()
                      : 'Unknown date',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// CONTENT
            /// Content fallback added by Thida
            Text(
              news.content?.isNotEmpty == true
                  ? news.content!
                  : 'No detailed content available for this article.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
