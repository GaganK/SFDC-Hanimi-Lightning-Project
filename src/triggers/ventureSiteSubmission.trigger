trigger ventureSiteSubmission on Venture_Site_Submission__c (after insert)
{
  List<Venture_Site_Submission__c> ventureSiteSubmissionsList
    = [select Id, Application__c, Site_Rankings__c from Venture_Site_Submission__c where Id in: Trigger.new];
  List<Ranking__c> rankingList = new List<Ranking__c>(); Integer rankNumber = 1;
  List<CDL_Site__c> cdlSiteList
    = [select Id, Name, Sequence__c, (select Id, CDL_Site__r.Name, Cohort__c, Sequence__c, Cohort_Year__c, Status__c
                                      from Cohorts__r where Sequence__c != null and Status__c = 'Active'
                                      and Cohort_Year__c = '2018-2019' order by Sequence__c)
       from CDL_Site__c where Sequence__c != null order by Sequence__c];
  for (Venture_Site_Submission__c vss : ventureSiteSubmissionsList)
  {
    if (vss.Application__c != null && vss.Site_Rankings__c != null && vss.Site_Rankings__c != '')
    {
      for (String rank : vss.Site_Rankings__c.split(';'))
      {
        for (CDL_Site__c cs : cdlSiteList)
        {
          if (rank.trim().contains(cs.Name))
          {
            for (Cohort__c c : cs.Cohorts__r)
            {
              Ranking__c ranking = new Ranking__c();
              ranking.Application__c = vss.Application__c;
              ranking.Cohort__c = c.Id;
              ranking.Ranked_By__c = 'Venture';
              ranking.Rank_Number__c = rankNumber;
              rankNumber++; rankingList.add(ranking);
            }
          }
        }
      }
    }
  }
  if (rankingList != null && rankingList.size() > 0) { insert rankingList; }
}