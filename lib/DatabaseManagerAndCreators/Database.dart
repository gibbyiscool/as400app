import 'package:as400app/TruckScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TruckDatabase {
  static final TruckDatabase _instance = TruckDatabase._internal();
  factory TruckDatabase() => _instance;

  TruckDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("trucks.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, filePath),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE trucks(
            tracNumber TEXT PRIMARY KEY,
            trlrNumber TEXT,
            licensePlate TEXT,
            last6Vin TEXT,
            status TEXT,
            drv1Code TEXT,
            drv2Code TEXT,
            drv1Home TEXT,
            drv2Home TEXT,
            dmgr1 TEXT,
            dmgr2 TEXT,
            orderNumber TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertTruck(Truck truck) async {
    final db = await database;
    await db.insert(
      'trucks',
      truck.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
Future<void> deleteTruck(String tracNumber) async {
    final db = await database;
    await db.delete(
      'trucks',
      where: 'tracNumber = ?',
      whereArgs: [tracNumber],
    );
  }

  Future<void> updateTruck(Truck truck) async {
    final db = await database;
    await db.update(
      'trucks',
      truck.toMap(),
      where: 'tracNumber = ?',
      whereArgs: [truck.tracNumber],
    );
  }

  Future<List<String>> getAllTruckNumbers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('trucks', columns: ['tracNumber']);
    return List.generate(maps.length, (i) => maps[i]['tracNumber'] as String);
  }


  Future<Truck?> getTruck(String tracNumber) async {
    final db = await database;
    final maps = await db.query(
      'trucks',
      where: 'tracNumber = ?',
      whereArgs: [tracNumber],
    );
    if (maps.isNotEmpty) {
      return Truck.fromMap(maps.first);
    } else {
      return null;
    }
  }
}

class OrderDatabase {
  static final OrderDatabase _instance = OrderDatabase._internal();
  factory OrderDatabase() => _instance;

  OrderDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("orders.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, filePath),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders(
            currentOrderNumber TEXT PRIMARY KEY,
            custCode TEXT,
            cust TEXT,
            orig TEXT,
            cmdty TEXT,
            mileLoad TEXT,
            trlrPalletBal TEXT,
            consCode TEXT,
            cons TEXT,
            cont TEXT,
            dest TEXT,
            custNumber TEXT,
            del TEXT,
            eta TEXT,
            pta TEXT,
            puDateStart TEXT,
            puDateEnd TEXT,
            puTimeStart TEXT,
            puTimeEnd TEXT,
            delDateStart TEXT,
            delDateEnd TEXT,
            delTimeStart TEXT,
            delTimeEnd TEXT,
            loadType TEXT,
            unloadType TEXT,
            orderStatus TEXT,
            preloadedTrailer TEXT,
            poNumber TEXT,
            puRefNumber TEXT,
            delRefNumber TEXT,
            customerComments TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Order?> getOrder(String currentOrderNumber) async {
    final db = await database;
    final maps = await db.query(
      'orders',
      where: 'currentOrderNumber = ?',
      whereArgs: [currentOrderNumber],
    );
    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Method to create a new order and insert it into the database
  Future<void> createNewOrder(String custCode, String currentOrderNumber) async {
    final customer = await CustomerDatabase().getCustomer(custCode);
    if (customer == null) {
      throw Exception("Customer not found");
    }

    Order newOrder = Order(
      custCode: custCode,
      cust: customer.customerName,
      orig: customer.city,
      cmdty: '',
      mileLoad: '',
      trlrPalletBal: '',
      consCode: '',
      cons: '',
      cont: '',
      dest: '',
      custNumber: '',
      del: '',
      currentOrderNumber: currentOrderNumber,
      eta: '',
      pta: '',
      puDateStart: '',
      puDateEnd: '',
      puTimeStart: '',
      puTimeEnd: '',
      delDateStart: '',
      delDateEnd: '',
      delTimeStart: '',
      delTimeEnd: '',
      loadType: '',
      unloadType: '',
      orderStatus: '',
      preloadedTrailer: '',
      poNumber: '',
      puRefNumber: '',
      delRefNumber: '',
      customerComments: '',
    );

    await insertOrder(newOrder);
  }
}

class CustomerDatabase {
  static final CustomerDatabase _instance = CustomerDatabase._internal();
  factory CustomerDatabase() => _instance;

  CustomerDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("customers.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, filePath),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customers(
            customerCode TEXT PRIMARY KEY,
            customerName TEXT,
            address TEXT,
            zip TEXT,
            csr TEXT,
            cityCode TEXT,
            city TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertCustomer(Customer customer) async {
    final db = await database;
    await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> deleteCustomer(String customerCode) async {
  final db = await database;
  await db.delete(
    'customers',
    where: 'customerCode = ?',
    whereArgs: [customerCode],
  );
}
Future<List<String>> getAllCustomerCodes() async {
  final db = await database;
  final result = await db.query('customers', columns: ['customerCode']);
  return result.map((row) => row['customerCode'] as String).toList();
}

  Future<Customer?> getCustomer(String customerCode) async {
    final db = await database;
    final maps = await db.query(
      'customers',
      where: 'customerCode = ?',
      whereArgs: [customerCode],
    );
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    } else {
      return null;
    }
  }
  

  // Method to recall customer info (name and city) by customer code
  Future<Map<String, String>> recallCustomerInfo(String custCode) async {
    final customer = await getCustomer(custCode);
    if (customer == null) {
      throw Exception("Customer not found");
    }
    return {
      'customerName': customer.customerName,
      'city': customer.city,
    };
  }
}


class Truck {
  String tracNumber;
  String trlrNumber;
  String licensePlate;
  String last6Vin;
  String status;
  String drv1Code;
  String drv2Code;
  String drv1Home;
  String drv2Home;
  String dmgr1;
  String dmgr2;
  String orderNumber;

  Truck({
    required this.tracNumber,
    required this.trlrNumber,
    required this.licensePlate,
    required this.last6Vin,
    required this.status,
    required this.drv1Code,
    required this.drv2Code,
    required this.drv1Home,
    required this.drv2Home,
    required this.dmgr1,
    required this.dmgr2,
    required this.orderNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'tracNumber': tracNumber,
      'trlrNumber': trlrNumber,
      'licensePlate': licensePlate,
      'last6Vin': last6Vin,
      'status': status, 
      'drv1Code': drv1Code,
      'drv2Code': drv2Code,
      'drv1Home': drv1Home,
      'drv2Home': drv2Home,
      'dmgr1': dmgr1,
      'dmgr2': dmgr2,
      'orderNumber': orderNumber,
    };
  }

  factory Truck.fromMap(Map<String, dynamic> map) {
    return Truck(
      tracNumber: map['tracNumber'],
      trlrNumber: map['trlrNumber'],
      licensePlate: map['licensePlate'],
      last6Vin: map['last6Vin'],
      status: map['status'],
      drv1Code: map['drv1Code'],
      drv2Code: map['drv2Code'],
      drv1Home: map['drv1Home'],
      drv2Home: map['drv2Home'],
      dmgr1: map['dmgr1'],
      dmgr2: map['dmgr2'],
      orderNumber: map['orderNumber'],
    );
  }
}

class Order {
  String custCode;
  String cust;
  String orig;
  String cmdty;
  String mileLoad;
  String trlrPalletBal;
  String consCode;
  String cons;
  String cont;
  String dest;
  String custNumber;
  String del;
  String currentOrderNumber;
  String eta;
  String pta;
  String puDateStart;
  String puDateEnd;
  String puTimeStart;
  String puTimeEnd;
  String delDateStart;
  String delDateEnd;
  String delTimeStart;
  String delTimeEnd;
  String loadType;
  String unloadType;
  String orderStatus;
  String preloadedTrailer;
  String poNumber;
  String puRefNumber;
  String delRefNumber;
  String customerComments;

  Order({
    required this.custCode,
    required this.cust,
    required this.orig,
    required this.cmdty,
    required this.mileLoad,
    required this.trlrPalletBal,
    required this.consCode,
    required this.cons,
    required this.cont,
    required this.dest,
    required this.custNumber,
    required this.del,
    required this.currentOrderNumber,
    required this.eta,
    required this.pta,
    required this.puDateStart,
    required this.puDateEnd,
    required this.puTimeStart,
    required this.puTimeEnd,
    required this.delDateStart,
    required this.delDateEnd,
    required this.delTimeStart,
    required this.delTimeEnd,
    required this.loadType,
    required this.unloadType,
    required this.orderStatus,
    required this.preloadedTrailer,
    required this.poNumber,
    required this.puRefNumber,
    required this.delRefNumber,
    required this.customerComments,
  });

  Map<String, dynamic> toMap() {
    return {
      'custCode': custCode,
      'cust': cust,
      'orig': orig,
      'cmdty': cmdty,
      'mileLoad': mileLoad,
      'trlrPalletBal': trlrPalletBal,
      'consCode': consCode,
      'cons': cons,
      'cont': cont,
      'dest': dest,
      'custNumber': custNumber,
      'del': del,
      'currentOrderNumber': currentOrderNumber,
      'eta': eta,
      'pta': pta,
      'puDateStart': puDateStart,
      'puDateEnd': puDateEnd,
      'puTimeStart': puTimeStart,
      'puTimeEnd': puTimeEnd,
      'delDateStart': delDateStart,
      'delDateEnd': delDateEnd,
      'delTimeStart': delTimeStart,
      'delTimeEnd': delTimeEnd,
      'loadType': loadType,
      'unloadType': unloadType,
      'orderStatus': orderStatus,
      'preloadedTrailer': preloadedTrailer,
      'poNumber': poNumber,
      'puRefNumber': puRefNumber,
      'delRefNumber': delRefNumber,
      'customerComments': customerComments,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      custCode: map['custCode'],
      cust: map['cust'],
      orig: map['orig'],
      cmdty: map['cmdty'],
      mileLoad: map['mileLoad'],
      trlrPalletBal: map['trlrPalletBal'],
      consCode: map['consCode'],
      cons: map['cons'],
      cont: map['cont'],
      dest: map['dest'],
      custNumber: map['custNumber'],
      del: map['del'],
      currentOrderNumber: map['currentOrderNumber'],
      eta: map['eta'],
      pta: map['pta'],
      puDateStart: map['puDateStart'],
      puDateEnd: map['puDateEnd'],
      puTimeStart: map['puTimeStart'],
      puTimeEnd: map['puTimeEnd'],
      delDateStart: map['delDateStart'],
      delDateEnd: map['delDateEnd'],
      delTimeStart: map['delTimeStart'],
      delTimeEnd: map['delTimeEnd'],
      loadType: map['loadType'],
      unloadType: map['unloadType'],
      orderStatus: map['orderStatus'],
      preloadedTrailer: map['preloadedTrailer'],
      poNumber: map['poNumber'],
      puRefNumber: map['puRefNumber'],
      delRefNumber: map['delRefNumber'],
      customerComments: map['customerComments'],
    );
  }
}

class Customer {
  String customerCode;
  String customerName;
  String address;
  String zip;
  String csr;
  String cityCode;
  String city;

  Customer({
    required this.customerCode,
    required this.customerName,
    required this.address,
    required this.zip,
    required this.csr,
    required this.cityCode,
    required this.city,
  });
  Map<String, dynamic> toMap() {
    return {
      "customerCode" : customerCode,
      "customerName" :customerName,
      "address" : address,
      "zip" : zip,
      "csr" : csr,
      "cityCode" : cityCode,
      "city" : city,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      customerCode: map['customerCode'],
      customerName: map['customerName'],
      address: map['address'],
      zip: map['zip'],
      csr: map['csr'],
      cityCode: map['cityCode'],
      city: map['city'],
      
    );
  }
}
