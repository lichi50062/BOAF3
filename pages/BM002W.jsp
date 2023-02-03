<%
//106.05.24 creat 經營月報表每月申報資料 by George
//111.04.25 調整Integer轉換String,造成無法寫入DB by 2295
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
	RequestDispatcher rd = null;
	String actMsg = "";	
	String alertMsg = "";	
	String webURL = "";	
	
	boolean doProcess = false;		
	//取得session資料,取得成功時,才繼續往下執行===================================================
	if(!Utility.CheckPermission(request,program_id)){//session timeout		
      System.out.println("BM002W login timeout");   
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
	
	//登入者資訊==========================================================================================
	String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");		
	String lguser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");						
	//======================================================================================================================
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			
	String bank_no = ( request.getParameter("bank_no")==null ) ? "" : (String)request.getParameter("bank_no");//分支機構代碼			
	String tbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");//總機構代碼			
	String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			
	String seq_no = ( request.getParameter("seq_no")==null ) ? "" : (String)request.getParameter("seq_no");			
	
	String nowtbank_no = "";
	System.out.println("act="+act);
	System.out.println("bank_no="+bank_no);
	System.out.println("BM002W.tbank_no="+tbank_no);
	
    if(!Utility.CheckPermission(request,"BM002W")){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName ); 
    }else{ 
    	if(act.equals("List")){ //for list and Query   	    
    	    //調整 93.12.20 若有已點選的tbank_no,則以已點選的tbank_no為主============================================================
			tbank_no = ( session.getAttribute("tbank_no")==null ) ? "" : (String)session.getAttribute("tbank_no");				
			nowtbank_no =  ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");			
			if(!nowtbank_no.equals("")){
	   			session.setAttribute("nowtbank_no",nowtbank_no);//將已點選的tbank_no寫入session	   
			}   
			tbank_no = ( session.getAttribute("nowtbank_no")==null ) ? tbank_no : (String)session.getAttribute("nowtbank_no");			
			//=======================================================================================================================	
			if(bank_type.equals("")){
	   		   bank_type=(String)session.getAttribute("nowbank_type");
		    }
	
		    List bn01Data = getbn01Reset();
    	    request.setAttribute("bn01Data",bn01Data);
	
        	rd = application.getRequestDispatcher(ListPgName );
		} else if (act.equals("New")) {//新增頁面
			rd = application.getRequestDispatcher(EditPgName);
		} else if (act.equals("Insert")) {//新增動作
			actMsg = insertBn01Reset(request,tbank_no,bank_no,lguser_id,lguser_name);
			if(actMsg.endsWith("成功")){
				rd = application.getRequestDispatcher(nextPgName+"?goPages=BM002W.jsp&act=List&bank_type="+bank_type);
			}else{
				rd = application.getRequestDispatcher(nextPgName);
			}
		} else if (act.equals("Edit")) {//查看明細
			String key = ( request.getParameter("key")==null ) ? "" : (String)request.getParameter("key");
			request.setAttribute("Bn01Reset",getBn01Reset(key));
			rd = application.getRequestDispatcher(EditPgName);
		} else if (act.equals("Update")) {//修改
			actMsg = updateBn01Reset(request,tbank_no,bank_no,lguser_id,lguser_name);
			if(actMsg.endsWith("成功")){
				rd = application.getRequestDispatcher(nextPgName+"?goPages=BM002W.jsp&act=List&bank_type="+bank_type);
			}else{
				rd = application.getRequestDispatcher(nextPgName);
			}
		} else if (act.equals("Delete")) {//刪除    	        	    
			actMsg = deleteBn01Reset(request,tbank_no,bank_no,lguser_id,lguser_name);
			if(actMsg.endsWith("成功")){
				rd = application.getRequestDispatcher(nextPgName+"?goPages=BM002W.jsp&act=List&bank_type="+bank_type);
			}else{
				rd = application.getRequestDispatcher(nextPgName);
			}
		}
		request.setAttribute("actMsg", actMsg);
	}
%>

<%
	try {
        //forward to next present jsp
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    }
    }//end of doProcess
%>


<%!private final static String program_id = "BM002W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String EditPgName = "/pages/"+program_id+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+program_id+"_List.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
    private List getbn01Reset(){
    	StringBuilder sql = new StringBuilder();//SQL
    	List paramList = new ArrayList() ;//查詢條件
    	
    	sql.append(" select bn01_reset.bank_no,bank_name, ")//機構名稱
    			.append(" F_TRANSCHINESEDATE(setup_date) as setup_date, ")//核准設立日期
    			.append(" F_TRANSCHINESEDATE(start_date) as start_date, ")//開始營運日期
    			.append(" F_TRANSCHINESEDATE(bn01_reset.add_date) as add_date ")//加入存款保險日期
    			.append(" from ")
    			.append(" bn01_reset left join (select * from bn01 where m_year=100)bn01 on bn01_reset.bank_no=bn01.bank_no ")
    			.append(" order by 1 ");
    	
    	List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");            
        return dbData;
    }
    
    private List getBn01Reset(String key){
    	StringBuilder sql = new StringBuilder();//SQL
    	List paramList = new ArrayList() ;//查詢條件
    	
    	sql.append("select bank_no,to_char(setup_date,'yyyy/mm/dd') as setup_date, ")
    			.append(" to_char(start_date,'yyyy/mm/dd') as start_date, ")
    			.append(" to_char(add_date,'yyyy/mm/dd') as add_date, ")
    			.append(" output_order,to_char(update_date,'yyyy/mm/dd  hh:mm:ss') as update_date ")
    			.append(" from bn01_reset where bank_no=? ");
    	paramList.add(key);
		
    	List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"setup_date,start_date,add_date,update_date");            
        return dbData;
    }
    //111.04.25 調整Integer轉換String,造成無法寫入DB
    private String insertBn01Reset(HttpServletRequest request,String bank_no,String seq_no,String lguser_id,String lguser_name) throws Exception{
    	StringBuilder sqlCmd = new StringBuilder();
    	List paramList = new ArrayList() ;
		String errMsg="";
		String newTbankNo=( request.getParameter("newTbank_no")==null ) ? "" : (String)request.getParameter("newTbank_no");
		String setupDate=( request.getParameter("setupDate")==null ) ? "" : (String)request.getParameter("setupDate");
		String startDate=( request.getParameter("startDate")==null ) ? "" : (String)request.getParameter("startDate");
		String addDate=( request.getParameter("addDate")==null ) ? "" : (String)request.getParameter("addDate");
		
    	try {
				List data = getBn01Reset(newTbankNo);
				
				if (data.size() == 0){//無資料時,Insert
					sqlCmd.setLength(0) ;
			    	paramList.clear() ;
					
			    	sqlCmd.append(" INSERT INTO BN01_RESET ")
			    	.append(" (BANK_NO,SETUP_DATE,START_DATE,ADD_DATE,UPDATE_DATE) ")
			    	.append(" VALUES (?,to_date(?,'YYYYMMDD'),to_date(?,'YYYYMMDD'),to_date(?,'YYYYMMDD'),SYSDATE )");
			    	paramList.add(newTbankNo) ;
			    	paramList.add(String.valueOf(Integer.parseInt(setupDate)+19110000)) ;//111.04.25 調整Integer轉換String,造成無法寫入DB
			    	paramList.add(String.valueOf(Integer.parseInt(startDate)+19110000)) ;
			    	paramList.add(String.valueOf(Integer.parseInt(addDate)+19110000)) ;
					
					if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)){	   				      		 
						errMsg += "相關資料寫入資料庫成功";					
					}else{
				 	    errMsg += "相關資料寫入資料庫失敗";
					}
				}else{
					errMsg += "已有該機構資料無法新增";
				}
			}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗";							
			}	

		return errMsg;
    }
	//111.04.25 調整Integer轉換String,造成無法寫入DB
    private String updateBn01Reset(HttpServletRequest request,String bank_no,String seq_no,String lguser_id,String lguser_name) throws Exception{
    	StringBuilder sqlCmd = new StringBuilder();
		List paramList = new ArrayList() ;
		String errMsg="";
		String newTbankNo=( request.getParameter("newTbank_no")==null ) ? "" : (String)request.getParameter("newTbank_no");
		String setupDate=( request.getParameter("setupDate")==null ) ? "" : (String)request.getParameter("setupDate");
		String startDate=( request.getParameter("startDate")==null ) ? "" : (String)request.getParameter("startDate");
		String addDate=( request.getParameter("addDate")==null ) ? "" : (String)request.getParameter("addDate");
		
    	try {
				List data = getBn01Reset(newTbankNo);
				
				if (data.size() > 0){//有資料時,update
					sqlCmd.setLength(0) ;
			    	paramList.clear() ;
			    	
			    	sqlCmd.append(" UPDATE BN01_RESET ")
			    	.append(" SET SETUP_DATE=to_date(?,'YYYYMMDD'),START_DATE=to_date(?,'YYYYMMDD'),ADD_DATE=to_date(?,'YYYYMMDD'),UPDATE_DATE=SYSDATE ")
			    	.append(" WHERE  BANK_NO=? ");
			    	
			    	paramList.add(String.valueOf(Integer.parseInt(setupDate)+19110000)) ;//111.04.25 調整Integer轉換String,造成無法寫入DB
			    	paramList.add(String.valueOf(Integer.parseInt(startDate)+19110000)) ;
			    	paramList.add(String.valueOf(Integer.parseInt(addDate)+19110000)) ;
			    	paramList.add(newTbankNo) ;
			    	
					if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)){	   				      		 
						errMsg += "相關資料修改資料庫成功";					
					}else{
				 	    errMsg += "相關資料修改資料庫失敗";
					}
				}else{
					errMsg += "無該機構資料可提供修改";
				}
			}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料修改資料庫失敗";							
			}	

		return errMsg;
    }
    
	private String deleteBn01Reset(HttpServletRequest request, String bank_no, String seq_no, String lguser_id, String lguser_name) throws Exception {
		StringBuilder sqlCmd = new StringBuilder();
		List paramList = new ArrayList() ;
		String errMsg="";
		String newTbankNo=( request.getParameter("newTbank_no")==null ) ? "" : (String)request.getParameter("newTbank_no");

		try {
				List data = getBn01Reset(newTbankNo);
			
				if (data.size() > 0){//有資料時,delete
					sqlCmd.setLength(0) ;
			    	
					sqlCmd.append(" delete BN01_RESET where BANK_NO=? ");
					paramList.add(newTbankNo) ;
					            		            		
					if (this.updDbUsesPreparedStatement(sqlCmd.toString(), paramList)) {
						errMsg = errMsg + "相關資料刪除成功";
					} else {
						errMsg = errMsg + "相關資料刪除失敗";
					}
				}else{
					errMsg += "無該機構資料可提供刪除";
				}
		} catch (Exception e) {
			System.out.println(e + ":" + e.getMessage());
			errMsg = errMsg + "相關資料刪除失敗";
		}

		return errMsg;
	}

	private boolean updDbUsesPreparedStatement(String sql, List paramList) throws Exception {
		List updateDBList = new ArrayList();//0:sql 1:data
		List updateDBSqlList = new ArrayList();//欲執行updatedb的sql list
		List updateDBDataList = new ArrayList();//儲存參數的List

		updateDBDataList.add(paramList);
		updateDBSqlList.add(sql);
		updateDBSqlList.add(updateDBDataList);
		updateDBList.add(updateDBSqlList);
		return DBManager.updateDB_ps(updateDBList);
	}%>    