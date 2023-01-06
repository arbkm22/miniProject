import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { loadStyle } from 'lightning/platformResourceLoader';
import LightningConfirm from 'lightning/confirm';

import getTriggerList from '@salesforce/apex/orgHandler.getTriggerList';
import updateTrigger from '@salesforce/apex/orgHandler.updateTrigger';
import getFlowList from '@salesforce/apex/orgHandler.getFlowList';
import updateFlow from '@salesforce/apex/orgHandler.updateFlow';
import noHeader from '@salesforce/resourceUrl/NoHeader';

export default class OrgHandler extends LightningElement {

    connectedCallback() {
        loadStyle(this, noHeader)
            .then(result => {});
    }

    @track triggers;
    @track flows;
    @track isLoading = false;
    @track isLoadingFlows = false;
    wiredApexResult;
    wiredFlowResult;

    // Basic Column structure for lightning-datatable
    // @track
    // columns = [
    //     { label: 'Name', fieldName: 'TriggerName', type: 'url',
    //         typeAttributes: { label: { fieldName: 'Name'}, target: '_blank'} },
    //     { label: 'Object', fieldName: 'Object__c' },
    //     { label: 'Status', fieldName: 'Status__c' },
    //     {
    //         type:'button',
    //         fixedWidth: 150,
    //         typeAttributes: {
    //             label: 'Edit',
    //             name: 'edit',
    //             variant: 'brand'
    //         }
    //     }
    // ];
    
    // DATATABLE COLUMNS
    @track
    triggerColumns = [
        { label: 'Name', fieldName: 'TriggerName', type: 'url',
            typeAttributes: { label: { fieldName: 'Name'}, target: '_blank'} },
        { label: 'Object', fieldName: 'Object__c' },
        { label: 'Status', fieldName: '', 
            cellAttributes: { iconName: { fieldName: 'dynamicIcon' } } 
        },
        { label: '', fieldName: 'Status2__c', type: 'toggleButton',
            typeAttributes: {
                status: { fieldName: 'Status2__c' },
                object: { fieldName: 'Object__c' },
                name: { fieldName: 'Name' }
            } 
        }
    ];

    @track
    flowColumns = [
        { label: 'Name', fieldName: 'FlowName', type: 'url',
            typeAttributes: { label: { fieldName: 'Name'}, target: '_blank'} },
        { label: 'Object', fieldName: 'Object__c' },
        { label: 'Status', fieldName: '', 
            cellAttributes: { iconName: { fieldName: 'dynamicIcon' } } 
        },
        { label: '', fieldName: 'Status__c', type: 'toggleButton',
            typeAttributes: {
                name: { fieldName: 'Name' },
                status: { fieldName: 'Status__c' },
                object: { fieldName: 'Object__c' }
            } 
        }
    ];

    // Wire Function
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
                tempRec.dynamicIcon = (record.Status__c == 'Active') ? 'action:approval' : 'action:close';
                tempRecs.push(tempRec);
            });
            this.triggers = tempRecs;            
        }
        else if (result.error) {
            console.log(result.error);
        }
    }

    @wire(getFlowList)
    getFlowsList(result) {
        this.wiredFlowResult = result;
        if (result.data) {
            console.log(result.data);
            let tempRecs = [];
            const resultData = Array.from(result.data);
            resultData.forEach( (record) => {
                let tempRec = Object.assign( {}, record );
                tempRec.FlowName = '/' + tempRec.Id;
                tempRec.dynamicIcon = (record.Status__c) ? 'action:approval' : 'action:close';
                tempRecs.push(tempRec);
            });
            this.flows = tempRecs;            
        }
        else if (result.error) {
            console.log(result.error);
        }
    }

    async updateTrigger(event) {
        let tgName = event.detail.value.name;
        let tgObject = event.detail.value.object;
        let tgStatus = event.detail.value.status
        let tgConfirm = (tgStatus == true) ? 'Deactivate' : 'Activate';
        // this.objectName = event.detail.row.Object__c;
        console.log(tgName + ' ' + tgObject);
        const result = await LightningConfirm.open({
            message: 'Are you sure you want to ' + tgConfirm + ' ' + tgName + '?',
            variant: 'headerless',
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
            if (tgConfirm == 'Activate')
                this.showToast('activated!');
            else 
                this.showToast('deactivated');
        }
    }   

    async updateFlow(event) {
        let flowName = event.detail.value.name;
        let flowObject = event.detail.value.object;
        let flowStatus = event.detail.value.status
        let flowConfirm = (flowStatus == true) ? 'Deactivate' : 'Activate';
        console.log(flowName + ' ' + flowObject);
        const result = await LightningConfirm.open({
            message: 'Are you sure you want to ' + flowConfirm + ' ' + flowName + '?',
            variant: 'headerless',
            label: 'Change flow status'
        });
        if (result) {
            this.isLoadingFlows = true;
            updateFlow({objectName: flowObject})
            .then(() => {
                console.log("updated successfully");
                this.isLoadingFlows = false;
                return refreshApex(this.wiredFlowResult);
            })
            .catch(() => {
                console.log("error");
            });
            if (flowConfirm == 'Activate')
                this.showToast('activated!');
            else 
                this.showToast('deactivated');
        }
    }
    
    showToast(toShow) {
        
        const event = new ShowToastEvent({
            title: 'Success!',
            message: 'Trigger successfully ' + toShow,
            variant: 'success',
        });
        this.dispatchEvent(event);
    }

    handleSelectedRec(event) {
        console.log(event.detail.value.object);
    }
    
}