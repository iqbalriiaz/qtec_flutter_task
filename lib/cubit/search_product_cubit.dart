import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/search_product_api.dart';
import '../models/search_product_model.dart';

class ProductSearchCubit extends Cubit<List<Results>> {
  final SearchProductApi _api;
  String _searchQuery = '';


  ProductSearchCubit(this._api) : super([]);

  void setSearchQuery(String query) {
    _searchQuery = query;
    emit([]);
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    if (_searchQuery.isNotEmpty) {
      try {
        final results = await _api.fetchProducts();
        final filteredResults = results.where((product) =>
            product.productName.toLowerCase().contains(_searchQuery.toLowerCase()));
        emit(filteredResults.toList());
      } catch (e) {
        emit([]);
        print('Error fetching products: $e');
      }
    } else {
      emit([]);
    }
  }
}
