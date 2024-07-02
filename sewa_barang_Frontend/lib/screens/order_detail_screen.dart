import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Untuk formatting tanggal
import 'package:sewa_barang/cubits/order/order_cubit.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  OrderDetailScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..fetchOrderDetail(orderId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Detail'),
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order status updated successfully')),
              );
            } else if (state is OrderReturned) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order returned successfully')),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderDetailLoaded) {
              final order = state.orderDetail;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar barang
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: order['item_image'] != null
                          ? Image.network(
                              'http://127.0.0.1:8000/items/getimage/${order['item_image']}',
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported, size: 100),
                    ),
                    SizedBox(height: 16),
                    // Informasi detail pesanan
                    Text(
                      'Item: ${order['item_name']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Description: ${order['item_description']}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    Text('Total Price: Rp ${order['total_price']}',
                        style: TextStyle(fontSize: 16)),
                    Text('Status: ${order['status_name']}',
                        style: TextStyle(fontSize: 16)),
                    Text('Vendor: ${order['vendor_name']}',
                        style: TextStyle(fontSize: 16)),
                    Text(
                      'Order Date: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(order['order_date']))}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Return Date: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(order['return_date']))}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    // Tombol "Barang diterima" jika status pesanan adalah "Diproses"
                    if (order['status_name'] == 'Diproses')
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<OrderCubit>().updateOrderStatus(
                                  orderId, 3); // 3 adalah status "Disewakan"
                            },
                            child: Text('Barang diterima'),
                          ),
                        ),
                      ),
                    // Tombol "Kembalikan barang" jika status pesanan adalah "Disewakan"
                    if (order['status_name'] == 'Disewakan')
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<OrderCubit>().updateOrderStatus(
                                  orderId, 4); // 4 adalah status "Dikembalikan"
                            },
                            child: Text('Kembalikan barang'),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is OrderError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No order details found'));
            }
          },
        ),
      ),
    );
  }
}
