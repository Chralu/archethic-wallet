/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'settings_drawer.dart';

class SecurityMenuView extends ConsumerWidget {
  const SecurityMenuView({
    required this.close,
    super.key,
  });

  final VoidCallback close;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProviders.selectedTheme);
    final localizations = AppLocalization.of(context)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.drawerBackground,
        gradient: LinearGradient(
          colors: <Color>[
            theme.drawerBackground!,
            theme.backgroundDark!,
          ],
          begin: Alignment.center,
          end: const Alignment(5, 0),
        ),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.only(
          top: 60,
        ),
        child: Column(
          children: <Widget>[
            // Back button and Security Text
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //Back button
                      Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        child: BackButton(
                          key: const Key('back'),
                          color: theme.text,
                          onPressed: close,
                        ),
                      ),
                      //Security Header Text
                      Text(
                        localizations.securityHeader,
                        style: theme.textStyleSize24W700EquinoxPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  ListView(
                    padding: const EdgeInsets.only(top: 15),
                    children: <Widget>[
                      const _SettingsListItem.spacer(),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.text05,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsetsDirectional.only(
                            top: 15,
                            bottom: 15,
                          ),
                          child: Text(
                            localizations.preferences,
                            style: theme.textStyleSize20W700EquinoxPrimary,
                          ),
                        ),
                      ),
                      /* const _SettingsListItem.spacer(),
                    AppSettings.buildSettingsListItemWithDefaultValue(
                        context,
                        localizations.networksHeader,
                        _curNetworksSetting,
                        'assets/icons/url.png',
                        theme.iconDrawer!,
                        _networkDialog),*/
                      // Authentication Method
                      const _SettingsListItem.spacer(),
                      const _AuthMethodSettingsListItem(),
                      // Authenticate on Launch
                      const _SettingsListItem.spacer(),
                      const _LockSettingsListItem(),
                      // Authentication Timer
                      const _SettingsListItem.spacer(),
                      const _AutoLockSettingsListItem(),
                      const _SettingsListItem.spacer(),
                      const _BackupSecretPhraseListItem(),
                      const _PinPadShuffleSettingsListItem(),
                      const _SettingsListItem.spacer(),
                      _SettingsListItem.singleLineWithInfos(
                        heading: localizations.removeWallet,
                        info: localizations.removeWalletDescription,
                        headingStyle: theme.textStyleSize16W600EquinoxRed,
                        icon: 'assets/icons/menu/remove-wallet.svg',
                        iconColor: Colors.red,
                        onPressed: () {
                          final language =
                              ref.read(LanguageProviders.selectedLanguage);

                          AppDialogs.showConfirmDialog(
                              context,
                              ref,
                              CaseChange.toUpperCase(
                                localizations.warning,
                                language.getLocaleString(),
                              ),
                              localizations.removeWalletDetail,
                              localizations.removeWalletAction.toUpperCase(),
                              () {
                            // Show another confirm dialog
                            AppDialogs.showConfirmDialog(
                              context,
                              ref,
                              localizations.areYouSure,
                              localizations.removeWalletReassurance,
                              localizations.yes,
                              () async {
                                await StateContainer.of(context).logOut();
                                // TODO(Chralu): Déplacer la selection du theme par défaut dans le UseCase `logout`
                                await ref.read(
                                  ThemeProviders.selectTheme(
                                    theme: ThemeOptions.dark,
                                  ).future,
                                );
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/',
                                  (Route<dynamic> route) => false,
                                );
                              },
                            );
                          });
                        },
                      ),
                      const _SettingsListItem.spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthMethodSettingsListItem extends ConsumerWidget {
  const _AuthMethodSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);

    final authenticationMethod = ref.watch(
      preferenceProvider.select((settings) => settings.authenticationMethod),
    );
    final asyncHasBiometrics = ref.watch(DeviceAbilities.hasBiometricsProvider);

    return _SettingsListItem.withDefaultValue(
      heading: localizations.authMethod,
      defaultMethod: AuthenticationMethod(authenticationMethod),
      icon: 'assets/icons/menu/authent.svg',
      iconColor: theme.iconDrawer!,
      onPressed: asyncHasBiometrics.maybeWhen(
        data: (hasBiometrics) => () => AuthentificationMethodDialog.getDialog(
              context,
              ref,
              hasBiometrics,
              AuthenticationMethod(authenticationMethod),
            ),
        orElse: () => () {},
      ),
    );
  }
}

class _LockSettingsListItem extends ConsumerWidget {
  const _LockSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);

    final lock =
        ref.watch(preferenceProvider.select((settings) => settings.lock));
    final settingsNotifier = ref.read(preferenceProvider.notifier);

    return _SettingsListItem.withDefaultValue(
      heading: localizations.lockAppSetting,
      defaultMethod: UnlockSetting(lock),
      icon: 'assets/icons/menu/authent-at-launch.svg',
      iconColor: theme.iconDrawer!,
      onPressed: () async {
        final unlockSetting = await LockDialog.getDialog(
          context,
          ref,
          UnlockSetting(lock),
        );
        if (unlockSetting == null) return;
        await settingsNotifier.setLockApp(unlockSetting.setting);
      },
    );
  }
}

class _AutoLockSettingsListItem extends ConsumerWidget {
  const _AutoLockSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);

    final lock =
        ref.watch(preferenceProvider.select((settings) => settings.lock));
    final lockTimeout = ref
        .watch(preferenceProvider.select((settings) => settings.lockTimeout));
    final settingsNotifier = ref.read(preferenceProvider.notifier);

    return _SettingsListItem.withDefaultValue(
      heading: localizations.autoLockHeader,
      defaultMethod: LockTimeoutSetting(lockTimeout),
      icon: 'assets/icons/menu/auto-lock.svg',
      iconColor: theme.iconDrawer!,
      onPressed: () async {
        final lockTimeoutSetting = await LockTimeoutDialog.getDialog(
          context,
          ref,
          LockTimeoutSetting(lockTimeout),
        );
        if (lockTimeoutSetting == null) return;
        await settingsNotifier.setLockTimeout(lockTimeoutSetting.setting);
      },
      disabled: lock == UnlockOption.no,
    );
  }
}

class _PinPadShuffleSettingsListItem extends ConsumerWidget {
  const _PinPadShuffleSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);

    final pinPadShuffle = ref
        .watch(preferenceProvider.select((settings) => settings.pinPadShuffle));
    final authenticationMethod = ref.watch(
      preferenceProvider.select((settings) => settings.authenticationMethod),
    );
    final settingsNotifier = ref.read(preferenceProvider.notifier);

    if (authenticationMethod != AuthMethod.pin) return const SizedBox();
    return Column(
      children: [
        const _SettingsListItem.spacer(),
        _SettingsListItem.withSwitch(
          heading: localizations.pinPadShuffle,
          icon: 'assets/icons/menu/pin-swap.svg',
          iconColor: theme.iconDrawer!,
          isSwitched: pinPadShuffle,
          onChanged: (bool isSwitched) {
            settingsNotifier.setPinPadShuffle(isSwitched);
          },
        ),
      ],
    );
  }
}

class _BackupSecretPhraseListItem extends ConsumerWidget {
  const _BackupSecretPhraseListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);

    return _SettingsListItem.singleLine(
      heading: localizations.backupSecretPhrase,
      headingStyle: theme.textStyleSize16W600EquinoxPrimary,
      icon: 'assets/icons/menu/vault.svg',
      iconColor: theme.iconDrawer!,
      onPressed: () async {
        final preferences = ref.watch(preferenceProvider);

        final auth = await AuthFactory.authenticate(
          context,
          ref,
          AuthenticationMethod(preferences.authenticationMethod),
          activeVibrations: preferences.activeVibrations,
        );
        if (auth) {
          final seed = await StateContainer.of(context).getSeed();
          final mnemonic = AppMnemomics.seedToMnemonic(
            seed!,
            languageCode: preferences.languageSeed,
          );

          Sheets.showAppHeightNineSheet(
            context: context,
            ref: ref,
            widget: AppSeedBackupSheet(mnemonic),
          );
        }
      },
    );
  }
}
