import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'viewmodel/acrcloud_vm.dart';
import 'viewmodel/theme_vm.dart';

final homeVM = ChangeNotifierProvider((_) => ACRCloudViewModel());
final themeVVM = ChangeNotifierProvider((_) => ThemeProvider());
