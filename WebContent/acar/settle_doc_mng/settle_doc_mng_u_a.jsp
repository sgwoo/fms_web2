<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	/* multipart/form-data �� FileUpload��ü ���� */ 
	
	String savePath = "C:\\Inetpub\\wwwroot\\data\\stop_doc"; // ������ ���丮 (������)
 	int sizeLimit = 5 * 1024 * 1024 ; // 5�ް����� ���� �Ѿ�� ���ܹ߻�
	MultipartRequest multi=new MultipartRequest(request, savePath, sizeLimit);
	
	String auth_rw = multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");
	String user_id = multi.getParameter("user_id")==null?"":multi.getParameter("user_id");//�α���-ID
	String br_id = multi.getParameter("br_id")==null?"":multi.getParameter("br_id");//�α���-������
	String gubun1 = multi.getParameter("gubun1")==null?"":multi.getParameter("gubun1");
	String gubun2 = multi.getParameter("gubun2")==null?"":multi.getParameter("gubun2");
	String gubun3 = multi.getParameter("gubun3")==null?"":multi.getParameter("gubun3");
	String gubun4 = multi.getParameter("gubun4")==null?"":multi.getParameter("gubun4");
	String st_dt = multi.getParameter("st_dt")==null?"":multi.getParameter("st_dt");
	String s_end_dt = multi.getParameter("s_end_dt")==null?"":multi.getParameter("s_end_dt");
	String end_dt = multi.getParameter("end_dt")==null?"":multi.getParameter("end_dt");
	String s_kd = multi.getParameter("s_kd")==null?"":multi.getParameter("s_kd");
	String t_wd = multi.getParameter("t_wd")==null?"":multi.getParameter("t_wd");
	String sort = multi.getParameter("sort")==null?"":multi.getParameter("sort");
	String asc = multi.getParameter("asc")==null?"":multi.getParameter("asc");
	
	String doc_id 	= multi.getParameter("doc_id")==null?"":multi.getParameter("doc_id");
	String mng_dept = multi.getParameter("mng_dept")==null?"":multi.getParameter("mng_dept");
	String gov_addr = multi.getParameter("gov_addr")==null?"":multi.getParameter("gov_addr");
	String title 	= multi.getParameter("title")==null?"":multi.getParameter("title");
	
	
%>

<%
	int count = 0;
	boolean flag = true;
	int flag1 = 0;
	
	//�ѱ��� ������ ���� -multipartrequest
    doc_id		= new String(doc_id.getBytes("8859_1"),"euc-kr");
    mng_dept	= new String(mng_dept.getBytes("8859_1"),"euc-kr");
    gov_addr	= new String(gov_addr.getBytes("8859_1"),"euc-kr");
    title		= new String(title.getBytes("8859_1"),"euc-kr");
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	//�ְ��� ���̺�
	FineDocBn.setDoc_dt		(multi.getParameter("doc_dt")==null?"":multi.getParameter("doc_dt"));
	FineDocBn.setMng_dept	(mng_dept);
	FineDocBn.setGov_addr	(gov_addr);
	FineDocBn.setTitle		(title);
	FineDocBn.setEnd_dt		(multi.getParameter("end_dt")==null?"":multi.getParameter("end_dt"));
	
	Enumeration formNames=multi.getFileNames();  // ���� �̸� ��ȯ
	String formName=(String)formNames.nextElement(); // �ڷᰡ ���� ��쿣 while ���� ���
	String fileName=multi.getFilesystemName(formName)==null?"":multi.getFilesystemName(formName); // ������ �̸� ���
	if(!fileName.equals("")){
		FineDocBn.setFilename	(fileName);
	}
	
	flag = FineDocDb.updateFineDoc(FineDocBn);
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
<form name='form1' action='settle_doc_mng_c.jsp' target='d_content' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=s_end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
</form>
<script>
<%		if(flag==true){%>
			alert("���������� ó���Ǿ����ϴ�.");
			parent.window.close();
			document.form1.submit()
//			parent.opener.location.reload();			
<%		}else{%>
			alert("�����߻�!");
<%		}%>
</script>
</body>
</html>

