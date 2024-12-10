import 'dart:io';
import 'package:vania/vania.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_vendors_table.dart';
import 'create_products_table.dart';
import 'create_productnotes_table.dart';
import 'create_orderitems_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateCustomerTable().up();
    await CreateOrdersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateProductnotesTable().up();
    await CreateOrderitemsTable().up();
  }

  dropTables() async {
    await CreateOrderitemsTable().down();
    await CreateProductnotesTable().down();
    await CreateProductsTable().down();
    await CreateVendorsTable().down();
    await CreateOrdersTable().down();
    await CreateCustomerTable().down();
  }
}
