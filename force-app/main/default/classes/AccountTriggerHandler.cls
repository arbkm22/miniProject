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
}