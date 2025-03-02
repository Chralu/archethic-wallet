/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/settings/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardCategory extends ConsumerWidget {
  const CardCategory({super.key, required this.background});

  final Widget background;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProviders.selectedTheme);

    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      color: theme.backgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.white10,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: background,
      ),
    );
  }
}
