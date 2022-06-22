import 'package:air_pollution/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test title'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Test Hive',
            textAlign: TextAlign.center,
          ),
          // ValueListenableBuilder는 Stream이랑 똑같다
          // box 데이터를 추가하면 바로바로 화면에 렌더링해준다.
          ValueListenableBuilder<Box>(
              valueListenable: Hive.box(testBox).listenable(),
              builder: (context, box, widget) {
                print(box.values.toList());
                return Column(
                  children: box.values.map((e) => Text(e.toString())).toList(),
                );
              }),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                print('key ${box.keys.toList()}');
                print('value ${box.values.toList()}');
              },
              child: const Text('Print Box')),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                // box.add('test03');
                box.put(101, true);
              },
              child: const Text('데이터 넣기')),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                print(box.get(100));
                print(box.getAt(4));
              },
              child: const Text('특정값 가져오기')),
          ElevatedButton(
              onPressed: () {
                final box = Hive.box(testBox);
                box.deleteAt(box.keys.length - 1);
              },
              child: const Text('특정값 삭제하기')),
        ],
      ),
    );
  }
}
