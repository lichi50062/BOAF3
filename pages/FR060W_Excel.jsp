<%
//101.07.30 created by 2968
//108.05.14 add 報表格式挑選 by 2295		
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   String act = ( request.getParameter("act")==null ) ? "view" : (String)request.getParameter("act");
   String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
   String bank_code = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");
   String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle");//108.05.14
   System.out.println("FR060W_Excel.act="+act+":bank_type="+bank_type+":bank_code="+bank_code+":S_YEAR="+S_YEAR+":S_MONTH="+S_MONTH);
   
   String filename="M201_保證案件月報表.xls";
       
   
   RequestDispatcher rd = null;
   boolean doProcess = false;
   String actMsg = "";
   /*
   //取得session資料,取得成功時,才繼續往下執行===================================================
   if(session.getAttribute("muser_id") == null){//session timeout
      System.out.println("FR001WB login timeout");
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );
	   try{
          rd.forward(request,response);
       }catch(Exception e){
          System.out.println("forward Error:"+e+e.getMessage());
       }
   }else{
      doProcess = true;
   }
   if(doProcess){//若muser_id資料時,表示登入成功====================================================================
   		if(!Utility.CheckPermission(request,"FR060W")){//無權限時,導向到LoginError.jsp
        	rd = application.getRequestDispatcher( LoginErrorPgName );
    	}else{
	    	//set next jsp
	    	if(act.equals("Qry")){
	    	   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);
	    	}else if(act.equals("view")){
      		   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      		   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
      			response.setHeader("Content-disposition","inline; filename=view.xls");
   			}else if (act.equals("download")){
   			*/
      			response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.14調整顯示的副檔名       
   			//}
   			if(act.equals("view") || act.equals("download")){
   				try{
	    			actMsg =RptFR060W.createRpt(S_YEAR,S_MONTH,"1000",bank_code);
	    			System.out.println("createRpt="+actMsg);
	    			System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    			
	    			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.14非xls檔須執行轉換	                
	  			        rptTrans rptTrans = new rptTrans();	  			
	  			        filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			        System.out.println("newfilename="+filename);	  			   
                    };		    								 
	   	    			
					FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
					ServletOutputStream out1 = response.getOutputStream();
					byte[] line = new byte[8196];
					int getBytes=0;
					while( ((getBytes=fin.read(line,0,8196)))!=-1 ){
						out1.write(line,0,getBytes);
						out1.flush();
	    			}

					fin.close();
					out1.close();

				}catch(Exception e){
	   				System.out.println(e.getMessage());
				}
   			}
   		//}
   		request.setAttribute("actMsg",actMsg);
		try {
        	//forward to next present jsp
        	rd.forward(request, response);
    	} catch (NullPointerException npe) {
    	}
    //}//end of doProcess
%>


<%!
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String QryPgName = "/pages/FR060W_Qry.jsp";
    private final static String RptCreatePgName = "/pages/FR060W_Excel.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";    
%>
