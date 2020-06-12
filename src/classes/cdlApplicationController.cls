//noinspection ApexUnresolvableReference
public class cdlApplicationController
{
  public String transDate { get; set; }
  public List<Document> logList { get; set; }
  public String logFolder;
  public Boolean DEBUG { get; set; }
  public String applicationId { get; set; }
  public Boolean qmlApplication { get; set; }
  public String verificationCode { get; set; }
  public Boolean incompleteApp { get; set; }
  public List<SelectOption> getIncompApp()
  {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('false','No'));
    options.add(new SelectOption('true','Yes'));
    return options;
  }
  public String applicationType { get; set; }
  public String applicationSite { get; set; }
  public Boolean allowColdApplication
  {
    get
    {
      Application_Settings__c appSettings
        = Application_Settings__c.getInstance('CDL Application Settings'); // + System.Today().year());
      allowColdApplication = appSettings.Allow_Cold_Application__c;
      if (allowColdApplication == false && applicationId != null) { allowColdApplication = true; }
      return allowColdApplication;
    } set;
  }
  public List<SelectOption> getAppSites()
  {
    List<SelectOption> appSites = new List<SelectOption>();
    appSites = getPickListValues(new Application__c(), 'Initial_CDL_Site_Preference__c', null);
    return appSites;
  }
  public List<SelectOption> getAppStreams()
  {
    List<SelectOption> appStreams = new List<SelectOption>();
    List<Stream__c> appStreamList = [select Id, Name from Stream__c];
    appStreams.add(new SelectOption('', '-- None --'));
    for (Stream__c stream : appStreamList)
    {
      appStreams.add(new SelectOption(stream.Id, stream.Name));
    }
    return appStreams;
  }
  public List<SelectOption> getAppTypes()
  {
    List<SelectOption> appTypes = new List<SelectOption>();
    appTypes = getPickListValues(new Application__c(), 'Application_Type__c', '-- None --');
    return appTypes;
  }
  public Application__c application { get; set; }
  public Id accountId { get; set; }
  public String ventureName { get; set; }
  public String ventureIndustry { get; set; }
  public List<SelectOption> getVenIndustry()
  {
    List<SelectOption> ventureIndustry = new List<SelectOption>();
    ventureIndustry = getPickListValues(new Account(), 'Industry_Multi__c', null);
    return ventureIndustry;
  }
  // Get And Set The Multi-Select PickList As Checkboxes
  public String[] ventureIndustryValues
  {
    get
    {
      String[] selected = new List<String>();
      List<SelectOption> selectOptionList = getVenIndustry();
      for (SelectOption selectOption : selectOptionList)
      {
        if (ventureIndustry != null && ventureIndustry.contains(selectOption.getValue()))
        { selected.add(selectOption.getValue()); }
      }
      return selected;
    }
    public set
    {
      String selectedConcat = '';
      for(String s : value)
      {
        if (selectedConcat == '') { selectedConcat += s; }
        else { selectedConcat += ';' + s; }
      }
      ventureIndustry = selectedConcat;
    }
  }
  public String industryOther { get; set; }
  public String ventureWebSite { get; set; }
  public String ventureAngelListProfile { get; set; }
  public String salutation { get; set; }
  public List<SelectOption> getSalTypes()
  {
    List<SelectOption> salTypes = new List<SelectOption>();
    salTypes = getPickListValues(new Contact(), 'Salutation', '-- None --');
    return salTypes;
  }
  public String gender { get; set;}
  public List<SelectOption> getGenderTypes()
  {
    List<SelectOption> genderTypes = new List<SelectOption>();
    genderTypes = getPickListValues(new Contact(), 'Gender__c', '-- None --');
    return genderTypes;
  }
  public String firstName { get; set; }
  public String lastName { get; set; }
  public String email { get; set; }
  public String phone { get; set; }
  public String street { get; set; }
  public String city { get; set; }
  public String provState { get; set; }
  public List<SelectOption> getProvStateOptions()
  {
    List<SelectOption> provState = new List<SelectOption>();
    provState = getPickListValues(new Contact(), 'MailingStateCode', '-- None --');
    return provState;
  }
  public String postalCode { get; set; }
  public String country { get; set; }
  public List<SelectOption> getCountryOptions()
  {
    List<SelectOption> country = new List<SelectOption>();
    country = getPickListValues(new Contact(), 'MailingCountryCode', '-- None --');
    return country;
  }
  public String skypeID { get; set; }
  public String twitterID { get; set; }
  public String linkedInID { get; set; }
  public String faceBookID { get; set; }
  public String crunchBaseID { get; set; }
  public String hackerNewsID { get; set; }
  public String gitHubID { get; set; }
  public String otherProfileID { get; set; }
  public String language { get; set; }
  public Integer numberOfEmployees { get; set; }
  public List<SelectOption> getDegreeTypes()
  {
    List<SelectOption> degreeTypes = new List<SelectOption>();
    degreeTypes = getPickListValues(new Education__c(), 'Degree__c', '-- None --');
    return degreeTypes;
  }
  public Integer numberOfDegrees { get; set; }
  public Integer tNumberOfDegrees { get; set; }
  public List<SelectOption> getNumOfDegrees()
  {
    List<SelectOption> numberOfDegrees = new List<SelectOption>();
    numberOfDegrees.add(new SelectOption('0', '0'));
    numberOfDegrees.add(new SelectOption('1', '1'));
    numberOfDegrees.add(new SelectOption('2', '2'));
    numberOfDegrees.add(new SelectOption('3', '3'));
    return numberOfDegrees;
  }
  public List<education> contactEducationList
  {
    get
    {
      if (contactEducationList == null || contactEducationList.isEmpty() || numberOfDegrees != tNumberOfDegrees)
      {
        contactEducationList = new List<education>();
        for (Integer i = 0; i < numberOfDegrees; i++)
        {
          education edu = new education();
          edu.degree = ''; edu.specialization = '';
          edu.yearOfGraduation = null; edu.gpa = null;
          edu.institute = ''; contactEducationList.add(edu);
        }
        tNumberOfDegrees = numberOfDegrees;
        return contactEducationList;
      } else
      {
        return contactEducationList;
      }
    }
    set;
  }
  public String stageOfVenture { get; set; }
  public List<SelectOption> getStageOfVen()
  {
    List<SelectOption> stageOfVenture = new List<SelectOption>();
    stageOfVenture = getPickListValues(new Account(), 'Stage_of_Venture__c', null);
    return stageOfVenture;
  }
  public Integer numberOfFounders { get; set; }
  public Integer tNumberOfFounders { get; set; }
  public List<SelectOption> getNumOfFounders()
  {
    List<SelectOption> numberOfFounders = new List<SelectOption>();
    numberOfFounders.add(new SelectOption('0', '0'));
    numberOfFounders.add(new SelectOption('1', '1'));
    numberOfFounders.add(new SelectOption('2', '2'));
    numberOfFounders.add(new SelectOption('3', '3'));
    return numberOfFounders;
  }
  public List<founderContact> founderList
  {
    get
    {
      if (founderList == null || founderList.isEmpty() || numberOfFounders != tNumberOfFounders)
      {
        founderList = new List<founderContact>();
        for (Integer i = 0; i < numberOfFounders; i++)
        {
          founderContact con = new founderContact();
          con.firstName = ''; con.lastName = ''; con.email = '';
          List<education> educationList = null;
          educationList = new List<education>();
          for (Integer ii = 0; ii < 3; ii++)
          {
            education edu = new education();
            edu.degree = ''; edu.specialization = '';
            edu.yearOfGraduation = null; edu.gpa = null; //0.00;
            edu.institute = ''; educationList.add(edu);
          }
          con.founderEducations = educationList;
          founderList.add(con);
        }
        tNumberOfFounders = numberOfFounders;
        return founderList;
      } else { return founderList; }
    }
    set;
  }
  public String founderInformation { get; set; }
  public List<SelectOption> getPrefLangs()
  {
    List<SelectOption> prefLangs = new List<SelectOption>();
    prefLangs.add(new SelectOption('English','English'));
    prefLangs.add(new SelectOption('French','French'));
    return prefLangs;
  }
  public String techSpecialization { get; set; }
  public List<SelectOption> getTechSpecial
  {
    get
    {
      List<SelectOption> optionsList = getPickListValues(new Application__c(), 'Tech_Specialization__c', null);
      for (Integer i = (optionsList.size() - 1); i >= 0; i--)
      {
        if (optionsList.get(i).getValue() == 'Prime' || optionsList.get(i).getValue() == 'Quantum Machine Learning')
        { optionsList.remove(i); }
      }
      return optionsList;
    }
    set;
  }
  // Get And Set The Multi-Select PickList As Checkboxes
  public String[] techSpecializationValues
  {
    get
    {
      String[] selected = new List<String>();
      List<SelectOption> selectOptionList = getTechSpecial;
      for (SelectOption selectOption : selectOptionList)
      {
        if (techSpecialization != null && techSpecialization.contains(selectOption.getValue()))
        { selected.add(selectOption.getValue()); }
      }
      return selected;
    }
    public set
    {
      String selectedConcat = '';
      for(String s : value)
      {
        if (selectedConcat == '') { selectedConcat += s; }
        else { selectedConcat += ';' + s; }
      }
      techSpecialization = selectedConcat;
    }
  }
  public Contact contact { get; set; }
  public Contact hContact { get; set; }
  public Id contactId { get; set; }
  public Id contactAccountId { get; set; }
  public Account account { get; set; }
  public List<Response__c> responseList { get; set; }
  public String citizenship { get; set; }
  public List<SelectOption> getCitizenships()
  {
    List<SelectOption> citizenships = new List<SelectOption>();
    citizenships = getPickListValues(new Contact(), 'Citizenship__c', null);
    return citizenships;
  }
  public String raisedAnyCapital { get; set; }
  public List<SelectOption> getRaisedAnyCapitalOptions()
  {
    List<SelectOption> raisedAnyCapital = new List<SelectOption>();
    raisedAnyCapital = getPickListValues(new Contact(), 'Raised_Any_Capital__c', '-- None --');
    return raisedAnyCapital;
  }
  public String amountRaisedAndInvestors { get; set; }
  public String relevantExperience { get; set; }
  public String keyAwardsAndAchievements { get; set; }
  public String whyCoFounderIsImportant { get; set; }
  public String entrepreneurialExperience { get; set; }
  public Decimal softwareDevelopmentExperience { get; set; }
  public String hoursSpentOnVenture { get; set; }
  public List<SelectOption> getHoursSpentOnVentureOptions()
  {
    List<SelectOption> hoursSpentOnVenture = new List<SelectOption>();
    hoursSpentOnVenture = getPickListValues
      (new Contact(), 'Hours_Spent_on_Venture_in_Last_30_Days__c', '-- None --');
    return hoursSpentOnVenture;
  }
  public String hoursExpectedOnVenture { get; set; }
  public List<SelectOption> getHoursExpectedOnVentureOptions()
  {
    List<SelectOption> hoursExpectedOnVenture = new List<SelectOption>();
    hoursExpectedOnVenture = getPickListValues
      (new Contact(), 'Hrs_Expected_on_Venture_for_Next_8_Mths__c', '-- None --');
    return hoursExpectedOnVenture;
  }
  public String willingToRelocate { get; set; }
  public List<SelectOption> getWillingToRelocateOptions()
  {
    List<SelectOption> willingToRelocate = new List<SelectOption>();
    willingToRelocate = getPickListValues(new Contact(), 'Willing_to_Re_locate_to_Canada__c', '-- None --');
    return willingToRelocate;
  }
  public String personalityType { get; set; }
  public List<SelectOption> getPersonalityTypeOptions()
  {
    List<SelectOption> personalityType = new List<SelectOption>();
    personalityType = getPickListValues(new Contact(), 'Creative_Destruction_SF_Requirement__c', '-- None --');
    return personalityType;
  }
  public Integer numberOfProgLangs { get; set; }
  public Integer tNumberOfProgLangs { get; set; }
  public List<SelectOption> getNumOfProgLangs()
  {
    List<SelectOption> numberOfProgLangs = new List<SelectOption>();
    numberOfProgLangs.add(new SelectOption('0', '0'));
    numberOfProgLangs.add(new SelectOption('1', '1'));
    numberOfProgLangs.add(new SelectOption('2', '2'));
    numberOfProgLangs.add(new SelectOption('3', '3'));
    numberOfProgLangs.add(new SelectOption('4', '4'));
    numberOfProgLangs.add(new SelectOption('5', '5'));
    numberOfProgLangs.add(new SelectOption('6', '6'));
    numberOfProgLangs.add(new SelectOption('7', '7'));
    numberOfProgLangs.add(new SelectOption('8', '8'));
    numberOfProgLangs.add(new SelectOption('9', '9'));
    numberOfProgLangs.add(new SelectOption('10', '10'));
    return numberOfProgLangs;
  }
  /***
  public List<programmingLanguage> progLangList
  {
    get
    {
      if (progLangList == null || progLangList.isEmpty() || numberOfProgLangs != tNumberOfProgLangs)
      {
        progLangList = new List<programmingLanguage>();
        for (Integer i = 0; i < numberOfProgLangs; i++)
        {
          programmingLanguage pl = new programmingLanguage();
          pl.language = ''; pl.proficency = '';
          progLangList.add(pl);
        }
        tNumberOfProgLangs = numberOfProgLangs;
        return progLangList;
      } else
      {
        return progLangList;
      }
    }
    set;
  }
  ***/
 /* public List<SelectOption> getProgLangs()
  {
    List<SelectOption> progLangs = new List<SelectOption>();
    progLangs = getPickListValues(new Programming_Language__c(), 'Language__c', '-- None --');
    return progLangs;
  }*/
  //public List<Programming_Language__c> progLangList { get; set; }
  /***
  {
    get
    {
      List<SelectOption> progLangs = new List<SelectOption>();
      List<Programming_Language__c> progLangList = new List<Programming_Language__c>();
      progLangs = getPickListValues(new Programming_Language__c(), 'Language__c', '-- None --');
      for (SelectOption progLang : progLangs)
      {
        if (progLang.getValue() != '')
        {
          Programming_Language__c pLang = new Programming_Language__c();
          pLang.Contact__c = contactId;
          pLang.Language__c = progLang.getValue();
          pLang.Proficiency__c = '';
          progLangList.add(pLang);
        }
      }
      return progLangList;
    }
    set;
  }
  ***/
  /*public List<SelectOption> getProficencies()
  {
    List<SelectOption> proficencyOptions = new List<SelectOption>();
    proficencyOptions = getPickListValues(new Programming_Language__c(), 'Proficiency__c', null);
    return proficencyOptions;
  } */
  public String howDidYouHearAboutProgram { get; set; }
  public List<SelectOption> getHowDidYouHearAboutProgram
  {
    get
    {
      List<SelectOption> howDidYouHearList = new List<SelectOption>();
      howDidYouHearList
        = getPickListValues(new Application__c(), 'How_Did_You_Hear_About_the_Program__c', '-- None --');
      return howDidYouHearList;
    }
  }
  public String referralName { get; set; }
  public Boolean acknowledgement { get; set; }
  public String siteLabel
  {
    get
    {
      String sLabel = '';
      try
      {
        if (qmlApplication) { sLabel = Label.Site_Information; }
        else { sLabel = Label.Stream_Information; }
      } catch (Exception e) { sLabel = Label.Stream_Information; }
      return sLabel;
    }
    set;
  }
  public List<CDL_Site__c> cdlSiteList { get; set; }
  public String preferredSites { get; set; }
  
  public String debugInfo()
  {
    String debugInfo = ''; debugInfo += '\n/*** All Incoming Headers: ***/\n';
    for (String key : ApexPages.currentPage().getHeaders().keySet())
    {
      if (ApexPages.currentPage().getHeaders().get(key) != null)
      { debugInfo += key + ' = ' + ApexPages.currentPage().getHeaders().get(key) + '\n'; }
    }
    if (ApexPages.currentPage().getParameters().size() >= 1)
    {
      debugInfo += '\n/*** All Incoming Parameters: ***/\n';
      for (String key : ApexPages.currentPage().getParameters().keySet())
      {
        if (ApexPages.currentPage().getParameters().get(key) != null)
        { debugInfo += key + ' = ' + ApexPages.currentPage().getParameters().get(key) + '\n'; }
        if (debugInfo.endsWith('=\n')) { debugInfo = debugInfo.substring(0,debugInfo.length()-2); }
      }
    }
    return debugInfo;
  }
  
  public void start()
  {
    logList = new List<Document>(); applicationId = null;
    applicationId = ApexPages.currentPage().getParameters().get('applicationId');
    if (ApexPages.currentPage().getParameters().get('qmlApplication') != null)
    { qmlApplication = Boolean.valueOf(ApexPages.currentPage().getParameters().get('qmlApplication')); }
    else { qmlApplication = false; }
    Application_Settings__c appSettings
      = Application_Settings__c.getInstance('CDL Application Settings');
    allowColdApplication = appSettings.Allow_Cold_Application__c;
    logFolder = appSettings.LogFolder__c;
    DEBUG = appSettings.DebugFlag__c;
    if (DEBUG)
    {
      //transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
      //String userName = UserInfo.getName();
      //String logStr = 'logDate' + ' : ' + transDate;
      //logStr += '\n' + 'userName' + ' : ' + userName;
      //logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
      //Document logDoc
      //  = cdlUtilities.createLogDoc('CDLApplication (start)' + ' - ' + userName + ' - '
      //                              + transDate, logFolder, logStr, 'text/plain', 'log');
      //logList.add(logDoc);
    }
    if (logList != null) { insert logList; }
  }
  
  public void init()
  {
    logList = new List<Document>();
    if (applicationId != null && applicationId != '' && allowColdApplication)
    {
      try
      {
        application
          = [select Id, Application_Type__c, Name, Venture__c, Venture__r.Name,
             CDL_Site__c, CDL_Site__r.Name, Stream__c, Stream__r.Name, Initial_CDL_Site_Preference__c,
             Tech_Specialization__c, How_Did_You_Hear_About_the_Program__c, Application_Referral_Name__c
             from Application__c where Id =: applicationId limit 1];
        applicationType = application != null ? application.Application_Type__c : '-- None --';
        applicationSite = application.CDL_Site__c;
        applicationSite = application.Initial_CDL_Site_Preference__c;
        techSpecialization = application.Tech_Specialization__c;
        howDidYouHearAboutProgram = application.How_Did_You_Hear_About_the_Program__c;
        referralName = application.Application_Referral_Name__c;
        qmlApplication = application.Tech_Specialization__c.contains('Quantum Machine Learning') ? true : false;
        account = [select Id, Name, Online_Submission__c, Phone, BillingStreet, BillingCity,
                   BillingStateCode, BillingPostalCode, NumberOfEmployees, Stage_of_Venture__c,
                   Industry_Multi__c, Industry__c, AngelList_Profile__c, Website,
                   Co_Founders_Background__c, Personal_Info_Collection_Acknowledgement__c
                   from Account where Id =: application.Venture__c limit 1];
        contactAccountId = account.Id;
        ventureName = account.Name;
        ventureAngelListProfile = account.AngelList_Profile__c;
        numberOfEmployees = account.NumberOfEmployees;
        stageOfVenture = account.Stage_of_Venture__c;
        ventureIndustry = account.Industry_Multi__c;
        industryOther = account.Industry__c;
        ventureWebSite = account.Website;
        founderInformation = account.Co_Founders_Background__c;
        //acknowledgement = account.Personal_Info_Collection_Acknowledgement__c;
        responseList
          = [select Id, Application__c, Order__c, Question__c, Question_English__c, Question_French__c, Response__c
             from Response__c where Application__c =: application.Id order by Order__c];
        System.debug('responseList: ' + responseList);
      } catch (Exception e)
      {
        if (DEBUG)
        {
          transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
          String userName = UserInfo.getName();
          String logStr = 'logDate' + ' : ' + transDate;
          logStr += '\n' + 'userName' + ' : ' + userName;
          logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
          logStr += '\n' + 'error' + ' : ' + e.getMessage();
          Document logDoc
            = cdlUtilities.createLogDoc('CDLApplication (init)' + ' - ' + userName + ' - '
                                        + transDate, logFolder, logStr, 'text/plain', 'log');
          logList.add(logDoc);
        }
      }
      try
      {
        try
        {
          Id primaryContactId
            = [select Contact__c from Application_Contact__c
               where Application__c =: applicationId and Primary_Contact__c = true limit 1].Contact__c;
          contact = [select Id, AccountId, Preferred_Language__c, Salutation, Gender__c,
                     FirstName, LastName, Email, Phone,
                     MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, MailingCountryCode,
                     Skype_ID__c, Twitter_ID__c, LinkedIn_Profile__c, Other_Profile_URL__c,
                     Facebook_Page__c, Crunchbase_Profile__c, Hacker_News_Link__c, GitHub_Page__c,
                     Citizenship__c, Raised_Any_Capital__c, Amount_Raised_And_Investors__c, Relevant_Experience__c,
                     Key_Awards_and_Achievements__c, Why_Co_Founder_is_Important_for_Venture__c,
                     Entrepreneurial_Experience__c, Software_Development_Experience_Years__c,
                     Hours_Spent_on_Venture_in_Last_30_Days__c, Hrs_Expected_on_Venture_for_Next_8_Mths__c,
                     Willing_to_Re_locate_to_Canada__c, Creative_Destruction_SF_Requirement__c from Contact
                     where AccountId =: contactAccountId and Id =: primaryContactId limit 1];
        } catch (Exception e)
        {
          if (DEBUG)
          {
            transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
            String userName = UserInfo.getName();
            String logStr = 'logDate' + ' : ' + transDate;
            logStr += '\n' + 'userName' + ' : ' + userName;
            logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
            logStr += '\n' + 'error' + ' : ' + e.getMessage();
            Document logDoc
              = cdlUtilities.createLogDoc('CDLApplication (init)' + ' - ' + userName + ' - '
                                          + transDate, logFolder, logStr, 'text/plain', 'log');
            logList.add(logDoc);
          }
        }
        if (contact != null)
        {
          contactId = contact.Id; contactAccountId = contact.AccountId;
          language = contact.Preferred_Language__c;
          salutation = contact.Salutation; gender = contact.Gender__c;
          firstName = contact.FirstName; lastName = contact.LastName; email = contact.Email;
          phone = contact.Phone; street = contact.MailingStreet; city = contact.MailingCity;
          provState = contact.MailingStateCode; postalCode = contact.MailingPostalCode;
          country = contact.MailingCountryCode; skypeID = contact.Skype_ID__c;
          twitterID = contact.Twitter_ID__c; linkedInID = contact.LinkedIn_Profile__c;
          otherProfileID = contact.Other_Profile_URL__c; faceBookID = contact.Facebook_Page__c;
          crunchBaseID = contact.Crunchbase_Profile__c; hackerNewsID = contact.Hacker_News_Link__c;
          gitHubID = contact.GitHub_Page__c;
          relevantExperience = contact.Relevant_Experience__c;
          keyAwardsAndAchievements = contact.Key_Awards_and_Achievements__c;
          hContact = new Contact();
          hContact.MailingStateCode = provState;
          hContact.MailingCountryCode = country;
          if (language == '' || language == null)
          {
            language = contact.Preferred_Language__c != null ? contact.Preferred_Language__c : 'English';
          }
          try
          {
            List<education> ceList = new List<education>();
            List<Education__c> eduList
              = [select Id, Contact__c, Degree__c, Specialization__c, Graduation_Year__c, GPA__c, Institute__c
            //  = [select Id, Contact__c, Degree__c, Specialization__c, Graduation_Year__c, Institute__c
                 from Education__c where Contact__c =: contactId];
            numberOfDegrees = eduList.size(); tNumberOfDegrees = eduList.size();
            for (Education__c edu : eduList)
            {
              education e = new education();
              e.eduId = edu.Id;
              e.degree = edu.Degree__c;
              e.specialization = edu.Specialization__c;
              e.yearOfGraduation = edu.Graduation_Year__c;
              e.gpa = edu.GPA__c;
              e.institute = edu.Institute__c;
              contactEducationList.add(e);
            }
            // VisualForce - BUG??? - Too Many (double) reference???
            for (Integer i = (contactEducationList.size() / 2 - 1); i >= 0; i--)
            {
              contactEducationList.remove(i);
            }
            List<Application_Contact__c> fList
              = [select Id, Application__c, Contact__c, Contact__r.FirstName, Contact__r.LastName,
                 Contact__r.Gender__c, Contact__r.Email, Contact__r.Hours_Spent_on_Venture_in_Last_30_Days__c,
                 Contact__r.Hrs_Expected_on_Venture_for_Next_8_Mths__c, Contact__r.Relevant_Experience__c,
                 Contact__r.Key_Awards_and_Achievements__c, Contact__r.Why_Co_Founder_is_Important_for_Venture__c
                 from Application_Contact__c
                 where Application__c =: applicationId and Primary_Contact__c != true];
            numberOfFounders = fList.size(); tNumberOfFounders = fList.size();
            founderList = new List<founderContact>();
            for (Application_Contact__c appCon : fList)
            {
              founderContact fContact = new founderContact();
              fContact.founderId = appCon.Id;
              fContact.contactId = appCon.Contact__c;
              fContact.firstName = appCon.Contact__r.FirstName;
              fContact.lastName = appCon.Contact__r.LastName;
              fContact.gender = appCon.Contact__r.Gender__c;
              fContact.email = appCon.Contact__r.Email;
              fContact.hoursSpentOnVenture = appCon.Contact__r.Hours_Spent_on_Venture_in_Last_30_Days__c;
              fContact.hoursExpectedOnVenture = appCon.Contact__r.Hrs_Expected_on_Venture_for_Next_8_Mths__c;
              fContact.relevantExperience = appCon.Contact__r.Relevant_Experience__c;
              fContact.keyAwardsAndAchievements = appCon.Contact__r.Key_Awards_and_Achievements__c;
              fContact.whyCoFounderIsImportant = appCon.Contact__r.Why_Co_Founder_is_Important_for_Venture__c;
              List<Education__c> eList
                = [select Id, Contact__c, Degree__c, Specialization__c, Graduation_Year__c, GPA__c, Institute__c
              //  = [select Id, Contact__c, Degree__c, Specialization__c, Graduation_Year__c, Institute__c
                   from Education__c where Contact__c =: fContact.contactId];
              List<education> educationList = new List<education>();
              for (Integer i=0; i<3; i++) //for (Education__c e : eList)
              {
                education edu = new education();
                try
                {
                  Education__c e = eList.get(i); edu.eduId = e.Id;
                  edu.degree = e.Degree__c; edu.specialization = e.Specialization__c;
                  edu.yearOfGraduation = e.Graduation_Year__c; edu.gpa = e.GPA__c;
                  edu.institute = e.Institute__c;
                } catch (Exception e)
                {
                  edu.degree = ''; edu.specialization = '';
                  edu.yearOfGraduation = ''; edu.gpa = '0.00';
                  edu.institute = '';
                }
                educationList.add(edu);
              }
              fContact.founderEducations = educationList;
              founderList.add(fContact);
            }
            // VisualForce - BUG??? - Too Many (double) reference???
            for (Integer i = (founderList.size() / 2 - 1); i >= 0; i--)
            {
              founderList.remove(i);
            }
            citizenship = contact.Citizenship__c;
            raisedAnyCapital = contact.Raised_Any_Capital__c;
            amountRaisedAndInvestors = contact.Amount_Raised_And_Investors__c;
            relevantExperience = contact.Relevant_Experience__c;
            keyAwardsAndAchievements = contact.Key_Awards_and_Achievements__c;
            entrepreneurialExperience = contact.Entrepreneurial_Experience__c;
            softwareDevelopmentExperience = contact.Software_Development_Experience_Years__c;
            hoursSpentOnVenture = contact.Hours_Spent_on_Venture_in_Last_30_Days__c;
            hoursExpectedOnVenture = contact.Hrs_Expected_on_Venture_for_Next_8_Mths__c;
            willingToRelocate = contact.Willing_to_Re_locate_to_Canada__c;
            personalityType = contact.Creative_Destruction_SF_Requirement__c;
            // Programming Language(s)
            //List<programmingLanguage> plList = new List<programmingLanguage>();
           /* List<Programming_Language__c> pList
              = [select Id, Contact__c, Language__c, Proficiency__c
                 from Programming_Language__c where Contact__c =: contactId];
            progLangList = plist;
            Set<String> pSet = new Set<String>();
            for (Programming_Language__c p : pList) { pSet.add(p.Language__c); }
            List<SelectOption> progLangs = new List<SelectOption>(); */
            //List<Programming_Language__c> progLangList = new List<Programming_Language__c>();
          /*  progLangs = getPickListValues(new Programming_Language__c(), 'Language__c', '-- None --');
            for (SelectOption progLang : progLangs)
            {
              if (progLang.getValue() != '' && !pSet.contains(progLang.getValue()))
              {
                Programming_Language__c pLang = new Programming_Language__c();
                pLang.Contact__c = contactId;
                pLang.Language__c = progLang.getValue();
                pLang.Proficiency__c = null;
                progLangList.add(pLang);
              }
            } */
            //progLangList = pList;
            /***
            numberOfProgLangs = pList.size(); tnumberOfProgLangs = pList.size();
            for (Programming_Language__c pl : pList)
            {
              programmingLanguage p = new programmingLanguage();
              p.plId = pl.Id;
              p.language = pl.Language__c;
              p.proficency = pl.Proficiency__c;
              plList.add(p);
            }
            //progLangList = plList;
            ***/
          } catch (Exception e)
          {
            if (DEBUG)
            {
              transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
              String userName = UserInfo.getName();
              String logStr = 'logDate' + ' : ' + transDate;
              logStr += '\n' + 'userName' + ' : ' + userName;
              logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
              logStr += '\n' + 'error' + ' : ' + e.getMessage();
              Document logDoc
                = cdlUtilities.createLogDoc('CDLApplication (init)' + ' - ' + userName + ' - '
                  + transDate, logFolder, logStr, 'text/plain', 'log');
              logList.add(logDoc);
            }
          }
        }
      } catch (Exception e)
      {
        contactAccountId = application.Venture__c;
        if (DEBUG)
        {
          transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
          String userName = UserInfo.getName();
          String logStr = 'logDate' + ' : ' + transDate;
          logStr += '\n' + 'userName' + ' : ' + userName;
          logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
          logStr += '\n' + 'error' + ' : ' + e.getMessage();
          Document logDoc
            = cdlUtilities.createLogDoc('CDLApplication (init)' + ' - ' + userName + ' - '
                                        + transDate, logFolder, logStr, 'text/plain', 'log');
          logList.add(logDoc);
        }
      }
    }
    if (numberOfDegrees == null) { numberOfDegrees = 0; }
    if (tNumberOfDegrees == null) { tNumberOfDegrees = 0; }
    if (numberOfProgLangs == null) { numberOfProgLangs = 0; }
    if (tNumberOfProgLangs == null) { tNumberOfProgLangs = 0; }
    if (hContact == null) { hContact = new Contact(); hContact.MailingCountryCode = 'CA'; }
    if (logList != null) { insert logList; }
  }
  
  public void getResponses()
  {
    logList = new List<Document>();
    applicationId = ApexPages.currentPage().getParameters().get('applicationId');
    if (responseList == null && applicationId != null)
    {
      try
      {
        responseList
          = [select Id, Application__c, Order__c, Question_English__c, Question_French__c, Response__c
             from Response__c where Application__c =: applicationId order by Order__c];
      } catch (Exception e) { System.debug(e.getMessage()); }
    }
    /***
    transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
    String userName = UserInfo.getName();
    String logStr = 'logDate' + ' : ' + transDate;
    logStr += '\n' + 'userName' + ' : ' + userName;
    logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
    for (Response__c response : responseList)
    {
      logStr += '\n' + 'responseList' + ' : ' + response.Id + ' ' + response.Application__c + ' ' + response.Order__c;
      logStr += ' ' + response.Question_English__c + ' ' + response.Question_French__c + ' ' + response.Response__c;
    }
    Document logDoc
      = cdlUtilities.createLogDoc('CDLApplication (getResponses)' + ' - ' + userName + ' - '
                                  + transDate, logFolder, logStr, 'text/plain', 'log');
    logList.add(logDoc);
    ***/
    if (logList != null) { insert logList; }
  }
  
  public PageReference saveContact()
  {
    logList = new List<Document>();
    try
    {
      Contact con = new Contact();
      if (contactId != null) { con.Id = contactId; }
      con.Online_Submission__c = true;
      con.RecordTypeId
        = [select Id from RecordType where sObjectType = 'Contact' and Name = 'Venture Contact' limit 1].Id;
      con.Salutation = salutation;
      con.FirstName = firstName;
      con.LastName = lastName;
      con.Gender__c = gender;
      con.Phone = phone;
      con.MailingStreet = street;
      con.MailingCity = city;
      provState = hContact.MailingStateCode;
      con.MailingStateCode = provState; //contact.MailingStateCode;
      con.MailingPostalCode = postalCode;
      country = hContact.MailingCountryCode;
      con.MailingCountryCode = country; //contact.MailingCountryCode;
      con.Email = email;
      con.Preferred_Language__c = language;
      if (contactId != null) { upsert con; }
      else { insert con; contactId = con.Id; }
      Account account = new Account();
      if (contactAccountId != null) { account.Id = contactAccountId; }
      account.Online_Submission__c = true;
      account.Name = ventureName == '' && qmlApplication == true ? firstName + ' ' + lastName : ventureName;
      account.RecordTypeId
        = [select Id from RecordType where sObjectType = 'Account' and Name = 'Venture Account' limit 1].Id;
      account.Phone = phone;
      account.BillingStreet = street;
      account.BillingCity = city;
      account.BillingStateCode = provState;
      account.BillingPostalCode = postalCode;
      account.BillingCountryCode = country;
      account.Industry_Multi__c = ventureIndustry;
      account.Industry__c = industryOther;
      if (contactAccountId != null) { upsert account; }
      else { insert account; contactAccountId = account.Id; }
      con.AccountId = contactAccountId; upsert con;
      Application__c app = new Application__c();
      if (applicationId != null) { app.Id = applicationId; }
      app.Online_Application_Submission__c = true;
      app.Venture__c = account.Id;
      if (applicationId != null) { upsert app; }
      else
      {
        app.Tech_Specialization__c = null;
        app.Application_Stage__c = 'Application In Progress';
        insert app; applicationId = app.Id;
      }
      verificationCode
        = [select Verification_CodeRO__c from Application__c where Id =: applicationId limit 1].Verification_CodeRO__c;
      Application_Contact__c appCon;
      try
      {
        appCon = [select Id, Application__c, Contact__c from Application_Contact__c
                  where Application__c =: applicationId and Contact__c =: contactId limit 1];
      } catch (Exception e) {}
      Application_Contact__c appContact = new Application_Contact__c();
      if (appCon != null) { appContact.Id = appCon.Id; }
      else { appContact.Application__c = applicationId; }
      appContact.Contact__c = contactId;
      appContact.Primary_Contact__c = true; upsert appContact;
      app.Initial_CDL_Site_Preference__c = applicationSite;
      try
      {
        if (!techSpecialization.contains('Prime')) { techSpecialization += ';' + 'Prime'; }
      } catch (Exception e) {}
      try
      {
        if (qmlApplication) { techSpecialization = 'Quantum Machine Learning'; }
      } catch (Exception e) {}
      app.Tech_Specialization__c = techSpecialization; update app;
    } catch (Exception e)
    {
      if (DEBUG)
      {
        //transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
        //String userName = UserInfo.getName();
        //String logStr = 'logDate' + ' : ' + transDate;
        //logStr += '\n' + 'userName' + ' : ' + userName;
        //logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
        //logStr += '\n' + 'error' + ' : ' + e.getMessage();
        //Document logDoc
        //  = cdlUtilities.createLogDoc('CDLApplication (saveContact)' + ' - ' + userName + ' - '
        //                              + transDate, logFolder, logStr, 'text/plain', 'log');
        //logList.add(logDoc);
      }
      if (logList != null) { insert logList; }
      ApexPages.addMessage(new ApexPages.Message
        (ApexPages.Severity.ERROR, e.getMessage() + '  Problem Saving Application!'));
      return null;
    }
    if (logList != null) { insert logList; }
    PageReference pageRef = Page.cdlApplicationContactDetails;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false); return pageRef;
  }
  
  public PageReference sendVCEmail()
  {
    String emailAddress = [select Email from Contact where Id =: contactId limit 1].Email;
    String emailTemplateName = 'CDL Application Verification Code';
    Id templateId
      = [select Id from EmailTemplate where Name =: emailTemplateName].Id;
    Boolean isSuccess = sendEmail(emailAddress, templateId, contactId, applicationId);
    if (isSuccess)
    { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '  Email Sent Successfully!')); }
    return null;
  }
  
  public Boolean sendEmail(String emailAddress, Id templateId, Id contactId, Id applicationId)
  {
    //String emailTemplateName = 'CDL Application Verification Code';
    //EmailTemplate emailTemplate
    //  = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name =: emailTemplateName];
    List<String> toAddress = new List<String>();
    toAddress.add(emailAddress);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setTemplateId(templateId);
    OrgWideEmailAddress[] owea
      = [select Id from OrgWideEmailAddress where Address = 'info@creativedestructionlab.com'];
    if (owea.size() > 0) { mail.setOrgWideEmailAddressId(owea.get(0).Id); }
    mail.setToAddresses(toAddress);
    //mail.setSubject('test subject');
    //String htmlBody = emailTemplate.HtmlValue;
    //htmlBody = htmlBody.replace('&lt;!--VERIFICATION_CODE--&gt;', verificationCode);
    //String plainBody = emailTemplate.Body;
    //plainBody = plainBody.replace('<!--VERIFICATION_CODE-->', verificationCode);
    //mail.setHtmlBody(htmlBody);
    //mail.setPlainTextBody(plainBody);
    mail.setTargetObjectId(contactId);
    mail.setTreatTargetObjectAsRecipient(false);
    mail.setWhatId(applicationId);
    mail.setSaveAsActivity(false);
    mail.setUseSignature(false);
    try
    {
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });
      return true;
    } catch (Exception e) { return false; } //{ System.debug(e.getMessage()); return false;}
  }
  
  public pageReference saveContactDetails()
  {
    logList = new List<Document>();
    try
    {
      Contact con = new Contact();
      if (contactId != null) { con.Id = contactId; }
      con.Skype_ID__c = skypeID;
      con.Twitter_ID__c = twitterID;
      con.LinkedIn_Profile__c = linkedInID;
      con.Facebook_Page__c = faceBookID;
      con.Crunchbase_Profile__c = crunchBaseID;
      con.Hacker_News_Link__c = hackerNewsID;
      con.GitHub_Page__c = gitHubID;
      con.Other_Profile_URL__c = otherProfileID;
      con.Hours_Spent_on_Venture_in_Last_30_Days__c = hoursSpentOnVenture;
      con.Hrs_Expected_on_Venture_for_Next_8_Mths__c = hoursExpectedOnVenture;
      con.Relevant_Experience__c = relevantExperience;
      con.Key_Awards_and_Achievements__c = keyAwardsAndAchievements;
      //con.Why_Co_Founder_is_Important_for_Venture__c = whyCoFounderIsImportant;
      if (contactId != null) { update con; }
      for (education education : contactEducationList)
      {
        //if (education.degree != '' && education.specialization != '' &&
        //    education.yearOfGraduation != '' && education.institute != '')
        if (education.degree != '' || education.specialization != '' ||
            education.yearOfGraduation != '' || education.institute != '')
        {
          Education__c edu = new Education__c();
          edu.Id = education.eduId;
          edu.Contact__c = contactId;
          edu.Degree__c = education.degree;
          edu.Specialization__c = education.specialization;
          edu.Graduation_Year__c = education.yearOfGraduation;
          edu.GPA__c = education.gpa;
          edu.Institute__c = education.institute;
          upsert edu;
        }
      }
    } catch (Exception e)
    {
      if (DEBUG)
      {
        //transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
        //String userName = UserInfo.getName();
        //String logStr = 'logDate' + ' : ' + transDate;
        //logStr += '\n' + 'userName' + ' : ' + userName;
        //logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
        //logStr += '\n' + 'error' + ' : ' + e.getMessage();
        //Document logDoc
        //  = cdlUtilities.createLogDoc('CDLApplication (saveContactDetails)' + ' - ' + userName + ' - '
        //                              + transDate, logFolder, logStr, 'text/plain', 'log');
        //logList.add(logDoc);
      }
      ApexPages.addMessage
        (new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Problem Saving Application!'));
      if (logList != null) { insert logList; }
      return null;
    }
    if (logList != null) { insert logList; }
    PageReference pageRef = Page.cdlApplicationVenture;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false); return pageRef;
  }
  
  /***
  public pageReference saveEducation()
  {
    try
    {
      for (education education : contactEducationList)
      {
        if (education.degree != '' && education.specialization != '' &&
            education.yearOfGraduation != '' && education.institute != '')
        {
          Education__c edu = new Education__c();
          edu.Id = education.eduId;
          edu.Contact__c = contactId;
          edu.Degree__c = education.degree;
          edu.Specialization__c = education.specialization;
          edu.Graduation_Year__c = education.yearOfGraduation;
          edu.GPA__c = education.gpa;
          edu.Institute__c = education.institute;
          upsert edu;
        }
      }
      PageReference pageRef = Page.cdlApplicationVenture;
      pageRef.getParameters().put('applicationId', applicationId);
      pageRef.setRedirect(false); return pageRef;
    } catch (Exception e)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Problem Saving Application!'));
      return null;
    }
  }
  ***/
  
  public PageReference saveVenture()
  {
    logList = new List<Document>();
    try
    {
      Account account = new Account();
      if (contactAccountId != null) { account.Id = contactAccountId; }
      account.AngelList_Profile__c = ventureAngelListProfile;
      account.NumberOfEmployees = numberOfEmployees;
      account.Stage_of_Venture__c = stageOfVenture;
      account.Website = ventureWebSite;
      account.Co_Founders_Background__c = founderInformation;
      if (contactAccountId != null) { upsert account; }
      else { insert account; accountId = account.Id; }
      List<Contact> contactFounderList = new List<Contact>();
      List<Education__c> educationList = new List<Education__c>();
      Set<Id> contactFounderIdSet = new Set<Id>();
      if (founderList != null)
      {
        for (founderContact fc : founderList)
        {
          if (fc.firstName != '' && fc.lastName != '' && fc.email != '' && fc.gender != '')
          {
            Contact founder = new Contact();
            if (fc.contactId != null) { founder.Id = fc.contactId; }
            founder.Online_Submission__c = true;
            founder.RecordTypeId
              = [select Id from RecordType where sObjectType = 'Contact' and Name = 'Venture Contact' limit 1].Id;
            founder.AccountId = account.Id;
            founder.FirstName = fc.firstName;
            founder.LastName = fc.lastName;
            founder.Gender__c = fc.gender;
            founder.Email = fc.email;
            founder.Hours_Spent_on_Venture_in_Last_30_Days__c = fc.hoursSpentOnVenture;
            founder.Hrs_Expected_on_Venture_for_Next_8_Mths__c = fc.hoursExpectedOnVenture;
            founder.Relevant_Experience__c = fc.relevantExperience;
            founder.Key_Awards_and_Achievements__c = fc.keyAwardsAndAchievements;
            founder.Why_Co_Founder_is_Important_for_Venture__c = fc.whyCoFounderIsImportant;
            founder.Online_Submission__c = true;
            upsert founder; //contactFounderIdSet.add(founder.Id);
            Application_Contact__c appCon = new Application_Contact__c();
            try
            {
              appCon = [select Id, Application__c, Contact__c from Application_Contact__c
                        where Application__c =: applicationId and Contact__c =: fc.contactId limit 1];
              appCon.Id = fc.founderId;
              appCon.Contact__c = fc.contactId;
              upsert appCon;
            } catch (Exception e)
            {
              appCon.Id = fc.founderId;
              appCon.Application__c = applicationId;
              appCon.Contact__c = founder.Id;
              insert appCon;
            }
            for (education edu : fc.founderEducations)
            {
              //if (edu.degree != '-- None --' && edu.specialization != '' &&
              //    edu.yearOfGraduation != '' && edu.institute != '')
              if (edu.degree != '' || edu.specialization != '' ||
                  edu.yearOfGraduation != '' || edu.institute != '')
              {
                Education__c education = new Education__c();
                if (edu.eduId != null) { education.Id = edu.eduId; }
                education.Contact__c = founder.Id;
                education.Degree__c = edu.degree;
                education.Specialization__c = edu.specialization;
                education.Graduation_Year__c = edu.yearOfGraduation;
                education.GPA__c = edu.gpa;
                education.Institute__c = edu.institute;
                upsert education;
              }
            }
          }
        }
      }
    } catch (Exception e)
    {
      if (DEBUG)
      {
        transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
        String userName = UserInfo.getName();
        String logStr = 'logDate' + ' : ' + transDate;
        logStr += '\n' + 'userName' + ' : ' + userName;
        logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
        logStr += '\n' + 'error' + ' : ' + e.getMessage();
        Document logDoc
          = cdlUtilities.createLogDoc('CDLApplication (saveVenture)' + ' - ' + userName + ' - '
                                      + transDate, logFolder, logStr, 'text/plain', 'log');
        logList.add(logDoc);
      }
      ApexPages.addMessage
        (new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + '  Problem Saving Application!'));
      return null;
    }
    if (logList != null) { insert logList; }
    PageReference pageRef = Page.cdlApplicationQuestions;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false); return pageRef;
  }
  
  /***
  public PageReference saveSiteStream()
  {
    if (applicationId != null)
    {
      try
      {
        Application__c application = new Application__c();
        application.Id = applicationId;
        application.Initial_CDL_Site_Preference__c = applicationSite;
        application.Tech_Specialization__c = techSpecialization;
        update application;
      } catch (Exception e)
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Problem Saving!'));
        return null;
      }
    }
    PageReference pageRef = Page.cdlApplicationQuestions;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false); return pageRef;
  }
  ***/
  
  public PageReference saveResponses()
  {
    logList = new List<Document>();
    try
    {
      if (responseList != null && applicationId != null)
      {
        for (Response__c response : responseList)
        {
          if (response.Response__c.length() > 1000)
          {
            response.Response__c = response.Response__c.substring(0,1000);
          }
        }
        update responseList;
      }
    } catch (Exception e)
    {
      if (DEBUG)
      {
        transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
        String userName = UserInfo.getName();
        String logStr = 'logDate' + ' : ' + transDate;
        logStr += '\n' + 'userName' + ' : ' + userName;
        logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
        logStr += '\n' + 'error' + ' : ' + e.getMessage();
        Document logDoc
          = cdlUtilities.createLogDoc('CDLApplication (saveResponses)' + ' - ' + userName + ' - '
                                      + transDate, logFolder, logStr, 'text/plain', 'log');
        logList.add(logDoc);
      }
      if (logList != null) { insert logList; }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
      return null;
    }
    PageReference pageRef;
    if (qmlApplication != null && qmlApplication) { pageRef = Page.cdlApplicationQML; }
    else { pageRef = Page.cdlApplicationAdditionalInfo; }
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false); return pageRef;
  }
  
  public pageReference saveQMLDetails()
  {
    logList = new List<Document>();
    try
    {
      Contact contact = new Contact();
      contact.Id = contactId;
      contact.RecordTypeId
        = [select Id from RecordType where sObjectType = 'Contact' and Name = 'QML Contact' limit 1].Id;
      contact.Citizenship__c = citizenship;
      contact.Raised_Any_Capital__c = raisedAnyCapital;
      contact.Amount_Raised_And_Investors__c = amountRaisedAndInvestors;
      //contact.Relevant_Experience__c = relevantExperience;
      //contact.Key_Awards_and_Achievements__c = keyAwardsAndAchievements;
      contact.Entrepreneurial_Experience__c = entrepreneurialExperience;
      contact.Software_Development_Experience_Years__c = softwareDevelopmentExperience;
      //contact.Hours_Spent_on_Venture_in_Last_30_Days__c = hoursSpentOnVenture;
      //contact.Hrs_Expected_on_Venture_for_Next_8_Mths__c = hoursExpectedOnVenture;
      contact.Willing_to_Re_locate_to_Canada__c = willingToRelocate;
      contact.Creative_Destruction_SF_Requirement__c = personalityType;
      update contact;
    /*  for (Programming_Language__c pLang : progLangList)
      {
        if (pLang.Proficiency__c != null) // && pLang.Proficiency__c != '' && pLang.Proficiency__c != '--None--')
        { upsert pLang; }
      } */
      /***
      for (programmingLanguage progLang : progLangList)
      {
        if (progLang.language != '' && progLang.proficency != '')
        {
          Programming_Language__c pl = new Programming_Language__c();
          if (progLang.plId != null) { pl.Id = progLang.plId; }
          else { pl.Contact__c = contactId; }
          pl.Language__c = progLang.language;
          pl.Proficiency__c = progLang.proficency;
          upsert pl;
        }
      }
      ***/
    } catch (Exception e)
    {
      if (DEBUG)
      {
        transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
        String userName = UserInfo.getName();
        String logStr = 'logDate' + ' : ' + transDate;
        logStr += '\n' + 'userName' + ' : ' + userName;
        logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
        logStr += '\n' + 'error' + ' : ' + e.getMessage();
        Document logDoc
          = cdlUtilities.createLogDoc('CDLApplication (saveQMLDetails)' + ' - ' + userName + ' - '
                                      + transDate, logFolder, logStr, 'text/plain', 'log');
        logList.add(logDoc);
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Problem Saving Application!'));
      return null;
    }
    if (logList != null) { insert logList; }
    PageReference pageRef = Page.cdlApplicationAdditionalInfo;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false); return pageRef;
  }
  
  public PageReference saveApplication()
  {
    logList = new List<Document>();
    try
    {
      if ((howDidYouHearAboutProgram == 'Referral' && referralName != '' ||
           howDidYouHearAboutProgram != '-- None --')) //&& acknowledgement == true)
      {
        Application__c application = new Application__c();
        application.Id = applicationId;
        application.Application_Stage__c = 'Applied';
        application.How_Did_You_Hear_About_the_Program__c = howDidYouHearAboutProgram;
        application.Application_Referral_Name__c = referralName;
        update application;
        Account account = new Account();
        //System.debug('accountId: ' + accountId);
        account.Id = contactAccountId;
        //System.debug('acknowledgement: ' + acknowledgement);
        account.Personal_Info_Collection_Acknowledgement__c = true; //acknowledgement;
        update account;
      } else
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Please Complete All Required Fields!'));
        return null;
      }
    } catch (Exception e)
    {
      /***
      if (DEBUG)
      {
        transDate = System.now().format('MM/dd/YYYY h:mm:ss a');
        String userName = UserInfo.getName();
        String logStr = 'logDate' + ' : ' + transDate;
        logStr += '\n' + 'userName' + ' : ' + userName;
        logStr += '\n' + 'debugInfo' + ' : ' + debugInfo();
        logStr += '\n' + 'error' + ' : ' + e.getMessage();
        Document logDoc
          = cdlUtilities.createLogDoc('CDLApplication (init)' + ' - ' + userName + ' - '
                                      + transDate, logFolder, logStr, 'text/plain', 'log');
        logList.add(logDoc);
      }
      ***/
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Problem Saving!'));
      return null;
    }
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '  ' + Label.Application_Submit_Message));
    //return null;
    if (logList != null) { insert logList; }
    // Confirmation Email
    String emailAddress = [select Email from Contact where Id =: contactId limit 1].Email;
    String emailTemplateName = 'CDL Completed Application Email';
    Id templateId
      = [select Id from EmailTemplate where Name =: emailTemplateName].Id;
    Boolean isSuccess = sendEmail(emailAddress, templateId, contactId, applicationId);
    PageReference pageRef = Page.cdlApplicationSuccess;
    pageRef.setRedirect(false); return pageRef;
  }
  
  /***
  public PageReference initPage()
  {
    PageReference pageRef = Page.cdlApplicationInit; //new PageReference('/cdlApplication?applicationId=' + applicationId);
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  ***/
  
  public static List<SelectOption> getPickListValues(sObject objectName, String fieldName, String firstVal)
  {
    List<SelectOption> options = new List<SelectOption>();
    if (firstVal != null)
    {
      options.add(new SelectOption('', firstVal));
    }
    Schema.sObjectType sObjectType = objectName.getSObjectType();
    Schema.DescribeSObjectResult sObjectDesc = sObjectType.getDescribe();
    Map<String, Schema.SObjectField> field_map = sObjectDesc.fields.getMap();
    List<Schema.PicklistEntry> pickListValues = field_map.get(fieldName).getDescribe().getPickListValues();
    for (Schema.PicklistEntry ple : pickListValues)
    {
      options.add(new SelectOption(ple.getValue(), ple.getLabel()));
    }
    return options;
  }
  
  public PageReference contactPage()
  {
    try
    {
      //if (incompleteApp && verificationCode != '')
      if (!allowColdApplication && verificationCode != '')
      {
        try
        {
          applicationId
            = [select Id, Verification_CodeRO__c from Application__c
               where Verification_CodeRO__c =: verificationCode limit 1].Id;
        } catch (Exception e)
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Invalid Verification Code!'));
          return null;
        }
      //} else if (incompleteApp && verificationCode == '')
      } else if (!allowColdApplication && verificationCode == '')
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Verification Code Required!'));
        return null;
      } else if (allowColdApplication && (incompleteApp || incompleteApp == null) && verificationCode != '')
      {
        try
        {
          applicationId
            = [select Id, Verification_CodeRO__c from Application__c
               where Verification_CodeRO__c =: verificationCode limit 1].Id;
        } catch (Exception e)
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Invalid Verification Code!'));
          return null;
        }
      } else if (allowColdApplication && (incompleteApp || incompleteApp == null) && verificationCode == '')
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Verification Code Required!'));
        return null;
      }
    } catch (Exception e)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Verification Code Required!'));
      return null;
    }
    PageReference pageRef = Page.cdlApplicationContact;
    if (applicationId != null)
    { pageRef.getParameters().put('applicationId', applicationId); }
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  public PageReference cdlSites()
  {
    try
    {
      if (verificationCode != '')
      {
        try
        {
          applicationId
            = [select Id, Verification_CodeRO__c from Application__c
               where Verification_CodeRO__c =: verificationCode limit 1].Id;
        } catch (Exception e)
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Invalid Verification Code!'));
          return null;
        }
      } else
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Verification Code Required!'));
        return null;
      }
    } catch (Exception e)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Verification Code Required!'));
      return null;
    }
    try
    {
      cdlSiteList = [select Id, Name from CDL_Site__c];
    } catch (Exception e) {}
    PageReference pageRef = Page.cdlApplicationSites;
    if (applicationId != null)
    { pageRef.getParameters().put('applicationId', applicationId); }
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  public PageReference saveSites()
  {
    if (preferredSites != null && preferredSites != '')
    {
      try
      {
        String[] cdlSiteArray = preferredSites.split(';');
        Map<Integer, Id> siteIdMap = new Map<Integer, Id>();
        Integer i = 1;
        for (String site : cdlSiteArray)
        {
          Id siteId = [select Id, Name from CDL_Site__c where Name =: site limit 1].Id;
          siteIdMap.put(i, siteId); i++;
        }
        for (Integer ii : siteIdMap.keySet())
        {
          Application_CDL_Sites__c cdlSite = new Application_CDL_Sites__c();
          cdlSite.Application__c = applicationId;
          cdlSite.Preference_Order__c = ii;
          cdlSite.CDL_Site__c = siteIdMap.get(ii);
          insert cdlSite;
        }
        PageReference pageRef = Page.cdlApplicationSiteSuccess;
        return pageRef;
      } catch (Exception e)
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Error Setting Site Preferences!'));
        return null;
      }
    } else
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '  Please Select Site Preferences!'));
      return null;
    }
  }
  
  public PageReference resetSites()
  {
    preferredSites = null;
    PageReference pageRef = Page.cdlApplicationSites;
    return pageRef;
  }
  
  public PageReference initPage()
  {
    PageReference pageRef = Page.cdlApplication;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  public PageReference contactDetails()
  {
    PageReference pageRef = Page.cdlApplicationContactDetails;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  public PageReference venturePage()
  {
    PageReference pageRef = Page.cdlApplicationVenture;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  public PageReference applicationQuestions()
  {
    PageReference pageRef;
    if (qmlApplication != null && qmlApplication) { pageRef = Page.cdlApplicationQML; }
    else { pageRef = Page.cdlApplicationQuestions; }
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  public PageReference applicationQuestionsQML()
  {
    PageReference pageRef = Page.cdlApplicationQuestions;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  /***
  public PageReference teamPage()
  {
    PageReference pageRef = Page.cdlApplicationTeam;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  ***/
  
  public PageReference previousPage()
  {
    PageReference pageRef = Page.cdlApplicationContact;
    pageRef.getParameters().put('applicationId', applicationId);
    pageRef.setRedirect(false);
    return pageRef;
  }
  
  public class founderContact
  {
    public Id founderId { get; set; }
    public Id contactId { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String gender { get; set; }
    public String email { get; set; }
    public String hoursSpentOnVenture { get; set; }
    public String hoursExpectedOnVenture { get; set; }
    public String relevantExperience { get; set; }
    public String keyAwardsAndAchievements { get; set; }
    public String whyCoFounderIsImportant { get; set; }
    //public Integer numberOfDegrees { get; set; }
    public List<education> founderEducations { get; set; }
  }
  
  public class education
  {
    //public String contactId { get; set; }
    public Id eduId { get; set; }
    public String degree { get; set; }
    public String specialization { get; set; }
    public String yearOfGraduation { get; set; }
    //public Decimal gpa { get; set; }
    public String gpa { get; set; }
    public String institute { get; set; }
  }
  
  public class response
  {
    public Id rId { get; set; }
    public String questionEnglish { get; set; }
    public String questionFrench { get; set; }
    public String responseAnswer { get; set; }
  }
  
  /***
  public class programmingLanguage
  {
    public Id plId { get; set; }
    public String language { get; set; }
    public String proficency { get; set; }
  }
  ***/
}