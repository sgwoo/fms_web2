<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body>

<%
	//자동이체 등록/수정 처리 페이지
		
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	int flag = 0;
	
	ContCmsBean bean = a_db.getCmsMng(m_id, l_cd);
	
	String o_app_dt = bean.getApp_dt();
	
	bean.setRent_mng_id	(m_id);
	bean.setRent_l_cd	(l_cd);
	bean.setSeq		(request.getParameter("seq")==null?"":request.getParameter("seq"));
	bean.setCms_st		(request.getParameter("cms_st")==null?"":request.getParameter("cms_st"));
	bean.setCms_amt		(request.getParameter("cms_amt").equals("")?0:Util.parseDigit(request.getParameter("cms_amt")));
	bean.setCp_st		(request.getParameter("cp_st")==null?"":request.getParameter("cp_st"));
	bean.setCms_start_dt	(request.getParameter("cms_start_dt")==null?"":request.getParameter("cms_start_dt"));
	bean.setCms_end_dt	(request.getParameter("cms_end_dt")==null?"":request.getParameter("cms_end_dt"));
	bean.setCms_day		(request.getParameter("cms_day")==null?"":request.getParameter("cms_day"));
	
	bean.setCms_bank	(request.getParameter("cms_bank")==null?"":request.getParameter("cms_bank"));
	
	bean.setCms_acc_no	(request.getParameter("cms_acc_no")==null?"":request.getParameter("cms_acc_no"));
	bean.setCms_dep_nm	(request.getParameter("cms_dep_nm")==null?"":request.getParameter("cms_dep_nm"));
	bean.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
	bean.setCms_dep_post	(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	bean.setCms_dep_addr	(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	bean.setCms_etc		(request.getParameter("cms_etc")==null?"":request.getParameter("cms_etc"));
	bean.setCms_tel		(request.getParameter("cms_tel")==null?"":request.getParameter("cms_tel"));
	bean.setCms_m_tel	(request.getParameter("cms_m_tel")==null?"":request.getParameter("cms_m_tel"));
	bean.setCms_email	(request.getParameter("cms_email")==null?"":request.getParameter("cms_email"));
	bean.setApp_dt		(request.getParameter("app_dt")==null?AddUtil.getDate():request.getParameter("app_dt"));
	bean.setReg_st		(request.getParameter("reg_st")==null?"":request.getParameter("reg_st"));
	
	if(bean.getSeq().equals("")){
	
		bean.setReg_id(user_id);
		
		if(!bean.getApp_dt().equals("")){
			bean.setApp_id(user_id);
		}
		
		
		if(!a_db.insertContCmsMng(bean))	flag += 1;
		
		
	}else{
		if(o_app_dt.equals("") && !bean.getApp_dt().equals("")){
			bean.setApp_id(user_id);
		}
		
		if(!o_app_dt.equals("") && bean.getApp_dt().equals("")){
			bean.setApp_id("");
		}		
		
		bean.setUpdate_id(user_id);
		
		if(!a_db.updateContCmsMng(bean))	flag += 1;
		
	}
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+	
					"&m_id="+m_id+"&l_cd="+l_cd+"&client_id="+client_id+"&c_id="+c_id+"&s_cd="+s_cd+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"";
	
%>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{%>		
		alert("처리되었습니다");		
		parent.location='cms_mng.jsp<%=valus%>';		
<%	}%>
</script>