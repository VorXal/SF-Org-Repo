/**
 * Created by Aleksei on 17.03.2021.
 */
@IsTest
private class QueuebleJobTest {

    @IsTest static void jobTestWithBillingAddress(){

        Id testAccountId = createTestAccountWithAddress();

        List<Contact> relatedContact = [SELECT Id, IsSynced__c, Processed_By_Queue__c
                                            FROM Contact WHERE AccountId = :testAccountId];

        System.assert(testAccountId != null);
        System.assert(relatedContact != null);
        System.assertEquals(relatedContact[0].IsSynced__c, true);
        System.assertEquals(relatedContact[0].Processed_By_Queue__c, false);

        Test.startTest();
        System.enqueueJob(new QueuebleJob());
        Test.stopTest();

        relatedContact = [SELECT Id, IsSynced__c, Processed_By_Queue__c
                                FROM Contact WHERE AccountId = :testAccountId];

        System.assert(testAccountId != null);
        System.assert(relatedContact != null);
        System.assertEquals(relatedContact[0].IsSynced__c, false);
        System.assertEquals(relatedContact[0].Processed_By_Queue__c, true);
    }

    @IsTest static void jobTestWithoutBillingAddress(){

        Id testAccountId = createTestAccountWithoutAddress();

        List<Contact> relatedContact = [SELECT Id, IsSynced__c, Processed_By_Queue__c
        FROM Contact WHERE AccountId = :testAccountId];

        System.assert(testAccountId != null);
        System.assert(relatedContact != null);
        System.assertEquals(relatedContact[0].IsSynced__c, true);
        System.assertEquals(relatedContact[0].Processed_By_Queue__c, false);

        Test.startTest();
        System.enqueueJob(new QueuebleJob());
        Test.stopTest();

        relatedContact = [SELECT Id, IsSynced__c, Processed_By_Queue__c
        FROM Contact WHERE AccountId = :testAccountId];

        System.assert(testAccountId != null);
        System.assert(relatedContact != null);
        System.assertEquals(relatedContact[0].IsSynced__c, true);
        System.assertEquals(relatedContact[0].Processed_By_Queue__c, false);
    }

    private static Id createTestAccountWithAddress(){

        Contact newContact = new Contact(FirstName = 'TestContact', LastName = 'TestContact');
        Account newAccount = new Account(
                Name = 'TestAccount', BillingCity = 'TestCity', BillingCountry = 'TestCountry');

        insert newAccount;

        newContact.AccountId = newAccount.Id;

        insert newContact;
        return newAccount.Id;
    }

    private static Id createTestAccountWithoutAddress(){

        Contact newContact = new Contact(FirstName = 'TestContact', LastName = 'TestContact');
        Account newAccount = new Account(Name = 'TestAccount');

        insert newAccount;

        newContact.AccountId = newAccount.Id;

        insert newContact;
        return newAccount.Id;
    }
}