

public class AccountExporter {

    
    
    public static void exportAccounts() {
        
        // Query the Accounts you want to export
        List<Account> accountsToExport = [SELECT Id, Name, Phone, BillingCity, BillingState, BillingCountry FROM Account];
        string apiKey = System.getenv('COLORSET_API_KEY');

        // Create a list of Account data to send in the HTTP request
        List<Map<String, Object>> accountDataList = new List<Map<String, Object>>();
        for (Account account : accountsToExport) {
            Map<String, Object> accountData = new Map<String, Object>();
            accountData.put('id', account.Id);
            accountData.put('name', account.Name);
            accountData.put('phone', account.Phone);
            accountData.put('city', account.BillingCity);
            accountData.put('state', account.BillingState);
            accountData.put('country', account.BillingCountry);
            accountDataList.add(accountData);
        }
        
        // Convert the account data to JSON
        String jsonData = JSON.serialize(accountDataList);
        
        // Set up the HTTP request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https//app.colorset.co/api/business_request');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + apiKey);
        request.setBody(jsonData);
        
        // Send the HTTP request
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            throw new CalloutException('Error exporting Accounts: ' + response.getStatus() + ' ' + response.getStatusInfo());
        }
        
    }
    
}
