trigger onceFiredProductTrigger on Product2 (before insert) {
   if(productTriggerHelper.getFlagValue() == true){
          productTriggerHelper.changeFlag();
          System.debug('Once');
    }
}