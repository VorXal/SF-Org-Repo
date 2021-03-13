/**
 * Created by Aleksei on 13.03.2021.
 */

public with sharing class QueuebleJob implements Queueable{

    public void execute(QueueableContext context) {
        List<Account> query = [SELECT Id, BillingAddress,
        (SELECT Id, IsSynced__c, Processed_By_Queue__c FROM Contacts) FROM Account];

        List<Contact> contactsToUpdate = new List<Contact>();
        for(Account acc : query){
            if(acc.BillingAddress != null){
                for (Contact contact: acc.Contacts){
                    contact.IsSynced__c = false;
                    contact.Processed_By_Queue__c = true;
                    contactsToUpdate.add(contact);
                }
            }
        }

        update contactsToUpdate;
    }
}