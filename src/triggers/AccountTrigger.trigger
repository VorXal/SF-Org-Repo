/**
 * Created by Aleksei on 10.03.2021.
 */

trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);

    if( Trigger.isInsert )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeInsert(Trigger.new);
        }
        else
        {
            handler.OnAfterInsert(Trigger.new);
        }
    }
    else if ( Trigger.isUpdate )
    {
        if(Trigger.isBefore)
        {
            handler.OnBeforeUpdate(Trigger.new ,Trigger.old,Trigger.newMap,Trigger.oldMap);
        }
        else
        {
            handler.OnAfterUpdate(Trigger.new ,Trigger.old,Trigger.newMap,Trigger.oldMap);
        }
    }

}