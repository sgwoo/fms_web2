<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.car_register.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	String cng_cau 	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_fee_est_dt = request.getParameter("s_fee_est_dt")==null?"":request.getParameter("s_fee_est_dt");
	
	
	String value0[]  = request.getParameterValues("c_rent_mng_id");
	String value1[]  = request.getParameterValues("c_rent_l_cd");
	String value2[]  = request.getParameterValues("c_rent_st");
	String value3[]  = request.getParameterValues("c_rent_seq");
	String value4[]  = request.getParameterValues("c_fee_tm");
	String value5[]  = request.getParameterValues("c_tm_st1");
	String value6[]  = request.getParameterValues("c_tm_st2");
	String value7[]  = request.getParameterValues("c_req_dt");
	String value8[]  = request.getParameterValues("c_tax_out_dt");
	
	int vid_size = value0.length;
	int flag = 0;
	
	for(int i=0 ; i < vid_size ; i++){
	
		FeeScdBean fee = af_db.getScdNew(value0[i], value1[i], value2[i], value3[i], value4[i], value5[i]);//m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1
		
		String req_dt 		= value7[i]==null?"":AddUtil.replace(value7[i],"-","");
		String tax_out_dt 	= value8[i]==null?"":AddUtil.replace(value8[i],"-","");
		
		String o_req_dt 		= AddUtil.replace(fee.getReq_dt(),"-","");
		String o_tax_out_dt 	= AddUtil.replace(fee.getTax_out_dt(),"-","");
		
		
		if(!req_dt.equals(o_req_dt) || !tax_out_dt.equals(o_tax_out_dt)){
			
			fee.setReq_dt		(req_dt);
			fee.setR_req_dt		(af_db.getValidDt(req_dt));
			fee.setTax_out_dt	(tax_out_dt);
			
			if(AddUtil.parseInt(AddUtil.replace(fee.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(fee.getReq_dt(),"-",""))){
				fee.setR_req_dt	(fee.getReq_dt());
			}
			
			if(!af_db.updateFeeScd(fee)) flag += 1;
			
			
			if(!cng_cau.equals("")){
				//변경이력 등록
				FeeScdCngBean cng = new FeeScdCngBean();
				cng.setRent_mng_id	(fee.getRent_mng_id());
				cng.setRent_l_cd	(fee.getRent_l_cd());
				cng.setFee_tm		(fee.getFee_tm());
				cng.setAll_st		("");
				cng.setGubun		("발행예정일|청구일자");
				cng.setB_value		(o_req_dt+"|"+o_tax_out_dt);
				cng.setA_value		(req_dt+"|"+tax_out_dt);
				cng.setCng_id		(user_id);
				cng.setCng_cau		(cng_cau);
				if(!af_db.insertFeeScdCng(cng)) flag += 1;
			}
		}
	}
%>


<html>
<head><title>FMS</title></head>
<body style="font-size:12">
<form name='form1' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='rent_seq' value='<%=rent_seq%>'>
<input type='hidden' name='cng_st' value='<%=cng_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
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
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='s_fee_est_dt' value='<%=s_fee_est_dt%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("스케줄이 변경되지 않았습니다");
<%	}else{		%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>
</body>
</html>
