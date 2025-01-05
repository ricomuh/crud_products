import 'package:crud_products/product_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:crud_products/services/api_service.dart';
import 'home_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isLoading = false;
  Map<String, dynamic>? _product;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
    });

    final response =
        await ApiService().get('products/${widget.productId}', withToken: true);
    setState(() {
      _isLoading = false;
      _product = response;
    });
  }

  Future<void> _deleteProduct() async {
    await ApiService().delete('products/${widget.productId}', withToken: true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _product == null
              ? Center(child: Text('Product not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${_product!['name']}',
                          style: TextStyle(fontSize: 20)),
                      SizedBox(height: 8),
                      Text('Description: ${_product!['description']}'),
                      SizedBox(height: 8),
                      Text('Price: IDR ${_product!['price']}'),
                      SizedBox(height: 8),
                      Text('Stock: ${_product!['stock']}'),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductPage(
                                    productId: widget.productId,
                                    product: _product!,
                                  ),
                                ),
                              );
                            },
                            child: Text('Edit'),
                          ),
                          ElevatedButton(
                            onPressed: _deleteProduct,
                            child: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
