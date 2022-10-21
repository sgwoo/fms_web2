<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	/* multipart/form-data �� FileUpload��ü ���� */ 
	
	String savePath = "C:\\Inetpub\\wwwroot\\data\\stop_doc\\doc_file"; // ������ ���丮 (������)
 	int sizeLimit = 5 * 1024 * 1024 ; // 5�ް����� ���� �Ѿ�� ���ܹ߻�
	MultipartRequest multi=new MultipartRequest(request, savePath, sizeLimit);
	
	String auth_rw 	= multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");
	String user_id	= multi.getParameter("user_id")==null?"":multi.getParameter("user_id");//�α���-ID
	String br_id 	= multi.getParameter("br_id")==null?"":multi.getParameter("br_id");//�α���-������
	
%>

<%
	String doc_id 	= multi.getParameter("doc_id")==null?"":multi.getParameter("doc_id");
	String gov_nm 	= multi.getParameter("gov_nm")==null?"":multi.getParameter("gov_nm");
	String gov_addr = multi.getParameter("gov_addr")==null?"":multi.getParameter("gov_addr");
	String mng_dept = multi.getParameter("mng_dept")==null?"":multi.getParameter("mng_dept");
	String mng_nm 	= multi.getParameter("firm_nm")==null?"":multi.getParameter("firm_nm");
	String title 	= multi.getParameter("title")==null?"":multi.getParameter("title");
	String title_sub= multi.getParameter("title_sub")==null?"":multi.getParameter("title_sub");
	
	//�ѱ��� ������ ���� -multipartrequest
    doc_id		= new String(doc_id.getBytes("8859_1"),"euc-kr");
    gov_nm		= new String(gov_nm.getBytes("8859_1"),"euc-kr");
    gov_addr	= new String(gov_addr.getBytes("8859_1"),"euc-kr");
    mng_dept	= new String(mng_dept.getBytes("8859_1"),"euc-kr");
	mng_nm		= new String(mng_nm.getBytes("8859_1"),"euc-kr");
    title		= new String(title.getBytes("8859_1"),"euc-kr");
    title_sub	= new String(title_sub.getBytes("8859_1"),"euc-kr");
	
	int count = 0;
	boolean flag = true;
	int flag1 = 0;
	
	//�ߺ�üũ
	count = FineDocDb.getDocIdChk(doc_id);
//	System.out.println("user_id = "+user_id);
	if(count == 0){
		//�ְ��� ���̺�
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(multi.getParameter("doc_dt")==null?"":multi.getParameter("doc_dt"));
		FineDocBn.setGov_id		(multi.getParameter("gov_id")==null?"":multi.getParameter("gov_id"));
		FineDocBn.setMng_dept	(mng_dept);
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_nm		(gov_nm);
		FineDocBn.setGov_addr	(gov_addr);
		FineDocBn.setTitle		(title);
		FineDocBn.setH_mng_id	(multi.getParameter("client_id")==null?"":multi.getParameter("client_id"));
		FineDocBn.setB_mng_id	(multi.getParameter("req_id")==null?"":multi.getParameter("req_id"));
		FineDocBn.setMng_nm		(mng_nm);
		FineDocBn.setMng_pos	(multi.getParameter("l_cd")==null?"":multi.getParameter("l_cd"));
		
		
		Enumeration formNames=multi.getFileNames();  // ���� �̸� ��ȯ
		String formName=(String)formNames.nextElement(); // �ڷᰡ ���� ��쿣 while ���� ���
		String fileName=multi.getFilesystemName(formName)==null?"":multi.getFilesystemName(formName); // ������ �̸� ���
		if(!fileName.equals("")){
			FineDocBn.setFilename	(fileName);
		}
		
		flag = FineDocDb.insertFineDoc(FineDocBn);

	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("���������� ó���Ǿ����ϴ�.");
			//parent.parent.location.reload();
			parent.close();				
<%		}else{%>
			alert("�����߻�!");
<%		}%>
<%	}else{%>
			alert("�̹� ��ϵ� ������ȣ�Դϴ�. Ȯ���Ͻʽÿ�.");
			parent.document.form1.gov_nm.focus();
<%	}%>
</script>
</body>
</html>

