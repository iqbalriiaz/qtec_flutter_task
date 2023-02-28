//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import '../models/details_product_model.dart';
//
// part 'details_product_state.dart';
//
// class ProductDetailsCubit extends Cubit<List<Data>> {
//   ProductDetailsCubit() : super(ProductDetailsInitial() as List<Data>);
//
//   Future<void> getProductDetails(String slug) async {
//     try {
//       emit(ProductDetailsLoading() as List<Data>);
//       final response = await http.get(Uri.parse('https://panel.supplyline.network/api/product-details/$slug/'));
//       if (response.statusCode == 200) {
//         emit(ProductDetailsLoaded(response.body) as List<Data>);
//       } else {
//         emit(ProductDetailsError('Failed to load product details') as List<Data>);
//       }
//     } catch (e) {
//       emit(ProductDetailsError('Failed to load product details') as List<Data>);
//     }
//   }
// }


//============================= will work on this later ======================