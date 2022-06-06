import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnclaw_mobile_application/blocs/user/user_bloc.dart';
import 'package:pawnclaw_mobile_application/common/components/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) => (state is UserUpdated)
            ? Scaffold(
                appBar: AppBar(title: Text('Profile')),
                body: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Name:' + state.user.name!),
                      Text('Email: ' + state.user.email!),
                      Text('Phone: ' + state.user.phone!)
                    ],
                  ),
                ),
              )
            : LoadingIndicator(loadingText: 'Vui lòng chờ'));
  }
}
