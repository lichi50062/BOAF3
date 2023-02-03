<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>

<%!
int FindCookie(Cookie cookies[],String cookie_name)
{
	for(int i=0;i<cookies.length;i++)
	{
		if(cookies[i].getName().equals(cookie_name))
		{
			return i;
		}
	}
	
	return -1;
}

//110.09.09 add
public static void addCookie(HttpServletResponse response, Cookie cookie, boolean isHttpOnly) {
        String name = cookie.getName();//Cookie名稱
        String value = cookie.getValue();//Cookie值
        int maxAge = cookie.getMaxAge();//最大生存時間(毫秒,0代表刪除,-1代表與瀏覽器會話一致)
        String path = cookie.getPath();//路徑
        String domain = cookie.getDomain();//域
        boolean isSecure = cookie.getSecure();//是否為安全協議資訊 

        StringBuilder buffer = new StringBuilder();

        buffer.append(name).append("=").append(value).append(";");

        if (maxAge == 0) {
            buffer.append("Expires=Thu Jan 01 08:00:00 CST 1970;");
        } else if (maxAge > 0) {
            buffer.append("Max-Age=").append(maxAge).append(";");
        }

        if (domain != null) {
            buffer.append("domain=").append(domain).append(";");
        }

        if (path != null) {
            buffer.append("path=").append(path).append(";");
        }

        if (isSecure) {
            buffer.append("secure;");
        }

        if (isHttpOnly) {
            buffer.append("HTTPOnly;");
        }

        response.addHeader("Set-Cookie", buffer.toString());
}
%>

<% 			
    System.out.println("BrowserLoginMark.jsp begin");
    String sqlCmd="";
	List updateDBSqlList = new LinkedList();								   				   
 	
 	Cookie cookies[] = request.getCookies();
 	int index = FindCookie(cookies,"cmuser_id");  
	String muser_id = cookies[index].getValue();
  
	  
  if(!muser_id.equals(""))
  {
         sqlCmd = "UPDATE WTT01 SET "
		        + " login_mark='N'"
		        + ",update_date=sysdate" 		            		 						       
		        + " where muser_id='"+muser_id+"'";				    	   
					   
		        updateDBSqlList.add(sqlCmd); 		            		            	            	            		
		     		DBManager.updateDB(updateDBSqlList);					 						 
			      System.out.println("Session is exiting!!");	
			      session.invalidate();
	} 
	else
	{
			 		System.out.println("NO DATA!!");	
	}	
	
	 cookies[index].setMaxAge(0);
	 
	 addCookie(response, cookies[index], true);//110.09.09 cookie增加設定httpOnly 
	 
	 //response.addCookie(cookies[index]);//110.11.02
	 
	 System.out.println("BrowserLoginMark.jsp end");
		
%>