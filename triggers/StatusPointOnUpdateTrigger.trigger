trigger StatusPointOnUpdateTrigger on Student__c ( after update ) {

    if ( Trigger.isUpdate && Trigger.isAfter ) {
        // Detect if status change to disabled value and get list record
        List< Student__c > listStudentDisabled    = new List< Student__c >();
        List< Student__c > listStudentNotDisabled = new List< Student__c >();

        for ( Student__c student : Trigger.New ) {

            if ( student.Status__c == 'Disabled' ) {
                listStudentDisabled.add( student );
            } else {
                listStudentNotDisabled.add( student );
            }

        }

        // Get list Student Score relate with Student record
        List< Student_Scoring_Skill__c > listStuScore = new List< Student_Scoring_Skill__c >();
        List< Student_Scoring_Skill__c > listToUpdate = new List< Student_Scoring_Skill__c >();

        // Update from another change to disabled
        if ( listStudentDisabled.size() > 0 ) {
            listStuScore = [SELECT Point__c FROM Student_Scoring_Skill__c WHERE Student__c IN: listStudentDisabled AND Point__c != 0];

            for ( Student_Scoring_Skill__c stuScore : listStuScore ) {
                stuScore.Point__c = 0;
                listToUpdate.add( stuScore );
            }

            update listToUpdate;
        }

        // Update from disabled to another
        if ( listStudentNotDisabled.size() > 0 ) {
            listStuScore = [SELECT Point__c, Student_Skill__r.Active__c, Student_Skill__r.Point__c FROM Student_Scoring_Skill__c WHERE Student__c IN: listStudentNotDisabled AND Point__c = 0 AND Student_Skill__r.Active__c = true];

            for ( Student_Scoring_Skill__c stuScore : listStuScore ) {
                stuScore.Point__c = stuScore.Student_Skill__r.Point__c;
                listToUpdate.add( stuScore );
            }

            update listToUpdate;
        }

    }

}