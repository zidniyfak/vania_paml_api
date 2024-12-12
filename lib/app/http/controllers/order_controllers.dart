import 'dart:math';

import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/order.dart';
import 'package:vania_paml_api/app/models/orderitem.dart';
import 'package:vania_paml_api/app/models/product.dart';

class OrderControllers extends Controller {
  Future<int> _generateOrderNum() async {
    var rng = Random();
    return int.parse(List.generate(11, (_) => rng.nextInt(10)).join());
  }

  Future<int> _generateOrderItem() async {
    var rng = Random();
    return int.parse(List.generate(11, (_) => rng.nextInt(10)).join());
  }

  Future<Response> index() async {
    // try {
    //   var orders = await Order().query().get();
    //   return Response.json(orders);
    // } catch (e) {
    //   return Response.json({'message': e.toString()});
    // }
    try {
      var orders = await Order()
          .query()
          .select([
            'orders.*',
            'customers.cust_name',
            'customers.cust_address',
          ])
          .join('customers', 'customers.cust_id', '=', 'orders.cust_id')
          .get();

      // Map orders untuk menambahkan data order items
      var detailedOrders = await Future.wait(orders.map((order) async {
        var orderItems = await Orderitem()
            .query()
            .select([
              'orderitems.*',
              'products.prod_name',
              'products.prod_price',
            ])
            .join('products', 'products.prod_id', '=', 'orderitems.prod_id')
            .where('orderitems.order_num', '=', order['order_num'])
            .get();

        return {
          'order_num': order['order_num'],
          'order_date': order['order_date'],
          'cust_id': order['cust_id'],
          'cust_name': order['cust_name'],
          'cust_address': order['cust_address'],
          'created_at': order['created_at'],
          'updated_at': order['updated_at'],
          'order_items': orderItems.map((item) {
            return {
              'order_item_num': item['order_item'],
              'prod_id': item['prod_id'],
              'prod_name': item['prod_name'],
              'prod_price': item['prod_price'],
              'quantity': item['quantity'],
              'size': item['size'],
              'created_at': item['created_at'],
              'updated_at': item['updated_at'],
            };
          }).toList(),
        };
      }).toList());

      return Response.json(detailedOrders);
    } catch (e) {
      return Response.json({'success': false, 'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      int orderNum = await _generateOrderNum();
      var orderDate = request.input('order_date');
      var customerId = request.input('cust_id');
      var orderItems = request.input('order_items') as List;

      // Get order items from request and validate if not empty
      if (orderItems.isEmpty) {
        return Response.json({
          'success': false,
          'message': 'Order item kosong',
        });
      }

      await Order().query().insert({
        'order_num': orderNum,
        'order_date': orderDate,
        'cust_id': customerId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Initialize list to store processed order items
      List<Map<String, dynamic>> savedOrderItems = [];

      // Process each item in the order
      for (var item in orderItems) {
        if (item is Map) {
          // Extract item details
          var prodId = item['prod_id'];
          var quantity = item['quantity'];
          var size = item['size'];

          // Validate item fields are not null
          if (prodId == null || quantity == null || size == null) {
            return Response.json({
              'success': false,
              'message': 'Order  item tidak valid',
            });
          }

          // Check if product exists in database
          var isProductExist =
              await Product().query().where('prod_id', '=', prodId).first();

          if (isProductExist == null) {
            return Response.json({
              'success': false,
              'message': 'Produk tidak ditemukan',
            });
          }

          // Generate unique order item number
          int orderItemNum = await _generateOrderItem();
          var orderItemData = {
            'order_item': orderItemNum,
            'order_num': orderNum,
            'prod_id': prodId,
            'quantity': quantity,
            'size': size,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          // Insert order item into database
          await Orderitem().query().insert(orderItemData);

          // Add processed item to saved items list
          savedOrderItems.add(orderItemData);
        }
      }

      // Return success response with order details
      return Response.json({
        'success': true,
        'message': 'Order berhasil dibuat',
        'data': {
          'order':
              await Order().query().where('order_num', '=', orderNum).first(),
          'order_items': savedOrderItems,
        }
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Gagal membuat order',
        'error': e.toString()
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
    return Response.json({});
  }

  Future<Response> destroy(int orderNum) async {
    try {
      await Orderitem().query().where('order_num', '=', orderNum).delete();

      await Order().query().where('order_num', '=', orderNum).delete();

      return Response.json({
        'success': true,
        'message': 'Order berhasil dihapus',
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus order',
        'error': e.toString()
      });
    }
  }
}

final OrderControllers orderController = OrderControllers();
