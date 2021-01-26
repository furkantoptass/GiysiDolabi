import 'package:flutter/material.dart';

class SilinmeyenFuturuBuilder extends StatefulWidget {
  final Future future;
  final AsyncWidgetBuilder builder;

  const SilinmeyenFuturuBuilder({Key key, this.future, this.builder})
      : super(key: key);
  @override
  _SilinmeyenFuturuBuilderState createState() =>
      _SilinmeyenFuturuBuilderState();
}

class _SilinmeyenFuturuBuilderState extends State<SilinmeyenFuturuBuilder>
    with AutomaticKeepAliveClientMixin<SilinmeyenFuturuBuilder> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: widget.future,
      builder: widget.builder,
    );
  }
}
