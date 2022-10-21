<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*, tax.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">

<%
	
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String fee_tm 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String tm_st2 	= request.getParameter("tm_st2")==null?"":request.getParameter("tm_st2");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	String cng_cau 	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	int idx 	= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));

	String cng_rent_l_cd	= request.getParameter("cng_rent_l_cd")==null?"":request.getParameter("cng_rent_l_cd");
	String cng_rent_st 		= request.getParameter("cng_rent_st")==null?"":request.getParameter("cng_rent_st");
	String cng_tm_st2 		= request.getParameter("cng_tm_st2")==null?"":request.getParameter("cng_tm_st2");
	String cng_choice1 		= request.getParameter("cng_choice1")==null?"":request.getParameter("cng_choice1");
	String cng_choice2 		= request.getParameter("cng_choice2")==null?"":request.getParameter("cng_choice2");
	String cng_choice3 		= request.getParameter("cng_choice3")==null?"":request.getParameter("cng_choice3");
	
	
	int flag = 0;
	
	
	FeeScdBean fee = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1);
	
	String cng_rent_mng_id = m_id;
	
	if(cng_choice1.equals("Y") && !l_cd.equals(cng_rent_l_cd)){ 
		Hashtable ht = a_db.getContCase(cng_rent_l_cd);
		cng_rent_mng_id = String.valueOf(ht.get("RENT_MNG_ID"));
	}
	

	if(cng_choice1.equals("Y")){
	
		if(!af_db.updateFeeScdCng(fee, "1", cng_rent_mng_id, cng_rent_l_cd, cng_rent_st, cng_tm_st2)) flag += 1;
		
		fee.setRent_mng_id(cng_rent_mng_id);
		fee.setRent_l_cd(cng_rent_l_cd);
		
	}
	
	if(cng_choice2.equals("Y")){
	
		if(!af_db.updateFeeScdCng(fee, "2", cng_rent_mng_id, cng_rent_l_cd, cng_rent_st, cng_tm_st2)) flag += 1;
		
		fee.setRent_st(cng_rent_st);
		
	}
	
	if(cng_choice3.equals("Y")){		
	
		if(!af_db.updateFeeScdCng(fee, "3", cng_rent_mng_id, cng_rent_l_cd, cng_rent_st, cng_tm_st2)) flag += 1;				
		
	}


%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
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
<input type='hidden' name='idx' value='<%=idx%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("�������� ������� �ʾҽ��ϴ�");
//		location='about:blank';
		
<%	}else{		%>		
		alert("�������� ����Ǿ����ϴ�");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>