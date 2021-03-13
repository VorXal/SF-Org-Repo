/**
 * Created by Aleksei on 13.03.2021.
 */

public with sharing class UpdateContactsByAccount {

    @Future
    public static void updateContacts(){
        List<Account> query = [SELECT Id, BillingAddress,
                                (SELECT Id, IsSynced__c, Processed_By_Future__c FROM Contacts) FROM Account LIMIT 150];

        List<Contact> contactsToUpdate = new List<Contact>();
        for(Account acc : query){
            if(acc.BillingAddress != null){
                for (Contact contact: acc.Contacts){
                    contact.IsSynced__c = false;
                    contact.Processed_By_Future__c = true;
                    contactsToUpdate.add(contact);
                }
            }
        }

        update contactsToUpdate;
    }
}