public with sharing class productTriggerHelper {
    @TestVisible private static Boolean flag = true;
    
    public static void changeFlag(){
        flag = !flag;
    }
    
    public static Boolean getFlagValue(){
        return flag;
    }
}