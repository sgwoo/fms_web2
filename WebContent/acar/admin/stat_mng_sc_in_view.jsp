<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_mng.*"%>
<jsp:useBean id="sm_db" scope="page" class="acar.stat_mng.StatMngDatabase"/>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"6":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = "";
	String dept_nm = "";
	Vector mngs1 = new Vector();
	Vector mngs2 = new Vector();
	Vector mngs3 = new Vector();
	Vector mngs4 = new Vector(); //부산
	Vector mngs5 = new Vector(); //대전
	Vector mngs6 = new Vector();  //강남
	Vector mngs7 = new Vector(); //광주지점
	Vector mngs8 = new Vector(); //대구지점
	Vector mngs9= new Vector(); //인천지점
	Vector mngs10= new Vector(); //수원지점 - 20140122추가
	Vector mngs11= new Vector(); //울산지점 - 20140922추가
	Vector mngs12= new Vector(); //광화문지점 - 20140922추가
	Vector mngs13= new Vector(); //송파지점 - 20140922추가	
						
	int mng_size1 = 0;
	int mng_size2 = 0;
	int mng_size3 = 0;
	int mng_size4 = 0;
	int mng_size5 = 0;
	int mng_size6 = 0;
	int mng_size7 = 0;
	int mng_size8 = 0;
	int mng_size9 = 0;
	int mng_size10 = 0;
	int mng_size11 = 0;
	int mng_size12 = 0;
	int mng_size13 = 0;
	
	// out.println("brch_id=" + brch_id);
	
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
		
		c_o = am_db.getMarks("S1", "", "1", "0", "0001", "1");
		c_t = am_db.getMarks("S1", "", "2", "0", "0001", "1");
		
		//지점관련 가중치는 일단 영업팀 - 2007-06-27 추 후 등록
		if(dept.getCode().equals("0001") || dept.getCode().equals("0007") || dept.getCode().equals("0008") || dept.getCode().equals("0009")|| dept.getCode().equals("0010")|| dept.getCode().equals("0011") || dept.getCode().equals("0012")  || dept.getCode().equals("0013")  || dept.getCode().equals("0016")  || dept.getCode().equals("0017") ||  dept.getCode().equals("0018") ){ //영업팀
			
			g_o = am_db.getMarks("S1", "0001", "1", "1", "0001", "2");
			g_t = am_db.getMarks("S1", "0001", "2", "1", "0001", "2");
			p_o = am_db.getMarks("S1", "0001", "1", "2", "0001", "2");
			p_t = am_db.getMarks("S1", "0001", "2", "2", "0001", "2");
			b_o = am_db.getMarks("S1", "0001", "1", "3", "0001", "2");
			b_t = am_db.getMarks("S1", "0001", "2", "3", "0001", "2");
		} else {
			g_o = am_db.getMarks("S1", dept.getCode(), "1", "1", "0001", "2");
			g_t = am_db.getMarks("S1", dept.getCode(), "2", "1", "0001", "2");
			p_o = am_db.getMarks("S1", dept.getCode(), "1", "2", "0001", "2");
			p_t = am_db.getMarks("S1", dept.getCode(), "2", "2", "0001", "2");
			b_o = am_db.getMarks("S1", dept.getCode(), "1", "3", "0001", "2");
			b_t = am_db.getMarks("S1", dept.getCode(), "2", "3", "0001", "2");
			
		}
		
		cg_b1 = am_db.getMarks("S1", "", "3", "1", "0001", "1");
		cg_b2 = am_db.getMarks("S1", "", "4", "1", "0001", "1");
		cg_m1 = am_db.getMarks("S1", "", "5", "1", "0001", "1");
		cb_b1 = am_db.getMarks("S1", "", "3", "9", "0001", "1");
		cb_b2 = am_db.getMarks("S1", "", "4", "9", "0001", "1");
		cb_m1 = am_db.getMarks("S1", "", "5", "9", "0001", "1");
		cc_o = am_db.getMarks("S1", "", "1", "0", "0001", "1");
		cc_t = am_db.getMarks("S1", "", "2", "0", "0001", "1");
		
		
		/*사원별 관리현황*/
		if(dept.getCode().equals("0002")){//관리팀
			dept_id = "0002";
			mngs1 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size1 = mngs1.size();		
		}else if(dept.getCode().equals("0001")){//영업팀
			dept_id = "0001";
			mngs2 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size2 = mngs2.size();
	//	}else if(dept.getCode().equals("0004")){//임원
			
	//		g_o = am_db.getMarks("S1", "0001", "1", "1", "0001", "2");
	//		g_t = am_db.getMarks("S1", "0001", "2", "1", "0001", "2");
	//		p_o = am_db.getMarks("S1", "0001", "1", "2", "0001", "2");
	//		p_t = am_db.getMarks("S1", "0001", "2", "2", "0001", "2");
	//		b_o = am_db.getMarks("S1", "0001", "1", "3", "0001", "2");
	//		b_t = am_db.getMarks("S1", "0001", "2", "3", "0001", "2");
	//		dept_id = "0004";
	//		mngs3 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
	//		mng_size3 = mngs3.size();
		}else if(dept.getCode().equals("0007")){//부산
			dept_id = "0007";
			mngs4 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size4 = mngs4.size();
		}else if(dept.getCode().equals("0008")){//대전지점
			dept_id = "0008";
			mngs5 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size5 = mngs5.size();	
		}else if(dept.getCode().equals("0009")){//강남
			dept_id = "0009";
			mngs6 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size6 = mngs6.size();	
		}else if(dept.getCode().equals("0010")){//광주지점
			dept_id = "0010";
			mngs7 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size7 = mngs7.size();				
		}else if(dept.getCode().equals("0011")){//대구지점
			dept_id = "0011";
			mngs8 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size8 = mngs8.size();	
		}else if(dept.getCode().equals("0012")){//인천지점
			dept_id = "0012";
			mngs9 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size9 = mngs9.size();
		}else if(dept.getCode().equals("0013")){//수원지점
			dept_id = "0013";
			mngs10 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size10 = mngs10.size();		
		}else if(dept.getCode().equals("0016")){//울산지점
			dept_id = "0016";
			mngs11 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size11 = mngs11.size();				
		}else if(dept.getCode().equals("0017")){//광화문지점
			dept_id = "0017";
			mngs12 = sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size12 = mngs12.size();		
		}else if(dept.getCode().equals("0018")){//송파지점
			dept_id = "0018";
			mngs13= sm_db.getStatMng7(brch_id, save_dt, dept_id, c_o, c_t, g_o, g_t, b_o, b_t, p_o, p_t, cg_b1, cg_b2, cg_m1, cb_b1, cb_b2, cb_m1, cc_o, cc_t);
			mng_size13 = mngs13.size();							
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
		var size4 = toInt(fm.mng_size4.value);
		var size5 = toInt(fm.mng_size5.value);	
		var size6 = toInt(fm.mng_size6.value);	
		var size7 = toInt(fm.mng_size7.value);	
		var size8 = toInt(fm.mng_size8.value);	
		var size9 = toInt(fm.mng_size9.value);	
		var size10 = toInt(fm.mng_size10.value);	
		var size11 = toInt(fm.mng_size11.value);	
		var size12 = toInt(fm.mng_size12.value);	
		var size13 = toInt(fm.mng_size13.value);	
				
		var t_size1 = size1+size2+size4+size5 +size6+size7+size8+size9+size10+size11+size12+size13;
		var t_size2 = size1+size2+size3+size4+size5+size6+size7+size8+size9+size10+size11+size12+size13;

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
		for(i=0; i<t_size2 ; i++){
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
			
			if(size1 == 1){
				fm.htot_ga[0].value		= toFloat(fm.htot_ga[0].value) + toFloat(fm.tot_ga.value);
				fm.h_cnt_b1_ga[0].value	= toFloat(fm.h_cnt_b1_ga[0].value) + toFloat(fm.cnt_b1_ga.value);			
				fm.h_cnt_b2_ga[0].value	= toFloat(fm.h_cnt_b2_ga[0].value) + toFloat(fm.cnt_b2_ga.value);						
				fm.h_cnt_m1_ga[0].value	= toFloat(fm.h_cnt_m1_ga[0].value) + toFloat(fm.cnt_m1_ga.value);									
				fm.hc_ga[0].value		= toFloat(fm.hc_ga[0].value) + toFloat(fm.c_ga.value);						
			}else{
				fm.htot_ga[0].value		= toFloat(fm.htot_ga[0].value) + toFloat(fm.tot_ga[i].value);
				fm.h_cnt_b1_ga[0].value	= toFloat(fm.h_cnt_b1_ga[0].value) + toFloat(fm.cnt_b1_ga[i].value);			
				fm.h_cnt_b2_ga[0].value	= toFloat(fm.h_cnt_b2_ga[0].value) + toFloat(fm.cnt_b2_ga[i].value);						
				fm.h_cnt_m1_ga[0].value	= toFloat(fm.h_cnt_m1_ga[0].value) + toFloat(fm.cnt_m1_ga[i].value);									
				fm.hc_ga[0].value		= toFloat(fm.hc_ga[0].value) + toFloat(fm.c_ga[i].value);						
			}
		}
		fm.htot_ga[0].value 	= parseFloatCipher3(toFloat(fm.htot_ga[0].value)/size1, 2);
		fm.h_cnt_b1_ga[0].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[0].value)/size1, 2);
		fm.h_cnt_b2_ga[0].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[0].value)/size1, 2);				
		fm.h_cnt_m1_ga[0].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[0].value)/size1, 2);				
		fm.hc_ga[0].value 		= parseFloatCipher3(toFloat(fm.hc_ga[0].value)/size1, 2);
		fm.h_cnt_b1[0].value	= toInt(fm.hcg_cnt_b1[0].value) + toInt(fm.hcb_cnt_b1[0].value);		
		fm.h_cnt_b2[0].value	= toInt(fm.hcg_cnt_b2[0].value) + toInt(fm.hcb_cnt_b2[0].value);		
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
		fm.h_cnt_b2[1].value	= toInt(fm.hcg_cnt_b2[1].value) + toInt(fm.hcb_cnt_b2[1].value);		
		//평점구성비 계산	
		fm.htot_ga_p[1].value = 100;		
		fm.h_cnt_b1_ga_p[1].value = Math.round(toFloat(fm.h_cnt_b1_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);		
		fm.h_cnt_b2_ga_p[1].value = Math.round(toFloat(fm.h_cnt_b2_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);		
		fm.h_cnt_m1_ga_p[1].value = Math.round(toFloat(fm.h_cnt_m1_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);		
//		fm.hc_ga_p[1].value = Math.round(toFloat(fm.hc_ga[1].value) / toFloat(fm.htot_ga[1].value)*100);								
		fm.hc_ga_p[1].value = toInt(fm.htot_ga_p[1].value)-toInt(fm.h_cnt_b1_ga_p[1].value)-toInt(fm.h_cnt_b2_ga_p[1].value)-toInt(fm.h_cnt_m1_ga_p[1].value);

	//부산지점 소계
		for(i=size1+size2+size3; i<size1+size2+size3+size4; i++){	
			fm.hc_cnt[2].value	= toInt(fm.hc_cnt[2].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[2].value= toInt(fm.hc_cnt_o[2].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[2].value= toInt(fm.hc_cnt_t[2].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[2].value= toInt(fm.hcg_cnt_b1[2].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[2].value= toInt(fm.hcg_cnt_b2[2].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[2].value= toInt(fm.hcg_cnt_m1[2].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[2].value= toInt(fm.hcb_cnt_b1[2].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[2].value= toInt(fm.hcb_cnt_b2[2].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[2].value	= toFloat(fm.htot_ga[2].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[2].value	= toFloat(fm.h_cnt_b1_ga[2].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[2].value	= toFloat(fm.h_cnt_b2_ga[2].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[2].value	= toFloat(fm.h_cnt_m1_ga[2].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[2].value	= toFloat(fm.hc_ga[2].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[2].value = parseFloatCipher3(toFloat(fm.htot_ga[2].value)/size4, 2);
		fm.h_cnt_b1_ga[2].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[2].value)/size4, 2);
		fm.h_cnt_b2_ga[2].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[2].value)/size4, 2);				
		fm.h_cnt_m1_ga[2].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[2].value)/size4, 2);						
		fm.hc_ga[2].value 	= parseFloatCipher3(toFloat(fm.hc_ga[2].value)/size4, 2);
		fm.h_cnt_b1[2].value	= toInt(fm.hcg_cnt_b1[2].value) + toInt(fm.hcb_cnt_b1[2].value);		
		fm.h_cnt_b2[2].value	= toInt(fm.hcg_cnt_b2[2].value) + toInt(fm.hcb_cnt_b2[2].value);		
		//평점구성비 계산	
		fm.htot_ga_p[2].value = 100;		
		fm.h_cnt_b1_ga_p[2].value = Math.round(toFloat(fm.h_cnt_b1_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);		
		fm.h_cnt_b2_ga_p[2].value = Math.round(toFloat(fm.h_cnt_b2_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);		
		fm.h_cnt_m1_ga_p[2].value = Math.round(toFloat(fm.h_cnt_m1_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);		
//		fm.hc_ga_p[2].value = Math.round(toFloat(fm.hc_ga[2].value) / toFloat(fm.htot_ga[2].value)*100);								
		fm.hc_ga_p[2].value = toInt(fm.htot_ga_p[2].value)-toInt(fm.h_cnt_b1_ga_p[2].value)-toInt(fm.h_cnt_b2_ga_p[2].value)-toInt(fm.h_cnt_m1_ga_p[2].value);


	//대전지점 소계
		for(i=size1+size2+size3+size4; i<size1+size2+size3+size4+size5; i++){	
			fm.hc_cnt[3].value	= toInt(fm.hc_cnt[3].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[3].value= toInt(fm.hc_cnt_o[3].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[3].value= toInt(fm.hc_cnt_t[3].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[3].value= toInt(fm.hcg_cnt_b1[3].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[3].value= toInt(fm.hcg_cnt_b2[3].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[3].value= toInt(fm.hcg_cnt_m1[3].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[3].value= toInt(fm.hcb_cnt_b1[3].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[3].value= toInt(fm.hcb_cnt_b2[3].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[3].value	= toFloat(fm.htot_ga[3].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[3].value	= toFloat(fm.h_cnt_b1_ga[3].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[3].value	= toFloat(fm.h_cnt_b2_ga[3].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[3].value	= toFloat(fm.h_cnt_m1_ga[3].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[3].value	= toFloat(fm.hc_ga[3].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[3].value = parseFloatCipher3(toFloat(fm.htot_ga[3].value)/size5, 2);
		fm.h_cnt_b1_ga[3].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[3].value)/size5, 2);
		fm.h_cnt_b2_ga[3].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[3].value)/size5, 2);				
		fm.h_cnt_m1_ga[3].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[3].value)/size5, 2);						
		fm.hc_ga[3].value 	= parseFloatCipher3(toFloat(fm.hc_ga[3].value)/size5, 2);
		fm.h_cnt_b1[3].value	= toInt(fm.hcg_cnt_b1[3].value) + toInt(fm.hcb_cnt_b1[3].value);		
		fm.h_cnt_b2[3].value	= toInt(fm.hcg_cnt_b2[3].value) + toInt(fm.hcb_cnt_b2[3].value);		
		//평점구성비 계산	
		fm.htot_ga_p[3].value = 100;		
		fm.h_cnt_b1_ga_p[3].value = Math.round(toFloat(fm.h_cnt_b1_ga[3].value) / toFloat(fm.htot_ga[3].value)*100);		
		fm.h_cnt_b2_ga_p[3].value = Math.round(toFloat(fm.h_cnt_b2_ga[3].value) / toFloat(fm.htot_ga[3].value)*100);		
		fm.h_cnt_m1_ga_p[3].value = Math.round(toFloat(fm.h_cnt_m1_ga[3].value) / toFloat(fm.htot_ga[3].value)*100);		
//		fm.hc_ga_p[3].value = Math.round(toFloat(fm.hc_ga[3].value) / toFloat(fm.htot_ga[3].value)*100);								
		fm.hc_ga_p[3].value = toInt(fm.htot_ga_p[3].value)-toInt(fm.h_cnt_b1_ga_p[3].value)-toInt(fm.h_cnt_b2_ga_p[3].value)-toInt(fm.h_cnt_m1_ga_p[3].value);

		//강남지점  소계
		for(i=size1+size2+size3+size4+size5; i<size1+size2+size3+size4+size5+size6; i++){	
			fm.hc_cnt[4].value	= toInt(fm.hc_cnt[4].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[4].value= toInt(fm.hc_cnt_o[4].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[4].value= toInt(fm.hc_cnt_t[4].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[4].value= toInt(fm.hcg_cnt_b1[4].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[4].value= toInt(fm.hcg_cnt_b2[4].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[4].value= toInt(fm.hcg_cnt_m1[4].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[4].value= toInt(fm.hcb_cnt_b1[4].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[4].value= toInt(fm.hcb_cnt_b2[4].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[4].value	= toFloat(fm.htot_ga[4].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[4].value	= toFloat(fm.h_cnt_b1_ga[4].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[4].value	= toFloat(fm.h_cnt_b2_ga[4].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[4].value	= toFloat(fm.h_cnt_m1_ga[4].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[4].value	= toFloat(fm.hc_ga[4].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[4].value = parseFloatCipher3(toFloat(fm.htot_ga[4].value)/size5, 2);
		fm.h_cnt_b1_ga[4].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[4].value)/size6, 2);
		fm.h_cnt_b2_ga[4].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[4].value)/size6, 2);				
		fm.h_cnt_m1_ga[4].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[4].value)/size6, 2);						
		fm.hc_ga[4].value 	= parseFloatCipher3(toFloat(fm.hc_ga[4].value)/size6, 2);
		fm.h_cnt_b1[4].value	= toInt(fm.hcg_cnt_b1[4].value) + toInt(fm.hcb_cnt_b1[4].value);		
		fm.h_cnt_b2[4].value	= toInt(fm.hcg_cnt_b2[4].value) + toInt(fm.hcb_cnt_b2[4].value);		
		//평점구성비 계산	
		fm.htot_ga_p[4].value = 100;		
		fm.h_cnt_b1_ga_p[4].value = Math.round(toFloat(fm.h_cnt_b1_ga[4].value) / toFloat(fm.htot_ga[4].value)*100);		
		fm.h_cnt_b2_ga_p[4].value = Math.round(toFloat(fm.h_cnt_b2_ga[4].value) / toFloat(fm.htot_ga[4].value)*100);		
		fm.h_cnt_m1_ga_p[4].value = Math.round(toFloat(fm.h_cnt_m1_ga[4].value) / toFloat(fm.htot_ga[4].value)*100);		
//		fm.hc_ga_p[4].value = Math.round(toFloat(fm.hc_ga[4].value) / toFloat(fm.htot_ga[4].value)*100);								
		fm.hc_ga_p[4].value = toInt(fm.htot_ga_p[4].value)-toInt(fm.h_cnt_b1_ga_p[4].value)-toInt(fm.h_cnt_b2_ga_p[4].value)-toInt(fm.h_cnt_m1_ga_p[4].value);

		//광주지점 소계
		for(i=size1+size2+size3+size4+size5+size6; i<size1+size2+size3+size4+size5+size6+size7; i++){	
			fm.hc_cnt[5].value	= toInt(fm.hc_cnt[5].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[5].value= toInt(fm.hc_cnt_o[5].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[5].value= toInt(fm.hc_cnt_t[5].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[5].value= toInt(fm.hcg_cnt_b1[5].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[5].value= toInt(fm.hcg_cnt_b2[5].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[5].value= toInt(fm.hcg_cnt_m1[5].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[5].value= toInt(fm.hcb_cnt_b1[5].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[5].value= toInt(fm.hcb_cnt_b2[5].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[5].value	= toFloat(fm.htot_ga[5].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[5].value	= toFloat(fm.h_cnt_b1_ga[5].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[5].value	= toFloat(fm.h_cnt_b2_ga[5].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[5].value	= toFloat(fm.h_cnt_m1_ga[5].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[5].value	= toFloat(fm.hc_ga[5].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[5].value = parseFloatCipher3(toFloat(fm.htot_ga[5].value)/size7, 2);
		fm.h_cnt_b1_ga[5].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[5].value)/size7, 2);
		fm.h_cnt_b2_ga[5].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[5].value)/size7, 2);				
		fm.h_cnt_m1_ga[5].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[5].value)/size7, 2);						
		fm.hc_ga[5].value 	= parseFloatCipher3(toFloat(fm.hc_ga[5].value)/size7, 2);
		fm.h_cnt_b1[5].value	= toInt(fm.hcg_cnt_b1[5].value) + toInt(fm.hcb_cnt_b1[5].value);		
		fm.h_cnt_b2[5].value	= toInt(fm.hcg_cnt_b2[5].value) + toInt(fm.hcb_cnt_b2[5].value);		
		//평점구성비 계산	
		fm.htot_ga_p[5].value = 100;		
		fm.h_cnt_b1_ga_p[5].value = Math.round(toFloat(fm.h_cnt_b1_ga[5].value) / toFloat(fm.htot_ga[5].value)*100);		
		fm.h_cnt_b2_ga_p[5].value = Math.round(toFloat(fm.h_cnt_b2_ga[5].value) / toFloat(fm.htot_ga[5].value)*100);		
		fm.h_cnt_m1_ga_p[5].value = Math.round(toFloat(fm.h_cnt_m1_ga[5].value) / toFloat(fm.htot_ga[5].value)*100);		
//		fm.hc_ga_p[5].value = Math.round(toFloat(fm.hc_ga[5].value) / toFloat(fm.htot_ga[5].value)*100);								
		fm.hc_ga_p[5].value = toInt(fm.htot_ga_p[5].value)-toInt(fm.h_cnt_b1_ga_p[5].value)-toInt(fm.h_cnt_b2_ga_p[5].value)-toInt(fm.h_cnt_m1_ga_p[5].value);
		
			//대구지점 소계
		for(i=size1+size2+size3+size4+size5+size6+size7; i<size1+size2+size3+size4+size5+size6+size7+size8; i++){	
			fm.hc_cnt[6].value	= toInt(fm.hc_cnt[6].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[6].value= toInt(fm.hc_cnt_o[6].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[6].value= toInt(fm.hc_cnt_t[6].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[6].value= toInt(fm.hcg_cnt_b1[6].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[6].value= toInt(fm.hcg_cnt_b2[6].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[6].value= toInt(fm.hcg_cnt_m1[6].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[6].value= toInt(fm.hcb_cnt_b1[6].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[6].value= toInt(fm.hcb_cnt_b2[6].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[6].value	= toFloat(fm.htot_ga[6].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[6].value	= toFloat(fm.h_cnt_b1_ga[6].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[6].value	= toFloat(fm.h_cnt_b2_ga[6].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[6].value	= toFloat(fm.h_cnt_m1_ga[6].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[6].value	= toFloat(fm.hc_ga[6].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[6].value = parseFloatCipher3(toFloat(fm.htot_ga[6].value)/size8, 2);
		fm.h_cnt_b1_ga[6].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[6].value)/size8, 2);
		fm.h_cnt_b2_ga[6].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[6].value)/size8, 2);				
		fm.h_cnt_m1_ga[6].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[6].value)/size8, 2);						
		fm.hc_ga[6].value 	= parseFloatCipher3(toFloat(fm.hc_ga[6].value)/size8, 2);
		fm.h_cnt_b1[6].value	= toInt(fm.hcg_cnt_b1[6].value) + toInt(fm.hcb_cnt_b1[6].value);		
		fm.h_cnt_b2[6].value	= toInt(fm.hcg_cnt_b2[6].value) + toInt(fm.hcb_cnt_b2[6].value);		
		//평점구성비 계산	
		fm.htot_ga_p[6].value = 100;		
		fm.h_cnt_b1_ga_p[6].value = Math.round(toFloat(fm.h_cnt_b1_ga[6].value) / toFloat(fm.htot_ga[6].value)*100);		
		fm.h_cnt_b2_ga_p[6].value = Math.round(toFloat(fm.h_cnt_b2_ga[6].value) / toFloat(fm.htot_ga[6].value)*100);		
		fm.h_cnt_m1_ga_p[6].value = Math.round(toFloat(fm.h_cnt_m1_ga[6].value) / toFloat(fm.htot_ga[6].value)*100);		
//		fm.hc_ga_p[6].value = Math.round(toFloat(fm.hc_ga[6].value) / toFloat(fm.htot_ga[6].value)*100);								
		fm.hc_ga_p[6].value = toInt(fm.htot_ga_p[6].value)-toInt(fm.h_cnt_b1_ga_p[6].value)-toInt(fm.h_cnt_b2_ga_p[6].value)-toInt(fm.h_cnt_m1_ga_p[6].value);


		//인천지점 소계
		for(i=size1+size2+size3+size4+size5+size6+size7+size8; i<size1+size2+size3+size4+size5+size6+size7+size8+size9; i++){	
			fm.hc_cnt[7].value	= toInt(fm.hc_cnt[7].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[7].value= toInt(fm.hc_cnt_o[7].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[7].value= toInt(fm.hc_cnt_t[7].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[7].value= toInt(fm.hcg_cnt_b1[7].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[7].value= toInt(fm.hcg_cnt_b2[7].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[7].value= toInt(fm.hcg_cnt_m1[7].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[7].value= toInt(fm.hcb_cnt_b1[7].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[7].value= toInt(fm.hcb_cnt_b2[7].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[7].value	= toFloat(fm.htot_ga[7].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[7].value	= toFloat(fm.h_cnt_b1_ga[7].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[7].value	= toFloat(fm.h_cnt_b2_ga[7].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[7].value	= toFloat(fm.h_cnt_m1_ga[7].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[7].value	= toFloat(fm.hc_ga[7].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[7].value = parseFloatCipher3(toFloat(fm.htot_ga[7].value)/size9, 2);
		fm.h_cnt_b1_ga[7].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[7].value)/size9, 2);
		fm.h_cnt_b2_ga[7].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[7].value)/size9, 2);				
		fm.h_cnt_m1_ga[7].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[7].value)/size9, 2);						
		fm.hc_ga[7].value 	= parseFloatCipher3(toFloat(fm.hc_ga[7].value)/size9, 2);
		fm.h_cnt_b1[7].value	= toInt(fm.hcg_cnt_b1[7].value) + toInt(fm.hcb_cnt_b1[7].value);		
		fm.h_cnt_b2[7].value	= toInt(fm.hcg_cnt_b2[7].value) + toInt(fm.hcb_cnt_b2[7].value);		
		//평점구성비 계산	
		fm.htot_ga_p[7].value = 100;		
		fm.h_cnt_b1_ga_p[7].value = Math.round(toFloat(fm.h_cnt_b1_ga[7].value) / toFloat(fm.htot_ga[7].value)*100);		
		fm.h_cnt_b2_ga_p[7].value = Math.round(toFloat(fm.h_cnt_b2_ga[7].value) / toFloat(fm.htot_ga[7].value)*100);		
		fm.h_cnt_m1_ga_p[7].value = Math.round(toFloat(fm.h_cnt_m1_ga[7].value) / toFloat(fm.htot_ga[7].value)*100);		
//		fm.hc_ga_p[7].value = Math.round(toFloat(fm.hc_ga[7].value) / toFloat(fm.htot_ga[7].value)*100);								
		fm.hc_ga_p[7].value = toInt(fm.htot_ga_p[7].value)-toInt(fm.h_cnt_b1_ga_p[7].value)-toInt(fm.h_cnt_b2_ga_p[7].value)-toInt(fm.h_cnt_m1_ga_p[7].value);

		//수원지점 소계
		for(i=size1+size2+size3+size4+size5+size6+size7+size8+size9; i<size1+size2+size3+size4+size5+size6+size7+size8+size9+size10; i++){	
			fm.hc_cnt[8].value	= toInt(fm.hc_cnt[8].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[8].value= toInt(fm.hc_cnt_o[8].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[8].value= toInt(fm.hc_cnt_t[8].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[8].value= toInt(fm.hcg_cnt_b1[8].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[8].value= toInt(fm.hcg_cnt_b2[8].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[8].value= toInt(fm.hcg_cnt_m1[8].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[8].value= toInt(fm.hcb_cnt_b1[8].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[8].value= toInt(fm.hcb_cnt_b2[8].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[8].value	= toFloat(fm.htot_ga[8].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[8].value	= toFloat(fm.h_cnt_b1_ga[8].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[8].value	= toFloat(fm.h_cnt_b2_ga[8].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[8].value	= toFloat(fm.h_cnt_m1_ga[8].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[8].value	= toFloat(fm.hc_ga[8].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[8].value = parseFloatCipher3(toFloat(fm.htot_ga[8].value)/size10, 2);
		fm.h_cnt_b1_ga[8].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[8].value)/size10, 2);
		fm.h_cnt_b2_ga[8].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[8].value)/size10, 2);				
		fm.h_cnt_m1_ga[8].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[8].value)/size10, 2);						
		fm.hc_ga[8].value 	= parseFloatCipher3(toFloat(fm.hc_ga[8].value)/size10, 2);
		fm.h_cnt_b1[8].value	= toInt(fm.hcg_cnt_b1[8].value) + toInt(fm.hcb_cnt_b1[8].value);		
		fm.h_cnt_b2[8].value	= toInt(fm.hcg_cnt_b2[8].value) + toInt(fm.hcb_cnt_b2[8].value);		
		//평점구성비 계산	
		fm.htot_ga_p[8].value = 100;		
		fm.h_cnt_b1_ga_p[8].value = Math.round(toFloat(fm.h_cnt_b1_ga[8].value) / toFloat(fm.htot_ga[8].value)*100);		
		fm.h_cnt_b2_ga_p[8].value = Math.round(toFloat(fm.h_cnt_b2_ga[8].value) / toFloat(fm.htot_ga[8].value)*100);		
		fm.h_cnt_m1_ga_p[8].value = Math.round(toFloat(fm.h_cnt_m1_ga[8].value) / toFloat(fm.htot_ga[8].value)*100);		
//		fm.hc_ga_p[8].value = Math.round(toFloat(fm.hc_ga[8].value) / toFloat(fm.htot_ga[8].value)*100);								
		fm.hc_ga_p[8].value = toInt(fm.htot_ga_p[8].value)-toInt(fm.h_cnt_b1_ga_p[8].value)-toInt(fm.h_cnt_b2_ga_p[8].value)-toInt(fm.h_cnt_m1_ga_p[8].value);

			//울산지점 소계
		for(i=size1+size2+size3+size4+size5+size6+size7+size8+size9; i<size1+size2+size3+size4+size5+size6+size7+size8+size9+size10+size11; i++){	
			fm.hc_cnt[9].value	= toInt(fm.hc_cnt[9].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[9].value= toInt(fm.hc_cnt_o[9].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[9].value= toInt(fm.hc_cnt_t[9].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[9].value= toInt(fm.hcg_cnt_b1[9].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[9].value= toInt(fm.hcg_cnt_b2[9].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[9].value= toInt(fm.hcg_cnt_m1[9].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[9].value= toInt(fm.hcb_cnt_b1[9].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[9].value= toInt(fm.hcb_cnt_b2[9].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[9].value	= toFloat(fm.htot_ga[9].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[9].value	= toFloat(fm.h_cnt_b1_ga[9].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[9].value	= toFloat(fm.h_cnt_b2_ga[9].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[9].value	= toFloat(fm.h_cnt_m1_ga[9].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[9].value	= toFloat(fm.hc_ga[9].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[9].value = parseFloatCipher3(toFloat(fm.htot_ga[9].value)/size11, 2);
		fm.h_cnt_b1_ga[9].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[9].value)/size11, 2);
		fm.h_cnt_b2_ga[9].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[9].value)/size11, 2);				
		fm.h_cnt_m1_ga[9].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[9].value)/size11, 2);						
		fm.hc_ga[9].value 	= parseFloatCipher3(toFloat(fm.hc_ga[9].value)/size11, 2);
		fm.h_cnt_b1[9].value	= toInt(fm.hcg_cnt_b1[9].value) + toInt(fm.hcb_cnt_b1[9].value);		
		fm.h_cnt_b2[9].value	= toInt(fm.hcg_cnt_b2[9].value) + toInt(fm.hcb_cnt_b2[9].value);		
		//평점구성비 계산	
		fm.htot_ga_p[9].value = 100;		
		fm.h_cnt_b1_ga_p[9].value = Math.round(toFloat(fm.h_cnt_b1_ga[9].value) / toFloat(fm.htot_ga[9].value)*100);		
		fm.h_cnt_b2_ga_p[9].value = Math.round(toFloat(fm.h_cnt_b2_ga[9].value) / toFloat(fm.htot_ga[9].value)*100);		
		fm.h_cnt_m1_ga_p[9].value = Math.round(toFloat(fm.h_cnt_m1_ga[9].value) / toFloat(fm.htot_ga[9].value)*100);		
//		fm.hc_ga_p[9].value = Math.round(toFloat(fm.hc_ga[9].value) / toFloat(fm.htot_ga[9].value)*100);								
		fm.hc_ga_p[9].value = toInt(fm.htot_ga_p[9].value)-toInt(fm.h_cnt_b1_ga_p[9].value)-toInt(fm.h_cnt_b2_ga_p[9].value)-toInt(fm.h_cnt_m1_ga_p[9].value);
		
	
				//종로지점 소계
		for(i=size1+size2+size3+size4+size5+size6+size7+size8+size9; i<size1+size2+size3+size4+size5+size6+size7+size8+size9+size10+size11+size12; i++){	
			fm.hc_cnt[10].value	= toInt(fm.hc_cnt[10].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[10].value= toInt(fm.hc_cnt_o[10].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[10].value= toInt(fm.hc_cnt_t[10].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[10].value= toInt(fm.hcg_cnt_b1[10].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[10].value= toInt(fm.hcg_cnt_b2[10].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[10].value= toInt(fm.hcg_cnt_m1[10].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[10].value= toInt(fm.hcb_cnt_b1[10].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[10].value= toInt(fm.hcb_cnt_b2[10].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[10].value	= toFloat(fm.htot_ga[10].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[10].value	= toFloat(fm.h_cnt_b1_ga[10].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[10].value	= toFloat(fm.h_cnt_b2_ga[10].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[10].value	= toFloat(fm.h_cnt_m1_ga[10].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[10].value	= toFloat(fm.hc_ga[10].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[10].value = parseFloatCipher3(toFloat(fm.htot_ga[10].value)/size12, 2);
		fm.h_cnt_b1_ga[10].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[10].value)/size12, 2);
		fm.h_cnt_b2_ga[10].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[10].value)/size12, 2);				
		fm.h_cnt_m1_ga[10].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[10].value)/size12, 2);						
		fm.hc_ga[10].value 	= parseFloatCipher3(toFloat(fm.hc_ga[10].value)/size12, 2);
		fm.h_cnt_b1[10].value	= toInt(fm.hcg_cnt_b1[10].value) + toInt(fm.hcb_cnt_b1[10].value);		
		fm.h_cnt_b2[10].value	= toInt(fm.hcg_cnt_b2[10].value) + toInt(fm.hcb_cnt_b2[10].value);		
		//평점구성비 계산	
		fm.htot_ga_p[10].value = 100;		
		fm.h_cnt_b1_ga_p[10].value = Math.round(toFloat(fm.h_cnt_b1_ga[10].value) / toFloat(fm.htot_ga[10].value)*100);		
		fm.h_cnt_b2_ga_p[10].value = Math.round(toFloat(fm.h_cnt_b2_ga[10].value) / toFloat(fm.htot_ga[10].value)*100);		
		fm.h_cnt_m1_ga_p[10].value = Math.round(toFloat(fm.h_cnt_m1_ga[10].value) / toFloat(fm.htot_ga[10].value)*100);		
//		fm.hc_ga_p[10].value = Math.round(toFloat(fm.hc_ga[10].value) / toFloat(fm.htot_ga[10].value)*100);								
		fm.hc_ga_p[10].value = toInt(fm.htot_ga_p[10].value)-toInt(fm.h_cnt_b1_ga_p[10].value)-toInt(fm.h_cnt_b2_ga_p[10].value)-toInt(fm.h_cnt_m1_ga_p[10].value);
		
		
				//송파지점 소계
		for(i=size1+size2+size3+size4+size5+size6+size7+size8+size9; i<size1+size2+size3+size4+size5+size6+size7+size8+size9+size10+size11+size12+size13; i++){	
			fm.hc_cnt[11].value	= toInt(fm.hc_cnt[11].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[11].value= toInt(fm.hc_cnt_o[11].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[11].value= toInt(fm.hc_cnt_t[11].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[11].value= toInt(fm.hcg_cnt_b1[11].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[11].value= toInt(fm.hcg_cnt_b2[11].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[11].value= toInt(fm.hcg_cnt_m1[11].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[11].value= toInt(fm.hcb_cnt_b1[11].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[11].value= toInt(fm.hcb_cnt_b2[11].value) + toInt(fm.cb_cnt_b2[i].value);

			fm.htot_ga[11].value	= toFloat(fm.htot_ga[11].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[11].value	= toFloat(fm.h_cnt_b1_ga[11].value) + toFloat(fm.cnt_b1_ga[i].value);			
			fm.h_cnt_b2_ga[11].value	= toFloat(fm.h_cnt_b2_ga[11].value) + toFloat(fm.cnt_b2_ga[i].value);								
			fm.h_cnt_m1_ga[11].value	= toFloat(fm.h_cnt_m1_ga[11].value) + toFloat(fm.cnt_m1_ga[i].value);											
			fm.hc_ga[11].value	= toFloat(fm.hc_ga[11].value) + toFloat(fm.c_ga[i].value);			
		}	
		fm.htot_ga[11].value = parseFloatCipher3(toFloat(fm.htot_ga[11].value)/size13, 2);
		fm.h_cnt_b1_ga[11].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[11].value)/size13, 2);
		fm.h_cnt_b2_ga[11].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[11].value)/size13, 2);				
		fm.h_cnt_m1_ga[11].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[11].value)/size13, 2);						
		fm.hc_ga[11].value 	= parseFloatCipher3(toFloat(fm.hc_ga[11].value)/size13, 2);
		fm.h_cnt_b1[11].value	= toInt(fm.hcg_cnt_b1[11].value) + toInt(fm.hcb_cnt_b1[11].value);		
		fm.h_cnt_b2[11].value	= toInt(fm.hcg_cnt_b2[11].value) + toInt(fm.hcb_cnt_b2[11].value);		
		//평점구성비 계산	
		fm.htot_ga_p[11].value = 100;		
		fm.h_cnt_b1_ga_p[11].value = Math.round(toFloat(fm.h_cnt_b1_ga[11].value) / toFloat(fm.htot_ga[11].value)*100);		
		fm.h_cnt_b2_ga_p[11].value = Math.round(toFloat(fm.h_cnt_b2_ga[11].value) / toFloat(fm.htot_ga[11].value)*100);		
		fm.h_cnt_m1_ga_p[11].value = Math.round(toFloat(fm.h_cnt_m1_ga[11].value) / toFloat(fm.htot_ga[11].value)*100);		
//		fm.hc_ga_p[11].value = Math.round(toFloat(fm.hc_ga[11].value) / toFloat(fm.htot_ga[11].value)*100);								
		fm.hc_ga_p[11].value = toInt(fm.htot_ga_p[11].value)-toInt(fm.h_cnt_b1_ga_p[11].value)-toInt(fm.h_cnt_b2_ga_p[11].value)-toInt(fm.h_cnt_m1_ga_p[11].value);
				
		
		//총계
		for(i=0; i<size1+size2+size3+size4+size5+size6+size7+size8+size9 +size10+size11+size12+size13; i++){
			fm.htot_ga[12].value		= toFloat(fm.htot_ga[12].value) + toFloat(fm.tot_ga[i].value);
			fm.h_cnt_b1_ga[12].value	= toFloat(fm.h_cnt_b1_ga[12].value) + toFloat(fm.cnt_b1_ga[i].value);
			fm.h_cnt_b2_ga[12].value	= toFloat(fm.h_cnt_b2_ga[12].value) + toFloat(fm.cnt_b2_ga[i].value);
			fm.h_cnt_m1_ga[12].value	= toFloat(fm.h_cnt_m1_ga[12].value) + toFloat(fm.cnt_m1_ga[i].value);			
			fm.hc_ga[12].value		= toFloat(fm.hc_ga[12].value) + toFloat(fm.c_ga[i].value);
		}		
		fm.htot_ga[12].value 	= parseFloatCipher3(toFloat(fm.htot_ga[12].value)/t_size2, 2);
		fm.h_cnt_b1_ga[12].value = parseFloatCipher3(toFloat(fm.h_cnt_b1_ga[12].value)/t_size2, 2);
		fm.h_cnt_b2_ga[12].value = parseFloatCipher3(toFloat(fm.h_cnt_b2_ga[12].value)/t_size2, 2);				
		fm.h_cnt_m1_ga[12].value = parseFloatCipher3(toFloat(fm.h_cnt_m1_ga[12].value)/t_size2, 2);						
		fm.hc_ga[12].value 		= parseFloatCipher3(toFloat(fm.hc_ga[12].value)/t_size2, 2);

		fm.hc_cnt[12].value	=toInt(fm.hc_cnt[4].value) +toInt(fm.hc_cnt[5].value) + toInt(fm.hc_cnt[6].value) + toInt(fm.hc_cnt[2].value) + toInt(fm.hc_cnt[3].value) + toInt(fm.hc_cnt[1].value) + toInt(fm.hc_cnt[0].value) + toInt(fm.hc_cnt[7].value) + toInt(fm.hc_cnt[8].value)+ toInt(fm.hc_cnt[9].value)+ toInt(fm.hc_cnt[10].value)+ toInt(fm.hc_cnt[11].value);
		fm.hc_cnt_o[12].value= toInt(fm.hc_cnt_o[2].value) + toInt(fm.hc_cnt_o[3].value)  + toInt(fm.hc_cnt_o[4].value)  + toInt(fm.hc_cnt_o[5].value)  + toInt(fm.hc_cnt_o[6].value) + toInt(fm.hc_cnt_o[1].value) + toInt(fm.hc_cnt_o[0].value) + toInt(fm.hc_cnt_o[7].value) + toInt(fm.hc_cnt_o[8].value)+ toInt(fm.hc_cnt_o[9].value)+ toInt(fm.hc_cnt_o[10].value)+ toInt(fm.hc_cnt_o[11].value);
		fm.hc_cnt_t[12].value= toInt(fm.hc_cnt_t[2].value) + toInt(fm.hc_cnt_t[3].value) + toInt(fm.hc_cnt_t[4].value)+ toInt(fm.hc_cnt_t[5].value)+ toInt(fm.hc_cnt_t[6].value)+ toInt(fm.hc_cnt_t[1].value) + toInt(fm.hc_cnt_t[0].value) + toInt(fm.hc_cnt_t[7].value) + toInt(fm.hc_cnt_t[8].value)+toInt(fm.hc_cnt_t[9].value)+toInt(fm.hc_cnt_t[10].value)+toInt(fm.hc_cnt_t[11].value);				
		fm.hcg_cnt_b1[12].value= toInt(fm.hcg_cnt_b1[2].value) + toInt(fm.hcg_cnt_b1[3].value) + toInt(fm.hcg_cnt_b1[4].value)+ toInt(fm.hcg_cnt_b1[5].value)+ toInt(fm.hcg_cnt_b1[6].value)+ toInt(fm.hcg_cnt_b1[1].value) + toInt(fm.hcg_cnt_b1[0].value)  + toInt(fm.hcg_cnt_b1[7].value)  + toInt(fm.hcg_cnt_b1[8].value)+ toInt(fm.hcg_cnt_b1[9].value)+ toInt(fm.hcg_cnt_b1[10].value)+ toInt(fm.hcg_cnt_b1[11].value);		
		fm.hcg_cnt_b2[12].value= toInt(fm.hcg_cnt_b2[2].value) + toInt(fm.hcg_cnt_b2[3].value) + toInt(fm.hcg_cnt_b2[4].value)+ toInt(fm.hcg_cnt_b2[5].value)+ toInt(fm.hcg_cnt_b2[6].value)+ toInt(fm.hcg_cnt_b2[1].value) + toInt(fm.hcg_cnt_b2[0].value) + toInt(fm.hcg_cnt_b2[7].value) + toInt(fm.hcg_cnt_b2[8].value) + toInt(fm.hcg_cnt_b2[9].value)+ toInt(fm.hcg_cnt_b2[10].value)+ toInt(fm.hcg_cnt_b2[11].value);		
		fm.hcg_cnt_m1[12].value= toInt(fm.hcg_cnt_m1[2].value) + toInt(fm.hcg_cnt_m1[3].value) + toInt(fm.hcg_cnt_m1[4].value)+ toInt(fm.hcg_cnt_m1[5].value)+ toInt(fm.hcg_cnt_m1[6].value)+ toInt(fm.hcg_cnt_m1[1].value) + toInt(fm.hcg_cnt_m1[0].value) + toInt(fm.hcg_cnt_m1[7].value) + toInt(fm.hcg_cnt_m1[8].value)+ toInt(fm.hcg_cnt_m1[9].value)+ toInt(fm.hcg_cnt_m1[10].value)+ toInt(fm.hcg_cnt_m1[11].value);		
		fm.hcb_cnt_b1[12].value= toInt(fm.hcb_cnt_b1[2].value) + toInt(fm.hcb_cnt_b1[3].value) + toInt(fm.hcb_cnt_b1[4].value)+ toInt(fm.hcb_cnt_b1[5].value)+ toInt(fm.hcb_cnt_b1[6].value)+ toInt(fm.hcb_cnt_b1[1].value) + toInt(fm.hcb_cnt_b1[0].value) + toInt(fm.hcb_cnt_b1[8].value)+ toInt(fm.hcb_cnt_b1[8].value)+ toInt(fm.hcb_cnt_b1[9].value)+ toInt(fm.hcb_cnt_b1[10].value)+ toInt(fm.hcb_cnt_b1[11].value);		
		fm.hcb_cnt_b2[12].value= toInt(fm.hcb_cnt_b2[2].value) + toInt(fm.hcb_cnt_b2[3].value) + toInt(fm.hcb_cnt_b2[4].value)+ toInt(fm.hcb_cnt_b2[5].value)+ toInt(fm.hcb_cnt_b2[6].value)+ toInt(fm.hcb_cnt_b2[1].value) + toInt(fm.hcb_cnt_b2[0].value) + toInt(fm.hcb_cnt_b2[8].value) + toInt(fm.hcb_cnt_b2[8].value)+ toInt(fm.hcb_cnt_b2[9].value)+ toInt(fm.hcb_cnt_b2[10].value)+ toInt(fm.hcb_cnt_b2[11].value);								

		for(i= size1+size2+size3+size4+size5+size6+size7+size8+size9 ; i<size1+size2+size3+size5+size6+size7+size8+size9+size10+size11+size12+size13; i++){				
			fm.hc_cnt[12].value		= toInt(fm.hc_cnt[12].value) + toInt(fm.c_cnt[i].value);
			fm.hc_cnt_o[12].value	= toInt(fm.hc_cnt_o[12].value) + toInt(fm.c_cnt_o[i].value);
			fm.hc_cnt_t[12].value	= toInt(fm.hc_cnt_t[12].value) + toInt(fm.c_cnt_t[i].value);
			fm.hcg_cnt_b1[12].value	= toInt(fm.hcg_cnt_b1[12].value) + toInt(fm.cg_cnt_b1[i].value);
			fm.hcg_cnt_b2[12].value	= toInt(fm.hcg_cnt_b2[12].value) + toInt(fm.cg_cnt_b2[i].value);
			fm.hcg_cnt_m1[12].value	= toInt(fm.hcg_cnt_m1[12].value) + toInt(fm.cg_cnt_m1[i].value);
			fm.hcb_cnt_b1[12].value	= toInt(fm.hcb_cnt_b1[12].value) + toInt(fm.cb_cnt_b1[i].value);
			fm.hcb_cnt_b2[12].value	= toInt(fm.hcb_cnt_b2[12].value) + toInt(fm.cb_cnt_b2[i].value);
		}
		
		fm.h_cnt_b1[12].value	= toInt(fm.hcg_cnt_b1[12].value) + toInt(fm.hcb_cnt_b1[12].value);		
		fm.h_cnt_b2[12].value	= toInt(fm.hcg_cnt_b2[12].value) + toInt(fm.hcb_cnt_b2[12].value);							
		//평점구성비 계산	
		fm.htot_ga_p[12].value = 100;		
		fm.h_cnt_b1_ga_p[12].value = Math.round(toFloat(fm.h_cnt_b1_ga[12].value) / toFloat(fm.htot_ga[12].value)*100);		
		fm.h_cnt_b2_ga_p[12].value = Math.round(toFloat(fm.h_cnt_b2_ga[12].value) / toFloat(fm.htot_ga[12].value)*100);		
		fm.h_cnt_m1_ga_p[12].value = Math.round(toFloat(fm.h_cnt_m1_ga[12].value) / toFloat(fm.htot_ga[12].value)*100);		
//		fm.hc_ga_p[12].value = Math.round(toFloat(fm.hc_ga[12].value) / toFloat(fm.htot_ga[12].value)*100);										
		fm.hc_ga_p[12].value = toInt(fm.htot_ga_p[12].value)-toInt(fm.h_cnt_b1_ga_p[12].value)-toInt(fm.h_cnt_b2_ga_p[12].value)-toInt(fm.h_cnt_m1_ga_p[12].value);		
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
	
	function LcRentUserList(st, user_id){
		window.open("view_lc_rent_user_list.jsp?st="+st+"&user_id="+user_id, "VIEW_LCRENT", "left=10, top=10, width=1000, height=700, scrollbars=yes");		
	}
//-->
</script>
<!--<link rel=stylesheet type="text/css" href="../../include/table.css">-->
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form action="stat_mng_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='mng_size1' value='<%=mng_size1%>'>
<input type='hidden' name='mng_size2' value='<%=mng_size2%>'>
<input type='hidden' name='mng_size3' value='<%=mng_size3%>'>
<input type='hidden' name='mng_size4' value='<%=mng_size4%>'>
<input type='hidden' name='mng_size5' value='<%=mng_size5%>'>
<input type='hidden' name='mng_size6' value='<%=mng_size6%>'>
<input type='hidden' name='mng_size7' value='<%=mng_size7%>'>
<input type='hidden' name='mng_size8' value='<%=mng_size8%>'>
<input type='hidden' name='mng_size9' value='<%=mng_size9%>'>
<input type='hidden' name='mng_size10' value='<%=mng_size10%>'>
<input type='hidden' name='mng_size11' value='<%=mng_size11%>'>
<input type='hidden' name='mng_size12' value='<%=mng_size12%>'>
<input type='hidden' name='mng_size13' value='<%=mng_size13%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line width='30%' id='td_title' style='position:relative;'>	
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width="25%" style='height:51'>부서</td>
                    <td class=title width="10%">연번</td>
                    <td class=title width="20%">성명</td>
                    <td class=title width="25%">입사일자</td>
                    <td class=title width="20%">총평점</td>
                </tr>
            </table>
	    </td>
	    <td width='70%' class=line>
	        <table width='100%' border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title colspan="4">최초영업<a href="javascript:LcRentUserList('1','<%=user_id%>');"><img src=../images/center/button_detail.gif align="absmiddle" border="0" alt="고객리스트"></a></td>
                    <td class=title colspan="4">영업관리<a href="javascript:LcRentUserList('2','<%=user_id%>');"><img src=../images/center/button_detail.gif align="absmiddle" border="0" alt="고객리스트"></a></td>
                    <td class=title colspan="2">정비관리<a href="javascript:LcRentUserList('3','<%=user_id%>');"><img src=../images/center/button_detail.gif align="absmiddle" border="0" alt="고객리스트"></a></td>
                    <td class=title colspan="4">업체관리</td>
                </tr>
                <tr> 
                    <td class=title width="50">일반식</td>
                    <td class=title width="50">기본식<br>
                      맞춤식</td>
                    <td class=title width="50">합계</td>
                    <td class=title width="50">평점</td>
                    <td class=title width="50">일반식</td>
                    <td class=title width="50">기본식<br>
                      맞춤식</td>
                    <td class=title width="50">합계</td>
                    <td class=title width="50">평점</td>
                    <td class=title width="50">일반식</td>
                    <td class=title width="50">평점</td>
                    <td class=title width="50">단독</td>
                    <td class=title width="50">공동</td>
                    <td class=title width="50">계</td>
                    <td class=title width="50">평점</td>
                </tr>
            </table>
	    </td>
    </tr>  			  
  <!--총평점-->
    <tr>
	    <td width=30% class=line id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class="title" align="center" colspan="4" width=80%>가중치</td>
                    <td class="title" align="center"> -</td>
                </tr>		
          <%for (int i = 0 ; i < mng_size1 ; i++){
				StatMngBean bean1 = (StatMngBean)mngs1.elementAt(i);
				dept_nm = bean1.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean1.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width="25%"  rowspan="<%=mng_size1%>" ><%=bean1.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width="10%" ><%=i+1%></td>
                    <td align="center" width="20%" ><%=bean1.getUser_nm()%></td>
                    <td align="center" width="25%" ><%=AddUtil.ChangeDate2(bean1.getEnter_dt())%> 
                    </td>
                    <td align="center" width="20%" > 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >고객지원팀 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >고객지원팀 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
          <%for (int i = 0 ; i < mng_size2 ; i++){
				StatMngBean bean2 = (StatMngBean)mngs2.elementAt(i);
				dept_nm = bean2.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean2.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center"  rowspan="<%=mng_size2%>"><%=bean2.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=bean2.getUser_nm()%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(bean2.getEnter_dt())%></td>
                    <td align="center"> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >영업팀 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >영업팀 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                 
           <%for (int i = 0 ; i < mng_size4 ; i++){
				StatMngBean bean4 = (StatMngBean)mngs4.elementAt(i);
				dept_nm = bean4.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean4.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size4%>"><%=bean4.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean4.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean4.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >부산지점
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4">부산지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>	  
             <%for (int i = 0 ; i < mng_size5 ; i++){
				StatMngBean bean5 = (StatMngBean)mngs5.elementAt(i);
				dept_nm = bean5.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean5.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size5%>"><%=bean5.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean5.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean5.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >대전지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >대전지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                <%for (int i = 0 ; i < mng_size6 ; i++){
				StatMngBean bean6 = (StatMngBean)mngs6.elementAt(i);
				dept_nm = bean6.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean6.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size6%>"><%=bean6.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean6.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean6.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >강남지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >강남지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                    
                <%for (int i = 0 ; i < mng_size7 ; i++){
				StatMngBean bean7 = (StatMngBean)mngs7.elementAt(i);
				dept_nm = bean7.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean7.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size7%>"><%=bean7.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean7.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean7.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >광주지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >광주지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                                    
                <%for (int i = 0 ; i < mng_size8 ; i++){
				StatMngBean bean8 = (StatMngBean)mngs8.elementAt(i);
				dept_nm = bean8.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean8.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size8%>"><%=bean8.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean8.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean8.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >대구지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >대구지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                                
                       <%for (int i = 0 ; i < mng_size9 ; i++){
				StatMngBean bean9 = (StatMngBean)mngs9.elementAt(i);
				dept_nm = bean9.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean9.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size9%>"><%=bean9.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean9.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean9.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >인천지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >인천지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                
                  <%for (int i = 0 ; i < mng_size10 ; i++){
				StatMngBean bean10 = (StatMngBean)mngs10.elementAt(i);
				dept_nm = bean10.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean10.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size10%>"><%=bean10.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean10.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean10.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >수원지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >수원지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                                                              
                 <%for (int i = 0 ; i < mng_size11 ; i++){
				StatMngBean bean11 = (StatMngBean)mngs11.elementAt(i);
				dept_nm = bean11.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean11.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size11%>"><%=bean11.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean11.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean11.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >울산지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >울산지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                
                            <%for (int i = 0 ; i < mng_size12 ; i++){
				StatMngBean bean12 = (StatMngBean)mngs12.elementAt(i);
				dept_nm = bean12.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean12.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size12%>"><%=bean12.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean12.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean12.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >광화문지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >광화문지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                
                            <%for (int i = 0 ; i < mng_size13 ; i++){
				StatMngBean bean13 = (StatMngBean)mngs13.elementAt(i);
				dept_nm = bean13.getDept_nm();%>
                <tr> 
                    <input type='hidden' name='mng_id' value='<%=bean13.getUser_id()%>'>
                    <%	if(i==0){%>
                    <td align="center" width=25% rowspan="<%=mng_size13%>"><%=bean13.getDept_nm()%></td>
                    <%	}else{}%>
                    <td align="center" width=10%><%=i+1%></td>
                    <td align="center" width=20%><%=bean13.getUser_nm()%></td>
                    <td align="center" width=25%><%=AddUtil.ChangeDate2(bean13.getEnter_dt())%></td>
                    <td align="center" width=20%> 
                      <input type="text" name="tot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center" colspan="4" >송파지점 
                      합계/평점 평균</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center" colspan="4" >송파지점 
                      평점구성비</td>
                    <td class="title" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                               
                                
                <tr> 
                    <td class="title_p" align="center" colspan="4" >총합계/평점 평균</td>
                    <td class="title_p" align="center"> 
                      <input type="text" name="htot_ga" value=""  size="5"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title_p" align="center" colspan="4" >총평점구성비</td>
                    <td class="title_p" align="center"> 
                      <input type="text" name="htot_ga_p" value=""  size="5"  class="whitenum">%
                    </td>
                </tr>
	        </table>
	    </td>
	    <td width='70%' class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class="title" align="center"  width="50"><input type="text" name="cg_b1" value="<%=cg_b1%>"  size="4"  class="whitenum"></td>
                    <td class="title" align="center"  width="50"><input type="text" name="cb_b1" value="<%=cb_b1%>"  size="4"  class="whitenum"></td>
                    <td class="title" align="center"  width="50">-</td>
                    <td class="title" align="center"  width="50">-</td>
                    <td class="title" align="center"  width="50"><input type="text" name="cg_b2" value="<%=cg_b2%>"  size="4"  class="whitenum"></td>
                    <td class="title" align="center"  width="50"><input type="text" name="cb_b2" value="<%=cb_b2%>"  size="4"  class="whitenum"></td>
                    <td class="title" align="center"  width="50">-</td>
                    <td class="title" align="center"  width="50">-</td>
                    <td class="title" align="center"  width="50"><input type="text" name="cg_m1" value="<%=cg_m1%>"  size="4"  class="whitenum"></td>
                    <td class="title" align="center"  width="50">-</td>
                    <td class="title" align="center"  width="50"><input type="text" name="cc_o" value="<%=cc_o%>"  size="4"  class="whitenum"></td>
                    <td class="title" align="center"  width="50"><input type="text" name="cc_t" value="<%=cc_t%>"  size="4"  class="whitenum"></td>
                    <td class="title" align="center"  width="50">-</td>
                    <td class="title" align="center"  width="50">-</td>
                </tr>
  <!--세부평점-->		  
          <%for (int i = 0 ; i < mng_size1 ; i++){
				StatMngBean bean1 = (StatMngBean)mngs1.elementAt(i);%>
                <tr> 
                    <td align="center" width="50" > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean1.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean1.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b1" value="<%=bean1.getC_Gen_cnt_b1()+bean1.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean1.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean1.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean1.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b2" value="<%=bean1.getC_Gen_cnt_b2()+bean1.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean1.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean1.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean1.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="c_cnt_o" value="<%=bean1.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="c_cnt_t" value="<%=bean1.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="c_cnt" value="<%=bean1.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean1.getDept_id()%>', '<%=bean1.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean1.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      -
                    </td>
                    <td class="title" align="center"  width="50"> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
          <%for (int i = 0 ; i < mng_size2 ; i++){
				StatMngBean bean2 = (StatMngBean)mngs2.elementAt(i);%>
                <tr> 
                    <td align="center" width="50" > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean2.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean2.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b1" value="<%=bean2.getC_Gen_cnt_b1()+bean2.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean2.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean2.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean2.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b2" value="<%=bean2.getC_Gen_cnt_b2()+bean2.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean2.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean2.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width="50" > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean2.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width="50"> 
                      <input type="text" name="c_cnt_o" value="<%=bean2.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width="50"> 
                      <input type="text" name="c_cnt_t" value="<%=bean2.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width="50"> 
                      <input type="text" name="c_cnt" value="<%=bean2.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean2.getDept_id()%>', '<%=bean2.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width="50"> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean2.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width="50"> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width="50"> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width="50"> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width="50"> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width="50"> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width="50"> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width="50"> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
       

          <%for (int i = 0 ; i < mng_size4 ; i++){
				StatMngBean bean4 = (StatMngBean)mngs4.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean4.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean4.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean4.getC_Gen_cnt_b1()+bean4.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean4.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean4.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean4.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean4.getC_Gen_cnt_b2()+bean4.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean4.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean4.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean4.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean4.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean4.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean4.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean4.getDept_id()%>', '<%=bean4.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean4.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
             <%for (int i = 0 ; i < mng_size5 ; i++){
				StatMngBean bean5 = (StatMngBean)mngs5.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean5.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean5.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean5.getC_Gen_cnt_b1()+bean5.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean5.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean5.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean5.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean5.getC_Gen_cnt_b2()+bean5.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean5.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean5.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean5.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean5.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean5.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean5.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean5.getDept_id()%>', '<%=bean5.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean5.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
             
                
              <%for (int i = 0 ; i < mng_size6 ; i++){
				StatMngBean bean6 = (StatMngBean)mngs6.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean6.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean6.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean6.getC_Gen_cnt_b1()+bean6.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean6.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean6.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean6.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean6.getC_Gen_cnt_b2()+bean6.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean6.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean6.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean6.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean6.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean6.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean6.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean6.getDept_id()%>', '<%=bean6.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean6.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
             
                      
              <%for (int i = 0 ; i < mng_size7 ; i++){
				StatMngBean bean7 = (StatMngBean)mngs7.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean7.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean7.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean7.getC_Gen_cnt_b1()+bean7.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean7.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean7.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean7.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean7.getC_Gen_cnt_b2()+bean7.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean7.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean7.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean7.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean7.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean7.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean7.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean7.getDept_id()%>', '<%=bean7.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean7.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                         <%for (int i = 0 ; i < mng_size8 ; i++){
				StatMngBean bean8 = (StatMngBean)mngs8.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean8.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean8.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean8.getC_Gen_cnt_b1()+bean8.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean8.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean8.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean8.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean8.getC_Gen_cnt_b2()+bean8.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean8.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean8.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean8.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean8.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean8.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean8.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean8.getDept_id()%>', '<%=bean8.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean8.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
                
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                  <%for (int i = 0 ; i < mng_size9 ; i++){
				StatMngBean bean9 = (StatMngBean)mngs9.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean9.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean9.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean9.getC_Gen_cnt_b1()+bean9.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean9.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean9.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean9.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean9.getC_Gen_cnt_b2()+bean9.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean9.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean9.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean9.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean9.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean9.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean9.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean9.getDept_id()%>', '<%=bean9.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean9.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>               
                
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
          <%for (int i = 0 ; i < mng_size10 ; i++){
				StatMngBean bean10 = (StatMngBean)mngs10.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean10.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean10.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean10.getC_Gen_cnt_b1()+bean10.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean10.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean10.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean10.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean10.getC_Gen_cnt_b2()+bean10.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean10.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean10.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean10.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean10.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean10.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean10.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean10.getDept_id()%>', '<%=bean10.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean10.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>               
                
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                <!-- 울산 -->
                  <%for (int i = 0 ; i < mng_size11 ; i++){
				StatMngBean bean11 = (StatMngBean)mngs11.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean11.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean11.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean11.getC_Gen_cnt_b1()+bean11.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean11.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean11.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean11.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean11.getC_Gen_cnt_b2()+bean11.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean11.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean11.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean11.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean11.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean11.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean11.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean11.getDept_id()%>', '<%=bean11.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean11.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>               
                
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                  <%for (int i = 0 ; i < mng_size12 ; i++){
				StatMngBean bean12 = (StatMngBean)mngs12.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean12.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean12.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean12.getC_Gen_cnt_b1()+bean12.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean12.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean12.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean12.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean12.getC_Gen_cnt_b2()+bean12.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean12.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean12.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean12.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean12.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean12.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean12.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean12.getDept_id()%>', '<%=bean12.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean12.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>               
                
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                  <%for (int i = 0 ; i < mng_size13 ; i++){
				StatMngBean bean13 = (StatMngBean)mngs13.elementAt(i);%>
                <tr> 
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b1" value="<%=bean13.getC_Gen_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b1" value="<%=bean13.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '9', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1" value="<%=bean13.getC_Gen_cnt_b1()+bean13.getC_BP_cnt_b1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '1', '3');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b1_ga" value="<%=AddUtil.parseFloatCipher(bean13.getCnt_b1_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_b2" value="<%=bean13.getC_Gen_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cb_cnt_b2" value="<%=bean13.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '9', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2" value="<%=bean13.getC_Gen_cnt_b2()+bean13.getC_BP_cnt_b2()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '1', '4');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_b2_ga" value="<%=AddUtil.parseFloatCipher(bean13.getCnt_b2_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cg_cnt_m1" value="<%=bean13.getC_Gen_cnt_m1()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '1', '5');">
                    </td>
                    <td align="center" width=50 > 
                      <input type="text" name="cnt_m1_ga" value="<%=AddUtil.parseFloatCipher(bean13.getCnt_m1_ga(),2)%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '9', '5');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_o" value="<%=bean13.getC_Client_cnt_o()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '0', '1');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt_t" value="<%=bean13.getC_Client_cnt_t()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '0', '2');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_cnt" value="<%=bean13.getC_Client_cnt()%>"  size="4"  class="whitenum" onSelect="javascript:move_list('<%=bean13.getDept_id()%>', '<%=bean13.getUser_id()%>', '0', '0');">
                    </td>
                    <td align="center"  width=50> 
                      <input type="text" name="c_ga" value="<%=AddUtil.parseFloatCipher(bean13.getC_Client_ga(),2)%>"  size="4"  class="whitenum">
                    </td>
                </tr>
          <%}%>
                <tr> 
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>               
                
                <tr> 
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      -
                    </td>
                    <td class=title align="center"  width=50> 
                      <input type="text" name="hc_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                </tr>
                
                
                <!--total-->
                
                   <tr> 
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_b1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hcg_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hcb_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_b2" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hcg_cnt_m1" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hc_cnt_o" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hc_cnt_t" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hc_cnt" value=""  size="4"  class="whitenum">
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="hc_ga" value=""  size="4"  class="whitenum">
                    </td>
                </tr>
          
                <tr> 
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_b1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_b2_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      <input type="text" name="h_cnt_m1_ga_p" value=""  size="4"  class="whitenum">%
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
                      -
                    </td>
                    <td class=title_p align="center"  width=50> 
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


