/**
 * Created by Aleksei on 17.03.2021.
 */

@IsTest
private class AccountTriggerHandlerTest {

    @IsTest static void testUpdate(){

        List<Id> accountIds = new List<Id>();
        Map<Id, Account> oldMap = new Map<Id, Account>();
        Map<Id, Account> newMap = new Map<Id, Account>();
        List<Contact> contactsList = new List<Contact>();

        Id testAccountId = createTestAccountWithContact();
        Account testAccount = [SELECT Id, Name, BillingCountry, BillingCity FROM Account WHERE Id = :testAccountId];

        accountIds.add(testAccountId);
        oldMap.put(testAccountId, testAccount);

        String jsonOldMap = JSON.serialize(oldMap);

        testAccount.BillingCountry = 'NewCountry';
        testAccount.BillingCity = 'NewCity';

        update testAccount;

        newMap.put(testAccountId, testAccount);

        String jsonNewMap = JSON.serialize(newMap);

        Test.startTest();
        AccountTriggerHandler.updateSyncStatusForContacts(accountIds, jsonOldMap, jsonNewMap);
        Test.stopTest();

        contactsList = [SELECT Id, IsSynced__c, Processed_By_Future__c FROM Contact WHERE AccountId IN :accountIds];

        System.assert(contactsList.size() != 0);
        System.assertEquals(contactsList[0].IsSynced__c, false);
        System.assertEquals(contactsList[0].Processed_By_Future__c, true);

    }

    private static Id createTestAccountWithContact(){

        Contact newContact = new Contact(FirstName='TestContact', LastName='TestContact');
        Account newAccount = new Account(
                Name='TestAccount', BillingCity='TestCity', BillingCountry='TestCountry');

        insert newAccount;

        newContact.AccountId = newAccount.Id;

        insert newContact;
        return newAccount.Id;
    }
}