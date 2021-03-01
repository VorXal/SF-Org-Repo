public with sharing class RandomTaskAllocator {
	@InvocableMethod
    public static void allocationTask(List<Id> accountList){
        List<Task> taskWhatIdList = [select WhatId from Task where WhatId in :accountList];
        List<User> userList = [select Id from User where isActive = true];
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