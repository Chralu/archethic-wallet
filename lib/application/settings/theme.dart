import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/available_themes.dart';
import 'package:aewallet/ui/themes/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@Riverpod(keepAlive: true)
BaseTheme _selectedTheme(Ref ref) => ThemeSetting(
      ref.watch(
        SettingsProviders.settings.select((settings) => settings.theme),
      ),
    ).getTheme();

abstract class ThemeProviders {
  static final selectedTheme = _selectedThemeProvider;
}
