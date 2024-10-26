import 'package:as400app/TruckScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TruckScreen(),
      routes: {
        '/truckScreen': (context) => TruckScreen(),
      },
    ));

class TruckDatabase {
  static final TruckDatabase _instance = TruckDatabase._internal();
  factory TruckDatabase() => _instance;

  TruckDatabase._internal();

  Map<String, Truck> trucks = {
    '14136': Truck(
      tracNumber: '14136',
      trlrNumber: '120243',
      drv1Code: 'ADKRO',
      drv2Code: 'RAMIVI',
      drv1Home: 'Bethlehem',
      drv2Home: 'Stockholm',
      dmgr1: 'PATRICK R WALK',
      dmgr2: 'CASEY JENNINGS',
      orderNumber: '0560933',
    ),
  };
}

class OrderDatabase {
  static final OrderDatabase _instance = OrderDatabase._internal();
  factory OrderDatabase() => _instance;

  OrderDatabase._internal();

  Map<String, Order> orders = {
    '0560933': Order(
      custCode: 'PSPS',
      cust: CustomerDatabase().getCustomerName('PSPS'),
      orig: 'Hollis Center',
      cmdty: 'FAK',
      mileLoad: '439',
      trlrPalletBal: '',
      consCode:'CAC',
      cons: 'C&S WHOLESALE GROCER',
      cont: '11111111',
      dest: 'Robesonia',
      custNumber: '8924568',
      del: '',
      currentOrderNumber: '0560933',
      eta: '',
      pta: '',
      puDateStart: '10/22/24',
      puDateEnd: '10/23/24',
      puTimeStart: '0800',
      puTimeEnd: '1200',
      delDateStart: '10/25/24',
      delDateEnd: '10/26/24',
      delTimeStart: '0900',
      delTimeEnd: '1500',
      loadType: 'N',
      unloadType: 'W',
      orderStatus: 'A',
      preloadedTrailer: '',
      poNumber: '987654',
      puRefNumber: 'PU12345',
      delRefNumber: 'DEL54321',
      customerComments: 'Handle with care',
    ),
  };
}

class CustomerDatabase {
  static final CustomerDatabase _instance = CustomerDatabase._internal();
  factory CustomerDatabase() => _instance;

  CustomerDatabase._internal();

  Map<String, Customer> customers = {
    'PSPS': Customer(
      customerCode: 'PSPS',
      customerName: 'Poland Springs',
      address: '123 Poland Springs Rd',
      zip: '04039',
      csr: 'John Doe',
      cityCode: 'HC ME',
    ),
    'MEME': Customer(
      customerCode: 'PSPS',
      customerName: 'Poland Springs',
      address: '123 Poland Springs Rd',
      zip: '04039',
      csr: 'John Doe',
      cityCode: 'HC ME',
    ),
  };

  String getCustomerName(String custCode) {
    return customers[custCode]?.customerName ?? 'Unknown Customer';
  }
}

class Customer {
  String customerCode;
  String customerName;
  String address;
  String zip;
  String csr;
  String cityCode;

  Customer({
    required this.customerCode,
    required this.customerName,
    required this.address,
    required this.zip,
    required this.csr,
    required this.cityCode,
  });
}

class Truck {
  String tracNumber;
  String trlrNumber;
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
    required this.drv1Code,
    required this.drv2Code,
    required this.drv1Home,
    required this.drv2Home,
    required this.dmgr1,
    required this.dmgr2,
    required this.orderNumber,
  });
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
}
