import 'package:get/get.dart';
import 'package:Filmify/screens/home_screen.dart';
import 'package:Filmify/screens/search_screen.dart';
import 'package:Filmify/screens/watch_list_screen.dart';

class BottomNavigatorController extends GetxController {
  var screens = [
    HomeScreen(),
    const SearchScreen(),
    WatchList(),
  ];
  var index = 0.obs;
  void setIndex(indx) => index.value = indx;
}
