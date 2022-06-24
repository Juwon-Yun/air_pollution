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

  test('test 3 : 0, 1, 2, 3, 4, 5가 순차적으로 발행되어야 한다.', () {
    //given
    var a = Stream.fromIterable([0, 1, 2]), b = Stream.fromIterable([3, 4, 5]);

    // when
    final stream = Rx.concat([a, b]);

    // then
    expect(stream, emitsInOrder([0, 1, 2, 3, 4, 5]));
  }, timeout: const Timeout(Duration(seconds: 10)));

  test('test 4 : 0, 1, 2, 3, 4, 5가 순차적으로 발행되어야 한다.', () {
    // given
    var a = Stream.fromIterable([0, 1, 2]), b = Stream.fromIterable([3, 4, 5]);

    // when
    final stream = Rx.concatEager([a, b]);

    // then
    expect(stream, emitsInOrder([0, 1, 2, 3, 4, 5]));
  }, timeout: const Timeout(Duration(seconds: 10)));

  test('defer 기본', () {
    // given
    var a = Stream.value(1);

    // when
    final stream = Rx.defer(() => a);

    // then
    stream.listen(expectAsync1(
      (event) {
        expect(event, 1);
      },
      count: 1,
    ));
  }, timeout: const Timeout(Duration(seconds: 10)));

  test('defer는 단일 구독이 기본이므로 여러번 구독했을때 실패해야한다.', () {
    // given
    var a = Stream.value(1);

    // when
    final stream = Rx.defer(() => a);

    // then
    try {
      stream.listen(null);
      stream.listen(null);
    } catch (error) {
      print(error); // Bad state: Stream has already been listened to.
      expect(error, isStateError);
    }
  }, timeout: const Timeout(Duration(seconds: 10)));

  test('reusable이 true일때 defer는 재구독이 가능해야 한다.', () {
    // given
    var a = Stream.value(1);

    // when
    final stream = Rx.defer(
        () => Stream.fromFuture(
              Future.delayed(
                const Duration(seconds: 1),
                () => a,
              ),
            ),
        reusable: true);

    // then
    stream.listen(expectAsync1((actual) => expect(actual, a), count: 1));
    stream.listen(expectAsync1((actual) => expect(actual, a), count: 1));
  }, timeout: const Timeout(Duration(seconds: 10)));
}
