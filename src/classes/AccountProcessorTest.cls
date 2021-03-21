@IsTest
private class AccountProcessorTest {

	@IsTest static void countContactsTest() {

        List<Id> accountIds = getTestData();

        System.debug(accountIds);

        Test.startTest();
        AccountProcessor.countContacts(accountIds);
        Test.stopTest();

        List<Account> countedAccounts = [SELECT Id, Name, Number_of_Contacts__c FROM Account WHERE Id IN :accountIds];
        System.debug(countedAccounts);
        System.assert(countedAccounts.size() != 0);
        System.assertEquals(countedAccounts[0].Number_of_Contacts__c, 1);
        System.assertEquals(countedAccounts[1].Number_of_Contacts__c, 1);
        System.assertEquals(countedAccounts[2].Number_of_Contacts__c, 2);
    }

    private static List<Id> getTestData(){
        List<Account> accountList = new List<Account>();
        List<Id> idsList = new List<Id>();
        List<Contact> contactList =  new List<Contact>();

        for(Integer i = 0; i < 3; i++){
            Account newAccount = new Account(Name = 'TestAccount_' + i);

            accountList.add(newAccount);
        }

        insert accountList;


        Integer temp = 1;

        for(Integer j = 0; j <= temp; j++){
            Contact newContact = new Contact(FirstName='TestContactName_' + temp + j, LastName='TestContact_' + temp + j);
            newContact.AccountId = accountList[temp - 1].Id;

            contactList.add(newContact);

            if (temp < 3) {
                temp++;
            }
        }

        System.debug(contactList);
        insert contactList;

        for(Account acc : accountList){
            idsList.add(acc.Id);
        }

        return idsList;
    }

}