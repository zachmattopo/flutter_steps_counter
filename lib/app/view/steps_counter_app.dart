// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_steps_counter/app/view/text_scale_factor_clamper.dart';
import 'package:flutter_steps_counter/feature_step_counter/view/step_counter_page.dart';
import 'package:flutter_steps_counter/l10n/l10n.dart';
import 'package:flutter_steps_counter/theme/custom_theme.dart';

class StepsCounterApp extends StatelessWidget {
  const StepsCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Counter App',
      theme: CustomTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TextScaleFactorClamper(
        child: StepCounterPage(),
      ),
    );
  }
}
