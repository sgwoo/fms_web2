<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.cls.*, acar.cont.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
		
	int cls_s_amt =  request.getParameter("cls_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_s_amt"));   //해지정산금 공급가
	int cls_v_amt =  request.getParameter("cls_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_v_amt"));   //해지정산금 부가세
	
	int flag = 0;
	
	
	//채무자 자구책
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	String cls_st = cls.getCls_st_r();
	
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd  (rent_l_cd);
	
	cls.setDiv_st(request.getParameter("div_st")==null?"":				request.getParameter("div_st")); 						   //구분 1:완납, 2:분납  
	cls.setDiv_cnt(request.getParameter("div_cnt")==null?1:				AddUtil.parseDigit(request.getParameter("div_cnt")));     //분납횟수  
	cls.setEst_dt(request.getParameter("est_dt")==null?"":				request.getParameter("est_dt"));  						   //입금예정일
	cls.setEst_amt(request.getParameter("est_amt")==null?0:				AddUtil.parseDigit(request.getParameter("est_amt")));	   //채권약정금액 
	cls.setEst_nm(request.getParameter("est_nm")==null?"":				request.getParameter("est_nm"));  				   //입금약정자
	cls.setGur_nm(request.getParameter("gur_nm")==null?"":				request.getParameter("gur_nm")); 				   //대위변제자
	cls.setGur_rel_tel(request.getParameter("gur_rel_tel")==null?"":	request.getParameter("gur_rel_tel"));      //확정금액 사유
	cls.setGur_rel(request.getParameter("gur_rel")==null?"":			request.getParameter("gur_rel")); 		   //확정금액 결재자
	cls.setRemark(request.getParameter("remark")==null?"":				request.getParameter("remark"));           //확정금액 사유
	cls.setUpd_id(user_id);	
	
	if(!ac_db.updateClsEtcGet(cls))	flag += 1;
	
		//기해지된건인 경우  - 정보변경에 따른 변경
	int cls_cnt = 0;
	
	cls_cnt = ac_db.getContClsCnt(rent_mng_id, rent_l_cd);	
	
	if ( cls_cnt > 0 ) {
		if ( cls_st.equals("1") || cls_st.equals("2")  ) {  //중도해약, 만기시
		
		//환불건여부 확인
		
		//해지정산금 입금예정일 수정
			if(!ac_db.updateScdExtReJungsan(rent_mng_id, rent_l_cd, user_id, est_dt ))	flag += 1;
		}
	}	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>
<script language='javascript'>
<%	if(flag != 0){ 	//해지테이블에 수정 실패%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>
		alert("처리되었습니다");
		parent.opener.location.href = "lc_cls_d_frame.jsp<%=valus%>";
		parent.window.close();
<%	}			%>
</script>