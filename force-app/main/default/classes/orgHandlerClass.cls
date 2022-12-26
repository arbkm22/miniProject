public with sharing class orgHandlerClass {
    @AuraEnabled(cacheable=true)
    public static List<ApexTrigger> getTriggers() {
        return [SELECT Name, TableEnumOrId, ApiVersion, Status FROM ApexTrigger];
    }
}
