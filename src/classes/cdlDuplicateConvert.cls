global class cdlDuplicateConvert implements dupcheck.dc3Plugin.InterfaceConvert
{
  global void beforeConvert(Database.LeadConvert leadConvertData)
  {
    //Database.LeadConvert[getAccountId=001q000000oOEbwAAG;getAccountRecord=null;getBypassAccountDedupeCheck=null;
    //                     getBypassContactDedupeCheck=null;getContactId=003q000000kUH4IAAW;getContactRecord=null;
    //                     getConvertedStatus=Qualified;getLeadId=00Qq00000066q41EAA;getOpportunityId=null;
    //                     getOpportunityName=null;getOpportunityRecord=null;getOwnerId=0051I000000XSLPQA4;
    //                     isDoNotCreateOpportunity=true;isOverwriteLeadSource=false;isSendNotificationEmail=false;]
    //System.debug('beforeConvert - leadConvertData: ' + leadConvertData);
    return;
  }
  
  global void convertFailed(Database.LeadConvert leadConvertData, dupcheck.dc3Exception.ConvertException exceptionData)
  {
    // YOUR CUSTOM CODE
    return;
  }
  
  global void afterConvert(Database.LeadConvertResult leadConvertResult, Task taskData)
  {
    try
    {
      //Database.LeadConvertResult[getAccountId=001q000000oOEbwAAG;getContactId=003q000000kUH4IAAW;
      //                           getErrors=();getLeadId=00Qq00000066q41EAA;getOpportunityId=null;isSuccess=true;]
      //System.debug('afterConvert - leadConvertResult: ' + leadConvertResult);
      //System.debug('afterConvert - taskData: ' + taskData);
      /***
      Lead Owner - to Account / Contact / Application
      Lead Score / Score Comments / Financing Stage - to Account
      Lead Company Description - to Account
      Lead Source - to Account / Contact
      ***/
      Lead lead = [select Id, OwnerId, Description, Lead_Score__c, Score_Comments__c, Financing_Stage__c, LeadSource
                   from Lead where Id =: leadConvertResult.getLeadId() limit 1];
      Id leadOwnerId;
      if (lead != null) { leadOwnerId = lead.OwnerId; }
      Account account = [select Id, OwnerId from Account where Id =: leadConvertResult.getAccountId() limit 1];
      if (account != null)
      {
        account.OwnerId = leadOwnerId;
        account.Description = lead.Description;
        account.Lead_Score__c = lead.Lead_Score__c;
        account.Score_Comments__c = lead.Score_Comments__c;
        account.Financing_Stage__c = lead.Financing_Stage__c;
        account.AccountSource = lead.LeadSource;
        update account;
      }
      Contact contact = [select Id from Contact where Id =: leadConvertResult.getContactId() limit 1];
      if (contact != null)
      {
        contact.OwnerId = leadOwnerId;
        contact.LeadSource = lead.LeadSource;
        update contact;
      }
      Application__c application = [select Id, OwnerId from Application__c where Venture__c =: account.Id limit 1];
      if (application != null)
      { application.OwnerId = leadOwnerId; application.Related_Lead__c = lead.Id; update application; }
    } catch (Exception e) { System.debug('Whoops'); }
    return;
  }
}