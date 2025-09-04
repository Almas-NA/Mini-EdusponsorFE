import 'package:edusponsor/config.dart';
import 'package:flutter/material.dart';


class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.title,
    this.tabBar,
    this.preferredSize = const Size.fromHeight(55.0),
    this.leading,
    this.actions,
    this.gradient,
    this.automaticallyImplyLeading = true,
    this.builder,
    this.primary = true,
  });

  final String? title;
  final List<Color>? gradient;
  final TabBar? tabBar;
  final Widget? leading;
  final Widget? builder;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final bool primary;
  @override
  final Size preferredSize;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = widget.actions ?? [];
    final List<Color> gradient = widget.gradient ??
        [
          primaryShade.shade800,
          primaryShade.shade400,
        ];
    final Widget? builder = widget.title == null
        ? widget.builder
        : Text(
            widget.title.toString(),
            style: const TextStyle(color: Colors.white),
          );
    return AppBar(
      primary: widget.primary,
      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leadingWidth:
          widget.leading == null && !widget.automaticallyImplyLeading ? 0 : 56,
      // titleSpacing: 0,
      title: builder,
      backgroundColor: primaryColor,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
      ),
      actions: actions,
      bottom: widget.tabBar,
    );
  }
}
