import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_steps_counter/feature_daily_goal/bloc/daily_goal_bloc.dart';
import 'package:flutter_steps_counter/feature_step_counter/counter.dart';
import 'package:flutter_steps_counter/l10n/l10n.dart';
import 'package:flutter_steps_counter/theme/custom_colors.dart';
import 'package:gap/gap.dart';

class DailyGoalPage extends StatefulWidget {
  const DailyGoalPage({super.key});

  @override
  State<DailyGoalPage> createState() => _DailyGoalPageState();
}

class _DailyGoalPageState extends State<DailyGoalPage> {
  bool _showTextFieldError = false;
  int? _goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      // Hide soft keyboard when tapping outside of textfield
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    l10n.dailyGoalExplanation,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const Gap(16),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorText:
                          _showTextFieldError ? l10n.dailyGoalErrorText : null,
                    ),
                    onChanged: (text) {
                      _goal = int.tryParse(text);

                      setState(() {
                        _showTextFieldError = _goal == null;
                      });
                    },
                  ),
                  const Gap(16),
                  BlocProvider<DailyGoalBloc>(
                    create: (context) => DailyGoalBloc(
                      stepCounterBloc:
                          BlocProvider.of<StepCounterBloc>(context),
                    ),
                    child: _DoneButton(goal: _goal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({required this.goal});

  final int? goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      child: Text(
        l10n.confirmText,
        style: Theme.of(context).textTheme.caption?.copyWith(
              fontWeight: FontWeight.bold,
              color: CustomColors.gray,
            ),
      ),
      onPressed: () {
        if (goal != null) {
          // Call bloc event for setting goal
          BlocProvider.of<DailyGoalBloc>(context).add(
            DailyGoalSet(goal: goal!),
          );

          Navigator.pop(context);
        }
      },
    );
  }
}
