trigger AccountTrigger on Account (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.updateShippingAddress(Trigger.New);
        }
    }
}