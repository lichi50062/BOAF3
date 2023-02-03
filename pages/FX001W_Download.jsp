<%--
107.05.11 add 金庫報表檔案下載 by 6417
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ include file="common.jsp"%>

<HTML>
<head>
<title>上傳檔案作業</title>
</head>
</HTML>
<%
	
	//若有已點選的tbank_no,則以已點選的tbank_no為主============================================================
	String bank_no = (session.getAttribute("tbank_no") == null) ? "" : (String) session.getAttribute("tbank_no");
	String nowtbank_no = (request.getParameter("tbank_no") == null) ? "" : (String) request.getParameter("tbank_no");
	if (!nowtbank_no.equals("")) {
		session.setAttribute("nowtbank_no", nowtbank_no);//將已點選的tbank_no寫入session	   
	}
	//get bank_no
	bank_no = (session.getAttribute("nowtbank_no") == null) ? bank_no : (String) session.getAttribute("nowtbank_no");
	//=======================================================================================================================

	String seq_no = (request.getParameter("seq_no") == null) ? "" : (String) request.getParameter("seq_no");
	String bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");
	//get file dir
	DataObject file = (DataObject) getUploadFile(bank_no, seq_no).get(0);
	String errMsg ="";
	RequestDispatcher rd = null;
	if(!Utility.CheckPermission(request,"FX001W")){//無權限時,導向到LoginError.jsp       
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{
		if (file != null) {
			String append_file = (String)file.getValue("append_file");
			int index = append_file.lastIndexOf(".");
			int length = append_file.length();
			String file_type = append_file.substring(index + 1, length);
			String dir = Utility.getProperties("wlx_uploadDir");
			String downloadlink = dir + System.getProperty("file.separator") + append_file;
			System.out.println("downloadlink:" + downloadlink);
			System.out.println("file_type:" + file_type);
			System.out.println("file_name:" + append_file);
			System.out.println("encode:" + URLEncoder.encode(append_file, "utf-8"));
			
			java.io.File tmpFile = new java.io.File(downloadlink);
			System.out.println("tmpFile.exists():" + tmpFile.exists());
			
			//download
			SmartUpload mySmartUpload = new SmartUpload(); 
			mySmartUpload.initialize(pageContext);
			if(tmpFile.exists()){
				//choose file type
				if (file_type.equals("doc") || file_type.equals("docx")) {
					mySmartUpload.setContentDisposition(null);
					mySmartUpload.downloadFile(downloadlink, "application/msword; charset=UTF-8", append_file);
				} else if (file_type.equals("xls") || file_type.equals("xlsx")) {
					mySmartUpload.setContentDisposition(null);
					mySmartUpload.downloadFile(downloadlink, "application/vnd.ms-excel; charset=UTF-8",
							append_file);
				} else if (file_type.equals("pdf")) {
					mySmartUpload.setContentDisposition("inline;");
					mySmartUpload.downloadFile(downloadlink, "application/pdf; charset=UTF-8", append_file);
				}
				out.clear();
				out = pageContext.pushBody();
				errMsg = "downloadSuccess";
			}else{
				errMsg = "找不到該檔案可提供下載";
				System.out.println("can't find the file");
			}
			rd = application.getRequestDispatcher( nextPgName + "?goPages=FX001W.jsp&act=new&bank_type="+bank_type);
	    }
		request.setAttribute("actMsg",errMsg);   
		try {
		       //forward to next present jsp
		       rd.forward(request, response);
		   } catch (NullPointerException npe) {
		   }

	}

	
%>

<%!
	private final static String LoginErrorPgName = "/pages/LoginError.jsp";
	private final static String nextPgName = "/pages/ActMsg.jsp";    

	private List getUploadFile(String bank_no, String seq_no) throws Exception {
		List paramList = new ArrayList();
		String sqlCmd = "select seq_no,file_type,append_file,append_link, update_date from wlx01_upload where bank_no= ? and seq_no=? ";
		paramList.add(bank_no);
		paramList.add(seq_no);

		List dbData = DBManager.QueryDB_SQLParam(sqlCmd, paramList,
				"seq_no,file_type,append_file,append_link, update_date");
		return dbData;
	}

	%>

