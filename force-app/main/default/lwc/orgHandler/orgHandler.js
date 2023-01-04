import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getTriggerList from '@salesforce/apex/orgHandler.getTriggerList';
import updateTrigger from '@salesforce/apex/orgHandler.updateTrigger';
import LightningConfirm from 'lightning/confirm';
import noHeader from '@salesforce/resourceUrl/NoHeader';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class OrgHandler extends LightningElement {

    connectedCallback() {
        loadStyle(this, noHeader)
            .then(result => {});
    }

    @track triggers;
    @track isLoading = false;
    wiredApexResult;

    @track
    columns = [
        { label: 'Name', fieldName: 'TriggerName', type: 'url',
            typeAttributes: { label: { fieldName: 'Name'}, target: '_blank'} },
        { label: 'Object', fieldName: 'Object__c' },
        { label: 'Status', fieldName: 'Status__c' },
        {
            type:'button',
            fixedWidth: 150,
            typeAttributes: {
                label: 'Edit',
                name: 'edit',
                variant: 'brand'
            }
        }
    ];

    @wire(getTriggerList)
    getTriggersList(result) {
        this.wiredApexResult = result;
        if (result.data) {
            console.log(result.data);
            let tempRecs = [];
            const resultData = Array.from(result.data);
            resultData.forEach( (record) => {
                let tempRec = Object.assign( {}, record );
                tempRec.TriggerName = '/' + tempRec.Id;
                tempRecs.push(tempRec);
            });
            this.triggers = tempRecs;            
        }
        else if (result.error) {
            console.log(result.error);
        }
    }

    async updateTrigger(event) {
        let tgName = event.detail.row.Name;
        let tgObject = event.detail.row.Object__c;
        let tgStatus = event.detail.row.Status__c;
        let tgConfirm = (tgStatus == 'Active') ? 'Deactivate' : 'Activate';
        this.objectName = event.detail.row.Object__c;
        console.log(tgName + ' ' + tgObject);
        const result = await LightningConfirm.open({
            message: 'Are you sure you want to ' + tgConfirm + ' ' + tgName + '?',
            variant: 'default',
            label: 'Change trigger status'
        });
        if (result) {
            this.isLoading = true;
            updateTrigger({objectName: tgObject})
            .then(() => {
                console.log("updated successfully");
                this.isLoading = false;
                return refreshApex(this.wiredApexResult);
            })
            .catch(() => {
                console.log("error");
            });
        }
        
    }   
    
}