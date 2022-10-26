import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlc_app_2/models/english_today.dart';
import 'package:tlc_app_2/packages/quote/quote.dart';
import 'package:tlc_app_2/pages/all_word_page.dart';
import 'package:tlc_app_2/pages/control_page.dart';
import 'package:tlc_app_2/values/app_assets.dart';
import 'package:tlc_app_2/values/app_colors.dart';
import 'package:tlc_app_2/values/app_styles.dart';
import 'package:tlc_app_2/values/share_keys.dart';
import 'package:tlc_app_2/widgets/app_button.dart';

import '../packages/quote/qoute_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;
  List<EnglishToday> words = [];
  String quote = Quotes().getRandom().content!;
  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];
    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    final prefs = await SharedPreferences.getInstance();
    int length = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> randoms = fixedListRandom(len: length, max: nouns.length);
    randoms.forEach((index) {
      newList.add(nouns[index]);
    });
    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'English today',
          textAlign: TextAlign.center,
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(children: [
          Container(
            height: size.height * 1 / 10,
            padding: const EdgeInsets.all(24),
            alignment: Alignment.centerLeft,
            child: Text(
              '"$quote"',
              style: AppStyles.h5
                  .copyWith(fontSize: 14, color: AppColors.textColor),
            ),
          ),
          Container(
            height: size.height * 2 / 3,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: words.length,
                itemBuilder: (context, index) {
                  String result =
                      words[index].noun != null ? words[index].noun! : '';
                  String firstLetter = result.substring(0, 1).toUpperCase();
                  String leftLetter = result.substring(1, result.length);
                  String quoteDefault =
                      'Think of all the beauty still left around you and be happy';
                  String quote = words[index].quote != null
                      ? words[index].quote!
                      : quoteDefault;
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: AppColors.primaryColor,
                      elevation: 4,
                      child: InkWell(
                        onDoubleTap: () {
                          setState(() {
                            words[index].isFavorite = !words[index].isFavorite;
                          });
                        },
                        hoverColor: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 16, right: 8),
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                        AppAssets.heart,
                                        color: words[index].isFavorite
                                            ? Colors.red
                                            : Colors.white,
                                      )),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: firstLetter,
                                        style: TextStyle(
                                            fontFamily: FontFamily.sen,
                                            fontSize: 89,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              BoxShadow(
                                                  color: Colors.black38,
                                                  offset: Offset(3, 6),
                                                  blurRadius: 6)
                                            ]),
                                        children: [
                                          TextSpan(
                                            text: leftLetter,
                                            style: TextStyle(
                                                fontFamily: FontFamily.sen,
                                                fontSize: 60,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  BoxShadow(
                                                      color: Colors.black38,
                                                      offset: Offset(3, 6),
                                                      blurRadius: 6)
                                                ]),
                                          )
                                        ]),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 24),
                                      child: AutoSizeText(
                                        '"$quote"',
                                        maxLines: 8,
                                        style: AppStyles.h4.copyWith(
                                          letterSpacing: 1,
                                          color: AppColors.textColor,
                                        ),
                                      ))
                                ])),
                      ),
                    ),
                  );
                }),
          ),
          _currentIndex >= 5
              ? buildShowMore()
              : Container(
                  height: 8,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return buildIndicator(index == _currentIndex, size);
                      }),
                )
          //indicator
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exChange),
      ),
      drawer: Drawer(
          child: Container(
        color: AppColors.primaryColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 24),
            child: Text(
              'Your mind',
              style: AppStyles.h3.copyWith(
                color: AppColors.textColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: AppButton(label: 'Favorites', onTap: () {}),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: AppButton(
                label: 'Your Control',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ControlPage()));
                }),
          )
        ]),
      )),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(microseconds: 300),
      curve: Curves.easeInCubic,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lightBlue : AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }

  Widget buildShowMore() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        alignment: Alignment.centerLeft,
        child: Material(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          elevation: 4,
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AllWordPage(words: words)));
            },
            borderRadius: BorderRadius.all(Radius.circular(16)),
            overlayColor: MaterialStateProperty.all(Colors.amberAccent),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text('Show more',
                  style: AppStyles.h5
                      .copyWith(color: AppColors.textColor, fontSize: 14)),
            ),
          ),
        ));
  }
}
