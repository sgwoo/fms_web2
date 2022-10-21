<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String tint_no	 	= request.getParameter("tint_no")==null?"":request.getParameter("tint_no");
	String tint_st	 	= request.getParameter("tint_st")==null?"":request.getParameter("tint_st");
	String off_id	 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm	 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String req_id	 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	
	
	TintBean tint 	= t_db.getTint(tint_no);
	
	String sup_off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String sup_est_dt 	= request.getParameter("sup_est_dt")==null?"":request.getParameter("sup_est_dt");
	String sup_est_h 	= request.getParameter("sup_est_h")	==null?"":request.getParameter("sup_est_h");
	
	tint.setTint_st			(tint_st);
	tint.setRent_mng_id		(request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id"));
	tint.setRent_l_cd		(request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd"));
	tint.setClient_id		(request.getParameter("client_id")	==null?"":request.getParameter("client_id"));
	tint.setCar_mng_id		(request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id"));
	tint.setCar_no			(request.getParameter("car_no")		==null?"":request.getParameter("car_no"));
	tint.setCar_nm			(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));
	tint.setCar_num			(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));
	tint.setFilm_st			(request.getParameter("film_st")	==null?"":request.getParameter("film_st"));
	tint.setSun_per			(request.getParameter("sun_per")	==null? 0:AddUtil.parseDigit(request.getParameter("sun_per")));
	tint.setCleaner_st		(request.getParameter("cleaner_st")	==null?"":request.getParameter("cleaner_st"));
	tint.setCleaner_add		(request.getParameter("cleaner_add")	==null?"":request.getParameter("cleaner_add"));
	tint.setNavi_nm			(request.getParameter("navi_nm")	==null?"":request.getParameter("navi_nm"));
	tint.setNavi_est_amt		(request.getParameter("navi_est_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("navi_est_amt")));
	tint.setOther			(request.getParameter("sup_other")	==null?"":request.getParameter("sup_other"));
	tint.setEtc			(request.getParameter("sup_etc")	==null?"":request.getParameter("sup_etc"));
	tint.setSup_est_dt		(sup_est_dt+sup_est_h);
	tint.setOff_id			(off_id);
	tint.setOff_nm			(off_nm);
	tint.setReg_id			(req_id);
	tint.setReg_dt			(AddUtil.getDate());
	tint.setBlackbox_yn		(request.getParameter("blackbox_yn")	==null?"":request.getParameter("blackbox_yn"));
	
	//=====[consignment] insert=====
	tint_no = t_db.insertTint(tint);
	
	if(tint_no.equals("")){
		result++;
	}
	

	%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="tint_no" 			value="<%=tint_no%>">
</form>
<script language='javascript'>
	var flag = 0;	
	
<%		if(result>0){	%>	
	alert('용품의뢰 등록 에러입니다.\n\n확인하십시오');		flag = 1;
<%		}else{	%>		
	alert('등록되었습니다.');
	var fm = document.form1;		
	fm.action = 'tint_w_frame.jsp';
	fm.target = 'd_content';
	fm.submit();		
<%		}	%>		
</script>
</body>
</html>