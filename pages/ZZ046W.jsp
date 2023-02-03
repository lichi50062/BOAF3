<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.StringTokenizer" %>

<%
	RequestDispatcher rd = null;
	String alertMsg = "";	
	String actMsg="";
	String webURL = "";	
	boolean doProcess = false;
	
	//取得session資料,取得成功時,才繼續往下執行===================================================
	String permission = ( session.getAttribute("muser_id")==null ) ? null : (String)session.getAttribute("muser_id");				                
    if(permission == null){//session timeout
       System.out.println("ZZ046W login timeout");   
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
	   try{
          rd.forward(request,response);
       }catch(Exception e){
          System.out.println("forward Error:"+e+e.getMessage());
       }
    }else{
      doProcess = true;
    } 
	
  	//若muser_id資料時,表示登入成功================================================================
	if(doProcess){
		String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				

		//登入者資訊
		String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
		String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");		
		String lguser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");				
		String lguser_tbank_no = ( session.getAttribute("tbank_no")==null ) ? "" : (String)session.getAttribute("tbank_no");			
		String bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");				
		session.setAttribute("nowtbank_no",null);//94.01.05 fix 沒有Bank_List,把所點選的Bank_no清除======
	
		System.out.println("lguser_id="+lguser_id);
		System.out.println("act="+act);

		if(!Utility.CheckPermission(request,"ZZ046W")){//無權限時,導向到LoginError.jsp
		        rd = application.getRequestDispatcher( LoginErrorPgName );        
		}else{
	    	if(act.equals("List")){
	    	    List dbData = getDataList();
	    	    System.out.println("ZZ046W dbData="+dbData.size());	    	    
	    	    
	    	    request.setAttribute("dbData", dbData);
	        	rd = application.getRequestDispatcher( ListPgName +"?act=List&test=nothing");                	
	        }else if (act.equals("Update")){
	        	String key = request.getParameter("UpdateKey");
	        	actMsg = UpdateDB(request, key);
	        	
	        	List dbData = getDataList();
	    	    request.setAttribute("dbData", dbData);
	    	    
	        	rd = application.getRequestDispatcher(nextPgName+"?zz=ZZ046W");                		
	        }else if (act.equals("UpdateAll")){
	        	actMsg = UpdateAllByOpenFlag();
	        	
	        	rd = application.getRequestDispatcher(nextPgName+"?zz=ZZ046W");  
	        }
	    	request.setAttribute("actMsg",actMsg);    
		}
	
		try {
	        rd.forward(request, response);
	    } catch (NullPointerException npe){
	    }
	}//end of doProcess
%>

<%!
	private final static String nextPgName = "/pages/ActMsg.jsp";    
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String ListPgName = "/pages/ZZ046W_List.jsp";  

	private List getDataList(){
		StringBuffer sb = new StringBuffer();
		sb.append("select bn01.bank_no,"); //機構代碼
		sb.append("wlx01_upload.seq_no,");	//序號
		sb.append("bank_name,");	//機構名稱
		sb.append("file_type,");	//檔案名稱
		sb.append("append_file,");	//下載檔案
		sb.append("append_link,");	//實際檔案位置
		sb.append("wlx01_upload.update_date,"); //上傳日期
		sb.append("open_flag"); //揭露至官網
		sb.append(" from (select * from bn01 where m_year=100 and bn_type !='2' and bank_type in ('6','7'))bn01 ");
		sb.append("left join (select wlx01_upload.* ");
		sb.append("from  (select bank_no,max(seq_no) as seq_no ");
		sb.append("from wlx01_upload ");
		sb.append("where file_kind !='M' ");	//非內部控制制度聲明書
		sb.append("group by bank_no)wlx01_upload_max ");
		sb.append("left join wlx01_upload on wlx01_upload_max.bank_no = wlx01_upload.bank_no and wlx01_upload_max.seq_no=wlx01_upload.seq_no ");
		sb.append("where file_kind != 'M')wlx01_upload on bn01.bank_no = wlx01_upload.bank_no ");
		sb.append("order by bn01.bank_no,wlx01_upload.seq_no");
		
		System.out.println("sql is = "+sb.toString());
	
		return DBManager.QueryDB_SQLParam(sb.toString(), null ,"seq_no,update_date");
	}
	
	private String UpdateDB (HttpServletRequest request, String key) throws Exception{
		
  		Enumeration ep = request.getParameterNames();
  		Enumeration ea = request.getParameterNames();
  		Hashtable t = new Hashtable();

		for(;ep.hasMoreElements();){
			String name = (String)ep.nextElement();
			t.put(name, request.getParameter(name));
		}
		
		int row = Integer.parseInt((String)t.get("row"));
		System.out.println(row);
		
  	    List lockData = new LinkedList();
  	    for(int i =0; i< row;i ++){
  	    	if(t.get("isModify_"+(i+1))!= null){
  	    		lockData.add((String)t.get("isModify_"+(i+1)));
  	    	}
  	    }
  	    
  	    //System.out.println("lockData size="+lockData.size());
  	    //System.out.println("lockData data="+lockData);  	    
  	      	    
  	  	Map pData = parseData(lockData);
		List mapping = new ArrayList() ;

		String sql = "";
		String msg = key.equals("Y")?"設定揭露成功":"設定取消揭露成功";
		
		if(key.equals("Y"))
			sql ="UPDATE wlx01_upload set open_flag = 'Y', update_date = sysdate WHERE bank_no = ? AND seq_no = ?";
		else if (key.equals("N"))
			sql ="UPDATE wlx01_upload set open_flag = 'N', update_date = sysdate WHERE bank_no = ? AND seq_no = ?";
		
  	    for(Object obj : pData.keySet()){
  	    	mapping.clear();
  	    	
  	    	String bank = (String)obj;
  	    	String seq = (String)pData.get(bank);
  	    	mapping.add(bank);
  	    	mapping.add(seq);
  	    	
  	  	  	if (!this.updDbUsesPreparedStatement(sql, mapping)){
  	  	  		msg = key.equals("Y")?"設定揭露失敗":"設定取消揭露失敗";
  	  	  	}
  	    }
  	    
  	    return msg;
	}
	
	private String UpdateAllByOpenFlag() throws Exception{
		String sql ="update wlx01_upload set open_flag='N',update_date = sysdate where file_kind = ?";
		List mapping = new ArrayList();
		mapping.add("O");
		
		if(!this.updDbUsesPreparedStatement(sql, mapping)){
			return "全部取消揭露失敗";
		}
		
		return "全部取消揭露成功";
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
	
	private Map parseData(List list){
		Map data = new HashMap();
		
		for(int i =0; i<list.size(); i++){
			String[] datas = ((String)list.get(i)).split(":");
			data.put(datas[0], datas[1]);
		}
		
		return data;
	}
		
%>


		