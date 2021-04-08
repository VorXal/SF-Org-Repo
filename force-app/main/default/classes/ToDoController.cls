public with sharing class ToDoController {
    
    @AuraEnabled(cacheable=true)
    public static List<ToDoItem__c> getToDos(){
        List<ToDoItem__c> todos;
        try {
            todos = [
                SELECT Name,
                Description__c,
                Creation_Date__c,
                Category__c,
                Priority__c,
                Status__c
                FROM ToDoItem__c
                ORDER BY Category__c
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return todos;
    }

    @AuraEnabled(Cacheable=true)
    public static List<ToDoItem__c> searchToDos(String searchTerm) {
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getToDos();
        }
        
        searchTerm = '%' + searchTerm + '%';
        
        return [
            SELECT Name,
            Description__c,
            Creation_Date__c,
            Category__c,
            Priority__c,
            Status__c
            FROM ToDoItem__c
            WHERE Name LIKE :searchTerm
            ORDER BY Category__c
        ];
    }
}