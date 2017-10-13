public with sharing class StudentScoringSkillAPI {
	public void setPoint () {
        List< Student_Scoring_Skill__c > listScore         = [SELECT Point__c, Student__r.Status__c, Student_Skill__r.Active__c, Student_Skill__r.Point__c FROM Student_Scoring_Skill__c];
        List< Student_Scoring_Skill__c > prepareListUpdate = new List< Student_Scoring_Skill__c >();

        for ( Student_Scoring_Skill__c stuSkill : listScore ) {

            if ( stuSkill.Point__c == 0 && stuSkill.Student__r.Status__c != 'Disabled' && stuSkill.Student_Skill__r.Active__c ) {
                stuSkill.Point__c = stuSkill.Student_Skill__r.Point__c;
            } else {
                stuSkill.Point__c = 0;
            }

            prepareListUpdate.add( stuSkill );
            System.debug( stuSkill.Point__c );
        }

        update prepareListUpdate;
    }
}