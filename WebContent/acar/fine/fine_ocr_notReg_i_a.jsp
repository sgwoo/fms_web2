<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.user_mng.*, acar.coolmsg.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String temp_paid_no = request.getParameter("temp_paid_no")==null?"":request.getParameter("temp_paid_no");
	String temp_vio_dt = request.getParameter("temp_vio_dt")==null?"":request.getParameter("temp_vio_dt");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String fault_st = request.getParameter("fault_st")==null?"":request.getParameter("fault_st");
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	//���·�����
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
	
	int seq2 = 0;
	String flag = "N";
	// fine_temp ���̺��� reg_yn ������Ʈ
	seq2 = a_fdb.updateFineTempRegYn(temp_paid_no, temp_vio_dt, seq);
	
	if(seq2 > 0 ) {
		flag = "Y";
	}
	
%>
	
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">

	// ���·� ���� �� ���� ������ �̵�
	function moveOcrReg() {
		var fm = document.form1;
		if('<%=flag%>' == "Y") {
			alert("���·� �̵�� ó���� �Ϸ�Ǿ����ϴ�.");
			fm.target = "d_content";
			fm.action = "fine_ocr_frame.jsp";
			fm.submit();
		} else {
			alert("���·� �̵�Ͽ� �����Ͽ����ϴ�.");
		}
	}
	
</script>
</head>
<body onLoad="javascript:moveOcrReg()">
<form action="" name="form1" method="post">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="seq_no" value="">
<input type="hidden" name="cmd" value="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
</form>
</body>
</html>