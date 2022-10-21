<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.cls.*, acar.cont.*, acar.credit.*, acar.user_mng.*"%>
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
	
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");

	int    scd_size 	= request.getParameter("vt_size8")		==null?0 :AddUtil.parseInt(request.getParameter("vt_size8"));  //중도매입옵션시 잔여대여료 스케쥴 갯수 
			
	int flag = 0;
		
	
	//중도매입옵션관련 추가 - 20161028 - 부가세 끝전 
		
	//삭제후 	
		if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_detail"))	flag += 1; //기안문서
								
		
		String value0[]  = request.getParameterValues("s_fee_tm");
		String value1[]  = request.getParameterValues("s_r_fee_est_dt");
		String value2[]  = request.getParameterValues("s_fee_s_amt");
		String value3[]  = request.getParameterValues("s_tax_amt");
		String value4[]  = request.getParameterValues("s_is_amt");
		String value5[]  = request.getParameterValues("s_cal_amt");
		String value6[]  = request.getParameterValues("s_r_fee_s_amt");
		String value7[]  = request.getParameterValues("s_r_fee_v_amt");
		String value8[]  = request.getParameterValues("s_r_fee_amt");
		String value9[]  = request.getParameterValues("s_rc_rate");
		String value10[]  = request.getParameterValues("s_cal_days");						
		
			
		for(int i=0 ; i < scd_size ; i++){
			
			int s_fee_tm = value0[i]	==null?0 :AddUtil.parseDigit(value0[i]);   //회차 
			int s_fee_s_amt = value2[i]	==null?0 :AddUtil.parseDigit(value2[i]);  //월대여료 
			int s_tax_amt = value3[i]	==null?0 :AddUtil.parseDigit(value3[i]); //자동차세  
			int s_is_amt = value4[i]	==null?0 :AddUtil.parseDigit(value4[i]); // 보험료 + 정비비용 
			int s_cal_amt = value5[i]	==null?0 :AddUtil.parseDigit(value5[i]);  // 제외요금 
			int s_r_fee_s_amt = value6[i]	==null?0 :AddUtil.parseDigit(value6[i]); //현재가치 공급가 
			int s_r_fee_v_amt = value7[i]	==null?0 :AddUtil.parseDigit(value7[i]); //현재가치 부가세 
			int s_r_fee_amt = value8[i]	==null?0 :AddUtil.parseDigit(value8[i]);   //현재가치 금액 
			float s_rc_rate = value9[i]	==null?0 :AddUtil.parseFloat(value9[i]);   //현재가치율 
			int s_cal_days = value10[i]	==null?0 :AddUtil.parseDigit(value10[i]);	//경과일수 	  	
			
			if(s_fee_tm > 0){
						
						//중도매입옵션 중도정산서저장
						ClsEtcDetailBean clsd = new ClsEtcDetailBean();
		
						clsd.setRent_mng_id(rent_mng_id);
						clsd.setRent_l_cd(rent_l_cd);
						clsd.setS_fee_tm(s_fee_tm); //회차
						clsd.setS_r_fee_est_dt(value1[i]); //납입할날짜 			
						clsd.setS_fee_s_amt(s_fee_s_amt); //월대여료
						clsd.setS_tax_amt(s_tax_amt);   //자동차세
						clsd.setS_is_amt(s_is_amt);  //보험료 + 정비비용 
						clsd.setS_cal_amt(s_cal_amt); //계산금액
						clsd.setS_r_fee_s_amt(s_r_fee_s_amt);   //현재가치율 반영 공급가 
						clsd.setS_r_fee_v_amt(s_r_fee_v_amt);   //현재가치율 반영 부가세 
						clsd.setS_r_fee_amt(s_r_fee_amt); //현재가치율 합계 
						clsd.setS_rc_rate(s_rc_rate); //현재가치율
						clsd.setS_cal_days(s_cal_days); //경과일수
															
						//해지의뢰서브내역 저장						
						if(!ac_db.insertClsEtcDetail(clsd))	flag += 1;									
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
		parent.opener.location.href = "lc_cls_off_d_frame.jsp<%=valus%>";
		parent.window.close();
<%	}			%>
</script>