// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import '../api/search_product_api.dart';
// import '../models/search_product_model.dart';
// class CustomSearchBar extends StatefulWidget {
//   const CustomSearchBar({Key? key}) : super(key: key);
//
//   @override
//   State<CustomSearchBar> createState() => _CustomSearchBarState();
// }
//
// class _CustomSearchBarState extends State<CustomSearchBar> {
//
//   final _productApi = SearchProductApi();
//   final _searchController = TextEditingController();
//   final _scrollController = ScrollController();
//   bool _isLoading = false;
//
//   // bool _isPaginationEnd = false;
//   final int _limit = 10;
//   int _offset = 0;
//   final bool _noResultsFound = false;
//   bool _showNoProductFoundMessage = false;
//   double h1TextSize = 14.0;
//   double h2TextSize = 12.0;
//   double h3TextSize = 11.0;
//   double productPriceSize = 14.0;
//   Timer? _debounceTimer;
//   final List<Results> _products = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _loadProducts();
//       }
//     });
//     _loadInitialProducts();
//   }
//
//   void _loadInitialProducts() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final products = await _productApi.fetchProducts();
//       setState(() {
//         _products.addAll(products);
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading initial products: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _onSearchTextChanged(String text) {
//     setState(() {
//       _products.clear();
//       _offset = 0;
//       // _isPaginationEnd = false;
//     });
//     if (text.isEmpty) {
//       _loadInitialProducts();
//     } else {
//       _debounceTimer?.cancel();
//       _debounceTimer = Timer(Duration(milliseconds: 500), () {
//         _loadProducts();
//       });
//     }
//   }
//
//   // void _loadProducts() async {
//   //   if (_isLoading || _isPaginationEnd) return;
//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   try {
//   //     final searchQuery = _searchController.text;
//   //     if (searchQuery.isEmpty) {
//   //       setState(() {
//   //         _isLoading = false;
//   //       });
//   //       return;
//   //     }
//   //     final products =
//   //         await _productApi.searchProduct(searchQuery, _limit, _offset);
//   //     setState(() {
//   //       _products.addAll(products);
//   //       _offset += _limit;
//   //       _isLoading = false;
//   //       if (products.length < _limit) {
//   //         _isPaginationEnd = true;
//   //       }
//   //     });
//   //   } catch (e) {
//   //     print('Error loading products: $e');
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }
//   void _loadProducts() async {
//     if (_isLoading) return;
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final searchQuery = _searchController.text;
//       if (searchQuery.isEmpty) {
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }
//       final products =
//       await _productApi.searchProduct(searchQuery, _limit, _offset);
//       setState(() {
//         _products.addAll(products);
//         _offset += _limit;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading products: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 15),
//       //padding: EdgeInsets.only(left: 20, right: 10,top: 0,bottom: 0),
//       decoration: BoxDecoration(
//           color: Color(0xffFFFFFF),
//           borderRadius: BorderRadius.all(
//             Radius.circular(10),
//           )),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//             hintText: 'কাঙ্ক্ষিত পণ্যটি খুঁজুন',
//             contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 10.0),
//             border: InputBorder.none,
//             suffixIcon: Icon(
//               Icons.search,
//               color: Colors.grey,
//             )),
//         onChanged: _onSearchTextChanged,
//       ),
//     );
//   }
// }
