public with sharing class AccountTriggerHandler extends TriggerHandler {
    
    List<Account> recordOldList = new List <Account> ();
    List<Account> recordNewList = new List <Account> ();    
    Map<Id, Account> recordOldMap = new Map <Id, Account> ();
    Map<Id, Account> recordNewMap = new Map <Id, Account> ();  

    public AccountTriggerHandler() {
        this.recordOldList = (List<Account> ) Trigger.old;
        this.recordNewList = (List<Account> ) Trigger.new;
        this.recordOldMap = (Map<Id, Account>) Trigger.oldMap;
        this.recordNewMap = (Map<Id, Account>) Trigger.newMap;
    }

    public override void beforeInsert() {
        //beforeInsert
    }

    public override void afterInsert() {
        //afterInsert
    }

    public override void beforeUpdate() {
        //beforeUpdate
    }

    public override void afterUpdate() {
        //afterUpdate
    }
}