import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewa_barang/cubits/order/order_cubit.dart';

class PaymentScreen extends StatefulWidget {
  final int itemId;
  final double pricePerDay;

  PaymentScreen({required this.itemId, required this.pricePerDay});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _daysController =
      TextEditingController(text: '1');
  String _selectedPaymentMethod = 'Bank Transfer';
  final List<String> _paymentMethods = [
    'Bank Transfer',
    'E-Wallet',
    'Credit Card'
  ];

  // Map to store bank account information for each method
  final Map<String, String> _paymentInfo = {
    'Bank Transfer': 'Bank BCA\n1234567890\nAccount Name: Budi Didudi',
    'E-Wallet': 'e-Wallet: ShopepayPay\nMobile Number: 08123456789',
    'Credit Card': 'Credit Card: XXXX-XXXX-XXXX-1234\nExpiry Date: 12/24'
  };

  double getTotalPrice() {
    int days = int.tryParse(_daysController.text) ?? 1;
    return days * widget.pricePerDay;
  }

  int getDay() {
    int days = int.tryParse(_daysController.text) ?? 1;
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of days',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {}); // Update total price when days change
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: _paymentMethods.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            SizedBox(height: 20),
            if (_selectedPaymentMethod.isNotEmpty &&
                _paymentInfo.containsKey(_selectedPaymentMethod))
              Text(
                _paymentInfo[_selectedPaymentMethod]!,
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price:'),
                Text('Rp ${getTotalPrice()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    )),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<OrderCubit>(context)
                      .createOrder(widget.itemId, getTotalPrice(), getDay());
                },
                child: Text('Pay'),
              ),
            ),
            BlocListener<OrderCubit, OrderState>(
              listener: (context, state) {
                if (state is OrderSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order created successfully')));
                  Navigator.pop(
                      context); // Navigate back to the item detail screen
                } else if (state is OrderError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
