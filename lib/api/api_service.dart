import 'package:Filmify/api/api.dart';
import 'package:Filmify/models/movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Filmify/models/review.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  // static Future<List<Movie>?> getCustomMovies(String url) async {
  //   List<Movie> movies = [];
  //   int page = 1;
  //   while (true) {
  //     try {
  //       http.Response response =
  //           await http.get(Uri.parse('${Api.baseUrl}movie/$url&page=$page'));
  //       var res = jsonDecode(response.body);
  //       List<Movie> pageMovies = [];
  //       res['results'].forEach(
  //         (m) => pageMovies.add(
  //           Movie.fromMap(m),
  //         ),
  //       );
  //       if (pageMovies.isEmpty) {
  //         break; // No more movies, exit the loop
  //       }
  //       movies.addAll(pageMovies);
  //       page++;
  //     } catch (e) {
  //       return null;
  //     }
  //   }
  //   return movies;
  // }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }
}
