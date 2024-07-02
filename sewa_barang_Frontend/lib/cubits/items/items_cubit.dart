import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  Future<void> fetchItems({String? searchQuery}) async {
    emit(ItemsLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/items/?search=${searchQuery ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Item> items = data.map((item) => Item.fromJson(item)).toList();
        emit(ItemsLoaded(items));
      } else {
        emit(ItemsError('Failed to fetch items'));
      }
    } catch (e) {
      emit(ItemsError('An error occurred'));
    }
  }
}

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<Item> items;

  const ItemsLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ItemsError extends ItemsState {
  final String error;

  const ItemsError(this.error);

  @override
  List<Object> get props => [error];
}

class Item {
  final int itemId;
  final int vendorId;
  final String itemName;
  final String description;
  final String pricePerDay;
  final String imageUrl;
  final DateTime createdAt;

  Item({
    required this.itemId,
    required this.vendorId,
    required this.itemName,
    required this.description,
    required this.pricePerDay,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      vendorId: json['vendor_id'],
      itemName: json['item_name'],
      description: json['description'],
      pricePerDay: json['price_per_day'],
      imageUrl: 'http://127.0.0.1:8000/items/getimage/${json['image_url']}',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
