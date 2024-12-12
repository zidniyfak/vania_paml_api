import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/product.dart';

class ProductControllers extends Controller {
  Future<String> _generateProductId() async {
    var lastProd = await Product().query().orderBy('prod_id', 'desc').first();

    int lastId = 0;
    if (lastProd != null) {
      // Mengambil angka setelah 'P' dan mengonversinya ke integer
      String lastProdId = lastProd['prod_id'].toString();

      // Ekstraksi angka dari string
      RegExp regex = RegExp(r'\d+');
      Match? match = regex.firstMatch(lastProdId);

      if (match != null) {
        lastId = int.parse(match.group(0)!);
      } else {
        throw FormatException(
            'Tidak dapat mengonversi angka dari string $lastProdId');
      }
    }
    int newId = lastId + 1;
    String newIdStr = 'PROD${newId.toString().padLeft(6, '0')}';

    return newIdStr;
  }

  Future<Response> index() async {
    try {
      // var products = await Product().query().get();
      var products = await Product()
          .query()
          .join('vendors', 'vendors.vend_id', '=',
              'products.vend_id') // Melakukan join antara tabel products dan vendors
          .select(['products.*', 'vendors.vend_name']).get();

      var formatProducts = products.map((product) {
        return {
          'prod_id': product['prod_id'],
          'prod_name': product['prod_name'],
          'prod_price': product['prod_price'],
          'prod_desc': product['prod_desc'],
          'vend_name': product['vend_name'],
          'created_at': product['created_at'],
          'updated_at': product['updated_at'],
          'vendors': {
            'vend_id': product['vend_id'],
            'vend_name': product['vend_name'],
          }
        };
      }).toList();

      return Response.json({
        'success': true,
        'message': 'Products retrieved successfully',
        'data': formatProducts
      });
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var vendId = request.input('vend_id');
      var prodName = request.input('prod_name');
      var prodPrice = request.input('prod_price');
      var prodDesc = request.input('prod_desc');

      var prodId = await _generateProductId();

      await Product().query().insert({
        'prod_id': prodId,
        'vend_id': vendId,
        'prod_name': prodName,
        'prod_price': prodPrice,
        'prod_desc': prodDesc,
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

  Future<Response> update(Request request, String prodId) async {
    try {
      var vendId = request.input('vend_id');
      var prodName = request.input('prod_name');
      var prodPrice = request.input('prod_price');
      var prodDesc = request.input('prod_desc');

      await Product().query().where('prod_id', '=', prodId).update({
        'vend_id': vendId,
        'prod_name': prodName,
        'prod_price': prodPrice,
        'prod_desc': prodDesc,
        'updated_at': DateTime.now(),
      });

      return Response.json({
        'success': true,
        'message': 'Data berhasil diupdate',
        'code': 200,
        'data': {
          'prod_id': prodId,
          'vend_id': vendId,
          'prod_name': prodName,
          'prod_price': prodPrice,
          'prod_desc': prodDesc,
        }
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }

  Future<Response> destroy(String prodId) async {
    try {
      await Product().query().where('prod_id', '=', prodId).delete();
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

final ProductControllers productController = ProductControllers();
