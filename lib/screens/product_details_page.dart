import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qtec_flutter_task/constants/constants.dart';

import '../api/search_product_api.dart';
import '../models/search_product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  String productName,
      brandName,
      distributorName,
      productDescription,
      productImage;
  num buyingPrice, sellingPrice, profit;

  ProductDetailsPage({
    super.key,
    required this.sellingPrice,
    required this.profit,
    required this.productName,
    required this.brandName,
    required this.buyingPrice,
    required this.distributorName,
    required this.productDescription,
    required this.productImage,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final _productApi = SearchProductApi();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  final int _limit = 10;
  int _offset = 0;
  double h1TextSize = 20.0;
  double h2TextSize = 18.0;
  double h3TextSize = 14.0;
  double h4TextSize = 12.0;
  double productPriceSize = 14.0;
  Timer? _debounceTimer;
  final List<Results> _products = [];
  int _currentImageIndex = 0;
  String cartText = "এটি\nকিনুন";
  bool isIconVisible = false;
  bool isProductCountVisible = false;
  int quantity = 0;

  @override
  void initState() {
    print(widget.productDescription);
    print(widget.distributorName);
    print(widget.buyingPrice);
    print(widget.brandName);
    print(widget.profit);
    print(widget.sellingPrice);
    print(widget.productName);
    print(widget.productImage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadProducts();
      }
    });
    _loadInitialProducts();
    super.initState();
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

  // void _loadProducts() async {
  //   if (_isLoading || _isPaginationEnd) return;
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     final searchQuery = _searchController.text;
  //     if (searchQuery.isEmpty) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       return;
  //     }
  //     final products =
  //         await _productApi.searchProduct(searchQuery, _limit, _offset);
  //     setState(() {
  //       _products.addAll(products);
  //       _offset += _limit;
  //       _isLoading = false;
  //       if (products.length < _limit) {
  //         _isPaginationEnd = true;
  //       }
  //     });
  //   } catch (e) {
  //     print('Error loading products: $e');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
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
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xff323232),
            )),
        backgroundColor: Color(0xffF7F2FF),
        title: Text("প্রোডাক্ট ডিটেইল",
            style: TextStyle(color: Color(0xff323232))),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 15),
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
            CarouselSlider(
              items: _products.map((imageUrl) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: NetworkImage(widget.productImage),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 250.0,
                aspectRatio: 16 / 2,
                viewportFraction: 0.7,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    utf8.decode(
                      widget.productName.codeUnits,
                    ),
                    style: TextStyle(
                        fontSize: h1TextSize, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ব্রান্ডঃ",
                        style: TextStyle(
                          fontSize: h3TextSize,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.brandName,
                        style: TextStyle(
                            fontSize: h3TextSize, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 5,
                        width: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffDA2079),
                        ),
                      ),
                      Text(
                        "ডিস্ট্রিবিউটরঃ",
                        style: TextStyle(
                          fontSize: h3TextSize,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.distributorName,
                        style: TextStyle(
                            fontSize: h3TextSize, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                        padding: EdgeInsets.only(left: 12, right: 12),
                        height: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ক্রয়মূল্যঃ",
                                  style: TextStyle(
                                      fontSize: h2TextSize,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffDA2079)),
                                ),
                                Text("৳ ${widget.buyingPrice}",
                                    style: TextStyle(
                                        fontSize: h2TextSize,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xffDA2079))),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "বিক্রয়মূল্যঃ",
                                  style: TextStyle(
                                    fontSize: h3TextSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                Visibility(
                                  visible: isProductCountVisible,
                                  child: Container(
                                    height: 35,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffFFCCE4)
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffFFBFDD)
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.remove),
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                quantity>0 ? quantity--: quantity;
                                                quantity == 0 ? isProductCountVisible = false : true;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          "${quantity} পিস" ,
                                          style: TextStyle(
                                              color: Color(0xffDA2079), fontSize: 14),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff6210E1),
                                                Color(0xff1400AE)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.add),
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                quantity++;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text("৳ ${widget.sellingPrice}",
                                    style: TextStyle(
                                      fontSize: h3TextSize,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(),
                              child: Text(
                                "${Constants.dottedLine}",
                                maxLines: 1,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "লাভঃ",
                                  style: TextStyle(
                                    fontSize: h3TextSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text("৳ ${widget.profit}",
                                    style: TextStyle(
                                      fontSize: h3TextSize,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        height: 75,
                        width: 70,
                        left: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.width / 2.6
                            : MediaQuery.of(context).size.width / 2.3,
                        bottom: -43,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              cartText = "কার্ট";
                              isIconVisible = true;
                              isProductCountVisible= true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                image: AssetImage("images/polygon.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isIconVisible
                                    ? Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.white,
                                      )
                                    : Container(),
                                Text(
                                  cartText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "বিস্তারিত",
                          style: TextStyle(
                            fontSize: h3TextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Html(
                          data:
                              utf8.decode(widget.productDescription.codeUnits),
                          style: {
                            "html": Style(
                              fontSize: FontSize(10),
                              color: Colors.black54,
                              fontFamily: "Noto Sans, sans-serif",
                              letterSpacing: -0.3,
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
