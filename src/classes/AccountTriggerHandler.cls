/**
 * Created by Aleksei on 10.03.2021.
 */

public with sharing class AccountTriggerHandler {

    private Boolean m_isExecuting = false;
    private Integer BatchSize = 0;
    public static Boolean IsFromBachJob ;
    public static Boolean isFromUploadAPI = false;

    public AccountTriggerHandler(Boolean isExecuting, Integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    @Future
    public static void createNewTask(List<Id> accountIds){
        List<Account> accountList = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        List<Task> tasksList = new List<Task>();
        for(Account acc : accountList){
            Task newTask = new Task(Subject = 'Negotiations with ' + acc.Name);
            newTask.WhatId = acc.Id;
            newTask.IsSynced__c = false;
            tasksList.add(newTask);
        }
        insert tasksList;
    }

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

    @Future
    public static void updateSyncStatusForContacts(List<Id> accountsIds, String strOldMap, String strNewMap){

        List<Contact> contactList = [SELECT Id,AccountId FROM Contact WHERE AccountId IN :accountsIds];

        Map<Id, Account> oldMap = (Map<Id, Account>) JSON.deserialize(strOldMap, Map<Id, Account>.class);
        Map<Id, Account> newMap = (Map<Id, Account>) JSON.deserialize(strNewMap, Map<Id, Account>.class);

        System.debug(oldMap);
        System.debug(newMap);

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
                        contact.Processed_By_Future__c = true;
                    }
                }
            }
        }

        update contactList;
    }


    public void OnBeforeInsert(List<Account> newAccount)
    {
        System.debug('OnBeforeInsert');
    }

    public void OnAfterInsert(List<Account> newAccount)
    {
        List<Id> accountIds = new List<Id>();

        for (Account acc : newAccount){
            accountIds.add(acc.Id);
        }

        createNewTask(accountIds);
    }

    public void OnAfterUpdate(List<Account> newAccount, List<Account> oldAccount, Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap )
    {
//        List<Id> accountIds = new List<Id>();
//
//        for (Account acc : newAccount){
//            accountIds.add(acc.Id);
//        }
//
//        String jsonOldMap = JSON.serialize(Trigger.oldMap);
//        String jsonNewMap = JSON.serialize(Trigger.newMap);
//
//        updateSyncStatusForContacts(accountIds, jsonOldMap, jsonNewMap);
//
//        System.enqueueJob(new UpdateSyncStatus(newAccount));
        newAccountMap.v
    }

    public void OnBeforeUpdate(List<Account> newAccount, List<Account> oldAccount, Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap )
    {
        System.debug('OnBeforeUpdate');
    }

}