import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'dart:isolate';

int fib(int n) {
  if (n == 0) return 0;
  if (n == 1) return 1;
  return fib(n - 1) + fib(n - 2);
}

void isolateHandler(SendPort event) {
  final receivePort = ReceivePort();
  event.send(receivePort.sendPort);

  receivePort.listen((Object? message) {
    print('message from MainIsolate:$message');
    if (message is int) {
      event.send(fib(message));
    }
  });
}

void main() async {
  //Пример работы с изолятом
  final receivePort = ReceivePort();
  final isolate =
      await Isolate.spawn<SendPort>(isolateHandler, receivePort.sendPort);

  final comleter = Completer<SendPort>();

  receivePort.listen((Object? message) {
    if (message is SendPort) comleter.complete(message);
    if (message is int) print('fibonacci: $message');
  });

  final isolateSendPort = await comleter.future;
  isolateSendPort.send('hello this is MainIsolate');
  isolateSendPort.send(10);
  isolate.kill();

//Бинарная сортировка( все время берем среднее)
  int binarSort(List list, int item) {
    var low = 0;
    var hight = list.length - 1;

    while (low <= hight) {
      final int mid = (low + hight) ~/ 2;
      final guess = list[mid];

      if (guess == item) {
        return mid;
      }
      if (guess > item) {
        hight = mid - 1;
      } else {
        low = mid + 1;
      }
    }
    return -1;
  }

  final myList = [1, 3, 5, 7, 9, 11, 13];
  // print(binarSort(myList, 11));
  // print(binarSort(myList, -22));

//Поиск самого маленькго числа в массиве
  int Smallest(arr) {
    int smallest = arr[0];
    int smallest_index = 0;
    for (int i = 1; i <= arr.length - 1; i++) {
      if (arr[i] < smallest) {
        smallest = arr[i];
        smallest_index = i;
      }
    }
    return smallest_index;
  }

  List<int> selectionSotr(List<int> arr) {
    final List<int> newArr = [];

    for (int i = 0; arr.length > 0; i++) {
      int smallest = Smallest(arr);
      newArr.add(arr[smallest]);
      arr.removeAt(smallest);
    }
    return newArr;
  }

  final List<int> listKek = [5, 3, 10, 6, 2, 4];
  // print(selectionSotr(listKek));

//Рекурсия
  int coundown(i) {
    if (i == 1) {
      return 1;
    } else {
      return i * coundown(i - 1);
    }
  }

  // print(listKek.removeAt(0));
  // print(listKek);

//Рекурсия
  int sum(List<int> list) {
    if (list.length == 1) {
      return list[0];
    } else {
      final int firstElement = list.removeAt(0);
      return firstElement + sum(list);
    }
  }

  final List<int> listEample = [2, 4, 6];
  // print(sum(listEample));

//Рекурсия на поиска большего числа в списке
  int find_max(List<int> list, int max_) {
    final int current = list.removeLast();

    if (current > max_) {
      max_ = current;
    }
    if (list.length != 0) {
      return find_max(list, max_);
    }
    return max_;
  }

  final List<int> listMax = [22, 28, 7, 3, 10];

  // print(find_max(listMax, 0));

//Графы, поиск в ширину

  bool persinIsSeller(String name) {
    return name.substring(name.length - 1) == "j";
  }

  bool search(String name, Map<String, List<String?>> graph) {
    final searchQueue = Queue();
    graph[name]?.forEach((e) => searchQueue.add(e));
    // searchQueue.add(graph[name]);
    final List<String> searched = [];
    while (searchQueue.isNotEmpty) {
      final String person = searchQueue.removeFirst();
      if (!searched.contains(person)) {
        if (persinIsSeller(person)) {
          print("$person is a seller!");
          return true;
        } else {
          graph[person]?.forEach((e) => searchQueue.add(e));
          // searchQueue.add(graph[[person]]);
          searched.add(person);
        }
      }
    }
    return false;
  }

  Map<String, List<String?>> graph = {
    "you": ["alice", "bob", "claiere"],
    "bob": ["anuj", "peggy"],
    "alice": ["peggy"],
    "claiere": ["thom", "jonny"],
    "anuj": [],
    "peggy": [],
    "thom": [],
    "jonny": [],
  };
  search("you", graph);
}
