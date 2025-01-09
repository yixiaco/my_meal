import 'package:flutter/material.dart';

class CreateCookbook0 extends StatefulWidget {
  const CreateCookbook0({super.key});

  @override
  State<CreateCookbook0> createState() => _CreateCookbook0State();
}

class _CreateCookbook0State extends State<CreateCookbook0> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: const Center(
        child: Text('CreateCookbook0'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
