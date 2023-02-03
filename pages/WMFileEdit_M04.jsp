﻿<%
//94.02.14 add 預設年月為上個月份,若本月為1月份時.則是申報上個年度的12月份 by 2295
//94.04.21 fix text field靠右 by 2295
//99.10.05 fix 套用DAO.preparestatment,並列印轉換後的SQL by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>

<%
	String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
   	
	System.out.println("WMFileEdit_M04.jsp");	
	//String Report = ( request.getParameter("Report")==null ) ? "" : (String)request.getParameter("Report");		
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");		
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? YEAR : (String)request.getParameter("S_YEAR");		
	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? MONTH : (String)request.getParameter("S_MONTH");		
	System.out.println("S_MONTH="+S_MONTH);
	//String Acc_Div = ( request.getParameter("Acc_Div")==null ) ? "" : (String)request.getParameter("Acc_Div");		
	//System.out.println("Report="+Report);
	List data_div01 = null;
	if(act.equals("new")){
		StringBuffer sqlCmd = new StringBuffer();
        sqlCmd.append(" select loan_use_no as \"loan_use_no\" ,loan_use_name ");
        sqlCmd.append(" from m00_loan_use ");
        sqlCmd.append(" order by input_order ");
	    data_div01 = DBManager.QueryDB_SQLParam(sqlCmd.toString(),null,"");
	}else{
		data_div01 = (List)request.getAttribute("data_div01");
	}
	System.out.println("data_div01.size="+data_div01.size());
%>

<html>
<head>
<style>
all.clsMenuItemNS{font: x-small Verdana; color: white; text-decoration: none;}
.clsMenuItemIE{text-decoration: none; font: x-small Verdana; color: white; cursor: hand;}
A:hover {color: white;}
input.small {font-size:8pt}
</style>
<%if(act.equals("Query")){%>
<title>申報資料查詢</title>
<%}else{%>
<title>線上編輯申報資料</title>
<%}%>

<link href="css/b51.css" rel="stylesheet" type="text/css">

<script language="JavaScript" type="text/JavaScript">
<!--
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
//-->
</script>
<script language="javascript" event="onresize" for="window"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/WMFileEdit.js"></script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" background="images/bg_1.gif" leftmargin="0">
<script language="JavaScript" src="js/menu.js"></script>
<!--
不需使用浮動視窗
<script language="JavaScript" src="js/menucontext_M04.js"></script> 
<script language="JavaScript">
showToolbar();
</script>
-->
<script language="JavaScript">
function UpdateIt(){
if (document.all){
document.all["MainTable"].style.top = document.body.scrollTop;
setTimeout("UpdateIt()", 200);
}
}
UpdateIt();
</script>
<form name='frmWMFileEdit' method=post action='/pages/WMFileEdit.jsp'>
 <input type="hidden" name="act" value="">  
<table width="1100" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#297A76">
  <tr>
    <td bordercolor="#FFFFFF"><table width="1100" border="0" align="center" cellpadding="0" cellspacing="0">
<!--        <tr> 
          <td><img src="images/topbanner_1.gif" width="780" height="103"></td>
        </tr>
-->       
        <tr> 
          <td bgcolor="#FFFFFF">&nbsp;</td>
        </tr>
        <tr> 
          <td bgcolor="#FFFFFF">
<table width="1100" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="1100" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="340"><img src="images/banner_bg1.gif" width="340" height="17"></td>
                      <td width="*"><font color='#000000' size=4><b> 
                        <center>
                          <b> 
                          <center>
                          <%if(act.equals("Query")){%>
                            <font color='#000000' size=4>申報資料查詢</font> 
                          <%}else{%>
                            <font color='#000000' size=4>線上編輯</font><font color="#CC0000"><font size=4>【農業信用保證基金貸款用途分析表】</font></font><font color='#000000' size=4></font> 
                          <%}%>  
                          </center>
                          </b> 
                        </center>
                        </b></font> </td>
                      <td width="340"><img src="images/banner_bg1.gif" width="340" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td><table width="1100" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                       <div align="right"><jsp:include page="getLoginUser.jsp?width=1100" flush="true" /></div>
                    </tr>
                    <tr> 
                      <td><Table width=1100 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#3A9D99">
                          <%if(act.equals("Query")){%>
                      	  <tr class="sbody"> 
                            <td width="112" bgcolor='#D8EFEE'> <div align=left>申報資料</div></td>
                            <td colspan=2 bgcolor='e7e7e7'>M04&nbsp;&nbsp;&nbsp;<%=ListArray.getDLIdName("4", "M04")%></td>
                          </tr>  
                          <%}%>                          
                          <tr class="sbody"> 
                            <td width="112" bgcolor='#D8EFEE'> <div align=left>基準日</div></td>
                            <td colspan=2 bgcolor='e7e7e7'>
                            <input type='text' name='S_YEAR' value="<%=S_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' <%if(act.equals("Edit")) out.print("disabled");%>>
        						<font color='#000000'>年
        						<select id="hide1" name=S_MONTH <%if(act.equals("Edit")) out.print("disabled");%>>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(S_MONTH.equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(S_MONTH.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						        	
        						</select><font color='#000000'>月</font>
                            </td>
                          </tr>
                          
                          <table width=1100 border='1' align='center' cellpadding="1" cellspacing="1" bordercolor="#3A9D99" class="sbody">
						  <tr bgcolor='e7e7e7' class="sbody"> 
                            <td bgcolor="#B1DEDC" rowspan=2><div align=center>貸款用途</div></td>
                            <td bgcolor="#B1DEDC" colspan=6><div align=center>當月份</div></td>
                            <td bgcolor="#B1DEDC" colspan=6><div align=center>當年度</div></td>
                            <td bgcolor="#B1DEDC" colspan=6><div align=center>累　計</div></td>
                          </tr>
						  <tr bgcolor='e7e7e7' class="sbody"> 
                            <td bgcolor="#B1DEDC"> <div align=center>件數</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>貸款金額</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>保證金額</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>件數</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>貸款金額</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>保證金額</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>件數</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>貸款金額</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>保證金額</div></td>
                            <td bgcolor="#B1DEDC"> <div align=center>%</div></td>
                          </tr>

 <% 	int i = 0 ;
 		int loan_index = 0 ;
		boolean fontbold=false;
		//String fontsize="2";		
		while( i < data_div01.size()){
		
%>
 			              <tr bgcolor='e7e7e7' class="sbody">
			                <td bgcolor="#D8EFEE"><div align=left>
			                <%= ((String)((DataObject)data_div01.get(i)).getValue("loan_use_name")).trim()%></div>
 			                 <input type=hidden value="<%=(String)((DataObject)data_div01.get(i)).getValue("loan_use_no")%>" name='loan_use_no_c'>
			                </td>
			                <% if( ((DataObject)data_div01.get(i)).getValue("guarantee_no_month") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_no_month") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_no_month")).toString()).equals("0")) ){%>
                                               <td><div align=left><input type='text' name='guarantee_no_month' class="small" value="" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
                                        <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_no_month' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("guarantee_no_month")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_no_month"))).toString())%>" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_no_month_p") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_no_month_p") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_no_month_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_no_month_p' class="small" value="" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>           
			                        <td><div align=left><input type='text' name='guarantee_no_month_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("guarantee_no_month_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_no_month_p"))).toString())%>" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("loan_amt_month") == null ||  (((DataObject)data_div01.get(i)).getValue("loan_amt_month") != null && ((((DataObject)data_div01.get(i)).getValue("loan_amt_month")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='loan_amt_month' class="small" value="" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='loan_amt_month' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("loan_amt_month")) == null ? "":(((DataObject)data_div01.get(i)).getValue("loan_amt_month"))).toString())%>" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("loan_amt_month_p") == null ||  (((DataObject)data_div01.get(i)).getValue("loan_amt_month_p") != null && ((((DataObject)data_div01.get(i)).getValue("loan_amt_month_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='loan_amt_month_p' class="small" value="" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='loan_amt_month_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("loan_amt_month_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("loan_amt_month_p"))).toString())%>" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_amt_month") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_amt_month") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_amt_month")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_amt_month' class="small" value="" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_amt_month' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("guarantee_amt_month")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_amt_month"))).toString())%>" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_amt_month_p") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_amt_month_p") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_amt_month_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_amt_month_p' class="small" value="" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_amt_month_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("guarantee_amt_month_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_amt_month_p"))).toString())%>" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_no_year") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_no_year") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_no_year")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_no_year' class="small" value="" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_no_year' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("guarantee_no_year")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_no_year"))).toString())%>" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_no_year_p") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_no_year_p") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_no_year_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_no_year_p' class="small" value="" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_no_year_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("guarantee_no_year_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_no_year_p"))).toString())%>" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("loan_amt_year") == null ||  (((DataObject)data_div01.get(i)).getValue("loan_amt_year") != null && ((((DataObject)data_div01.get(i)).getValue("loan_amt_year")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='loan_amt_year' class="small" value="" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='loan_amt_year' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("loan_amt_year")) == null ? "":(((DataObject)data_div01.get(i)).getValue("loan_amt_year"))).toString())%>" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("loan_amt_year_p") == null ||  (((DataObject)data_div01.get(i)).getValue("loan_amt_year_p") != null && ((((DataObject)data_div01.get(i)).getValue("loan_amt_year_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='loan_amt_year_p' class="small" value="" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='loan_amt_year_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("loan_amt_year_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("loan_amt_year_p"))).toString())%>" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_amt_year") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_amt_year") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_amt_year")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_amt_year' class="small" value="" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_amt_year' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("guarantee_amt_year")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_amt_year"))).toString())%>" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_amt_year_p") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_amt_year_p") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_amt_year_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_amt_year_p' class="small" value="" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_amt_year_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("guarantee_amt_year_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_amt_year_p"))).toString())%>" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_no_totacc' class="small" value="" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_no_totacc' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc"))).toString())%>" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc_p") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc_p") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_no_totacc_p' class="small" value="" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_no_totacc_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_no_totacc_p"))).toString())%>" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("loan_amt_totacc") == null ||  (((DataObject)data_div01.get(i)).getValue("loan_amt_totacc") != null && ((((DataObject)data_div01.get(i)).getValue("loan_amt_totacc")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='loan_amt_totacc' class="small" value="" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='loan_amt_totacc' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("loan_amt_totacc")) == null ? "":(((DataObject)data_div01.get(i)).getValue("loan_amt_totacc"))).toString())%>" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("loan_amt_totacc_p") == null ||  (((DataObject)data_div01.get(i)).getValue("loan_amt_totacc_p") != null && ((((DataObject)data_div01.get(i)).getValue("loan_amt_totacc_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='loan_amt_totacc_p' class="small" value="" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='loan_amt_totacc_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("loan_amt_totacc_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("loan_amt_totacc_p"))).toString())%>" size=5 maxlength=6 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_amt_totacc' class="small" value="" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_amt_totacc' class="small" value="<%=Utility.setCommaFormat(((((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc"))).toString())%>" size=13 maxlength=14 onFocus='this.value=changeVal(this)' onBlur='checkPoint_focus(this);this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }
			                            
			                if( ((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc_p") == null ||  (((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc_p") != null && ((((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc_p")).toString()).equals("0")) ){%>
			                    <td><div align=left><input type='text' name='guarantee_amt_totacc_p' class="small" value="" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% }else{ %>
			                        <td><div align=left><input type='text' name='guarantee_amt_totacc_p' class="small" value="<%=Utility.getPercentNumber(((((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc_p")) == null ? "":(((DataObject)data_div01.get(i)).getValue("guarantee_amt_totacc_p"))).toString())%>" size=3 maxlength=4onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this)' style='text-align: right;'></div></td>
			                <% } %>
			              </tr>
                <%	i++;
		}%>
			              <tr bgcolor='e7e7e7' class="sbody">
			                <td colspan=19>註：自80年1月1日起受理保證貸款始區分用途別，故本表累計欄係自上述日期起算。
			                </td>
			              </tr>
                    </table><BR>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr>
              </table></td>
              </tr>
              <tr>                  
                <td><div align="right"><jsp:include page="getMaintainUser.jsp?width=1100" flush="true" /></div></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td><div align="center"> 
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>     
			 	<% //如果.有權限做update,且程科目代號不為空值時才顯示確定跟取消%> 
				<%if(act.equals("new")){%>  
                        <td width="74"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert','M04','','','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image91','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image91" width="66" height="25" border="0" id="Image91"></a></div></td>
         		<%}%>
         		<%if(act.equals("Edit")){%>
                        <td width="74"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update','M04','<%=S_YEAR%>','<%=S_MONTH%>','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image91','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image91" width="66" height="25" border="0" id="Image91"></a></div></td>
                        <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete','M04','<%=S_YEAR%>','<%=S_MONTH%>','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
                <%}%>
           		<%if(!act.equals("Query")){%>
                        <td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
                <%}%>        
                        <td width="93"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image81','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image81" width="80" height="25" border="0" id="Image81"></a></div></td>
                      </tr>
                    </table>
                  </div></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF"><table width="1100" border="0" align="center" cellpadding="1" cellspacing="1">
              <tr> 
                <td><div align="center"><img src="images/line_1.gif" width="1100" height="12"></div></td>
              </tr>
              <tr> 
                <td><table width="1100" border="0" cellpadding="1" cellspacing="1" class="sbody">
                    <tr> 
                      <td colspan="2"><font color='#9110000'><img src="images/arrow_1.gif" width="28" height="23" align="absmiddle"><font color="#007D7D" size="3">使用說明 
                        : </font></font></td>
                    </tr>
                    <tr> 
                      <td width="16">&nbsp;</td>
                      <td width="577"> <ul>
                          <li>本網頁提供新增農業信用保證基金貸款用途分析表。<%=ListArray.getDLIdName("1", "M04")%></li>
                          <li>承辦員E_MAIL請勿填寫外部免費電子信箱以免無法收到更新結果通知。</li>
                          <li>確認資料無誤後，按<font color="#666666">【確定】</font>即將本網頁上的資料，於資料庫中新增。</li>
                          <li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>
                          <li>點選所列之<font color="#666666">【回上一頁】</font>則放棄資料， 回至前一畫面。</li>
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td><div align="center"><img src="images/line_1.gif" width="1100" height="12"></div></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td bgcolor="#FFFFFF">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</form>
</body>

</html>
