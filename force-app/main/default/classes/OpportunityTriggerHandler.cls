public class OpportunityTriggerHandler {
    public static void updateHighest(List<Opportunity> oppList) {
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : oppList) {
            accIds.add(opp.AccountId);
        }
        List<Account> accs = [SELECT Name, Highest_Opportunity_Value__c FROM Account WHERE Id IN :accIds];
        List<AggregateResult> agResults = [SELECT AccountId, MAX(Amount)amts FROM Opportunity WHERE AccountId IN :accIds GROUP BY AccountId];
        Map<Id, Decimal> accWithMaxAmount = new Map<Id, Decimal>();
        for (AggregateResult ag : agResults) {
            Id accId = (Id)ag.get('AccountId');
            Decimal amount = (Decimal)ag.get('amts');
            accWithMaxAmount.put(accId, amount);
        }
        if (!accWithMaxAmount.isEmpty())
            OpportunityTriggerHelper.updateHighestHelper(accWithMaxAmount);
    }
}
