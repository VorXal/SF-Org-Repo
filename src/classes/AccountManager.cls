/**
 * Created by Aleksei on 14.03.2021.
 */

@RestResource(UrlMapping='/Account/*')
global with sharing class AccountManager {


    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;

        String accountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);

        Account outputAccount = [SELECT Id, Name FROM Account WHERE Id = :accountId];

        return outputAccount;
    }


    @HttpPost
    global static Id createAccount(String name){
        Account newAccount = new Account(Name = name);

        insert newAccount;

        return newAccount.Id;
    }


    @HttpDelete
    global static void deleteAccount(){
        RestRequest request = RestContext.request;

        String accountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);

        Account deleteAccount = [SELECT Id, Name FROM Account WHERE Id = :accountId];

        delete deleteAccount;
    }


    @HttpPut
    global static Id upsertAccount(String id, String name){
        Account thisAccount = new Account(
                Id = id,
                Name = name);

        upsert thisAccount;

        return thisAccount.Id;
    }

    @HttpPatch
    global static Id updateAccountFields(){
        RestRequest request = RestContext.request;

        String accountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);

        Account thisAccount = [SELECT Id FROM Account WHERE Id = :accountId];

        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());

        for(String fieldName : params.keySet()) {

            thisAccount.put(fieldName, params.get(fieldName));
        }
        update thisAccount;

        return thisAccount.Id;
    }
}