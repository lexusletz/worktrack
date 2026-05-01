import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'updater_model.dart';
import 'updater_repository.dart';

final packageInfoProvider = Provider<PackageInfo>((ref) {
  throw UnimplementedError();
});

final updaterRepositoryProvider = Provider<UpdaterRepository>((ref) {
  return UpdaterRepository(ref.watch(packageInfoProvider));
});

class UpdaterNotifier extends Notifier<Updater> {
  final Logger logger = Logger('UpdaterNotifier');

  @override
  Updater build() {
    return const Updater(
      isNewerVersionAvailable: false,
      currentVersion: "",
      newVersion: "",
      downloadUrl: null,
    );
  }

  Future<void> checkForUpdates() async {
    final result = await ref.read(updaterRepositoryProvider).checkForUpdates();
    state = result;
  }

  Future<void> downloadAndInstallUpdate() async {
    // Only works on Android
    if (Platform.isAndroid) {
      final downloadUrl = state.downloadUrl;
      if (downloadUrl != null && downloadUrl.isNotEmpty) {
        await ref
            .read(updaterRepositoryProvider)
            .downloadNewVersion(downloadUrl: downloadUrl);
      }
    }
  }
}

final updaterProvider = NotifierProvider<UpdaterNotifier, Updater>(
  UpdaterNotifier.new,
);
