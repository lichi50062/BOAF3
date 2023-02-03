<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/PopupCalendar.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0">
<form name='Listfrm' method=post action='#'>
<table width="780" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
	<tr> 
	<td>
		 <input type='text' name='begY' value="" size='3' maxlength='3'  >    
        <font color='#000000'>年
        <select id="hide3" name=begM>
        <option></option>
        <%
        	for (int j = 1; j <= 12; j++) {
        	if (j < 10){%>        	
        	<option value=0<%=j%>>0<%=j%></option>        		
        	<%}else{%>
        	<option value=<%=j%> ><%=j%></option>
        	<%}%>
        <%}%>
        </select>月
        <select id="hide4" name=begD>
        <option></option>
        <%
        	for (int j = 1; j < 32; j++) {
        	if (j < 10){%>        	
        	<option value=0<%=j%> >0<%=j%></option>        		
        	<%}else{%>
        	<option value=<%=j%> ><%=j%></option>
        	<%}%>
        <%}%>
        </select>日</font>
	<button name='button1' onClick="popupCal('Listfrm','begY,begM,begD','BTN_date_1',event,'','true')">
    			<img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'>
    			</button>
    </td>
    </tr>
</table>    			
</form>

</body>
</html>