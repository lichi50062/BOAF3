<%
//93.12.21 add 權限 by 2295
//94.01.12 fix DEGREE(最高學歷(含科系))	30->100
//			   BACKGROUND(最近經歷)	30->100
//94.03.08 add 增加顯示分支機構代號/名稱 by 2295
//94.04.01 add 同一職務不可有一人以上擔任 by 2295
//         add 檢核身份証號 by 2295
//94.04.06 fix 機構已裁撤時.僅可以查詢 by 2295
//             卸任日期不可大於當日日期或小於就任日期 by 2295
//95.08.21 fix 顯示日期用getStringTokenizerData來拆日期字串 by 2295
//99.12.03 fix sqlInjection by 2808
//102.04.24 add idn解密 by2968
//102.06.27 add idn遮蔽 by2968
//102.08.15 fix maskChar字串遮蔽功能
//111.03.02 調整Edge無法顯示確認視窗 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	String nowDay = Utility.getDateFormat("yyyy/MM/dd");//當日日期
	String haveCancel = ( request.getParameter("haveCancel")==null ) ? "N" : (String)request.getParameter("haveCancel");		
	List WLX02_M = (List)request.getAttribute("WLX02_M");	
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");		
	String bank_no = ( request.getParameter("bank_no")==null ) ? "" : (String)request.getParameter("bank_no");		
	//取得FX002W的權限
	Properties permission = ( session.getAttribute("FX002W")==null ) ? new Properties() : (Properties)session.getAttribute("FX002W"); 
	if(permission == null){
       System.out.println("FX002W_Edit.permission == null");
    }else{
       System.out.println("FX002W_Edit.permission.size ="+permission.size());               
    }
	
	String BIRTH_DATE_Y="";
	String BIRTH_DATE_M="";
	String BIRTH_DATE_D="";
	String BIRTH_DATE="";
	
	String INDUCT_DATE_Y="";
	String INDUCT_DATE_M="";
	String INDUCT_DATE_D="";
	String INDUCT_DATE="";
	
	String ABDICATE_DATE_Y="";
	String ABDICATE_DATE_M="";
	String ABDICATE_DATE_D="";
	String ABDICATE_DATE="";
	List tmpDate=null;
	if(WLX02_M != null && WLX02_M.size() != 0){
	   System.out.println("WLX02_M.size()="+WLX02_M.size());
	    int i = 0;
		if(((DataObject)WLX02_M.get(0)).getValue("birth_date") != null){
		   BIRTH_DATE = Utility.getCHTdate((((DataObject)WLX02_M.get(0)).getValue("birth_date")).toString().substring(0, 10), 0);
		   //95.08.21 顯示日期用getStringTokenizerData來拆日期字串
		   tmpDate = Utility.getStringTokenizerData(BIRTH_DATE,"//");
		   if(tmpDate != null && tmpDate.size() != 0){
		      BIRTH_DATE_Y = (String)tmpDate.get(0);
		      BIRTH_DATE_M = (String)tmpDate.get(1);
		      BIRTH_DATE_D = (String)tmpDate.get(2);		      
		   }
		   /*i = 0;
		   if(BIRTH_DATE.length() == 9) i = 1;
		   BIRTH_DATE_Y = BIRTH_DATE.substring(0,2+i);
		   BIRTH_DATE_M = BIRTH_DATE.substring(3+i,5+i);
		   BIRTH_DATE_D = BIRTH_DATE.substring(6+i,BIRTH_DATE.length());		 */
		}		
		if(((DataObject)WLX02_M.get(0)).getValue("induct_date") != null){
		   INDUCT_DATE = Utility.getCHTdate((((DataObject)WLX02_M.get(0)).getValue("induct_date")).toString().substring(0, 10), 0);
		   //95.08.21 顯示日期用getStringTokenizerData來拆日期字串
		   tmpDate = Utility.getStringTokenizerData(INDUCT_DATE,"//");
		   if(tmpDate != null && tmpDate.size() != 0){
		      INDUCT_DATE_Y = (String)tmpDate.get(0);
		      INDUCT_DATE_M = (String)tmpDate.get(1);
		      INDUCT_DATE_D = (String)tmpDate.get(2);		      
		   }
		   /*i = 0;
		   if(INDUCT_DATE.length() == 9) i = 1;
		   INDUCT_DATE_Y = INDUCT_DATE.substring(0,2+i);
		   INDUCT_DATE_M = INDUCT_DATE.substring(3+i,5+i);
		   INDUCT_DATE_D = INDUCT_DATE.substring(6+i,INDUCT_DATE.length());		 */
		}
		if(((DataObject)WLX02_M.get(0)).getValue("abdicate_date") != null){
		   ABDICATE_DATE = Utility.getCHTdate((((DataObject)WLX02_M.get(0)).getValue("abdicate_date")).toString().substring(0, 10), 0);
		   //95.08.21 顯示日期用getStringTokenizerData來拆日期字串
		   tmpDate = Utility.getStringTokenizerData(ABDICATE_DATE,"//");
		   if(tmpDate != null && tmpDate.size() != 0){
		      ABDICATE_DATE_Y = (String)tmpDate.get(0);
		      ABDICATE_DATE_M = (String)tmpDate.get(1);
		      ABDICATE_DATE_D = (String)tmpDate.get(2);		      
		   }
		   /*i = 0;
		   if(ABDICATE_DATE.length() == 9) i = 1;
		   ABDICATE_DATE_Y = ABDICATE_DATE.substring(0,2+i);
		   ABDICATE_DATE_M = ABDICATE_DATE.substring(3+i,5+i);
		   ABDICATE_DATE_D = ABDICATE_DATE.substring(6+i,ABDICATE_DATE.length());		 */
		}		
	}else{
	   System.out.println("WLX02_M == null");
	}
	
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FX002W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title>負責人基本資料維護</title>
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
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#' name="UpdateForm">
<input type="hidden" name="act" value="">  
<input type="hidden" name="bank_no" value="<%=bank_no%>">  
<input type="hidden" name="seq_no" value="<%if(WLX02_M != null && WLX02_M.size() != 0){out.print((((DataObject)WLX02_M.get(0)).getValue("seq_no")).toString());}%>">
<input type="hidden" name="nowDay" value="<%=nowDay%>">
<table width="640" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   		   <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
        <tr> 
          <td bgcolor="#FFFFFF">
		  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="170"><img src="images/banner_bg1.gif" width="170" height="17"></td>
                      <td width="250"><font color='#000000' size=4><b> 
                        <center>
                          負責人基本資料維護 
                        </center>
                        </b></font> </td>
                      <td width="170"><img src="images/banner_bg1.gif" width="170" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
               
                    <tr> 
                      <div align="right"><jsp:include page="getLoginUser.jsp" flush="true" /></div> 
                    </tr>
                    <tr> 
                      <td><table width=600 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#3A9D99">                          
						
						<tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>分支機構代號</td>
						  <td width='70%' colspan=3 bgcolor='e7e7e7'>  
						    <%if(session.getAttribute("FX002W.bank_no") != null){
						         out.print((String)session.getAttribute("FX002W.bank_no"));
						      }
						    %>
                          </td>
                        </tr>
                            
                        <tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>分支機構名稱</td>
						  <td width='70%' colspan=3 bgcolor='e7e7e7'>						  
							 <%if(session.getAttribute("FX002W.bank_name") != null){
						         out.print((String)session.getAttribute("FX002W.bank_name"));
						      }
						    %>
						    &nbsp;
                          </td>
                        </tr>    
						
        			    <tr class="sbody">
						<td width='30%' bgcolor='#D8EFEE' align='left'>姓名</td>
						<td width='70%' colspan=3 bgcolor='e7e7e7'>						    
						    <input type='text' name='NAME' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print( (((DataObject)WLX02_M.get(0)).getValue("name") == null) ? "" : (String)((DataObject)WLX02_M.get(0)).getValue("name"));%>" size='20' maxlength='20' >
						</td>
        			    </tr>
        			    
        			    <tr class="sbody">
						<td width='30%' bgcolor='#D8EFEE' align='left'>性別</td>
						<td width='70%' colspan=3 bgcolor='e7e7e7'>
						 <select name='SEX'>
						   <option value='M' <%if((WLX02_M == null) || ((WLX02_M != null && WLX02_M.size() != 0) && ((String)((DataObject)WLX02_M.get(0)).getValue("sex")).equals("M"))) out.print("selected");%>>男</option>
        				   <option value='F' <%if((WLX02_M != null && WLX02_M.size() != 0) && ((String)((DataObject)WLX02_M.get(0)).getValue("sex")).equals("F")) out.print("selected");%>>女</option>						   
        				 </select>
        				</td>
        				</tr>
        				
        				<tr class="sbody">
						<td width='30%' align='left' bgcolor='#D8EFEE'>職稱</td>						                       
						<%  List position_code = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='007' order by input_order",null,"");%>
						<td width='70%' colspan=3 bgcolor='e7e7e7'>
                            <select name='POSITION_CODE'>                            
                            <%for(int i=0;i<position_code.size();i++){%>
                            <option value="<%=(String)((DataObject)position_code.get(i)).getValue("cmuse_id")%>" 
                            <%if((WLX02_M != null && WLX02_M.size() != 0) && (((String)((DataObject)position_code.get(i)).getValue("cmuse_id")).equals((String)((DataObject)WLX02_M.get(0)).getValue("position_code")))) out.print("selected");%>
                            >
                            <%=(String)((DataObject)position_code.get(i)).getValue("cmuse_name")%></option>                            
                            <%}%>
                            </select>
                        </td>                                     
                        </tr> 
                        
                        <tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>順位</td>
						  <td width='70%' colspan=3 bgcolor='e7e7e7'>
                            <input type='text' name='RANK' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print( ((DataObject)WLX02_M.get(0)).getValue("rank") == null ?"":(((DataObject)WLX02_M.get(0)).getValue("rank")).toString());%>" size=5 maxlength=5>
        					(請輸入阿拉伯數字 或 不輸入)
                          </td>
	  					</tr>
	  					
	  					<tr class="sbody">
						<td width='30%' align='left' bgcolor='#D8EFEE'>身分證字號</td>
						<td width='35%' colspan=2 bgcolor='e7e7e7'>
                            <input type='text' name='ID' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print(Utility.maskChar(Utility.decode((String)((DataObject)WLX02_M.get(0)).getValue("id")),4,4,"*"));%>" size='10' maxlength='10' size='10' maxlength='10' >  
                            <input type='hidden' name='encode_ID' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print((String)((DataObject)WLX02_M.get(0)).getValue("id"));%>" >                                             
                            <font color="red" size=4>*</font>
                        </td>
                        <td width='35%' bgcolor='e7e7e7'>
                            是否確定
                            <select name=ID_CODE >
                            <option value="Y" <%if((WLX02_M != null && WLX02_M.size() != 0) &&  (((DataObject)WLX02_M.get(0)).getValue("id_code") != null && ((String)((DataObject)WLX02_M.get(0)).getValue("id_code")).equals("Y"))  ) out.print("selected");%>>Y</option>
                            <option value="N" <%if((WLX02_M == null) || (WLX02_M.size() == 0) || ((WLX02_M != null && WLX02_M.size() != 0) &&  ((((DataObject)WLX02_M.get(0)).getValue("id_code") == null) || ((String)((DataObject)WLX02_M.get(0)).getValue("id_code")).equals("N")))   ) out.print("selected");%>>N</option>   
                            </select>                               
                        </td>
                        </tr>	
					     
					    <tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>出生年月日</td>
						  <td width='70%' colspan=3 bgcolor='e7e7e7'>
						    <input type='hidden' name='BIRTH_DATE' value="">
                            <input type='text' name='BIRTH_DATE_Y' value="<%=BIRTH_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=BIRTH_DATE_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(BIRTH_DATE_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(BIRTH_DATE_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=BIRTH_DATE_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(BIRTH_DATE_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(BIRTH_DATE_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日</font>
                            </td>
	  					</tr>
        			    
        			    <tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>最高學歷(含科系)</td>
						  <td width='70%' colspan=3 bgcolor='e7e7e7'>                            
                            <input type='text' name='DEGREE' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print(((String)((DataObject)WLX02_M.get(0)).getValue("degree") == null)?"":(String)((DataObject)WLX02_M.get(0)).getValue("degree"));%>" size='50' maxlength='100'>
        					</td>
	  					</tr>
	  					
	  					<tr class="sbody">
						<td width='30%' bgcolor='#D8EFEE' align='left'>電話</td>
						<td width='70%' colspan=3 bgcolor='e7e7e7'>						        				 
        				 <input type='text' name='TELNO' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print(((String)((DataObject)WLX02_M.get(0)).getValue("telno") == null)?"":(String)((DataObject)WLX02_M.get(0)).getValue("telno"));%>" size='20' maxlength='20' >(含區域號碼，並以"-"區隔)                            
        			    </td>
        			    </tr>	
        			    
        			    <tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>就任日期</td>
						  <td width='70%' colspan=3 bgcolor='e7e7e7'>
						    <input type='hidden' name='INDUCT_DATE' value="">
                            <input type='text' name='INDUCT_DATE_Y' value="<%=INDUCT_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=INDUCT_DATE_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(INDUCT_DATE_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(INDUCT_DATE_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=INDUCT_DATE_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(INDUCT_DATE_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(INDUCT_DATE_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日</font>
        						<font color="red" size=4>*</font>
                            </td>
	  					</tr>
	  					
	  					<tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>卸任日期</td>
						  <td width='35%' bgcolor='e7e7e7'>
						    <input type='hidden' name='ABDICATE_DATE' value="">
                            <input type='text' name='ABDICATE_DATE_Y' value="<%=ABDICATE_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this)' <%if((WLX02_M == null) || ((WLX02_M != null && WLX02_M.size() != 0) && (  ((DataObject)WLX02_M.get(0)).getValue("abdicate_code") == null ||  ((String)((DataObject)WLX02_M.get(0)).getValue("abdicate_code")).equals("N"))) )  out.print("disabled");%>>
        						<font color='#000000'>年
        						<select id="hide1" name=ABDICATE_DATE_M <%if((WLX02_M == null) || ((WLX02_M != null && WLX02_M.size() != 0) && (  ((DataObject)WLX02_M.get(0)).getValue("abdicate_code") == null ||  ((String)((DataObject)WLX02_M.get(0)).getValue("abdicate_code")).equals("N"))) )  out.print("disabled");%>>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(ABDICATE_DATE_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(ABDICATE_DATE_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=ABDICATE_DATE_D <%if((WLX02_M == null) || ((WLX02_M != null && WLX02_M.size() != 0) && (  ((DataObject)WLX02_M.get(0)).getValue("abdicate_code") == null ||  ((String)((DataObject)WLX02_M.get(0)).getValue("abdicate_code")).equals("N"))) )  out.print("disabled");%>>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(ABDICATE_DATE_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(ABDICATE_DATE_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日</font>
                            </td>
                            <td width='35%' colspan=2 bgcolor='e7e7e7'>
                            確定卸任
                            <select name=ABDICATE_CODE onchange="javascript:setAbdicateDate(document.UpdateForm);">
                            <option value="Y" <%if((WLX02_M != null && WLX02_M.size() != 0) && ( ((DataObject)WLX02_M.get(0)).getValue("abdicate_code") != null && ((String)((DataObject)WLX02_M.get(0)).getValue("abdicate_code")).equals("Y")) ) out.print("selected");%>>Y<optopn>
                            <option value="N" <%if((WLX02_M == null) || ((WLX02_M != null && WLX02_M.size() != 0) && ( ((DataObject)WLX02_M.get(0)).getValue("abdicate_code") == null || ((String)((DataObject)WLX02_M.get(0)).getValue("abdicate_code")).equals("N")))  ) out.print("selected");%>>N<optopn>
                            </td>
	  					</tr>
	  					
	  					<tr class="sbody">
						<td width='30%' align='left' bgcolor='#D8EFEE'>最近經歷</td>
						<td width='70%' colspan=3 bgcolor='e7e7e7'>
						    <input type='text' name='BACKGROUND' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print(((String)((DataObject)WLX02_M.get(0)).getValue("background") == null)?"":(String)((DataObject)WLX02_M.get(0)).getValue("background"));%>" size='50' maxlength='100'>                          
                        </td>
                        </tr>                                               
                        
                        <tr class="sbody">
						  <td width='30%' align='left' bgcolor='#D8EFEE'>電子郵件帳號</td>
						  <td width='70%' colspan=3 bgcolor='e7e7e7'>                            
                            <input type='text' name='EMAIL' value="<%if(WLX02_M != null && WLX02_M.size() != 0) out.print(((String)((DataObject)WLX02_M.get(0)).getValue("email") == null)?"":(String)((DataObject)WLX02_M.get(0)).getValue("email"));%>" size='30' maxlength='60' >
        				  </td>
	  					</tr>
        			    
                        </Table></td>
                    </tr>                 
                    <tr>                  
                <td><div align="right"><jsp:include page="getMaintainUser.jsp" flush="true" /></div></td>                                              
              </tr>
              
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td><div align="center"> 
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>   
                      <%if(haveCancel.equals("N")){//94.04.06機構未裁撤時才能執行修改.卸任.刪除%>
   		              <%if(act.equals("newM")){%>
   		                <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){//Add %>                   	        	                                   		      
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'InsertM','Manager');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
				        <%}%>
				      <%}else if(act.equals("EditM")){%>  				        
				        <%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){//Update %>                   	        	                                   		      
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'AbdicateM','Manager');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_abdicateb.gif',1)"><img src="images/bt_abdicate.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>                        
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'UpdateM','Manager');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>                        				        
				        <%}%>
				        <%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){//Delete %>                   	        	                                   		     
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'DeleteM','Manager');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>                        				        				        
				        <%}%>
				      <%}%>
                        <td width="66"><div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image105" width="66" height="25" border="0" id="Image105"></a></div></td>                        
                      <%}//end of 未裁撤者%>
                        <td width="93"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image106" width="80" height="25" border="0" id="Image106"></a></div></td>

              		  </tr>
                    </table>
                  </div></td>
              </tr>     
              
  <tr> 
                <td><table width="600" border="0" cellpadding="1" cellspacing="1" class="sbody">
                    <tr> 
                      <td colspan="2"><font color='#990000'><img src="images/arrow_1.gif" width="28" height="23" align="absmiddle"><font color="#007D7D" size="3">使用說明 
                        : </font></font></td>
                    </tr>
                    <tr> 
                      <td width="16">&nbsp;</td>
                      <td width="577"> <ul>
                      	  <li>按<font color="#666666">【卸任】即將本表上的資料, 於資料庫中建檔。</li>
                          <li>按<font color="#666666">【修改】即將本表上的資料, 於資料庫中建檔</li>
        				  <li>按<font color="#666666">【刪除】即將本表上的資料, 於資料庫中刪除。</li>
        				  <li>如放棄修改或無修改之資料需輸入, 按<font color="#666666">【回上一頁】即離開本程式。</li>        	
        				  <li>順位可空敲,然當職稱相同時,若須排列其職等之順序,則可利用此欄輸入數字,由小到大排序。</li>        	
        				  <li>【<font color="red" size=4>*</font>】為必填欄位。</li>
        				  <li><font color="red">機構已裁撤時,僅可查詢不可再辦理異動事宜。</font></li>
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
              <!--tr> 
                <td><div align="center"><img src="images/line_1.gif" width="600" height="12"></div></td>
              </tr-->
</table>
</form>
</body>
</html>
