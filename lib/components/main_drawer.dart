import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

// temp region row data
const regions = ['서울', '경기', '대구', '충남', '인천', '대전', '경북', '제주', '충북'];

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          DrawerHeader(
              child: Text(
            '지역 선택',
            style: defaultTextStyle.copyWith(fontSize: 20),
          )),
          // ListView이외에도 넣을 수 있지만 ListView안에 넣는게 더 세팅이 되어씨음

          // spread operator 로 List 를 하나씩 뿌려준다.
          // .. -> cascade operator
          ...regions
              .map((e) => ListTile(
                    tileColor: Colors.white,
                    selectedTileColor: lightColor,
                    selectedColor: Colors.black,
                    selected: e == '서울',
                    onTap: () {},
                    title: Text(e),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
