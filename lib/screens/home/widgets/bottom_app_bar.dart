import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geople/widgets/meatball_menu_main.dart';

class GeopleBottomAppBar extends StatefulWidget {
  final List<GeopleBottomAppBarItem> items;
  final ValueChanged<int> onTabSelected;
  final double iconSize;
  final Color selectedTabColor;

  GeopleBottomAppBar({
    this.items,
    this.onTabSelected,
    this.iconSize: 24.0,
    this.selectedTabColor,
  });

  @override
  State<StatefulWidget> createState() => GeopleBottomAppBarState();
}

class GeopleBottomAppBarState extends State<GeopleBottomAppBar> {
  int _selectedIndex = 0;

  void updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabItem({
    GeopleBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color =
        _selectedIndex == index ? widget.selectedTabColor : Colors.black54;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () => onPressed(index),
            icon: Icon(item.iconData, color: color, size: widget.iconSize),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: updateIndex,
      );
    });

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: MeatballMenuMain(
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}

class GeopleBottomAppBarItem {
  GeopleBottomAppBarItem({this.iconData, this.text});

  final IconData iconData;
  final String text;
}
