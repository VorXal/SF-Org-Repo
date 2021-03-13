/**
 * Created by Aleksei on 11.03.2021.
 */

global  class UpdateAccountByTask implements Database.Batchable<SObject>, Database.Stateful {

    global  Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT Id, Name, Updated_By_Task__c, Owner.Name, '+
                        '(SELECT Id, Account_Owner__c FROM Tasks WHERE IsSynced__c = FALSE) FROM Account'
        );
    }

    global  void execute(Database.BatchableContext bc, List<Account> scope){
        List<Task> tasksToUpdate = new List<Task>();
        List<Account> accountsToUpdate = new List<Account>();

        for(Account account : scope){
            for(Task task: account.Tasks){
                task.Account_Owner__c = account.Owner.Name;
                task.IsSynced__c = true;
                tasksToUpdate.add(task);
            }
            account.Updated_By_Task__c = true;
            accountsToUpdate.add(account);
        }

        update accountsToUpdate;
        update tasksToUpdate;
    }

    global  void finish(Database.BatchableContext bc){
        System.debug('Accounts and tasks were successfully updated!');
    }
}