/**
 * Created by Aleksei on 11.03.2021.
 */

public with sharing class UpdateAccountByContact implements Database.Batchable<Account>, Database.Stateful {

    private List<Account> accountList;

    public UpdateAccountByContact(List<Account> accounts){
        accountList = accounts;
    }

    public Iterable<Account> start(Database.BatchableContext bc) {
        return accountList;
    }

    public void execute(Database.BatchableContext bc, List<Account> scope){
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();

        for(Account account : scope){
            for(Contact contact: account.Contacts){
                contact.MailingCity = account.BillingCity;
                contact.MailingLatitude = account.BillingLatitude;
                contact.MailingLongitude = account.BillingLongitude;
                contact.MailingCountry = account.BillingCountry;
                contact.MailingPostalCode = account.BillingPostalCode;
                contact.MailingState = account.BillingState;
                contact.MailingStreet = account.BillingStreet;
                contact.IsSynced__c = true;
                contactsToUpdate.add(contact);
            }
            account.Updated_By_Contact__c = true;
            accountsToUpdate.add(account);
        }


        update contactsToUpdate;
        update accountsToUpdate;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Accounts and contacts were successfully updated!');
    }
}