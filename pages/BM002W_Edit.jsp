<%
//106.05.25 create經營月報表固定項目 by George
//111.04.25 移除日期視窗 by 2295
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
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");	
	String report_no = "BM002W";
	List AllBankList = Utility.getbn01Bank("100");
	System.out.println("AllBankList.size:"+AllBankList.size());
	List Bn01Reset = (List) request.getAttribute("Bn01Reset");
	
	String newTbank_no = "";
	String setupDate_year="",setupDate_month="",setupDate_day="";
	String startDate_year="",startDate_month="",startDate_day="";
	String addDate_year="",addDate_month="",addDate_day="";
	
	if("Edit".equals(act) && Bn01Reset != null){
		for(int i=0; i<Bn01Reset.size(); i++){
			newTbank_no = (((DataObject)Bn01Reset.get(i)).getValue("bank_no")).toString();
			String setupDate[] = (((DataObject)Bn01Reset.get(i)).getValue("setup_date")).toString().split("/");
			String startDate[] = (((DataObject)Bn01Reset.get(i)).getValue("start_date")).toString().split("/");
			String addDate[] =  (((DataObject)Bn01Reset.get(i)).getValue("add_date")).toString().split("/");
			
			setupDate_year = String.valueOf(Integer.parseInt(setupDate[0])-1911);
			setupDate_month = setupDate[1];
			setupDate_day = setupDate[2];
			startDate_year = String.valueOf(Integer.parseInt(startDate[0])-1911);
			startDate_month = startDate[1];
			startDate_day = startDate[2];
			addDate_year = String.valueOf(Integer.parseInt(addDate[0])-1911);
			addDate_month = addDate[1];
			addDate_day = addDate[2];
		}
	}
	
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/BM002W.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
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

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0"
	leftmargin="0">
	<form name='form'  method=post action='#'>
		<input type="hidden" name="act" value=""> 
		<input type="hidden" name="wlx01Cancel" value=""> <input type='hidden' name='BUSINESS_ITEM'>
		<table width="640" border="0" align="left" cellpadding="0"
			cellspacing="1" bgcolor="#FFFFFF">
			<tr>
				<td><img src="images/space_1.gif" width="12" height="12"></td>
			</tr>
			<tr>
				<td bgcolor="#FFFFFF">
					<table width="600" border="0" align="center" cellpadding="0"
						cellspacing="0">
						<tr>
							<td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<td width="165"><img src="images/banner_bg1.gif"
											width="165" height="17"></td>
										<td width="270"><font color='#000000' size=4><b>
													<center>
														經營月報表固定項目
													</center>
											</b></font></td>
										<td width="165"><img src="images/banner_bg1.gif" width="165" height="17"></td>
									</tr>
								</table></td>
						</tr>
						<tr>
							<td><img src="images/space_1.gif" width="12" height="12"></td>
						</tr>
						<tr>
							<div align="right"><jsp:include page="getLoginUser.jsp" flush="true" /></div>
						</tr>
						<tr>
							<td><Table width=600 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#3A9D99">
									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175"> <div align=left>機構名稱</div>
									</td>
			                            <td bgcolor='e7e7e7' width="402">
			                            <%if("New".equals(act)){ %>
				                            <select name="newTbank_no">
											<option value="">請選擇</option>
											<%
											if(AllBankList!=null && AllBankList.size()>0){
												for(int i=0; i<AllBankList.size(); i++){
													String bank_no = (String)((DataObject)AllBankList.get(i)).getValue("bank_no");
													out.print("<option value='"+bank_no+"'  "+(bank_no.equals(newTbank_no)?"selected":"")+">"+(String)((DataObject)AllBankList.get(i)).getValue("bank_name")+"</option>");
												}
											}%>
											</select>
										<%}else{ %>
											<input type='hidden' name='newTbank_no' size='7'  value='<%=newTbank_no %>'  >
											<select id="hide1"  disabled='disabled' >
											<option value="">請選擇</option>
											<%
											if(AllBankList!=null && AllBankList.size()>0){
												for(int i=0; i<AllBankList.size(); i++){
													String bank_no = (String)((DataObject)AllBankList.get(i)).getValue("bank_no");
													out.print("<option value='"+bank_no+"'  "+(bank_no.equals(newTbank_no)?"selected":"")+">"+(String)((DataObject)AllBankList.get(i)).getValue("bank_name")+"</option>");
												}
											}%>
											</select>
										<%} %>
										</td>
                         			 </tr>
                          
	                          <tr class="sbody">
						    	<td bgcolor="#D2F0FF" width="175">							
								   <div align=left>核准設立日期</div>
				                </td>
								<td bgcolor="#e7e7e7">
									<input type='hidden' name='setupDate'><!-- //核准設立日期 -->
									<input type='text' id='setupDate_year' name='setupDate_year' value='<%=setupDate_year%>' size='2' maxlength='3' >年
									<select id='setupDate_month' name='setupDate_month' >
										<option></option>
										<%for (int j = 1; j <= 12; j++) {
											if (j < 10){%>
												<option value=0<%=j%> <%if(!"".equals(setupDate_month) && Integer.parseInt(setupDate_month)==j) out.print("selected");%> >0<%=j%></option>
											<%}else{%>
												<option value=<%=j%>  <%if(!"".equals(setupDate_month) && Integer.parseInt(setupDate_month)==j) out.print("selected");%>  ><%=j%></option>
											<%}
										}%>
									</select>月
											            			
									<select id='setupDate_day' name='setupDate_day' >
										<option></option>
										<%for (int j = 1; j <= 31; j++) {
											if (j < 10){ %>
												<option value=0<%=j%>  <%if(!"".equals(setupDate_day) && Integer.parseInt(setupDate_day)==j) out.print("selected");%> >0<%=j%></option>
											<%}else{ %>
												<option value=<%=j%> <%if(!"".equals(setupDate_day) && Integer.parseInt(setupDate_day)==j) out.print("selected");%> ><%=j%></option>
											<%}
										}%>
									</select>日
									<!--button name='button_setupDate' onClick="popupCal('form','setupDate_year,setupDate_month,setupDate_day','BTN_date_setupDate',event)">
									<img align="absmiddle" border='0' name='BTN_date_setupDate' src='images/clander.gif'-->
									</button>
								</td>			    
							</tr>
							  
				            <tr class="sbody">
						    	<td bgcolor="#D2F0FF" width="175">							
								   <div align=left>開始營運日期</div>
				                </td>
								<td bgcolor="#e7e7e7">
									<input type='hidden'  name='startDate'><!-- //開始營運日期 -->
									<input type='text' id='startDate_year' name='startDate_year' value='<%=startDate_year %>' size='2' maxlength='3' >年
									<select id='startDate_month' name='startDate_month'>
										<option></option>
										<%for (int j = 1; j <= 12; j++) {
											if (j < 10){%>
												<option value=0<%=j%> <%if(!"".equals(startDate_month) && Integer.parseInt(startDate_month)==j) out.print("selected");%> onblur='CheckYear(this)' >0<%=j%></option>
											<%}else{%>
												<option value=<%=j%>  <%if(!"".equals(startDate_month) && Integer.parseInt(startDate_month)==j) out.print("selected");%> onblur='CheckYear(this)' ><%=j%></option>
											<%}
										}%>
									</select>月
											            			
									<select id='startDate_day' name='startDate_day' >
										<option></option>
										<%for (int j = 1; j <= 31; j++) {
											if (j < 10){ %>
												<option value=0<%=j%>  <%if(!"".equals(startDate_day) && Integer.parseInt(startDate_day)==j) out.print("selected");%> >0<%=j%></option>
											<%}else{ %>
												<option value=<%=j%> <%if(!"".equals(startDate_day) && Integer.parseInt(startDate_day)==j) out.print("selected");%> ><%=j%></option>
											<%}
										}%>
									</select>日
									<!--button name='button_startDate' onClick="popupCal('form','startDate_year,startDate_month,startDate_day','BTN_date_startDate',event)">
									<img align="absmiddle" border='0' name='BTN_date_startDate' src='images/clander.gif'-->
									</button>
								</td>			    
							</tr>
				           
				            <tr class="sbody">
						    	<td bgcolor="#D2F0FF" width="175">							
								   <div align=left>加入存款保險日期</div>
				                </td>
								<td bgcolor="#e7e7e7">
									<input type='hidden' name='addDate'><!-- //加入存款保險日期 -->
									<input type='text' id='addDate_year' name='addDate_year' value='<%=addDate_year%>' size='2' maxlength='3' >年
									<select id='addDate_month' name='addDate_month' >
										<option></option>
										<%for (int j = 1; j <= 12; j++) {
											if (j < 10){%>
												<option value=0<%=j%> <%if(!"".equals(addDate_month) && Integer.parseInt(addDate_month)==j) out.print("selected");%> >0<%=j%></option>
											<%}else{%>
												<option value=<%=j%>  <%if(!"".equals(addDate_month) && Integer.parseInt(addDate_month)==j) out.print("selected");%>  ><%=j%></option>
											<%}
										}%>
									</select>月
											            			
									<select id='addDate_day' name='addDate_day' >
										<option></option>
										<%for (int j = 1; j <= 31; j++) {
											if (j < 10){ %>
												<option value=0<%=j%>  <%if(!"".equals(addDate_day) && Integer.parseInt(addDate_day)==j) out.print("selected");%> >0<%=j%></option>
											<%}else{ %>
												<option value=<%=j%> <%if(!"".equals(addDate_day) && Integer.parseInt(addDate_day)==j) out.print("selected");%> ><%=j%></option>
											<%}
										}%>
									</select>日
									<!--button name='button_addDate' onClick="popupCal('form','addDate_year,addDate_month,addDate_day','BTN_date_addDate',event)">
									<img align="absmiddle" border='0' name='BTN_date_addDate' src='images/clander.gif'-->
									</button>
									</td>			    
								</tr>
									
									</Table></td>
								</tr>
						<td>

						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><div align="center">
									<table width="243" border="0" cellpadding="1" cellspacing="1">
										<tr>
										<%if(act.equals("New") && Utility.getPermission(request,report_no,"A")){ %>
											<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>
										<% } %>
										<%if(act.equals("Edit") && Utility.getPermission(request,report_no,"U")){ %>
											<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>			            
										<% } %>
										<%if(act.equals("Edit") && Utility.getPermission(request,report_no,"D")){ %>
											<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
										<% } %>
											<td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
											<td width="93"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image81','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image81" width="80" height="25" border="0" id="Image81"></a></div></td>
										</tr>
									</table>
								</div></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<td><div align="right"><jsp:include page="getMaintainUser.jsp" flush="true" /></div></td>
					</table>
				</td>
			</tr>
			<tr>
				<td><table width="600" border="0" cellpadding="1" cellspacing="1" class="sbody">
						<tr>
							<td colspan="2"><font color='#990000'><img src="images/arrow_1.gif" width="28" height="23" align="absmiddle"><font color="#007D7D" size="3">使用說明 : </font></font></td>
						</tr>
						<tr>
							<td width="16">&nbsp;</td>
							<td width="577">
								<ul>
									<li>本網頁提供新增經營月報表固定項目資料。</li>
                          			<li>承辦員E_MAIL請勿填寫外部免費電子信箱以免無法收到更新結果通知。</li>
									<li>確認資料無誤後，按<font color="#666666">【確定】</font>即將本網頁上的資料，於資料庫中新增。</li>
                          			<li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>
									<li>點選所列之<font color="#666666">【回上一頁】</font>則放棄資料， 回至前一畫面。</li>
									<font color='red'> </font>
								</ul>
							</td>
						</tr>
					</table></td>
			</tr>
		</table>
	</form>
</body>
</html>
