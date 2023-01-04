trigger AccountTrigger on Account (before insert, before update) {
    List<TriggerHandler__c> triggerList = [SELECT Name, Object__c, Status__c FROM TriggerHandler__c WHERE Name='AccountTrigger'];
    TriggerHandler__c accountHandler = triggerList[0];
    if (accountHandler.Status__c == 'Active') {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                AccountTriggerHandler.updateShippingAddress(Trigger.New);
            }
        }
    }
}