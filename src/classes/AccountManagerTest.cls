/**
 * Created by Aleksei on 17.03.2021.
 */
@IsTest
private class AccountManagerTest {

    @IsTest static void testGetAccount(){

        Id recordId = createTestRecord();

        RestRequest request = new RestRequest();
        request.requestURI =
                'https://epam-da-dev-ed.my.salesforce.com/services/apexrest/Account/'
                        + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;

        Account thisAccount = AccountManager.getAccount();

        System.assert(thisAccount != null);
        System.assertEquals('Test Account', thisAccount.Name);
    }

    @IsTest static void testCreateAccount(){

        Id accountId = AccountManager.createAccount('Test Create Account');

        Account createdAccount = [SELECT Id, Name FROM Account WHERE Id = :accountId];

        System.assert(accountId != null);
        System.assertEquals('Test Create Account', createdAccount.Name);
    }

    @IsTest static void testDeleteAccount(){

        Id recordId = createTestRecord();

        RestRequest request = new RestRequest();
        request.requestURI =
                'https://epam-da-dev-ed.my.salesforce.com/services/apexrest/Account/'
                        + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;

        AccountManager.deleteAccount();

        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :recordId];

        System.assert(accounts.size() == 0);
    }

    @IsTest static void testPutAccount(){

        Id insertedAccId = AccountManager.upsertAccount(createTestRecord(),'testPutInsertAccount');
        Account insertedAccount = [SELECT Name FROM Account WHERE Id = :insertedAccId];

        System.assert(insertedAccId != null);
        System.assertEquals(insertedAccount.Name, 'testPutInsertAccount');
    }

    @IsTest static void testPatchAccount(){

        Id recordId = createTestRecord();

        RestRequest request = new RestRequest();
        request.requestURI =
                'https://epam-da-dev-ed.my.salesforce.com/services/apexrest/Account/'
                        + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name": "NameChanged", "Phone": "654-321"}');

        RestContext.request = request;

        Id thisAccountId = AccountManager.updateAccountFields();

        System.assert(thisAccountId != null);

        Account thisAccount = [SELECT Id, Name, Phone FROM Account WHERE Id = :thisAccountId];

        System.assert(thisAccount != null);
        System.assertEquals(thisAccount.Name, 'NameChanged');
        System.assertEquals(thisAccount.Phone, '654-321');
    }

    static Id createTestRecord() {
        
        Account accountTest = new Account(Name='Test Account', Phone='123-456');
        insert accountTest;
        return accountTest.Id;
    }
}