import 'package:DTUOTG/providers/info_provider.dart';
import 'package:DTUOTG/providers/server_connection_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class InviteScreen extends StatefulWidget {
  static const routeName = "inviteScreen";
  InviteScreen({Key key}) : super(key: key);

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  bool waiting = false;
  bool respCame = false;
  var resp;
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('invite friends'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Padding(
                child: CupertinoTextFormFieldRow(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  controller: email,
                  //   restorationId: 'email',
                  placeholder: 'email',
                  keyboardType: TextInputType.name,
                  // clearButtonMode: OverlayVisibilityMode.editing,
                  obscureText: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'enter email';
                    }
                  },
                ),
                padding:
                    EdgeInsets.only(left: 22, top: 0, bottom: 20, right: 22),
              ),
            ),
            if (respCame) Text(resp.toString()),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    respCame = false;
                    waiting = true;
                  });
                  var scf =
                      Provider.of<Server_Connection_Functions_globalObject>(
                              context,
                              listen: false)
                          .serverConnectionFunctions;
                  resp = await scf.invite(
                    email.text,
                  );
                  setState(() {
                    waiting = false;
                    respCame = true;
                  });
                },
                child: waiting
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                      )
                    : Text('invite'))
          ],
        ),
      ),
    );
  }
}
