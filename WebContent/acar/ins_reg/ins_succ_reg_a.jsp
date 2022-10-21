<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<jsp:useBean id="cls" 	class="acar.insur.InsurClsBean" 		scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String o_c_id = request.getParameter("o_c_id")==null?"":request.getParameter("o_c_id");//자동차관리번호
	String o_ins_st = request.getParameter("o_ins_st")==null?"":request.getParameter("o_ins_st");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String ins_con_no = request.getParameter("ins_con_no")==null?"":request.getParameter("ins_con_no");
	String next_ins_st = ai_db.getInsStNext(car_mng_id);
	
	int flag = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;
	
	//중복입력 체크-----------------------------------------------------
	int over_cnt = ai_db.getCheckOverIns(car_no, ins_con_no);
	
	if(over_cnt == 0){
		
		InsurBean ins = ai_db.getIns(o_c_id, o_ins_st);
		
		ins.setCar_mng_id(car_mng_id);
		ins.setIns_st(next_ins_st);
		ins.setIns_sts("1");	//1:유효, 2:만료, 3:중도해지, 4:오프리스보험
		ins.setIns_com_id(request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id"));
		ins.setIns_con_no(request.getParameter("ins_con_no")==null?"":request.getParameter("ins_con_no"));
		ins.setConr_nm(request.getParameter("conr_nm")==null?"":request.getParameter("conr_nm"));
		ins.setCon_f_nm(request.getParameter("con_f_nm")==null?"":request.getParameter("con_f_nm"));
		ins.setIns_start_dt(request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt"));
		ins.setIns_exp_dt(request.getParameter("ins_exp_dt")==null?"":request.getParameter("ins_exp_dt"));
		ins.setCar_use(request.getParameter("car_use")==null?"":request.getParameter("car_use"));
		ins.setAge_scp(request.getParameter("age_scp")==null?"":request.getParameter("age_scp"));
		ins.setAir_ds_yn(request.getParameter("air_ds_yn")==null?"N":request.getParameter("air_ds_yn"));
		ins.setAir_as_yn(request.getParameter("air_as_yn")==null?"N":request.getParameter("air_as_yn"));
		ins.setCar_rate(request.getParameter("car_rate")==null?"":request.getParameter("car_rate"));
		ins.setExt_rate(request.getParameter("ext_rate")==null?"":request.getParameter("ext_rate"));
		ins.setRins_pcp_amt(request.getParameter("rins_pcp_amt")==null?0:Util.parseDigit(request.getParameter("rins_pcp_amt")));
		ins.setVins_pcp_kd(request.getParameter("vins_pcp_kd")==null?"":request.getParameter("vins_pcp_kd"));
		ins.setVins_pcp_amt(request.getParameter("vins_pcp_amt")==null?0:Util.parseDigit(request.getParameter("vins_pcp_amt")));
		ins.setVins_gcp_kd(request.getParameter("vins_gcp_kd")==null?"":request.getParameter("vins_gcp_kd"));
		ins.setVins_gcp_amt(request.getParameter("vins_gcp_amt")==null?0:Util.parseDigit(request.getParameter("vins_gcp_amt")));
		ins.setVins_bacdt_kd(request.getParameter("vins_bacdt_kd")==null?"":request.getParameter("vins_bacdt_kd"));
		ins.setVins_bacdt_kc2(request.getParameter("vins_bacdt_kc2")==null?"":request.getParameter("vins_bacdt_kc2"));
		ins.setVins_bacdt_amt(request.getParameter("vins_bacdt_amt")==null?0:Util.parseDigit(request.getParameter("vins_bacdt_amt")));
//		ins.setVins_canoisr_kd(request.getParameter("vins_canoisr_kd")==null?0:request.getParameter("vins_canoisr_kd"));
		ins.setVins_canoisr_amt(request.getParameter("vins_canoisr_amt")==null?0:Util.parseDigit(request.getParameter("vins_canoisr_amt")));
		ins.setVins_cacdt_car_amt(request.getParameter("vins_cacdt_car_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_car_amt")));
		ins.setVins_cacdt_me_amt(request.getParameter("vins_cacdt_me_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_me_amt")));
		ins.setVins_cacdt_cm_amt(request.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_cm_amt")));
		ins.setVins_cacdt_amt(request.getParameter("vins_cacdt_cm_amt")==null?0:Util.parseDigit(request.getParameter("vins_cacdt_cm_amt")));
		ins.setVins_spe(request.getParameter("vins_spe")==null?"":request.getParameter("vins_spe"));
		ins.setVins_spe_amt(request.getParameter("vins_spe_amt")==null?0:Util.parseDigit(request.getParameter("vins_spe_amt")));
		ins.setIns_kd(request.getParameter("ins_kd")==null?"":request.getParameter("ins_kd"));
		ins.setReg_cau(request.getParameter("reg_cau")==null?"":request.getParameter("reg_cau"));
		ins.setReg_id(user_id);
		
		if(!ai_db.insertIns(ins))	flag += 1;
		
		
		//해지보험정보
		cls = ai_db.getInsurClsCase(o_c_id, o_ins_st);
		//전보험 중도해지 처리
		InsurBean cls_ins = ai_db.getIns(o_c_id, o_ins_st);
		cls_ins.setIns_sts("3");	//1:유효, 2:만료, 3:중도해지, 4:오프리스보험
		//cls_ins.setIns_exp_dt(cls.getReq_dt());
		if(!ai_db.updateIns(cls_ins))	flag2 += 1;
		
		
		//보험변경스케줄+보험요금스케줄 승계로 넘기기
		if(!ai_db.updateInsScdSucc(o_c_id, o_ins_st, car_mng_id, next_ins_st)) flag3 += 1;
		
		
	}
%>
<form name='form1' method='post' action='/acar/ins_cls_mng/ins_cls_succ_frame.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
</form>
<script language='javascript'>
<%	if(over_cnt == 0){//중복체크%>
<%		if(flag != 0)	{%>	alert('승계차량 보험등록 오류발생!');			<%}%>
<%		if(flag2 != 0)	{%>	alert('해지차량 보험중지 오류발생!');			<%}%>
<%		if(flag3 != 0)	{%>	alert('보험변경/요금스케줄 승계 오류발생!');	<%}%>
<%		if(flag+flag2+flag3 == 0)	{%>	alert('정상처리되었습니다.');		<%}%>

<%		if(flag == 0){%>
			var fm = document.form1;
			fm.target = "d_content";		
			fm.submit();
<%		}else{	%>
			location='about:blank';
<%		}	%>
<%	}else{%>
	alert('이미 등록되었습니다.');
<%	}%>
</script>
</body>
</html>
