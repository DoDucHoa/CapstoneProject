import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/transaction/transaction_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';
import 'package:pawnclaw_mobile_application/common/constants.dart';
import 'package:pawnclaw_mobile_application/repositories/transaction/transaction_repository.dart';
import 'package:pawnclaw_mobile_application/screens/transaction_screen/components/transaction_card.dart';

import '../../../blocs/authentication/auth_bloc.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var account;

  @override
  void initState() {
    var authState = BlocProvider.of<AuthBloc>(context).state as Authenticated;
    account = authState.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (context) => TransactionBloc()..add(GetTransactions(account)),
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: const Text('Đơn hàng'),
              backgroundColor: backgroundColor,
              foregroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                    return state is TransactionLoaded
                        ? Padding(
                            padding: EdgeInsets.all(width * smallPadRate),
                            child: ListView.separated(
                              itemBuilder: ((context, index) => TransactionCard(
                                    booking: state.transactions[index],
                                    size: 180,
                                  )),
                              separatorBuilder: ((context, index) =>
                                  const SizedBox(
                                    height: 15,
                                  )),
                              itemCount: state.transactions.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                            ))
                        :Container(height: height, child: LoadingIndicator(loadingText: 'Đang tải đơn hàng')
                          
                        );
                  })
                ],
              ),
            )));
  }

  Widget buildFilterBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(children: [
        
      ],),
    );
  }

  Widget buildFilterButton(Icon icon, String text){
    return Container();
  }
}
