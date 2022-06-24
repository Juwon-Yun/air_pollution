import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/constants/data_config.dart';
import 'package:flutter/material.dart';

typedef OnRegionTap = void Function(String region);

class MainDrawer extends StatelessWidget {
  final OnRegionTap onRegionTap;
  final String selectedRegion;
  final Color darkColor;
  final Color lightColor;

  const MainDrawer({
    Key? key,
    required this.onRegionTap,
    required this.selectedRegion,
    required this.darkColor,
    required this.lightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: darkColor),
            child: DrawerHeader(
              curve: Curves.linearToEaseOut,
              child: Text(
                '지역 선택',
                style: defaultTextStyle.copyWith(fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          // ListView이외에도 넣을 수 있지만 ListView안에 넣는게 더 세팅이 되어있음
          ...regions
              .map((e) => ListTile(
                    tileColor: Colors.white,
                    selectedTileColor: lightColor,
                    selectedColor: Colors.black,
                    selected: e == selectedRegion,
                    onTap: () {
                      onRegionTap(e);
                    },
                    title: Text(e),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
