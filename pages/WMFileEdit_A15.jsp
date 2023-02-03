<%
//109.07.08 create by 6493
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%
	
   	String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();   	
	String act = ( request.getParameter("act")==null ) ? "new" : (String)request.getParameter("act");		
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? YEAR : (String)request.getParameter("S_YEAR");		
	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? MONTH : (String)request.getParameter("S_MONTH");		
	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");		
	Boolean F01_APPLY_INI = Boolean.valueOf( (request.getParameter("F01_APPLY_INI")==null) ? "false" : (String)request.getParameter("F01_APPLY_INI") );		
	System.out.println("WMFileEdit_A15.act="+act);
	System.out.println("S_YEAR="+S_YEAR);	
	System.out.println("S_MONTH="+S_MONTH);	
	System.out.println("bank_type="+bank_type);		
	List data_div01 = null;
	String ncacno = "ncacno";
	String ncacno_7 = "ncacno_7";
	StringBuffer sqlCmd = new StringBuffer();
	List paramList = new ArrayList();
	String Report_no="A15";	
	String acc_div = "";
	
	Boolean EDIT_APPLY_INI = request.getAttribute("edit_apply_ini")==null ? false : (Boolean)request.getAttribute("edit_apply_ini");
	data_div01 = (List)request.getAttribute("data_div01");
	//若無資料或第一次申報，需要查詢項目欄位
	if( data_div01 == null || data_div01.size() == 0 || Boolean.valueOf(F01_APPLY_INI) ){
		acc_div = "15";
		StringBuffer sql = new StringBuffer();
		String t1 = ncacno;
		if("6".equals(bank_type)){
			t1 = ncacno;
		}else if("7".equals(bank_type)){
			t1 = ncacno_7;
		}
		sql.append(" select * from " + t1 + " ");		
		sql.append(" left join wlx01_limit_item on substr(" + t1 + ".acc_code,2,3) = limit_type ");		
		sql.append(" where acc_tr_type = ? and acc_div=? order by acc_range ");		
		paramList.add(Report_no);
		paramList.add(acc_div);
		data_div01 = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"update_date");
	}
	
	System.out.println("data_div01.size="+data_div01.size());
	//取得WMFileEdit的權限
	Properties permission = ( session.getAttribute("WMFileEdit")==null ) ? new Properties() : (Properties)session.getAttribute("WMFileEdit"); 
	if(permission == null){
       System.out.println("WMFileEdit_A15.permission == null");
    }else{
       System.out.println("WMFileEdit_A15.permission.size ="+permission.size());
               
    }
%>
<html>
<head>
<style>
all.clsMenuItemNS{font: x-small Verdana; color: white; text-decoration: none;}
.clsMenuItemIE{text-decoration: none; font: x-small Verdana; color: white; cursor: hand;}
A:hover {color: white;}
</style>
<%if(act.equals("Query")){%>
<title>申報資料查詢</title>
<%}else{%>
<title>線上編輯申報資料</title>
<%}%>

<link href="css/b51.css" rel="stylesheet" type="text/css">

<script language="JavaScript" type="text/JavaScript">
</script>
<script language="JavaScript">lastMenu=null;</script>

<script language="javascript" event="onresize" for="window"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/WMFileEdit.js"></script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<script language="JavaScript" src="js/menu.js"></script>

<form name='frmWMFileEdit' method=post action='/pages/WMFileEdit.jsp'>
<input type="hidden" name="act" value="">  
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
                      <td width="80"><img src="images/banner_bg1.gif" width="80" height="17"></td>
                      <td width="440"><font color='#000000' size=4><b> 
                        <center>
                          <b> 
                          <center>
                          <%if(act.equals("Query")){%>
                            <font color='#000000' size=4>申報資料查詢</font> 
                          <%}else{%>
                            <font color='#000000' size=4>線上編輯</font><font color="#CC0000" size=4>【<%=ListArray.getDLIdName("1", "A15")%>】</font>
                          <%}%>  
                          </center>
                          </b> 
                        </center>
                        </b></font> </td>
                      <td width="80"><img src="images/banner_bg1.gif" width="80" height="17"></td>
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
                      <td>
                        <Table width=600 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#3A9D99">                          
                          <tr class="sbody" bgcolor='#D2F0FF'> 
                            <td width="60"> <div align=left>基準日</div></td>
                            <td colspan=4>
                            <input type='hidden' name="S_YEAR" value="<%=S_YEAR%>">
                            <input type='hidden' name="S_MONTH" value="<%=S_MONTH%>">
                            <input type='text' name='S_YEAR' value="<%=S_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' disabled>
        						<font color='#000000'>年
        						<select id="hide1" name=S_MONTH disabled>
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
                          <%if(act.equals("Query")){%>
                      	  <tr class="sbody" bgcolor='#D8EFEE'> 
                            <td width="60"> <div align=left>申報資料</div></td>
                            <td colspan=4>A15&nbsp;&nbsp;&nbsp;<%=ListArray.getDLIdName("1", "A15")%></td>
                          </tr>  
                          <%}%>    
				<%
					//依不同編輯情況，
					//產生畫面時控制顯示"0"或"year_amt"或"year_amt+month_amt"，
					//而取得DataObject時則控制"year_amt"為該月或上個月DB值
					//
					//      |  編輯情況		|	name='year_amt'(畫面顯示)	|	name="origin"(隱藏欄位用以計算)
					//------+---------------+-------------------------------+---------------------------------
					//客戶數 |  初次申報		|	0							|	0
					//		|  修改初次申報	|	該月year_amt					|	0
					//		|  一月新增		|	上月year_amt					|	上月year_amt
					//		|  一月修改		|	上月year_amt+該月month_amt	|	上月year_amt
					//		|  其他新增		|	上月year_amt					|	上月year_amt
					//		|  其他修改		|	上月year_amt+該月month_amt	|	上月year_amt
					//------+---------------+-------------------------------+---------------------------------
					//交易數 |  初次申報		|	0							|	0
					//		|  修改初次申報	|	該月year_amt					|	0
					//		|  一月新增		|	0							|	0
					//		|  一月修改		|	該月year_amt					|	0
					//		|  其他新增		|	上月year_amt					|	上月year_amt
					//		|  其他修改		|	上月year_amt+該月month_amt	|	上月year_amt
				%>
				<%//////////////////////////////////////////////客戶數//////////////////////////////////////////////%>
				<%//項目代碼:900100(電子銀行),900200(行動支付),900300(收單特店-主掃模式),900400(收單特店-被掃模式) %>
                          <tr bgcolor='e7e7e7'>		
							<td colspan=5 bgcolor="#ffffe6"><b><div align=center><a name="A15_div01">客戶數</a></div></b></td>		
						  </tr>
						  <tr bgcolor='e7e7e7' class="sbody"> 
                            <td width=60 bgcolor="#D8EFEE"> <div align=left>項目代碼</div></td>
                            <td width="200"  bgcolor="#D8EFEE" colspan=2> <div align=left>項目名稱</div></td>
                            <td width=161 bgcolor="#B1DEDC"> <div align=left>本月開戶數(戶)</div></td>
                            <td width=161 bgcolor="#B1DEDC"> <div align=left>累計開戶數(自開辦以來)</div></td>
                          </tr>
 				 <% int monthAmt=0,yearAmt=0;
 				 	List deleteList = new ArrayList();
					String bgcolor="#F2F2F2";
					String tmpAcc_Code = "";
					for(int i = 0; i < data_div01.size(); i++){
						//bgcolor = (i % 2 == 0)?"#F2F2F2":"#FFFFE6";			 
						bgcolor="#F2F2F2";
		    			tmpAcc_Code = ((String)((DataObject)data_div01.get(i)).getValue("acc_code")).trim();		  
				 		if( "00".equals(tmpAcc_Code.substring(4)) ){
				 			deleteList.add(data_div01.get(i));
				 %>
						  <tr bgcolor="<%=bgcolor%>" class="sbody">
						  	<td bgcolor="<%=bgcolor%>">			
								<div align=left><%=(String)((DataObject)data_div01.get(i)).getValue("acc_code")%></div>
								<input type=hidden name=acc_code value="<%=(String)((DataObject)data_div01.get(i)).getValue("acc_code")%>">		
								<input type=hidden name=acc_name value="<%=(String)((DataObject)data_div01.get(i)).getValue("acc_name")%>">		
								<input type=hidden name=acc_div value="01">
							</td>
							<td colspan=2>
								<div align=left>	
								<%=(String)((DataObject)data_div01.get(i)).getValue("acc_name")%>		
								</div>
							</td>
							<td>
								<%//本月開戶數(戶) %>
								<a name="<%=tmpAcc_Code%>">
									<%monthAmt=Integer.valueOf(((((DataObject)data_div01.get(i)).getValue("month_amt")) == null ? "0":(((DataObject)data_div01.get(i)).getValue("month_amt"))).toString()); %>
									<input align='right' type='text' name='month_amt' size=16 maxlength=16 onFocus='this.value=changeVal(this)' style='text-align: right;'
									<%//第一次申報時，累計開戶數由使用者填寫，其餘則自動加總至累計開戶數 %>
									<% if( F01_APPLY_INI || EDIT_APPLY_INI){%>
										 onchange='this.value=Math.abs(changeStr(this))==0?"":changeStr(this);' 
									<% }else{ %>
										 onchange='this.value=changeStrA15Add(this);' 
									<% } 	  %>
									<% if( act.equals("new") ){%>
			       						value=""
									<% }else{ %>
			       						value="<%=Utility.setCommaFormat(0==monthAmt?"":String.valueOf(monthAmt))%>" 
									<% }//end of amt ? 0 	%>
									>
								</a>
							</td>
							<td>
								<%//累積開戶數(自開辦以來) %>
								<a name="<%=tmpAcc_Code%>">
									<%yearAmt=Integer.valueOf(((((DataObject)data_div01.get(i)).getValue("year_amt")) == null ? "0":(((DataObject)data_div01.get(i)).getValue("year_amt"))).toString()); %>
									<input type='text' name='year_amt' size=16 maxlength=16 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this);' 
									<% if( F01_APPLY_INI ){%>
										value=""
									<% }else if( act.equals("Edit") && !EDIT_APPLY_INI ){%>
			       						value='<%=Utility.setCommaFormat(yearAmt+monthAmt==0?"":String.valueOf(yearAmt+monthAmt))%>' 
									<% }else{%>
			       						value='<%=Utility.setCommaFormat(yearAmt==0?"":String.valueOf(yearAmt))%>' 
			       					<% } 	  %>
									<%//第一次申報時，累計開戶數由使用者填寫，其餘則自動加總至累計開戶數，並且使用者不能修改 %>
									<% if(F01_APPLY_INI || EDIT_APPLY_INI){ 	%>
										style='text-align: right;'
									<% } else {	%>
										readonly style='color: #808080; background-color: #ffffe6; text-align: right;'
									<% }		%>
									>
									<input type="hidden" name="origin"
									<% if( F01_APPLY_INI || EDIT_APPLY_INI ){%>
			       						value=""
									<% }else{ %> 
										value='<%=Utility.setCommaFormat(0==yearAmt?"":String.valueOf(yearAmt))%>'
									<% }		%>
									>
								</a>
							</td>
						  </tr>
				 <%	    }
					}
					data_div01.removeAll(deleteList);
					deleteList.clear();
				 %>
				<%//////////////////////////////////////////////客戶數 END//////////////////////////////////////////////%>
				
				<%//////////////////////////////////////////////資料整理(客戶數以外的資料)///////////////////////////////%>
				<% 
					//dataList-┬-dataMap(交易情形91XXXX)--------	-┬-("rowspan", 表格合併列數)
					//		   |	  							 └-("tempList", DB資料明細)
					//		   ├-dataMap(交易情形9201XX,9202XX)-	-┬-("rowspan", 表格合併列數)
					//		   |	  							 └-("tempList", DB資料明細)
					//		   └-dataMap(行動支付交易情形92XXXX)--┬-("rowspan", 表格合併列數)
					//				  							 └-("tempList", DB資料明細)
 					List<HashMap> dataList = new ArrayList<HashMap>();
 					HashMap dataMap = new HashMap();
 					List<DataObject> tempList = new ArrayList<DataObject>();
 				 	int rowspan=0;
 					String accCode = "";
 				 	
 					//交易情形:9101XX(約定帳戶轉帳)、9102XX(非約定帳戶轉帳)、9103XX(臺灣Pay購物)、910XXX(動態新增項目)
 					dataMap.put("title", "交易情形");
 				 	dataList.add(dataMap);
 				 	dataMap = new HashMap();
					for(int i = 0; i < data_div01.size(); i++){
		    			tmpAcc_Code = ((String)((DataObject)data_div01.get(i)).getValue("acc_code")).trim();
				 		if( "1".equals(tmpAcc_Code.substring(1,2)) ){
				 			deleteList.add(data_div01.get(i));
				 			if(accCode.isEmpty()){
				 				accCode = tmpAcc_Code.substring(1,4);
				 			}
				 			if(accCode.equals(tmpAcc_Code.substring(1,4))){
				 				//若項目相同則累計表格合併數
				 				rowspan++;
				 			}else{
				 				//若項目不相同則存入dataList並重新計算
				 				dataMap.put("rowspan", rowspan);
				 				dataMap.put("tempList", tempList);
				 				dataList.add(dataMap);
				 				dataMap = new HashMap();
				 				tempList = new ArrayList();
				 				rowspan=1;
				 				accCode = tmpAcc_Code.substring(1,4);
				 			}
				 			tempList.add((DataObject)data_div01.get(i));
				 			continue;
				 		}
					}
					//將以上迴圈最後一個項目存入dataList
					dataMap.put("rowspan", rowspan);
	 				dataMap.put("tempList", tempList);
	 				dataList.add(dataMap);
	 				dataMap = new HashMap();
	 				tempList = new ArrayList();
	 				rowspan=0;
	 				
	 				//移除已存入dataList之資料
					data_div01.removeAll(deleteList);
					deleteList.clear();
					
					//交易情形:9201XX(特店收單交易情形-主掃模式)、9202XX(特店收單交易情形-被掃模式)
	 				for(int i = 0; i < data_div01.size(); i++){
		    			tmpAcc_Code = ((String)((DataObject)data_div01.get(i)).getValue("acc_code")).trim();
		    			if( "201".equals(tmpAcc_Code.substring(1,4)) || "202".equals(tmpAcc_Code.substring(1,4)) ){
				 			deleteList.add(data_div01.get(i));
				 			rowspan++;
				 			tempList.add((DataObject)data_div01.get(i));
				 		}
					}
	 				//將以上迴圈最後一個項目存入dataList
					dataMap.put("rowspan", rowspan);
	 				dataMap.put("tempList", tempList);
	 				dataList.add(dataMap);
	 				dataMap = new HashMap();
	 				tempList = new ArrayList();
	 				rowspan=0;
	 				
	 				//移除已存入dataList之資料
					data_div01.removeAll(deleteList);
					deleteList.clear();
					
					//行動支付交易情形:9203XX(臺灣Pay)、9204XX(Line Pay)、92XXXX(動態新增項目)
					dataMap.put("title", "行動支付交易情形");
					dataList.add(dataMap);
 				 	dataMap = new HashMap();
	 				for(int i = 0; i < data_div01.size(); i++){
		    			tmpAcc_Code = ((String)((DataObject)data_div01.get(i)).getValue("acc_code")).trim();
				 		if( "2".equals(tmpAcc_Code.substring(1,2)) ){
				 			if(accCode.isEmpty()){
				 				accCode = tmpAcc_Code.substring(1,4);
				 			}
				 			if(accCode.equals(tmpAcc_Code.substring(1,4))){
				 				//若項目相同則累計表格合併數
				 				rowspan++;
				 			}else{
				 				//若項目不相同則存入dataList並重新計算
				 				dataMap.put("rowspan", rowspan);
				 				dataMap.put("tempList", tempList);
				 				dataList.add(dataMap);
				 				dataMap = new HashMap();
				 				tempList = new ArrayList();
				 				rowspan=1;
				 				accCode = tmpAcc_Code.substring(1,4);
				 			}
				 			tempList.add((DataObject)data_div01.get(i));
				 		}
					}
	 				//將以上迴圈最後一個項目存入dataList
	 				dataMap.put("rowspan", rowspan);
	 				dataMap.put("tempList", tempList);
	 				dataList.add(dataMap);
				%>
				<%/////////////////////////////////////////////資料整理 END////////////////////////////////////////////%>
				
				<%//////////////////////////////////////////////產生畫面//////////////////////////////////////////////%>
				<% 	
					DataObject dataObject = null;
					for(int i=0; i<dataList.size(); i++){
						dataMap = dataList.get(i);
						if(dataMap.get("title")!=null && !((String)dataMap.get("title")).isEmpty()){
				%>
						  <tr bgcolor='e7e7e7'>		
						    <td colspan=5  bgcolor="#ffffe6"><b><div align=center><a name="A15_div01"><%=(String)dataMap.get("title")%></a></div></b></td>		
						  </tr>
						  <tr bgcolor='e7e7e7' class="sbody"> 
                            <td width=60 bgcolor="#D8EFEE"> <div align=left>項目代碼</div></td>
                            <td width=40 bgcolor="#D8EFEE"> <div align=left>&nbsp;</div></td>
                            <td width=160  bgcolor="#D8EFEE"> <div align=left>項目名稱</div></td>
                            <td width=161 bgcolor="#B1DEDC"> <div align=left>本月交易</div></td>
                            <td width=161 bgcolor="#B1DEDC"> <div align=left>本年累計交易</div></td>
                          </tr>
                <%
							continue;
						}
						tempList = (ArrayList)dataMap.get("tempList");
						for(int j=0; j<tempList.size(); j++){
							dataObject = tempList.get(j);
							bgcolor="#F2F2F2";
							tmpAcc_Code = ((String)dataObject.getValue("acc_code")).trim();
				%>
							<tr bgcolor="<%=bgcolor%>" class="sbody">
						  	<td bgcolor="<%=bgcolor%>">			
								<div align=left><%=(String)dataObject.getValue("acc_code")%></div>
								<input type=hidden name=acc_code value="<%=(String)dataObject.getValue("acc_code")%>">		
								<input type=hidden name=acc_name value="<%=(String)dataObject.getValue("acc_name")%>">		
								<input type=hidden name=acc_div value="01">
							</td>
							
						<% 	//每個項目之第一列合併表格並放入項目名稱 %>
						<% 	if( j==0 ){ %>
							<td rowspan="<%= dataMap.get("rowspan") %>">
								<div align=left>
						<% 		if( "920101".equals(tmpAcc_Code) ){ %>
									特店收單交易情形
						<% 		} else { %>
									<%=(String)dataObject.getValue("limit_type_name")%>
						<% 		} %>
								</div>
							</td>
						<% 	} %>
							
							<td>
								<div align=left>	
								<%=(String)dataObject.getValue("acc_name")%>		
								</div>
							</td>
							<td>
								<%//本月交易%>
								<a name="<%=tmpAcc_Code%>">
									<%monthAmt=Integer.valueOf(((dataObject.getValue("month_amt")) == null ? "0":(dataObject.getValue("month_amt"))).toString());%>
			       					<input type='text' name='month_amt' size=16 maxlength=16 onFocus='this.value=changeVal(this)' style='text-align: right;'
									<%//第一次申報時本年累計交易由使用者填寫，若月份為一月則本月交易複製至本年累計交易，其餘則自動加總至本年累計交易%>
									<% if( F01_APPLY_INI || EDIT_APPLY_INI){%>
										 onchange='this.value=Math.abs(changeStr(this))==0?"":changeStr(this);' 
									<% }else if( S_MONTH.equals("1") ){%>
										 onchange='this.value=changeStrA15Month01(this);' 
									<% }else{ %>
										 onchange='this.value=changeStrA15Add(this);' 
									<% } 	  %>
									<% if( act.equals("new") ){%>
										value=""
									<% }else{ %>
			       						value="<%=Utility.setCommaFormat(0==monthAmt?"":String.valueOf(monthAmt))%>" 
									<% }//end of amt ? 0 	%>
									>
								</a>
							</td>
							<td>
								<%//本年累計交易%>
								<a name="<%=tmpAcc_Code%>">
									<%yearAmt=Integer.valueOf(((dataObject.getValue("year_amt")) == null ? "0":(dataObject.getValue("year_amt"))).toString()); %>
									
			       					<input type='text' name='year_amt' size=16 maxlength=16 onFocus='this.value=changeVal(this)' onBlur='this.value=changeStr(this);' style='text-align: right;'   
									<%//第一次申報時或新增一月資料時，不帶入資料%>
									<% if( F01_APPLY_INI || (act.equals("new") && S_MONTH.equals("1")) ){ 	%>
			       						value=""
									<% } else if(act.equals("Edit") && !EDIT_APPLY_INI && !S_MONTH.equals("1")){	%>
			       						value="<%=Utility.setCommaFormat(yearAmt+monthAmt==0?"":String.valueOf(yearAmt+monthAmt))%>" 
									<% } else {	%>
			       						value="<%=Utility.setCommaFormat(yearAmt==0?"":String.valueOf(yearAmt))%>" 
									<% }		%>
									<%//第一次申報時或新增或修改一月資料時，開放使用者填寫%>
									<% if( F01_APPLY_INI || EDIT_APPLY_INI || S_MONTH.equals("1") ){ 	%>
			       						style='text-align: right;'
									<% } else {	%>
										readonly style='color: #808080; background-color: #ffffe6; text-align: right;'
									<% }		%>
									>
									<input type="hidden" name="origin" 
									<% if( F01_APPLY_INI || EDIT_APPLY_INI || S_MONTH.equals("1") ){ 	%>
			       						value=""
									<% } else {	%>
										value="<%=Utility.setCommaFormat(yearAmt==0?"":String.valueOf(yearAmt))%>"
									<% }		%>
									>
								</a>
							</td>
						  </tr>
				<%		
						}
					}
				%>
				<%/////////////////////////////////////////////產生畫面 END////////////////////////////////////////////%>
				
				

	          		    </Table>
	          		  </td>
                    </tr>
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table></td>
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
			 	<% //如果.有權限做update,且程科目代號不為空值時才顯示確定跟取消%> 
				<%if(act.equals("new")){%>     
				     <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ //add%>                   	        	                                   		       
                        <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert','A15','','','<%=bank_type%>');" ><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>                        
                     <%}%>   
         		<%}%>
         		<%if(act.equals("Edit")){%>
         		     <%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ //update%>                   	        	                                   		     
				        <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update','A15','<%=S_YEAR%>','<%=S_MONTH%>','<%=bank_type%>');" ><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>			            
				     <%}%>   
				     <%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ //delete%>                   	        	                                   		     
				        <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete','A15','<%=S_YEAR%>','<%=S_MONTH%>','<%=bank_type%>');" ><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>										               
				     <%}%>   
				<%}%>				
         		<%if(!act.equals("Query")){%>       
         		     <%if( (permission != null && permission.get("A") != null && permission.get("A").equals("Y"))                  	        	                                   		        
         		         ||(permission != null && permission.get("U") != null && permission.get("U").equals("Y"))                  	        	                                   		     
         		         ||(permission != null && permission.get("D") != null && permission.get("D").equals("Y"))){ //Add/Update/delete%>                   	        	                                   		     
                        <td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" ><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
                      <%}%>  
                <%}%>        
                        <td width="80"><div align="center"><a href="javascript:history.back();" ><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a></div></td>
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
          <td bgcolor="#FFFFFF"><table width="600" border="0" align="center" cellpadding="1" cellspacing="1">
              <tr> 
                <td><div align="center"><img src="images/line_1.gif" width="600" height="12"></div></td>
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
                          <li>本網頁提供新增<%=ListArray.getDLIdName("1", "A15")%>。</li>
                          <li>承辦員E_MAIL請勿填寫外部免費電子信箱以免無法收到更新結果通知。</li>
                          <li>確認資料無誤後，按<font color="#666666">【確定】</font>即將本網頁上的資料，於資料庫中新增。</li>
                          <li>按<font color="#666666">【確定】</font>或<font color="#666666">【修改】</font>時,會一併執行線上檢核,需耗時5-7秒。</li>
                          <li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>
                          <li>點選所列之<font color="#666666">【回上一頁】</font>則放棄資料， 回至前一畫面。</li>
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
              <!--tr> 
                <td><div align="center"><img src="images/line_1.gif" width="600" height="12"></div></td>
              </tr-->
            </table></td>
        </tr>        
      </table></td>
  </tr>
</table>
</form>
</body>

</html>
