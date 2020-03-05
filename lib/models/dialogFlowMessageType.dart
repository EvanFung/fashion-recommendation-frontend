import 'package:flutter/material.dart';

//check the message type of different message from dialogflow
class DialogFlowMessageType {
  String type;
  DialogFlowMessageType(Map message) {
    if (message.containsKey('card')) {
      this.type = 'card';
    }
    if (message.containsKey('basicCard')) {
      this.type = 'basicCard';
    }
    if (message.containsKey('simpleResponses')) {
      this.type = 'simpleResponses';
    }
    if (message.containsKey('carouselSelect')) {
      this.type = 'carouselSelect';
    }
    if (message.containsKey('text')) {
      this.type = 'text';
    }
    if (message.containsKey('quickReplies')) {
      this.type = 'quickReplies';
    }
  }
}
