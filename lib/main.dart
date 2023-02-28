import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtec_flutter_task/screens/product_page.dart';
import 'api/api_class.dart';
import 'cubit/search_product_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiClass hotDealProductApi = ApiClass();

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
}