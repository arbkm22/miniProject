public class OpportunityTriggerHelper {
    public static void updateHighestHelper(Map<Id, Decimal> accs) {
        List<Account> accList = new List<Account>();
        for (Id key : accs.keySet()) {
            Account acc = new Account();
            acc.Id = key;
            acc.Highest_Opportunity_Value__c = accs.get(key);
            accList.add(acc);
        }
        if (!accList.isEmpty())
            UPDATE accList;
    }
}
