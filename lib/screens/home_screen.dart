import 'package:Filmify/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Filmify/api/api.dart';
import 'package:Filmify/api/api_service.dart';
import 'package:Filmify/controllers/bottom_navigator_controllers.dart';
import 'package:Filmify/controllers/movie_controller.dart';
import 'package:Filmify/controllers/search_controller.dart';
import 'package:Filmify/widgets/search_box.dart';
import 'package:Filmify/widgets/tab_builder_box.dart';
import 'package:Filmify/widgets/top_rated_items.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final MoviesController controller = Get.put(MoviesController());
  final SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF0296E5),
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF242A32),
            title: Text(
              'Welcome to Filmify!',
              style: GoogleFonts.sacramento(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0296E5),
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Logout',
                color: const Color(0xFF67686D),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF242A32),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.grey),
                      ),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            FirebaseAuth.instance.signOut();
                            await GoogleSignIn().disconnect();
                            Get.offAll(LoginPage());
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What do you want to watch?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SearchBox(
                onSumbit: () {
                  String search =
                      Get.find<SearchController>().searchController.text;
                  Get.find<SearchController>().searchController.text = '';
                  Get.find<SearchController>().search(search);
                  Get.find<BottomNavigatorController>().setIndex(1);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const SizedBox(
                height: 34,
              ),
              Obx(
                (() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        height: 290,
                        child: ListView.separated(
                          itemCount: controller.mainTopRatedMovies.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 24),
                          itemBuilder: (_, index) => TopRatedItem(
                              movie: controller.mainTopRatedMovies[index],
                              index: index + 1),
                        ),
                      )),
              ),
              DefaultTabController(
                length: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TabBar(
                        indicatorWeight: 4,
                        indicatorColor: Color(
                          0xFF3A3F47,
                        ),
                        tabs: [
                          Tab(text: 'Now playing'),
                          Tab(text: 'Upcoming'),
                          Tab(text: 'Top rated'),
                          Tab(text: 'Popular'),
                        ]),
                    SizedBox(
                      height: 430,
                      child: TabBarView(children: [
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'now_playing?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'upcoming?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'top_rated?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'popular?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
