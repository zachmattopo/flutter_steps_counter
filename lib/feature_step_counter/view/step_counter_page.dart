// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_steps_counter/feature_daily_goal/view/daily_goal_page.dart';
import 'package:flutter_steps_counter/feature_step_counter/counter.dart';
import 'package:flutter_steps_counter/l10n/l10n.dart';
import 'package:flutter_steps_counter/services/repository.dart';
import 'package:flutter_steps_counter/theme/custom_colors.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounterPage extends StatelessWidget {
  const StepCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepCounterBloc>(
      create: (_) => StepCounterBloc(repository: Repository.get())
        ..add(const StepCounterDataFetched()),
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
              // TODO(hafiz): Handle goal notification turned on and off

              // Show confirmation
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
    final l10n = context.l10n;

    return Center(
      child: BlocBuilder<StepCounterBloc, StepCounterState>(
        builder: (context, state) {
          if (state is StepCounterFetchSuccess) {
            final _stepsFraction = state.totalSteps / state.dailyGoalSteps;
            final _stepsPercent = (_stepsFraction * 100).toStringAsFixed(0);

            return CircularPercentIndicator(
              radius: 110,
              lineWidth: 12,
              animation: true,
              animationDuration: 1000,
              curve: Curves.easeOutCubic,
              // Set to 1.0 if fraction is >1
              percent: _stepsFraction > 1.0 ? 1.0 : _stepsFraction,
              center: Text(
                '$_stepsPercent%',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: CustomColors.darkBlue,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: CustomColors.orange,
              backgroundColor: CustomColors.fadeGray,
            );
          }

          if (state is StepCounterFetchFailure) {
            return Column(
              children: [
                Text(
                  state.errorMessage,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Gap(16),
                ElevatedButton(
                  onPressed: openAppSettings,
                  child: Text(
                    l10n.openAppSettingsText,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.gray,
                        ),
                  ),
                ),
              ],
            );
          }

          // State is either `StepCounterFetchInProgress`
          // or `StepCounterInitial`
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class _StepsCaloriesCountRow extends StatelessWidget {
  const _StepsCaloriesCountRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        if (state is StepCounterFetchSuccess) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MiniCounter(
                  iconAddress: 'assets/images/steps.png',
                  countNumber: '${state.totalSteps} / ${state.dailyGoalSteps}',
                  countName: l10n.stepsText,
                ),
                _MiniCounter(
                  iconAddress: 'assets/images/flame.png',
                  countNumber: '${state.totalCalories}',
                  countName: l10n.caloriesText,
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
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
    final stepCounterBloc = BlocProvider.of<StepCounterBloc>(context);

    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        if (state is StepCounterFetchSuccess) {
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
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: stepCounterBloc,
                    child: const DailyGoalPage(),
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _LinearGoalProgress extends StatelessWidget {
  const _LinearGoalProgress();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        if (state is StepCounterFetchSuccess) {
          final _stepsFraction = state.totalSteps / state.dailyGoalSteps;

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
                  // Set to 1.0 if fraction is >1
                  percent: _stepsFraction > 1.0 ? 1.0 : _stepsFraction,
                  barRadius: const Radius.circular(16),
                  progressColor: CustomColors.orange,
                  backgroundColor: CustomColors.fadeGray,
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
