/**
 * Created by Aleksei on 13.03.2021.
 */

global class ScheduleBatches implements Schedulable{
    global void execute(SchedulableContext sc){
        UpdateAccountByContact updateAccountByContact = new UpdateAccountByContact(
        [SELECT Id, BillingCity, BillingLatitude, BillingLongitude, BillingCountry,
                BillingPostalCode, BillingState, BillingStreet,
        (SELECT Id FROM Contacts) FROM Account]);

        UpdateAccountByTask updateAccountByTask = new UpdateAccountByTask();

        Database.executeBatch(updateAccountByTask, 200);
        Database.executeBatch(updateAccountByContact, 200);
    }
}