public class applicationInterviewController
{
  @AuraEnabled
  public static String getPrimaryContact(String appId)
  {
    String primaryContactId = '';
    try
    {
      primaryContactId
        = [select Contact__c from Application_Contact__c
           where Application__c =: appId and Primary_Contact__c = true limit 1].Contact__c;
    } catch (Exception e) {}
    return primaryContactId;
  }
}