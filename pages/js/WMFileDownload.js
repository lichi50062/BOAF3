// 94.05.25 add加上bank_type為參數
// 94.11.15 add 若為F01時,只開放查詢 by 2295
// 95.10.02 add 下載報表 by 2495
// 95.11.28 add 下載報表-A99法定比率分析統計表 by 2295
// 96.05.08 fix 農.漁會無法下載excell報表 by 2295
// 96.07.30 add 下載報表--存款帳戶分級差異化管理統計表_農漁會 by 2295
// 96.11.06 add  下載報表-A01資產區負債表/損益表區分農漁會 by 2295
// 97.06.19 add 若為A09時,不開放下載報表 by 2295
//100.05.12 fix A05.報表下載機構名稱被截斷 by 2295
//101.07.31 add 申報資料查詢_m106、m201、m206 by 2968
//101.09.03 add M106/M201/M206,不提供查詢,只提供下載.報表下載 by 2295
//104.01.09 add A12 by 2968
//104.10.14 add A13,不開放下報表 by 2295
//107.08.23 fix 取消A02,需於每月20日以後,才可下載的訊息 by 2295
//108.03.28 add 報表輸出格式 by 2295
//109.06.23 add 增加A15電子銀行及行動支付業務辦理情形 by 6493
//111.03.16 調整Edge點申報資料時,有些報表無報表下載,[報表下載]按鈕無法隱藏 by 2295

function hiddenYM(form)
{
	if(form.Report_no.value=='A04' )
	{
		 form.E_YEAR.disabled=false;        
     form.E_MONTH.disabled=false;            
  }else{   	 
     form.E_YEAR.disabled=true;        
     form.E_MONTH.disabled=true;   
  }
  
}
//96.05.08 fix 農.漁會無法下載excell報表
function doSubmit(form, myfun,BANK_NO,BANK_NAME,muser_id,muser_name) {
	
	//alert('BANK_NO='+BANK_NO);
	if (!checkSingleYM(form.S_YEAR, form.S_MONTH)) return;

	var _id = form.Report_no.value;
	var bank_code = form.Bank_Code_S.value;	
    
    //modify by 2354 2004.12.23 == begin
	var DLId = form.Report_no.value.substr(0, 1);
	
	if(myfun=='Download' && (form.Report_no.value=='M08' || DLId=='B')){
		alert('此報表不提供下載功能');
		return;
	}
	
	if(myfun=='Download' || myfun=='Query'){//fix 96.05.08 by 2295
	   form.action="/pages/WMFileDownload.jsp?act="+myfun+"&bank_type="+form.bank_type.value+"&test=nothing";
	   form.submit();
	}
    
	
	//form.action="/pages/WMFileDownload.jsp?act="+myfun+"&M_YEAR="+form.S_YEAR.value+"&M_MONTH="+form.S_MONTH+"&test=nothing";
	//add by 2495 2006.09.29 
	
	if(myfun=='DownloadReport'){//報表下載
		
		var prtType = new Array ("xls","ods","pdf","rtf","odt","pdf");
		for ( i=0; i<6; i++ ) {
            if(form.printStyle[i].checked){		   	               
	          form.prtStyle.value = prtType[i];
	        }  	       
	    } 	   
	 
	   if(form.Report_no.value == 'B01' || form.Report_no.value == 'B02' || 
	      form.Report_no.value == 'B03' || form.Report_no.value == 'F01' || 
	      form.Report_no.value == 'M01' || form.Report_no.value == 'M02' || 
	      form.Report_no.value == 'M03' || form.Report_no.value == 'M04' || 
	      form.Report_no.value == 'M05' || form.Report_no.value == 'M06' ||
	      form.Report_no.value == 'M07' || form.Report_no.value == 'M08' )
	   {
	      alert("尚無提供報表下載服務");	
	      form.action="/pages/WMFileDownload_Qry.jsp?bank_type="+form.bank_type.value;
	      form.submit();
	   }
	   var UNIT='1';	
	   if(form.Report_no.value == 'A01'){
		  var Report_no=prompt("請輸入欲查看報表類型,查看『資產負債表』請輸入1,查看『損益表』請輸入2","1");
		  if(Report_no==1){
		  	 if(form.bank_type.value == '6'){//96.11.06區分農漁會
			    form.action="/pages/FR003W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&UNIT="+UNIT+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;			 
			 }else if(form.bank_type.value == '7'){
			 	form.action="/pages/FR003F_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&UNIT="+UNIT+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;			 
			 }	
		  }else if(Report_no==2){
			 var hasMonth="null";
			 if(form.bank_type.value == '6'){//96.11.06區分農漁會			
			    form.action="/pages/FR004W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&UNIT="+UNIT+"&hasMonth="+hasMonth+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;			
			 }else if(form.bank_type.value == '7'){
			    form.action="/pages/FR004F_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&UNIT="+UNIT+"&hasMonth="+hasMonth+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;			
			 }		
		  }else{
			alert("請輸入欲查看報表類型,查看『資產負債表』請輸入1,查看『損益表』請輸入2");	
			form.action="/pages/WMFileDownload_Qry.jsp?bank_type="+form.bank_type.value;				
		  }		
		  form.submit();	
		}	
		
		if(form.Report_no.value == 'A02'){			
		   //alert("A02法定比率資料,需於每月20日以後,才可下載該申報基準日報表資料!");//107.08.23取消顯示	
		   form.action="/pages/FR0066W_Rtf.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_TYPE="+form.bank_type.value+"&unit="+BANK_NO+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
		   form.submit();
		}				 
		if(form.Report_no.value == 'A03'){			
			var datestate="null";		
			myfun="download";
		    var Report_no=prompt("請輸入欲查看報表類型,查看『明細表』請輸入1,查看『總表』請輸入2","1");
			if(Report_no==1){
				var rptStyle=1;
				form.action="/pages/FR005W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_TYPE="+form.bank_type.value+"&Unit="+UNIT+"&datestate="+datestate+"&rptStyle="+rptStyle+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;				
			}else if(Report_no==2){
				var rptStyle=0;
				form.action="/pages/FR005W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_TYPE="+form.bank_type.value+"&Unit="+UNIT+"&datestate="+datestate+"&rptStyle="+rptStyle+"&BANK_NO="+BANK_NO+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;				
			}else{
				alert("請輸入欲查看報表類型,查看『明細表』請輸入1,查看『總表』請輸入2");	
				form.action="/pages/WMFileDownload_Qry.jsp?bank_type="+form.bank_type.value;				
			}	
			form.submit();		
		}
				
		if (form.Report_no.value == 'A04'){			
			var datestate="null";					
			form.action="/pages/FR007WA_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit="+UNIT+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}	
		
		if (form.Report_no.value == 'A05'){//100.05.12 fix 無法取得機構名稱 by 2295
			form.action="/pages/FR008W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NO+BANK_NAME+"&bank_type="+form.bank_type.value+"&Unit="+UNIT+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}	 
		
		if (form.Report_no.value == 'A06'){
			var datestate="";
			form.action="/pages/FR037W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit="+UNIT+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}	 
		
		if (form.Report_no.value == 'A08'){//96.07.30 add 存款帳戶分級差異化管理統計表_農漁會
			var datestate="";
			form.action="/pages/FR045W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&E_YEAR="+form.S_YEAR.value+"&E_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit="+UNIT+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}	 
		
	    if (form.Report_no.value == 'A99'){//95.11.28 add 法定比率分析統計表			
			var datestate="";
			form.action="/pages/FR0066WB_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit=1000&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}	
		
		if (form.Report_no.value == 'A10'){//97.06.18 add 應予評估資產彙總表
			var datestate="";
			form.action="/pages/FR047W_Excel.jsp?act=download&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit=1&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}
		
		if (form.Report_no.value == 'A12'){//104.01.09 add 逾期放款及轉銷呆帳及存款準備率降低所增盈餘月報表
			var datestate="";
			form.action="/pages/FR068W_Excel.jsp?act="+myfun+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit="+UNIT+"&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}
		
		if (form.Report_no.value == 'M106'){//101.07.30 add 貸款用途分析表
			var datestate="";
			form.action="/pages/FR059W_Excel.jsp?act=download&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit=1&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}
		if (form.Report_no.value == 'M201'){//101.07.30 add 
			var datestate="";
			form.action="/pages/FR060W_Excel.jsp?act=download&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit=1&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}
		if (form.Report_no.value == 'M206'){//101.07.30 add 金融機構別及地區別保證案件分析表
			var datestate="";
			form.action="/pages/FR061W_Excel.jsp?act=download&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit=1&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}
		if (form.Report_no.value == 'A15'){//109.06.23  增加A15電子銀行及行動支付業務辦理情形
			var datestate="";
			form.action="/pages/FR083W_Excel.jsp?act=download&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&BANK_NO="+BANK_NO+"&BANK_NAME="+BANK_NAME+"&bank_type="+form.bank_type.value+"&datestate="+datestate+"&Unit=1&muser_id="+muser_id+"&muser_name="+muser_name+"&printStyle="+form.prtStyle.value;
			form.submit();
		}
		
	}
	
}

// 94.11.15 add 若為F01時,只開放查詢 by 2295
// 97.06.19 add 若為A09時,不開放下載報表 by 2295
//101.09.03 add M106/M201/M206,不提供查詢,只提供下載.報表下載 by 2295
//104.10.14 add A13,不開放下報表 by 2295
//108.03.28 add 顯示報表輸出格式
//111.03.16 調整Edge點申報資料時,有些報表無報表下載,[報表下載]按鈕無法隱藏 by 2295
function hiddenDownload(b)
{
	if(document.UpdateForm.Report_no.value=='F01'){
       if (b == 'hidden'){        
           document.all.Downloadbtn.style.display='none';        
       }else{       
           document.all.Downloadbtn.style.display='block';        
       }    
    }else{
       document.all.Downloadbtn.style.display='block';        	
    }   
    
    if(document.UpdateForm.Report_no.value=='A09' || document.UpdateForm.Report_no.value=='A13'){
       if (b == 'hidden'){        
           document.all.DownloadReport.style.display='none';        
       }else{       
           document.all.DownloadReport.style.display='block';        
       }    
    }else{
       document.all.DownloadReport.style.display='block';        	
    }
    //101.09.03 add M106/M201/M206,不提供查詢,只提供下載.報表下載
    if(document.UpdateForm.Report_no.value=='M106' || document.UpdateForm.Report_no.value=='M201' || document.UpdateForm.Report_no.value=='M206'){
       if (b == 'hidden'){        
           document.all.Querybtn.style.display='none';        
       }else{       
           document.all.Querybtn.style.display='block';        
       }    
    }else{
       document.all.Querybtn.style.display='block';        	
    }   
    //108.03.28 顯示報表輸出格式
    document.all.printStyle[0].checked=true;
    if(document.UpdateForm.Report_no.value=='A02'){ 
       document.all.printStyle[3].checked=true;
       document.all.rptStype_ods.style.display='none';               
       document.all.rptStype_odt.style.display='block';               
    }else{       
       document.all.rptStype_ods.style.display='block';               
       document.all.rptStype_odt.style.display='none';       
    }          
}

