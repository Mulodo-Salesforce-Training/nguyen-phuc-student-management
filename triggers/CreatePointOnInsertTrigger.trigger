trigger CreatePointOnInsertTrigger on Student_Scoring_Skill__c ( after insert ) {

    if ( Trigger.isAfter && Trigger.isInsert ) {
        List< Id > listStuScoreId                     = new List< Id >();
        List< Student_Scoring_Skill__c > listStuScore = new List< Student_Scoring_Skill__c >();
        List< Student_Scoring_Skill__c > listToUpdate = new List< Student_Scoring_Skill__c >();

        for ( Student_Scoring_Skill__c stuScore : Trigger.New ) {
            listStuScoreId.add( stuScore.Id );
        }

        listStuScore = [SELECT Point__c, Student_Skill__r.Active__c, Student_Skill__r.Point__c, Student__r.Status__c FROM Student_Scoring_Skill__c WHERE Id IN :listStuScoreId];

        for ( Student_Scoring_Skill__c stuScore : listStuScore ) {
            if ( !stuScore.Student__r.Status__c.equalsIgnoreCase( 'Disabled' ) && stuScore.Student_Skill__r.Active__c ) {
                stuScore.Point__c = stuScore.Student_Skill__r.Point__c;
                listToUpdate.add( stuScore );
            }
        }

        update listToUpdate;

    }

}