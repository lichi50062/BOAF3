﻿// 94.04.01 add 載入wlx04的資料 by 2295
// 94.04.01 add 檢核身份証號 by 2295
// 94.04.06 add 卸任日期不可大於當日日期或小於就任日期 by 2295
// 94.04.07 add 總機構裁撤日期不可小於任一分支機構裁撤日期 by 2295
// 95.05.26 add 從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數.不可為0/負數/空白 by 2295
//101.09.11 add 檢核.從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數 = 本機構員工總人數 + 分支機構員工總人數 by 2295
//104.06.24 add 檢核.正式職員+技工+工友+特約人員=從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數 by 2968
//106.02.02 add 業務項目組合字串 by 2968
//107.05.10 add 檔案上傳專區upload by 6417
//107.05.10 add 檔案上傳專區upload by 6417
//107.05.15 add 主管機關信用部分部主任函文號及日期 by 6417
//109.07.29 add 電子銀行/行動支付 by 6493
function doSubmit(form,cnd,table){
	    	
	    if((table == 'Master') && (!checkWLX01Data(form))){	        	      
	       return;
	    }	
	    if((table == 'Manager') && (!checkManager(form))){
	       return;
	    }	    
	    if((table == 'WM') && (!checkWLX01_WMData(form))){
	       return;
	    }
	    if(table == 'Audit' && cnd != 'DeleteAudit'){
	    	if(!checkAudit(form)){
	    		return;
	    	}
	    }
	    if(cnd == 'AbdicateM'){//高階主管卸任
	       form.ABDICATE_CODE[0].selected=true;	   
	       form.ABDICATE_DATE_Y.disabled=false;
	       form.ABDICATE_DATE_M.disabled=false;
	       form.ABDICATE_DATE_D.disabled=false;    
	       if(AskAbdicate()){
	       	  if(!checkManager(form)) return;
	       	  form.action="/pages/FX001W.jsp?act="+cnd+"&position_code="+form.POSITION_CODE.value+"&id="+form.ID.value+"&test=nothing";
	          form.submit();	     
	       }else{
	          return;
	       }	
	    } 
		
	    if(cnd == 'Revoke'){//總機構裁撤
	       form.CANCEL_NO[0].selected=true;	   
	       form.CANCEL_DATE_Y.disabled=false;
	       form.CANCEL_DATE_M.disabled=false;
	       form.CANCEL_DATE_D.disabled=false;    
	       if(AskRevoke()){
	       	  if(!checkWLX01Data(form)) return;
	       	  form.action="/pages/FX001W.jsp?act="+cnd+"&test=nothing";
	          form.submit();	     
	       }else{
	          return;
	       }	
	    }
	    
	    if(table == 'Master'){	    
	       if((cnd == "Update") && AskUpdate(form)){ 
	           form.action="/pages/FX001W.jsp?act="+cnd+"&test=nothing";
	           form.submit();	    
	       }
		}	
	    if(table == 'Manager'){	   
	       form.action="/pages/FX001W.jsp?act="+cnd+"&position_code="+form.POSITION_CODE.value+"&id="+form.ID.value+"&test=nothing";
	       if((cnd == "InsertM") && AskInsert(form)) form.submit();	    
	       if((cnd == "UpdateM") && AskUpdate(form)) form.submit();	    
	       if((cnd == "DeleteM") && AskDelete(form)) form.submit();	    	       	       
	    }
	    if(table == 'WM'){	   
	       form.action="/pages/FX001W.jsp?act="+cnd+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&test=nothing";
	       if((cnd == "InsertWM") && AskInsert(form)) form.submit();	    
	       if((cnd == "UpdateWM") && AskUpdate(form)) form.submit();	    
	       if((cnd == "DeleteWM") && AskDelete(form)) form.submit();	    	       	         
	    }
	    if(table == 'Audit'){	   
		       form.action="/pages/FX001W.jsp?act="+cnd+"&test=nothing";
		       if((cnd == "InsertAudit") && AskInsert(form)) form.submit();	    
		       if((cnd == "UpdateAudit") && AskUpdate(form)) form.submit();	    
		       if((cnd == "DeleteAudit") && AskDelete(form)) form.submit();	    	       	       
		}
}	

function AddManager(form,WLX01_size){
	   if(WLX01_size == '0'){
	   	  alert("請先輸入主檔資料");
	   	  return;
	   }else{	
	      form.action="/pages/FX001W.jsp?act=newM&test=nothing";
	      form.submit();
	   }   
}	

function AddWM(form,WLX01_size){
	   if(WLX01_size == '0'){
	   	  alert("請先輸入主檔資料");
	   	  return;
	   }else{	
	      form.action="/pages/FX001W.jsp?act=newWM&test=nothing";
	      form.submit();
	   }   
}
//94.04.01 add 載入wlx04的資料 by 2295
function loadData(form,cnd,cnd1){	 		
	      form.action="/pages/FX001W.jsp?act="+cnd+"&nowact="+cnd1+"&test=nothing";	      
	      form.submit();	      
}

function setAbdicateDate(form){	
	    if(form.ABDICATE_CODE.value == 'Y'){
	       form.ABDICATE_DATE_Y.disabled=false;
	       form.ABDICATE_DATE_M.disabled=false;
	       form.ABDICATE_DATE_D.disabled=false;
	    }else{
	       form.ABDICATE_DATE_Y.value="";
	       form.ABDICATE_DATE_M.value="";
	       form.ABDICATE_DATE_D.value="";
	       form.ABDICATE_DATE_Y.disabled=true;
	       form.ABDICATE_DATE_M.disabled=true;
	       form.ABDICATE_DATE_D.disabled=true;
	    }
}	

function setCancelDate(form){	
	    if(form.CANCEL_NO.value == 'Y'){
	       form.CANCEL_DATE_Y.disabled=false;
	       form.CANCEL_DATE_M.disabled=false;
	       form.CANCEL_DATE_D.disabled=false;
	    }else{
	       form.CANCEL_DATE_Y.value="";
	       form.CANCEL_DATE_M.value="";
	       form.CANCEL_DATE_D.value="";
	       form.CANCEL_DATE_Y.disabled=true;
	       form.CANCEL_DATE_M.disabled=true;
	       form.CANCEL_DATE_D.disabled=true;
	    }
}


function setCenterNO(form){	
	    if(form.CENTER_FLAG.value == 'Y'){
	       form.CENTER_NO.disabled=false;	       
	    }else{
	       form.CENTER_NO.value="";
	       form.CENTER_NO.disabled=true;	       
	    }
}

function setAddr(form,cnd){	
	    if(cnd == 'IT_ADDR'){
	    	form.IT_ADDR.value=form.ADDR.value;	    	
		}	
		if(cnd == 'AUDIT_ADDR'){
			form.HSIEN_ID_AREA_ID.value = form.tmpStr1.value;
			form.ADDR.value=form.tmpStr2.value;
			document.getElementById('spanA').style.display='none';
			document.getElementById('spanB').style.display = 'inline';
		}
}

// 95.05.26 add 從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數.不可為0/負數/空白 by 2295
//101.09.11 add 檢核.從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數 = 本機構員工總人數 + 分支機構員工總人數 by 2295
function checkWLX01Data(form) 
{
	var ckDate;
	
	if (trimString(form.STAFF_NUM.value) != "" ){
        if(isNaN(Math.abs(form.STAFF_NUM.value))){
           alert("本機構員工總人數不可為文字");
           form.STAFF_NUM.focus();
           return false;
        }else if(form.STAFF_NUM.value < 0){        	
	   		alert("本機構員工總人數不可為負數");
			form.STAFF_NUM.focus();
			return false;	        	
    	}	           		
	}else{
	    alert("本機構員工總人數不可為空白");
	    return false;
	}
		
	if (trimString(form.CREDIT_STAFF_NUM.value) != "" ){
        if(isNaN(Math.abs(form.CREDIT_STAFF_NUM.value))){
           alert("從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數不可為文字");
           form.CREDIT_STAFF_NUM.focus();
           return false;
        }else if(form.CREDIT_STAFF_NUM.value < 0){        	
	   	   alert("從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數不可為負數");
		   form.CREDIT_STAFF_NUM.focus();
		   return false;	        	
		}else if(form.CREDIT_STAFF_NUM.value == 0){        	
	   	   alert("從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數不可為0");
		   form.CREDIT_STAFF_NUM.focus();
		   return false;	        	   
    	}	             		
	}else{
	    alert("從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數不可為空白");
	    return false;
	}
	//101.09.11 add 檢核.從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數 = 本機構員工總人數 + 分支機構員工總人數 by 2295
    var sum_staff;
    sum_staff = parseInt(form.STAFF_NUM.value) + parseInt(form.wlx02staff_num.value);
    //alert(sum_staff);
    if(sum_staff != parseInt(form.CREDIT_STAFF_NUM.value)){
       alert('從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數['+form.CREDIT_STAFF_NUM.value+'],與本機構員工總人數['+form.STAFF_NUM.value+']與分支機構員工總人數['+form.wlx02staff_num.value+']加總['+sum_staff+']不合('+form.CREDIT_STAFF_NUM.value+' 不等於 '+form.STAFF_NUM.value+'+'+form.wlx02staff_num.value+ ' ),若需修正分支機構員工總人數,請至國內營業分支構機基本資料維護(FX002W)進行資料修改!!');
       return false;
    }
    //104.06.24 add 檢核.正式職員+技工+工友+特約人員=從事信用業務(存款、放款及農貸轉放等信用業務)之員工人數
    if(form.CREDIT_STAFF.value=='')form.CREDIT_STAFF.value="0";
    if(form.SKILL_STAFF.value=='') form.SKILL_STAFF.value="0";
    if(form.MANUAL_STAFF.value=='')form.MANUAL_STAFF.value="0";
    if(form.TEMP_STAFF.value=='')  form.TEMP_STAFF.value="0";
    var creditStaff = parseInt(form.CREDIT_STAFF.value);
    var skillStaff = parseInt(form.SKILL_STAFF.value);
    var manualStaff = parseInt(form.MANUAL_STAFF.value);
    var tempStaff = parseInt(form.TEMP_STAFF.value);
    sum_staff = creditStaff + skillStaff + manualStaff +tempStaff ;
    if(sum_staff != parseInt(form.CREDIT_STAFF_NUM.value)){
    	 alert('正式職員('+creditStaff+')+技工('+skillStaff+')+工友('+manualStaff+')+特約人員('+tempStaff+')加總為'+sum_staff+'\n不等於從事信用業務之員工人數'+form.CREDIT_STAFF_NUM.value+'!!');
         return false;
    }
    
	if((trimString(form.SETUP_DATE_Y.value) != "" ) 
    || (trimString(form.SETUP_DATE_M.value) != "" )
    || (trimString(form.SETUP_DATE_D.value) != "" ))
    {				   	    
        if (trimString(form.SETUP_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.SETUP_DATE_Y.value))){
               alert("原始核准設立日期(年)不可輸入文字");    
			   form.SETUP_DATE_Y.focus();            
               return false;
            }
        }else{
			alert("原始核准設立日期(年)不可空白");
			form.SETUP_DATE_Y.focus();
			return false;   
		}   
        if (trimString(form.SETUP_DATE_M.value) == "" ){
			alert("原始核准設立日期(月)不可空白");
			form.SETUP_DATE_M.focus();
			return false;
		}			
		if (trimString(form.SETUP_DATE_D.value) == "" ){
			alert("原始核准設立日期(日)不可空白");
			form.SETUP_DATE_D.focus();		
			return false;
		}	    

    	ckDate = '' + (parseInt(form.SETUP_DATE_Y.value)+1911) + '/' + form.SETUP_DATE_M.value + '/' + form.SETUP_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
        	alert('原始核准設立日期為無效日期!!');
        	form.SETUP_DATE_D.focus();
        	return false;
    	}    
    	form.SETUP_DATE.value = ckDate;   	    	
    }
    
    if((trimString(form.CHG_LICENSE_DATE_Y.value) != "" ) 
    || (trimString(form.CHG_LICENSE_DATE_M.value) != "" )
    || (trimString(form.CHG_LICENSE_DATE_D.value) != "" ))
    {				   	    
        if (trimString(form.CHG_LICENSE_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.CHG_LICENSE_DATE_Y.value))){
               alert("最近換照日期(年)不可輸入文字");    
			   form.CHG_LICENSE_DATE_Y.focus();            
               return false;
            }
        }else{
			alert("最近換照日期(年)不可空白");
			form.CHG_LICENSE_DATE_Y.focus();
			return false;   
		}   
        if (trimString(form.CHG_LICENSE_DATE_M.value) == "" ){
			alert("最近換照日期(月)不可空白");
			form.CHG_LICENSE_DATE_M.focus();
			return false;
		}			
		if (trimString(form.CHG_LICENSE_DATE_D.value) == "" ){
			alert("最近換照日期(日)不可空白");
			form.CHG_LICENSE_DATE_D.focus();		
			return false;
		}	    

    	ckDate = '' + (parseInt(form.CHG_LICENSE_DATE_Y.value)+1911) + '/' + form.CHG_LICENSE_DATE_M.value + '/' + form.CHG_LICENSE_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
        	alert('最近換照日期為無效日期!!');
        	form.CHG_LICENSE_DATE_D.focus();
        	return false;
    	}    
    	form.CHG_LICENSE_DATE.value = ckDate;   	    	
    }
   
    if((trimString(form.OPEN_DATE_Y.value) != "" ) 
    || (trimString(form.OPEN_DATE_M.value) != "" )
    || (trimString(form.OPEN_DATE_D.value) != "" ))
    {				   	    
        if (trimString(form.OPEN_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.OPEN_DATE_Y.value))){
               alert("原始開業日期(年)不可輸入文字");    
			   form.OPEN_DATEE_Y.focus();            
               return false;
            }
        }else{
			alert("原始開業日期(年)不可空白");
			form.OPEN_DATE_Y.focus();
			return false;   
		}   
        if (trimString(form.OPEN_DATE_M.value) == "" ){
			alert("原始開業日期(月)不可空白");
			form.OPEN_DATE_M.focus();
			return false;
		}			
		if (trimString(form.OPEN_DATE_D.value) == "" ){
			alert("原始開業日期(日)不可空白");
			form.OPEN_DATE_D.focus();		
			return false;
		}	    

    	ckDate = '' + (parseInt(form.OPEN_DATE_Y.value)+1911) + '/' + form.OPEN_DATE_M.value + '/' + form.OPEN_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
        	alert('原始開業日期為無效日期!!');
        	form.OPEN_DATE_D.focus();
        	return false;
    	}    
    	form.OPEN_DATE.value = ckDate;   	    	
    }
//107.05.15 add 異動wlx04的資料 by 6417    
    if((trimString(form.AGREE_DATE_Y.value) != "" ) 
    		|| (trimString(form.AGREE_DATE_M.value) != "" )
    		|| (trimString(form.AGREE_DATE_D.value) != "" ))
    {				   	    
    	if (trimString(form.AGREE_DATE_Y.value)  != "" ){        
    		if(isNaN(Math.abs(form.AGREE_DATE_Y.value))){
    			alert("最近地方主管機關同意信用部主任函日期(年)不可輸入文字");    
    			form.AGREE_DATE_Y.focus();            
    			return false;
    		}
    	}else{
    		alert("最近地方主管機關同意信用部主任函日期(年)不可空白");
    		form.AGREE_DATE_Y.focus();
    		return false;   
    	}   
    	if (trimString(form.AGREE_DATE_M.value) == "" ){
    		alert("最近地方主管機關同意信用部主任函日期(月)不可空白");
    		form.AGREE_DATE_M.focus();
    		return false;
    	}			
    	if (trimString(form.AGREE_DATE_D.value) == "" ){
    		alert("最近地方主管機關同意信用部主任函日期(日)不可空白");
    		form.AGREE_DATE_D.focus();		
    		return false;
    	}	    
    	
    	ckDate = '' + (parseInt(form.AGREE_DATE_Y.value)+1911) + '/' + form.AGREE_DATE_M.value + '/' + form.AGREE_DATE_D.value;
    	
    	if( fnValidDate(ckDate) != true){
    		alert('最近地方主管機關同意信用部主任函日期為無效日期');
    		form.START_DATE_D.focus();
    		return false;
    	}    
    	form.AGREE_DATE.value = ckDate; 
    	
    	if (trimString(form.AGREE_NO.value) == "" ){
			alert("最近地方主管機關同意信用部主任函文號不可空白");
			form.AGREE_NO.focus();
			return false;
		}
    	
    }
    if((trimString(form.START_DATE_Y.value) != "" ) 
    || (trimString(form.START_DATE_M.value) != "" )
    || (trimString(form.START_DATE_D.value) != "" ))
    {				   	    
        if (trimString(form.START_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.START_DATE_Y.value))){
               alert("開始營業日(年)不可輸入文字");    
			   form.START_DATEE_Y.focus();            
               return false;
            }
        }else{
			alert("開始營業日(年)不可空白");
			form.START_DATE_Y.focus();
			return false;   
		}   
        if (trimString(form.START_DATE_M.value) == "" ){
			alert("開始營業日(月)不可空白");
			form.START_DATE_M.focus();
			return false;
		}			
		if (trimString(form.START_DATE_D.value) == "" ){
			alert("開始營業日(日)不可空白");
			form.START_DATE_D.focus();		
			return false;
		}	    

    	ckDate = '' + (parseInt(form.START_DATE_Y.value)+1911) + '/' + form.START_DATE_M.value + '/' + form.START_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
        	alert('開始營業日為無效日期!!');
        	form.START_DATE_D.focus();
        	return false;
    	}    
    	form.START_DATE.value = ckDate;  
    	

    }
    
    if(form.CANCEL_NO.value == 'Y'){
		if (trimString(form.CANCEL_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.CANCEL_DATE_Y.value))){
            	alert("裁撤生效日期(年)不可輸入文字");    
            	form.CANCEL_DATE_Y.focus();
            	return false;
        	}	
        }else{
			alert("裁撤生效日期(年)不可空白");
			form.CANCEL_DATE_Y.focus();
			return false;   
		}
			
		if (trimString(form.CANCEL_DATE_M.value) == "" ){
			alert("裁撤生效日期(月)不可空白");
			form.CANCEL_DATE_M.focus();
			return false;
		}			
		if (trimString(form.CANCEL_DATE_D.value) == "" ){
			alert("裁撤生效日期(日)不可空白");
			form.CANCEL_DATE_D.focus();
			return false;
		}	       
		
		 
        
    	ckDate = '' + (parseInt(form.CANCEL_DATE_Y.value)+1911) + '/' + form.CANCEL_DATE_M.value + '/' + form.CANCEL_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
           	alert('裁撤生效日期為無效日期!!');
           	form.CANCEL_DATE_D.focus();
           	return false;
   		}	          		
   		
   		form.CANCEL_DATE.value = ckDate;   	    	    		
   		
   		//94.04.07 add 總機構裁撤日期不可小於任一分支機構裁撤日期
   		var a = form.wlx02date.value.split(',');
        for(var i =0; i < a.length; i ++){	        
        	//alert('a[i]'+a[i]);
        	//alert('form.cancel_date='+form.CANCEL_DATE.value);        	
	        if(form.CANCEL_DATE.value < a[i]){
	           alert('裁撤日期不可小於任一分支機構裁撤日期');	 
	           return false;
	        }	
        }        
   }
   
   if(form.CENTER_FLAG.value == 'Y'){
   	  if (trimString(form.CENTER_NO.value) == "" ){
			alert("電腦共用中心代碼不可空白");
			form.CENTER_NO.focus();
			return false;
		}
   }	
   
   
   if (trimString(form.M2_NAME.value) == "" ){
	   alert("地方主管機關代號不可空白");
	   form.M2_NAME.focus();
	   return false;
   }
   form.BUSINESS_ITEM.value='1、2、3、4、5、6、7、8、9、10';
   var items = document.getElementsByName('ITEMS');
   for(i=0;i<items.length;i++){
	   if(items[i].checked){
		   form.BUSINESS_ITEM.value=form.BUSINESS_ITEM.value+"、"+items[i].value;
		   if(items[i].value=='99' && form.BUSINESS_ITEM_EXTRA.value==''){
			   alert("其他業務項目說明不可空白");
			   form.BUSINESS_ITEM_EXTRA.focus();
			   return false;
		   }
		   if(items[i].value=='13' && !checkEBankData()){
			   return false;
		   }
	   }
   }
   return true;
}
function checkEBankData(){
	//name=大寫 id=小寫
	//電子銀行-農委會同意備查函日期///////////////////////////////
	if (trimString($('#ebank_doc_date_y').val())  != "" ){        
    	if(isNaN(Math.abs($('#ebank_doc_date_y').val()))){
           alert("電子銀行-農委會同意備查函日期(年)不可輸入文字");    
           $('#ebank_doc_date_y').focus();            
           return false;
        }
    }else{
		alert("電子銀行-農委會同意備查函日期(年)不可空白");
		$('#ebank_doc_date_y').focus();
		return false;   
	}   
    if (trimString($('#ebank_doc_date_m').val()) == "" ){
		alert("電子銀行-農委會同意備查函日期(月)不可空白");
		$('#ebank_doc_date_m').focus();
		return false;
	}			
	if (trimString($('#ebank_doc_date_d').val()) == "" ){
		alert("電子銀行-農委會同意備查函日期(日)不可空白");
		$('#ebank_doc_date_d').focus();		
		return false;
	}	    
	ckDate = '' + (parseInt($('#ebank_doc_date_y').val())+1911) + '/' + $('#ebank_doc_date_m').val() + '/' + $('#ebank_doc_date_d').val();
	if( fnValidDate(ckDate) != true){
    	alert('電子銀行-農委會同意備查函日期為無效日期!!');
    	$('#ebank_doc_date_d').focus();
    	return false;
	}    
	$('#ebank_doc_date').val(ckDate);
	////////////////////////////////////////////////////////////
	
	//電子銀行-農委會同意備查函文號///////////////////////////////
	if (trimString($('#ebank_doc_no').val()) == "" ){
		alert("電子銀行-農委會同意備查函文號不可空白");
		$('#ebank_doc_no').focus();
		return false;
	}
	////////////////////////////////////////////////////////////
	
	//電子銀行-功能與限額(元)：約定帳戶轉帳、非約定帳戶轉帳、臺灣Pay購物...動態新增項目//////////////////////////////////////////
	var eLimitType;
	var elimit_items = document.getElementsByName('ELIMIT_ITEMS');
	for(var i=0;i<elimit_items.length;i++){
		if(elimit_items[i].checked){
			eLimitType = elimit_items[i].value;
			//行動支付-限額///////////////////////////////
			var elimit_limit_input_items;

			//控制要取出表格資料的子項目代號
			var sub_type_array;
			if('103' == eLimitType){
				//103-臺灣Pay購物
				sub_type_array = [2,3];
			} else {
				//約定帳戶轉帳、非約定帳戶轉帳...動態新增項目
				sub_type_array = [0];					
			}
			for(var k=0; k<sub_type_array.length; k++){
				elimit_limit_input_items = $("#elimit_"+eLimitType+"_sub_type_"+sub_type_array[k]+" input");
				for(var j=0; j<elimit_limit_input_items.length; j++){
					if ( isNaN(Math.abs(trimString( elimit_limit_input_items[j].value ).replace(/,/g, ""))) ){
						alert("電子銀行-限額 請輸入數字");
						elimit_limit_input_items[j].focus();
						return false;
					}
				}						
			}
			////////////////////////////////////////////////////////////
		}
	}
	////////////////////////////////////////////////////////////
	
	//電子銀行-特店收單//////////////////////////////////////////
	if($('#ebank_checkbox').prop('checked')){
		if(!$('#ebank_s1').prop('checked') && !$('#ebank_s2').prop('checked')){
			alert('若勾選"電子銀行-特店收單"則需勾選"主掃模式"或"被掃模式"');
			$('#ebank_checkbox').focus();
			return false;
		}
	}
	////////////////////////////////////////////////////////////
	
	//電子銀行-行動支付//////////////////////////////////////////
	if($('#epay_checkbox').prop('checked')){
		var check_epay_item = false;
		var ePayType;
		var epay_items = document.getElementsByName('EPAY_ITEMS');
		for(var i=0;i<epay_items.length;i++){
			if(epay_items[i].checked){
				check_epay_item = true;
				ePayType = epay_items[i].value;
				//行動支付-農委會同意備查函日期///////////////////////////////
				if (trimString($('#epay_'+ ePayType +'_doc_date_y').val())  != "" ){        
			    	if(isNaN(Math.abs($('#ebank_doc_date_y').val()))){
			           alert("行動支付-農委會同意備查函日期(年)不可輸入文字");    
			           $('#epay_'+ ePayType +'_doc_date_y').focus();            
			           return false;
			        }
			    }else{
					alert("行動支付-農委會同意備查函日期(年)不可空白");
					$('#epay_'+ ePayType +'_doc_date_y').focus();
					return false;   
				}   
			    if (trimString($('#epay_'+ ePayType +'_doc_date_m').val()) == "" ){
					alert("行動支付-農委會同意備查函日期(月)不可空白");
					$('#epay_'+ ePayType +'_doc_date_m').focus();
					return false;
				}			
				if (trimString($('#epay_'+ ePayType +'_doc_date_d').val()) == "" ){
					alert("行動支付-農委會同意備查函日期(日)不可空白");
					$('#epay_'+ ePayType +'_doc_date_d').focus();		
					return false;
				}	    
				ckDate = '' + (parseInt($('#epay_'+ ePayType +'_doc_date_y').val())+1911) + '/' + $('#epay_'+ ePayType +'_doc_date_m').val() + '/' + $('#epay_'+ ePayType +'_doc_date_d').val();
					       
				if( fnValidDate(ckDate) != true){
			    	alert('行動支付-農委會同意備查函日期為無效日期!!');
			    	$('#epay_'+ ePayType +'_doc_date_d').focus();
			    	return false;
				}    
				$('#epay_'+ ePayType +'_doc_date').val(ckDate);
				////////////////////////////////////////////////////////////
				
				//行動支付-農委會同意備查函文號///////////////////////////////
				if (trimString($('#epay_'+ ePayType +'_doc_no').val()) == "" ){
					alert("行動支付-農委會同意備查函文號不可空白");
					$('#epay_'+ ePayType +'_doc_no').focus();
					return false;
				}
				////////////////////////////////////////////////////////////
				
				//行動支付-限額///////////////////////////////
				var epay_limit_input_items;

				//控制要取出表格資料的子項目代號
				var sub_type_array;
				if('203' == ePayType){
					//臺灣Pay
					sub_type_array = [1,2,6];
				}else if( '204' == ePayType ){
					//Line Pay
					sub_type_array = [7];					
				} else {
					//動態新增項目
					sub_type_array = [1,2,6];					
				}
				for(var k=0; k<sub_type_array.length; k++){
					epay_limit_input_items = $("#epay_"+ePayType+"_sub_type_"+sub_type_array[k]+" input");
					for(var j=0; j<epay_limit_input_items.length; j++){
						if ( isNaN(Math.abs(trimString( epay_limit_input_items[j].value ).replace(/,/g, ""))) ){
							alert("行動支付-限額 請輸入數字");
							epay_limit_input_items[j].focus();
							return false;
						}
					}						
				}
				////////////////////////////////////////////////////////////
			}
		}
		if(!check_epay_item){
			alert('若勾選"行動支付"則需勾選至少一項');
			$('#epay_checkbox').focus();
			return false;
		}
	}	
	////////////////////////////////////////////////////////////
	
	return true;
}
function chkInteger(data){
	data.value = changeVal(data); 
    if (isNaN(Math.abs(data.value))) {    	    	
   	    alert("請輸入數字");
   	    data.value = '';
   	    data.focus();
   	    return false;
    }
    if(data.value=='0' || data.value=='' || data.value==null){
    	data.value = '';
    }else{
    	data.value = Math.abs(data.value);
    }
    data.value = changeStr(data);
    return true;
}
function chkItem(form,item){
	if(item.value=='99'){
		if(item.checked){
			form.BUSINESS_ITEM_EXTRA.disabled="";
		}else{
			form.BUSINESS_ITEM_EXTRA.value='';
			form.BUSINESS_ITEM_EXTRA.disabled="disabled";
		}
	}
}
function chkExpand(item){
	if(item.checked){
		$("#"+item.value).show();
	}else{
		$("#"+item.value).hide();
	}
}
function chkElimitExpand(item){
	if(item.checked){
		$("#elimit_"+item.value).show();
	}else{
		$("#elimit_"+item.value).hide();
	}
}
function chkEpayExpand(item){
	if(item.checked){
		$("#epay_"+item.value).show();
	}else{
		$("#epay_"+item.value).hide();
	}
}
function chkShopCode(item){
	if(item.checked && "ebank_s1" == item.id){
		$("#ebank_checkbox").prop('checked', true);
		$("#ebank_s1").prop('checked', true);
	}else if(item.checked && "ebank_s2" == item.id){
		$("#ebank_checkbox").prop('checked', true);
		$("#ebank_s2").prop('checked', true);
	}else if(!item.checked && "ebank_checkbox" == item.id){
		$("#ebank_checkbox").prop('checked', false);
		$("#ebank_s1").prop('checked', false);
		$("#ebank_s2").prop('checked', false);
	}
}

//94.04.01 add 檢核身份証號 by 2295
function checkManager(form) 
{
	var ckDate;
	
	if (trimString(form.ID.value) =="" ){
		alert("身分證字號不可空白");
		form.ID.focus();
		return false;
	}	
	
	if (trimString(form.NAME.value) =="" ){
		alert("姓名不可空白");
		form.NAME.focus();
		return false;
	}
	
	if (trimString(form.RANK.value) != "" ){
        if(isNaN(Math.abs(form.RANK.value))){
           alert("順位不可為文字");
           form.RANK.focus();
           return false;
        }           		
	}
    
    if((trimString(form.BIRTH_DATE_Y.value) != "" ) 
    || (trimString(form.BIRTH_DATE_M.value) != "" )
    || (trimString(form.BIRTH_DATE_D.value) != "" ))
    {				   	    
        if (trimString(form.BIRTH_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.BIRTH_DATE_Y.value))){
               alert("出生年月日(年)不可輸入文字");    
			   form.BIRTH_DATE_Y.focus();            
               return false;
            }
        }else{
			alert("出生年月日(年)不可空白");
			form.BIRTH_DATE_Y.focus();
			return false;   
		}   
        if (trimString(form.BIRTH_DATE_M.value) == "" ){
			alert("出生年月日(月)不可空白");
			form.BIRTH_DATE_M.focus();
			return false;
		}			
		if (trimString(form.BIRTH_DATE_D.value) == "" ){
			alert("出生年月日(日)不可空白");
			form.BIRTH_DATE_D.focus();		
			return false;
		}	    

    	ckDate = '' + (parseInt(form.BIRTH_DATE_Y.value)+1911) + '/' + form.BIRTH_DATE_M.value + '/' + form.BIRTH_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
        	alert('出生年月日為無效日期!!');
        	form.BIRTH_DATE_D.focus();
        	return false;
    	}    
    	form.BIRTH_DATE.value = ckDate;   	    	
    }

	if (trimString(form.INDUCT_DATE_Y.value) == "" ){
		alert("就任日期(年)不可空白");
		form.INDUCT_DATE_Y.focus();
		return false;
	} else {
        if(isNaN(Math.abs(form.INDUCT_DATE_Y.value))){
            alert("就任日期(年)不可輸入文字");    
			form.INDUCT_DATE_Y.focus();            
            return false;
        }	
        if (trimString(form.INDUCT_DATE_M.value) == "" ){
			alert("就任日期(月)不可空白");
			form.INDUCT_DATE_M.focus();
			return false;
		}			
		if (trimString(form.INDUCT_DATE_D.value) == "" ){
			alert("就任日期(日)不可空白");
			form.INDUCT_DATE_D.focus();		
			return false;
		}	    

    	ckDate = '' + (parseInt(form.INDUCT_DATE_Y.value)+1911) + '/' + form.INDUCT_DATE_M.value + '/' + form.INDUCT_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
        	 alert('就任日期為無效日期!!');
         	form.INDUCT_DATE_D.focus();
         	return false;
    	}	  
    	form.INDUCT_DATE.value = ckDate;   	    	
    }	
    	
	if(form.ABDICATE_CODE.value == 'Y'){
		if (trimString(form.ABDICATE_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.ABDICATE_DATE_Y.value))){
            	alert("卸任日期(年)不可輸入文字");    
            	form.ABDICATE_DATE_Y.focus();
            	return false;
        	}	
        }else{
			alert("卸任日期(年)不可空白");
			form.ABDICATE_DATE_Y.focus();
			return false;   
		}
			
		if (trimString(form.ABDICATE_DATE_M.value) == "" ){
			alert("卸任日期(月)不可空白");
			form.ABDICATE_DATE_M.focus();
			return false;
		}			
		if (trimString(form.ABDICATE_DATE_D.value) == "" ){
			alert("卸任日期(日)不可空白");
			form.ABDICATE_DATE_D.focus();
			return false;
		}	        
    	ckDate = '' + (parseInt(form.ABDICATE_DATE_Y.value)+1911) + '/' + form.ABDICATE_DATE_M.value + '/' + form.ABDICATE_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
           	alert('卸任日期為無效日期!!');
           	form.ABDICATE_DATE_D.focus();
           	return false;
   		}	       
   		
   		form.ABDICATE_DATE.value = ckDate;   	    	    		   		
   		
   		//94.04.06 add 卸任日期不可大於當日日期或小於就任日期 by 2295
        if(( form.ABDICATE_DATE.value < form.INDUCT_DATE.value)
        || ( form.ABDICATE_DATE.value > form.nowDay.value))
        {
            alert('卸任日期不可大於當日日期或小於就任日期');
            return false;			
        }
   }
   //94.04.01 add 檢核身份証號 by 2295
   if(form.ID_CODE.value != 'Y' && !check_identity_no(form.ID.value)){
	    alert('身份証號檢核有誤');
	    return false;
   }
  
   return true;
}


function checkWLX01_WMData(form) 
{	
	if (trimString(form.PUSH_DebitCard_CNT.value) != "" ){
        if(isNaN(Math.abs(form.PUSH_DebitCard_CNT.value))){
           alert("發行金融卡數(含分支機構)不可為文字");
           form.PUSH_DebitCard_CNT.focus();
           return false;
        }           		
	}
	if (trimString(form.TRAN_DebitCard_CNT.value) != "" ){
        if(isNaN(Math.abs(form.TRAN_DebitCard_CNT.value))){
           alert("流通金融卡數(含分支機構)不可為文字");
           form.TRAN_DebitCard_CNT.focus();
           return false;
        }           		
	}
	if (trimString(form.ATM_CNT.value) != "" ){
        if(isNaN(Math.abs(form.ATM_CNT.value))){
           alert("ATM裝設台數(含分支機構)不可為文字");
           form.ATM_CNT.focus();
           return false;
        }           		
	}
	if (trimString(form.TRAN_CNT.value) != "" ){
        if(isNaN(Math.abs(form.TRAN_CNT.value))){
           alert("交易次數(本月) (含分支機構)不可為文字");
           form.TRAN_CNT.focus();
           return false;
        }           		
	}
	if (trimString(form.TRAN_AMT.value) != "" ){
        if(isNaN(Math.abs(form.TRAN_AMT.value))){
           alert("交易金額(本年累計) (含分支機構)不可為文字");
           form.TRAN_AMT.focus();
           return false;
        }           		
	}
	if (trimString(form.CHECK_DEPOSIT_CNT.value) != "" ){
        if(isNaN(Math.abs(form.CHECK_DEPOSIT_CNT.value))){
           alert("支票存款戶(含分支機構)不可為文字");
           form.CHECK_DEPOSIT_CNT.focus();
           return false;
        }           		
	}
	
	if (trimString(form.CHECK_DEPOSIT_AMT.value) != "" ){
        if(isNaN(Math.abs(form.CHECK_DEPOSIT_AMT.value))){
           alert("支票存款餘額(含分支機構)不可為文字");
           form.CHECK_DEPOSIT_AMT.focus();
           return false;
        }           		
	}
	
	return true;
}
function checkAudit(form) {
	var pDate;
	var sDate;
	if (trimString(form.NAME.value) =="" ){
		alert("稽核人員姓名不可空白");
		form.NAME.focus();
		return false;
	}
	//若專任與否為[否]時,則[主管機關核准兼任與否]為必要輸入欄位
	if(form.FULL_TIME.value=='N'){
		if(form.PART_TIME.value==''){
			alert("請選擇主管機關核准兼任與否");
			form.PART_TIME.focus();
			return false;
		}
	//專任與否:為[是]時,主管機關核准日期/文號,增加為必要輸入欄位
	}else if(form.FULL_TIME.value=='Y'){
		if(trimString(form.SETUP_DATE_Y.value) == ""){
			alert("主管機關核准日期(年)不可空白");
			form.SETUP_DATE_Y.focus();
			return false;
		}else if(trimString(form.SETUP_DATE_M.value) == ""){
			alert("主管機關核准日期(月)不可空白");
			form.SETUP_DATE_M.focus();
			return false;
		}else if(trimString(form.SETUP_DATE_D.value) == ""){
			alert("主管機關核准日期(日)不可空白");
			form.SETUP_DATE_D.focus();
			return false;
		}
		if (trimString(form.SETUP_NO.value) == "" ){
			alert("主管機關核准文號不可空白");
			form.SETUP_NO.focus();
			return false;
		}
	}
	
	//若兼任與否為[是]時,則[主管機關核准兼任日期]/ [主管機關核准兼任文號]為必要輸入欄位
	if(form.PART_TIME.value=='Y'){
		if(trimString(form.PART_TIME_DATE_Y.value) == ""){
			alert("主管機關核准兼任日期(年)不可空白");
			form.PART_TIME_DATE_Y.focus();
			return false;
		}else if(trimString(form.PART_TIME_DATE_M.value) == ""){
			alert("主管機關核准兼任日期(月)不可空白");
			form.PART_TIME_DATE_M.focus();
			return false;
		}else if(trimString(form.PART_TIME_DATE_D.value) == ""){
			alert("主管機關核准兼任日期(日)不可空白");
			form.PART_TIME_DATE_D.focus();
			return false;
		}
		if (trimString(form.PART_TIME_NO.value) == "" ){
			alert("主管機關核准兼任文號不可空白");
			form.PART_TIME_NO.focus();
			return false;
		}
	}
	
	if((trimString(form.PART_TIME_DATE_Y.value) != "" ) 
		    || (trimString(form.PART_TIME_DATE_M.value) != "" )
		    || (trimString(form.PART_TIME_DATE_D.value) != "" )){				   	    
		if(isNaN(Math.abs(form.PART_TIME_DATE_Y.value))){
            alert("主管機關核准兼任日期(年)不可輸入文字");    
			form.PART_TIME_DATE_Y.focus();            
            return false;
        }	
        if (trimString(form.PART_TIME_DATE_M.value) == "" ){
			alert("主管機關核准兼任日期(月)不可空白");
			form.PART_TIME_DATE_M.focus();
			return false;
		}			
		if (trimString(form.PART_TIME_DATE_D.value) == "" ){
			alert("主管機關核准兼任日期(日)不可空白");
			form.PART_TIME_DATE_D.focus();		
			return false;
		}	    
    	pDate = '' + (parseInt(form.PART_TIME_DATE_Y.value)+1911) + '/' + form.PART_TIME_DATE_M.value + '/' + form.PART_TIME_DATE_D.value;
    	if(fnValidDate(pDate) != true){
        	alert('主管機關核准兼任日期為無效日期!!');
         	form.PART_TIME_DATE_D.focus();
         	return false;
    	}	  
    	form.PART_TIME_DATE.value = pDate;	    	
	}
	if((trimString(form.SETUP_DATE_Y.value) != "" ) 
		    || (trimString(form.SETUP_DATE_M.value) != "" )
		    || (trimString(form.SETUP_DATE_D.value) != "" )){				   	    
		
		if (trimString(form.SETUP_DATE_Y.value) == "" ){	
			alert("主管機關核准日期(年)不可空白");
			form.SETUP_DATE_Y.focus();
			return false;   
		}         
		if (trimString(form.SETUP_DATE_Y.value)  != "" ){        
			if(isNaN(Math.abs(form.SETUP_DATE_Y.value))){
				alert("主管機關核准日期(年)不可輸入文字");    
				form.SETUP_DATE_Y.focus();            
				return false;
			}
		}
		if (trimString(form.SETUP_DATE_M.value) == "" ){
			alert("主管機關核准日期(月)不可空白");
			form.SETUP_DATE_M.focus();
			return false;
		}			
		if (trimString(form.SETUP_DATE_D.value) == "" ){
			alert("主管機關核准日期(日)不可空白");
			form.SETUP_DATE_D.focus();		
			return false;
		}	    
		sDate = '' + (parseInt(form.SETUP_DATE_Y.value)+1911) + '/' + form.SETUP_DATE_M.value + '/' + form.SETUP_DATE_D.value;
		if( fnValidDate(sDate) != true){
		    alert('主管機關核准日期為無效日期!!');
		    form.SETUP_DATE_D.focus();
		    return false;
		}    
		form.SETUP_DATE.value = sDate;   
	}
	return true;
}
function AddAudit(form,WLX01_size){
	   if(WLX01_size == '0'){
	   	  alert("請先輸入主檔資料");
	   	  return;
	   }else{	
	      form.action="/pages/FX001W.jsp?act=newAudit&test=nothing";
	      form.submit();
	   }   
}


