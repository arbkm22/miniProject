public with sharing class orgHandler {
    @AuraEnabled(cacheable=true)
    public static List<ApexTrigger> getTriggers() {
        return [SELECT Id, Name, TableEnumOrId, Status FROM ApexTrigger];
    }

    @AuraEnabled(cacheable=true)
    public static List<TriggerHandler__c> getTriggerList() {
        return [SELECT Name, Object__c, Status__c, Status2__c FROM TriggerHandler__c];
    }

    @AuraEnabled
    public static List<FlowDefinitionView> getFlowsList() {
        return [SELECT Id, Label, ProcessType, IsActive, VersionNumber, IsTemplate FROM FlowDefinitionView WHERE ProcessType = 'Flow'];
    }

    @AuraEnabled
    public static void updateTrigger(String objectName) {
        TriggerHandler__c toUpdate = [SELECT Name, Object__c, Status__c, Status2__c FROM TriggerHandler__c WHERE Object__c = :objectName];
        List<TriggerHandler__c> updateList = new List<TriggerHandler__c>();
        if (toUpdate.Status__c == 'Active') {
            toUpdate.Status__c = 'Inactive';
            toUpdate.Status2__c = false;
        }
        else if (toUpdate.Status__c == 'Inactive') {
            toUpdate.Status__c = 'Active';
            toUpdate.Status2__c = true;
        }
        updateList.add(toUpdate);
        if (!updateList.isEmpty())
            UPDATE updateList;
    }
}