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
	/*String bank_no = (session.getAttribute("tbank_no") == null) ? "" : (String) session.getAttribute("tbank_no");
	String nowtbank_no = (request.getParameter("tbank_no") == null) ? "" : (String) request.getParameter("tbank_no");
	if (!nowtbank_no.equals("")) {
		session.setAttribute("nowtbank_no", nowtbank_no);//將已點選的tbank_no寫入session	   
	}
	//get bank_no
	bank_no = (session.getAttribute("nowtbank_no") == null) ? bank_no : (String) session.getAttribute("nowtbank_no");
	*///=======================================================================================================================

	String seq_no = (request.getParameter("seq_no") == null) ? "" : (String) request.getParameter("seq_no");
	String bank_no = (request.getParameter("bank_no") == null) ? "" : (String) request.getParameter("bank_no");
	//get file dir
	DataObject file = (DataObject) getUploadFile(bank_no, seq_no).get(0);
	if (file != null) {
		String append_file = (String)file.getValue("append_link");
		int length = append_file.length();
		int type_index = append_file.lastIndexOf(".");
		String file_type = append_file.substring(type_index + 1, length);
		String dir = Utility.getProperties("reportDir");
		String downloadlink = dir + System.getProperty("file.separator") + append_file;
		System.out.println("file_type:" + file_type);
		System.out.println("downloadlink:" + downloadlink);
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
		}else{
			System.out.println("can't find the file");
		}
	}
%>

<%!
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

