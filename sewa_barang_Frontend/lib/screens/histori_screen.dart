import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewa_barang/cubits/order/order_cubit.dart';
import 'order_detail_screen.dart'; // Import Halaman Detail Order

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..fetchUserOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return Center(child: Text('No orders found'));
              }
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return Card(
                    margin: EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: order['item_image'] != null
                          ? Image.network(
                              'http://127.0.0.1:8000/items/getimage/${order['item_image']}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported),
                      title: Text(order['item_name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Price: Rp ${order['total_price']}'),
                          Text('Status: ${order['status_name']}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailScreen(orderId: order['order_id']),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is OrderError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No orders found'));
            }
          },
        ),
      ),
    );
  }
}
