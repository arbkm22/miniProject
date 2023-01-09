trigger OpportunityTrigger on Opportunity (after insert) {
    List<TriggerHandler__c> t = [SELECT Name, Object__c, Status__c FROM TriggerHandler__c WHERE Object__c = 'Opportunity'];
    TriggerHandler__c opp = t[0];
    if (opp.Status__c == 'Active') {
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                OpportunityTriggerHandler.updateHighest(Trigger.New);
            }
        }
    }
}