<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String st = request.getParameter("st")==null?"2":request.getParameter("st");
	String f_st = request.getParameter("f_st")==null?"1":request.getParameter("f_st");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int seq_no = 0;
	int count = 0;

	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	if(cmd.equals("i")||cmd.equals("u")||cmd.equals("d")){
		
		f_bean.setCar_mng_id(car_mng_id);
		f_bean.setRent_mng_id(rent_mng_id);
		f_bean.setRent_l_cd(rent_l_cd);
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
		f_bean.setPaid_amt(request.getParameter("paid_amt")==null?0:Util.parseInt(request.getParameter("paid_amt")));
		f_bean.setProxy_dt(request.getParameter("proxy_dt")==null?"":request.getParameter("proxy_dt"));
		f_bean.setPol_sta(request.getParameter("pol_sta")==null?"":request.getParameter("pol_sta"));
		f_bean.setPaid_no(request.getParameter("paid_no")==null?"":request.getParameter("paid_no"));
		f_bean.setFault_st(request.getParameter("fault_st")==null?"":request.getParameter("fault_st"));
		f_bean.setDem_dt(request.getParameter("dem_dt")==null?"":request.getParameter("dem_dt"));
		f_bean.setColl_dt(request.getParameter("coll_dt")==null?"":request.getParameter("coll_dt"));
		f_bean.setRec_plan_dt(request.getParameter("rec_plan_dt")==null?"":request.getParameter("rec_plan_dt"));
		f_bean.setNote(request.getParameter("note")==null?"":request.getParameter("note"));
		f_bean.setNo_paid_yn(request.getParameter("no_paid_yn")==null?"N":request.getParameter("no_paid_yn"));
		f_bean.setNo_paid_cau(request.getParameter("no_paid_cau")==null?"":request.getParameter("no_paid_cau"));
		f_bean.setUpdate_id(request.getParameter("user_id")==null?"":request.getParameter("user_id"));
		f_bean.setUpdate_dt(AddUtil.getDate());
		
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
	<%if(cmd.equals("u")||cmd.equals("d")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		var theForm = document.form1;
		var theForm1 = parent.c_body.document.ForfeitForm;
		//parent.c_body.hideLayer();
		theForm1.seq_no.value = '';
		theForm.target="c_foot";
		theForm.submit();;
		window.location="about:blank";
<%		}else if(count==2){%>
		alert("정상적으로 삭제되었습니다.");
		var theForm = document.form1;
		var theForm1 = parent.c_body.document.ForfeitForm;
		//parent.c_body.hideLayer();
		theForm1.seq_no.value = '';
		theForm.target="c_foot";
		theForm.submit();;
		window.location="about:blank";
<%		}
	}else{
		if(seq_no!=0){%>
	alert("정상적으로 등록되었습니다.");
	var theForm = document.form1;
	var theForm1 = parent.c_body.document.ForfeitForm;
	//parent.c_body.hideLayer();
	theForm1.seq_no.value = '';
	theForm.target="c_foot";
	theForm.submit();
	window.location="about:blank";
<%		}
	}%>
	}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">

<form action="./forfeit_i_sc.jsp" name="form1" method="post">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="f_st" value="<%=f_st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
</form>
</body>
</html>