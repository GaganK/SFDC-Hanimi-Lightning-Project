/*
 * Purpose			: Test class for ResponseToApplicationBatch
 * Developer		: Rabaab (Dreamwares)
 * Date				: 15-May-2018
 */

@isTest
private class ResponseToApplicationBatchTest {
    private static Integer maxcount = 9;
    
	/*
	 * Purpose		: Creating setup records 
	 */
    @testSetup
    private static void createTestSetup(){
    	//Creating and inserting application records
        Application__c[] applications = new List<Application__c>();
        for(Integer index = 0; index<maxcount; index++){
            applications.add(new Application__c());
        }
        insert applications;
        
        //Creating question records
        Question__c[] questions = new List<Question__c>();
        questions.add(new Question__c(Question_English__c='Describe a single customer and how they will use your product or service.'));
        questions.add(new Question__c(Question_English__c='Describe the machine-learning problem you are solving. Please include a brief description of the core methods or technologies used, inputs, outputs, and approach to validation.'));
        questions.add(new Question__c(Question_English__c='Do you have a working prototype? Can you show it? If not, how long will it take you to produce one? Explain what the prototype or product demonstrates.'));
        questions.add(new Question__c(Question_English__c='Do you have affiliation with any other programs/institutions? If so, please specify:'));
        questions.add(new Question__c(Question_English__c='Does your venture have any advisors? If so please list them and give a brief description of their background.'));
        questions.add(new Question__c(Question_English__c='Have you generated any revenue? If so, how much have you generated and over what period of time?'));
        questions.add(new Question__c(Question_English__c='Have you raised any money? If so, how much?'));
        questions.add(new Question__c(Question_English__c='Have you received any grant funding? If so, how much?'));
        questions.add(new Question__c(Question_English__c='How do you plan to protect your idea from competitors and imitators? (Inimitability and IP)'));
        questions.add(new Question__c(Question_English__c='How do you sell to your customer?'));
        questions.add(new Question__c(Question_English__c='How do you think the Creative Destruction Lab can help your venture succeed?'));
        questions.add(new Question__c(Question_English__c='How much time and money have you already spent on developing this business?'));
        questions.add(new Question__c(Question_English__c='Is there anything else you would like to tell us?'));
        questions.add(new Question__c(Question_English__c='Product/Service Overview (Briefly describe how your product or service works)'));
        questions.add(new Question__c(Question_English__c='Venture Overview (Briefly describe your venture)'));
        questions.add(new Question__c(Question_English__c='What is the long-term vision of your company? How is your product going to change the world?'));
        questions.add(new Question__c(Question_English__c='What is the single most important dimension on which your technology outperforms your competition?'));
        questions.add(new Question__c(Question_English__c='What is the value proposition for this specific customer?'));
        questions.add(new Question__c(Question_English__c='What kind of data do you have access to, and how much data do you need to train your learning algorithms?'));
        questions.add(new Question__c(Question_English__c='Who else is selling to your customer? Why will your customer buy your product or service instead of your competitor\'s?'));
        questions.add(new Question__c(Question_English__c='Why is it crucial to have a sophisticated machine learning algorithm at the core of the product or service?'));
        insert questions;
        
        //Creating responses for each application
        Response__c[] responses = new List<Response__c>();
        for(Application__c application : applications){
            for(Question__c question : questions){
                responses.add(new Response__c(Application__c = application.Id,
                                         Question__c = question.Id,
                                         Response__c = 'Test reponse'
                                        ));
            }
        }
        //System.debug('TEST|  Response count: ' +responses.size());
        insert responses;
    }
    
    /*
     * Purpose		: Test method to test batch
     */
    private static testmethod void testBatch(){
        Test.startTest();
        Database.executeBatch(new ResponseToApplicationBatch());
        Test.stopTest();
        
        Application__c[] applications = [SELECT Id, Describe_a_single_customer_and_how_they__c,
                                         Describe_the_machine_learning_problem_yo__c,
                                         Do_you_have_a_working_prototype_Can_you__c,
                                         Do_you_have_affiliation_with_any_other_p__c,
                                         Does_your_venture_have_any_advisors_If__c,
                                         Have_you_generated_any_revenue_If_so_h__c,
                                         Have_you_raised_any_money_If_so_how_mu__c,
                                         Have_you_received_any_grant_funding_If__c,
                                         How_do_you_plan_to_protect_your_idea_fro__c,
                                         How_do_you_sell_to_your_customer__c,
                                         How_do_you_think_the_Creative_Destructio__c,
                                         How_much_time_and_money_have_you_already__c,
                                         Is_there_anything_else_you_would_like_to__c,
                                         Product_Service_Overview_Briefly_descri__c,
                                         Venture_Overview_Briefly_describe_your__c,
                                         What_is_the_long_term_vision_of_your_com__c,
                                         What_is_the_single_most_important_dimens__c,
                                         What_is_the_value_proposition_for_this_s__c,
                                         What_kind_of_data_do_you_have_access_to__c,
                                         Who_else_is_selling_to_your_customer_Wh__c,
                                         Why_is_it_crucial_to_have_a_sophisticate__c
                                         FROM Application__c];
        System.debug('TEST| ' +applications[0]);
        for(Application__c application : applications){
            System.assertEquals(true, application.Describe_a_single_customer_and_how_they__c != null );
            System.assertEquals(true, application.Describe_the_machine_learning_problem_yo__c != null );
            System.assertEquals(true, application.Do_you_have_a_working_prototype_Can_you__c != null );
            System.assertEquals(true, application.Do_you_have_affiliation_with_any_other_p__c != null );
            System.assertEquals(true, application.Does_your_venture_have_any_advisors_If__c != null );
            System.assertEquals(true, application.Have_you_generated_any_revenue_If_so_h__c != null );
            System.assertEquals(true, application.Have_you_raised_any_money_If_so_how_mu__c != null );
            System.assertEquals(true, application.Have_you_received_any_grant_funding_If__c != null );
            System.assertEquals(true, application.How_do_you_plan_to_protect_your_idea_fro__c != null );
            System.assertEquals(true, application.How_do_you_sell_to_your_customer__c != null );
            System.assertEquals(true, application.How_do_you_think_the_Creative_Destructio__c != null );
            System.assertEquals(true, application.How_much_time_and_money_have_you_already__c != null );
            System.assertEquals(true, application.Is_there_anything_else_you_would_like_to__c != null );
            System.assertEquals(true, application.Product_Service_Overview_Briefly_descri__c != null );
            System.assertEquals(true, application.Venture_Overview_Briefly_describe_your__c != null );
            System.assertEquals(true, application.What_is_the_long_term_vision_of_your_com__c != null );
            System.assertEquals(true, application.What_is_the_single_most_important_dimens__c != null );
            System.assertEquals(true, application.What_is_the_value_proposition_for_this_s__c != null );
            System.assertEquals(true, application.What_kind_of_data_do_you_have_access_to__c != null );
            System.assertEquals(true, application.Who_else_is_selling_to_your_customer_Wh__c != null );
            System.assertEquals(true, application.Why_is_it_crucial_to_have_a_sophisticate__c != null );
        }
    }
}