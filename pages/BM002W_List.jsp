<%
//106.05.24 creat 經營月報表固定項目 by George
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
	
	List bn01Data = (List)request.getAttribute("bn01Data");
	
	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			
	System.out.println("BM002W_List.bank_type="+bank_type);
	if(bn01Data != null){
	   System.out.println("bn01Data.size="+bn01Data.size());
	}else{
	   System.out.println("bn01Data == null");
	}
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/BM002W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title>經營月報表固定項目</title>
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
	<form method=post action='/pages/BM002W.jsp'>
		<input type="hidden" name="act" value="List">
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
										<td width="150"><img src="images/banner_bg1.gif"
											width="150" height="17"></td>
										<td width="300"><font color='#000000' size=4><b>
													<center>經營月報表固定項目</center>
											</b></font></td>
										<td width="150"><img src="images/banner_bg1.gif"
											width="150" height="17"></td>
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
										<td colspan="2">
											<table border="1" width="100%" bgcolor="#FFFFF" bordercolor="#3A9D99">
												<tr class="sbody" bgcolor="#D2F0FF">
													<td>序號</td>
													<td>機構名稱</td>
													<td>核准設立日期</td>
													<td>開始營運日期</td>
													<td>加入存款保險日期</td>
												</tr>
												<%for (int i=0;i<bn01Data.size();i++){
												   if((((DataObject)bn01Data.get(i)).getValue("bank_name")) == null ||  (((DataObject)bn01Data.get(i)).getValue("bank_name")).toString() == null) continue;												
												%>
												<tr class="sbody" bgcolor='#EBF4E1'>
													<td><%=i+1<10?"0"+(i+1):i+1 %></td>
													<td>
														<a href="javascript:showDetailList('<%=(((DataObject)bn01Data.get(i)).getValue("bank_no")).toString() %>')"><%=(((DataObject)bn01Data.get(i)).getValue("bank_name")).toString() %></a>
													</td>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
												</tr>
													
												<tr class="sbody" bgcolor="#FFFFCC"  id="<%=(((DataObject)bn01Data.get(i)).getValue("bank_no")).toString() %>" style="display: none;">
													<td>&nbsp;</td>
													<td>&nbsp;</td>
													<td>
														<a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(((DataObject)bn01Data.get(i)).getValue("bank_no")).toString() %>')"><%=(((DataObject)bn01Data.get(i)).getValue("setup_date")).toString() %></a>
													</td>
													<td>
														<a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(((DataObject)bn01Data.get(i)).getValue("bank_no")).toString() %>')"><%=(((DataObject)bn01Data.get(i)).getValue("start_date")).toString() %></a>
													</td>
													<td>
														<a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(((DataObject)bn01Data.get(i)).getValue("bank_no")).toString() %>')"><%=(((DataObject)bn01Data.get(i)).getValue("add_date")).toString() %></a>
													</td>
												</tr>
														<% } %>
												</table>
											</td>
										</tr>
								</table>
								<p align="center">
								<%if(Utility.getPermission(request,"BM002W","A")){ %>
									<a onmouseover="MM_swapImage('Image102','','images/bt_addb.gif',1)" onmouseout="MM_swapImgRestore()" href="javascript:doSubmit(this.document.forms[0],'New','');">
									<img id="Image102" border="0" name="Image102"  src="images/bt_add.gif"  width="66" height="25"  ></a>
								<%} %>
								</p>
							</td>
					</form>
</body>
</html>
