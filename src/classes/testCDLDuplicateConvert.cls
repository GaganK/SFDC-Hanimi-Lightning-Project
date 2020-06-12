@IsTest(SeeAllData=true)
public class testCDLDuplicateConvert
{
  @IsTest
  public static void testCDLDuplicateConvert()
  {
    test.startTest();
    Lead lead = new Lead();
    lead.FirstName = 'Trigger1'; lead.LastName = 'Test1';
    lead.Company = 'Trigger Test1'; lead.LeadSource = 'GetTimely Online';
    lead.Lead_Score__c = 3; lead.Status = 'Lead';
    insert lead;
    Database.LeadConvert lc = new database.LeadConvert();
    lc.setLeadId(lead.Id);
    LeadStatus convertStatus
      = [select Id, MasterLabel from LeadStatus where IsConverted = true limit 1];
    lc.setConvertedStatus(convertStatus.MasterLabel);
    Database.LeadConvertResult lcr = Database.convertLead(lc);
    cdlDuplicateConvert cdlDC = new cdlDuplicateConvert();
    cdlDC.beforeConvert(lc);
    dupcheck.dc3Exception.ConvertException exceptionData
      = new dupcheck.dc3Exception.ConvertException();
    cdlDC.convertFailed(lc, exceptionData);
    cdlDC.afterConvert(lcr, null);
    Test.stopTest();
  }
}