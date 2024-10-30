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

  void _createOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Order newOrder = Order.createNewOrder(_custCode, _customerName, _origin);
      newOrder.cmdty = _cmdty;
      newOrder.mileLoad = _mileLoad;
      newOrder.trlrPalletBal = _trlrPalletBal;
      newOrder.consCode = _consCode;
      newOrder.cons = _consigneeName;
      newOrder.dest = _destination;
      newOrder.cont = _cont;
      newOrder.custNumber = _custNumber;
      newOrder.currentOrderNumber = _currentOrderNumber;
      newOrder.puDateStart = _puDateStart;
      newOrder.puDateEnd = _puDateEnd;
      newOrder.puTimeStart = _puTimeStart;
      newOrder.puTimeEnd = _puTimeEnd;
      newOrder.delDateStart = _delDateStart;
      newOrder.delDateEnd = _delDateEnd;
      newOrder.delTimeStart = _delTimeStart;
      newOrder.delTimeEnd = _delTimeEnd;
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
    } else if (!_isValidCustomerCode(value)) {
      return 'Entered code is not correct, please re-enter code or create customer in customer creator';
    }
    return null;
  }

  bool _isValidCustomerCode(String code) {
    // Check against the customer database
    return CustomerDatabase().getCustomer(code) != null;
  }

  void _onCustomerCodeSubmitted(String value) {
    Customer? customer = CustomerDatabase().getCustomer(value);
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
  void _onConsigneeCodeSubmitted(String value) {
    Customer? consignee = CustomerDatabase().getCustomer(value);
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
