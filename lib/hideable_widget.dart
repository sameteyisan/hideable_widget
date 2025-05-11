library hideable_widget;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///Hideable Widget package helps to make any static widget hideable while scrolling.
///
////// To Use:
/// Wrap your static widget with [HideableWidget],
///
/// Then, your Scrollable widget should then be given the same scroll controller as given for [HideableWidget].
/// It could, [ListView], [SingleChildScrollView], [GridView] etc.
///

class HideableWidget extends StatefulWidget {
  const HideableWidget({
    super.key,
    required this.child,
    required this.scrollController,
    this.useOpacity = true,
    this.duration = const Duration(milliseconds: 200),
    this.opacityDuration,
  });

  /// This is the static widget you want to hide while scrolling.
  final Widget child;

  /// It should be the same as the scroll controller supplied with your scrollable widget.
  final ScrollController scrollController;

  /// Used to turn the opacity animation on and off. It is on by default.
  final bool useOpacity;

  /// Use this to set the hiding time.
  final Duration duration;

  /// Use this to set the opacity duration that runs during the hiding period.
  final Duration? opacityDuration;

  @override
  State<HideableWidget> createState() => _HideableWidgetState();
}

class _HideableWidgetState extends State<HideableWidget> {
  GlobalKey key = GlobalKey();

  double height = 0;

  bool hide = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());

    widget.scrollController.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listener);
    widget.scrollController.dispose();
    super.dispose();
  }

  void getSizeAndPosition() {
    RenderBox? object = key.currentContext?.findRenderObject() as RenderBox;
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        height = object.size.height;
      });
    });
  }

  void listener() {
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        hide = true;
      });
    } else {
      setState(() {
        hide = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: hide,
      child: AnimatedOpacity(
        duration: widget.opacityDuration ?? widget.duration,
        opacity: widget.useOpacity ? (hide ? 0 : 1) : 1,
        child: AnimatedContainer(
          duration: widget.duration,
          height: hide ? 0 : (height == 0 ? null : height),
          key: key,
          child: widget.child,
        ),
      ),
    );
  }
}
