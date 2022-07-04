// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_steps_counter/counter/counter.dart';
import 'package:flutter_steps_counter/l10n/l10n.dart';
import 'package:flutter_steps_counter/theme/custom_colors.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StepCounterPage extends StatelessWidget {
  const StepCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // TODO(hafiz): Make this dynamic
    const _isNotificationOn = true;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 28,
          padding: const EdgeInsets.all(12),
          onPressed: () {},
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 28,
            padding: const EdgeInsets.all(12),
            icon: const Icon(
              _isNotificationOn
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isNotificationOn
                        ? l10n.notificationOff
                        : l10n.notificationOn,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const CounterBody(),
    );
  }
}

class CounterBody extends StatelessWidget {
  const CounterBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.stepCounterAppBarTitle,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Gap(80),
              const _CircularGoalProgress(),
              const _StepsCaloriesCountRow(),
              const _DailyGoalButton(),
              const Gap(32),
              const _LinearGoalProgress(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularGoalProgress extends StatelessWidget {
  const _CircularGoalProgress();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 110,
        lineWidth: 12,
        animation: true,
        animationDuration: 1000,
        curve: Curves.easeOutCubic,
        // TODO(hafiz): Make this dynamic
        percent: 0.7,
        center: Text(
          // TODO(hafiz): Make this dynamic
          '70%',
          style: Theme.of(context).textTheme.headline2?.copyWith(
                color: CustomColors.darkBlue,
                fontWeight: FontWeight.w800,
              ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: CustomColors.orange,
        backgroundColor: CustomColors.fadeGray,
      ),
    );
  }
}

class _StepsCaloriesCountRow extends StatelessWidget {
  const _StepsCaloriesCountRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MiniCounter(
            iconAddress: 'assets/images/steps.png',
            // TODO(hafiz): Make this dynamic
            countNumber: '1557 / 30000',
            countName: l10n.stepsText,
          ),
          _MiniCounter(
            iconAddress: 'assets/images/flame.png',
            // TODO(hafiz): Make this dynamic
            countNumber: '340',
            countName: l10n.caloriesText,
          ),
        ],
      ),
    );
  }
}

class _MiniCounter extends StatelessWidget {
  const _MiniCounter({
    required this.iconAddress,
    required this.countNumber,
    required this.countName,
  });

  final String iconAddress;
  final String countNumber;
  final String countName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ImageIcon(
          AssetImage(iconAddress),
          size: 24,
        ),
        const Gap(8),
        Text(
          countNumber,
          style: textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(4),
        Text(
          countName,
          style: textTheme.caption,
        ),
      ],
    );
  }
}

class _DailyGoalButton extends StatelessWidget {
  const _DailyGoalButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.edit_outlined),
            const Gap(8),
            Text(
              l10n.dailyGoalText,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.gray,
                  ),
            ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }
}

class _LinearGoalProgress extends StatelessWidget {
  const _LinearGoalProgress();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Icon(
          Icons.sports_score,
          color: CustomColors.darkBlue,
        ),
        Center(
          child: LinearPercentIndicator(
            lineHeight: 8,
            animation: true,
            animationDuration: 1000,
            curve: Curves.easeOutCubic,
            // TODO(hafiz): Make this dynamic
            percent: 0.7,
            barRadius: const Radius.circular(16),
            progressColor: CustomColors.orange,
            backgroundColor: CustomColors.fadeGray,
          ),
        ),
      ],
    );
  }
}
