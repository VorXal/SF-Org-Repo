/**
 * Created by Aleksei on 10.03.2021.
 */

public with sharing class UpdateSyncStatus implements Queueable{
    private List<Id> accountsIds = new List<Id>();
    private Map<Id, Account> oldMap;
    private Map<Id, Account> newMap;

    private static Boolean checkUpdateBillingAdress(String oldCity, String oldCountry,
            String oldGeocode, Decimal oldLatitude, Decimal oldLongitude,
            String oldPostalCode, String oldState, String oldStreet, String newCity,
            String newCountry, String newGeocode, Decimal newLatitude, Decimal newLongitude,
            String newPostalCode, String newState, String newStreet){
        return (
                (oldCity != newCity)
                        || (oldCountry != newCountry)
                        || (oldGeocode != newGeocode)
                        || (oldLatitude != newLatitude)
                        || (oldLongitude != newLongitude)
                        || (oldPostalCode != newPostalCode)
                        || (oldState != newState)
                        || (oldStreet != newStreet)
        );

    }

    public void execute(QueueableContext context){
        List<Contact> contactList = [SELECT Id,AccountId FROM Contact WHERE AccountId IN :accountsIds];

        for(Id accId : accountsIds){
            Account oldAccount = oldMap.get( accId );
            Account newAccount = newMap.get( accId );

            Boolean isAdressChanged = checkUpdateBillingAdress(
                    oldAccount.BillingCity, oldAccount.BillingCountry,
                    oldAccount.BillingGeocodeAccuracy, oldAccount.BillingLatitude,
                    oldAccount.BillingLongitude, oldAccount.BillingPostalCode,
                    oldAccount.BillingState, oldAccount.BillingStreet,
                    newAccount.BillingCity, newAccount.BillingCountry,
                    newAccount.BillingGeocodeAccuracy, newAccount.BillingLatitude,
                    newAccount.BillingLongitude, newAccount.BillingPostalCode,
                    newAccount.BillingState, newAccount.BillingStreet
            );

            if(isAdressChanged){
                for(Contact contact : contactList){
                    if(contact.AccountId == accId){
                        contact.IsSynced__c = false;
                        contact.Processed_By_Queue__c = true;
                    }
                }
            }
        }

        update contactList;
    }


    public UpdateSyncStatus(List<Account> accountList){
        for(Account acc : accountList){
            this.accountsIds.add(acc.Id);
        }
        this.oldMap = (Map<Id, Account>) Trigger.oldMap;
        this.newMap = (Map<Id, Account>) Trigger.newMap;
    }
}