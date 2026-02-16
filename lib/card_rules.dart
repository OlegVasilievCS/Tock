class CardRules {

  int? executeCardMovement(String cardValue){
    if(cardValue.contains('2')){
      return 2;
    }
    else if(cardValue.contains('3')){
      return 3;
    }
    else if(cardValue.contains('4')){
      return -4;
    }
    else if(cardValue.contains('5')){
      return 5;
    }
    else if(cardValue.contains('6')){
      return 6;
    }
    else if(cardValue.contains('7')){
      return 7;
    }
    else if(cardValue.contains('8')){
      return 8;
    }
    else if(cardValue.contains('9')){
      return 9;
    }
    else if(cardValue.contains('10')){
      return 10;
    }
    else if(cardValue.contains('jack')){
      return 11;
    }
    if(cardValue.contains('queen')){
      return 12;
    }
    else if(cardValue.contains('king')){
      return 13;
    }
    else if(cardValue.contains('ace')){
      return 1;
    }
    return 0;
  }


}