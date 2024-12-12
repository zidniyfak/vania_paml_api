import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/productnote.dart';

class ProductNoteControllers extends Controller {
  Future<String> _generateProdNoteId() async {
    var lastProdNote =
        await Productnote().query().orderBy('note_id', 'desc').first();

    int lastId = 0;
    if (lastProdNote != null) {
      String lastIdStr = lastProdNote['note_id'].toString().substring(1);
      lastId = int.parse(lastIdStr);
    }

    int newId = lastId + 1;
    String newIdStr = 'N${newId.toString().padLeft(4, '0')}';
    return newIdStr;
  }

  Future<Response> index() async {
    try {
      var productNotes = await Productnote().query().get();
      return Response.json(productNotes);
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var noteId = await _generateProdNoteId();
      var prodId = request.input('prod_id');
      var noteDate = request.input('note_date');
      var noteText = request.input('note_text');
      await Productnote().query().insert({
        'note_id': noteId,
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
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

  Future<Response> update(Request request, String noteId) async {
    try {
      var prodId = request.input('prod_id');
      var noteDate = request.input('note_date');
      var noteText = request.input('note_text');
      await Productnote().query().where('note_id', '=', noteId).update({
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
        'updated_at': DateTime.now(),
      });
      return Response.json({
        'success': true,
        'message': 'Data berhasil diupdate',
        'code': 200,
        'data': {
          'note_id': noteId,
          'prod_id': prodId,
          'note_date': noteDate,
          'note_text': noteText,
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

  Future<Response> destroy(String noteId) async {
    try {
      await Productnote().query().where('note_id', '=', noteId).delete();
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

final ProductNoteControllers productNoteController = ProductNoteControllers();
