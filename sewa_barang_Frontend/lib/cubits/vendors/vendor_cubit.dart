import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VendorCubit extends Cubit<VendorState> {
  VendorCubit() : super(VendorInitial());

  Future<void> fetchVendor(int vendorId) async {
    emit(VendorLoading());
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/vendors/vendors/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(VendorLoaded(Vendor.fromJson(data)));
      } else {
        emit(VendorError('Failed to fetch vendor'));
      }
    } catch (e) {
      emit(VendorError('Failed to fetch vendor: $e'));
    }
  }
}

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object> get props => [];
}

class VendorInitial extends VendorState {}

class VendorLoading extends VendorState {}

class VendorLoaded extends VendorState {
  final Vendor vendor;

  const VendorLoaded(this.vendor);

  @override
  List<Object> get props => [vendor];
}

class VendorError extends VendorState {
  final String message;

  const VendorError(this.message);

  @override
  List<Object> get props => [message];
}

class Vendor {
  final int vendorId;
  final String vendorName;
  final String email;
  final DateTime createdAt;

  Vendor({
    required this.vendorId,
    required this.vendorName,
    required this.email,
    required this.createdAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendor_id'],
      vendorName: json['vendor_name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
