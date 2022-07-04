import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_steps_counter/theme/custom_colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: CustomColors.orange,
        onPrimary: CustomColors.darkBlue,
        secondary: CustomColors.gray,
        onSecondary: CustomColors.softBlue,
        error: Colors.red,
        onError: CustomColors.darkBlue,
        background: CustomColors.fadeGray,
        onBackground: CustomColors.darkBlue,
        surface: CustomColors.gray,
        onSurface: CustomColors.darkBlue,
      ),
      // scaffoldBackgroundColor: CustomColors.fadeGray,
      fontFamily: 'Lato',
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        color: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: CustomColors.darkBlue,
        ),
      ),
      iconTheme: const IconThemeData(
        color: CustomColors.orange,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        buttonColor: CustomColors.gray,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: CustomColors.fadeGray,
          onPrimary: CustomColors.gray,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  // TODO(hafiz): Create a dark theme
  // static ThemeData get darkTheme {}
}
