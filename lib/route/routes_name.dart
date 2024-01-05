import 'package:flutter/material.dart';
import 'package:responsiveapp/main.dart';
import 'package:responsiveapp/signature_screen.dart';

class RoutesName {
  // ignore: non_constant_identifier_names
  static const String homePage = '/home';
  // ignore: non_constant_identifier_names
  static const String signaturePage = '/sign';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homePage:
        return _GeneratePageRoute(
            widget: MyHomePage(), routeName: settings.name!);
      case RoutesName.signaturePage:
        return _GeneratePageRoute(
            widget: const SignatureScreen(), routeName: settings.name!);
      default:
        return _GeneratePageRoute(
            widget: MyHomePage(), routeName: settings.name!);
    }
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget? widget;
  final String? routeName;
  _GeneratePageRoute({this.widget, this.routeName})
      : super(
      settings: RouteSettings(name: routeName),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget!;
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        return SlideTransition(
          textDirection: TextDirection.rtl,
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      });
}


