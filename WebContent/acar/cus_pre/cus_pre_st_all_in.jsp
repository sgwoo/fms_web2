<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_mng.*"%>
<jsp:useBean id="sm_db" scope="page" class="acar.stat_mng.StatMngDatabase"/>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"6":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String dept_id = "";
	String dept_nm = "";
	Vector mngs1 = new Vector();
	Vector mngs2 = new Vector();
	Vector mngs3 = new Vector();
	int mng_size1 = 0;
	int mng_size2 = 0;
	int mng_size3 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//가중치 부여
	String c_o = "2";
	String c_t = "1";
	String g_o = "4.5";
	String g_t = "1";
	String b_o = "1";
	String b_t = "0.5";
	String p_o = "1";
	String p_t = "0.5";
	String cg_b1 = "0.1";
	String cg_b2 = "0.2";
	String cg_m1 = "0.7";
	String cb_b1 = "0.1";
	String cb_b2 = "0.2";
	String cb_m1 = "0";
	String cc_o = "2";
	String cc_t = "1";
	
	
	CodeBean[] depts = c_db.getCodeAll2("0002", ""); /* 코드 구분:부서명-가산점적용 */		
	int dept_size = depts.length;	
	CodeBean[] ways = c_db.getCodeAll2("0005", "Y"); /* 코드 구분:대여방식-가산점적용 */	
	int way_size = ways.length;		
	
	for(int i = 0 ; i < dept_size ; i++){
		CodeBean dept = depts[i];	
		
		c_o = am_db.getMarks(br_id, "", "1", "0", "0001", "1");
		c_t = am_db.getMarks(br_id, "", "2", "0", "0001", "1");
		g_o = am_db.getMarks(br_id, dept.getCode(), "1", "1", "0001", "2");
		g_t = am_db.getMarks(br_id, dept.getCode(), "2", "1", "0001", "2");
		p_o = am_db.getMarks(br_id, dept.getCode(), "1", "2", "0001", "2");
		p_t = am_db.getMarks(br_id, dept.getCode(), "2", "2", "0001", "2");
		b_o = am_db.getMarks(br_id, dept.getCode(), "1", "3", "0001", "2");
		b_t = am_db.getMarks(br_id, dept.getCode(), "2", "3", "0001", "2");
		cg_b1 = am_db.getMarks(br_id, "", "3", "1", "0001", "1");
		cg_b2 = am_db.getMarks(br_id, "", "4", "1", "0001", "1");
		cg_m1 = am_db.getMarks(br_id, "", "5", "1", "0001", "1");
		cb_b1 = am_db.getMarks(br_id, "", "3", "9", "0001", "1");
		cb_b2 = am_db.getMarks(br_id, "", "4", "9", "0001", "1");
		cb_m1 = am_db.getMarks(br_id, "", "5", "9", "0001", "1");
		cc_o = am_db.getMarks(br_id, "", "1", "0", "0001", "1");
		cc_t = am_db.getMarks(br_id, "", "2", "0", "0001", "1");
		
		/*사원별 관리현황*/
		if(dept.getCode().equals("0002")){//관리팀
			dept_id = "0002";
			mngs1 = sm_db.getStatMng6(br_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size1 = mngs1.size();		
//			out.println(c_o+" "+c_t+" "+g_o+" "+g_t+" "+b_o+" "+b_t+" "+p_o+" "+p_t+"<br>");
		}else if(dept.getCode().equals("0001")){//영업팀
			dept_id = "0001";
			mngs2 = sm_db.getStatMng6(br_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
//			out.println(c_o+" "+c_t+" "+g_o+" "+g_t+" "+b_o+" "+b_t+" "+p_o+" "+p_t+"<br>");			
			mng_size2 = mngs2.size();
		}else if(dept.getCode().equals("0004")){//임원
			g_o = am_db.getMarks(br_id, "0001", "1", "1", "0001", "2");
			g_t = am_db.getMarks(br_id, "0001", "2", "1", "0001", "2");
			p_o = am_db.getMarks(br_id, "0001", "1", "2", "0001", "2");
			p_t = am_db.getMarks(br_id, "0001", "2", "2", "0001", "2");
			b_o = am_db.getMarks(br_id, "0001", "1", "3", "0001", "2");
			b_t = am_db.getMarks(br_id, "0001", "2", "3", "0001", "2");
			dept_id = "0004";
			mngs3 = sm_db.getStatMng6(br_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
//			out.println(c_o+" "+c_t+" "+g_o+" "+g_t+" "+b_o+" "+b_t+" "+p_o+" "+p_t+"<br>");			
			mng_size3 = mngs3.size();
		}
	}
	
	//가산점 출력
	int aaa = AddUtil.parseInt(save_dt);
	if(aaa > 0 && aaa < 20040101){
		cg_b1 = "0.15";
		cg_b2 = "0.1";
		cg_m1 = "0.55";
		cb_b1 = "0.15";
		cb_b2 = "0.1";
		cb_m1 = "0";
		cc_o = "0.2";
		cc_t = "0.1";
	}else if(aaa >=20040101 && aaa <=20040427){
		cg_b1 = "0.17";
		cg_b2 = "0.08";
		cg_m1 = "0.55";
		cb_b1 = "0.17";
		cb_b2 = "0.08";
		cb_m1 = "0";
		cc_o = "0.2";
		cc_t = "0.1";
	}else if(aaa >=20040428){
		cg_b1 = "0.2";
		cg_b2 = "0.1";
		cg_m1 = "0.55";
		cb_b1 = "0.2";
		cb_b2 = "0.1";
		cb_m1 = "0";
		cc_o = "0.15";
		cc_t = "0.075";
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
-->
</script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;	
		if(fm.save_dt.value != ''){ alert("이미 마감 등록된 사원별 관리현황입니다."); return; }
		if(!confirm('마감하시겠습니까?'))
			return;
		fm.target='i_no';
		fm.action='stat_mng_sc_null.jsp';
		fm.submit();		
	}	

	//처음 셋팅하기
	function set_sum(){
		var fm = document.form1;	
		var size1 = toInt(fm.mng_size1.value);
		var size2 = toInt(fm.mng_size2.value);
		var size3 = toInt(fm.mng_size3.value);		
		var t_size1 = size1+size2;
		var t_size2 = size1+size2+size3;

		//평점계산
		if(fm.save_dt.value == ''){
			for(i=0; i<t_size2; i++){
				fm.cnt_b1_ga[i].value 	= toFloat(fm.cg_cnt_b1[i].value) * toFloat(fm.cg_b1.value) + toFloat(fm.cb_cnt_b1[i].value) * toFloat(fm.cb_b1.value);
				fm.cnt_b1_ga[i].value  	= parseFloatCipher3(fm.cnt_b1_ga[i].value, 2);
				fm.cnt_b2_ga[i].value 	= toFloat(fm.cg_cnt_b2[i].value) * toFloat(fm.cg_b2.value) + toFloat(fm.cb_cnt_b2[i].value) * toFloat(fm.cb_b2.value);
				fm.cnt_b2_ga[i].value  	= parseFloatCipher3(fm.cnt_b2_ga[i].value, 2);
				fm.cnt_m1_ga[i].value 	= toFloat(fm.cg_cnt_m1[i].value) * toFloat(fm.cg_m1.value);
				fm.cnt_m1_ga[i].value  	= parseFloatCipher3(fm.cnt_m1_ga[i].value, 2);			
				fm.c_ga[i].value  		= toFloat(fm.c_cnt_o[i].value) * toFloat(fm.cc_o.value) + toFloat(fm.c_cnt_t[i].value) * toFloat(fm.cc_t.value);			
				fm.c_ga[i].value  		= parseFloatCipher3(fm.c_ga[i].value, 2);						
			}
		}

		//총평점계산
		for(i=0; i<size1+size2+size3 ; i++){
			fm.tot_ga[i].value	= toFloat(fm.cnt_b1_ga[i].value) + toFloat(fm.cnt_b2_ga[i].value) + toFloat(fm.cnt_m1_ga[i].value) + toFloat(fm.c_ga[i].value);
			fm.tot_ga[i].value  = parseFloatCipher3(fm.tot_ga[i].value, 2);
		}		

		//고객지원팀 소계
		for(i=0; i<size1; i++){				
			fm.hc_cnt[0].value		= toInt(fm.hc_cnt[0].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[0].value	= toInt(fm.hc_cnt_o[0].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[0].value	= toInt(fm.hc_cnt_t[0].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[0].value	= toInt(fm.hcg_cnt_b1[0].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[0].value	= toInt(fm.hcg_cnt_b2[0].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[0].value	= toInt(fm.hcg_cnt_m1[0].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[0].value	= toInt(fm.hcb_cnt_b1[0].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[0].value	= toInt(fm.hcb_cnt_b2[0].value) + toInt(fm.cb_cnt_b2[i].value);
			
			fm.htot_ga[0].value		= toFloat(fm.htot_ga[0].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[0].value	= toFloat(fm.h_cnt_b1_ga[0].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[0].value	= toFloat(fm.h_cnt_b2_ga[0].value) + toFloat(fm.cnt_b2_ga[i].value);						
			fm.h_cnt_m1_ga[0].value	= toFloat(fm.h_cnt_m1_ga[0].value) + toFloat(fm.cnt_m1_ga[i].value);									
			fm.hc_ga[0].value		= toFloat(fm.hc_ga[0].value) + toFloat(fm.c_ga[i].value);						
		}
		fm.htot_ga[0].value 	= parseFloatCipher3(toFloat(fm.htot_ga[0].value)/size1, 2);
		fm.h_cnt_b1_ga[0].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[0].value)/size1, 2);
		fm.h_cnt_b2_ga[0].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[0].value)/size1, 2);				
		fm.h_cnt_m1_ga[0].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[0].value)/size1, 2);				
		fm.hc_ga[0].value 		= parseFloatCipher3(toFloat(fm.hc_ga[0].value)/size1, 2);
		fm.h_cnt_b1[0].value	= toInt(fm.hcg_cnt_b1[0].value) + toInt(fm.hcb_cnt_b1[0].value);		
		fm.h_cnt_b2[0].value	= toInt(fm.hcg_cnt_b2[0].value) + toInt(fm.hcb_cnt_b1[0].value);		
		//평점구성비 계산	
		fm.htot_ga_p[0].value = 100;		
		fm.h_cnt_b1_ga_p[0].value = Math.round(toFloat(fm.h_cnt_b1_ga[0].value) / toFloat(fm.htot_ga[0].value)*100);		
		fm.h_cnt_b2_ga_p[0].value = Math.round(toFloat(fm.h_cnt_b2_ga[0].value) / toFloat(fm.htot_ga[0].value)*100);		
		fm.h_cnt_m1_ga_p[0].value = Math.round(toFloat(fm.h_cnt_m1_ga[0].value) / toFloat(fm.htot_ga[0].value)*100);		
//		fm.hc_ga_p[0].value = Math.round(toFloat(fm.hc_ga[0].value) / toFloat(fm.htot_ga[0].value)*100);								
		fm.hc_ga_p[0].value = toInt(fm.htot_ga_p[0].value)-toInt(fm.h_cnt_b1_ga_p[0].value)-toInt(fm.h_cnt_b2_ga_p[0].value)-toInt(fm.h_cnt_m1_ga_p[0].value);
		
		//영업팀 소계
		for(i=size1; i<size1+size2; i++){	
			fm.hc_cnt[1].value	= toInt(fm.hc_cnt[1].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[1].value= toInt(fm.hc_cnt_o[1].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[1].value= toInt(fm.hc_cnt_t[1].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[1].value= toInt(fm.hcg_cnt_b1[1].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[1].value= toInt(fm.hcg_cnt_b2[1].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[1].value= toInt(fm.hcg_cnt_m1[1].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[1].value= toInt(fm.hcb_cnt_b1[1].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[1].value= toInt(fm.hcb_cnt_b2[1].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[1].value	= toFloat(fm.htot_ga[1].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[1].value	= toFloat(fm.h_cnt_b1_ga[1].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[1].value	= toFloat(fm.h_cnt_b2_ga[1].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[1].value	= toFloat(fm.h_cnt_m1_ga[1].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[1].value	= toFloat(fm.hc_ga[1].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[1].value = parseFloatCipher3(toFloat(fm.htot_ga[1].value)/size2, 2);
		fm.h_cnt_b1_ga[1].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[1].value)/size2, 2);
		fm.h_cnt_b2_ga[1].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[1].value)/size2, 2);				
		fm.h_cnt_m1_ga[1].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[1].value)/size2, 2);						
		fm.hc_ga[1].value 	= parseFloatCipher3(toFloat(fm.hc_ga[1].value)/size2, 2);
		fm.h_cnt_b1[1].value	= toInt(fm.hcg_cnt_b1[1].value) + toInt(fm.hcb_cnt_b1[1].value);		
		fm.h_cnt_b2[1].value	= toInt(fm.hcg_cnt_b2[1].value) + toInt(fm.hcb_cnt_b1[1].value);		
		//평점구성비 계산	
		fm.htot_ga_p[1].value = 100;		
		fm.h_cnt_b1_ga_p[1].value = Math.round(toFloat(fm.h_cnt_b1_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);		
		fm.h_cnt_b2_ga_p[1].value = Math.round(toFloat(fm.h_cnt_b2_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);		
		fm.h_cnt_m1_ga_p[1].value = Math.round(toFloat(fm.h_cnt_m1_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);		
//		fm.hc_ga_p[1].value = Math.round(toFloat(fm.hc_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);								
		fm.hc_ga_p[1].value = toInt(fm.htot_ga_p[1].value)-toInt(fm.h_cnt_b1_ga_p[1].value)-toInt(fm.h_cnt_b2_ga_p[1].value)-toInt(fm.h_cnt_m1_ga_p[1].value);

		//총계
		for(i=0; i<size1+size2+size3 ; i++){
			fm.htot_ga[2].value		= toFloat(fm.htot_ga[2].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[2].value	= toFloat(fm.h_cnt_b1_ga[2].value) + toFloat(fm.cnt_b1_ga[i].value);
			fm.h_cnt_b2_ga[2].value	= toFloat(fm.h_cnt_b2_ga[2].value) + toFloat(fm.cnt_b2_ga[i].value);
			fm.h_cnt_m1_ga[2].value	= toFloat(fm.h_cnt_m1_ga[2].value) + toFloat(fm.cnt_m1_ga[i].value);			
			fm.hc_ga[2].value		= toFloat(fm.hc_ga[2].value) + toFloat(fm.c_ga[i].value);
		}		
		fm.htot_ga[2].value 	= parseFloatCipher3(toFloat(fm.htot_ga[2].value)/t_size2, 2);
		fm.h_cnt_b1_ga[2].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[2].value)/t_size2, 2);
		fm.h_cnt_b2_ga[2].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[2].value)/t_size2, 2);				
		fm.h_cnt_m1_ga[2].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[2].value)/t_size2, 2);						
		fm.hc_ga[2].value 		= parseFloatCipher3(toFloat(fm.hc_ga[2].value)/t_size2, 2);

		fm.hc_cnt[2].value	= toInt(fm.hc_cnt[1].value) + toInt(fm.hc_cnt[0].value);
		fm.hc_cnt_o[2].value= toInt(fm.hc_cnt_o[1].value) + toInt(fm.hc_cnt_o[0].value);
		fm.hc_cnt_t[2].value= toInt(fm.hc_cnt_t[1].value) + toInt(fm.hc_cnt_t[0].value);				
		fm.hcg_cnt_b1[2].value= toInt(fm.hcg_cnt_b1[1].value) + toInt(fm.hcg_cnt_b1[0].value);		
		fm.hcg_cnt_b2[2].value= toInt(fm.hcg_cnt_b2[1].value) + toInt(fm.hcg_cnt_b2[0].value);		
		fm.hcg_cnt_m1[2].value= toInt(fm.hcg_cnt_m1[1].value) + toInt(fm.hcg_cnt_m1[0].value);		
		fm.hcb_cnt_b1[2].value= toInt(fm.hcb_cnt_b1[1].value) + toInt(fm.hcb_cnt_b1[0].value);		
		fm.hcb_cnt_b2[2].value= toInt(fm.hcb_cnt_b2[1].value) + toInt(fm.hcb_cnt_b2[0].value);								

		for(i=size1+size2; i<size1+size2+size3; i++){				
			fm.hc_cnt[2].value		= toInt(fm.hc_cnt[2].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[2].value	= toInt(fm.hc_cnt_o[2].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[2].value	= toInt(fm.hc_cnt_t[2].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[2].value	= toInt(fm.hcg_cnt_b1[2].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[2].value	= toInt(fm.hcg_cnt_b2[2].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[2].value	= toInt(fm.hcg_cnt_m1[2].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[2].value	= toInt(fm.hcb_cnt_b1[2].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[2].value	= toInt(fm.hcb_cnt_b2[2].value) + toInt(fm.cb_cnt_b2[i].value);
		}
		fm.h_cnt_b1[2].value	= toInt(fm.hcg_cnt_b1[2].value) + toInt(fm.hcb_cnt_b1[2].value);		
		fm.h_cnt_b2[2].value	= toInt(fm.hcg_cnt_b2[2].value) + toInt(fm.hcb_cnt_b1[2].value);							
		//평점구성비 계산	
		fm.htot_ga_p[2].value = 100;		
		fm.h_cnt_b1_ga_p[2].value = Math.round(toFloat(fm.h_cnt_b1_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);		
		fm.h_cnt_b2_ga_p[2].value = Math.round(toFloat(fm.h_cnt_b2_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);		
		fm.h_cnt_m1_ga_p[2].value = Math.round(toFloat(fm.h_cnt_m1_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);		
//		fm.hc_ga_p[2].value = Math.round(toFloat(fm.hc_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);										
		fm.hc_ga_p[2].value = toInt(fm.htot_ga_p[2].value)-toInt(fm.h_cnt_b1_ga_p[2].value)-toInt(fm.h_cnt_b2_ga_p[2].value)-toInt(fm.h_cnt_m1_ga_p[2].value);		
	}	

	//세부리스트 이동
	function move_list(dept_id, user_id, mng_way, mng_st){	
		var fm = document.form1;
		fm.s_dept.value = dept_id;
		fm.s_user.value = user_id;		
		fm.s_mng_way.value = mng_way;
		fm.s_mng_st.value = mng_st;
		if(mng_way == '0'){
			fm.action = "stat_mng_client_frame_s.jsp?";
		}else{
			fm.action = "stat_mng_car_frame_s.jsp";
		}
		fm.target='d_content';
		fm.submit();		
	}
-->
</script>
<!--<link rel=stylesheet type="text/css" href="../../include/table.css">-->
<link rel=stylesheet type="text/css" href="/include/index.css">
</head>
<body onLoad="javascript:init()">
<form action="/acar/admin/stat_mng_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mng_size1' value='<%=mng_size1%>'>
<input type='hidden' name='mng_size2' value='<%=mng_size2%>'>
<input type='hidden' name='mng_size3' value='<%=mng_size3%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr id='tr_title' style='position:relative;z-index:1'>
	  <td  width='280' id='td_title' style='position:relative;'> <table width="300" border="0" cellspacing="1" cellpadding="1" bgcolor="#000000" height="61">
          <tr align="center" valign="middle" bgcolor="#6784ba"> 
            <td width="70"><font color="#FFFFFF">부서</font></td>
            <td width="20"><font color="#FFFFFF">연번</font></td>
            <td width="60"><font color="#FFFFFF">성명</font></td>
            <td width="80"><font color="#FFFFFF">입사일자</font></td>
            <td width="70"><font color="#FFFFFF">총평점</font></td>
          </tr>
        </table></td>
	<td width='750'>
	    <table width='700' border="0" cellspacing="1" cellpadding="1" bgcolor="#000000" height="61">
          <tr bgcolor="#6784ba" align="center"> 
            <td class=title colspan="4"><font color="#FFFFFF">최초영업</font></td>
            <td class=title colspan="4"><font color="#FFFFFF">영업관리</font></td>
            <td class=title colspan="2"><font color="#FFFFFF">정비관리</font></td>
            <td class=title colspan="4"><font color="#FFFFFF">업체관리</font></td>
          </tr>
          <tr bgcolor="#6784ba" align="center"> 
            <td class=title width="50"><font color="#FFFFFF">일반식</font></td>
            <td class=title width="50"><font color="#FFFFFF">기본식<br>
              맞춤식</font></td>
            <td class=title width="50"><font color="#FFFFFF">합계</font></td>
            <td class=title width="50"><font color="#FFFFFF">평점</font></td>
            <td class=title width="50"><font color="#FFFFFF">일반식</font></td>
            <td class=title width="50"><font color="#FFFFFF">기본식<br>
              맞춤식</font></td>
            <td class=title width="50"><font color="#FFFFFF">합계</font></td>
            <td class=title width="50"><font color="#FFFFFF">평점</font></td>
            <td class=title width="50"><font color="#FFFFFF">일반식</font></td>
            <td class=title width="50"><font color="#FFFFFF">평점</font></td>
            <td class=title width="50"><font color="#FFFFFF">단독</font></td>
            <td class=title width="50"><font color="#FFFFFF">공동</font></td>
            <td class=title width="50"><font color="#FFFFFF">계</font></td>
            <td class=title width="50"><font color="#FFFFFF">평점</font></td>
          </tr>
        </table>
	</td>
  </tr>  			  
  <!--총평점-->
  <tr>
	  <td class='line' width='280' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width='300' bgcolor="#000000">
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="4" height="20">가중치</td>
            <td class="is" align="center" height="20" width="67"> -</td>
          </tr>
          <%for (int i = 0 ; i < mng_size1 ; i++){
				StatMngBean bean1 = (StatMngBean)mngs1.elementAt(i);
				dept_nm = bean1.getDept_nm();%>
          <tr bgcolor="#FFFFFF"> 
            <input type='hidden' name='mng_id' value='<%=bean1.getUser_id()%>'>
            <%	if(i==0){%>
            <td align="center" width="69"  rowspan="<%=mng_size1%>" height="20"><%=bean1.getDept_nm()%></td>
            <%	}else{}%>
            <td align="center" width="21" height="20"><%=i+1%></td>
            <td align="center" width="59" height="20"><%=bean1.getUser_nm()%></td>
            <td align="center" width="78" height="20"><%=AddUtil.ChangeDate2(bean1.getEnter_dt())%> </td>
            <td align="center" width="67" height="20"> <input type="text" name="tot_ga" value=""  size="4"  class="whitenum"> 
            </td>
          </tr>
          <%}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="4" height="20"><%=dept_nm%> 합계/평점 평균</td>
            <td class="is" align="center" height="20" width="67"> <input type="text" name="htot_ga" value=""  size="4"  class="whitenum"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" colspan="4" height="20"><%=dept_nm%> 평점구성비</td>
            <td class="is" align="center" height="20" width="67"> <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">
              % </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="star" align="center" colspan="4" height="20">총합계/평점 평균</td>
            <td class="star" align="center" height="20" width="67"> <input type="text" name="htot_ga" value=""  size="4"  class="whitenum"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="star" align="center" colspan="4" height="20">총평점구성비</td>
            <td class="star" align="center" height="20" width="67"> <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">
              % </td>
          </tr>
        </table></td>
	<td class='line' width='750'>
	    <table border="0" cellspacing="1" cellpadding="0" width='700' bgcolor="#000000">
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="49"><input type="text" name="cg_b1" value="<%=cg_b1%>"  size="4"  class="whitenum"></td>
            <td class="is" align="center" height="20" width="47"><input type="text" name="cb_b1" value="<%=cb_b1%>"  size="4"  class="whitenum"></td>
            <td class="is" align="center" height="20" width="49">-</td>
            <td class="is" align="center" height="20" width="49">-</td>
            <td class="is" align="center" height="20" width="47"><input type="text" name="cg_b2" value="<%=cg_b2%>"  size="4"  class="whitenum"></td>
            <td class="is" align="center" height="20" width="47"><input type="text" name="cb_b2" value="<%=cb_b2%>"  size="4"  class="whitenum"></td>
            <td class="is" align="center" height="20" width="47">-</td>
            <td class="is" align="center" height="20" width="49">-</td>
            <td class="is" align="center" height="20" width="47"><input type="text" name="cg_m1" value="<%=cg_m1%>"  size="4"  class="whitenum"></td>
            <td class="is" align="center" height="20" width="56">-</td>
            <td class="is" align="center" height="20" width="49"><input type="text" name="cc_o" value="<%=cc_o%>"  size="4"  class="whitenum"></td>
            <td class="is" align="center" height="20" width="49"><input type="text" name="cc_t" value="<%=cc_t%>"  size="4"  class="whitenum"></td>
            <td class="is" align="center" height="20" width="49">-</td>
            <td class="is" align="center" height="20" width="49">-</td>
          </tr>
  <!--세부평점-->		  
          <%for (int i = 0 ; i < mng_size1 ; i++){
				StatMngBean bean1 = (StatMngBean)mngs1.elementAt(i);%>
          <tr bgcolor="#FFFFFF"> 
            <td align="center" width="49" height="20"> 
              <input type="text" name="cg_cnt_b1" value="<%=bean1.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '3');">
            </td>
            <td align="center" width="47" height="20"> 
              <input type="text" name="cb_cnt_b1" value="<%=bean1.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '9', '3');">
            </td>
            <td align="center" width="49" height="20"> 
              <input type="text" name="cnt_b1" value="<%=bean1.getC_Gen_cnt_b1()+bean1.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '3');">
            </td>
            <td align="center" width="49" height="20"> 
              <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean1.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
            </td>
            <td align="center" width="47" height="20"> 
              <input type="text" name="cg_cnt_b2" value="<%=bean1.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '4');">
            </td>
            <td align="center" width="47" height="20"> 
              <input type="text" name="cb_cnt_b2" value="<%=bean1.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '9', '4');">
            </td>
            <td align="center" width="47" height="20"> 
              <input type="text" name="cnt_b2" value="<%=bean1.getC_Gen_cnt_b2()+bean1.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '4');">
            </td>
            <td align="center" width="49" height="20"> 
              <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean1.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
            </td>
            <td align="center" width="47" height="20"> 
              <input type="text" name="cg_cnt_m1" value="<%=bean1.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '5');">
            </td>
            <td align="center" width="56" height="20"> 
              <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean1.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '9', '5');">
            </td>
            <td align="center" width="49" height="20"> 
              <input type="text" name="c_cnt_o" value="<%=bean1.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '0', '1');">
            </td>
            <td align="center" width="49" height="20"> 
              <input type="text" name="c_cnt_t" value="<%=bean1.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '0', '2');">
            </td>
            <td align="center" width="49" height="20"> 
              <input type="text" name="c_cnt" value="<%=bean1.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '0', '0');">
            </td>
            <td align="center" width="49" height="20"> 
              <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean1.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
            </td>
          </tr>
          <%}%>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="47"> 
              <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="47"> 
              <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="47"> 
              <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="47"> 
              <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="47"> 
              <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="56"> 
              <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="is" align="center" height="20" width="49"> 
              -
            </td>
            <td class="is" align="center" height="20" width="47"> 
              -
            </td>
            <td class="is" align="center" height="20" width="49"> 
              -
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
            </td>
            <td class="is" align="center" height="20" width="47"> 
              -
            </td>
            <td class="is" align="center" height="20" width="47"> 
              -
            </td>
            <td class="is" align="center" height="20" width="47"> 
              -
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
            </td>
            <td class="is" align="center" height="20" width="47"> 
              -
            </td>
            <td class="is" align="center" height="20" width="56"> 
              <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
            </td>
            <td class="is" align="center" height="20" width="49"> 
              -
            </td>
            <td class="is" align="center" height="20" width="49"> 
              -
            </td>
            <td class="is" align="center" height="20" width="49"> 
              -
            </td>
            <td class="is" align="center" height="20" width="49"> 
              <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="47"> 
              <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="47"> 
              <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="47"> 
              <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="47"> 
              <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="47"> 
              <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="56"> 
              <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td class="star" align="center" height="20" width="49"> 
              -
            </td>
            <td class="star" align="center" height="20" width="47"> 
              -
            </td>
            <td class="star" align="center" height="20" width="49"> 
              -
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
            </td>
            <td class="star" align="center" height="20" width="47"> 
              -
            </td>
            <td class="star" align="center" height="20" width="47"> 
              -
            </td>
            <td class="star" align="center" height="20" width="47"> 
              -
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
            </td>
            <td class="star" align="center" height="20" width="47"> 
              -
            </td>
            <td class="star" align="center" height="20" width="56"> 
              <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
            </td>
            <td class="star" align="center" height="20" width="49"> 
              -
            </td>
            <td class="star" align="center" height="20" width="49"> 
              -
            </td>
            <td class="star" align="center" height="20" width="49"> 
              -
            </td>
            <td class="star" align="center" height="20" width="49"> 
              <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
            </td>
          </tr>
        </table>
	  </td>
	</tr>
<!--
  <tr>
	<td width='470' id='td_con' style='position:relative;'>			
      <table border="0" cellspacing="1" cellpadding="0" width='470'>
        <tr>
		  <td><font color="#FF00FF">♣</font> 관리업체 가중치 부여 방법 : 업체수당 단독=<%=c_o%>점, 공동=<%=c_t%>점</td>
		</tr>
        <tr>
		  <td><font color="#FF00FF">♣</font> 관리구분 가중치 부여 방법 : 일반식은 대수당 단독=<%=g_o%>점, 공동-고객지원팀=<%=g_t%>점,</td>
		</tr>		
	  </table>
	</td>
	<td width='550'>
	    <table border="0" cellspacing="1" cellpadding="0" width='550'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
          <tr>
		  <td> 공동-영업팀=<%=g_t%>점, 맞춤식o기본식은 대수당 <%=b_o%>점 부여 / 공동관리는 단독관리의 50%</td>
		</tr>		
	  </table>
	</td>
  </tr>	
-->  
</table>		
</form>
<script language='javascript'>
<!--
	set_sum();
//-->
</script>
</body>
</html>

