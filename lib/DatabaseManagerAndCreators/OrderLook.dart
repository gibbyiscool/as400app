import 'package:flutter/material.dart';
import 'Database.dart';

class OrderLookupScreen extends StatefulWidget {
  @override
  _OrderLookupScreenState createState() => _OrderLookupScreenState();
}

class _OrderLookupScreenState extends State<OrderLookupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _orderNumber = '';
  Order? _retrievedOrder;
  bool _isLoading = false;

  Future<void> _lookupOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      final orderDatabase = OrderDatabase();
      Order? order = await orderDatabase.getOrder(_orderNumber);

      setState(() {
        _retrievedOrder = order;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Lookup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Order Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an order number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _orderNumber = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _lookupOrder,
                child: _isLoading ? CircularProgressIndicator() : Text('Lookup Order'),
              ),
              SizedBox(height: 20),
              if (_retrievedOrder != null) _buildOrderDetails(),
              if (_retrievedOrder == null && !_isLoading && _orderNumber.isNotEmpty)
                Text('No order found for the given order number'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Number: ${_retrievedOrder!.currentOrderNumber}'),
          Text('Customer Code: ${_retrievedOrder!.custCode}'),
          Text('Customer Name: ${_retrievedOrder!.cust}'),
          Text('Origin: ${_retrievedOrder!.orig}'),
          Text('Commodity: ${_retrievedOrder!.cmdty}'),
          Text('Miles Load: ${_retrievedOrder!.mileLoad}'),
          Text('Trailer Pallet Balance: ${_retrievedOrder!.trlrPalletBal}'),
          Text('Consignee Code: ${_retrievedOrder!.consCode}'),
          Text('Consignee: ${_retrievedOrder!.cons}'),
          Text('Contact: ${_retrievedOrder!.cont}'),
          Text('Destination: ${_retrievedOrder!.dest}'),
          Text('Customer Number: ${_retrievedOrder!.custNumber}'),
          Text('Delivery: ${_retrievedOrder!.del}'),
          Text('ETA: ${_retrievedOrder!.eta}'),
          Text('PTA: ${_retrievedOrder!.pta}'),
          Text('Pickup Date Start: ${_retrievedOrder!.puDateStart}'),
          Text('Pickup Date End: ${_retrievedOrder!.puDateEnd}'),
          Text('Pickup Time Start: ${_retrievedOrder!.puTimeStart}'),
          Text('Pickup Time End: ${_retrievedOrder!.puTimeEnd}'),
          Text('Delivery Date Start: ${_retrievedOrder!.delDateStart}'),
          Text('Delivery Date End: ${_retrievedOrder!.delDateEnd}'),
          Text('Delivery Time Start: ${_retrievedOrder!.delTimeStart}'),
          Text('Delivery Time End: ${_retrievedOrder!.delTimeEnd}'),
          Text('Load Type: ${_retrievedOrder!.loadType}'),
          Text('Unload Type: ${_retrievedOrder!.unloadType}'),
          Text('Order Status: ${_retrievedOrder!.orderStatus}'),
          Text('Preloaded Trailer: ${_retrievedOrder!.preloadedTrailer}'),
          Text('PO Number: ${_retrievedOrder!.poNumber}'),
          Text('Pickup Reference Number: ${_retrievedOrder!.puRefNumber}'),
          Text('Delivery Reference Number: ${_retrievedOrder!.delRefNumber}'),
          Text('Customer Comments: ${_retrievedOrder!.customerComments}'),
        ],
      ),
    );
  }
}
