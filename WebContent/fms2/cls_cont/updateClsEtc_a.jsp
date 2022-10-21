<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cls.*,  acar.cont.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

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
	
	//채권관계, 잔존채권의 처리의견/지시사항
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
//	String cls_st = cls.getCls_st_r();
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	int flag = 0;
		
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd	(rent_l_cd);
	
	cls.setCls_dt(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//실이용기간 월
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//실이용기간 일
	cls.setCls_st(cls_st);	
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//해지내역
	cls.setReg_id(reg_id); //담당자id
	cls.setUpd_id	(user_id);
	cls.setD_saction_id(request.getParameter("d_saction_id")==null?"":	request.getParameter("d_saction_id")); //확정금액 결재자
	cls.setD_reason(request.getParameter("d_reason")==null?"":	request.getParameter("d_reason"));             //확정금액 사유
	cls.setDly_saction_id(request.getParameter("dly_saction_id")==null?"":	request.getParameter("dly_saction_id")); //연체료감액 결재자
	cls.setDly_reason(request.getParameter("dly_reason")==null?"":	request.getParameter("dly_reason"));       //연체료감액 사유
	cls.setDft_saction_id(request.getParameter("dft_saction_id")==null?"":	request.getParameter("dft_saction_id")); //중도해지위약금감액 결재자
	cls.setDft_reason(request.getParameter("dft_reason")==null?"":	request.getParameter("dft_reason"));       //중도해지위약금감액 사유	
	cls.setRemark(request.getParameter("remark")==null?"":	request.getParameter("remark"));       //지시사항 기타의견
	cls.setCms_chk(request.getParameter("cms_chk")==null?"":	request.getParameter("cms_chk"));       //cms 인출의뢰
	cls.setDft_cost_id(request.getParameter("dft_cost_id")==null?"":	request.getParameter("dft_cost_id")); //영업효율담당자
		//고객환불정보
	cls.setRe_bank(request.getParameter("re_bank")==null?"":request.getParameter("re_bank"));            //은행
	cls.setRe_acc_no(request.getParameter("re_acc_no")==null?"":request.getParameter("re_acc_no"));      //환불계좌번호
	cls.setRe_acc_nm(request.getParameter("re_acc_nm")==null?"":request.getParameter("re_acc_nm"));      //환불 예금주명
	cls.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //차량주행거리
	
	cls.setMatch(request.getParameter("match")==null?"":request.getParameter("match"));      //만기매칭
	cls.setExt_saction_id(request.getParameter("ext_saction_id")==null?"":	request.getParameter("ext_saction_id")); //선수금후불처리 결재자
	cls.setExt_reason(request.getParameter("ext_reason")==null?"":	request.getParameter("ext_reason"));       //선수금후불처리 사유	
		
	boolean cr1_flag = ac_db.updateClsEtcCau(cls);
	
	String cms_after = request.getParameter("cms_after")==null?"":request.getParameter("cms_after");		
		
	//해지의뢰내역 추가 항목 - 20180907 cls_etc field가 너무 많아서 cls_etc_more에 추가 		
	if ( !ac_db.updateClsCmsAfter(rent_mng_id, rent_l_cd, cms_after ) )	flag += 1;			
	
	//기해지된건인 경우  - 정보변경에 따른 변경
	int cls_cnt = 0;
	
	cls_cnt = ac_db.getContClsCnt(rent_mng_id, rent_l_cd);	
	
	if ( cls_cnt > 0 ) {
		if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("14")|| cls_st.equals("8")   ) {
			
			//해지정보
			ClsBean clr = as_db.getClsCase(rent_mng_id, rent_l_cd);				
					
			//중도해지,  만기해지 해지의뢰 등록		
			clr.setCls_dt(request.getParameter("cls_dt"));
			clr.setCls_st(cls_st);	
			clr.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//실이용기간 월
			clr.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//실이용기간 일
				
			clr.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//해지내역
			clr.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //차량주행거리			
		
			clr.setCms_chk(request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk"));  //cms인출의뢰
			
			if(!as_db.updateCls(clr))	flag += 1;								
		}
		
		if (  cls_st.equals("7") || cls_st.equals("10") ) {
			if ( !as_db.updateClsSt(rent_mng_id, rent_l_cd, cls_st ) )	flag += 1;			
		}
	}	
				
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>
<script language='javascript'>
<%	if(!cr1_flag){  %>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>
		alert("처리되었습니다");
		parent.opener.location.href = "lc_cls_d_frame.jsp<%=valus%>";
		parent.window.close();
<%	}			%>
</script>