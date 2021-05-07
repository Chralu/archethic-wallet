// @dart=2.9

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uniris_mobile_wallet/appstate_container.dart';
import 'package:uniris_mobile_wallet/app_icons.dart';
import 'package:uniris_mobile_wallet/dimens.dart';
import 'package:uniris_mobile_wallet/localization.dart';
import 'package:uniris_mobile_wallet/styles.dart';
import 'package:uniris_mobile_wallet/ui/widgets/buttons.dart';

class IntroBackupSafetyPage extends StatefulWidget {
  @override
  _IntroBackupSafetyState createState() => _IntroBackupSafetyState();
}

class _IntroBackupSafetyState extends State<IntroBackupSafetyPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              StateContainer.of(context).curTheme.backgroundDark,
              StateContainer.of(context).curTheme.background
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => SafeArea(
            minimum: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.035,
                top: MediaQuery.of(context).size.height * 0.075),
            child: Column(
              children: <Widget>[
                //A widget that holds the header, the paragraph, the seed, "seed copied" text and the back button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          // Back Button
                          Container(
                            margin: EdgeInsetsDirectional.only(
                                start: smallScreen(context) ? 15 : 20),
                            height: 50,
                            width: 50,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(AppIcons.back,
                                    color: StateContainer.of(context)
                                        .curTheme
                                        .text,
                                    size: 24)),
                          ),
                        ],
                      ),
                      // Safety icon
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: smallScreen(context) ? 30 : 40,
                          top: 15,
                        ),
                        child: Icon(
                          AppIcons.security,
                          size: 60,
                          color: StateContainer.of(context).curTheme.primary,
                        ),
                      ),
                      // The header
                      Container(
                        margin: EdgeInsetsDirectional.only(
                          start: smallScreen(context) ? 30 : 40,
                          end: smallScreen(context) ? 30 : 40,
                          top: 10,
                        ),
                        alignment: AlignmentDirectional(-1, 0),
                        child: AutoSizeText(
                          AppLocalization.of(context).secretInfoHeader,
                          style: AppStyles.textStyleHeaderColored(context),
                          stepGranularity: 0.1,
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                      // The paragraph
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: smallScreen(context) ? 30 : 40,
                            end: smallScreen(context) ? 30 : 40,
                            top: 15.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            AutoSizeText(
                              AppLocalization.of(context).secretInfo,
                              style: AppStyles.textStyleParagraph(context),
                              maxLines: 5,
                              stepGranularity: 0.5,
                            ),
                            Container(
                              margin: EdgeInsetsDirectional.only(top: 15),
                              child: AutoSizeText(
                                AppLocalization.of(context).secretWarning,
                                style: AppStyles.textStyleParagraphPrimary(
                                    context),
                                maxLines: 4,
                                stepGranularity: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Next Screen Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppButton.buildAppButton(
                        context,
                        AppButtonType.PRIMARY,
                        AppLocalization.of(context).gotItButton,
                        Dimens.BUTTON_BOTTOM_DIMENS, onPressed: () {
                      Navigator.of(context).pushNamed('/intro_backup',
                          arguments:
                              StateContainer.of(context).encryptedSecret);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
