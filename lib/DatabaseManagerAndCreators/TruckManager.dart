import 'package:flutter/material.dart';
import 'Database.dart';

class TruckLookupScreen extends StatefulWidget {
  final String? truckNumber;

  TruckLookupScreen({this.truckNumber});

  @override
  _TruckLookupScreenState createState() => _TruckLookupScreenState();
}

class _TruckLookupScreenState extends State<TruckLookupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _truckNumber = '';
  Truck? _truck;

  @override
  void initState() {
    super.initState();
    if (widget.truckNumber != null) {
      _truckNumber = widget.truckNumber!;
      _lookupTruck();  // Lookup the truck as soon as the screen is initialized
    }
  }

  void _lookupTruck() async {
    if (_truckNumber.isNotEmpty) {
      Truck? truck = await TruckDatabase().getTruck(_truckNumber);
      setState(() {
        _truck = truck;
      });
    } else if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_truckNumber.isNotEmpty) {
        Truck? truck = await TruckDatabase().getTruck(_truckNumber);
        setState(() {
          _truck = truck;
        });
      } else {
        // If no truck number is provided, show all trucks
        List<String> truckNumbers = await TruckDatabase().getAllTruckNumbers();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('All Trucks'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: truckNumbers.map((number) {
                  return ListTile(
                    title: Text(number),
                    onTap: () async {
                      // Lookup the selected truck
                      Truck? selectedTruck = await TruckDatabase().getTruck(number);
                      setState(() {
                        _truck = selectedTruck;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
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
    }
  }


  void _deleteTruck() async {
    if (_truck != null) {
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Truck'),
          content: Text('Are you sure you want to delete this truck? This action is irreversible.'),
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
        await TruckDatabase().deleteTruck(_truck!.tracNumber);
        setState(() {
          _truck = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Truck deleted successfully!')),
        );
      }
    }
  }

  void _editTruck() {
    if (_truck != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TruckCreatorScreen(truck: _truck!),
        ),
      );
    }
  }

  void _showAllTruckNumbers() async {
    List<String> truckNumbers = await TruckDatabase().getAllTruckNumbers();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('All Truck Numbers'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: truckNumbers.map((number) => Text(number)).toList(),
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
        title: Text('Truck Lookup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Truck Number'),
                onSaved: (value) => _truckNumber = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _lookupTruck,
              child: Text('Lookup Truck'),
            ),
            SizedBox(height: 20),
            _truck != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Truck Number: ${_truckNumber}'),
                      Text('Trailer Number: ${_truck!.trlrNumber}'),
                      Text('License Plate: ${_truck!.licensePlate}'),
                      Text('Last 6 VIN: ${_truck!.last6Vin}'),
                      Text('Status: ${_truck!.status}'),
                      Text('Driver 1 Code: ${_truck!.drv1Code}'),
                      Text('Driver 1 Name ${_truck!.drv1Name}'),
                      Text('Driver 2 Code: ${_truck!.drv2Code}'),
                      Text('Driver 2 Name ${_truck!.drv2Name}'),
                      Text('Driver 1 Home: ${_truck!.drv1Home}'),
                      Text('Driver 2 Home: ${_truck!.drv2Home}'),
                      Text('Driver Manager 1: ${_truck!.dmgr1}'),
                      Text('Driver Manager 2: ${_truck!.dmgr2}'),
                      Text('Order Number: ${_truck!.orderNumber}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _deleteTruck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete Truck'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _editTruck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Edit Truck'),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TruckCreatorScreen()),
                );
              },
              child: Text('Add Truck'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAllTruckNumbers,
              child: Text('Show All Truck Numbers'),
            ),
          ],
        ),
      ),
    );
  }
}

class TruckCreatorScreen extends StatefulWidget {
  final Truck? truck;

  TruckCreatorScreen({this.truck});

  @override
  _TruckCreatorScreenState createState() => _TruckCreatorScreenState();
}

class _TruckCreatorScreenState extends State<TruckCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  String _tracNumber = '';
  String _trlrNumber = '';
  String _licensePlate = '';
  String _last6Vin = '';
  String _status = 'A';
  String _drv1Code = '';
  String _drv1Name = '';
  String _drv2Code = '';
  String _drv2Name = '';
  String _drv1Home = '';
  String _drv2Home = '';
  String _dmgr1 = '';
  String _dmgr2 = '';
  String _orderNumber = '';
  String _orderCustomerCode = '';
  String _orderConsigneeCode = '';
  String _pta = '';

  @override
  void initState() {
    super.initState();
    if (widget.truck != null) {
      _tracNumber = widget.truck!.tracNumber;
      _trlrNumber = widget.truck!.trlrNumber;
      _licensePlate = widget.truck!.licensePlate;
      _last6Vin = widget.truck!.last6Vin;
      _status = widget.truck!.status;
      _drv1Code = widget.truck!.drv1Code;
      _drv1Name = widget.truck!.drv1Name;
      _drv2Code = widget.truck!.drv2Code;
      _drv2Name = widget.truck!.drv2Name;
      _drv1Home = widget.truck!.drv1Home;
      _drv2Home = widget.truck!.drv2Home;
      _dmgr1 = widget.truck!.dmgr1;
      _dmgr2 = widget.truck!.dmgr2;
      _orderNumber = widget.truck!.orderNumber;
      _pta = widget.truck!.pta;
    }
  }

  void _validateOrderNumber() async {
    if (_orderNumber.isNotEmpty) {
      final order = await OrderDatabase().getOrder(_orderNumber);
      if (order != null) {
        setState(() {
          _orderCustomerCode = order.custCode;
          _orderConsigneeCode = order.consCode;
        });
      } else {
        setState(() {
          _orderCustomerCode = '';
          _orderConsigneeCode = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order number does not exist!')),
        );
      }
    }
  }

  void _createTruck() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Truck newTruck = Truck(
        tracNumber: _tracNumber,
        trlrNumber: _trlrNumber,
        licensePlate: _licensePlate,
        last6Vin: _last6Vin,
        status: _status,
        drv1Code: _drv1Code,
        drv1Name: _drv1Name,
        drv2Code: _drv2Code,
        drv2Name: _drv2Name,
        drv1Home: _drv1Home,
        drv2Home: _drv2Home,
        dmgr1: _dmgr1,
        dmgr2: _dmgr2,
        orderNumber: _orderNumber,
        pta: _pta
      );
      if (widget.truck == null) {
        await TruckDatabase().insertTruck(newTruck);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Truck added successfully!')),
        );
      } else {
        await TruckDatabase().updateTruck(newTruck);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Truck updated successfully!')),
        );
      }
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.truck != null ? 'Edit Truck' : 'Create New Truck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Truck Number'),
                initialValue: _tracNumber,
                onSaved: (value) => _tracNumber = value ?? '',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
                enabled: widget.truck == null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Trailer Number'),
                initialValue: _trlrNumber,
                onSaved: (value) => _trlrNumber = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'License Plate'),
                initialValue: _licensePlate,
                onSaved: (value) => _licensePlate = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last 6 VIN'),
                initialValue: _last6Vin,
                onSaved: (value) => _last6Vin = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Status.'),
                initialValue: _status,
                onSaved: (value) => _status = value ?? 'A',
                validator: (value) => value!.isEmpty ? 'Required field' : null,
                enabled: widget.truck != null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Driver 1 Code'),
                initialValue: _drv1Code,
                onSaved: (value) => _drv1Code = value ?? '',
              ),
               TextFormField(
                decoration: InputDecoration(labelText: 'Driver 1 Name'),
                initialValue: _drv1Name,
                onSaved: (value) => _drv1Name = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Driver 2 Code'),
                initialValue: _drv2Code,
                onSaved: (value) => _drv2Code = value ?? '',
              ),
               TextFormField(
                decoration: InputDecoration(labelText: 'Driver 2 Name'),
                initialValue: _drv2Name,
                onSaved: (value) => _drv2Name = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Driver 1 Home'),
                initialValue: _drv1Home,
                onSaved: (value) => _drv1Home = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Driver 2 Home'),
                initialValue: _drv2Home,
                onSaved: (value) => _drv2Home = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Driver Manager 1'),
                initialValue: _dmgr1,
                onSaved: (value) => _dmgr1 = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Driver Manager 2'),
                initialValue: _dmgr2,
                onSaved: (value) => _dmgr2 = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Order Number'),
                initialValue: _orderNumber,
                onChanged: (value) {
                  _orderNumber = value;
                  _validateOrderNumber();
                },
                onSaved: (value) => _orderNumber = value ?? '',
              ),
              SizedBox(height: 10),
              if (_orderCustomerCode.isNotEmpty && _orderConsigneeCode.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer Code: $_orderCustomerCode'),
                    Text('Consignee Code: $_orderConsigneeCode'),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTruck,
                child: Text(widget.truck != null ? 'Update Truck' : 'Create Truck'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}