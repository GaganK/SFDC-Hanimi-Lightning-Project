@IsTest(SeeAllData=true)
public class testCDLUtilities
{
  @IsTest
  public static void testCDLUtilities()
  {
    cdlUtilities.generateRandomString(6);
  }
  
  @IsTest
  public static void testCreateLogDoc()
  {
    String transDate
      = System.now().format('MM/dd/YYYY h:mm:ss a');
    cdlUtilities.createLogDoc('cdlApplication DEBUG: ' + ' - ' + transDate, 'CDL Application Logs',
                              'cdlApplication: ' + 'test', 'text/plain', 'log');
  }
  
  @IsTest
  public static void testDebug()
  {
    RestRequest rReq = new RestRequest();
    rReq.addHeader('test', 'test'); rReq.addParameter('param1', 'value1');
    rReq.requestBody = Blob.valueOf('test');
    String debugInfo = cdlUtilities.debugInfo(rReq);
  }
}