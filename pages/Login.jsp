<%
// 93.12.23 add 寫入WTT06 Log記錄 by 2295
//          add 登入時寫入WTT01.login_mark="Y".並alert Msg
// 94.01.07 fix 登入時不寫到login_mark by 2295
// 94.01.07 fix 若wtt01的muser_name或muser_data的m_email為空白時,alert Msg by 2295
// 94.01.10 fix 若Muser_Data裡的e-mail為空白時,須強制輸入基本資料 by 2295
// 94.02.14 fix 不是superBOAF才需輸入使用者基本資料
// 94.03.11 add 若delete_mark="Y",不可登入系統 by 2295
// 94.09.05 add 密碼三個月換一次 by 2495
// 96.03.22 add 密碼套入加/解密元件 by 2295
// 98.12.28 顯示java vesrion 
// 99.12.06 fix sqlInjection by 2808
//101.05.04 fix 密碼錯誤3次,無法鎖定 by 2295
//107.08.17 fix 使用bean讀取DataObject by 2295
//108.03.12 add 增加圖型驗證碼 by 2295
//110.08.06 add 不管有無登入成功皆寫入WTT06 log by 2295
//110.09.08 cookie增加設定httpOnly by 2295
//111.04.13 調整batchno寫入DB錯誤 by 2295
//111.07.05 調整更改密碼不可與前3次相同 by 2295
//111.10.25 調整先檢核圖型驗證碼,再檢核帳號 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.dao.DAOFactory" %>
<%@ page import="com.tradevan.util.dao.RdbCommonDao" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.Date" %>

<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.io.*" %>
<%@ page import="com.tradevan.util.UpdateTimeOut" %>
<%@ page import="com.google.code.kaptcha.Constants.*" %>
<%@ page import="javax.servlet.http.Cookie" %>
                
<%
	RequestDispatcher rd = null;
	String actMsg = "";	
	String alertMsg = "";	
	String webURL_Y = "";	
	String webURL_N = "";	
	DataObject bean = null;//107.08.17 add


	String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");					
	String muser_password = ( request.getParameter("muser_password")==null ) ? "" : (String)request.getParameter("muser_password");					
	String ChangePwd = ( request.getParameter("ChangePwd")==null ) ? "" : (String)request.getParameter("ChangePwd");					
	String ConfirmPwd = ( request.getParameter("ConfirmPwd")==null ) ? "" : (String)request.getParameter("ConfirmPwd");						
	int LoginErrorTime = (session.getAttribute(muser_id) == null) ? 0 : Integer.parseInt((String)session.getAttribute(muser_id));              	
    boolean reLogin = false;
 	String login_mark="N";
    String m_email = "";    
    String muser_name = "";    
    String logining="";
	String PASSWORD_UPDATE_DATE="";  		  
	String PASSWORD_PRE="";       
	boolean haveErr = false;//111.07.05 add
	//98.12.28 顯示java vesrion    
	System.out.println(muser_id+":Login-java.version="+(System.getProperties()).getProperty("java.version"));     
	if(session.getAttribute("LoginErrorTime") == null){
	   System.out.println("LoginErrorTime == null");
	}//else{//107.08.17
	    //System.out.println("LoginErrorTime != null");//107.08.17 fix	    
	    //System.out.println((String)session.getAttribute(muser_id));//107.08.17 fix
	//}//107.08.17
	//RdbCommonDao RdbCommonDao = DAOFactory.getRdbCommonDao("");
	//RdbCommonDao.newQryConnection();
	//DBManager.newQryConnection();
	
	//108.03.08 增加圖型驗證碼
    //111.10.25 調整先檢核圖型驗證碼,再檢核帳號       
   	String randomcode = (String)session.getAttribute(com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY);
   	String input_randomcode = (String) request.getParameter("kaptchafield");   
   	System.out.println("input_randomcode: " + input_randomcode + " ? randomcode: " + randomcode + " ,is equals = "+(input_randomcode.equals(randomcode)?"true":"false"));
    
	if(input_randomcode == null || randomcode == null || (input_randomcode != null && randomcode != null && !input_randomcode.equals(randomcode))){
       actMsg = "驗證碼輸入錯誤";
       WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄
       haveErr = true;
       rd = application.getRequestDispatcher( LoginErrorPgName );   
       System.out.println("randomcode-fail");
    }else{
       		
	 System.out.println("randomcode-success");   
	
    List WTT01 = getWTT01(muser_id);   
    String firstlogin_mark = "";
    System.out.println("WTT01.size()="+WTT01.size()); 	      
    if(WTT01.size() == 0){    	       
       actMsg = "找不到此用戶帳號";               
       WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄                   
       rd = application.getRequestDispatcher( LoginErrorPgName +"?muser_id="+muser_id);                    
    }else {    
       bean = (DataObject)WTT01.get(0);//107.08.17 add  
       m_email = (String)bean.getValue("m_email");
       muser_name = (String)bean.getValue("muser_name");
       login_mark = (String)bean.getValue("login_mark");
       System.out.println("muser_password="+Utility.decode((String)bean.getValue("muser_password")));
       //96.03.22 add 將資料庫入的密碼解密       
       if(!(Utility.decode((String)bean.getValue("muser_password")).equals(muser_password))){
           actMsg = "用戶密碼錯誤";
           session.setAttribute(muser_id,String.valueOf(++LoginErrorTime));
           System.out.println("LoginErrorTime="+LoginErrorTime);
           if(LoginErrorTime >= 3){
              actMsg = PwdError3Times(muser_id,muser_id,(String)bean.getValue("muser_name"));
           }
           WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄
           rd = application.getRequestDispatcher( LoginErrorPgName );                    
       }else{    
            //108.03.08 增加圖型驗證碼//調整先檢核圖型驗證碼,再檢核用戶密碼
            /*
   			String randomcode = (String)session.getAttribute(com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY);
   			String input_randomcode = (String) request.getParameter("kaptchafield");   
   			System.out.println("input_randomcode: " + input_randomcode + " ? randomcode: " + randomcode + " ,is equals = "+(input_randomcode.equals(randomcode)?"true":"false"));
   
			if(input_randomcode != null && randomcode != null && !input_randomcode.equals(randomcode)){
       	   	   actMsg = "驗證碼輸入錯誤";
       	   	   WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄
       	   	   haveErr = true;
          	   rd = application.getRequestDispatcher( LoginErrorPgName );   
       		}
       		
            //94.03.11 add 若delete_mark="Y",不可登入系統=============================
            else */if(((String)bean.getValue("delete_mark")).equals("Y")){
               actMsg = "該帳號已被刪除,無法登入系統";
               WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄
               haveErr = true;
               rd = application.getRequestDispatcher( LoginErrorPgName );                    
            }//94.08.25 fix 帳號只有一人使用 by 2495
            else if(((String)bean.getValue("lock_mark")).equals("Y") ){
               actMsg = "該帳號已被鎖定,無法登入系統";
               WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄
               haveErr = true;
               rd = application.getRequestDispatcher( LoginErrorPgName );                    
            }
            else  if((!ChangePwd.equals("")) && (!ConfirmPwd.equals(""))){//更改密碼
            	   //111.07.05 更改密碼不可與前3次相同
       		   	   if((Utility.decode((String)bean.getValue("password_pre")).equals(ChangePwd)) || //目前密碼=前1次密碼
       		   	      (Utility.decode((String)bean.getValue("password_pre1")).equals(ChangePwd)))  //目前密碼=前2次密碼       		   	   
       		   	   {
       		   	   	 actMsg = "更改密碼不可與前3次相同";
       		   	   	 haveErr = true;
          		  	 rd = application.getRequestDispatcher( LoginErrorPgName );            
          		   }
          	}	
          	     
            //94.08.25 fix  同一時間只有一個使用者帳號 by 2495 
            /*         
            else if(((String)((DataObject)WTT01.get(0)).getValue("login_mark")).equals("Y") ){                          
               actMsg = "該帳號有人使用,無法登入系統";
               rd = application.getRequestDispatcher( LoginErrorPgName );                    
            }
            */          
            if(!haveErr){//111.07.05 add
       		   firstlogin_mark = (String)bean.getValue("firstlogin_mark");
       		   //96.03.22 add 將欲更改之密碼加密
       		   if((!ChangePwd.equals("")) && (!ConfirmPwd.equals(""))){//更改密碼       		   	   
            	    actMsg =UpdateDB(muser_id,(String)bean.getValue("muser_password"),(String)bean.getValue("password_pre"),(String)bean.getValue("password_pre1"),Utility.encode(ChangePwd),muser_id,(String)bean.getValue("muser_name"));                		             
            	    firstlogin_mark = "N";
            	    reLogin = true;        	  
       		   }
       		   if(firstlogin_mark.equals("Y")){
          		  actMsg = "此用戶為第一次登入系統,請更改用戶密碼";
          		  WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄
          		  rd = application.getRequestDispatcher( LoginErrorPgName );       		                     
       		   }else if(!reLogin){          		   	    		      
                 //94.9.5 密碼三個月換一次 by 2495	
                 long days = getPwdPeriod(muser_id);//96.03.22 add 取得密碼使用期間 by 2295
                 /*			    
				 List WTT01PWD = getPwdUPDATE(muser_id);   				       					
				 String PRE_PASSWORD_DATA = (((DataObject)WTT01PWD.get(0)).getValue("password_update_date")).toString();
       			 int PreYear = Integer.parseInt(PRE_PASSWORD_DATA.substring(0,4));
       			 int PreMonth = Integer.parseInt(PRE_PASSWORD_DATA.substring(4,6));
       			 int PreDay = Integer.parseInt(PRE_PASSWORD_DATA.substring(6,8));		  
				 Calendar today=new GregorianCalendar();						 		 		
				 Calendar day1=new GregorianCalendar(PreYear,PreMonth,PreDay);
				 long days=(today.getTimeInMillis()-day1.getTimeInMillis())/1000/60/60/24; 		     
                 */
                 if(days>60){
                	actMsg = "使用該密碼已三個月,請更換新密碼";
                	WriteToWTT06(request,muser_id);//110.08.06增加寫入登入紀錄
               		rd = application.getRequestDispatcher( LoginErrorPgName ); 
                 }else{     		      
       		        //93.12.23寫入WTT06 Log    
       		        String batch_no=WriteToDB(request,muser_id,(String)bean.getValue("muser_name"));//110.08.06 fix 
     		      	login_mark = (String)bean.getValue("login_mark");
    		      
       		        //94.08.29 fix 手動關閉視窗for session timeout問題 by 2495
       		        Cookie cmuser_id = new Cookie("cmuser_id",muser_id);    
       		        addCookie(response, cmuser_id, true);//110.09.08 cookie增加設定httpOnly 
       		        //response.addCookie(cmuser_id);//110.09.08       		      
       		        //94.06.08WTT01 = getWTT01(muser_id);    		      
       		        session.setAttribute("muser_id",muser_id);//使用者帳號
       		        session.setAttribute("muser_name",(String)bean.getValue("muser_name"));//使用者姓名
       		        session.setAttribute("muser_type",(String)bean.getValue("muser_type"));//使用者類別
       		        session.setAttribute("bank_type",(String)bean.getValue("bank_type"));//機構類別
       		        session.setAttribute("tbank_no",(String)bean.getValue("tbank_no"));//總機構代號
       		        session.setAttribute("muser_telno",(String)bean.getValue("m_telno"));//使用者電話
       		        session.setAttribute("muser_email",(String)bean.getValue("m_email"));//使用者e-mail
       		        if(batch_no.indexOf("batch_no") != -1){//110.08.05 add       		           
       		           session.setAttribute("batch_no",batch_no.substring(9,batch_no.length()));//登入的serial
       		    	}	
       		      	if(bean.getValue("bank_no") != null){//分支機構代號       		      
       		         session.setAttribute("bank_no",(String)bean.getValue("bank_no"));
       		      	}         		      
       		      	session.setAttribute("muser_i_o",(String)bean.getValue("muser_i_o"));//局內/局外
       		        //94.09.08 fix 採用sessionListen來解決session timeout問題 by 2495 
       		      	//UpdateTimeOut.SetMuser(muser_id);       		
 				 					 //設定使用者權限	      		      
       		      	actMsg = setPermission(request,muser_id,(String)bean.getValue("bank_type"));       		      
       		      
       		        //設定session連線時間 
       		        String timeout=Utility.getProperties("SESSION_TIMEOUT");
 					//timeout="30";        	  
            	  	try {
                		if (timeout != null && timeout.length()>0) {                    		
                    		session.setMaxInactiveInterval(Integer.parseInt(timeout));
                    		//session.setMaxInactiveInterval(100);
                		}
            	  	}catch (Exception e) {
               	     actMsg = actMsg + "session.setMaxInactiveInterval is fail !!";
            	 	}//end of catch 
            	 }//end of 密碼使用未超過3個月      		    
       		   }//end of 非第一次登入
       		}//end of lock_mark != Y   
       		//System.out.println("m_email="+m_email);  		        		
       		if(actMsg.equals("")){            		       
       		    if((muser_name == null || muser_name.equals("")) || (m_email == null || m_email.equals("")))
       		    {       		   
       		        //94.01.10 fix 若Muser_Data裡的e-mail為空白時,須強制輸入基本資料
       		        if(!muser_id.equals("superBOAF")){//94.02.04 fix 不是superBOAF才需輸入使用者基本資料
       		            alertMsg = "請至管理系統->使用者基本資料維護,更改使用者基本資料";       		   
          	            webURL_Y = "/pages/MainFrame.jsp";   
          	            session.setAttribute("UpdateMuser_Data","true");    		   
          	            rd = application.getRequestDispatcher( nextPgName );
          	        }else{
       		            rd = application.getRequestDispatcher( mainPgName ); 
       		        }    
       		    }else{
       		        rd = application.getRequestDispatcher( mainPgName );   
       		    }
       	   }else{
       		  rd = application.getRequestDispatcher( LoginErrorPgName );            
       	   }            	
       }//用戶密碼正確
    }//有此用戶帳號       
    }//圖型驗證碼正確  
    request.setAttribute("actMsg",actMsg);     
    request.setAttribute("alertMsg",alertMsg); 
    request.setAttribute("webURL_Y",webURL_Y);
    System.out.println(muser_id+":Login-end");
%>

<%
	try {
        //forward to next present jsp
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    } finally{
        //DBManager.closeQryConnection();
    }
%>


<%!
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";  
    private final static String nextPgName = "/pages/ActMsg.jsp";   
    private final static String mainPgName = "/pages/MainFrame.jsp";        
       
    //設定使用者權限
    private String setPermission(HttpServletRequest request,String muser_id,String bank_type){
        String errMsg = "";
        String sqlCmd = "";
        List permissionList = new LinkedList();     		      
        List permissionDetail = new LinkedList();     
        
        		      
        Properties pPermission = new Properties();                
        HttpSession session = request.getSession();
        DataObject bean = null;//107.08.17 add
        
    	try{    
    		List paramList =new ArrayList() ;
    		sqlCmd = " select WTT02.bank_type,cdshareno.CMUSE_NAME,cdshareno.INPUT_ORDER,"
     	   		   + " WTT03_2.program_id,WTT03_1.PROGRAM_NAME,WTT03_1.url_id,"
	   	   		   + " WTT04.P_ADD,WTT04.P_DELETE,WTT04.P_UPDATE,"
	   	   		   + " WTT04.P_QUERY,WTT04.P_PRINT,WTT04.P_UPLOAD,"
	   	   		   + " WTT04.P_DOWNLOAD,WTT04.P_LOCK,WTT04.P_OTHER"
		   		   + " from WTT02"
		   		   + " LEFT JOIN cdshareno on WTT02.BANK_TYPE = cdshareno.CMUSE_ID and cdshareno.CMUSE_DIV='016'"
		   		   + " LEFT JOIN WTT03_2  on WTT03_2.PROGRAM_TYPE = WTT02.BANK_TYPE "
		   		   + " LEFT JOIN WTT04 on WTT03_2.PROGRAM_ID=WTT04.PROGRAM_ID "
		   		   + " LEFT JOIN WTT03_1 on WTT03_1.PROGRAM_ID=WTT04.PROGRAM_ID"
		   		   + " where WTT02.muser_id=?"		   		   
		   		   + " and WTT03_2.WEB_TYPE='1'"
		   		   + " and WTT04.muser_id = WTT02.muser_id"
		   		   + " order by cdshareno.INPUT_ORDER,WTT04.program_id";
		   	paramList.add(muser_id) ;	   
    		//List dbData = DBManager.QueryDB(sqlCmd,"","Login.jsp");
    		List dbData =    DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");    
    		if(dbData != null){
       		   System.out.println("getPermission_dbData.size()="+dbData.size());       				 
       		   for(int i=0;i<dbData.size();i++){
       		       //System.out.print("program_id="+(String)((DataObject)dbData.get(i)).getValue("program_id")+"[");
       		       bean = (DataObject)dbData.get(i);//107.08.17 add
       			   if(((String)bean.getValue("p_add")).equals("Y")){
       			      pPermission.setProperty("A","Y");
       			      //System.out.print("A");       			   	   
       			      //permissionList.add("A"); 
       			   }
       			   if(((String)bean.getValue("p_delete")).equals("Y")){
       			       //permissionList.add("D"); 
       			       pPermission.setProperty("D","Y");       			   	   
       			       //System.out.print("D");       			   	   
       			   }
       			   if(((String)bean.getValue("p_update")).equals("Y")){
       			       //permissionList.add("U"); 
       			       pPermission.setProperty("U","Y");       			   	   
       			       //System.out.print("U");       			   	   
       			   }
       			   if(((String)bean.getValue("p_query")).equals("Y")){
       			       //permissionList.add("Q"); 
       			       pPermission.setProperty("Q","Y");       			   	   
       			       //System.out.print("Q");       			   	   
       			   }
       			   if(((String)bean.getValue("p_print")).equals("Y")){
       			       //permissionList.add("P"); 
       			       pPermission.setProperty("P","Y");    
       			       //System.out.print("P");       			   	      			   	   
       			   }
       			   if(((String)bean.getValue("p_upload")).equals("Y")){
       			       //permissionList.add("up"); 
       			       pPermission.setProperty("up","Y");       			   	   
       			       //System.out.print("up");       			   	   
       			   }
       			   if(((String)bean.getValue("p_download")).equals("Y")){
       			       //permissionList.add("dl"); 
       			       pPermission.setProperty("dl","Y");       			   	   
       			       //System.out.print("dl");       			   	   
       			   }
       			   if(((String)bean.getValue("p_lock")).equals("Y")){
       			       //permissionList.add("L"); 
       			       pPermission.setProperty("L","Y");       			   	   
       			       //System.out.print("L");       			   	   
       			   }
       			   //System.out.println("]");
       			   //session.setAttribute((String)((DataObject)dbData.get(i)).getValue("program_id"),permissionList);
       			   session.setAttribute((String)bean.getValue("program_id"),pPermission);
       			   pPermission = new Properties();     
       		   }//end of for
    	    }
    	}catch(Exception e){
    			System.out.println("Login.setPermission["+e+"]:"+e.getMessage());
				errMsg = errMsg + "設定權限失敗";									  
    	}		
    	return errMsg;  
    }
    //取得WTT01該使用者帳號資料
    private List getWTT01(String muser_id){
    		//查詢條件        		
    		List paramList = new ArrayList () ;
    		String sqlCmd = " select * from WTT01,MUSER_DATA "
    					  + " where WTT01.muser_id=? "      					    		    		  
    					  + " and WTT01.muser_id = MUSER_DATA.muser_id(+)"; 
    		paramList.add(muser_id) ;
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");            
            return dbData;
    } 
    //111.07.05 增加寫入前2次密碼
    private String UpdateDB(String muser_id,String muser_password,String password_pre,String password_pre1,String ChangePwd,String user_id,String user_name) throws Exception{    	
		StringBuffer sqlCmd = new StringBuffer();		
		String errMsg="";		
		
		try {
				//List updateDBSqlList = new LinkedList();
				List paramList = new ArrayList() ;
				//insert WTT01_LOG===================================================		    
				sqlCmd.append(" INSERT INTO WTT01_LOG " 
					   + " select muser_id,muser_name,muser_password,muser_i_o,bank_type,"
					   + " tbank_no,bank_no,subdep_id,add_user,add_name,add_date,firstlogin_mark,login_mark,"
					   + " lock_mark,delete_mark,muser_type,password_update_date,password_pre,"
					   + " user_id,user_name,update_date"
					   + ",?,?,sysdate,'U',password_pre1"
					   + " from WTT01"						  
					   + " WHERE muser_id=?");
				paramList.add(user_id) ;
				paramList.add(user_name) ;
				paramList.add(muser_id) ;
				//updateDBSqlList.add(sqlCmd);
				this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList) ;
				//=========================================================================
				sqlCmd.setLength(0) ;
				paramList.clear() ;
				if("".equals(password_pre)){					
					sqlCmd.append("UPDATE WTT01 SET "
				   	   + " muser_password=? "				    	   						   
					   + ",firstlogin_mark='N'" 
					   + ",password_update_date=sysdate" 		            		 						       
				       + ",password_pre=? " 				       
				       + ",user_id=? "
				       + ",user_name=? "
				       + ",update_date=sysdate" 		            		 						       
					   + " where muser_id=? ");				    	   
					paramList.add(ChangePwd) ;
					paramList.add(muser_password) ;
					paramList.add(user_id) ;
					paramList.add(user_name) ;
					paramList.add(muser_id) ;
		        	//updateDBSqlList.add(sqlCmd); 	
				}else {						   				    
					sqlCmd.append("UPDATE WTT01 SET "
				   	   + " muser_password=? "				    	   						   
					   + ",firstlogin_mark='N'" 
					   + ",password_update_date=sysdate" 		            		 						       
				       + ",password_pre=? " 				       
				       + ",password_pre1=? " 	
				       + ",user_id=? "
				       + ",user_name=? "
				       + ",update_date=sysdate" 		            		 						       
					   + " where muser_id=? ");				    	   
					paramList.add(ChangePwd) ;
					paramList.add(muser_password) ;
					paramList.add(password_pre) ;
					paramList.add(user_id) ;
					paramList.add(user_name) ;
					paramList.add(muser_id) ;
		        	//updateDBSqlList.add(sqlCmd); 	
		           
				}	
				//if(DBManager.updateDB(updateDBSqlList,"Login.jsp")){
				if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)) {
					errMsg = errMsg + "更改密碼成功,請重新登入系統";					
				}else{
				  	errMsg = errMsg + "更改密碼失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				}    	   		
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "更改密碼失敗";								
		}	

		return errMsg;
	} 
    
    private String PwdError3Times(String muser_id,String user_id,String user_name) throws Exception{    	
		StringBuffer sqlCmd = new StringBuffer();		
		String errMsg="";		
		
		try {
				//List updateDBSqlList = new LinkedList();
				List paramList = new ArrayList() ;
				//insert WTT01_LOG===================================================		    
				sqlCmd.append(" INSERT INTO WTT01_LOG " 
					   + " select muser_id,muser_name,muser_password,muser_i_o,bank_type,"
					   + " tbank_no,bank_no,subdep_id,add_user,add_name,add_date,firstlogin_mark,login_mark,"
					   + " lock_mark,delete_mark,muser_type,password_update_date,password_pre,"
					   + " user_id,user_name,update_date"
					   + ",?,?,sysdate,'U',password_pre1"
					   + " from WTT01"						  
					   + " WHERE muser_id=?" );
				paramList.add(user_id) ;
				paramList.add(user_name) ;
				paramList.add(muser_id);
				//updateDBSqlList.add(sqlCmd);	
				this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList) ;
				sqlCmd.setLength(0) ;
				paramList.clear() ;
				//=========================================================================
				sqlCmd.append("UPDATE WTT01 SET "
				   	   + " lock_mark='Y'"				    	   						   
					   + ",user_id=?"
				       + ",user_name=?"
				       + ",update_date=sysdate" 		            		 						       
					   + " where muser_id=?");				    	   
				paramList.add(user_id) ;
				paramList.add(user_name) ;
				paramList.add(muser_id) ;
		        //updateDBSqlList.add(sqlCmd); 		            	
	            		
				//if(DBManager.updateDB(updateDBSqlList,"Login.jsp"))
				if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)) {
					errMsg = errMsg + "密碼已錯誤3次,該帳號已被鎖定";					
				}else{
				  	errMsg = errMsg + "密碼已錯誤3次<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				}    	   		
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "密碼已錯誤3次";							
		}	

		return errMsg;
	} 
	
	private String WriteToDB(HttpServletRequest request,String muser_id,String muser_name) throws Exception{    	
		StringBuffer sqlCmd = new StringBuffer() ;		
		String errMsg="";		
		String ipAddr = request.getRemoteAddr();//111.04.28 fix		
		//String ipAddr = getIp(request);//111.04.28 fix	
		Date today = new Date();		
		//int	batch_no = today.hashCode();
		
		//System.out.println("Utility="+Utility.getDateFormat("yyyyMMddHHmmssSSS"));
		BigDecimal time = new BigDecimal(Utility.getDateFormat("yyyyMMddHHmmssSSS")); 
		//System.out.println("time="+time);
		int	batch_no = time.hashCode();
		//System.out.println("time.hash="+batch_no); 		

		try {
				//List updateDBSqlList = new LinkedList();
				List paramList =new ArrayList() ;
				sqlCmd.append("INSERT INTO WTT06 VALUES (?,sysdate"
				       + ",?" 					       
				       + ",'1'" 
				       + ",?,'Y',null)" );					       
				paramList.add(String.valueOf(batch_no)) ;//111.04.13調整寫入DB失敗
				paramList.add(muser_id) ;
				paramList.add(ipAddr) ;//111.04.28 fix
		        //updateDBSqlList.add(sqlCmd); 		            		            
	      		this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList) ;
	      		sqlCmd.setLength(0) ;
	      		paramList.clear() ;
	      //94.01.07 fix 不對login 做login_mark
				//94.08.25 fix 將/**/拿掉  by 2495 
				sqlCmd.append("UPDATE WTT01 SET "
				  	   + " login_mark='Y'"
				       + ",user_id=?"
				       + ",user_name=?"
				       + ",update_date=sysdate" 		            		 						       
					     + " where muser_id=?");				    	   
				paramList.add(muser_id) ;
				paramList.add(muser_name) ;
				paramList.add(muser_id) ;
		         //  updateDBSqlList.add(sqlCmd); 	            		            
					
				//if(DBManager.updateDB(updateDBSqlList,"Login.jsp")){
				if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)) {
					errMsg = "batch_no="+batch_no;//110.08.06 add
				}else{
				  	errMsg = errMsg + "寫入登入記錄失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				}    	   		
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "寫入登入記錄";						
		}	

		return errMsg;
	}
	
	//110.08.06 登入失敗時寫入登入紀錄WTT06 log
	private String WriteToWTT06(HttpServletRequest request,String muser_id) throws Exception{    	
		StringBuffer sqlCmd = new StringBuffer() ;		
		String errMsg="";		
		String RemortAddr = request.getRemoteAddr();		
		Date today = new Date();		
		//int	batch_no = today.hashCode();
		
		//System.out.println("Utility="+Utility.getDateFormat("yyyyMMddHHmmssSSS"));
		BigDecimal time = new BigDecimal(Utility.getDateFormat("yyyyMMddHHmmssSSS")); 
		//System.out.println("time="+time);
		int	batch_no = time.hashCode();
		//System.out.println("time.hash="+batch_no); 		

		try {
				//List updateDBSqlList = new LinkedList();
				List paramList =new ArrayList() ;
				sqlCmd.append("INSERT INTO WTT06 VALUES (?,sysdate"
				       + ",?" 					       
				       + ",'1'" 
				       + ",?,'N',null)" );					       
				paramList.add(String.valueOf(batch_no)) ;//111.04.13調整寫入DB失敗
				paramList.add(muser_id) ;
				paramList.add(RemortAddr) ;
	      		
				if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)) {					
				}else{
				  	errMsg = errMsg + "寫入登入記錄失敗<br>[DBManager.getErrMsg()]:<br>" + DBManager.getErrMsg();
				}    	   		
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "寫入登入記錄";						
		}	

		return errMsg;
	}
	
	
	//94.9.5 密碼三個月換一次 by 2495
	private List getPwdUPDATE(String muser_id){ 							   				   
		//取得使用者上次更換密碼時間===================================================
		 List paramList = new ArrayList() ;
  	     String sqlCmd = " select to_char(PASSWORD_UPDATE_DATE,'yyyymmdd') as PASSWORD_UPDATE_DATE   from WTT01 "
  		    		   + " where muser_id=? "; 					   
  		 paramList.add(muser_id) ;		  
		  List dbPwdUPDATE = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");                       
         return dbPwdUPDATE;    	   		
   }
   //96.03.22 add取得密碼使用期間 by 2295
   private long getPwdPeriod(String muser_id){
   	 long days=0;
   	 try{
   	     List WTT01PWD = getPwdUPDATE(muser_id);   				       					
		 String PRE_PASSWORD_DATA = (((DataObject)WTT01PWD.get(0)).getValue("password_update_date")).toString();
       	 int PreYear = Integer.parseInt(PRE_PASSWORD_DATA.substring(0,4));
       	 int PreMonth = Integer.parseInt(PRE_PASSWORD_DATA.substring(4,6));
       	 int PreDay = Integer.parseInt(PRE_PASSWORD_DATA.substring(6,8));		  
		 Calendar today=new GregorianCalendar();						 		 		
		 Calendar day1=new GregorianCalendar(PreYear,PreMonth,PreDay);
		 days=(today.getTimeInMillis()-day1.getTimeInMillis())/1000/60/60/24;
   	 }catch(Exception e){
   	    System.out.println("getPwdPeriod Error:"+e+e.getMessage());
   	 }	   	 
   	 return days;
   }	
	private boolean updDbUsesPreparedStatement(String sql ,List paramList) throws Exception{
		List updateDBList = new ArrayList();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();//欲執行updatedb的sql list
		List updateDBDataList = new ArrayList();//儲存參數的List
		
		updateDBDataList.add(paramList);
		updateDBSqlList.add(sql);
		updateDBSqlList.add(updateDBDataList);
		updateDBList.add(updateDBSqlList);
		return DBManager.updateDB_ps(updateDBList) ;
	}      
	//110.09.08 add
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
    
    public String getIp(HttpServletRequest request) throws Exception {    	   
		   String ip = request.getHeader("X-Forwarded-For");
		   if (ip != null) {
		       if (!ip.isEmpty() && !"unKnown".equalsIgnoreCase(ip)) {
					int index = ip.indexOf(",");
					if (index != -1) {
						return ip.substring(0, index);
					} else {
						return ip;
					}
			  }
			}
			ip = request.getHeader("X-Real-IP");
			if (ip != null) {
				if (!ip.isEmpty() && !"unKnown".equalsIgnoreCase(ip)) {
					return ip;
				}
			}
			ip = request.getHeader("Proxy-Client-IP");
			if (ip != null) {
				if (!ip.isEmpty() && !"unKnown".equalsIgnoreCase(ip)) {
					return ip;
				}
			}
			ip = request.getHeader("WL-Proxy-Client-IP");
			if (ip != null) {
				if (!ip.isEmpty() && !"unKnown".equalsIgnoreCase(ip)) {
					 return ip;
				}
			}
			ip = request.getRemoteAddr();
			return ip.equals("0:0:0:0:0:0:0:1") ? "127.0.0.1" : ip;
	}
    
    
	
%>    