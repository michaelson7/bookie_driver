import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';

import '../../../../model/core/DriverStatsModel.dart';
import '../../../../model/core/UserDataModel.dart';
import '../../../../provider/DriverProvider.dart';
import '../../../constants/constants.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/toast.dart';

class DriverWallet extends StatefulWidget {
  static String id = "DriverWallet";
  const DriverWallet({Key? key}) : super(key: key);

  @override
  _DriverWalletState createState() => _DriverWalletState();
}

class _DriverWalletState extends State<DriverWallet> {
  var _provider = DriverProvider();
  var registrationProvider = RegistrationProvider();

  bool isLoading = true;
  DriverStatsModel? driverStatsModel;
  UserDataModel? userDataModel;
  double price = 0.0, balance = 0.0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    driverStatsModel = await _provider.getDriverStats();
    var data = await registrationProvider.getUserId();

    setState(() {
      userDataModel = UserDataModel.fromJson(
        data.data!,
      );
      balance = double.parse(driverStatsModel?.availableBalance ?? "0");
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Wallet",
        color: kAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildSingleChildScrollView(),
    );
  }

  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text("Total Value", style: kTextStyleHeader1),
            SizedBox(height: 10),
            Text(
              "ZMW ${balance}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  openPaymentDialog();
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("Deposit Funds"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> initPayment() async {
    String currency = FlutterwaveCurrency.ZMW;
    var refrence = DateTime.now().millisecondsSinceEpoch.toString();
    Flutterwave flutterwave = Flutterwave.forUIPayment(
      context: this.context,
      encryptionKey: "FLWSECK_TESTa83747c7397c",
      publicKey: "FLWPUBK_TEST-a57bd9375b9aa5bf9422064fc04521bf-X",
      currency: currency,
      amount: price.toString(),
      email: "${userDataModel?.me?.email}",
      fullName:
          "${userDataModel?.me?.firstName} ${userDataModel?.me?.lastName}",
      txRef: refrence,
      isDebugMode: true,
      phoneNumber: "${userDataModel?.me?.phoneNumber}",
      acceptCardPayment: true,
      acceptUSSDPayment: true,
      acceptAccountPayment: false,
      acceptZambiaPayment: true,
    );

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        toastMessage(context: context, message: "ERROR; no response");
        makeDeposit();
      } else {
        final isSuccessful = checkPaymentIsSuccessful(
          response: response,
          amount: price.toString(),
          currency: currency,
          txref: refrence,
        );
        if (isSuccessful) {
          toastMessage(context: context, message: "Payment Successful");
          makeDeposit();
        } else {
          toastMessage(context: context, message: "ERROR; ${response.message}");
        }
      }
    } catch (error) {
      loggerError(message: error.toString());
    }
  }

  bool checkPaymentIsSuccessful({
    required ChargeResponse response,
    required currency,
    required amount,
    required txref,
  }) {
    return response.data?.status == FlutterwaveConstants.SUCCESSFUL;
  }

  void openPaymentDialog() {
    var width = MediaQuery.of(context).size.width;
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            /// backgroundColor: Colors.red,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.account_balance_wallet,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: kBorderRadiusCircular,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Text(
                            'Deposit funds into wallet',
                            style: kTextStyleHeader2,
                          ),
                          SizedBox(height: 4),
                          const Text(
                            "Please enter amount to deposit into your account",
                            style: kTextStyleHint,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]+')),
                            ],
                            onChanged: (text) {
                              setState(() {
                                price = double.parse(text);
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Deposit Amount",
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (price <= 10) {
                                      toastMessage(
                                        context: context,
                                        message:
                                            "Please enter amount greater than 10 kwatcha",
                                      );
                                    } else {
                                      initPayment();
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kAccent,
                                      borderRadius: kBorderRadiusCircularPro,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Deposit",
                                        textAlign: TextAlign.center,
                                        style: kTextStyleWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> makeDeposit() async {
    var response = await _provider.depositDriverFunds(
      driverId: "${userDataModel?.me?.driverSet?.first.id}",
      amount: price.toString(),
    );
    setState(() {
      balance = balance + price;
    });
    toastMessage(context: context, message: "Funds Successfully Deposited");
  }
}
