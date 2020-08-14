import 'package:flutter/material.dart';
import '../ui/view/Ciudad.dart';

class TabBottomNavigation extends StatefulWidget {
  _TabState createState() => _TabState();
}

class _TabState extends State<TabBottomNavigation> with SingleTickerProviderStateMixin{
  
  TabController _controller;
  ///
  ///inicializar el tab
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  ///
  ///para limpiar el tab 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab Navigator'),
      ),
      body: getTabBarView(<Widget>[
        Ciudad(),
        Ciudad(),
      ]),
      bottomNavigationBar: getTabBar(),

    );
  }

  Material getTabBar() {
    return Material (
      child: TabBar(
        tabs: <Tab>[
          Tab(icon: Icon(Icons.directions_car),),
          Tab(icon: Icon(Icons.directions_transit),),
        ],
        controller: _controller,
      ),
      color: Colors.blue,
    );
  }

  TabBarView getTabBarView(var displays) {
    return TabBarView(
      children: displays,
      controller: _controller,
    );
  }
}