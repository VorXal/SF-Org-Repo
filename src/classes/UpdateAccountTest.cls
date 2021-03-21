/**
 * Created by Aleksei on 17.03.2021.
 */
@IsTest
private class UpdateAccountTest {

    @TestSetup static void setup(){

        User user = [SELECT Id FROM User WHERE Name='Aleksei Voronkov'];

        Account newAccount = new Account(Name = 'TestAccount');
        newAccount.OwnerId = user.Id;
        newAccount.Owner = user;
        newAccount.Updated_By_Task__c = false;
        insert newAccount;
    }

    @IsTest static void batchTest(){

        Test.startTest();
        Database.executeBatch(new UpdateAccount());
        Test.stopTest();

        List<Account> accountList = [SELECT Id, Name, Updated_By_Task__c, Owner.Name FROM Account];
        List<Task> taskList = [SELECT Account_Owner__c, IsSynced__c FROM Task WHERE WhatId IN :accountList];

        System.debug(taskList);

        System.assert(accountList.size() != 0);
        System.assertEquals(accountList[0].Updated_By_Task__c, true);
        System.assertEquals(taskList[1].Account_Owner__c, accountList[0].Owner.Name);
        System.assertEquals(taskList[0].IsSynced__c, true);
    }

}