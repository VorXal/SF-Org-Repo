public class productTriggerHelper {
	private static Boolean flag = true;
    
    public static void changeFlag(){
        flag = !flag;
    }
    
    public static Boolean getFlagValue(){
        return flag;
    }
}