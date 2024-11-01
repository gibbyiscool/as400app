 import 'package:flutter/material.dart';
import 'Database.dart';
import 'dart:async';

class OrderLookupScreen extends StatefulWidget {
  @override
  _OrderLookupScreenState createState() => _OrderLookupScreenState();
}

class _OrderLookupScreenState extends State<OrderLookupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _orderNumber = '';
  Order? _order;

  void _lookupOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Order? order = await OrderDatabase().getOrder(_orderNumber);
      setState(() {
        _order = order;
      });
    }
  }

  void _deleteOrder() async {
    if (_order != null) {
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Order'),
          content: Text('Are you sure you want to delete this order? This action is irreversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirmDelete == true) {
        await OrderDatabase().deleteOrder(_order!.currentOrderNumber);
        setState(() {
          _order = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order deleted successfully!')),
        );
      }
    }
  }

  void _editOrder() {
    if (_order != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderCreatorScreen(order: _order!),
        ),
      );
    }
  }

  void _showAllOrderNumbers() async {
    List<String> orderNumbers = await OrderDatabase().getAllOrderNumbers();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('All Order Numbers'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: orderNumbers.map((number) => Text(number)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Lookup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Order Number'),
                onSaved: (value) => _orderNumber = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _lookupOrder,
              child: Text('Lookup Order'),
            ),
            SizedBox(height: 20),
            _order != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Code: ${_order!.custCode}'),
                      Text('Customer Name: ${_order!.cust}'),
                      Text('Origin: ${_order!.orig}'),
                      Text('Commodity: ${_order!.cmdty}'),
                      Text('Miles Load: ${_order!.mileLoad}'),
                      Text('Trailer Pallet Balance: ${_order!.trlrPalletBal}'),
                      Text('Consignee Code: ${_order!.consCode}'),
                      Text('Consignee: ${_order!.cons}'),
                      Text('Contact: ${_order!.cont}'),
                      Text('Destination: ${_order!.dest}'),
                      Text('Customer Number: ${_order!.custNumber}'),
                      Text('Delivery: ${_order!.del}'),
                      Text('Current Order Number: ${_order!.currentOrderNumber}'),
                      Text('ETA: ${_order!.eta}'),
                      Text('Pickup Date Start: ${_order!.puDateStart}'),
                      Text('Pickup Date End: ${_order!.puDateEnd}'),
                      Text('Pickup Time Start: ${_order!.puTimeStart}'),
                      Text('Pickup Time End: ${_order!.puTimeEnd}'),
                      Text('Delivery Date Start: ${_order!.delDateStart}'),
                      Text('Delivery Date End: ${_order!.delDateEnd}'),
                      Text('Delivery Time Start: ${_order!.delTimeStart}'),
                      Text('Delivery Time End: ${_order!.delTimeEnd}'),
                      Text('Load Type: ${_order!.loadType}'),
                      Text('Unload Type: ${_order!.unloadType}'),
                      Text('Order Status: ${_order!.orderStatus}'),
                      Text('Preloaded Trailer: ${_order!.preloadedTrailer}'),
                      Text('PO Number: ${_order!.poNumber}'),
                      Text('Pickup Reference Number: ${_order!.puRefNumber}'),
                      Text('Delivery Reference Number: ${_order!.delRefNumber}'),
                      Text('Customer Comments: ${_order!.customerComments}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _deleteOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete Order'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _editOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Edit Order'),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderCreatorScreen()),
                );
              },
              child: Text('Add Order'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAllOrderNumbers,
              child: Text('Show All Order Numbers'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCreatorScreen extends StatefulWidget {
  final Order? order;

  OrderCreatorScreen({this.order});

  @override
  _OrderCreatorScreenState createState() => _OrderCreatorScreenState();
}

class _OrderCreatorScreenState extends State<OrderCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  String _custCode = '';
  String _cust = '';
  String _orig = '';
  String _cmdty = '';
  String _mileLoad = '';
  String _trlrPalletBal = '';
  String _consCode = '';
  String _cons = '';
  String _cont = '';
  String _dest = '';
  String _custNumber = '';
  String _del = '';
  String _currentOrderNumber = '';
  String _eta = '';
  String _pta = '';
  String _puDateStart = '';
  String _puDateEnd = '';
  String _puTimeStart = '';
  String _puTimeEnd = '';
  String _delDateStart = '';
  String _delDateEnd = '';
  String _delTimeStart = '';
  String _delTimeEnd = '';
  String _loadType = '';
  String _unloadType = '';
  String _orderStatus = '';
  String _preloadedTrailer = '';
  String _poNumber = '';
  String _puRefNumber = '';
  String _delRefNumber = '';
  String _customerComments = '';

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _custCode = widget.order!.custCode;
      _cust = widget.order!.cust;
      _orig = widget.order!.orig;
      _cmdty = widget.order!.cmdty;
      _mileLoad = widget.order!.mileLoad;
      _trlrPalletBal = widget.order!.trlrPalletBal;
      _consCode = widget.order!.consCode;
      _cons = widget.order!.cons;
      _cont = widget.order!.cont;
      _dest = widget.order!.dest;
      _custNumber = widget.order!.custNumber;
      _del = widget.order!.del;
      _currentOrderNumber = widget.order!.currentOrderNumber;
      _eta = widget.order!.eta;
      _puDateStart = widget.order!.puDateStart;
      _puDateEnd = widget.order!.puDateEnd;
      _puTimeStart = widget.order!.puTimeStart;
      _puTimeEnd = widget.order!.puTimeEnd;
      _delDateStart = widget.order!.delDateStart;
      _delDateEnd = widget.order!.delDateEnd;
      _delTimeStart = widget.order!.delTimeStart;
      _delTimeEnd = widget.order!.delTimeEnd;
      _loadType = widget.order!.loadType;
      _unloadType = widget.order!.unloadType;
      _orderStatus = widget.order!.orderStatus;
      _preloadedTrailer = widget.order!.preloadedTrailer;
      _poNumber = widget.order!.poNumber;
      _puRefNumber = widget.order!.puRefNumber;
      _delRefNumber = widget.order!.delRefNumber;
      _customerComments = widget.order!.customerComments;
    } else {
      _generateCustomerCode();
      _generateOrderNumber();
    }
  }

  void _generateCustomerCode() async {
    final nextCode = await OrderDatabase().getNextCustomerCode();
    setState(() {
      _custCode = nextCode;
    });
  }

  void _generateOrderNumber() async {
    final nextOrderNumber = await OrderDatabase().getNextOrderNumber();
    setState(() {
      _currentOrderNumber = nextOrderNumber;
    });
  }

  void _checkCustomerCodeExists() async {
    bool exists = await OrderDatabase().checkCustomerCodeExists(_custCode);
    if (!exists) {
      
    }
  }

  void _createOrder() async {
    if (_formKey.currentState!.validate()) {
      _checkCustomerCodeExists();
      _formKey.currentState!.save();
      Order newOrder = Order(
        custCode: _custCode,
        cust: _cust,
        orig: _orig,
        cmdty: _cmdty,
        mileLoad: _mileLoad,
        trlrPalletBal: _trlrPalletBal,
        consCode: _consCode,
        cons: _cons,
        cont: _cont,
        dest: _dest,
        custNumber: _custNumber,
        del: _del,
        currentOrderNumber: _currentOrderNumber,
        eta: _eta,
        puDateStart: _puDateStart,
        puDateEnd: _puDateEnd,
        puTimeStart: _puTimeStart,
        puTimeEnd: _puTimeEnd,
        delDateStart: _delDateStart,
        delDateEnd: _delDateEnd,
        delTimeStart: _delTimeStart,
        delTimeEnd: _delTimeEnd,
        loadType: _loadType,
        unloadType: _unloadType,
        orderStatus: _orderStatus,
        preloadedTrailer: _preloadedTrailer,
        poNumber: _poNumber,
        puRefNumber: _puRefNumber,
        delRefNumber: _delRefNumber,
        customerComments: _customerComments,
      );
      if (widget.order == null) {
        await OrderDatabase().insertOrder(newOrder);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order added successfully! Order Number: $_currentOrderNumber')),
        );
      } else {
        await OrderDatabase().updateOrder(newOrder);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order updated successfully!')),
        );
      }
      _formKey.currentState!.reset();
    }
  }
  void _onCustomerCodeSubmitted(String value) async {
  Customer? customer = await CustomerDatabase().getCustomer(value);
  if (customer != null) {
    setState(() {
      _cust = customer.customerName;
      _orig = customer.city;
    });
  } else {
    setState(() {
      _cust = 'None found';
      _orig = 'None found';
    });
  }
}
void _onConsigneeCodeSubmitted(String value) async {
  Customer? consignee = await CustomerDatabase().getCustomer(value);
  if (consignee != null) {
    setState(() {
      _cons = consignee.customerName;
      _dest = consignee.city;
    });
  } else {
    setState(() {
      _cons = 'None found';
      _dest = 'None found';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order != null ? 'Edit Order' : 'Create New Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('New Order Number: $_currentOrderNumber',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Shipper Customer Code'),
                initialValue: _custCode,
                onChanged: (value) {
                  _custCode = value;
                  _checkCustomerCodeExists();
                },
                onFieldSubmitted: _onCustomerCodeSubmitted,
              ),
              SizedBox(height: 8),
              Text('Customer Name: $_cust'),
              Text('Origin: $_orig'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Commodity'),
                initialValue: _cmdty,
                onSaved: (value) => _cmdty = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Miles Load'),
                initialValue: _mileLoad,
                onSaved: (value) => _mileLoad = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Trailer Pallet Balance'),
                initialValue: _trlrPalletBal,
                onSaved: (value) => _trlrPalletBal = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Consignee Customer Code'),
                initialValue:_consCode,
                onChanged: (value) {
                  _consCode = value;
                  _checkCustomerCodeExists();
                },
                onFieldSubmitted: _onConsigneeCodeSubmitted,
              ),
              SizedBox(height: 8),
              Text('Consignee: $_cons'),
              Text('Destination: $_dest'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
                initialValue: _cont,
                onSaved: (value) => _cont = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Number'),
                initialValue: _custNumber,
                onSaved: (value) => _custNumber = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery'),
                initialValue: _del,
                onSaved: (value) => _del = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'PO Number'),
                initialValue: _poNumber,
                onSaved: (value) => _poNumber = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Date Start (Date)'),
                initialValue: _puDateStart,
                onSaved: (value) => _puDateStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Date End (Date)'),
                initialValue: _puDateEnd,
                onSaved: (value) => _puDateEnd = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Time Start (Military Time)'),
                initialValue: _puTimeStart,
                onSaved: (value) => _puTimeStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pickup Time End (Military Time)'),
                initialValue: _puTimeEnd,
                onSaved: (value) => _puTimeEnd = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Date Start (Date)'),
                initialValue: _delDateStart,
                onSaved: (value) => _delDateStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Date End (Date)'),
                initialValue: _delDateEnd,
                onSaved: (value) => _delDateEnd = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Time Start (Military Time)'),
                initialValue: _delTimeStart,
                onSaved: (value) => _delTimeStart = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Delivery Time End (Military Time)'),
                initialValue: _delTimeEnd,
                onSaved: (value) => _delTimeEnd = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Load Type (N, D, W, Y)'),
                initialValue: _loadType,
                onSaved: (value) => _loadType = value ?? '',
                validator: (value) => (value!.isEmpty || !['N', 'D', 'W', 'Y'].contains(value)) ? 'Must be N, D, W, or Y' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Unload Type (N, D, W, Y)'),
                initialValue: _unloadType,
                onSaved: (value) => _unloadType = value ?? '',
                validator: (value) => (value!.isEmpty || !['N', 'D', 'W', 'Y'].contains(value)) ? 'Must be N, D, W, or Y' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createOrder,
                child: Text(widget.order != null ? 'Update Order' : 'Create Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}