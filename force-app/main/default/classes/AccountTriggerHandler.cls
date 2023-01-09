public class AccountTriggerHandler {
    public static void updateShippingAddress(List<Account> accList) {
        for (Account acc : accList) {
            if (acc.BillingStreet != null)
                acc.ShippingStreet = acc.BillingStreet;
            if (acc.BillingState != null)
                acc.ShippingState = acc.BillingState;
            if (acc.BillingCity != null)
                acc.ShippingCity = acc.BillingCity;
            if (acc.BillingCountry != null)
                acc.ShippingCountry = acc.BillingCountry;
        }
    }
    
    public static void updateState(List<Account> accList, Map<Id, Account> accMap) {
        for (Account acc : accList) {
            if (acc.BillingState != accMap.get(acc.Id).BillingState) {
                acc.State_Changed__c = true;
            }
        }
    }
}