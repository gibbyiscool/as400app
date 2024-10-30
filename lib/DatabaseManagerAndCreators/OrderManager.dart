import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Database.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderCreatorScreen(),
      routes: {
        '/orderScreen': (context) => OrderCreatorScreen()
      },
    ));
class OrderScreen extends StatelessWidget {
  final Order order;

  OrderScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Code: ${order.custCode}'),
              Text('Customer Name: ${order.cust}'),
              Text('Origin: ${order.orig}'),
              Text('Commodity: ${order.cmdty}'),
              Text('Miles Load: ${order.mileLoad}'),
              Text('Trailer Pallet Balance: ${order.trlrPalletBal}'),
              Text('Consignee Code: ${order.consCode}'),
              Text('Consignee: ${order.cons}'),
              Text('Contact: ${order.cont}'),
              Text('Destination: ${order.dest}'),
              Text('Customer Number: ${order.custNumber}'),
              Text('Delivery: ${order.del}'),
              Text('Current Order Number: ${order.currentOrderNumber}'),
              Text('ETA: ${order.eta}'),
              Text('PTA: ${order.pta}'),
              Text('Pickup Date Start: ${order.puDateStart}'),
              Text('Pickup Date End: ${order.puDateEnd}'),
              Text('Pickup Time Start: ${order.puTimeStart}'),
              Text('Pickup Time End: ${order.puTimeEnd}'),
              Text('Delivery Date Start: ${order.delDateStart}'),
              Text('Delivery Date End: ${order.delDateEnd}'),
              Text('Delivery Time Start: ${order.delTimeStart}'),
              Text('Delivery Time End: ${order.delTimeEnd}'),
              Text('Load Type: ${order.loadType}'),
              Text('Unload Type: ${order.unloadType}'),
              Text('Order Status: ${order.orderStatus}'),
              Text('Preloaded Trailer: ${order.preloadedTrailer}'),
              Text('PO Number: ${order.poNumber}'),
              Text('Pickup Reference Number: ${order.puRefNumber}'),
              Text('Delivery Reference Number: ${order.delRefNumber}'),
              Text('Customer Comments: ${order.customerComments}'),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCreatorScreen extends StatefulWidget {
  @override
  _OrderCreatorScreenState createState() => _OrderCreatorScreenState();
}

class _OrderCreatorScreenState extends State<OrderCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  String _custCode = '';
  String _customerName = '';
  String _origin = '';
  String _cmdty = '';
  String _mileLoad = '';
  String _trlrPalletBal = '';
  String _consCode = '';
  String _consigneeName = '';
  String _destination = '';
  String _cont = '';
  String _custNumber = '';
  String _currentOrderNumber = '';
  String _puDateStart = '';
  String _puDateEnd = '';
  String _puTimeStart = '';
  String _puTimeEnd = '';
  String _delDateStart = '';
  String _delDateEnd = '';
  String _delTimeStart = '';
  String _delTimeEnd = '';

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _createOrder() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    Order newOrder = Order(
      custCode: _custCode,
      cust: _customerName,
      orig: _origin,
      cmdty: _cmdty,
      mileLoad: _mileLoad,
      trlrPalletBal: _trlrPalletBal,
      consCode: _consCode,
      cons: _consigneeName,
      cont: _cont,
      dest: _destination,
      custNumber: _custNumber,
      del: '',
      currentOrderNumber: _currentOrderNumber,
      eta: '',
      pta: '',
      puDateStart: _puDateStart,
      puDateEnd: _puDateEnd,
      puTimeStart: _puTimeStart,
      puTimeEnd: _puTimeEnd,
      delDateStart: _delDateStart,
      delDateEnd: _delDateEnd,
      delTimeStart: _delTimeStart,
      delTimeEnd: _delTimeEnd,
      loadType: '',
      unloadType: '',
      orderStatus: '',
      preloadedTrailer: '',
      poNumber: '',
      puRefNumber: '',
      delRefNumber: '',
      customerComments: '',
    );

    // Insert the new order into the database
    await OrderDatabase().insertOrder(newOrder);

    // Navigate to the OrderScreen to show the order details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(order: newOrder),
      ),
    );
  }
}



  String? _validateCustomerCode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  } else {
    return null; // Asynchronous check must be done separately
  }
}

void _onCustomerCodeSubmitted(String value) async {
  Customer? customer = await CustomerDatabase().getCustomer(value);
  if (customer != null) {
    setState(() {
      _customerName = customer.customerName;
      _origin = customer.city;
    });
  } else {
    setState(() {
      _customerName = 'None found';
      _origin = 'None found';
    });
  }
}

void _onConsigneeCodeSubmitted(String value) async {
  Customer? consignee = await CustomerDatabase().getCustomer(value);
  if (consignee != null) {
    setState(() {
      _consigneeName = consignee.customerName;
      _destination = consignee.city;
    });
  } else {
    setState(() {
      _consigneeName = 'None found';
      _destination = 'None found';
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Code'),
                onSaved: (value) => _custCode = value ?? '',
                validator: _validateCustomerCode,
                onFieldSubmitted: _onCustomerCodeSubmitted,
              ),
              SizedBox(height: 8),
              Text('Customer Name: $_customerName'),
              Text('Origin: $_origin'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Commodity'),
                onSaved: (value) => _cmdty = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Miles Load'),
                onSaved: (value) => _mileLoad = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Trailer Pallet Balance'),
                onSaved: (value) => _trlrPalletBal = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Consignee Code'),
                onSaved: (value) => _consCode = value ?? '',
                onFieldSubmitted: _onConsigneeCodeSubmitted,
              ),
              SizedBox(height: 8),
              Text('Consignee: $_consigneeName'),
              Text('Destination: $_destination'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
                onSaved: (value) => _cont = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
                onSaved: (value) => _cont = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Number'),
                onSaved: (value) => _custNumber = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Order Number'),
                onSaved: (value) => _currentOrderNumber = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Date Start'),
                onSaved: (value) => _puDateStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Date End'),
                onSaved: (value) => _puDateEnd = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Time Start'),
                onSaved: (value) => _puTimeStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Time End'),
                onSaved: (value) => _puTimeEnd = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Date Start'),
                onSaved: (value) => _delDateStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Date End'),
                onSaved: (value) => _delDateEnd = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Time Start'),
                onSaved: (value) => _delTimeStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Time End'),
                onSaved: (value) => _delTimeEnd = value ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createOrder,
                child: Text('Create Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
