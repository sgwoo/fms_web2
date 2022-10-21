<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String f_list = request.getParameter("f_list")==null?"in":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int seq_no = 0;
	int count = 0;

	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	if(cmd.equals("i")||cmd.equals("u")||cmd.equals("d")){
		
		f_bean.setCar_mng_id(c_id);
		f_bean.setRent_mng_id(m_id);
		f_bean.setRent_l_cd(l_cd);
		f_bean.setSeq_no(request.getParameter("seq_no")==null?0:Util.parseInt(request.getParameter("seq_no")));
		f_bean.setFine_st(request.getParameter("fine_st")==null?"":request.getParameter("fine_st"));
		f_bean.setCall_nm(request.getParameter("call_nm")==null?"":request.getParameter("call_nm"));
		f_bean.setTel(request.getParameter("tel")==null?"":request.getParameter("tel"));
		f_bean.setFax(request.getParameter("fax")==null?"":request.getParameter("fax"));
		f_bean.setVio_dt(request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt"));
		f_bean.setVio_pla(request.getParameter("vio_pla")==null?"":request.getParameter("vio_pla"));
		f_bean.setVio_cont(request.getParameter("vio_cont")==null?"":request.getParameter("vio_cont"));
		f_bean.setPaid_st(request.getParameter("paid_st")==null?"":request.getParameter("paid_st"));
		f_bean.setRec_dt(request.getParameter("rec_dt")==null?"":request.getParameter("rec_dt"));
		f_bean.setPaid_end_dt(request.getParameter("paid_end_dt")==null?"":request.getParameter("paid_end_dt"));
		f_bean.setPaid_amt(request.getParameter("paid_amt")==null?0:AddUtil.parseDigit(request.getParameter("paid_amt")));
		f_bean.setProxy_dt(request.getParameter("proxy_dt")==null?"":request.getParameter("proxy_dt"));
		f_bean.setPol_sta(request.getParameter("pol_sta")==null?"":request.getParameter("pol_sta"));
		f_bean.setPaid_no(request.getParameter("paid_no")==null?"":request.getParameter("paid_no"));
		f_bean.setFault_st(request.getParameter("fault_st")==null?"":request.getParameter("fault_st"));
		f_bean.setFault_nm(request.getParameter("fault_nm")==null?"":request.getParameter("fault_nm"));
		f_bean.setDem_dt(request.getParameter("dem_dt")==null?"":request.getParameter("dem_dt"));
		f_bean.setColl_dt(request.getParameter("coll_dt")==null?"":request.getParameter("coll_dt"));
		f_bean.setRec_plan_dt(request.getParameter("rec_plan_dt")==null?"":request.getParameter("rec_plan_dt"));
		f_bean.setNote(request.getParameter("note")==null?"":request.getParameter("note"));
		f_bean.setNo_paid_yn(request.getParameter("no_paid_yn")==null?"N":request.getParameter("no_paid_yn"));
		f_bean.setNo_paid_cau(request.getParameter("no_paid_cau")==null?"":request.getParameter("no_paid_cau"));
		f_bean.setUpdate_id(request.getParameter("user_id")==null?"":request.getParameter("user_id"));
		f_bean.setUpdate_dt(AddUtil.getDate());
		f_bean.setObj_dt1(request.getParameter("obj_dt1")==null?"":request.getParameter("obj_dt1"));
		f_bean.setObj_dt2(request.getParameter("obj_dt2")==null?"":request.getParameter("obj_dt2"));
		f_bean.setObj_dt3(request.getParameter("obj_dt3")==null?"":request.getParameter("obj_dt3"));
		f_bean.setBill_doc_yn(request.getParameter("bill_doc_yn")==null?"":request.getParameter("bill_doc_yn"));
		f_bean.setBill_mon(request.getParameter("bill_mon")==null?"":request.getParameter("bill_mon"));		
		f_bean.setFault_amt(request.getParameter("fault_amt")==null?0:AddUtil.parseDigit(request.getParameter("fault_amt")));
//		out.println(request.getParameter("fault_nm")==null?"":request.getParameter("fault_nm"));
		f_bean.setVat_yn(request.getParameter("vat_yn")==null?"":request.getParameter("vat_yn"));
		f_bean.setTax_yn(request.getParameter("tax_yn")==null?"":request.getParameter("tax_yn"));
		f_bean.setF_dem_dt(request.getParameter("f_dem_dt")==null?"":request.getParameter("f_dem_dt"));
		f_bean.setE_dem_dt(request.getParameter("e_dem_dt")==null?"":request.getParameter("e_dem_dt"));
		f_bean.setBusi_st(request.getParameter("busi_st")==null?"":request.getParameter("busi_st"));
		if(cmd.equals("i")){		seq_no = a_fdb.insertForfeit(f_bean);
		}else if(cmd.equals("u")){	count = a_fdb.updateForfeit(f_bean);
		}else if(cmd.equals("d")){	count = a_fdb.deleteForfeit(f_bean);
		}
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){
		var fm = document.form1;
	<%if(cmd.equals("u")||cmd.equals("d")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		fm.seq_no.value = '<%=f_bean.getSeq_no()%>';
		fm.target = "d_content";
		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.submit();
<%		}else if(count==2){%>
		alert("정상적으로 삭제되었습니다.");
		fm.seq_no.value = '';
		fm.target = "d_content";
		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.submit();
<%		}
	}else{
		if(seq_no!=0){%>
		alert("정상적으로 등록되었습니다.");
		fm.seq_no.value = '<%=seq_no%>';
		fm.target = "d_content";
		fm.action = "/acar/forfeit_mng/forfeit_i_frame.jsp";
		fm.submit();
<%		}
	}%>
	}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="" name="form1" method="post">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='serv_id' value=''>
<input type="hidden" name="seq_no" value="">
<input type="hidden" name="cmd" value="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
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
<input type="hidden" name="vio_dt" value="">
</form>
</body>
</html>
