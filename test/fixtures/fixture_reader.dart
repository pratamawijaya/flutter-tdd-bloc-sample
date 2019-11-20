import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

// https://stackoverflow.com/a/58461307
String testPath(String relativePath) {
  Directory current = Directory.current;
  String path =
      current.path.endsWith('/test') ? current.path : current.path + '/test';

  return path + '/' + relativePath;
}
