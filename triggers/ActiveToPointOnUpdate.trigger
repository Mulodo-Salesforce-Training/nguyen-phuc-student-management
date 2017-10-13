trigger ActiveToPointOnUpdate on Student_Skill__c ( after update ) {

    if ( Trigger.isUpdate && Trigger.isAfter ) {
        // Detect if status change to disabled value and get list record
        List< Id > listSkillDisabled    = new List< Id >();
        List< Id > listSkillNotDisabled = new List< Id >();

        for ( Student_Skill__c skill : Trigger.New ) {

            if ( skill.Active__c ) {
                listSkillNotDisabled.add( skill.Id );
            } else {
                listSkillDisabled.add( skill.Id );
            }

        }

        // Get list Student Score relate with Student record
        List< Student_Scoring_Skill__c > listStuScore = new List< Student_Scoring_Skill__c >();
        List< Student_Scoring_Skill__c > listToUpdate = new List< Student_Scoring_Skill__c >();

        // Update from another change to disabled
        if ( listSkillDisabled.size() > 0 ) {
            listStuScore = [SELECT Point__c FROM Student_Scoring_Skill__c WHERE Student_Skill__r.Id IN: listSkillDisabled AND Point__c != 0];

            for ( Student_Scoring_Skill__c stuScore : listStuScore ) {
                stuScore.Point__c = 0;
                listToUpdate.add( stuScore );
            }

            update listToUpdate;
        }

        // Update from disabled to another
        if ( listSkillNotDisabled.size() > 0 ) {
            listStuScore = [SELECT Point__c, Student__r.Status__c, Student_Skill__r.Point__c FROM Student_Scoring_Skill__c WHERE Student_Skill__r.Id IN: listSkillNotDisabled AND Student__r.Status__c != 'Disabled'];

            for ( Student_Scoring_Skill__c stuScore : listStuScore ) {
                stuScore.Point__c = stuScore.Student_Skill__r.Point__c;
                listToUpdate.add( stuScore );
            }

            update listToUpdate;
        }

    }

}