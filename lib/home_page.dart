import 'package:flutter/material.dart';
import 'package:crud_products/services/api_service.dart';
import 'login_page.dart';
import 'product_detail_page.dart';
import 'add_product_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;
  bool _isLoading = false;
  List _products = [];
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    final response =
        await ApiService().get('products?page=$_currentPage', withToken: true);
    setState(() {
      _isLoading = false;
      _products = response['data'];
      _totalPages = response['last_page'];
    });
  }

  Future<void> _logout() async {
    await ApiService().delete('auth/logout', withToken: true);
    await ApiService().removeToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: IDR ${product['price']}'),
                            Text('Stock: ${product['stock']}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(productId: product['id']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentPage > 1
                            ? () {
                                setState(() {
                                  _currentPage--;
                                  _fetchProducts();
                                });
                              }
                            : null,
                        child: Text('Previous'),
                      ),
                      Text('Page $_currentPage of $_totalPages'),
                      ElevatedButton(
                        onPressed: _currentPage < _totalPages
                            ? () {
                                setState(() {
                                  _currentPage++;
                                  _fetchProducts();
                                });
                              }
                            : null,
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
