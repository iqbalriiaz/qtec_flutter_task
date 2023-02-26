import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/constants.dart';
import '../models/search_product_model.dart';

class SearchProductApi {
  Future<List<Results>> fetchProducts() async {
    final response = await http.get(Uri.parse(Constants.baseURL));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final searchProductList = <Results>[];

      for (final i in data["data"]["products"]["results"]) {
        final datum = Results.fromJson(i);
        searchProductList.add(datum);
      }

      return searchProductList;
    } else {
      throw "Something went wrong, status code: ${response.statusCode}";
    }
  }

  Future<List<Results>> searchProduct(String query, int limit, int offset) async {
    final response = await http.get(Uri.parse('${Constants.baseURL}limit=$limit&offset=$offset&search=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final searchProductsList = <Results>[];

      for (final i in data["data"]["products"]["results"]) {
        final datum = Results.fromJson(i);
        searchProductsList.add(datum);
      }

      return searchProductsList;
    } else {
      throw "Something went wrong, status code: ${response.statusCode}";
    }
  }
}
