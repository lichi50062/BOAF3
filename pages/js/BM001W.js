//106.05.25 create by George
function doSubmit(form,fun,date){
	   if(fun == 'new'){
		   form.action="/pages/BM001W_Edit.jsp?act="+fun;
		   form.submit();
	   }
	   else if(fun == 'Edit'){
		   form.action="/pages/BM001W.jsp?act="+fun+"&r_date="+date;
		   form.submit();
	   }
	   else if(checkData(form)){
		   form.action="/pages/BM001W.jsp?act="+fun;
		   if((fun == "Insert") && AskInsert(form)) form.submit();	    
		   if((fun == "Update") && AskUpdate(form)) form.submit();	    
		   if((fun == "Delete") && AskDelete(form)) form.submit();
	   }
}	

function checkNu(T1){
	var a = T1.split(",");
	if(a.length>0){
		var str = "";
		for(var i=0;i<a.length;i++){
			str += a[i];
		}
		return isNaN(str);
	}else{
		return isNaN(T1);
	}
}

function changeToSpace(T1) {
	var str = T1.value;
	
	while (str.substring(0,1) == "0") {
		str = str.replace("0", "");
    }
	return str;
}

function changeToZero(T1) {
	var str = T1.value;

	while (str.indexOf(" ") != -1) {
		str = str.replace(" ", "");
    }
    if(str == ""){
    	str = "0";
    }
    return str;
}

function checkData(form) 
{	
	if (trimString(form.m_year.value) =="" ){
		alert("申報年份不可空白");
		form.m_year.focus();
		return false;
	}else if(isNaN(Math.abs(form.m_year.value))){
           alert("申報年份不可為文字");
           form.m_year.focus();
           return false;    
	}
	
	if (trimString(form.m_month.value) =="" ){
		alert("申報月份不可空白");
		form.m_month.focus();
		return false;
	}	
	
	if (trimString(form.loan_amt.value) =="" ){
		alert("專案農貸-貸放餘額不可空白");
		form.loan_amt.focus();
		return false;
	}else if(checkNu(form.loan_amt.value)){
           alert("專案農貸-貸放餘額不可為文字");
           form.loan_amt.focus();
           return false;    
	}
	
	if (trimString(form.loan_over_amt.value) =="" ){
		alert("專案農貸-逾放金額不可空白");
		form.loan_over_amt.focus();
		return false;
	}else if(checkNu(form.loan_over_amt.value)){
           alert("專案農貸-逾放金額不可為文字");
           form.loan_over_amt.focus();
           return false;    
	}
	
	if (trimString(form.loan_cnt.value) =="" ){
		alert("專案農貸受益戶數不可空白");
		form.loan_cnt.focus();
		return false;
	}else if(checkNu(form.loan_cnt.value)){
           alert("專案農貸受益戶數不可為文字");
           form.loan_cnt.focus();
           return false;    
	}
	
	if (trimString(form.bank_cnt.value) =="" ){
		alert("受輔導信用部家數不可空白");
		form.bank_cnt.focus();
		return false;
	}else if(checkNu(form.bank_cnt.value)){
           alert("受輔導信用部家數不可為文字");
           form.bank_cnt.focus();
           return false;    
	}
	
	if (trimString(form.tbank_cnt_6.value) =="" ){
		alert("農會本部家數不可空白");
		form.tbank_cnt_6.focus();
		return false;
	}else if(checkNu(form.tbank_cnt_6.value)){
           alert("農會本部家數不可為文字");
           form.tbank_cnt_6.focus();
           return false;    
	}
	
	if (trimString(form.tbank_cnt_7.value) =="" ){
		alert("漁會本部家數不可空白");
		form.tbank_cnt_7.focus();
		return false;
	}else if(checkNu(form.tbank_cnt_7.value)){
           alert("漁會本部家數不可為文字");
           form.tbank_cnt_7.focus();
           return false;    
	}
	
	if (trimString(form.bank_cnt_6.value) =="" ){
		alert("農會分部家數不可空白");
		form.bank_cnt_6.focus();
		return false;
	}else if(checkNu(form.bank_cnt_6.value)){
           alert("農會分部家數不可為文字");
           form.bank_cnt_6.focus();
           return false;    
	}
	
	if (trimString(form.bank_cnt_7.value) =="" ){
		alert("漁會分部家數不可空白");
		form.bank_cnt_7.focus();
		return false;
	}else if(checkNu(form.bank_cnt_7.value)){
           alert("漁會分部家數不可為文字");
           form.bank_cnt_7.focus();
           return false;    
	}
	
	if (trimString(form.agri_build_amt.value) =="" ){
		alert("農業金庫-建築貸款餘額不可空白");
		form.agri_build_amt.focus();
		return false;
	}else if(checkNu(form.agri_build_amt.value)){
           alert("農業金庫-建築貸款餘額不可為文字");
           form.agri_build_amt.focus();
           return false;    
	}
	
	if (trimString(form.agri_loan_amt.value) =="" ){
		alert("農業金庫-放款不可空白");
		form.agri_loan_amt.focus();
		return false;
	}else if(checkNu(form.agri_loan_amt.value)){
           alert("農業金庫-放款不可為文字");
           form.agri_loan_amt.focus();
           return false;    
	}
	
   return true;
}