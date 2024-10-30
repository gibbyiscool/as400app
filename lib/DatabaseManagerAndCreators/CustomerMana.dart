import 'package:flutter/material.dart';
import 'Database.dart';

class CustomerLookupScreen extends StatefulWidget {
  @override
  _CustomerLookupScreenState createState() => _CustomerLookupScreenState();
}

class _CustomerLookupScreenState extends State<CustomerLookupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerCode = '';
  Customer? _customer;

  void _lookupCustomer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Customer? customer = await CustomerDatabase().getCustomer(_customerCode);
      setState(() {
        _customer = customer;
      });
    }
  }

  void _deleteCustomer() async {
    if (_customer != null) {
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Customer'),
          content: Text('Are you sure you want to delete this customer? This action is irreversible.'),
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
        await CustomerDatabase().deleteCustomer(_customer!.customerCode);
        setState(() {
          _customer = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Customer deleted successfully!')),
        );
      }
    }
  }
  void _editCustomer() {
  if (_customer != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerCreatorScreen(customer: _customer!),
        ),
      );
    }
  }


  void _showAllCustomerCodes() async {
    List<String> customerCodes = await CustomerDatabase().getAllCustomerCodes();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('All Customer Codes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: customerCodes.map((code) => Text(code)).toList(),
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
        title: Text('Customer Lookup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Customer Code'),
                onSaved: (value) => _customerCode = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _lookupCustomer,
              child: Text('Lookup Customer'),
            ),
            SizedBox(height: 20),
            _customer != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Name: ${_customer!.customerName}'),
                      Text('Address: ${_customer!.address}'),
                      Text('ZIP Code: ${_customer!.zip}'),
                      Text('CSR: ${_customer!.csr}'),
                      Text('City Code: ${_customer!.cityCode}'),
                      Text('City: ${_customer!.city}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _deleteCustomer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete Customer'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _editCustomer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Edit Customer'),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerCreatorScreen()),
                );
              },child: Text('Add Customer')
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAllCustomerCodes,
              child: Text('Show All Customer Codes'),
            ),
            
          ],
        ),
      ),
    );
  }
}


class CustomerCreatorScreen extends StatefulWidget {
  final Customer? customer;

  CustomerCreatorScreen({this.customer});

  @override
  _CustomerCreatorScreenState createState() => _CustomerCreatorScreenState();
}

class _CustomerCreatorScreenState extends State<CustomerCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerCode = '';
  String _customerName = '';
  String _address = '';
  String _zip = '';
  String _csr = '';
  String _cityCode = '';
  String _city = '';

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _customerCode = widget.customer!.customerCode;
      _customerName = widget.customer!.customerName;
      _address = widget.customer!.address;
      _zip = widget.customer!.zip;
      _csr = widget.customer!.csr;
      _cityCode = widget.customer!.cityCode;
      _city = widget.customer!.city;
    }
  }

  void _createCustomer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Customer newCustomer = Customer(
        customerCode: _customerCode,
        customerName: _customerName,
        address: _address,
        zip: _zip,
        csr: _csr,
        cityCode: _cityCode,
        city: _city,
      );
     await CustomerDatabase().insertCustomer(newCustomer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.customer != null ? 'Customer updated successfully!' : 'Customer added successfully!')),
      );
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer != null ? 'Edit Customer' : 'Create New Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Code'),
                initialValue: _customerCode,
                onSaved: (value) => _customerCode = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
                enabled: widget.customer == null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                initialValue: _customerName,
                onSaved: (value) => _customerName = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                initialValue: _address,
                onSaved: (value) => _address = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ZIP Code'),
                initialValue: _zip,
                onSaved: (value) => _zip = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CSR'),
                initialValue: _csr,
                onSaved: (value) => _csr = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City Code'),
                initialValue: _cityCode,
                onSaved: (value) => _cityCode = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                initialValue: _city,
                onSaved: (value) => _city = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createCustomer,
                child: Text(widget.customer != null ? 'Update Customer' : 'Create Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
