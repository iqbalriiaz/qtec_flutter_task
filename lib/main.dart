import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtec_flutter_task/screens/product_details_page.dart';
import 'package:qtec_flutter_task/screens/product_page.dart';
import 'api/search_product_api.dart';
import 'cubit/search_product_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SearchProductApi hotDealProductApi = SearchProductApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qtec Task',
      home: BlocProvider<ProductSearchCubit>(
        create: (context) => ProductSearchCubit(hotDealProductApi),
        child: ProductPage(),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Your App Name Here',
  //     home: ProductPage(),
  //   );
  // }
}
