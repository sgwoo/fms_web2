<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.settle_acc.*, acar.bill_mng.*, acar.cont.*, acar.tax.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tax.TaxDatabase"/>
<%@ include file="/smart/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String bus_id2 		= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String s_item 		= request.getParameter("s_item")==null?"":request.getParameter("s_item");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String msg 			= request.getParameter("msg2")==null?"":request.getParameter("msg2");
	String msglen 		= request.getParameter("msglen2")==null?"":request.getParameter("msglen2");
	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	
	String msg_type 	= "0";
	String msg_subject 	= "";
	
	//발신자
	UsersBean user_bean = umd.getUsersBean(bus_id2);
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	
	int i_msglen = AddUtil.parseInt(msglen);
	
	//-아마존카- 자동삽입
	msg 	 	= msg + "-아마존카-";
	i_msglen 	= i_msglen+10;
	
	
	if(i_msglen > 80) 	msg_type = "5"; 
	
	
	if(!destphone.equals("")){
		
		String rqdate = "";
		if(msg_type.equals("5")) msg_subject = "(주)아마존카";
		
		if(req_dt.equals("")){
			t_db.insertsendMail_V5_H(user_bean.getUser_m_tel(), user_bean.getUser_nm(), destphone, firm_nm, "", rqdate, msg_type, msg_subject, msg, rent_l_cd, client_id, ck_acar_id, "5");
		}else{
			String req_time = req_dt;
			
			if(req_dt_h.equals("")) req_dt_h = "09";
			if(req_dt_s.equals("")) req_dt_s = "00";
			
			req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
			
			t_db.insertsendMail_V5_H(user_bean.getUser_m_tel(), user_bean.getUser_nm(), destphone, firm_nm, req_time, rqdate, msg_type, msg_subject, msg, rent_l_cd, client_id, ck_acar_id, "5");
		}
	}
%>
<script language='javascript'>
<!--
	alert('전송되었습니다.');
//-->
</script>
</body>
</html>