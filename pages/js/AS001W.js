function doSubmit(form,cnd,bank_no){	     	    	    
	    form.action="/pages/AS001W.jsp?act="+cnd+"&test=nothing";	    
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;	    	    	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/AS001W.jsp?act="+cnd+"&TBANK_NO="+bank_no+"&test=nothing";	    	
	       form.submit();
	    }	
	    /*
	    t = swalconfirm('新增');
	    alert('t='+t);
	    if(t == true){
	    	alert('test1');
	    }else{
	    	alert('test2');
	    }
	    */		
	    //if((cnd == "Insert") && AskInsert(form)) form.submit();//111.01.06 fix	    
	    
	    
	    //$("#Image101").bind("click", function () { $.MsgBox.Confirm("溫馨提示", "確定要進行新增嗎？"); });
	    
	    //if(confirmTest2()) form.submit();//111.01.13 add
	    if((cnd == "Insert") && AskInsert(form)) form.submit();//111.01.06 add
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	    
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	    
}	
/*

function confirmTest2(){	
Swal.fire({
  title: '確定要新增嗎?',
  showDenyButton: true,
  showCancelButton: true,
  confirmButtonText: '確定',
  denyButtonText: '取消',
  cancelButtonText: '取消',
}).then((result) => {
  //Read more about isConfirmed, isDenied below 
  if (result.isConfirmed) {
  	alert('result.isConfirmed='+result.isConfirmed);
    Swal.fire('Saved!', '', 'success');    
  } else if (result.isDenied) {
  	alert('result.isDenied='+result.isDenied);
    Swal.fire('Changes are not saved', '', 'info');    
  }
})

}
*/
/*
function swalconfirm(text) {
    Swal.fire({
        //title: "操作確認",
        text: "確定要"+text+"嗎?",
        showCancelButton: true
    }).then(function(result) {
    	alert(result.value);
    	
       if (result.value) {
       	  //Swal.fire("您按了OK");
       	   return true;
           
       }
       else {
       	   //Swal.fire("您選擇了Cancel");
       	   return false;           
       }
      
    });
}
*/  


/*

function swalConfirm(title, msg) {
    var dfd = jQuery.Deferred();
    Swal.fire({
        title: title,
        html: msg,
        icon: 'question',
        showCancelButton: true,
        animation: false
    }).then(function (result) {
        if (result.value) dfd.resolve();
        else dfd.reject();
    });
    return dfd.promise();
}

function confirmTest() {
    swalConfirm("操作確認", "確定要新增嗎")
        .done(function () {
            //Swal.fire("您按了OK");
            return true;
        })
        .fail(function () {
        	return false;
            //Swal.fire("您選擇了Cancel");
        });
}
*/
	
function checkData(form,cnd) 
{	
	if (trimString(form.BANK_NO.value) =="" ){
		alert("機構代碼不可空白");
		form.BANK_NO.focus();
		return false;
	}else{	   
	    if((form.BANK_TYPE.value == "6" || form.BANK_TYPE.value == "7") && (form.BANK_NO.value.length != 7)){
	       alert("農(漁)會機構代碼，須填入7碼");	
	       form.BANK_NO.focus();
		   return false;
	    }	
	    if(((form.BANK_TYPE.value != "6") && (form.BANK_TYPE.value != "7")) && (form.BANK_NO.value.length < 3)){
	       alert("機構代碼，至少須填入3碼");	
	       form.BANK_NO.focus();
		   return false;
	    }	
	    
	}	
	
	if (trimString(form.BANK_NAME.value) =="" ){
		alert("機構名稱不可空白");
		form.BANK_NAME.focus();
		return false;
	}		
	
	if (trimString(form.BANK_B_NAME.value) =="" ){
		alert("機構簡稱不可空白");
		form.BANK_B_NAME.focus();
		return false;
	}
		
	if((form.BANK_TYPE.value == "6" || form.BANK_TYPE.value == "7") && (form.EXCHANGE_NO.value.length != 7)){
	    alert("農(漁)通匯代碼，須填入7碼");	
	    form.EXCHANGE_NO.focus();
		return false;
	}		
		
   return true;
}
function sameBank_Name(form){
  form.BANK_B_NAME.value = form.BANK_NAME.value;
}