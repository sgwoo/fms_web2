<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String reg_id = request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
		
	int flag = 0;	
		
	//ä�ǰ���, ����ä���� ó���ǰ�/���û���
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
		
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd	(rent_l_cd);
	
	if(cls_st.equals("8")){//���Կɼ��ΰ�� 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));
			
		//���Կɼ� �Ա� 1 - ���꼭 �ۼ�������
		cls.setOpt_ip_dt1(request.getParameter("opt_ip_dt1")==null?"":			request.getParameter("opt_ip_dt1"));  		 //�߰��Ա���
		cls.setOpt_ip_amt1(request.getParameter("opt_ip_amt1")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt1")));	  //�߰��Աݾ� 	
		cls.setOpt_ip_bank1(request.getParameter("opt_bank_code1_2")==null?"":		request.getParameter("opt_bank_code1_2"));           //�Ա�����
		cls.setOpt_ip_bank_no1(request.getParameter("opt_deposit_no1_2")==null?"":request.getParameter("opt_deposit_no1_2"));            //�Աݱ���
		
		//���Կɼ� �Ա� 2 - ���꼭 �ۼ�������
		cls.setOpt_ip_dt2(request.getParameter("opt_ip_dt2")==null?"":			request.getParameter("opt_ip_dt2"));  		 //�߰��Ա���
		cls.setOpt_ip_amt2(request.getParameter("opt_ip_amt2")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt2")));	  //�߰��Աݾ� 	
		cls.setOpt_ip_bank2(request.getParameter("opt_bank_code2_2")==null?"":		request.getParameter("opt_bank_code2_2"));           //�Ա�����
		cls.setOpt_ip_bank_no2(request.getParameter("opt_deposit_no2_2")==null?"":request.getParameter("opt_deposit_no2_2"));            //�Աݱ���	
	
	}
			
	cls.setUpd_id	(user_id);
			
	if (cls_st.equals("8")) {			
		if(!ac_db.updateClsEtcAsset(cls))	flag += 1;	
		if(!ac_db.updateClsEtcOpt(cls))	flag += 1;
	}
	
		
	//�����Ƿڳ��� �߰� �׸� - 20180907 cls_etc field�� �ʹ� ���Ƽ� cls_etc_more�� �߰� 			
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);		

	clsm.setRent_mng_id(rent_mng_id);
	clsm.setRent_l_cd(rent_l_cd);
					
	clsm.setM_dae_amt(request.getParameter("m_dae_amt")==null?0:			AddUtil.parseDigit(request.getParameter("m_dae_amt")));	  //��ü�Աݾ� 	
	clsm.setExt_amt(request.getParameter("ext_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ext_amt")));	  //ȯ��/������ 	
	clsm.setStatus("1");	  //status 	
	///�����Ƿڳ��� �߰� �׸� ����	
	clsm.setCms_amt(request.getParameter("cms_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cms_amt")));	  //cms �κ�����  
	
	if(!ac_db.updateClsEtcMore(clsm))	flag += 1;	
				
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
	
	
%>
<script language='javascript'>
<%	if(flag != 0){ 	//�������̺� ���� ����%>

		alert("ó������ �ʾҽ��ϴ�");
		location='about:blank';		
<%	}else{		%>
		alert("ó���Ǿ����ϴ�");
		<% if (cls_st.equals("8")) {	%>
			parent.opener.location.href = "lc_cls_off_d_frame.jsp<%=valus%>";
		<% } else {%>
			parent.opener.location.href = "lc_cls_d_frame.jsp<%=valus%>";
		<%} %>
		parent.window.close();
<%	}	%>
</script>