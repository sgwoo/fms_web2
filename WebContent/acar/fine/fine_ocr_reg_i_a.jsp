<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.user_mng.*, acar.coolmsg.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
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
	String file_url = request.getParameter("file_url")==null?"":request.getParameter("file_url");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String fault_st = request.getParameter("fault_st")==null?"":request.getParameter("fault_st");
	String email_yn = request.getParameter("email_yn_val")==null?"":request.getParameter("email_yn_val");

	boolean flag6 = true;
	int count = 0;
	String reg_code  = Long.toString(System.currentTimeMillis());
	int est_check1 = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();

	//과태료정보
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	ForfeitDatabase fdb = ForfeitDatabase.getInstance();
		f_bean.setReg_code		(reg_code);
		f_bean.setFine_st		("1");
		f_bean.setVio_dt		(request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt"));
		f_bean.setVio_pla(request.getParameter("vio_pla")==null?"":request.getParameter("vio_pla"));
		f_bean.setVio_cont		(request.getParameter("vio_cont")==null?"":request.getParameter("vio_cont"));
		f_bean.setPaid_st		("1");		
		f_bean.setPaid_end_dt	(request.getParameter("paid_end_dt")==null?"":request.getParameter("paid_end_dt"));
		f_bean.setObj_end_dt	(request.getParameter("obj_end_dt")==null?"":request.getParameter("obj_end_dt"));
		f_bean.setPaid_amt		(request.getParameter("paid_amt")==null?0:AddUtil.parseDigit(request.getParameter("paid_amt")));
		f_bean.setPol_sta		(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
		f_bean.setPaid_no		(request.getParameter("paid_no")==null?"":request.getParameter("paid_no"));
		f_bean.setFault_st		("1");
		f_bean.setNote			("과태료 OCR 등록");
		f_bean.setUpdate_id		(request.getParameter("user_id")==null?"":request.getParameter("user_id"));
		f_bean.setUpdate_dt		(AddUtil.getDate());
		f_bean.setMng_id		(request.getParameter("mng_id")==null?"":request.getParameter("mng_id"));
		f_bean.setCar_mng_id	(c_id);
		f_bean.setRent_mng_id	(m_id);
		f_bean.setRent_l_cd		(l_cd);
		f_bean.setRent_s_cd		(request.getParameter("s_cd")==null?"":request.getParameter("s_cd"));
		f_bean.setReg_id		(user_id);
		f_bean.setNotice_dt		(AddUtil.getDate());
		f_bean.setRent_st		(request.getParameter("rent_st")==null?"":request.getParameter("rent_st"));
		f_bean.setFile_name		(request.getParameter("file_url")==null?"":request.getParameter("file_url"));
		f_bean.setEmail_yn		(email_yn);
		
		int seq1 = a_fdb.insertOcrForfeit(f_bean);
		int seq2 = 0;
		
		String flag1 = "";
		String flag2 = "";
		
		if(seq1 > 0){
			flag1 = "Y";
		} else {
			flag1 = "N";
		}
		if(flag1 == "Y") {
			// fine_temp 테이블의 reg_yn 업데이트
			seq2 = a_fdb.updateFineTempRegYn(temp_paid_no, temp_vio_dt, seq);
			if(seq2 > 0) {
				flag2 = "Y";
			} else {
				flag2 = "N";
			}
		}
%>
	
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">

	// 과태료 저장 후 이전 페이지 이동
	function moveOcrReg() {
		var fm = document.form1;
		if('<%=flag2%>' == "Y") {
			alert("과태료 등록이 완료되었습니다.");
			fm.target = "d_content";
			fm.action = "../fine_mng/fine_mng_frame.jsp";
			fm.submit();
		} else {
			alert("과태료 등록에 실패하였습니다.");
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
