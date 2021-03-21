public with sharing class TaskCreator {

	@InvocableMethod
    public static void createNewTask(List<Account> accountList){
        List<Task> tasksList = new List<Task>();
        for(Account acc : accountList){
            Task newTask = new Task(Subject = 'Negotiations with ' + acc.Name);
            newTask.WhatId = acc.Id;
            tasksList.add(newTask);
        }
        insert tasksList;
    }
    
}