import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:newsfeedapp/models/news_model.dart';
import 'package:newsfeedapp/repository/api.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String countryCode = 'us';

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);

      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();

      newsProvider.fetchNews(countryCode);

      remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) async {
        await remoteConfig.activate();
        setState(() {
          countryCode = remoteConfig.getString("countryCode");
          newsProvider.fetchNews(countryCode);
        });
      });
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
        appBar: appBarWidget(context, countryCode),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Top Headlines",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              newsProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.grey,
                    ))
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              newsProvider.newsModel?.articles.length ?? 0,
                          itemBuilder: (context, index) {
                            final Article? article =
                                newsProvider.newsModel?.articles[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article?.source!.name ?? "",
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              article?.description ?? '',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black54,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              _formatPublishedAt(
                                                      article?.publishedAt) ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: article?.urlToImage != null
                                            ? Image.network(
                                                article?.urlToImage ?? '',
                                                height: 100.0,
                                                width: 100.0,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
            ])));
  }
}

String? _formatPublishedAt(DateTime? publishedAt) {
  if (publishedAt == null) return null;

  final difference = DateTime.now().difference(publishedAt);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inHours == 0) {
    return '${difference.inMinutes} mins ago';
  } else if (difference.inDays == 0) {
    return '${difference.inHours} hours ago';
  } else {
    return '${difference.inDays} days ago';
  }
}

PreferredSizeWidget appBarWidget(BuildContext context, String countryCode) {
  return AppBar(
    title: const Text(
      "MyNews",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    backgroundColor: Color(0xFF0C54BE),
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    actions: [
      Row(
        children: [
          Icon(
            Icons.navigation_rounded,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            countryCode.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    ],
  );
}
