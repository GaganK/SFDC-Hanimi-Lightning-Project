@isTest
public class Test_PartnerQuestionnaireController {
    
    @isTest
    public static void createPartnerQuestionnaire()
    {
        Account acc = new Account(name='Test');
        insert acc;
                
        PartnerQuestionnaireController ac = new PartnerQuestionnaireController(new ApexPages.StandardController(acc));
        ac.openPartnerQuestionnaireForm();
        ac.getIsVenture();
        ac.savePartnerQuestionnaire();
    }

}