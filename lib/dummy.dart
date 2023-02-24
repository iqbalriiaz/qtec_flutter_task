import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool showButtons = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showButtons = !showButtons;
                  print("button clicked");
                });
              },
              child: Container(
                height: 200,
                width: 200,
                color: Colors.grey,
                child: Center(
                  child: Text(
                    'Product Image',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: showButtons ? 80 : 0,
              width: showButtons ? 200 : 0,
              curve: Curves.easeInOut,
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(child: Text('1')),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
