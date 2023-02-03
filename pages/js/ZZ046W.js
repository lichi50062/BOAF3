﻿//107.05.30 add by Ethan.shih
function doSubmit(form,cnd,val){
	form.action="/pages/ZZ046W.jsp?act="+cnd+"&test=nothing&UpdateKey="+val;
	
	if(cnd != 'UpdateAll'){
		if(!checkData(form)){
			return;
		}
	}
	
	form.submit();
}	

function checkData(form,cnd) 
{	
  var flag = false;  
  for (var i = 0 ; i < form.elements.length; i++) {    
    if ( form.elements[i].checked == true ) {
        flag = true;
    }    
  }
  if (flag == false) {     
	alert('請至少選擇一筆欲選擇的資料!');   
    return false;
  }
  return true;
}	

function selectAll(form) {  
	for ( var i = 0; i < form.elements.length; i++) {
		if((form.elements[i].type=='checkbox') && form.elements[i].disabled == false) {	
			form.elements[i].checked = true;
		}	          	  
	}
	return;
}

function selectNo(form) {  
  for ( var i = 0; i < form.elements.length; i++) {
       if((form.elements[i].type=='checkbox') && form.elements[i].disabled == false) {	
      	 form.elements[i].checked = false;
       }	           
  }
  return;
}
