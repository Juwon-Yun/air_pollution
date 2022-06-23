import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/constants/fade_animation.dart';
import 'package:air_pollution/model/stat_model.dart';
import 'package:air_pollution/model/status_model.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final StatusModel status;
  final StatModel stat;
  final String region;
  final DateTime dateTime;
  final bool isExpanded;

  const MainAppBar({
    Key? key,
    required this.status,
    required this.stat,
    required this.region,
    required this.dateTime,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: status.primaryColor,
      pinned: true,
      title: isExpanded
          ? null
          : Text('$region ${DataUtils.getTimeFormat(dateTime: dateTime)}'),
      expandedHeight: 500,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            // appbar의 원래 높이만큼 설정
            margin: const EdgeInsets.only(top: kToolbarHeight),
            child: FadeAnimation(
              delay: 0.8,
              child: Column(
                children: [
                  Text(
                    region,
                    style: defaultTextStyle,
                  ),
                  Text(
                    DataUtils.getTimeFormat(dateTime: stat.dataTime),
                    style: defaultTextStyle.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    status.imagePath,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    status.label,
                    style: defaultTextStyle.copyWith(
                        fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status.comment,
                    style: defaultTextStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
