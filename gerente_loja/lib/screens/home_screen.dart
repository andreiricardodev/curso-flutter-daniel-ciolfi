import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerente_loja/blocs/order_bloc.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/tabs/orders_tab.dart';
import 'package:gerente_loja/tabs/products_tab.dart';
import 'package:gerente_loja/tabs/users_tab.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _userBloc = UserBloc();
    _orderBloc = OrderBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white54),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (value) {
            _pageController.animateToPage(
              value,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Clientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Produtos',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrderBloc>(
            bloc: _orderBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _page = value;
                });
              },
              children: [
                UsersTab(),
                OrdersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 1:
        return SpeedDial(
          child: Icon(
            Icons.sort,
          ),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.arrow_downward,
                color: Colors.pinkAccent,
              ),
              backgroundColor: Colors.white,
              label: 'Concluídos Abaixo',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _orderBloc.setOrderCriteria(SortCriteria.READY_LAST);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.arrow_upward,
                color: Colors.pinkAccent,
              ),
              backgroundColor: Colors.white,
              label: 'Concluídos Acima',
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _orderBloc.setOrderCriteria(SortCriteria.READY_FIRST);
              },
            ),
          ],
        );
        break;
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => EditCategoryDialog(),
          ),
        );
        break;
    }
    return null;
  }
}