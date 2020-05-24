import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literature/utils/card_previewer.dart';
import 'package:literature/utils/game_communication.dart';

class CustomDialog extends StatefulWidget {
  final String askingTo, whoAsked, buttonText, roomId;
  final Image image;
  final Function cb;

  CustomDialog({
    @required this.askingTo,
    @required this.whoAsked,
    @required this.buttonText,
    this.image,
    @required this.roomId,
    @required this.cb
  });

  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  // Initial state variables
  // that map to card previewer.
  String cardType = 'ace';
  String cardSuit = 'hearts';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    var containerHeight = MediaQuery.of(context).size.height;
    var containerWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        //...bottom card part,
        //...top circlular image part,
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          height: containerHeight*0.587,
          width: containerWidth*0.821,
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "You are asking a card to " + widget.askingTo + ".",
                style: TextStyle(
                  fontSize: containerWidth*0.058,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: containerHeight*0.0188),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton<String>(
                    value: cardType,
                    onChanged: (String newValue) {
                      setState(() {
                        cardType = newValue;
                      });
                    },
                    items: <String>[
                      "ace",
                      "two",
                      "three",
                      "four",
                      "five",
                      "six",
                      "eight",
                      "nine",
                      "ten",
                      "jack",
                      "queen",
                      "king"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: cardSuit,
                    onChanged: (String newValue) {
                      setState(() {
                        cardSuit = newValue;
                      });
                    },
                    items: <String>[
                      "spades",
                      "hearts",
                      "diamonds",
                      "clubs",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  RaisedButton(
                    onPressed: () {
                      // Ask for the particular card,
                      // send message on socket to server.
                      Map cardAskingDetails = { 
                        "cardSuit": cardSuit,
                        "cardType": cardType,
                        "askingTo": widget.askingTo,
                        "whoAsked": widget.whoAsked,
                        "roomId": widget.roomId
                      };
                      // Closes the dialog.
                      widget.cb();
                      game.send("card_asking_event", json.encode(cardAskingDetails));
                    },
                    child: Text(widget.buttonText),
                  ),
                ]
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: new CardPreviewer(cardSuit: cardSuit, cardType: cardType),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}