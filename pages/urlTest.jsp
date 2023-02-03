
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.Integer" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page contentType="text/html;charset=big5" %>
<html>
<head>
<title></title>
</head>
<body>

<%
   URL myURL=new URL("https://exam.feb.gov.tw/BOAF.aspx?t=exd05&datef=2019-11-12&datet=2019-11-12");//ด๚ธี
   Sysetm.out.println("https://exam.feb.gov.tw/BOAF.aspx?t=exd05&datef=2019-11-12&datet=2019-11-12");
   URLConnection raoURL;
   raoURL=myURL.openConnection();
   raoURL.setDoInput(true);
   raoURL.setDoOutput(true);
   raoURL.setUseCaches(false);
   BufferedReader infromURL=new BufferedReader(new InputStreamReader(raoURL.getInputStream()));        
   int datai=0;
   boolean haveRecords = false;
   boolean records_multi = false;
   while((raoInputString=infromURL.readLine())!=null){              
       if( datai > 0){
           System.out.println(raoInputString);                                            
       }
       datai++;
   }
   infromURL.close();
%>

</body>
</html>