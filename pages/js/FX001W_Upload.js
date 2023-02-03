// 107.05.11 6417 檔案上傳



function doSubmit(form,table){
	if((table == 'UP') && (!checkWLX01_Upload())){
	       return;
	   }
	 
	if(confirm('確定上傳該資料檔?')){
		form.submit();
	}else{
		return;
	}
	
	
}
function checkWLX01_Upload() 
{	
	
	var fileType = document.getElementById("file_type").value;
	var fileValue = document.getElementById("file_name").value;
	var fileReg = /(doc|docx|xls|xlsx|pdf)$/i;
	//console.log(fileValue);
    if(getRadioVal()=='O' && fileType == ''){
    	alert("其他選項需填寫檔案類型");
        return false;     
    }else if( fileValue == '' ){		
       alert("請選擇檔案");
       return false;         		
	}else if(!fileValue.match(fileReg)){
	   
		alert("檔案僅限word/excel/pdf ");
		return false; 
    }

	return true;
}

function getRadioVal(){
	var val;
	var radios = document.getElementsByName("file_kind");
	
	for(var i = 0; i<radios.length;i++ ){
		if(radios[i].checked){
			val= radios[i].value;
			break;
		}
	}
	return val;
}
