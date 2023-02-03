<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.jspsmart.upload.*"%>
<%

String bank_type = (session.getAttribute("bank_type") == null)?"":(String)session.getAttribute("bank_type");				
String tbank_no = (session.getAttribute("tbank_no") == null)?"":(String)session.getAttribute("tbank_no");				
String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");

List dbData = (List)request.getAttribute("dbData");


/*Properties permission = ( session.getAttribute("ZZ031W")==null ) ? new Properties() : (Properties)session.getAttribute("ZZ031W"); 
if(permission == null){
   System.out.println("ZZ031W_List.permission == null");
}else{
   System.out.println("ZZ031W_List.permission.size ="+permission.size());               
}*/

%>

<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/ZZ046W.js"></script>
<script language="javascript" event="onresize" for="window"></script>

<html>
<head>
<title>總機構基本資料維護</title>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#'>
<input type="hidden" name="row" value="<%=dbData.size()+1%>">   
<table width="600" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   			<td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
        <tr> 
          <td bgcolor="#FFFFFF">
		  <table width="773" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="773" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
                      <td width="*"><font color='#000000' size=4><b> 
                        <center>
                          	&nbsp;總機構基本資料維護-其他類別檔案揭露設定&nbsp;
                        </center>
                        </b></font> </td>
                      <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td><table width="773" border="0" align="center" cellpadding="0" cellspacing="0">
               
                    <tr> 
                      <div align="right"><jsp:include page="getLoginUser.jsp?width=773" flush="true" /></div> 
                    </tr>                    
                    <tr> 
                      <td><table width=773 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#3A9D99">                                                    
                      	  <tr class="sbody">
			              	<td width='100%' colspan=7 bgcolor='#D8EFEE'>
					        	<input type="button" value="選項全選" onclick="javascript:selectAll(this.form)">
					            <input type="button" value="選項解除" onclick="javascript:selectNo(this.form)">
					            <input type="button" value="設定揭露" onclick="javascript:doSubmit(this.form, 'Update', 'Y')">
					            <input type="button" value="取消揭露" onclick="javascript:doSubmit(this.form, 'Update', 'N')">
					   			<input type="button" value="全部取消揭露" onclick="javascript:doSubmit(this.form, 'UpdateAll', 'N')">
			              		<font color="red">＊僅顯示最新上傳其他類別檔案</font>
			             	</td>
			              </tr>
			              <tr class="sbody" bgcolor="#9AD3D0">
			              	<td width="5%" align="left">序號</td>
			              	<td width="5%" align="left">選項</td>
			              	<td width="30%" align="left">總機構代碼</td>
			              	<td width="20%" align="left">檔案名稱</td>
			              	<td width="20%" align="left">檔案下載</td>
			              	<td width="10%" align="left">上傳日期</td>
			              	<td width="10%" align="left">揭露至官網</td>
			              </tr>                          
			            <%
						String bgcolor="#D3EBE0";
			            int i=0;
			            
			            if(dbData != null){
			            	if(dbData.size() == 0){%>
			            		<tr class="sbody" bgcolor="<%=bgcolor%>">
			            			 <td colspan=13 align=center>無資料可供查詢</td>
			            		</tr>
			            	<%}else{
			            		while(i<dbData.size()){
			            			bgcolor = (i % 2 == 0)?"#e7e7e7":"#D3EBE0";%>
			            			<tr class ="sbody" bgcolor='<%=bgcolor%>'>
										<!--<td><%=(((DataObject)dbData.get(i)).getValue("seq_no") == null) ?"&nbsp;":((DataObject)dbData.get(i)).getValue("seq_no").toString()%></td> -->
										<td><%=i+1%></td>
										<td>
											<%if ((((DataObject)dbData.get(i)).getValue("append_file") != null)){%>
												<input type="checkbox" name="isModify_<%=(i+1)%>" value="<%=(((DataObject)dbData.get(i)).getValue("bank_no") == null) ?"&nbsp;":(String)((DataObject)dbData.get(i)).getValue("bank_no")%>:<%=(((DataObject)dbData.get(i)).getValue("seq_no") == null) ?"&nbsp;":((DataObject)dbData.get(i)).getValue("seq_no").toString()%>">
											<%}else {%>
												&nbsp;
											<%} %>
										</td>
										<td><%=(((DataObject)dbData.get(i)).getValue("bank_no") == null) ?"&nbsp;":(String)((DataObject)dbData.get(i)).getValue("bank_no")%><br><%=(((DataObject)dbData.get(i)).getValue("bank_name") == null) ?"&nbsp;":(String)((DataObject)dbData.get(i)).getValue("bank_name")%></td>
										<td><%=(((DataObject)dbData.get(i)).getValue("file_type") == null) ?"&nbsp;":(String)((DataObject)dbData.get(i)).getValue("file_type")%></td>
										<td>
											<% if((((DataObject)dbData.get(i)).getValue("append_file") != null)) {%>
												<a href="FX001W_Download.jsp?seq_no=<%=((DataObject)dbData.get(i)).getValue("seq_no").toString()%>&tbank_no=<%=(String)((DataObject)dbData.get(i)).getValue("bank_no")%>"><%=(String)((DataObject)dbData.get(i)).getValue("append_file")%></a>
											<%}else{%>
												&nbsp;
											<% }%>
										</td>										
										<td><%=(((DataObject)dbData.get(i)).getValue("update_date") == null) ?"&nbsp;":Utility.getCHTdate((((DataObject)dbData.get(i)).getValue("update_date")).toString().substring(0, 10), 0)%></td>
										<td><%=(((DataObject)dbData.get(i)).getValue("open_flag") == null) ?"&nbsp;":(String)((DataObject)dbData.get(i)).getValue("open_flag")%></td>
									</tr>
									<%i++;
			            		}	
			            	}
			            } %>
			            </table>
					</td>
				</tr>
			</table></td>
		</tr>
	</table>
</form>
</body>
</html>