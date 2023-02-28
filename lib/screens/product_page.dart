import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qtec_flutter_task/screens/product_details_page.dart';
import '../api/api_class.dart';
import '../models/search_product_model.dart';


class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _productApi = ApiClass();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  // bool _isPaginationEnd = false;
  final int _limit = 10;
  int _offset = 0;
  double h1TextSize = 14.0;
  double h2TextSize = 12.0;
  double h3TextSize = 11.0;
  double productPriceSize = 14.0;
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
      // _isPaginationEnd = false;
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
    if (_isLoading) return;
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
      backgroundColor: Color(0xffF7F2FF),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 15),
            //padding: EdgeInsets.only(left: 20, right: 10,top: 0,bottom: 0),
            decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: 'কাঙ্ক্ষিত পণ্যটি খুঁজুন',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 10.0),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  )),
              onChanged: _onSearchTextChanged,
            ),
          ),
          Expanded(
              child: _isLoading && _products.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _products.isEmpty
                  ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    "No Product Found",
                    style: TextStyle(fontSize: 24),
                  ))
                  : Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    if (index == _products.length) {
                      if (_isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                    final product = _products[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Card(
                          elevation: 5.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailsPage(
                                          brandName: product.brand.name,
                                          buyingPrice: product.charge
                                              .currentCharge,
                                          distributorName: product.seller,
                                          productDescription: product
                                              .description,
                                          productName: product.productName,
                                          profit: product.charge.profit,
                                          sellingPrice: product.charge
                                              .sellingPrice,
                                          productImage: product.image,
                                        ),

                                  ));
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                  EdgeInsets.only(top: 10.0),
                                  height: 130,
                                  child: Image.network(
                                    product.image,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      top: 8, left: 8, right: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        utf8.decode(
                                          product.productName
                                              .codeUnits,
                                        ),
                                        style: TextStyle(
                                            fontSize: h1TextSize,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                'ক্রয়',
                                                style: TextStyle(
                                                  fontSize:
                                                  h3TextSize,
                                                  color: Color(
                                                      0xff646464),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '৳${product.charge.currentCharge
                                                    .toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize:
                                                  h1TextSize,
                                                  color: Color(
                                                      0xffDA2079),
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '৳${product.charge.bookingPrice
                                                .toStringAsFixed(2)}',
                                            style: TextStyle(
                                              decoration:
                                              TextDecoration
                                                  .lineThrough,
                                              fontSize: h2TextSize,
                                              color:
                                              Color(0xffDA2079),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                'বিক্রয়',
                                                style: TextStyle(
                                                  fontSize:
                                                  h3TextSize,
                                                  color: Color(
                                                      0xff646464),
                                                ),
                                              ),
                                              Text(
                                                '৳${product.charge.sellingPrice
                                                    .toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize:
                                                  h2TextSize,
                                                  color: Color(
                                                      0xff646464),
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'লাভ',
                                                style: TextStyle(
                                                  fontSize:
                                                  h3TextSize,
                                                  color: Color(
                                                      0xff646464),
                                                ),
                                              ),
                                              Text(
                                                '৳${product.charge.profit
                                                    .toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize:
                                                  h2TextSize,
                                                  color: Color(
                                                      0xff646464),
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery
                              .of(context)
                              .orientation == Orientation.portrait ? MediaQuery
                              .of(context)
                              .size
                              .width / 5.1
                              : MediaQuery
                              .of(context)
                              .size
                              .width / 4.6,
                          bottom: -12,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ProductPage(),));
                            },
                            child: ClipOval(
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff6210E1), // first color
                                      Color(0xff1400AE), // second color
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                        )
                      ],
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}