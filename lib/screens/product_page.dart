import 'dart:async';

import 'package:flutter/material.dart';

import '../api/search_product_api.dart';
import '../models/search_product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _productApi = SearchProductApi();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isPaginationEnd = false;
  final int _limit = 10;
  int _offset = 10;
  bool _noResultsFound = false;
  bool _showNoProductFoundMessage = false;

  Timer? _debounceTimer;
  final List<Results> _products = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadProducts();
      }
    });
    _loadInitialProducts();
  }

  void _loadInitialProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final products = await _productApi.fetchProducts();
      setState(() {
        _products.addAll(products);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading initial products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _products.clear();
      _offset = 0;
      _isPaginationEnd = false;
    });
    if (text.isEmpty) {
      _loadInitialProducts();
    } else {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(Duration(milliseconds: 500), () {
        _loadProducts();
      });
    }
  }

  void _loadProducts() async {
    if (_isLoading || _isPaginationEnd) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final searchQuery = _searchController.text;
      if (searchQuery.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final products =
          await _productApi.searchProduct(searchQuery, _limit, _offset);
      setState(() {
        _products.addAll(products);
        _offset += _limit;
        _isLoading = false;
        if (products.length < _limit) {
          _isPaginationEnd = true;
        }
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Product")),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
              onChanged: _onSearchTextChanged,
            ),
          ),
          Expanded(
            child: _noResultsFound
                ? Center(child: Text('No results found'))
                : _isLoading && _products.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _products.length + 1,
                        itemBuilder: (context, index) {

                          if (index == _products.length) {
                            if (_isLoading || _isPaginationEnd) {
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  _showNoProductFoundMessage = true;
                                });
                              });
                              return Center(
                                child: _showNoProductFoundMessage
                                    ? Text("No product found")
                                    : CircularProgressIndicator(),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }

                          final product = _products[index];
                          return ListTile(
                            leading: Image.network(product.image),
                            title: Text(product.brand.slug),
                            subtitle: Text(product.id.toString()),
                            trailing:
                                Text(product.charge.bookingPrice.toString()),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
