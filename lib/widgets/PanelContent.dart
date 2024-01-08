import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../main.dart';

class PanelContent extends StatefulWidget {
  final PanelController panelController;
  final ScrollController scrollController;
  final Future<List<String>> Function() getSelectedMallets;

  const PanelContent({
    Key? key,
    required this.panelController,
    required this.scrollController,
    required this.getSelectedMallets,
  }) : super(key: key);

  @override
  _PanelContentState createState() => _PanelContentState();
}

class _PanelContentState extends State<PanelContent> {
  @override
  Widget build(BuildContext context) {
    bool isPanelFullyOpen = widget.panelController.panelPosition == 1.0;

    return FutureBuilder<List<String>>(
      future: widget.getSelectedMallets(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            controller: widget.scrollController,
            physics: CustomScrollPhysics(isScrollable: isPanelFullyOpen),
            padding: const EdgeInsets.only(top: 20, bottom: 25, left: 25, right: 25),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  snapshot.data![index],
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              );
            },
          );
        } else {
          return Container(); // Return an empty container when no data is available
        }
      },
    );
  }
}


class CustomScrollPhysics extends ScrollPhysics {
  final bool isScrollable;

  const CustomScrollPhysics({required this.isScrollable, ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(isScrollable: isScrollable, parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return isScrollable;
  }
}
