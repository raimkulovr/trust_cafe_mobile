import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoginPrompt extends StatefulWidget {
  const LoginPrompt({
    required this.onAuthenticationRequest,
    this.scrollController,
    super.key,
  });

  final ScrollController? scrollController;
  final void Function(BuildContext context) onAuthenticationRequest;
  @override
  State<LoginPrompt> createState() => _LoginPromptState();
}

class _LoginPromptState extends State<LoginPrompt> {
  final TapGestureRecognizer _tapRecognizer = TapGestureRecognizer();
  late final ScrollController? _scrollController;

  bool showPrompt = true;

  @override
  void initState() {
    _scrollController = widget.scrollController;
    _scrollController?.addListener(_scrollControllerListener);
    super.initState();
  }

  void _scrollControllerListener() {
    if (_scrollController!.position.userScrollDirection == ScrollDirection.forward &&
        _scrollController.position.pixels >= 100 ||
        _scrollController.position.pixels < 100) {
      switchShowPrompt(true);
    } else {
      switchShowPrompt(false);
    }
  }

  void switchShowPrompt(bool newValue) {
    if (newValue!=showPrompt){
      setState(() {
        showPrompt = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.blueAccent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      height: showPrompt ? 50 : 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'You are currently browsing as a guest. ',
              // style: TextStyle(color: Colors.w,),
              children: [
                TextSpan(
                  text: 'Login or register',
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600
                  ),
                  recognizer: _tapRecognizer
                    ..onTap = () {
                      widget.onAuthenticationRequest(context);
                    },
                ),
                const TextSpan(
                  text: ' to post and comment.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    _scrollController?.removeListener(_scrollControllerListener);
    _scrollController?.dispose();
    super.dispose();
  }
}
