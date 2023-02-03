//106.05.25 create by George
function doSubmit(form,fun,key){
	   if(fun == 'New'){
		   form.action="/pages/BM002W_Edit.jsp?act="+fun;
		   form.submit();
	   }
	   else if(fun == 'Edit'){
		   form.action="/pages/BM002W.jsp?act="+fun+"&key="+key;
		   form.submit();
	   }
	   else if(checkData(form)){
		   form.action="/pages/BM002W.jsp?act="+fun;
		   if((fun == "Insert") && AskInsert(form)) form.submit();	    
		   if((fun == "Update") && AskUpdate(form)) form.submit();	    
		   if((fun == "Delete") && AskDelete(form)) form.submit();
	   }
}	

function showDetailList(id){
	var result_style = document.getElementById(id).style;
	if(result_style.display == 'none'){
		result_style.display = '';
	}else{
		result_style.display = 'none';
	}
}

function checkData(form) {	
	
	form.setupDate.value = '';
	form.startDate.value = '';
	form.addDate.value = '';
	
	if (trimString(form.newTbank_no.value) =="" ){
		alert("請選擇機構名稱");
		form.newTbank_no.focus();
		return false;
	}
	
	mergeCheckedDate("setupDate_year;setupDate_month;setupDate_day","setupDate");
	mergeCheckedDate("startDate_year;startDate_month;startDate_day","startDate");
	mergeCheckedDate("addDate_year;addDate_month;addDate_day","addDate");
	
	if (trimString(form.setupDate.value) =="" ){
		alert("核准設立日期不可空白");
		return false;
	}
	if (trimString(form.startDate.value) =="" ){
		alert("開始營運日期不可空白");
		return false;
	}
	if (trimString(form.addDate.value) =="" ){
		alert("加入存款保險日期不可空白");
		return false;
	}
	
   return true;
}