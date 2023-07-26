import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/components/z_card.dart';
import 'package:signalbyt/models/announcement_aggr.dart';

import '../../components/z_image_display.dart';
import '../../constants/app_colors.dart';
import '../../models/news_aggr.dart';
import '../../models_providers/app_provider.dart';
import '../../utils/z_format.dart';
import '../../utils/z_launch_url.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final newsAll = appProvider.newsAll;
    final announcements = appProvider.announcements;

    var tabs = appProvider.newsAll.length == 0
        ? null
        : TabBar(
            controller: _controller,
            indicatorColor: appColorYellow,
            labelColor: appColorYellow,
            tabs: [Tab(text: 'Announcements'), Tab(text: 'News')],
          );

    var body = appProvider.newsAll.length == 0
        ? AnnouncementDisplay(announcements: announcements)
        : TabBarView(controller: _controller, children: [
            AnnouncementDisplay(announcements: announcements),
            DisplayNews(news: newsAll),
          ]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        toolbarHeight: appProvider.newsAll.length == 0 ? null : 0,
        bottom: tabs,
      ),
      body: body,
    );
  }
}

class AnnouncementDisplay extends StatefulWidget {
  const AnnouncementDisplay({Key? key, required this.announcements}) : super(key: key);

  final List<Announcement> announcements;

  @override
  State<AnnouncementDisplay> createState() => _AnnouncementDisplayState();
}

class _AnnouncementDisplayState extends State<AnnouncementDisplay> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.announcements.length,
      itemBuilder: ((context, index) => Column(
            children: [
              if (index == 0) SizedBox(height: 8),
              _buildAnnouncementCard(widget.announcements[index]),
              if (index == widget.announcements.length - 1) SizedBox(height: 16),
            ],
          )),
    );
  }

  _buildAnnouncementCard(Announcement announcement) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return ZCard(
        onTap: () {
          if (announcement.link != '') ZLaunchUrl.launchUrl(announcement.link);
        },
        borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ZFormat.dateFormatSignal(announcement.timestampCreated)}',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 11),
                  ),
                  SizedBox(height: 4),
                  Text(announcement.title),
                  SizedBox(height: 4),
                  Text(
                    announcement.body,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall!.color),
                  ),
                ],
              ),
            ),
            if (announcement.image != '')
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZImageDisplay(
                      image: announcement.image,
                      width: MediaQuery.of(context).size.width * .2,
                      height: MediaQuery.of(context).size.width * .2,
                      borderRadius: BorderRadius.circular(8),
                    )
                  ],
                ),
              ),
          ],
        ));
  }
}

class DisplayNews extends StatefulWidget {
  final List<News> news;
  DisplayNews({Key? key, required this.news}) : super(key: key);

  @override
  State<DisplayNews> createState() => _DisplayNewsState();
}

class _DisplayNewsState extends State<DisplayNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.news.length,
        itemBuilder: ((context, index) => Column(
              children: [
                if (index == 0) SizedBox(height: 8),
                _buildNewsItem(widget.news[index]),
                if (index == widget.news.length - 1) SizedBox(height: 16),
              ],
            )),
      ),
    );
  }

  _buildNewsItem(News news) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      child: ZCard(
          borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
          onTap: () => ZLaunchUrl.launchUrl(news.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(news.site.toUpperCase()),
                  Text(
                    '${ZFormat.dateFormatSignal(news.publishedDate)}',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 11),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.625,
                    child: Text(
                      news.text,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  ZImageDisplay(
                    image: news.image,
                    width: MediaQuery.of(context).size.width * .2,
                    height: MediaQuery.of(context).size.width * .2,
                    borderRadius: BorderRadius.circular(8),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
