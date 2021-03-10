public with sharing class RandomTaskAllocator {
	@InvocableMethod
    public static void allocationTask(List<Id> accountList){
        List<Task> taskWhatIdList = [SELECT WhatId FROM Task WHERE WhatId IN :accountList];
        List<User> userList = [SELECT Id FROM User WHERE IsActive = TRUE];
        for(Id accId : accountList){
            Integer i = 0;
            for(Task task: taskWhatIdList){
                if(task.WhatId == accId){
                    i++;
                }
            }
            if(i > 3){
                Integer randomNumber = Integer.valueOf((Math.random() * userList.size()));
                for(Task task: taskWhatIdList){
                	if(task.WhatId == accId){
                    	task.OwnerId = userList[randomNumber].Id;
                	}
            	}
                System.debug('Done');
            }
        }
        update taskWhatIdList;
    }
}