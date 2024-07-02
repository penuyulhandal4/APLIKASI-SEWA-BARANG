import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  Future<void> createOrder(int itemId, double totalPrice, int days) async {
    emit(OrderLoading());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id_user');
    print("ini user id ${userId.toString()}");

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/orders/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'item_id': itemId,
          'status_id': 2,
          'order_date': DateTime.now().toIso8601String(),
          'return_date':
              DateTime.now().add(Duration(days: days)).toIso8601String(),
          'total_price': totalPrice,
        }),
      );

      if (response.statusCode == 200) {
        emit(OrderSuccess());
      } else {
        emit(OrderError('Failed to create order'));
      }
    } catch (e) {
      emit(OrderError('Failed to create order: $e'));
    }
  }

  Future<void> fetchUserOrders() async {
    emit(OrderLoading());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id_user');

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/orders/user/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body);

        for (var order in orders) {
          // Fetch Order Status
          final statusResponse = await http.get(
            Uri.parse(
                'http://127.0.0.1:8000/order_status/${order['status_id']}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          if (statusResponse.statusCode == 200) {
            final statusData = jsonDecode(statusResponse.body)['data'];
            order['status_name'] = statusData['status_name'];
          } else {
            print('Failed to fetch status for order: ${order['order_id']}');
            order['status_name'] = 'Unknown';
          }

          // Fetch Item Details
          final itemResponse = await http.get(
            Uri.parse('http://127.0.0.1:8000/items/${order['item_id']}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );

          if (itemResponse.statusCode == 200) {
            final itemData = jsonDecode(itemResponse.body);
            order['item_image'] =
                itemData != null ? itemData['image_url'] : null;
            order['item_name'] =
                itemData != null ? itemData['item_name'] : 'Unknown';
          } else {
            print('Failed to fetch item for order: ${order['order_id']}');
            order['item_image'] = null;
            order['item_name'] = 'Unknown';
          }
        }

        emit(OrdersLoaded(orders));
      } else {
        emit(OrderError('Failed to fetch orders: ${response.body}'));
      }
    } catch (e) {
      emit(OrderError('Failed to fetch orders: $e'));
    }
  }

  Future<void> fetchOrderDetail(int orderId) async {
    emit(OrderLoading());

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final orderDetail = jsonDecode(response.body);

        // Fetch Order Status
        final statusResponse = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/order_status/${orderDetail['status_id']}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (statusResponse.statusCode == 200) {
          final statusData = jsonDecode(statusResponse.body)['data'];
          orderDetail['status_name'] = statusData['status_name'];
        } else {
          orderDetail['status_name'] = 'Unknown';
        }

        // Fetch Item Details
        final itemResponse = await http.get(
          Uri.parse('http://127.0.0.1:8000/items/${orderDetail['item_id']}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (itemResponse.statusCode == 200) {
          final itemData = jsonDecode(itemResponse.body);
          orderDetail['item_image'] =
              itemData != null ? itemData['image_url'] : null;
          orderDetail['item_name'] =
              itemData != null ? itemData['item_name'] : 'Unknown';
          orderDetail['item_description'] =
              itemData != null ? itemData['description'] : 'No description';
          orderDetail['vendor_id'] =
              itemData != null ? itemData['vendor_id'] : 'No description';
        } else {
          orderDetail['item_image'] = null;
          orderDetail['item_name'] = 'Unknown';
          orderDetail['item_description'] = 'No description';
        }

        // Fetch Vendor Details (if needed)
        final vendorResponse = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/vendors/vendors/${orderDetail['vendor_id']}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (vendorResponse.statusCode == 200) {
          final vendorData = jsonDecode(vendorResponse.body);
          orderDetail['vendor_name'] =
              vendorData != null ? vendorData['vendor_name'] : 'Unknown';
        } else {
          orderDetail['vendor_name'] = 'Unknown';
        }

        emit(OrderDetailLoaded(orderDetail));
      } else {
        emit(OrderError('Failed to fetch order detail: ${response.body}'));
      }
    } catch (e) {
      emit(OrderError('Failed to fetch order detail: $e'));
    }
  }

  Future<void> updateOrderStatus(int orderId, int statusId) async {
    emit(OrderLoading());

    try {
      final response = await http.patch(
        Uri.parse(
            'http://127.0.0.1:8000/orders/$orderId/status?status_id=$statusId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        emit(OrderStatusUpdated());
        // Fetch order details again to refresh the UI
        await fetchOrderDetail(orderId);
      } else {
        emit(OrderError('Failed to update order status'));
      }
    } catch (e) {
      emit(OrderError('Failed to update order status: $e'));
    }
  }
}

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderStatusUpdated extends OrderState {}

class OrderReturned extends OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<dynamic> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderDetailLoaded extends OrderState {
  final Map<String, dynamic> orderDetail;

  const OrderDetailLoaded(this.orderDetail);

  @override
  List<Object> get props => [orderDetail];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
