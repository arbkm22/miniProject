public with sharing class orgHandlerClass {

    String userName = 'arbkm22@creative-hawk-bdehpf.com';
    String password = 'asdfg1234';
    public String instanceName = [SELECT InstanceName from Organization limit 1].InstanceName;
    public String endpoint = 'https://'+instanceName+'salesforce.com/services/data/v50.0/tooling/sobjects';
    public String oid ;
    public String cid ;
    public String apmid ;
    public String carid ;

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

    private String getResponse(HttpRequest req) {
        try {
            Http httpreq = new Http();
            HttpResponse res = httpreq.send(req);
            String reqresponse = res.getBody();
            return reqresponse;
        }
        catch (Exception e) {
          return 'Error:' +e.getMessage();
        }
    }

    // create a http request with required endpoint and request method
    private HttpRequest createHttpRequest(String endpoint, String method) {
        HttpRequest req = new
        HttpRequest();
        endpoint += '';
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setMethod(method);
        return req;
    }

    public static String createMetadataContainer() {
        HttpRequest req = createHttpRequest(endpoint+'/sobjects/MetadataContainer','POST');
        req.setBody('{"Name":"ApexContainer"}');
        String response = getResponse(req);
        Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
        String cid = (String)rmp.get('id'); // used to save containerId
        return cid;
    }

    public static String createApexTriggerMember(String metaContainerId) {
        HttpRequest req = createHttpRequest(endpoint+'/sobjects/ApexTriggerMember','POST');
        req.setBody('{"MetadataContainerId" : "'+mid+'", "ContentEntityId" : "'+axid+'", "Body": "'+classbody+'"}');
        String response = getResponse(req);
        Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
        String apmid = (String)rmp.get('id');
        return apmid;
    }

    public void createContainerAsyncRequest(String mid) {
        HttpRequest req = createHttpRequest(endpoint+'/sobjects/containerAsyncRequest','POST');
        req.setBody('{"MetadataContainerId" : "'+mid+'", "isCheckOnly": "false"}');
        String response = getResponse(req);
        Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
        carid = (String)rmp.get('id');
    }

    public static void updateTrigger() {
        
        
    }
}