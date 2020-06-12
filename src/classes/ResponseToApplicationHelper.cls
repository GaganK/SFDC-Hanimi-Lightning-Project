/*
 * Purpose			: Helper for ResponseToApplicationBatch
 * Developer		: Rabaab (Dreamwares)
 * Date				: 15-May-2018
 */
public class ResponseToApplicationHelper {
    
    /*
     * Purpose		: Map response values to application object field
     * Parameter	: List of response records
     */
    public static void mapResponsesToApplication(Response__c[] responses){
        Map<Id, Application__c> applicationsToBeUpserted = new Map<Id, Application__c>();
        for(Response__c response : responses){
            Application__c application;// = new Application__c();
            
            if(applicationsToBeUpserted.containsKey(response.Application__c)){
                application = applicationsToBeUpserted.get(response.Application__c);
            }else{
                application = new Application__c();
                application.Id = response.Application__c;
            }
            
            if(response.Question_English__c.equals('Describe a single customer and how they will use your product or service.')){
                application.Describe_a_single_customer_and_how_they__c = response.Response__c;
            }else if(response.Question_English__c.equals('Describe the machine-learning problem you are solving. Please include a brief description of the core methods or technologies used, inputs, outputs, and approach to validation.')){
                application.Describe_the_machine_learning_problem_yo__c = response.Response__c;
            }else if(response.Question_English__c.equals('Do you have a working prototype? Can you show it? If not, how long will it take you to produce one? Explain what the prototype or product demonstrates.')){
                application.Do_you_have_a_working_prototype_Can_you__c = response.Response__c;
            }else if(response.Question_English__c.equals('Do you have affiliation with any other programs/institutions? If so, please specify:')){
                application.Do_you_have_affiliation_with_any_other_p__c = response.Response__c;
            }else if(response.Question_English__c.equals('Does your venture have any advisors? If so please list them and give a brief description of their background.')){
                application.Does_your_venture_have_any_advisors_If__c = response.Response__c;
            }else if(response.Question_English__c.equals('Have you generated any revenue? If so, how much have you generated and over what period of time?')){
                application.Have_you_generated_any_revenue_If_so_h__c = response.Response__c;
            }else if(response.Question_English__c.equals('Have you raised any money? If so, how much?')){
                application.Have_you_raised_any_money_If_so_how_mu__c = response.Response__c;
            }else if(response.Question_English__c.equals('Have you received any grant funding? If so, how much?')){
                application.Have_you_received_any_grant_funding_If__c = response.Response__c;
            }else if(response.Question_English__c.equals('How do you plan to protect your idea from competitors and imitators? (Inimitability and IP)')){
                application.How_do_you_plan_to_protect_your_idea_fro__c = response.Response__c;
            }else if(response.Question_English__c.equals('How do you sell to your customer?')){
                application.How_do_you_sell_to_your_customer__c = response.Response__c;
            }else if(response.Question_English__c.equals('How do you think the Creative Destruction Lab can help your venture succeed?')){
                application.How_do_you_think_the_Creative_Destructio__c = response.Response__c;
            }else if(response.Question_English__c.equals('How much time and money have you already spent on developing this business?')){
                application.How_much_time_and_money_have_you_already__c = response.Response__c;
            }else if(response.Question_English__c.equals('Is there anything else you would like to tell us?')){
                application.Is_there_anything_else_you_would_like_to__c = response.Response__c;
            }else if(response.Question_English__c.equals('Product/Service Overview (Briefly describe how your product or service works)')){
                application.Product_Service_Overview_Briefly_descri__c = response.Response__c;
            }else if(response.Question_English__c.equals('Venture Overview (Briefly describe your venture)')){
                application.Venture_Overview_Briefly_describe_your__c = response.Response__c;
            }else if(response.Question_English__c.equals('What is the long-term vision of your company? How is your product going to change the world?')){
                application.What_is_the_long_term_vision_of_your_com__c = response.Response__c;
            }else if(response.Question_English__c.equals('What is the single most important dimension on which your technology outperforms your competition?')){
                application.What_is_the_single_most_important_dimens__c = response.Response__c;
            }else if(response.Question_English__c.equals('What is the value proposition for this specific customer?')){
                application.What_is_the_value_proposition_for_this_s__c = response.Response__c;
            }else if(response.Question_English__c.equals('What kind of data do you have access to, and how much data do you need to train your learning algorithms?')){
                application.What_kind_of_data_do_you_have_access_to__c = response.Response__c;
            }else if(response.Question_English__c.equals('Who else is selling to your customer? Why will your customer buy your product or service instead of your competitor\'s?')){
                application.Who_else_is_selling_to_your_customer_Wh__c = response.Response__c;
            }else if(response.Question_English__c.equals('Why is it crucial to have a sophisticated machine learning algorithm at the core of the product or service?')){
                application.Why_is_it_crucial_to_have_a_sophisticate__c = response.Response__c;
            }/*else if(response.Question_English__c.equals('')){
                application. = response.Response__c;
            }*/
            
            applicationsToBeUpserted.put(application.Id, application);
        }
        
        //Database.upsert(applicationsToBeUpserted.values());
        System.debug('Application:  ' + applicationsToBeUpserted.values());
        update applicationsToBeUpserted.values();
    }
}