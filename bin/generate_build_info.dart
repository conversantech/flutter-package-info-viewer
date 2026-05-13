// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';

void main() async {
  print('🚀 Generating build-info.json...');

  String commitHash = '';
  String branch = '';
  String author = '';

  try {
    commitHash = (await Process.run('git', ['rev-parse', 'HEAD']))
        .stdout
        .toString()
        .trim();
    branch = (await Process.run('git', ['rev-parse', '--abbrev-ref', 'HEAD']))
        .stdout
        .toString()
        .trim();
    author = (await Process.run('git', ['log', '-1', '--pretty=format:%an']))
        .stdout
        .toString()
        .trim();
  } catch (e) {
    print('⚠️ Git not found or not a git repository. Skipping git info.');
  }

  Map<String, dynamic> dependencies = {};
  Map<String, dynamic> devDependencies = {};

  try {
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      final pubspecContent = await pubspecFile.readAsString();
      final pubspecYaml = loadYaml(pubspecContent);

      if (pubspecYaml['dependencies'] != null) {
        dependencies = _yamlToMap(pubspecYaml.nodes['dependencies']);
      }
      if (pubspecYaml['dev_dependencies'] != null) {
        devDependencies = _yamlToMap(pubspecYaml.nodes['dev_dependencies']);
      }
    }
  } catch (e) {
    print('⚠️ Error parsing pubspec.yaml: $e');
  }

  final buildInfo = {
    'commitHash': commitHash,
    'branch': branch,
    'author': author,
    'buildDate': DateTime.now().toString().split('.')[0],
    'dependencies': dependencies,
    'devDependencies': devDependencies,
  };

  final file = File('assets/build-info.json');
  if (!await file.parent.exists()) {
    await file.parent.create(recursive: true);
  }

  await file.writeAsString(jsonEncode(buildInfo));
  print('✅ Generated assets/build-info.json');
  print(
      '📢 Make sure to add "assets/build-info.json" to your pubspec.yaml assets section!');
}

Map<String, dynamic> _yamlToMap(YamlNode? node) {
  if (node == null || node is! YamlMap) return {};
  final Map<String, dynamic> result = {};
  node.forEach((key, value) {
    final keyStr = key.toString();
    if (value is YamlMap) {
      result[keyStr] = _yamlToMap(value);
    } else if (value is YamlList) {
      result[keyStr] = value.map((e) => e.toString()).toList();
    } else {
      result[keyStr] = value.toString();
    }
  });
  return result;
}
