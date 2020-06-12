public class PartnerQuestionnaireController {
    
    public Partner_Questionnaire__c PartnerQuestionnaire{get;set;}
    public boolean isNewPartnerQuestionnaire{get;set;}
    private String AccountId;
    
    public PartnerQuestionnaireController(ApexPages.StandardController std)
    {
        PartnerQuestionnaire = new Partner_Questionnaire__c();
        PartnerQuestionnaire.Account_Name__c = std.getId();
        isNewPartnerQuestionnaire = false;
        AccountId = std.getId();
    }
    
    public boolean getIsVenture()
    {
        Account acc = [Select id,name,recordType.name from Account where id =: AccountId];
        if(acc.recordType.Name == 'Venture Account')
        {
            return true;
        }
        return false;
    }
    
    public void openPartnerQuestionnaireForm()
    {
        isNewPartnerQuestionnaire = true;
    }
    
    public PageReference savePartnerQuestionnaire()
    {
        try
        {
            upsert PartnerQuestionnaire;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        
        isNewPartnerQuestionnaire = false;
        PartnerQuestionnaire = new Partner_Questionnaire__c();
        return null;
        
    }

}