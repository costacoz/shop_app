import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/models/http_exception.dart';
import 'package:shop_flutter_app/providers/auth.dart';
import 'package:shop_flutter_app/screens/products_overview_screen.dart';
import 'package:shop_flutter_app/widgets/snackbar_simple.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 70.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'TheShop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.headline6?.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  /// Error messages
  static const ERROR_EMAIL_EXISTS = 'The user with such email already exists!';
  static const ERROR_INVALID_PASSWORD = 'The password is invalid!';
  static const ERROR_USER_DISABLED = 'This account was disabled!';
  static const ERROR_OPERATION_NOT_ALLOWED = 'Something went wrong, please try again later.';
  static const ERROR_EMAIL_NOT_FOUND = 'Email with such email not found.';

  /// Animation intended variables
  AnimationController? _controller; // like a "player" for animation
  late Animation<Offset> _slideAnimation; // animation itself
  late Animation<double> _opacityAnimation;
  static const double heightAnimationStart = 260;
  static const double heightAnimationEnd = 320;

  @override
  void initState() {
    super.initState();

    /// 'this' made possible to access after adding SingleTickerProviderStateMixin mixin
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300)); //-- for how long to animate
    _slideAnimation = Tween<Offset>(
      // what to animate
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      // how to split animation time (curve)
      parent: _controller!, // the animation "player" to which this CurvedAnimation will be applied to
      curve: Curves.linear, // type of animation
    ));
    // _heightAnimation.addListener(() => setState(() {})); // approach of manually managing animation
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void setLoading(state) => setState(() => _isLoading = state);

  void setAuthMode(mode) => setState(() => _authMode = mode);

  Future<void> _submit() async {
    var errorMessage;
    if (!(_formKey.currentState?.validate() ?? false)) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();
    setLoading(true);
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).signin(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false).signup(_authData['email']!, _authData['password']!);
      }
      // Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
    } on HttpException catch (e) {
      errorMessage = 'Authentication failed';
      switch (e.message.toString()) {
        case 'EMAIL_EXISTS':
          errorMessage = ERROR_EMAIL_EXISTS;
          break;
        case 'INVALID_PASSWORD':
          errorMessage = ERROR_INVALID_PASSWORD;
          break;
        case 'USER_DISABLED':
          errorMessage = ERROR_USER_DISABLED;
          break;
        case 'OPERATION_NOT_ALLOWED':
          errorMessage = ERROR_OPERATION_NOT_ALLOWED;
          break;
        case 'EMAIL_NOT_FOUND':
          errorMessage = ERROR_EMAIL_NOT_FOUND;
          break;
        default:
          throw Exception('HttpException thrown, but not corresponding to set of handled ones.');
      }
    } catch (e) {
      errorMessage = 'Generic error. Couldn not authenticate.';
      print(e);
    } finally {
      _showErrorSnackBar(errorMessage);
    }
    setLoading(false);
  }

  void _showErrorSnackBar(errorMessage) {
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarSimple(
        text: errorMessage,
        color: Colors.red,
        iconData: Icons.error,
      ));
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setAuthMode(AuthMode.Signup);
      _controller?.forward();
    } else {
      setAuthMode(AuthMode.Login);
      _controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child:

          /// Automatic animation approach:
          // AnimatedBuilder(
          //   animation: _heightAnimation,
          //   builder: (ctx, ch) => Container(...)
          AnimatedContainer(
        height: _authMode == AuthMode.Signup ? heightAnimationEnd : heightAnimationStart,
        // height: _heightAnimation.value.height, // for semi-automatic animation
        // constraints: BoxConstraints(minHeight: _heightAnimation.value.height),
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? heightAnimationEnd : heightAnimationStart),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        curve: Curves.linear,
        duration: Duration(milliseconds: 300),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(color: Theme.of(context).primaryTextTheme.button?.color),
                    ),
                  ),
                FlatButton(
                  child: Text('${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
