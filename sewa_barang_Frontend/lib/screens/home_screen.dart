import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewa_barang/cubits/items/items_cubit.dart';
import 'package:sewa_barang/screens/login_screen.dart';
import 'package:sewa_barang/screens/item_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsCubit()..fetchItems(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String query = _searchController.text;
                      BlocProvider.of<ItemsCubit>(context)
                          .fetchItems(searchQuery: query);
                    },
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ItemsCubit, ItemsState>(
                  builder: (context, state) {
                    if (state is ItemsLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ItemsLoaded) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ItemDetailScreen(item: item),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    item.itemName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Rp ${item.pricePerDay}/hari',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ItemsError) {
                      return Center(child: Text(state.error));
                    } else {
                      return Center(child: Text('No items found'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
