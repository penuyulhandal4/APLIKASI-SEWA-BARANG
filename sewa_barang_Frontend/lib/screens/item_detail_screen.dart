import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewa_barang/cubits/vendors/vendor_cubit.dart';
import 'package:sewa_barang/cubits/order/order_cubit.dart';
import 'package:sewa_barang/cubits/items/items_cubit.dart';
import 'package:sewa_barang/screens/payment_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VendorCubit()..fetchVendor(item.vendorId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(item.itemName),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  item.itemName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Rp ${item.pricePerDay}/hari',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                SizedBox(height: 20),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                BlocBuilder<VendorCubit, VendorState>(
                  builder: (context, state) {
                    if (state is VendorLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is VendorLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vendor: ${state.vendor.vendorName}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Email: ${state.vendor.email}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    } else if (state is VendorError) {
                      return Center(child: Text(state.message));
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => OrderCubit(),
                            child: PaymentScreen(
                              itemId: item.itemId,
                              pricePerDay: double.parse(item.pricePerDay),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('Sewa'),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
