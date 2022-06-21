import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/model/stat_model.dart';
import 'package:air_pollution/model/status_model.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final StatusModel status;
  final StatModel stat;

  const MainAppBar({Key? key, required this.status, required this.stat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: status.primaryColor,
      expandedHeight: 500,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            // appbar의 원래 높이만큼 설정
            margin: const EdgeInsets.only(top: kToolbarHeight),
            child: Column(
              children: [
                Text(
                  '서울',
                  style: defaultTextStyle,
                ),
                Text(
                  getTimeFormat(dateTime: stat.dataTime),
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
    );
  }

  String getTimeFormat({required DateTime dateTime}) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
