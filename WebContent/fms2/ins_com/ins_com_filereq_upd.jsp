<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,java.text.SimpleDateFormat"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	
	
	String reg_code[] = request.getParameterValues("reg_code"); 
	String seq[] = request.getParameterValues("seq"); 
	String etc[] = request.getParameterValues("etc"); 
	
	
	String gubun_st =   request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st"); 
	String c_reg_code =   request.getParameter("c_reg_code")==null?"":request.getParameter("c_reg_code"); 
	String c_seq =   request.getParameter("c_seq")==null?"":request.getParameter("c_seq"); 
	String c_use_st =   request.getParameter("c_use_st")==null?"":request.getParameter("c_use_st"); 
	
	
	String gubun2 =   request.getParameter("gubun2")==null?"":request.getParameter("gubun2"); 
	String gubun3 =   request.getParameter("gubun3")==null?"":request.getParameter("gubun3"); 

	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsurExcelBean ins = new InsurExcelBean();
	
	boolean result = false;
	
	if(gubun_st.equals("c")){
			ins.setReg_code(c_reg_code);
			ins.setSeq(Integer.parseInt(c_seq));
			ins.setUse_st(c_use_st);
			
			result = ic_db.updateInsExcelCom3(ins); 
	}else{
		int size = reg_code.length;
			
		for(int i=0; i<size; i++){
			ins.setReg_code(reg_code[i]);
			ins.setSeq(Integer.parseInt(seq[i]));
			ins.setEtc(etc[i]);
			
			result = ic_db.updateInsExcelCom2(ins); 
		}
	}

	
%>

<html>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head>
<title>FMS</title>
<script type="text/javascript"
	src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<script>
	var result = '<%=result%>';
	var gubun2 = '<%=gubun2%>';
	var gubun3 = '<%=gubun3%>';

	if (result) {
		location.href = "ins_com_filereq_sc_in.jsp?gubun2=" + gubun2
				+ "&gubun3=" + gubun3 + "'";

	} else {
		alert("수정 중 오류 발생");
		location.href = "ins_com_filereq_sc_in.jsp?gubun2=" + gubun2
				+ "&gubun3=" + gubun3 + "'";
	}
</script>


<body>

</body>