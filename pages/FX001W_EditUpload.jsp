
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%		
   
	System.out.println("actMsg :" + request.getAttribute("actMsg"));

   	String nowtbankNo =  (String)session.getAttribute("nowtbank_no");
	System.out.println("nowtbankNo:" +nowtbankNo);
	//取得FX001W的權限====================================================================================================
	Properties permission = ( session.getAttribute("FX001W")==null ) ? new Properties() : (Properties)session.getAttribute("FX001W"); 
	if(permission == null){
       System.out.println("FX001W_EditAudit.permission == null");
    }else{
       System.out.println("FX001W_EditAudit.permission.size ="+permission.size());               
    }   	
   	//=======================================================================================================================	

%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FX001W_Upload.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title>總機構基本資料維護-檔案上傳 </title>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<% if(request.getAttribute("actMsg")!=null){
	%>alert("<%= request.getAttribute("actMsg")%>");<%
}
%>	
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
</script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='/pages/FX001W.jsp?act=upload' enctype="multipart/form-data"> 
<input type="hidden" name="act" value="">
<input type="hidden" name="bank_code" value="<%=nowtbankNo%>">
<table width="640" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		  <tr> 
   		   <td><img src="images/space_1.gif" width="12" height="12"></td>
  		  </tr>
          <td bgcolor="#FFFFFF">
		  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="170"><img src="images/banner_bg1.gif" width="170" height="17"></td>
                      <td width="250"><font color='#000000' size=4><b> 
                        <center style="white-space:nowrap;">總機構基本資料維護-檔案上傳 </center>
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
						<td width='15%' bgcolor='#D8EFEE' align='left'>檔案類型</td>
						<td width='85%' colspan=3 bgcolor='e7e7e7'>
						    <input type='radio' name='file_kind' value="M" checked="checked" >內部控制制度聲明書
						    <input type='radio' name='file_kind' value="O"  >其他 <input type="text" id ="file_type" name="file_type" size="30"><br>
						     
						</td>
        			    </tr>
        			    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#D8EFEE'>上傳檔案位置</td>						                       
						<td width='85%' colspan=3 bgcolor='e7e7e7'>
                            <input id ="file_name" type="file" name='file_name' required accept=".xls,.pdf,.xlsx,.doc,.docx" size="40"><span style='color: red;'>僅限word/excel/pdf</span> 
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
                      <%if(permission != null && permission.get("up") != null && permission.get("up").equals("Y")){//Query %>
				         <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'UP');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_uploadb.gif',1)"><img src="images/bt_upload.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
                         <td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>
                         <td width="66"> <div><a href="javascript:history.back();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image8" width="80" height="25" border="0"></a></div></td>
                      <%}%>
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
					      <li>本網頁提供上傳檔案資料</li>
                      	  <li>按上傳即可上傳該檔案</li>                         
                          <li>按<font color="#666666">【取消】</font>>即重新輸入資料</li>
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
</table>
</form>
</body>
</html>
