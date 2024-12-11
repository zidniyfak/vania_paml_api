import 'dart:math';

import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/customer.dart';

class CustomerControllers extends Controller {
  Future<String> _generateCustomerId() async {
    var lastCust = await Customer().query().orderBy('cust_id', 'desc').first();

    int lastId = 0;
    if (lastCust != null) {
      // Mengambil angka setelah 'C' dan mengonversinya ke integer
      String lastIdStr = lastCust['cust_id'].toString().substring(1);
      lastId = int.parse(
          lastIdStr); // Pastikan lastId diupdate dengan nilai yang benar
    }

    int newId = lastId + 1;

    // Membuat ID baru dengan format 'C0001', 'C0002', dll.
    String newIdStr = 'C${newId.toString().padLeft(4, '0')}';

    return newIdStr;
  }

  Future<Response> index() async {
    try {
      var customers = await Customer().query().get();
      return Response.json(customers);
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var custName = request.input('cust_name');
      var custAddress = request.input('cust_address');
      var custCity = request.input('cust_city');
      var custState = request.input('cust_state');
      var custZip = request.input('cust_zip');
      var custCountry = request.input('cust_country');
      var custTelp = request.input('cust_telp');

      var custId = await _generateCustomerId();

      await Customer().query().insert({
        'cust_id': custId,
        'cust_name': custName,
        'cust_address': custAddress,
        'cust_city': custCity,
        'cust_state': custState,
        'cust_zip': custZip,
        'cust_country': custCountry,
        'cust_telp': custTelp,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      });

      return Response.json({
        'success': true,
        'message': 'Data berhasil disimpan',
        'code': 200,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      var custName = request.input('cust_name');
      var custAddress = request.input('cust_address');
      var custCity = request.input('cust_city');
      var custState = request.input('cust_state');
      var custZip = request.input('cust_zip');
      var custCountry = request.input('cust_country');
      var custTelp = request.input('cust_telp');

      await Customer().query().where('id', '=', id).update({
        'cust_name': custName,
        'cust_address': custAddress,
        'cust_city': custCity,
        'cust_state': custState,
        'cust_zip': custZip,
        'cust_country': custCountry,
        'cust_telp': custTelp,
        'updated_at': DateTime.now(),
      });
      return Response.json({
        'success': true,
        'message': 'Data berhasil diupdate',
        'code': 200,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }

  Future<Response> destroy(int id) async {
    try {
      await Customer().query().where('id', '=', id).delete();
      return Response.json({
        'success': true,
        'message': 'Data berhasil dihapus',
        'code': 200,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }
}

final CustomerControllers customerController = CustomerControllers();
