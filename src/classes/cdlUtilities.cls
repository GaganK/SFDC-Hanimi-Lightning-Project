public class cdlUtilities
{
  public static String generateRandomString(Integer randLen)
  {
    String randomString = '';
    String possibleChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    for (Integer i = 0; i < randLen; i++)
    {
      Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), possibleChars.length());
      randomString += possibleChars.subString(idx, idx+1);
    }
    return randomString;
  }
  
  public static Document createLogDoc(String docName, String docFolderName, String docContent,
                                      String docContentType, String docType)
  {
    Document doc = new Document(); doc.Name = docName;
    doc.FolderId = [select Id from Folder where Name =: docFolderName limit 1].Id;
    doc.Body = Blob.valueOf(docContent); doc.ContentType = docContentType;
    doc.Type = docType; return doc;
  }
  
  // User-Agent = FreshHooks/0.34 (http://developers.freshbooks.com/api/webhooks)
  // X-Salesforce-SIP = 184.106.13.16
  public static String debugInfo(RestRequest req)
  {
    String debugInfo = ''; debugInfo += '/*** All Incoming Headers: ***/\n';
    for (String key : req.headers.keySet())
    {
      if (req.headers.get(key) != null)
      { debugInfo += key + ' = ' + req.headers.get(key) + '\n'; }
    }
    if (req.params.size() >= 1)
    {
      debugInfo += '\n/*** All Incoming Parameters: ***/\n';
      for (String key : req.params.keySet())
      {
        if (req.params.get(key) != null)
        { debugInfo += key + ' = ' + req.params.get(key) + '\n'; }
        if (debugInfo.endsWith('=\n')) { debugInfo = debugInfo.substring(0,debugInfo.length()-2); }
      }
    }
    if (req.requestBody.toString() != '')
    { debugInfo += '\n/*** Body: ***/\n'; debugInfo += req.requestBody.toString(); }
    return debugInfo;
  }
}