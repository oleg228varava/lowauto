import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class AutoTranslate extends StatelessWidget {
  final Widget child;
  const AutoTranslate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return _t(child, settings);
  }
}

Widget _t(Widget w, SettingsProvider s) {
  // ---------- TEXT ----------
  if (w is Text && w.data != null) {
    return Text(
      s.tr(w.data!),
      key: w.key,
      style: w.style,
      textAlign: w.textAlign,
      maxLines: w.maxLines,
      overflow: w.overflow,
    );
  }

  // ---------- APPBAR ----------
  if (w is AppBar) {
    return AppBar(
      key: w.key,
      title: w.title == null ? null : _t(w.title!, s),
      actions: w.actions,
      backgroundColor: w.backgroundColor,
      elevation: w.elevation,
      leading: w.leading,
    );
  }

  // ---------- LIST TILE ----------
  if (w is ListTile) {
    return ListTile(
      key: w.key,
      leading: w.leading,
      title: w.title == null ? null : _t(w.title!, s),
      subtitle: w.subtitle == null ? null : _t(w.subtitle!, s),
      trailing: w.trailing,
      onTap: w.onTap,
    );
  }

  // ---------- BUTTONS ----------
  if (w is ElevatedButton) {
    return ElevatedButton(
      key: w.key,
      onPressed: w.onPressed,
      style: w.style,
      child: _t(w.child!, s),
    );
  }

  if (w is TextButton) {
    return TextButton(
      key: w.key,
      onPressed: w.onPressed,
      child: _t(w.child!, s),
    );
  }

  if (w is OutlinedButton) {
    return OutlinedButton(
      key: w.key,
      onPressed: w.onPressed,
      child: _t(w.child!, s),
    );
  }

  // ---------- COLUMN / ROW ----------
  if (w is Column) {
    return Column(
      key: w.key,
      mainAxisAlignment: w.mainAxisAlignment,
      crossAxisAlignment: w.crossAxisAlignment,
      children: w.children.map((c) => _t(c, s)).toList(),
    );
  }

  if (w is Row) {
    return Row(
      key: w.key,
      mainAxisAlignment: w.mainAxisAlignment,
      crossAxisAlignment: w.crossAxisAlignment,
      children: w.children.map((c) => _t(c, s)).toList(),
    );
  }

  // ---------- PADDING ----------
  if (w is Padding && w.child != null) {
    return Padding(
      key: w.key,
      padding: w.padding,
      child: _t(w.child!, s),
    );
  }

  // ---------- CENTER ----------
  if (w is Center && w.child != null) {
    return Center(key: w.key, child: _t(w.child!, s));
  }

  // ---------- SCAFFOLD ----------
  if (w is Scaffold) {
    return Scaffold(
      key: w.key,
      appBar: w.appBar == null ? null : _t(w.appBar!, s) as PreferredSizeWidget,
      body: w.body == null ? null : _t(w.body!, s),
      drawer: w.drawer,
      bottomNavigationBar: w.bottomNavigationBar,
      backgroundColor: w.backgroundColor,
    );
  }

  return w;
}
