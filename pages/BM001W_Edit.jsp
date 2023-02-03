<%
// 106.05.25 create經營月報表每月申報資料 by George
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
	String report_no = "BM001W";
	String r_date = ( request.getParameter("r_date")==null ) ? "" : (String)request.getParameter("r_date");	
	List rptBusiness = (List) request.getAttribute("rptBusiness");
	
	String m_year = Utility.getYear(),m_month = Utility.getMonth();
	String loan_amt="0",loan_over_amt="0";
	String loan_cnt="0",bank_cnt="0",tbank_cnt_6="0",tbank_cnt_7="0",bank_cnt_6="0",bank_cnt_7="0";
	String agri_build_amt="0",agri_loan_amt="0";
	
	if("Edit".equals(act) && rptBusiness != null){
		System.out.println("rptBusiness.size="+rptBusiness.size());
		
		if(rptBusiness.size()>0){
			m_year = (((DataObject)rptBusiness.get(0)).getValue("m_year")).toString();
			m_month = (((DataObject)rptBusiness.get(0)).getValue("m_month")).toString();
			loan_amt = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("loan_amt")).toString());
			loan_over_amt = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("loan_over_amt")).toString());
			loan_cnt = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("loan_cnt")).toString());
			bank_cnt = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("bank_cnt")).toString());
			tbank_cnt_6 = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("tbank_cnt_6")).toString());
			tbank_cnt_7 = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("tbank_cnt_7")).toString());
			bank_cnt_6 = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("bank_cnt_6")).toString());
			bank_cnt_7 = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("bank_cnt_7")).toString());
			agri_build_amt = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("agri_build_amt")).toString());
			agri_loan_amt = Utility.setCommaFormat((((DataObject)rptBusiness.get(0)).getValue("agri_loan_amt")).toString());
		}
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
	<form method=post action='#'>
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
														<font color="#CC0000">【經營月報表每<font size=4>月申報資料】</font></font>
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
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>申報年月</div>
										</td>
											<td bgcolor='e7e7e7'>
											<%if("new".equals(act)){ %>
												<input type='text' name='m_year' size='7' maxlength='3' onblur='CheckYear(this)' value='<%=m_year %>'  > <font color='#000000'>年 
												<select id="hide1" name='m_month' >
														<option> </option>
														<% 
														for(int i =1; i <=12; i++){
															String m = i<10?"0"+i:String.valueOf(i);
															out.print("<option value="+m+" "+ (String.valueOf(i).equals(m_month)?"selected":"")+">"+m+"</option>");
														} 
														%>
												</select><font color='#000000'>月</font>
											<%}else{ %>
												<input type='hidden' name='m_year' size='7' maxlength='3' onblur='CheckYear(this)' value='<%=m_year %>'  >
												<input type='hidden' name='m_month' size='7' maxlength='3' onblur='CheckYear(this)' value='<%=m_month %>'  >
												<input type='text'  size='7' maxlength='3' onblur='CheckYear(this)' value='<%=m_year %>'  disabled='disabled' > <font color='#000000'>年 
												<select id="hide1"  disabled='disabled' >
														<option> </option>
														<% 
														for(int i =1; i <=12; i++){
															String m = i<10?"0"+i:String.valueOf(i);
															out.print("<option value="+m+" "+ (String.valueOf(i).equals(m_month)?"selected":"")+">"+m+"</option>");
														} 
														%>
												</select><font color='#000000'>月</font>
											<%} %>
											</td>
									</tr>

									<tr class="sbody">
										<td bgcolor="#C0C0C0" colspan="2" height="24">
											<p align="center">
												<b><font size="3">信用部</font></b>
										</td>
									</tr>

									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>專案農貸-貸放餘額</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='loan_amt' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=loan_amt %>"> 元</td>
									</tr>
									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>專案農貸-逾放金額</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='loan_over_amt' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=loan_over_amt %>"> 元</td>
									</tr>

									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175" height="27">
											<div align=left>專案農貸受益戶數</div>
										</td>
										<td bgcolor="#e7e7e7" height="27"><input type='text'
											name='loan_cnt' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=loan_cnt %>"> 戶</td>
									</tr>
									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>受輔導信用部家數</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='bank_cnt' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=bank_cnt %>"> 家</td>
									</tr>
									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>農會本部家數</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='tbank_cnt_6' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=tbank_cnt_6 %>"> 家</td>
									</tr>
									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>漁會本部家數</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='tbank_cnt_7' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=tbank_cnt_7 %>"> 家</td>
									</tr>
									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>農會分部家數</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='bank_cnt_6' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=bank_cnt_6 %>"> 家</td>
									</tr>


									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>漁會分部家數</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='bank_cnt_7' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=bank_cnt_7 %>"> 家</td>
									</tr>

									<tr class="sbody">
										<td bgcolor="#C0C0C0" colspan="2">
											<p align="center">
												<b><font size="3">全國農業金庫</font></b>
										</td>
									</tr>
									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175" height="26">
											<div align=left>農業金庫-建築貸款餘額</div>
										</td>
										<td bgcolor="#e7e7e7" height="26"><input type='text'
											name='agri_build_amt' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=agri_build_amt %>"> 元</td>
									</tr>

									<tr class="sbody">
										<td bgcolor="#D2F0FF" width="175">
											<div align=left>農業金庫-放款</div>
										</td>
										<td bgcolor="#e7e7e7"><input type='text'
											name='agri_loan_amt' size=16 maxlength=16
											onFocus='this.value=changeVal(this);this.value=changeToSpace(this);'
											onBlur='checkPoint_focus(this);this.value=changeStr(this);this.value=changeToZero(this);'
											style='text-align: right;' value="<%=agri_loan_amt %>"> 元</td>
									</tr>


								</Table></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><div align="center">
									<table width="243" border="0" cellpadding="1" cellspacing="1">
										<tr>
										<%if(act.equals("new") && Utility.getPermission(request,report_no,"A")){ %>
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
									<li>本網頁提供新增經營月報表每月申報資料。</li>
									<li>承辦員E_MAIL請勿填寫外部免費電子信箱以免無法收到更新結果通知。</li>
									<li>確認資料無誤後，按<font color="#666666">【確定】</font>即將本網頁上的資料，於資料庫中新增。
									</li>
									<li>按<font color="#666666">【取消】</font>即重新輸入資料。
									</li>
									<li>點選所列之<font color="#666666">【回上一頁】</font>則放棄資料， 回至前一畫面。
									</li>
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
