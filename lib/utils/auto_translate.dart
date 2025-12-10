import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class AutoTranslate extends StatelessWidget {
  final Widget child;

  const AutoTranslate({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return _translateRecursive(child, settings);
  }
}

Widget _translateRecursive(Widget widget, SettingsProvider settings) {
  // ---------- Text ----------
  if (widget is Text) {
    return Text(
      settings.tr(widget.data ?? ''),
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }

  // ---------- RichText ----------
  if (widget is RichText) return widget;

  // ---------- Column ----------
  if (widget is Column) {
    return Column(
      key: widget.key,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: widget.children
          .map((c) => _translateRecursive(c, settings))
          .toList(),
    );
  }

  // ---------- Row ----------
  if (widget is Row) {
    return Row(
      key: widget.key,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: widget.children
          .map((c) => _translateRecursive(c, settings))
          .toList(),
    );
  }

  // ---------- ListView ----------
  if (widget is ListView &&
      widget.childrenDelegate is SliverChildListDelegate) {
    final delegate =
        widget.childrenDelegate as SliverChildListDelegate;

    return ListView(
      key: widget.key,
      padding: widget.padding,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      shrinkWrap: widget.shrinkWrap,
      children: delegate.children
          .map((c) => _translateRecursive(c, settings))
          .toList(),
    );
  }

  // ---------- Padding ----------
  if (widget is Padding) {
    return Padding(
      key: widget.key,
      padding: widget.padding,
      child: widget.child == null
          ? const SizedBox()
          : _translateRecursive(widget.child!, settings),
    );
  }

  // ---------- Container ----------
  if (widget is Container) {
    return Container(
      key: widget.key,
      padding: widget.padding,
      margin: widget.margin,
      decoration: widget.decoration,
      child: widget.child == null
          ? null
          : _translateRecursive(widget.child!, settings),
    );
  }

  // ---------- Center ----------
  if (widget is Center) {
    return Center(
      key: widget.key,
      child: widget.child == null
          ? null
          : _translateRecursive(widget.child!, settings),
    );
  }

  // ---------- SizedBox ----------
  if (widget is SizedBox) {
    return SizedBox(
      key: widget.key,
      width: widget.width,
      height: widget.height,
      child: widget.child == null
          ? null
          : _translateRecursive(widget.child!, settings),
    );
  }

  return widget;
}
