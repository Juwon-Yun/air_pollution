import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  test('test 1 : 각 스트림에서 모든 값이 한 개 이상 방출되었을 때 가장 최근 값들을 합쳐 방출해야 한다.', () async {
    // given
    var a = Stream.fromIterable(['a']),
        b = Stream.fromIterable(['b']),
        c = Stream.fromIterable(['c', 'd']);

    // when
    final stream = Rx.combineLatestList([a, b, c]);

    // then
    await expectLater(
        stream,
        emitsInOrder([
          ['a', 'b', 'c'],
          ['a', 'b', 'd'],
          emitsDone
        ]));
  }, timeout: const Timeout(Duration(seconds: 10)));

  test('test 2 : 각 스트림에서 모든 값이 한 개 이상 방출되었을 때, 가장 최근값들의 가장 마지막 값을 합쳐 방출해야 한다.',
      () async {
    // given
    var a = Stream.fromIterable(['a']),
        b = Stream.fromIterable(['b']),
        c = Stream.fromIterable(['c', 'd']);

    // when
    // 가장 마지막 값을 합치는 조건 추가
    final stream =
        Rx.combineLatest([a, b, c], (List<String> values) => values.last);

    // then
    await expectLater(stream, emitsInOrder(['c', 'd', emitsDone]));
  }, timeout: const Timeout(Duration(seconds: 10)));
}
