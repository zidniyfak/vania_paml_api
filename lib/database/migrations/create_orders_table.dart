import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      bigInt('order_num', length: 11);
      date('order_date');
      char('cust_id', length: 5);
      timeStamps();

      primary('order_num');
      foreign('cust_id', 'customers', 'cust_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
