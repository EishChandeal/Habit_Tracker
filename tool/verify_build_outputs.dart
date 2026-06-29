// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final filesToCheck = [
    'lib/objectbox.g.dart',
    'lib/objectbox-model.json',
  ];

  var allExist = true;

  print('=== Verifying ObjectBox Build Runner Outputs ===');
  for (final filePath in filesToCheck) {
    final file = File(filePath);
    if (file.existsSync()) {
      final size = file.lengthSync();
      print('✓ $filePath exists ($size bytes)');
      if (size == 0) {
        print('  ⚠ Warning: $filePath is empty!');
        allExist = false;
      }
    } else {
      print('✗ $filePath DOES NOT exist!');
      allExist = false;
    }
  }

  if (allExist) {
    print('================================================');
    print('✓ Verification successful! All files exist and are valid.');
    exit(0);
  } else {
    print('================================================');
    print('✗ Verification failed! One or more files are missing or empty.');
    exit(1);
  }
}
