<%
// 94.03.10	增加營運中/裁撤別下拉選單處理 add by egg
// 94.08.12  add Office 2003版Excel現僅提供「下載報表」功能 
// 94.09.05  add 拿掉檢視報表 by 2295
// 94.11.16  add 全體漁會信用部.金額單位 by 2295
// 99.04.26  fix 縣市合併調整 by 2808
//100.05.03 fix 無法顯示漁會機構名稱 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%
	showCancel_No=true;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
	showCityType=false;//顯示縣市別
	showUnit=true;//顯示金額單位
	showPageSetting=true;//顯示報表列印格式
	setLandscape=false;//true:橫印
	Map dataMap =Utility.saveSearchParameter(request);
	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;		
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;		
	String report_no = "FR003F";
	String bankType = Utility.getTrimString(dataMap.get("bankType"));
	//94.03.10 add by egg
   	String sqlCmd = "";
	String cancel_no = "";
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">

function doSubmit(cnd){   

   this.document.forms[0].action = "/pages/FR003F_Excel.jsp?act="+cnd;	
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();   
}
//94.03.10 add by egg
//重導FR003F_Qry.jsp頁面以致輸出對應之金融機構資料
function getData(form,item){
	if(item == 'cancel_no'){
		//初始BANK_NO值
	   	form.BANK_NO.value="";
	}
	form.action="/pages/FR003F_Qry.jsp?act=getData&test=nothing";
	form.submit();
}
function changeTbank(xml) {
	var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption; 
    var target = document.getElementById("BANK_NO");
    var type = form.bankType.value;
   	var m_year = form.S_YEAR.value;
   	target.length = 0;
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }
    myXML = document.all(xml).XMLDocument;
    nodeType = myXML.getElementsByTagName("bankType");//bank_type農/漁會
    nodeCity = myXML.getElementsByTagName("bankCity");//hsien_id縣市別
	nodeValue = myXML.getElementsByTagName("bankValue");//bank_no機構代號
	nodeName = myXML.getElementsByTagName("bankName");//bank_no+bank_name
	nodeYear = myXML.getElementsByTagName("bankYear");//m_year所屬年度
	BnType = myXML.getElementsByTagName("BnType");//bn_type營運中/已裁撤
	
	var typeName="農漁會";
	if(type=="6"){
		typeName="農會"
	}else if(type=="7"){
		typeName="漁會"
	}
	oOption = document.createElement("OPTION");
	oOption.text="全體"+typeName+"信用部";
	oOption.value="ALL/全體"+typeName+"信用部";
	target.add(oOption);
	for(var i=0;i<nodeType.length ;i++)	{
		//無區分縣市別==============
	    //有區分營運中/已裁撤
	    if((nodeYear.item(i).firstChild.nodeValue == m_year) &&
  	       (nodeType.item(i).firstChild.nodeValue == type) )  {//相同年度.農/漁會  
		    if(form.CANCEL_NO.value == 'N'){//營運中				
		         if(BnType.item(i).firstChild.nodeValue != '2'){
		        	 oOption = document.createElement("OPTION");
		        	 oOption.text=nodeName.item(i).firstChild.nodeValue;
			         oOption.value=nodeValue.item(i).firstChild.nodeValue+"/"+nodeName.item(i).firstChild.nodeValue;  
			         target.add(oOption);
		         }		
	        }else{//已裁撤		    
	             if(BnType.item(i).firstChild.nodeValue == '2'){
	            	 oOption = document.createElement("OPTION");
	            	 oOption.text=nodeName.item(i).firstChild.nodeValue;
			         oOption.value=nodeValue.item(i).firstChild.nodeValue+"/"+nodeName.item(i).firstChild.nodeValue;
			         target.add(oOption);
		         }
	        }
		    
	    }
	}
	target[0].selected=true;
}


	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_preloadImages() { //v3.0
	  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

	function MM_jumpMenu(targ,selObj,restore){ //v3.0
		eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
		if (restore) selObj.selectedIndex=0;
	}
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name='form' method=post action='#'>
<input type='hidden' name="showTbank" value='<%=showBankType %>'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type="hidden" name="showCancel_No" value='<%=showCancel_No %>'>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="50%"><font color='#000000' size=4><b><center>漁會信用部資產負債表</center></b></font></td>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<Table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" bgcolor="#BDDE9C">
    <td colspan="2" height="1">
      <div align="right">
       <input type='radio' name="excelaction" value='download' checked> 下載報表
       <a href="javascript:doSubmit('createRpt')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
      </div>
    </td>
</tr>
<%//105.4.6 控制點不同，無法共用  ym_hsien_id_unit.include  by 2968%>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">查詢日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type="text" name="S_YEAR" size="3" maxlength="3" value="<%=YEAR%>"
    	onChange="changeTbank('TBankXML');" >
      年      
    <select id="hide1" name=S_MONTH>        						
     <%
     	for (int j = 1; j <= 12; j++) {
     	if (j < 10){%>        	
     	<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
     	<%}else{%>
     	<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
     	<%}%>
     <%}%>
     </select><font color='#000000'>月</font>
    </td>
</tr>
<%if(showCancel_No){%>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">營運中/裁撤別</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
     <select name='CANCEL_NO' onChange="changeTbank('TBankXML');">
     	<option  value="N" <%if((!cancel_no.equals("")) && cancel_no.equals("N")) out.print("selected");%>>營運中</option>
     	<option  value="Y" <%if((!cancel_no.equals("")) && cancel_no.equals("Y")) out.print("selected");%>>已裁撤</option>
     </select>
    </td>
</tr>
<%}%>
<%if(showBankType){%>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="416" bgcolor="#EBF4E1" height="1">  
  <select size="1" name="bankType" onChange="checkCity();resetOption();changeTbank('TBankXML', form.tbank, form.cityType, form)">
  <%if(bankType.equals("6")){//有農會的menu時,才可顯示農會%>
  <option value ='6' <%if((!bankType.equals("")) && bankType.equals("6")) out.print("selected");%>>農會</option>                                                            
  <%}%>
  <%if(bankType.equals("7")){//有漁會的menu時,才可顯示漁會%>
  <option value ='7' <%if((!bankType.equals("")) && bankType.equals("7")) out.print("selected");%>>漁會</option>                              
  <%}%> 
  </select>
</td>
</tr>
<%}else{%>
	<input type='hidden' name="bankType" value='<%=Utility.getTrimString(dataMap.get("bank_type")) %>'>
<%}%>
<%if(showCityType){%>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">縣市別</td>
<td width="416" bgcolor="#EBF4E1" height="1">
  <select size="1" name="cityType" onChange="changeTbank('TBankXML', form.tbank, form.cityType, form)" >
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;
  </td>
</tr>
<%}%>
<%if(showUnit){%>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
<td width="416" bgcolor="#EBF4E1" height="1">
   <select size="1" name="Unit">
     <option value ='1' <%if((!Unit.equals("")) && Unit.equals("1")) out.print("selected");%>>元</option>
     <option value ='1000' <%if((!Unit.equals("")) && Unit.equals("1000")) out.print("selected");%>>千元</option>
     <option value ='10000' <%if((!Unit.equals("")) && Unit.equals("10000")) out.print("selected");%>>萬元</option>
     <option value ='1000000' <%if((!Unit.equals("")) && Unit.equals("1000000")) out.print("selected");%>>百萬元</option>
     <option value ='10000000' <%if((!Unit.equals("")) && Unit.equals("10000000")) out.print("selected");%>>千萬元</option>
     <option value ='100000000' <%if((!Unit.equals("")) && Unit.equals("100000000")) out.print("selected");%>>億元</option>
   </select>
 </td>
</tr> 
<%}%>  
<tr class="sbody">
	<td width="118" bgcolor="#BDDE9C" height="1">機構單位 :</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
		<select id='BANK_NO' name='BANK_NO'/>
    </td>
<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
  <tr>
  	<td bgcolor="#E9F4E3" colspan="2">
       <div align="center">
  		<table width="574" border="0" cellpadding="1" cellspacing="1">
  		<tr><td width="34"><img src="/pages/images/print_1.gif" width="34" height="34"></td>
            <td width="492"><font color="#CC6600">本報表採用A4紙張橫印</font></td>                              
        </tr>
        </table>
        </div>
    </td>
  </tr>  
</table>    
</table>

<!-- -------------------------------------------------------------- -->

</form>
<script language="JavaScript" type="text/JavaScript">

changeTbank("TBankXML") ;

</script>
</body>
</html>
