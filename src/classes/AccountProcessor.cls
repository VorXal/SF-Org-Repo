public class AccountProcessor {
    @future
    public static void countContacts(List<Id> AccountIds){
        List<Account> accountList = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id in :AccountIds];
        List<Contact> contactList = [SELECT AccountId FROM Contact WHERE AccountId in :AccountIds];
        for(Account acc : accountList){
            Integer count = 0;
            for(Contact c : contactList){
                if(c.AccountId == acc.Id){
                    count++;
                }
            }
            acc.Number_of_Contacts__c = count;
        }
    }
}