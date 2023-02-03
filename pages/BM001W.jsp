<%
// 106.05.24 creat 經營月報表每月申報資料 by George
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
      System.out.println("BM001W login timeout");   
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
	System.out.println("BM001W.tbank_no="+tbank_no);
	
    if(!Utility.CheckPermission(request,"BM001W")){//無權限時,導向到LoginError.jsp
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
	
		    List rptBusinessData = getRptBusiness();
    	    request.setAttribute("rptBusinessData",rptBusinessData);
	
        	rd = application.getRequestDispatcher( ListPgName );
		} else if (act.equals("new")) {//新增頁面
			rd = application.getRequestDispatcher(EditPgName);
		} else if (act.equals("Insert")) {//新增動作
			actMsg = insertRptBusiness(request,tbank_no,bank_no,lguser_id,lguser_name);
			if(actMsg.endsWith("成功")){
				rd = application.getRequestDispatcher(nextPgName+"?goPages=BM001W.jsp&act=List&bank_type="+bank_type);
			}else{
				rd = application.getRequestDispatcher(nextPgName);
			}
		} else if (act.equals("Edit")) {//查看明細
			String r_date = ( request.getParameter("r_date")==null ) ? "" : (String)request.getParameter("r_date");
			List rptBusiness = getRptBusiness(r_date);
			request.setAttribute("rptBusiness",rptBusiness);
			rd = application.getRequestDispatcher(EditPgName);
		} else if (act.equals("Update")) {//修改
			actMsg = updateRptBusiness(request,tbank_no,bank_no,lguser_id,lguser_name);
			if(actMsg.endsWith("成功")){
				rd = application.getRequestDispatcher(nextPgName+"?goPages=BM001W.jsp&act=List&bank_type="+bank_type);
			}else{
				rd = application.getRequestDispatcher(nextPgName);
			}
		} else if (act.equals("Delete")) {//刪除    	        	    
			actMsg = deleteRptBusiness(request,tbank_no,bank_no,lguser_id,lguser_name);
			if(actMsg.endsWith("成功")){
				rd = application.getRequestDispatcher(nextPgName+"?goPages=BM001W.jsp&act=List&bank_type="+bank_type);
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


<%!
	private final static String program_id = "BM001W";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String EditPgName = "/pages/"+program_id+"_Edit.jsp";
    private final static String ListPgName = "/pages/"+program_id+"_List.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
    private List getRptBusiness(){
    	StringBuilder sql = new StringBuilder();//SQL
    	List paramList = new ArrayList() ;//查詢條件
    	
    	sql.append("select m_year,m_month,")
    		.append("m_year || '/' || substr(100 + m_month, 2) as inputdate,")//基準日
    		.append("(to_number(to_char(update_date,'yyyy')) - 1911)||to_char(update_date,'/MM/DD') as update_date1, ")//異動日期
    		.append("to_char(update_date,'hh:mm:ss') as update_date2 ")//異動日期
    		.append("from rpt_business ")
    		.append("order by m_year desc ,m_month desc");
		
    	List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");            
        return dbData;
    }
    
    private List getRptBusiness(String r_date){
    	StringBuilder sql = new StringBuilder();//SQL
    	List paramList = new ArrayList() ;//查詢條件
    	
    	String tempdate [] = r_date.split("/");
    	
    	sql.append("select * from rpt_business where m_year=? and m_month=? ");
    	paramList.add(tempdate[0]);
    	paramList.add(tempdate[1]);
		
    	List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"m_year,m_month,loan_amt,loan_over_amt,loan_cnt,bank_cnt,tbank_cnt_6,tbank_cnt_7,bank_cnt_6,bank_cnt_7,agri_build_amt,agri_loan_amt");            
        return dbData;
    }
    
    private String insertRptBusiness(HttpServletRequest request,String bank_no,String seq_no,String lguser_id,String lguser_name) throws Exception{
    	StringBuilder sqlCmd = new StringBuilder();		
		String errMsg="";
		String m_year=( request.getParameter("m_year")==null ) ? "" : (String)request.getParameter("m_year");
		String m_month=( request.getParameter("m_month")==null ) ? "" : (String)request.getParameter("m_month");
		String loan_amt=( request.getParameter("loan_amt")==null ) ? "" : (String)request.getParameter("loan_amt");
		String loan_over_amt=( request.getParameter("loan_over_amt")==null ) ? "" : (String)request.getParameter("loan_over_amt");
		String loan_cnt=( request.getParameter("loan_cnt")==null ) ? "" : (String)request.getParameter("loan_cnt");
		String bank_cnt=( request.getParameter("bank_cnt")==null ) ? "" : (String)request.getParameter("bank_cnt");
		String tbank_cnt_6=( request.getParameter("tbank_cnt_6")==null ) ? "" : (String)request.getParameter("tbank_cnt_6");
		String tbank_cnt_7=( request.getParameter("tbank_cnt_7")==null ) ? "" : (String)request.getParameter("tbank_cnt_7");
		String bank_cnt_6=( request.getParameter("bank_cnt_6")==null ) ? "" : (String)request.getParameter("bank_cnt_6");
		String bank_cnt_7=( request.getParameter("bank_cnt_7")==null ) ? "" : (String)request.getParameter("bank_cnt_7");
		String agri_build_amt=( request.getParameter("agri_build_amt")==null ) ? "" : (String)request.getParameter("agri_build_amt");
		String agri_loan_amt=( request.getParameter("agri_loan_amt")==null ) ? "" : (String)request.getParameter("agri_loan_amt");
		
    	try {
				List paramList = new ArrayList() ;
		    	String yy = Integer.parseInt(Utility.getYear()) > 99 ? "100" :"99" ;
		    	
		   		List data = getRptBusiness(m_year+"/"+m_month);
				
				if (data.size() == 0){//無資料時,Insert
					sqlCmd.setLength(0) ;
			    	paramList.clear() ;
					
			    	sqlCmd.append(" INSERT INTO RPT_BUSINESS ( ")
			    	.append(" M_YEAR,M_MONTH,LOAN_AMT,LOAN_OVER_AMT,LOAN_CNT,BANK_CNT,TBANK_CNT_6,TBANK_CNT_7")
			    	.append(",BANK_CNT_6,BANK_CNT_7,AGRI_BUILD_AMT,AGRI_LOAN_AMT,UPDATE_DATE ) VALUES (")
			    	.append(" ?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE )");
			    	paramList.add(m_year) ;
			    	paramList.add(m_month) ;
			    	paramList.add(Utility.setNoCommaFormat(loan_amt)) ;
			    	paramList.add(Utility.setNoCommaFormat(loan_over_amt)) ;
			    	paramList.add(Utility.setNoCommaFormat(loan_cnt)) ;
			    	paramList.add(Utility.setNoCommaFormat(bank_cnt)) ;
			    	paramList.add(Utility.setNoCommaFormat(tbank_cnt_6)) ;
			    	paramList.add(Utility.setNoCommaFormat(tbank_cnt_7)) ;
			    	paramList.add(Utility.setNoCommaFormat(bank_cnt_6)) ;
			    	paramList.add(Utility.setNoCommaFormat(bank_cnt_7)) ;
			    	paramList.add(Utility.setNoCommaFormat(agri_build_amt)) ;
			    	paramList.add(Utility.setNoCommaFormat(agri_loan_amt)) ;
					
					if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)){	   				      		 
						errMsg += "相關資料寫入資料庫成功";					
					}else{
				 	    errMsg += "相關資料寫入資料庫失敗";
					}
				}else{
					errMsg += "已有該申報年月資料無法新增";
				}
			}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料寫入資料庫失敗";							
			}	

		return errMsg;
    }
	
    private String updateRptBusiness(HttpServletRequest request,String bank_no,String seq_no,String lguser_id,String lguser_name) throws Exception{
    	StringBuilder sqlCmd = new StringBuilder();		
		String errMsg="";
		String m_year=( request.getParameter("m_year")==null ) ? "" : (String)request.getParameter("m_year");
		String m_month=( request.getParameter("m_month")==null ) ? "" : (String)request.getParameter("m_month");
		String loan_amt=( request.getParameter("loan_amt")==null ) ? "" : (String)request.getParameter("loan_amt");
		String loan_over_amt=( request.getParameter("loan_over_amt")==null ) ? "" : (String)request.getParameter("loan_over_amt");
		String loan_cnt=( request.getParameter("loan_cnt")==null ) ? "" : (String)request.getParameter("loan_cnt");
		String bank_cnt=( request.getParameter("bank_cnt")==null ) ? "" : (String)request.getParameter("bank_cnt");
		String tbank_cnt_6=( request.getParameter("tbank_cnt_6")==null ) ? "" : (String)request.getParameter("tbank_cnt_6");
		String tbank_cnt_7=( request.getParameter("tbank_cnt_7")==null ) ? "" : (String)request.getParameter("tbank_cnt_7");
		String bank_cnt_6=( request.getParameter("bank_cnt_6")==null ) ? "" : (String)request.getParameter("bank_cnt_6");
		String bank_cnt_7=( request.getParameter("bank_cnt_7")==null ) ? "" : (String)request.getParameter("bank_cnt_7");
		String agri_build_amt=( request.getParameter("agri_build_amt")==null ) ? "" : (String)request.getParameter("agri_build_amt");
		String agri_loan_amt=( request.getParameter("agri_loan_amt")==null ) ? "" : (String)request.getParameter("agri_loan_amt");
		
    	try {
				List paramList = new ArrayList() ;
		    	String yy = Integer.parseInt(Utility.getYear()) > 99 ? "100" :"99" ;
		    	List data = getRptBusiness(m_year+"/"+m_month);
				
				if (data.size() > 0){//有資料時,update
					sqlCmd.setLength(0) ;
			    	paramList.clear() ;
					
			    	sqlCmd.append(" UPDATE RPT_BUSINESS ")
			    	.append(" SET LOAN_AMT=?,LOAN_OVER_AMT=?,LOAN_CNT=?,BANK_CNT=?,TBANK_CNT_6=?,TBANK_CNT_7=?")
			    	.append(",BANK_CNT_6=?,BANK_CNT_7=?,AGRI_BUILD_AMT=?,AGRI_LOAN_AMT=?,UPDATE_DATE=SYSDATE WHERE ")
			    	.append(" M_YEAR=? and M_MONTH=? ");
			    	
			    	paramList.add(Utility.setNoCommaFormat(loan_amt)) ;
			    	paramList.add(Utility.setNoCommaFormat(loan_over_amt)) ;
			    	paramList.add(Utility.setNoCommaFormat(loan_cnt)) ;
			    	paramList.add(Utility.setNoCommaFormat(bank_cnt)) ;
			    	paramList.add(Utility.setNoCommaFormat(tbank_cnt_6)) ;
			    	paramList.add(Utility.setNoCommaFormat(tbank_cnt_7)) ;
			    	paramList.add(Utility.setNoCommaFormat(bank_cnt_6)) ;
			    	paramList.add(Utility.setNoCommaFormat(bank_cnt_7)) ;
			    	paramList.add(Utility.setNoCommaFormat(agri_build_amt)) ;
			    	paramList.add(Utility.setNoCommaFormat(agri_loan_amt)) ;
			    	paramList.add(m_year) ;
			    	paramList.add(m_month) ;
			    	
					if(this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList)){	   				      		 
						errMsg += "相關資料修改資料庫成功";
						insertRptBusinessLog(data,lguser_id,lguser_name,"U");
					}else{
				 	    errMsg += "相關資料修改資料庫失敗";
					}
				}else{
					errMsg += "無該申報年月資料可提供修改";
				}
			}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "相關資料修改資料庫失敗";							
			}	

		return errMsg;
    }
    
	private String deleteRptBusiness(HttpServletRequest request, String bank_no, String seq_no, String lguser_id, String lguser_name) throws Exception {
		StringBuilder sqlCmd = new StringBuilder();		
		String errMsg="";
		String m_year=( request.getParameter("m_year")==null ) ? "" : (String)request.getParameter("m_year");
		String m_month=( request.getParameter("m_month")==null ) ? "" : (String)request.getParameter("m_month");

		try {
			List paramList = new ArrayList() ;
	    	
			List data = getRptBusiness(m_year+"/"+m_month);
			
			if (data.size() > 0){//有資料時,delete
				sqlCmd.setLength(0) ;
				paramList.clear();
		    	
				sqlCmd.append(" delete rpt_business where m_year=? and m_month= ?");
				paramList.add(m_year);
				paramList.add(m_month);
				            		            		
				if (this.updDbUsesPreparedStatement(sqlCmd.toString(), paramList)) {
					errMsg = errMsg + "相關資料刪除成功";
					insertRptBusinessLog(data,lguser_id,lguser_name,"D");
				} else {
					errMsg = errMsg + "相關資料刪除失敗";
				}
			}else{
				errMsg += "無該申報年月資料可提供刪除";
			}
		} catch (Exception e) {
			System.out.println(e + ":" + e.getMessage());
			errMsg = errMsg + "相關資料刪除失敗";
		}

		return errMsg;
	}
	
	private void insertRptBusinessLog(List formdata,String lguser_id,String lguser_name,String act_id) throws Exception{
    	StringBuilder sqlCmd = new StringBuilder();		
		List paramList = new ArrayList() ;
		
		DataObject bean = (DataObject) formdata.get(0);
		
		String m_year=(bean.getValue("m_year") == null) ? "0" : String.valueOf(bean.getValue("m_year"));
		String m_month=(bean.getValue("m_month") == null) ? "0" : String.valueOf(bean.getValue("m_month"));
		String loan_amt=(bean.getValue("loan_amt") == null) ? "0" : String.valueOf(bean.getValue("loan_amt"));
		String loan_over_amt=(bean.getValue("loan_over_amt") == null) ? "0" : String.valueOf(bean.getValue("loan_over_amt"));
		String loan_cnt=(bean.getValue("loan_cnt") == null) ? "0" : String.valueOf(bean.getValue("loan_cnt"));
		String bank_cnt=(bean.getValue("bank_cnt") == null) ? "0" : String.valueOf(bean.getValue("bank_cnt"));
		String tbank_cnt_6=(bean.getValue("tbank_cnt_6") == null) ? "0" : String.valueOf(bean.getValue("tbank_cnt_6"));
		String tbank_cnt_7=(bean.getValue("tbank_cnt_7") == null) ? "0" : String.valueOf(bean.getValue("tbank_cnt_7"));
		String bank_cnt_6=(bean.getValue("bank_cnt_6") == null) ? "0" : String.valueOf(bean.getValue("bank_cnt_6"));
		String bank_cnt_7=(bean.getValue("bank_cnt_7") == null) ? "0" : String.valueOf(bean.getValue("bank_cnt_7"));
		String agri_build_amt=(bean.getValue("agri_build_amt") == null) ? "0" : String.valueOf(bean.getValue("agri_build_amt"));
		String agri_loan_amt=(bean.getValue("agri_loan_amt") == null) ? "0" : String.valueOf(bean.getValue("agri_loan_amt"));
		
		sqlCmd.setLength(0) ;
    	paramList.clear() ;
		
    	sqlCmd.append(" INSERT INTO RPT_BUSINESS_LOG ( ")
    	.append(" M_YEAR,M_MONTH,LOAN_AMT,LOAN_OVER_AMT,LOAN_CNT,BANK_CNT,TBANK_CNT_6,TBANK_CNT_7, ")
    	.append("BANK_CNT_6,BANK_CNT_7,AGRI_BUILD_AMT,AGRI_LOAN_AMT,USER_ID_C,USER_NAME_C,UPDATE_DATE_C,UPDATE_TYPE_C ")
    	.append("  ) VALUES ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,? )");
    	paramList.add(m_year) ;
    	paramList.add(m_month) ;
    	paramList.add(Utility.setNoCommaFormat(loan_amt)) ;
    	paramList.add(Utility.setNoCommaFormat(loan_over_amt)) ;
    	paramList.add(Utility.setNoCommaFormat(loan_cnt)) ;
    	paramList.add(Utility.setNoCommaFormat(bank_cnt)) ;
    	paramList.add(Utility.setNoCommaFormat(tbank_cnt_6)) ;
    	paramList.add(Utility.setNoCommaFormat(tbank_cnt_7)) ;
    	paramList.add(Utility.setNoCommaFormat(bank_cnt_6)) ;
    	paramList.add(Utility.setNoCommaFormat(bank_cnt_7)) ;
    	paramList.add(Utility.setNoCommaFormat(agri_build_amt)) ;
    	paramList.add(Utility.setNoCommaFormat(agri_loan_amt)) ;
    	
    	paramList.add(Utility.setNoCommaFormat(lguser_id)) ;
    	paramList.add(Utility.setNoCommaFormat(lguser_name)) ;
    	paramList.add(Utility.setNoCommaFormat(act_id)) ;
		
		try{
			this.updDbUsesPreparedStatement(sqlCmd.toString(),paramList);
		} catch (Exception e) {
			System.out.println(e + ":" + e.getMessage());
		}
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