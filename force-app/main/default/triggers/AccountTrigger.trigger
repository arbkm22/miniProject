trigger AccountTrigger on Account (before insert, before update) {
    List<TriggerHandler__c> triggerList = [SELECT Name, Object__c, Status__c FROM TriggerHandler__c WHERE Object__c='Account'];
    TriggerHandler__c acc = triggerList[0];
    if (acc.Status__c == 'Active') {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                AccountTriggerHandler.updateShippingAddress(Trigger.New);
            }
            if (Trigger.isUpdate) {
                AccountTriggerHandler.updateState(Trigger.New, Trigger.oldMap);
            }
        }
    }
}