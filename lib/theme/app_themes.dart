import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Themes for the app.
sealed class AppThemes {
  const AppThemes._();

  // static final _seedColor = ([...Colors.primaries]..shuffle()).first;
  static final _seedColor = (<MaterialColor>[
    Colors.red,
    Colors.pink,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.blueGrey,
  ]..shuffle())
      .first;

  static ThemeData _themeData({
    Brightness brightness = Brightness.light,
    Color? seedColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: seedColor ?? _seedColor,
    );
    //-- Define Theme Data.
    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        shape: const RoundedRectangleBorder(borderRadius: appBarBorderRadius),
        backgroundColor: colorScheme.inversePrimary.withOpacity(.75),
      ),
      // Badge Theme
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.primary.withOpacity(.375),
        textStyle: const TextStyle(fontWeight: FontWeight.w400),
      ),
      // DropdownMenu Theme
      // inputDecorationTheme: ,
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: const InputDecorationTheme(filled: true),
        menuStyle: MenuStyle(
          visualDensity: VisualDensity.compact,
          // alignment: Alignment.topRight,
          backgroundColor: MaterialStateProperty.all(
            Colors.black,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
        ),
      ),
    );

    return themeData.copyWith(
      textTheme: GoogleFonts.ubuntuTextTheme(themeData.textTheme),
      // Floating Action Bar
      floatingActionButtonTheme: themeData.floatingActionButtonTheme.copyWith(
        backgroundColor: themeData.appBarTheme.backgroundColor,
      ),
      //  SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            themeData.snackBarTheme.backgroundColor?.withOpacity(.25),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Public APIs
  // static double? get hintFontSize => theme.textTheme.titleMedium?.fontSize;

  static const height = 15.0;
  static const height2x = height * 2;
  static const height6x = height * 6;
  static const width = height;
  static const width2x = width * 2;

  static const radiusCircular = Radius.circular(15);
  static const appBarBorderRadius = BorderRadius.only(
    bottomLeft: radiusCircular,
    bottomRight: radiusCircular,
  );
  static const borderRadius = BorderRadius.all(radiusCircular);
  static const outlineInputBorder = OutlineInputBorder(
    borderRadius: borderRadius,
  );

  static ThemeData light({Color? seedColor}) =>
      _themeData(seedColor: seedColor);
  static ThemeData dark({Color? seedColor}) =>
      _themeData(brightness: Brightness.dark, seedColor: seedColor);
}
