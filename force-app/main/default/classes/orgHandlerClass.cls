public with sharing class orgHandlerClass {

    String userName = 'arbkm22@creative-hawk-bdehpf.com';
    String password = 'asdfg1234';

    @AuraEnabled
    public static void checkToolingApi(String triggerName) {
        String auth = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf('{userName}:{password}'));

        String instanceUrl = URL.getSalesforceBaseUrl().toExternalForm();

        // Query the Trigger object to get the ID of the trigger
        String query = 'SELECT Id FROM Trigger WHERE Name = \'' + triggerName + '\'';
        String encodedQuery = EncodingUtil.urlEncode(query, 'UTF-8');
        String toolingApiUrl = instanceUrl + '/services/data/v50.0/tooling/query?q=' + encodedQuery;

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', auth);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(toolingApiUrl);
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            // Parse the response
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> records = (List<Object>) responseBody.get('records');

            if (!records.isEmpty()) {
                Map<String, Object> tg = (Map<String, Object>) records[0];
                String triggerId = (String) tg.get('Id');

                // Deactivate the trigger
                String updateUrl = instanceUrl + '/services/data/v50.0/tooling/sobjects/Trigger/' + triggerId + '/update';
                request = new HttpRequest();
                request.setHeader('Authorization', auth);
                request.setHeader('Content-Type', 'application/json');
                request.setEndpoint(updateUrl);
                request.setMethod('POST');
                request.setBody('{"Status": "Inactive"}');

                response = http.send(request);

                if (response.getStatusCode() == 204) {
                    System.debug('Trigger deactivated');
                } 
                else {
                    System.debug('Error deactivating trigger: ' + response.getStatusCode() + ' ' + response.getStatus());
                }
            } 
            else {
                System.debug('Trigger not found');
            }
        } 
        else {
            System.debug('Error querying triggers: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
    }
}