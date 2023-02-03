<%
//106.05.24 creat 經營月報表每月申報資料 by George
//106.11.13 調整 調整若異動日期為null時,無法顯示問題 by 2295
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
	
	List rptBusinessData = (List)request.getAttribute("rptBusinessData");
	
	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			
	System.out.println("BM001W_List.bank_type="+bank_type);
	if(rptBusinessData != null){
	   System.out.println("rptBusinessData.size="+rptBusinessData.size());
	}else{
	   System.out.println("rptBusinessData == null");
	}
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/BM001W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title>經營月報表每月申報資料</title>
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

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0"
	leftmargin="0">
	<form method=post action='/pages/BM001W.jsp'>
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
													<center>經營月報表每月申報資料</center>
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
										<td><table width=600 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#3A9D99">
												<tr align=left bgcolor='#D2F0FF'>
													<td width=582 class="sbody">
													<%if(Utility.getPermission(request,"BM001W","A")){ %>
														<div align="center">
															<a
																href="javascript:doSubmit(this.document.forms[0],'new','')"
																onMouseOut="MM_swapImgRestore()"
																onMouseOver="MM_swapImage('Image9','','images/bt_addb.gif',1)">
																<img src="images/bt_add.gif" name="Image9" width="66"
																height="25" border="0" align="center">
															</a>
														</div>
													<%} %>
													</td>
												</tr>
											</Table></td>
									</tr>
									<tr>
										<td><table width='600' border=1 align='center'
												cellpadding="1" cellspacing="1" bordercolor="#3A9D99">
												<tr bgcolor='#B1DEDC' class="sbody">
													<td width=30% align='center' bordercolor="#3A9D99"><font
														color=#000000>基準日</font></td>
													<td width=40% align='center' bordercolor="#3A9D99">異<font
														color=#000000>動日期</font></td>
												</tr>
									<%for (int i=0;i<rptBusinessData.size();i++){%>
											<% if(i%2 == 0){ %>
												<tr bgcolor='#FFFFE6' class="sbody">
											<% }else{ %>
												<tr bgcolor='#F2F2F2' class="sbody">
											<% } %>
													<td align='center' bordercolor="#3A9D99"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(((DataObject)rptBusinessData.get(i)).getValue("inputdate")).toString() %>');"><%=(((DataObject)rptBusinessData.get(i)).getValue("inputdate")).toString() %></a></td>
													<%if(((DataObject)rptBusinessData.get(i)).getValue("update_date1") == null){%>
														<td align='center' bordercolor="#3A9D99">&nbsp;</td>
													<%}else{%>	
													<td align='center' bordercolor="#3A9D99"><%=(((DataObject)rptBusinessData.get(i)).getValue("update_date1")).toString() %>&nbsp;&nbsp;<%=(((DataObject)rptBusinessData.get(i)).getValue("update_date2")).toString() %></td>
													<%}%>
												</tr>
									<%} %>
											</table></td>
									</tr>
									<td><div align="right"><jsp:include page="getMaintainUser.jsp" flush="true" /></div></td>
								</table></td>
						</tr>
						<tr>
							<td><table width="600" border="0" cellpadding="1"
									cellspacing="1" class="sbody">
									<tr>
										<td colspan="2"><font color='#990000'><img
												src="images/arrow_1.gif" width="28" height="23"
												align="absmiddle"><font color="#007D7D" size="3">使用說明
													: </font></font></td>
									</tr>
									<tr>
										<td width="16">&nbsp;</td>
										<td width="577">
											<ul>
												<li>本網頁提供線上編輯經營月報表每月申報資料。</li>
												<li>點選年月可修改該月份申報資料。</li>
												<li>按新增可新增一筆新的月份資料。</li>
											</ul>
										</td>
									</tr>
								</table></td>
						</tr>
					</table>
					</form>
</body>
</html>
