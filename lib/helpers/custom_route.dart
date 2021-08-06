import 'package:flutter/material.dart';

/// Example of how to change page navigation animation to FadeIn (in this case).

/// This class is intended to use with single routes on the created fly, like Navigator.pushReplacement()
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // if (settings.isInitialRoute) {
    // }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
    // return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}

/// This class is to be used for general theme, which affects all routes transitions.
/// It is used in MaterialApp -> theme -> (inside of ThemeData) pageTransitionsTheme ->  
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // if (route.settings.isInitialRoute) {
    // }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
    // return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}