import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tlc_app_2/models/english_today.dart';
import 'package:tlc_app_2/utils/support_app.dart';
import 'package:tlc_app_2/values/app_assets.dart';
import 'package:tlc_app_2/values/app_colors.dart';
import 'package:tlc_app_2/values/app_styles.dart';

class AllWordPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordPage({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.pop(context);
            },
            child: Image.asset(AppAssets.letArrow),
          ),
        ),
        body: Container(
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: words
                .map((e) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        e.noun != null
                            ? SupportApp.capitalize(e.noun ?? '')
                            : '',
                        style: AppStyles.h4.copyWith(shadows: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(2, 3),
                            blurRadius: 6,
                          )
                        ]),
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}
