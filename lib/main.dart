import 'package:flutter/material.dart';
import 'package:instagrocers/Auth/Views/signin.dart';
import 'package:instagrocers/Cart/View/cart.dart';
import 'package:instagrocers/Home/Views/Home.dart';
import 'package:instagrocers/Orders/Views/orderhome.dart';
import 'package:instagrocers/Search/Views/search.dart';
import 'package:instagrocers/Stores/storedashboard.dart';



void main() {

 WidgetsFlutterBinding.ensureInitialized();
 //Stripe.publishableKey = 'pk_test_51OUdVOEsTmh0E2XGkvRprQeMwqkOIp8G5JOdiL7aom9QEdA9McbFNcXQEJlo85DZ2SKrC9Iox5iNphnBxf5JQywa00De8wERGy';
 runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SigninScreen()
    );
  }
}



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Storedashboard(),
     CartPage(),
     const Search(),
     OrderHome()
  
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,  // Active color
        unselectedItemColor: Colors.black, // Inactive color
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [

          BottomNavigationBarItem( 
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

           BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: 'Store',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Orders',
          ),
          

        ],
      ),
    );
  }
}
