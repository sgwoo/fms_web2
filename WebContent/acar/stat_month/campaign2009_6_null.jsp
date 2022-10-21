<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.stat_bus.*, acar.estimate_mng.*, acar.admin.*, acar.cost.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 		//권한
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");	//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");		//로그인-영업소
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String today = AddUtil.getDate(4);
	int flag1 = 0;
	
	//영업캠페인변수 : campaign 테이블
	Hashtable ht = cmp_db.getCampaignVar();
	
	String year 		= (String)ht.get("YEAR");
	String tm 			= (String)ht.get("TM");
	String cs_dt 		= (String)ht.get("CS_DT");
	String ce_dt 		= (String)ht.get("CE_DT");
	String bs_dt 		= (String)ht.get("BS_DT");
	String be_dt 		= (String)ht.get("BE_DT");
	String bs_dt2 		= (String)ht.get("BS_DT2");
	String be_dt2 		= (String)ht.get("BE_DT2");
	int amt 			= AddUtil.parseInt((String)ht.get("AMT"));
	int bus_up_per 		= AddUtil.parseInt((String)ht.get("BUS_UP_PER"));
	int bus_down_per 	= AddUtil.parseInt((String)ht.get("BUS_DOWN_PER"));
	int mng_up_per 		= AddUtil.parseInt((String)ht.get("MNG_UP_PER"));
	int mng_down_per 	= AddUtil.parseInt((String)ht.get("MNG_DOWN_PER"));
	int bus_amt_per 	= AddUtil.parseInt((String)ht.get("BUS_AMT_PER"));
	int mng_amt_per 	= AddUtil.parseInt((String)ht.get("MNG_AMT_PER"));
	//신입사원따로 무시
	int new_bus_up_per 	= AddUtil.parseInt((String)ht.get("NEW_BUS_UP_PER"));
	int new_bus_down_per = AddUtil.parseInt((String)ht.get("NEW_BUS_DOWN_PER"));
	int new_bus_amt_per = AddUtil.parseInt((String)ht.get("NEW_BUS_AMT_PER"));
	//신입사원따로 새로
	int cnt1 			= AddUtil.parseInt((String)ht.get("CNT1"));
	int mon 			= AddUtil.parseInt((String)ht.get("MON"));
	String cnt2 		= (String)ht.get("CNT2");
	float cmp_discnt_per = AddUtil.parseFloat((String)ht.get("CMP_DISCNT_PER"));
	int car_amt 		= AddUtil.parseInt((String)ht.get("CAR_AMT"));	
	int car_amt2 		= AddUtil.parseInt((String)ht.get("CAR_AMT2"));	//1군 기준금액
	int max_dalsung 	= AddUtil.parseInt((String)ht.get("MAX_DALSUNG"));
	int max_dalsung2 	= AddUtil.parseInt((String)ht.get("MAX_DALSUNG2"));
	//할인치 부서별 가중치 부여
	int bus_ga 			= AddUtil.parseInt((String)ht.get("BUS_GA"));
	int mng_ga 			= AddUtil.parseInt((String)ht.get("MNG_GA"));
	int bus_new_ga 		= AddUtil.parseInt((String)ht.get("BUS_NEW_GA"));
	int mng_new_ga 		= AddUtil.parseInt((String)ht.get("MNG_NEW_GA"));
	String enter_dt		= (String)ht.get("ENTER_DT");
	String ns_dt1		= (String)ht.get("NS_DT1");
	String ns_dt2		= (String)ht.get("NS_DT2");
	String ns_dt3		= (String)ht.get("NS_DT3");
	String ns_dt4		= (String)ht.get("NS_DT4");
	String ne_dt1		= (String)ht.get("NE_DT1");
	String ne_dt2		= (String)ht.get("NE_DT2");
	String ne_dt3		= (String)ht.get("NE_DT3");
	String ne_dt4		= (String)ht.get("NE_DT4");
	int nm_cnt1			= AddUtil.parseInt((String)ht.get("NM_CNT1"));
	int nm_cnt2			= AddUtil.parseInt((String)ht.get("NM_CNT2"));
	int nm_cnt3			= AddUtil.parseInt((String)ht.get("NM_CNT3"));
	int nm_cnt4			= AddUtil.parseInt((String)ht.get("NM_CNT4"));
	int nb_cnt1			= AddUtil.parseInt((String)ht.get("NB_CNT1"));
	int nb_cnt2			= AddUtil.parseInt((String)ht.get("NB_CNT2"));
	int nb_cnt3			= AddUtil.parseInt((String)ht.get("NB_CNT3"));
	int nb_cnt4			= AddUtil.parseInt((String)ht.get("NB_CNT4"));
	//대수가중치
	int cnt_per			= AddUtil.parseInt((String)ht.get("CNT_PER"));
	int cost_per		= AddUtil.parseInt((String)ht.get("COST_PER"));
	int cnt_per2		= AddUtil.parseInt((String)ht.get("CNT_PER2"));   //1군
	int cost_per2		= AddUtil.parseInt((String)ht.get("COST_PER2"));  //1군
	
	//영업실적 기초정보 입력
	boolean flag = true;
	
	
	//1. 영업효율 기본정보 생성-------------------------------------------------------
	int flag2 = 0;
	//stord procedure call
	String  d_flag1 =  ac_db.call_sp_sale_cost_base_magam(today, user_id);
	if (!d_flag1.equals("0")) flag2 = 1;
	System.out.println(" 영업효율비용마감 등록 =" + d_flag1);
	//-----------------------------------------------------------------------------
	
	//2. 영업대수 기본정보 생성-------------------------------------------------------
	int flag3 = 0;
	String  d_flag2 =  ad_db.call_sp_stat_bus_cmp_base_magam();
	if (!d_flag2.equals("0")) flag3 = 1;
	System.out.println("영업대수기본마감 등록 =" + d_flag2);
	
	
	if(flag){
	
		Vector vt = new Vector();
		Vector vt2 = new Vector();
		
		//기존직원
		vt2 = cmp_db.getStatBusCmpAccountData_2009_06(ht, "");
		
		if(vt2.size()>0){
			for(int i=0; i<vt2.size(); i++){
				Hashtable ht3 = (Hashtable)vt2.elementAt(i);
				vt.add(ht3);
			}
		}
		
		
		//신입1
		if(!ns_dt1.equals("") && !ne_dt1.equals("")){
		  	if(nm_cnt1+nb_cnt1 > 0){
				vt2 = cmp_db.getStatBusCmpAccountData_2009_06(ht, "1");
				if(vt2.size()>0){
					for(int i=0; i<vt2.size(); i++){
						Hashtable ht3 = (Hashtable)vt2.elementAt(i);
						vt.add(ht3);
					}
				}
			}
		}
		//신입2
		if(!ns_dt2.equals("") && !ne_dt2.equals("")){
			if(nm_cnt2+nb_cnt2 > 0){
				vt2 = cmp_db.getStatBusCmpAccountData_2009_06(ht, "2");
				if(vt2.size()>0){
					for(int i=0; i<vt2.size(); i++){
						Hashtable ht3 = (Hashtable)vt2.elementAt(i);
						vt.add(ht3);
					}
				}
			}
		}
		//신입3
		if(!ns_dt3.equals("") && !ne_dt3.equals("")){
			if(nm_cnt3+nb_cnt3 > 0){
				vt2 = cmp_db.getStatBusCmpAccountData_2009_06(ht, "3");
				if(vt2.size()>0){
					for(int i=0; i<vt2.size(); i++){
						Hashtable ht3 = (Hashtable)vt2.elementAt(i);
						vt.add(ht3);
					}
				}
			}
		}
		//신입4
		if(!ns_dt4.equals("") && !ne_dt4.equals("")){
			if(nm_cnt4+nb_cnt4 > 0){
				vt2 = cmp_db.getStatBusCmpAccountData_2009_06(ht, "4");
				if(vt2.size()>0){
					for(int i=0; i<vt2.size(); i++){
						Hashtable ht3 = (Hashtable)vt2.elementAt(i);
						vt.add(ht3);
					}
				}
			}
		}
		out.println(vt.size());
		out.println("<br>");
		
		
		if(vt.size()>0){
		
			//오늘자 데이타 삭제
			flag  = cmp_db.deleteStatBusCmp(today);//20090401 수정할것
						
			for(int i=0; i<vt.size(); i++){
				Hashtable ht2 = (Hashtable)vt.elementAt(i);
				
				StatBusCmpBean bean = new StatBusCmpBean();
				
				bean.setSave_dt			(today);
				bean.setSeq				(AddUtil.addZero2(i));
				
				bean.setBus_id			(String.valueOf(ht2.get("BUS_ID")));
				
				bean.setRent_cnt		(String.valueOf(ht2.get("계약1")));
				bean.setStart_cnt		(String.valueOf(ht2.get("개시1")));
				bean.setCnt1			(String.valueOf(ht2.get("합계1")));
				bean.setR_rent_cnt		(String.valueOf(ht2.get("유효계약1")));
				bean.setR_start_cnt		(String.valueOf(ht2.get("유효개시1")));
				bean.setR_cnt			(String.valueOf(ht2.get("유효합계1")));
				bean.setDay				(String.valueOf(ht2.get("총일수1")));
				bean.setR_cnt2			(String.valueOf(ht2.get("일평균")));
				bean.setC_day			(String.valueOf(ht2.get("경과일수")));
				bean.setC_rent_cnt		(String.valueOf(ht2.get("계약2")));
				bean.setC_start_cnt		(String.valueOf(ht2.get("개시2")));
				bean.setC_cnt			(String.valueOf(ht2.get("합계2")));
				bean.setCr_rent_cnt		(String.valueOf(ht2.get("유효계약2")));
				bean.setCr_start_cnt	(String.valueOf(ht2.get("유효개시2")));
				bean.setCr_cnt			(String.valueOf(ht2.get("유효합계2")));
				
				bean.setSum_cnt1		(String.valueOf(ht2.get("부서소계합계1")));
				bean.setSum_r_cnt		(String.valueOf(ht2.get("부서소계유효합계1")));
				bean.setSum_bus			(String.valueOf(ht2.get("부서소계일평균")));
				bean.setAvg_cnt1		(String.valueOf(ht2.get("부서평균합계1")));
				bean.setAvg_r_cnt		(String.valueOf(ht2.get("부서평균유효합계1")));
				bean.setAvg_bus			(String.valueOf(ht2.get("부서평균일평균")));
				bean.setAvg_low_bus		(String.valueOf(ht2.get("부서최저할인치")));
				
				//2009-04 추가
				bean.setDay2			(String.valueOf(ht2.get("총일수2")));
				bean.setR_cost_cnt		(String.valueOf(ht2.get("평가기준효율실적")));
				bean.setC_cost_cnt		(String.valueOf(ht2.get("캠페인효율실적")));
				bean.setR_cnt2_1		(String.valueOf(ht2.get("일평균1")));
				bean.setR_cnt2_2		(String.valueOf(ht2.get("일평균2")));
				bean.setSum_cost_cnt	(String.valueOf(ht2.get("부서소계영업실적1")));
				bean.setSum_bus_1		(String.valueOf(ht2.get("부서소계일평균1")));
				bean.setSum_bus_2		(String.valueOf(ht2.get("부서소계일평균2")));
				bean.setAvg_cost_cnt	(String.valueOf(ht2.get("부서평균영업실적1")));
				bean.setAvg_bus_1		(String.valueOf(ht2.get("부서평균일평균1")));
				bean.setAvg_bus_2		(String.valueOf(ht2.get("부서평균일평균2")));
				
				bean.setAvg_car_cost_1	(String.valueOf(ht2.get("부서대당영업효율1")));
				bean.setAvg_car_cost_2	(String.valueOf(ht2.get("부서대당영업효율2")));
				
				bean.setR_cost_amt		(String.valueOf(ht2.get("영업효율1")));
				bean.setC_cost_amt		(String.valueOf(ht2.get("영업효율2")));
				bean.setCost_cnt1		(String.valueOf(ht2.get("영업대수1")));
				bean.setCost_cnt2		(String.valueOf(ht2.get("영업대수2")));
				
				float r_cnt2 		= AddUtil.parseFloat((String)ht2.get("일평균"));//일평균
				float avg_bus 		= AddUtil.parseFloat((String)ht2.get("부서평균일평균"));//부서평균일평균
				float low_bus 		= AddUtil.parseFloat((String)ht2.get("부서최저할인치"));//부서최저할인치
				float cmp_cnt 		= AddUtil.parseFloat((String)ht2.get("캠페인유효실적"));//캠페인유효실적
				float pre_cmp 		= 0;//할인치
				float pre_cmp_ga 	= 0;//할인치(가중치)
				
				if(String.valueOf(ht2.get("ENTER_ST")).equals("신입")){
					pre_cmp 	= r_cnt2;
					if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){
						pre_cmp_ga 	= r_cnt2*mng_new_ga/100;
					}else{
						pre_cmp_ga 	= r_cnt2*bus_new_ga/100;
					}
				}else{
					if(avg_bus < r_cnt2){
						if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){
							pre_cmp = avg_bus + (r_cnt2-avg_bus) * (AddUtil.parseFloat((String)ht.get("MNG_UP_PER"))/100);
						}else{
							pre_cmp = avg_bus + (r_cnt2-avg_bus) * (AddUtil.parseFloat((String)ht.get("BUS_UP_PER"))/100);
						}
					}else{
						if(low_bus > r_cnt2){
							pre_cmp	= low_bus;
						}else{
							pre_cmp = r_cnt2;
						}
					}
					if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){
						pre_cmp_ga 	= pre_cmp*AddUtil.parseFloat((String)ht.get("MNG_GA"))/100;
					}else{
						pre_cmp_ga 	= pre_cmp*AddUtil.parseFloat((String)ht.get("BUS_GA"))/100;
					}
				}
				pre_cmp				= AddUtil.parseFloatCipher(pre_cmp,5);
				pre_cmp_ga			= AddUtil.parseFloatCipher(pre_cmp_ga,5);
				
				float discnt_per 	= pre_cmp_ga*AddUtil.parseFloat((String)ht2.get("경과일수"));//평가기준
				discnt_per			= AddUtil.parseFloatCipher(discnt_per,2);
				
				float dalsung 		= cmp_cnt/discnt_per*100;//달성율
				dalsung				= AddUtil.parseFloatCipher(dalsung,2);
				
				bean.setPre_cmp			(String.valueOf(pre_cmp));
				bean.setPre_cmp_ga		(String.valueOf(pre_cmp_ga));
				bean.setCmp_discnt_per	(String.valueOf(discnt_per));
				bean.setOrg_dalsung		(String.valueOf(dalsung));
				
				if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){
					if(dalsung > AddUtil.parseFloat((String)ht.get("MAX_DALSUNG2"))) 	dalsung = AddUtil.parseFloat((String)ht.get("MAX_DALSUNG2"));
				}else{
					if(dalsung > AddUtil.parseFloat((String)ht.get("MAX_DALSUNG"))) 	dalsung = AddUtil.parseFloat((String)ht.get("MAX_DALSUNG"));
				}
				
				bean.setDalsung			(String.valueOf(dalsung));
				
				float gun_amt		= 0;
				
				if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){
						gun_amt = cmp_cnt*dalsung/100*AddUtil.parseFloat((String)ht.get("CAR_AMT2"));  //1군 기준금액
				} else {
						gun_amt = cmp_cnt*dalsung/100*AddUtil.parseFloat((String)ht.get("CAR_AMT")); 
				}
													
				gun_amt				= Math.round(gun_amt/1000)*1000;//천원반올림
				
				bean.setAmt				(String.valueOf(gun_amt));
				
				if(String.valueOf(ht2.get("LOAN_ST")).equals("1")){
					gun_amt 	= gun_amt*AddUtil.parseFloat((String)ht.get("MNG_AMT_PER"))/100;
				}else{
					gun_amt 	= gun_amt*AddUtil.parseFloat((String)ht.get("BUS_AMT_PER"))/100;
				}
				gun_amt				= Math.round(gun_amt/1000)*1000;//천원반올림
				
				bean.setAmt2			(String.valueOf(gun_amt));
				bean.setC_tot_cnt		(String.valueOf(cmp_cnt));
				
				//변수
				bean.setV_bs_dt			(String.valueOf(ht.get("BS_DT")));
				bean.setV_be_dt			(String.valueOf(ht.get("BE_DT")));
				bean.setV_bs_dt2		(String.valueOf(ht.get("BS_DT2")));
				bean.setV_be_dt2		(String.valueOf(ht.get("BE_DT2")));
				bean.setV_cs_dt			(String.valueOf(ht.get("CS_DT")));
				bean.setV_ce_dt			(String.valueOf(ht.get("CE_DT")));
				bean.setV_car_amt		(String.valueOf(ht.get("CAR_AMT")));
				bean.setV_bus_up_per	(String.valueOf(ht.get("BUS_UP_PER")));
				bean.setV_bus_down_per	(String.valueOf(ht.get("BUS_DOWN_PER")));
				bean.setV_mng_up_per	(String.valueOf(ht.get("MNG_UP_PER")));
				bean.setV_mng_down_per	(String.valueOf(ht.get("MNG_DOWN_PER")));
				bean.setV_bus_amt_per	(String.valueOf(ht.get("BUS_AMT_PER")));
				bean.setV_mng_amt_per	(String.valueOf(ht.get("MNG_AMT_PER")));
				bean.setV_cnt1			(String.valueOf(ht.get("CNT1")));
				bean.setV_mon			(String.valueOf(ht.get("MON")));
				bean.setV_cnt2			(String.valueOf(ht.get("CNT2")));
				bean.setV_cmp_discnt_per(String.valueOf(ht.get("CMP_DISCNT_PER")));
				bean.setV_max_dalsung	(String.valueOf(ht.get("MAX_DALSUNG")));
				bean.setV_bus_ga		(String.valueOf(ht.get("BUS_GA")));
				bean.setV_mng_ga		(String.valueOf(ht.get("MNG_GA")));
				bean.setV_bus_new_ga	(String.valueOf(ht.get("BUS_NEW_GA")));
				bean.setV_enter_dt		(String.valueOf(ht.get("ENTER_DT")));
				bean.setV_ns_dt1		(String.valueOf(ht.get("NS_DT1")));
				bean.setV_ns_dt2		(String.valueOf(ht.get("NS_DT2")));
				bean.setV_ns_dt3		(String.valueOf(ht.get("NS_DT3")));
				bean.setV_ne_dt1		(String.valueOf(ht.get("NE_DT1")));
				bean.setV_ne_dt2		(String.valueOf(ht.get("NE_DT2")));
				bean.setV_ne_dt3		(String.valueOf(ht.get("NE_DT3")));
				bean.setV_nm_cnt1		(String.valueOf(ht.get("NM_CNT1")));
				bean.setV_nm_cnt2		(String.valueOf(ht.get("NM_CNT2")));
				bean.setV_nm_cnt3		(String.valueOf(ht.get("NM_CNT3")));
				bean.setV_nb_cnt1		(String.valueOf(ht.get("NB_CNT1")));
				bean.setV_nb_cnt2		(String.valueOf(ht.get("NB_CNT2")));
				bean.setV_nb_cnt3		(String.valueOf(ht.get("NB_CNT3")));
				bean.setV_cnt_per		(String.valueOf(ht.get("CNT_PER")));
				bean.setV_cost_per		(String.valueOf(ht.get("COST_PER")));
				bean.setV_car_amt2		(String.valueOf(ht.get("CAR_AMT2")));
				bean.setV_cnt_per2		(String.valueOf(ht.get("CNT_PER2")));
				bean.setV_cost_per2		(String.valueOf(ht.get("COST_PER2")));
				bean.setV_max_dalsung2	(String.valueOf(ht.get("MAX_DALSUNG2")));
				
				if(!cmp_db.insertStatBusCmp(bean)) flag1 = 1;//20090401 수정할것
				
			}			
			
			//달성률 계산
			
			
			//평가달성률 적용
			flag  = cmp_db.updateStatBusCmpAmt(today);//20090401 수정할것
			System.out.println("영업캠페인 마감 등록");
		}
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>영업캠페인</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=today%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag1 != 0){%>
	alert('영업캠페인 마감등록 오류 발생!');
<%	}else{%>
	alert('등록되었습니다.');
	if(fm.from_page.value == ''){
		fm.action = '/acar/admin/stat_end_sc.jsp';
	}else{
		fm.action = '<%=from_page%>';
	}
	fm.submit();				
<%	}%>
</script>
</body>
</html>