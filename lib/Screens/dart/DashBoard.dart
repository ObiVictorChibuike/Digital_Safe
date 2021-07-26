import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safe/Models/Contact.dart';
import 'package:safe/Utils/dart/database_helper.dart';
import 'package:safe/Widgets/Constants.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlNumber = TextEditingController();
  final _ctrlAmount = TextEditingController();
  final _ctrlDeposit = TextEditingController();
  final _ctrlWithDraw = TextEditingController();
  dynamic addAmount;
  dynamic changeAmount;
  dynamic withdrawAmount;

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
    _clearForm();
    Navigator.of(context).pop();
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  _clearForm() {
    setState(() {
      _formKey.currentState;
      _ctrlName.clear();
      _ctrlAmount.clear();
      _ctrlNumber.clear();
      _ctrlDeposit.clear();
      _ctrlWithDraw.clear();
      _contact.id = null;
    });
  }

  _refreshList() async {
    List<Contact> ref = await _dataBaseHelper.fetchContact();
    setState(() {
      _contacts = ref;
    });
  }

  DataBaseHelper _dataBaseHelper;
  List _contacts = [];
  Contact _contact = Contact();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataBaseHelper = DataBaseHelper.instance;
      _refreshList();
    });
  }

  _onAddAmount() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      await _dataBaseHelper.updateContact(_contact);
      _clearForm();
      Navigator.of(context).pop();
    }
  }

  _onRemoveAmount() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      await _dataBaseHelper.updateContact(_contact);
      _clearForm();
      Navigator.of(context).pop();
    }
  }

  _onInitialSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_contact.id == null)
        await _dataBaseHelper.insertContact(_contact);
      else
        await _dataBaseHelper.updateContact(_contact);
      _refreshList();
      _clearForm();
      Navigator.of(context).pop();
    }
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              color: Colors.blue.shade50,
              height: MediaQuery.of(context).size.height * .70,
              width: MediaQuery.of(context).size.width * .5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        alignment: Alignment.topRight,
                      ),
                      Text(
                        "Add Customer Details",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: BluePrimaryColor,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: _ctrlName,
                            cursorHeight: 25,
                            cursorWidth: 2,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: BluePrimaryColor,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                isDense: true,
                                labelText: 'Full Name',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 11)),
                            onSaved: (val) =>
                                setState(() => _contact.name = val),
                            validator: (val) => (val.length == 0
                                ? 'This field is required'
                                : null),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _ctrlAmount,
                            cursorHeight: 25,
                            cursorWidth: 2,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: BluePrimaryColor,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                isDense: true,
                                labelText: 'Amount',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 11)),
                            validator: (val) => (val.length < 3
                                ? 'least amount required is #100'
                                : null),
                            onSaved: (val) =>
                                setState(() => _contact.amount = val),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _ctrlNumber,
                            cursorHeight: 25,
                            cursorWidth: 2,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: BluePrimaryColor,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                isDense: true,
                                labelText: 'Mobile Number',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 11)),
                            onSaved: (val) =>
                                setState(() => _contact.mobile = val),
                            validator: (val) => (val.length < 11
                                ? 'A Valid Phone Number is Required'
                                : null),
                          ),
                        ]),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.maxFinite,
                        child: MaterialButton(
                          onPressed: () {
                            _onInitialSubmit();
                            Fluttertoast.showToast(
                                msg: "Account Created Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2);
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          color: BluePrimaryColor,
                          textColor: Colors.white,
                          elevation: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void showEditAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              color: Colors.blue.shade50,
              height: MediaQuery.of(context).size.height * .60,
              width: MediaQuery.of(context).size.width * .5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                        ),
                        onPressed: () {},
                        alignment: Alignment.topRight,
                      ),
                      Text(
                        "Edit Customer Details",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: BluePrimaryColor,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: _ctrlName,
                            cursorHeight: 25,
                            cursorWidth: 2,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: BluePrimaryColor,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                isDense: true,
                                labelText: 'Full Name',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 11)),
                            onSaved: (val) =>
                                setState(() => _contact.name = val),
                            validator: (val) => (val.length == 0
                                ? 'This field is required'
                                : null),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _ctrlNumber,
                            cursorHeight: 25,
                            cursorWidth: 2,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: BluePrimaryColor,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide:
                                      BorderSide(color: BluePrimaryColor),
                                ),
                                isDense: true,
                                labelText: 'Mobile Number',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins', fontSize: 11)),
                            onSaved: (val) =>
                                setState(() => _contact.mobile = val),
                            validator: (val) => (val.length < 11
                                ? 'A Valid Phone Number is Required'
                                : null),
                          ),
                        ]),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.maxFinite,
                        child: MaterialButton(
                          onPressed: _onInitialSubmit,
                          child: Text(
                            "Update",
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          color: BluePrimaryColor,
                          textColor: Colors.white,
                          elevation: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _list() => Center(
        child: ListView.builder(
            itemCount: _contacts.length,
            //_items.length,
            itemBuilder: (context, index) {
              //Contact contact = Contact.fromMap(_items[index]);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue.shade100,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "CUSTOMER DETAILS.",
                        style: TextStyle(
                          fontSize: 14,
                          color: BluePrimaryColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        color: BluePrimaryColor,
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                child: Column(
                                  children: [
                                    InkWell(
                                      child: Center(
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 32,
                                            child: Icon(
                                              Icons.person_add_rounded,
                                              size: 35,
                                              color: BluePrimaryColor,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: 'NAME:  ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: BluePrimaryColor,
                                        letterSpacing: 1,
                                        fontFamily: 'Poppins',
                                      ),
                                      children: [
                                    TextSpan(
                                        text: //'${contact.name}',
                                            _contacts[index].name,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: BluePrimaryColor,
                                          fontFamily: 'Poppins',
                                        ))
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      text: 'AMOUNT:  ₦ ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: BluePrimaryColor,
                                        letterSpacing: 1,
                                        fontFamily: 'Poppins',
                                      ),
                                      children: [
                                    TextSpan(
                                        text: //'${contact.amount}',
                                            _contacts[index].amount,
                                        style: TextStyle(
                                          color: BluePrimaryColor,
                                          fontSize: 10,
                                          fontFamily: 'Poppins',
                                        ))
                                  ])),
                              RichText(
                                  text: TextSpan(
                                      text: 'MOBILE:  ',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: BluePrimaryColor,
                                        letterSpacing: 1,
                                        fontFamily: 'Poppins',
                                      ),
                                      children: [
                                    TextSpan(
                                        text: //'${contact.mobile}',
                                            _contacts[index].mobile,
                                        style: TextStyle(
                                            color: BluePrimaryColor,
                                            fontSize: 10,
                                            fontFamily: 'Poppins'))
                                  ])),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: BluePrimaryColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.add_box,
                                color: BluePrimaryColor,
                                size: 15,
                              ),
                              tooltip: 'Deposit',
                              onPressed: () {
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0)), //this right here
                                        child: Container(
                                          color: Colors.blue.shade50,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.clear,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    alignment:
                                                        Alignment.topRight,
                                                  ),
                                                  Text(
                                                    "Deposit",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: BluePrimaryColor,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Form(
                                                    key: _formKey,
                                                    child: Column(children: [
                                                      TextFormField(
                                                        controller:
                                                            _ctrlDeposit,
                                                        cursorHeight: 25,
                                                        cursorWidth: 2,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        cursorColor:
                                                            BluePrimaryColor,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration:
                                                            InputDecoration(
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              BluePrimaryColor),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              BluePrimaryColor),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              BluePrimaryColor),
                                                                ),
                                                                isDense: true,
                                                                labelText:
                                                                    'Amount',
                                                                labelStyle: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        11)),
                                                        onSaved: (val) =>
                                                            setState(() =>
                                                                _contact.amount =
                                                                    val),
                                                        validator: (val) => (val
                                                                    .length <
                                                                3
                                                            ? 'least amount required is #100'
                                                            : null),
                                                      ),
                                                    ]),
                                                  ),
                                                  SizedBox(height: 20),
                                                  SizedBox(
                                                    height: 45,
                                                    width: double.maxFinite,
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          changeAmount =
                                                              int.parse(
                                                                  _contacts[
                                                                          index]
                                                                      .amount);
                                                          addAmount =
                                                              changeAmount +
                                                                  int.parse(
                                                                      _ctrlDeposit
                                                                          .text);
                                                          _contacts[index]
                                                                  .amount =
                                                              '$addAmount';
                                                          _contact =
                                                              _contacts[index];
                                                        });
                                                        String message =
                                                            "*******DIGITAL SAFE*******\n ********CREDIT ALERT********\n"
                                                            "NAME: ${_contact.name}\n AMOUNT DEPOSITED: ₦ ${_ctrlDeposit.text}\nBALANCE: ₦ ${_contact.amount}";
                                                        List<String> recipents =
                                                            [
                                                          _contacts[index]
                                                              .mobile
                                                        ];
                                                        _sendSMS(
                                                            message, recipents);
                                                        _onAddAmount();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Deposit Successful",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                2);
                                                      },
                                                      child: Text(
                                                        "Add",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      color: BluePrimaryColor,
                                                      textColor: Colors.white,
                                                      elevation: 10,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: BluePrimaryColor,
                                size: 15,
                              ),
                              tooltip: 'Withdrawal',
                              onPressed: () {
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0)), //this right here
                                        child: Container(
                                          color: Colors.blue.shade50,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.clear,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    alignment:
                                                        Alignment.topRight,
                                                  ),
                                                  Text(
                                                    "Withdrawal",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: BluePrimaryColor,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Form(
                                                    key: _formKey,
                                                    child: Column(children: [
                                                      TextFormField(
                                                        controller:
                                                            _ctrlWithDraw,
                                                        cursorHeight: 25,
                                                        cursorWidth: 2,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        cursorColor:
                                                            BluePrimaryColor,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration:
                                                            InputDecoration(
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              BluePrimaryColor),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              BluePrimaryColor),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              BluePrimaryColor),
                                                                ),
                                                                isDense: true,
                                                                labelText:
                                                                    'Amount',
                                                                labelStyle: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        11)),
                                                        onSaved: (val) =>
                                                            setState(() =>
                                                                _contact.amount =
                                                                    val),
                                                        validator: (val) => (val
                                                                    .length <
                                                                3
                                                            ? 'least amount required is #100'
                                                            : null),
                                                      ),
                                                    ]),
                                                  ),
                                                  SizedBox(height: 20),
                                                  SizedBox(
                                                    height: 45,
                                                    width: double.maxFinite,
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        if (int.parse(
                                                                _ctrlWithDraw
                                                                    .text) >
                                                            int.parse(
                                                                _contacts[index]
                                                                    .amount)) {
                                                          return _showSnackBar(
                                                              "Insufficient Fund");
                                                        } else
                                                          setState(() {
                                                            changeAmount = int
                                                                .parse(_contacts[
                                                                        index]
                                                                    .amount);
                                                            withdrawAmount =
                                                                changeAmount -
                                                                    int.parse(
                                                                        _ctrlWithDraw
                                                                            .text);
                                                            _contacts[index]
                                                                    .amount =
                                                                '$withdrawAmount';
                                                            _contact =
                                                                _contacts[
                                                                    index];
                                                            String message =
                                                                "*******DIGITAL SAFE*******\n ********DEBIT ALERT********\n"
                                                                "NAME: ${_contact.name}\n AMOUNT DEBITED: ₦ ${_ctrlWithDraw.text}\nBALANCE: ₦ ${_contact.amount}";
                                                            List<String>
                                                                recipents = [
                                                              _contacts[index]
                                                                  .mobile
                                                            ];
                                                            _sendSMS(message,
                                                                recipents);
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Withdrawal Successful",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                timeInSecForIosWeb:
                                                                    2);
                                                          });
                                                        _onRemoveAmount();
                                                      },
                                                      child: Text(
                                                        "Withdraw",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      color: BluePrimaryColor,
                                                      textColor: Colors.white,
                                                      elevation: 10,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: BluePrimaryColor,
                                size: 15,
                              ),
                              tooltip: 'Withdrawal',
                              onPressed: () {
                                showEditAlertDialog(context);
                                setState(() {
                                  _contact = _contacts[index];
                                  _ctrlName.text = _contacts[index].name;
                                  _ctrlNumber.text = _contacts[index].mobile;
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: BluePrimaryColor,
                                size: 15,
                              ),
                              tooltip: 'Delete',
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.blue.shade100,
                                    title: Text(
                                      "Delete Contact Details",
                                      style: TextStyle(
                                        color: BluePrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      "Are you sure you want this customer's details deleted?",
                                      style: TextStyle(
                                        color: BluePrimaryColor,
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "CANCEL",
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          await _dataBaseHelper.deleteContact(
                                              _contacts[index].id);
                                          _refreshList();
                                          Navigator.of(context).pop();
                                          String message =
                                              "*******DIGITAL SAFE*******\n **ACCOUNT REMOVAL**\n"
                                              "Dear ${_contacts[index].name}, this is to notify you that your account has been Successfully Removed.\nThank you for your Patronage and We wish you all the best.";
                                          List<String> recipents = [
                                            _contacts[index].mobile
                                          ];
                                          _sendSMS(message, recipents);
                                          Fluttertoast.showToast(
                                              msg: "Delete Successful",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 2);
                                        },
                                        child: Text(
                                          "CONTINUE",
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          "...Guarantee and Trust.",
                          style: TextStyle(
                              fontSize: 10,
                              color: BluePrimaryColor,
                              fontFamily: 'Poppins'),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      );

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text(
    "DashBoard",
    style: TextStyle(fontFamily: 'Poppins'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: BluePrimaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: cusSearchBar,
          titleSpacing: 40.0,
          leading: Icon(Icons.menu),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  icon: cusIcon,
                  onPressed: () {
                    setState(() {
                      if (this.cusIcon.icon == Icons.search) {
                        this.cusIcon = Icon(Icons.cancel);
                        this.cusSearchBar = TextField(
                          cursorHeight: 25,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      } else {
                        this.cusIcon = Icon(Icons.search);
                        this.cusSearchBar = Text(
                          "DashBoard",
                          style: TextStyle(fontFamily: 'Poppins'),
                        );
                      }
                    });
                  }),
            )
          ],
          centerTitle: false,
          elevation: 5,
        ),
        body: FutureBuilder<List<Contact>>(
            future: DataBaseHelper.instance.fetchContact(),
            initialData: List(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty)
                return Center(
                  child: Text(
                    "No Records Found!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              else
                return _list();
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: BluePrimaryColor,
          tooltip: 'Add Persons',
          child: Icon(
            Icons.person_add_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      )),
    );
  }
}
