<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"6":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	
	String dept_id = "";
	Vector buss1 = new Vector();
	Vector buss2 = new Vector();
	Vector buss3 = new Vector();
	Vector buss4 = new Vector();
	Vector buss5 = new Vector();
	Vector buss = new Vector();
	
	int bus_size1 = 0;
	int bus_size2 = 0;
	int bus_size3 = 0;
	int bus_size4 = 0;
	int bus_size5 = 0;
	int bus_size = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//가중치 부여
	String cg = "0.1";
	String gg1 = "0.1";
	String gg2 = "0.1";
	String gg3 = "0.1";
	String gg4 = "0.1";
	String gg5 = "0.1";
	String bg1 = "0.1";
	String bg2 = "0.1";
	String bg3 = "0.1";
	String bg4 = "0.1";
	String bg5 = "0.1";	
	String pg1 = "0.1";
	String pg2 = "0.1";
	String pg3 = "0.1";
	String pg4 = "0.1";
	String pg5 = "0.1";
	
	CodeBean[] depts = c_db.getCodeAll2("0002", ""); /* 코드 구분:부서명-가산점적용 */
	int dept_size = depts.length;
	CodeBean[] ways = c_db.getCodeAll2("0005", "Y"); /* 코드 구분:대여방식-가산점적용 */
	int way_size = ways.length;
	
	buss = sb_db.getStatBus(brch_id, save_dt, "all", cg, gg1, gg2, gg3, gg4, gg5, bg1, bg2, bg3, bg4, bg5, pg1, pg2, pg3, pg4, pg5);
	bus_size = buss.size();
	
	for(int i = 0 ; i < dept_size ; i++){
		CodeBean dept = depts[i];
	}
	
	int htot_ga[] 	= new int[6];
	int hg_cnt1[] 	= new int[6];
	int hg_cnt2[] 	= new int[6];
	int hg_cnt3[] 	= new int[6];
	int hg_cnt4[] 	= new int[6];
	int hg_cnt5[] 	= new int[6];
	int hg_ga[] 	= new int[6];
	int hb_cnt1[] 	= new int[6];
	int hb_cnt2[] 	= new int[6];
	int hb_cnt3[] 	= new int[6];
	int hb_cnt4[] 	= new int[6];
	int hb_cnt5[] 	= new int[6];
	int hb_ga[] 	= new int[6];
	int hc_cnt[] 	= new int[6];
	int hc_ga[] 	= new int[6];
	int ht_cnt1[] 	= new int[6];
	int ht_cnt2[] 	= new int[6];
	int ht_cnt3[] 	= new int[6];
	int ht_cnt4[] 	= new int[6];
	int ht_cnt5[] 	= new int[6];
	int ht_ga[] 	= new int[6];
	
	String b_nm ="";
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
		fm.action='stat_bus_sc_null.jsp';
		fm.submit();		
	}	

	//처음 셋팅하기
	function set_sum(){
		var fm = document.form1;	
		var size1 = toInt(fm.bus_size1.value);
		var size2 = toInt(fm.bus_size2.value);
		var size3 = toInt(fm.bus_size3.value);	
		var size4 = toInt(fm.bus_size4.value);
		var size5 = toInt(fm.bus_size5.value);			
		var t_size1 = size1+size2+size4+size5;
		var t_size2 = size1+size2+size3+size4+size5;

		//총평점	
		for(i=0; i<t_size2 ; i++){					
			fm.tot_ga[i].value	= toFloat(fm.g_ga[i].value) + toFloat(fm.b_ga[i].value) + /* toFloat(fm.p_ga[i].value) +*/ toFloat(fm.c_ga[i].value);
			fm.tot_ga[i].value  = parseFloatCipher3(fm.tot_ga[i].value, 1);
		}		

		//합계
		for(i=0; i<t_size2 ; i++){	
			fm.t_cnt1[i].value	= toFloat(fm.g_cnt1[i].value) + /*toFloat(fm.p_cnt1[i].value) +*/ toFloat(fm.b_cnt1[i].value);
			fm.t_cnt2[i].value	= toFloat(fm.g_cnt2[i].value) + /*toFloat(fm.p_cnt2[i].value) +*/ toFloat(fm.b_cnt2[i].value);
			fm.t_cnt3[i].value	= toFloat(fm.g_cnt3[i].value) + /*toFloat(fm.p_cnt3[i].value) +*/ toFloat(fm.b_cnt3[i].value);
			fm.t_cnt4[i].value	= toFloat(fm.g_cnt4[i].value) + /*toFloat(fm.p_cnt4[i].value) +*/ toFloat(fm.b_cnt4[i].value);
			fm.t_cnt5[i].value	= toFloat(fm.g_cnt5[i].value) + /*toFloat(fm.p_cnt5[i].value) +*/ toFloat(fm.b_cnt5[i].value);
			fm.t_ga[i].value	= toFloat(fm.g_ga[i].value) + /*toFloat(fm.p_ga[i].value) +*/ toFloat(fm.b_ga[i].value);
			fm.t_ga[i].value = parseFloatCipher3(toFloat(fm.t_ga[i].value), 1);
		}	
				
		//고객지원팀 소계
		for(i=0; i<size1; i++){				
			fm.htot_ga[0].value	= toFloat(fm.htot_ga[0].value) + toFloat(fm.tot_ga[i].value);
			fm.hg_cnt1[0].value	= toFloat(fm.hg_cnt1[0].value) + toFloat(fm.g_cnt1[i].value);
			fm.hg_cnt2[0].value	= toFloat(fm.hg_cnt2[0].value) + toFloat(fm.g_cnt2[i].value);
			fm.hg_cnt3[0].value	= toFloat(fm.hg_cnt3[0].value) + toFloat(fm.g_cnt3[i].value);
			fm.hg_cnt4[0].value	= toFloat(fm.hg_cnt4[0].value) + toFloat(fm.g_cnt4[i].value);
			fm.hg_cnt5[0].value	= toFloat(fm.hg_cnt5[0].value) + toFloat(fm.g_cnt5[i].value);
			fm.hg_ga[0].value	= toFloat(fm.hg_ga[0].value) + toFloat(fm.g_ga[i].value);									
			fm.hb_cnt1[0].value	= toFloat(fm.hb_cnt1[0].value) + toFloat(fm.b_cnt1[i].value);
			fm.hb_cnt2[0].value	= toFloat(fm.hb_cnt2[0].value) + toFloat(fm.b_cnt2[i].value);
			fm.hb_cnt3[0].value	= toFloat(fm.hb_cnt3[0].value) + toFloat(fm.b_cnt3[i].value);
			fm.hb_cnt4[0].value	= toFloat(fm.hb_cnt4[0].value) + toFloat(fm.b_cnt4[i].value);
			fm.hb_cnt5[0].value	= toFloat(fm.hb_cnt5[0].value) + toFloat(fm.b_cnt5[i].value);
			fm.hb_ga[0].value	= toFloat(fm.hb_ga[0].value) + toFloat(fm.b_ga[i].value);						
			/*
			fm.hp_cnt1[0].value	= toFloat(fm.hp_cnt1[0].value) + toFloat(fm.p_cnt1[i].value);
			fm.hp_cnt2[0].value	= toFloat(fm.hp_cnt2[0].value) + toFloat(fm.p_cnt2[i].value);
			fm.hp_cnt3[0].value	= toFloat(fm.hp_cnt3[0].value) + toFloat(fm.p_cnt3[i].value);
			fm.hp_cnt4[0].value	= toFloat(fm.hp_cnt4[0].value) + toFloat(fm.p_cnt4[i].value);
			fm.hp_cnt5[0].value	= toFloat(fm.hp_cnt5[0].value) + toFloat(fm.p_cnt5[i].value);
			fm.hp_ga[0].value	= toFloat(fm.hp_ga[0].value) + toFloat(fm.p_ga[i].value);						
			*/
			fm.hc_cnt[0].value	= toInt(fm.hc_cnt[0].value) + toInt(fm.c_cnt[i].value);
			fm.hc_ga[0].value	= toFloat(fm.hc_ga[0].value) + toFloat(fm.c_ga[i].value);
			
			fm.ht_cnt1[0].value	= toFloat(fm.ht_cnt1[0].value) + toFloat(fm.t_cnt1[i].value);
			fm.ht_cnt2[0].value	= toFloat(fm.ht_cnt2[0].value) + toFloat(fm.t_cnt2[i].value);
			fm.ht_cnt3[0].value	= toFloat(fm.ht_cnt3[0].value) + toFloat(fm.t_cnt3[i].value);
			fm.ht_cnt4[0].value	= toFloat(fm.ht_cnt4[0].value) + toFloat(fm.t_cnt4[i].value);
			fm.ht_cnt5[0].value	= toFloat(fm.ht_cnt5[0].value) + toFloat(fm.t_cnt5[i].value);
			fm.ht_ga[0].value	= toFloat(fm.ht_ga[0].value) + toFloat(fm.t_ga[i].value);									
		}

		//영업팀 소계
		for(i=size1; i<size1+size2; i++){	
			fm.htot_ga[1].value	= toFloat(fm.htot_ga[1].value) + toFloat(fm.tot_ga[i].value);
			fm.hg_cnt1[1].value	= toFloat(fm.hg_cnt1[1].value) + toFloat(fm.g_cnt1[i].value);
			fm.hg_cnt2[1].value	= toFloat(fm.hg_cnt2[1].value) + toFloat(fm.g_cnt2[i].value);
			fm.hg_cnt3[1].value	= toFloat(fm.hg_cnt3[1].value) + toFloat(fm.g_cnt3[i].value);
			fm.hg_cnt4[1].value	= toFloat(fm.hg_cnt4[1].value) + toFloat(fm.g_cnt4[i].value);
			fm.hg_cnt5[1].value	= toFloat(fm.hg_cnt5[1].value) + toFloat(fm.g_cnt5[i].value);
			fm.hg_ga[1].value	= toFloat(fm.hg_ga[1].value) + toFloat(fm.g_ga[i].value);									
			fm.hb_cnt1[1].value	= toFloat(fm.hb_cnt1[1].value) + toFloat(fm.b_cnt1[i].value);
			fm.hb_cnt2[1].value	= toFloat(fm.hb_cnt2[1].value) + toFloat(fm.b_cnt2[i].value);
			fm.hb_cnt3[1].value	= toFloat(fm.hb_cnt3[1].value) + toFloat(fm.b_cnt3[i].value);
			fm.hb_cnt4[1].value	= toFloat(fm.hb_cnt4[1].value) + toFloat(fm.b_cnt4[i].value);
			fm.hb_cnt5[1].value	= toFloat(fm.hb_cnt5[1].value) + toFloat(fm.b_cnt5[i].value);
			fm.hb_ga[1].value	= toFloat(fm.hb_ga[1].value) + toFloat(fm.b_ga[i].value);						
			/*
			fm.hp_cnt1[1].value	= toFloat(fm.hp_cnt1[1].value) + toFloat(fm.p_cnt1[i].value);
			fm.hp_cnt2[1].value	= toFloat(fm.hp_cnt2[1].value) + toFloat(fm.p_cnt2[i].value);
			fm.hp_cnt3[1].value	= toFloat(fm.hp_cnt3[1].value) + toFloat(fm.p_cnt3[i].value);
			fm.hp_cnt4[1].value	= toFloat(fm.hp_cnt4[1].value) + toFloat(fm.p_cnt4[i].value);
			fm.hp_cnt5[1].value	= toFloat(fm.hp_cnt5[1].value) + toFloat(fm.p_cnt5[i].value);
			fm.hp_ga[1].value	= toFloat(fm.hp_ga[1].value) + toFloat(fm.p_ga[i].value);						
			*/
			fm.hc_cnt[1].value	= toInt(fm.hc_cnt[1].value) + toInt(fm.c_cnt[i].value);
			fm.hc_ga[1].value	= toFloat(fm.hc_ga[1].value) + toFloat(fm.c_ga[i].value);
			
			fm.ht_cnt1[1].value	= toFloat(fm.ht_cnt1[1].value) + toFloat(fm.t_cnt1[i].value);
			fm.ht_cnt2[1].value	= toFloat(fm.ht_cnt2[1].value) + toFloat(fm.t_cnt2[i].value);
			fm.ht_cnt3[1].value	= toFloat(fm.ht_cnt3[1].value) + toFloat(fm.t_cnt3[i].value);
			fm.ht_cnt4[1].value	= toFloat(fm.ht_cnt4[1].value) + toFloat(fm.t_cnt4[i].value);
			fm.ht_cnt5[1].value	= toFloat(fm.ht_cnt5[1].value) + toFloat(fm.t_cnt5[i].value);
			fm.ht_ga[1].value	= toFloat(fm.ht_ga[1].value) + toFloat(fm.t_ga[i].value);									

		}
	
	
			//부산지점 소계
		for(i=size1+size2+size3; i<size1+size2+size3+size4; i++){	
			fm.htot_ga[2].value	= toFloat(fm.htot_ga[2].value) + toFloat(fm.tot_ga[i].value);		
			fm.hg_cnt1[2].value	= toFloat(fm.hg_cnt1[2].value) + toFloat(fm.g_cnt1[i].value);
			fm.hg_cnt2[2].value	= toFloat(fm.hg_cnt2[2].value) + toFloat(fm.g_cnt2[i].value);
			fm.hg_cnt3[2].value	= toFloat(fm.hg_cnt3[2].value) + toFloat(fm.g_cnt3[i].value);
			fm.hg_cnt4[2].value	= toFloat(fm.hg_cnt4[2].value) + toFloat(fm.g_cnt4[i].value);
			fm.hg_cnt5[2].value	= toFloat(fm.hg_cnt5[2].value) + toFloat(fm.g_cnt5[i].value);
			fm.hg_ga[2].value	= toFloat(fm.hg_ga[2].value) + toFloat(fm.g_ga[i].value);												
			fm.hb_cnt1[2].value	= toFloat(fm.hb_cnt1[2].value) + toFloat(fm.b_cnt1[i].value);
			fm.hb_cnt2[2].value	= toFloat(fm.hb_cnt2[2].value) + toFloat(fm.b_cnt2[i].value);
			fm.hb_cnt3[2].value	= toFloat(fm.hb_cnt3[2].value) + toFloat(fm.b_cnt3[i].value);
			fm.hb_cnt4[2].value	= toFloat(fm.hb_cnt4[2].value) + toFloat(fm.b_cnt4[i].value);
			fm.hb_cnt5[2].value	= toFloat(fm.hb_cnt5[2].value) + toFloat(fm.b_cnt5[i].value);
			fm.hb_ga[2].value	= toFloat(fm.hb_ga[2].value) + toFloat(fm.b_ga[i].value);						
			/*
			fm.hp_cnt1[2].value	= toFloat(fm.hp_cnt1[2].value) + toFloat(fm.p_cnt1[i].value);
			fm.hp_cnt2[2].value	= toFloat(fm.hp_cnt2[2].value) + toFloat(fm.p_cnt2[i].value);
			fm.hp_cnt3[2].value	= toFloat(fm.hp_cnt3[2].value) + toFloat(fm.p_cnt3[i].value);
			fm.hp_cnt4[2].value	= toFloat(fm.hp_cnt4[2].value) + toFloat(fm.p_cnt4[i].value);
			fm.hp_cnt5[2].value	= toFloat(fm.hp_cnt5[2].value) + toFloat(fm.p_cnt5[i].value);
			fm.hp_ga[2].value	= toFloat(fm.hp_ga[2].value) + toFloat(fm.p_ga[i].value);						
			*/
			fm.hc_cnt[2].value	= toInt(fm.hc_cnt[2].value) + toInt(fm.c_cnt[i].value);
			fm.hc_ga[2].value	= toFloat(fm.hc_ga[2].value) + toFloat(fm.c_ga[i].value);
						
			fm.ht_cnt1[2].value	= toFloat(fm.ht_cnt1[2].value) + toFloat(fm.t_cnt1[i].value);
			fm.ht_cnt2[2].value	= toFloat(fm.ht_cnt2[2].value) + toFloat(fm.t_cnt2[i].value);
			fm.ht_cnt3[2].value	= toFloat(fm.ht_cnt3[2].value) + toFloat(fm.t_cnt3[i].value);
			fm.ht_cnt4[2].value	= toFloat(fm.ht_cnt4[2].value) + toFloat(fm.t_cnt4[i].value);
			fm.ht_cnt5[2].value	= toFloat(fm.ht_cnt5[2].value) + toFloat(fm.t_cnt5[i].value);
			fm.ht_ga[2].value	= toFloat(fm.ht_ga[2].value) + toFloat(fm.t_ga[i].value);									
		}
		
			//대전지점 소계
		for(i=size1+size2+size3+size4; i<size1+size2+size3+size4+size5; i++){	
			fm.htot_ga[3].value	= toFloat(fm.htot_ga[3].value) + toFloat(fm.tot_ga[i].value);		
			fm.hg_cnt1[3].value	= toFloat(fm.hg_cnt1[3].value) + toFloat(fm.g_cnt1[i].value);
			fm.hg_cnt2[3].value	= toFloat(fm.hg_cnt2[3].value) + toFloat(fm.g_cnt2[i].value);
			fm.hg_cnt3[3].value	= toFloat(fm.hg_cnt3[3].value) + toFloat(fm.g_cnt3[i].value);
			fm.hg_cnt4[3].value	= toFloat(fm.hg_cnt4[3].value) + toFloat(fm.g_cnt4[i].value);
			fm.hg_cnt5[3].value	= toFloat(fm.hg_cnt5[3].value) + toFloat(fm.g_cnt5[i].value);
			fm.hg_ga[3].value	= toFloat(fm.hg_ga[3].value) + toFloat(fm.g_ga[i].value);												
			fm.hb_cnt1[3].value	= toFloat(fm.hb_cnt1[3].value) + toFloat(fm.b_cnt1[i].value);
			fm.hb_cnt2[3].value	= toFloat(fm.hb_cnt2[3].value) + toFloat(fm.b_cnt2[i].value);
			fm.hb_cnt3[3].value	= toFloat(fm.hb_cnt3[3].value) + toFloat(fm.b_cnt3[i].value);
			fm.hb_cnt4[3].value	= toFloat(fm.hb_cnt4[3].value) + toFloat(fm.b_cnt4[i].value);
			fm.hb_cnt5[3].value	= toFloat(fm.hb_cnt5[3].value) + toFloat(fm.b_cnt5[i].value);
			fm.hb_ga[3].value	= toFloat(fm.hb_ga[3].value) + toFloat(fm.b_ga[i].value);						
			/*
			fm.hp_cnt1[3].value	= toFloat(fm.hp_cnt1[3].value) + toFloat(fm.p_cnt1[i].value);
			fm.hp_cnt2[3].value	= toFloat(fm.hp_cnt2[3].value) + toFloat(fm.p_cnt2[i].value);
			fm.hp_cnt3[3].value	= toFloat(fm.hp_cnt3[3].value) + toFloat(fm.p_cnt3[i].value);
			fm.hp_cnt4[3].value	= toFloat(fm.hp_cnt4[3].value) + toFloat(fm.p_cnt4[i].value);
			fm.hp_cnt5[3].value	= toFloat(fm.hp_cnt5[3].value) + toFloat(fm.p_cnt5[i].value);
			fm.hp_ga[3].value	= toFloat(fm.hp_ga[3].value) + toFloat(fm.p_ga[i].value);						
			*/
			fm.hc_cnt[3].value	= toInt(fm.hc_cnt[3].value) + toInt(fm.c_cnt[i].value);
			fm.hc_ga[3].value	= toFloat(fm.hc_ga[3].value) + toFloat(fm.c_ga[i].value);
						
			fm.ht_cnt1[3].value	= toFloat(fm.ht_cnt1[3].value) + toFloat(fm.t_cnt1[i].value);
			fm.ht_cnt2[3].value	= toFloat(fm.ht_cnt2[3].value) + toFloat(fm.t_cnt2[i].value);
			fm.ht_cnt3[3].value	= toFloat(fm.ht_cnt3[3].value) + toFloat(fm.t_cnt3[i].value);
			fm.ht_cnt4[3].value	= toFloat(fm.ht_cnt4[3].value) + toFloat(fm.t_cnt4[i].value);
			fm.ht_cnt5[3].value	= toFloat(fm.ht_cnt5[3].value) + toFloat(fm.t_cnt5[i].value);
			fm.ht_ga[3].value	= toFloat(fm.ht_ga[3].value) + toFloat(fm.t_ga[i].value);									
		}
		
		//총계
		for(i=0; i<size1+size2+size3+size4+size5 ; i++){
			fm.htot_ga[4].value	= toFloat(fm.htot_ga[4].value) + toFloat(fm.tot_ga[i].value);
			fm.hg_ga[4].value	= toFloat(fm.hg_ga[4].value) + toFloat(fm.g_ga[i].value);
			fm.hb_ga[4].value	= toFloat(fm.hb_ga[4].value) + toFloat(fm.b_ga[i].value);
			//fm.hp_ga[4].value	= toFloat(fm.hp_ga[4].value) + toFloat(fm.p_ga[i].value);			
			fm.hc_ga[4].value	= toFloat(fm.hc_ga[4].value) + toFloat(fm.c_ga[i].value);
			fm.ht_ga[4].value	= toFloat(fm.ht_ga[4].value) + toFloat(fm.t_ga[i].value);			
			
		}		
			fm.hc_cnt[4].value	= toInt(fm.hc_cnt[3].value) + toInt(fm.hc_cnt[2].value) +  toInt(fm.hc_cnt[1].value) + toInt(fm.hc_cnt[0].value);
			fm.hg_cnt1[4].value	= toInt(fm.hg_cnt1[3].value) + toInt(fm.hg_cnt1[2].value) + toInt(fm.hg_cnt1[1].value) + toInt(fm.hg_cnt1[0].value);
			fm.hg_cnt2[4].value	= toInt(fm.hg_cnt2[3].value) + toInt(fm.hg_cnt2[2].value) + toInt(fm.hg_cnt2[1].value) + toInt(fm.hg_cnt2[0].value);
			fm.hg_cnt3[4].value	= toInt(fm.hg_cnt3[3].value) + toInt(fm.hg_cnt3[2].value) + toInt(fm.hg_cnt3[1].value) + toInt(fm.hg_cnt3[0].value);
			fm.hg_cnt4[4].value	= toInt(fm.hg_cnt4[3].value) + toInt(fm.hg_cnt4[2].value) + toInt(fm.hg_cnt4[1].value) + toInt(fm.hg_cnt4[0].value);
			fm.hg_cnt5[4].value	= toInt(fm.hg_cnt5[3].value) + toInt(fm.hg_cnt5[2].value) + toInt(fm.hg_cnt5[1].value) + toInt(fm.hg_cnt5[0].value);
			fm.hb_cnt1[4].value	= toInt(fm.hb_cnt1[3].value) + toInt(fm.hb_cnt1[2].value) + toInt(fm.hb_cnt1[1].value) + toInt(fm.hb_cnt1[0].value);
			fm.hb_cnt2[4].value	= toInt(fm.hb_cnt2[3].value) + toInt(fm.hb_cnt2[2].value) + toInt(fm.hb_cnt2[1].value) + toInt(fm.hb_cnt2[0].value);
			fm.hb_cnt3[4].value	= toInt(fm.hb_cnt3[3].value) + toInt(fm.hb_cnt3[2].value) + toInt(fm.hb_cnt3[1].value) + toInt(fm.hb_cnt3[0].value);
			fm.hb_cnt4[4].value	= toInt(fm.hb_cnt4[3].value) + toInt(fm.hb_cnt4[2].value) + toInt(fm.hb_cnt4[1].value) + toInt(fm.hb_cnt4[0].value);
			fm.hb_cnt5[4].value	= toInt(fm.hb_cnt5[3].value) + toInt(fm.hb_cnt5[2].value) + toInt(fm.hb_cnt5[1].value) + toInt(fm.hb_cnt5[0].value);
			/*
			fm.hp_cnt1[4].value	= toInt(fm.hp_cnt1[3].value) + toInt(fm.hp_cnt1[2].value) + toInt(fm.hp_cnt1[1].value) + toInt(fm.hp_cnt1[0].value);
			fm.hp_cnt2[4].value	= toInt(fm.hp_cnt2[3].value) + toInt(fm.hp_cnt2[2].value) + toInt(fm.hp_cnt2[1].value) + toInt(fm.hp_cnt2[0].value);
			fm.hp_cnt3[4].value	= toInt(fm.hp_cnt3[3].value) + toInt(fm.hp_cnt3[2].value) + toInt(fm.hp_cnt3[1].value) + toInt(fm.hp_cnt3[0].value);
			fm.hp_cnt4[4].value	= toInt(fm.hp_cnt4[3].value) + toInt(fm.hp_cnt4[2].value) + toInt(fm.hp_cnt4[1].value) + toInt(fm.hp_cnt4[0].value);
			fm.hp_cnt5[4].value	= toInt(fm.hp_cnt5[3].value) + toInt(fm.hp_cnt5[2].value) + toInt(fm.hp_cnt5[1].value) + toInt(fm.hp_cnt5[0].value);
			*/
			fm.ht_cnt1[4].value	= toInt(fm.ht_cnt1[3].value) + toInt(fm.ht_cnt1[2].value) + toInt(fm.ht_cnt1[1].value) + toInt(fm.ht_cnt1[0].value);
			fm.ht_cnt2[4].value	= toInt(fm.ht_cnt2[3].value) + toInt(fm.ht_cnt2[2].value) + toInt(fm.ht_cnt2[1].value) + toInt(fm.ht_cnt2[0].value);
			fm.ht_cnt3[4].value	= toInt(fm.ht_cnt3[3].value) + toInt(fm.ht_cnt3[2].value) + toInt(fm.ht_cnt3[1].value) + toInt(fm.ht_cnt3[0].value);
			fm.ht_cnt4[4].value	= toInt(fm.ht_cnt4[3].value) + toInt(fm.ht_cnt4[2].value) + toInt(fm.ht_cnt4[1].value) + toInt(fm.ht_cnt4[0].value);
			fm.ht_cnt5[4].value	= toInt(fm.ht_cnt5[3].value) + toInt(fm.ht_cnt5[2].value) + toInt(fm.ht_cnt5[1].value) + toInt(fm.ht_cnt5[0].value);			
		

	}	

	//세부리스트 이동
	function move_list(dept_id, user_id, mng_way, mng_st){	
		var fm = document.form1;
		fm.s_dept.value = dept_id;
		fm.s_user.value = user_id;		
		fm.s_mng_way.value = mng_way;
		fm.s_mng_st.value = mng_st;
		if(mng_way == '0'){
			fm.action = "stat_bus_client_frame_s.jsp?";
		}else{
			fm.action = "stat_bus_car_frame_s.jsp";
		}
		fm.target='d_content';
//		fm.submit();		
	}
-->
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='bus_size1' value='<%=bus_size1%>'>
<input type='hidden' name='bus_size2' value='<%=bus_size2%>'>
<input type='hidden' name='bus_size3' value='<%=bus_size3%>'>
<input type='hidden' name='bus_size4' value='<%=bus_size4%>'>
<input type='hidden' name='bus_size5' value='<%=bus_size5%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line width='220' id='td_title' style='position:relative;'>	
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="30%" class=title style='height:51'>부서</td>
                    <td width="10%" class=title>연번</td>
                    <td width="20%" class=title>성명</td>
                    <td width="40%" class=title>입사일자</td>
                    </tr>
            </table>
	    </td>
	    <td width='1060' class=line>
	        <table width='1060' border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title rowspan=2  width="60">총평점</td>
                    <td class=title colspan="6">합계</td>
                    <td class=title colspan="6">일반식</td>			
                    <td class=title colspan="6">기본식</td>
                    <!--<td class=title colspan="6">맞춤식</td>-->
                    <td class=title colspan="2">업체</td>
                </tr>
                <tr> 
                
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">보유차<br>
                      (6개월)</td>
                    <td class=title width="50">가중치</td>
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">보유차<br>
                      (6개월)</td>
                    <td class=title width="50">가중치</td>
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">보유차<br>
                      (6개월)</td>
                    <td class=title width="50">가중치</td>
	
		<td class=title width="50">업체수</td>
                    <td class=title width="50">가중치</td>
                </tr>
            </table>
	    </td>
    </tr>  			  
    <tr>
	    <td class='line' width='220' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            
              <%for (int i = 0 ; i < bus_size ; i++){
    				StatBusBean bean = (StatBusBean)buss.elementAt(i);
    			
    				if (i == 0) {
    					b_nm = bean.getDept_nm();
    				}
    				    		   		         		
  				if (!b_nm.equals( bean.getDept_nm() )) {
           	%> 			
  				<tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;소합계</td>
               
                </tr>
              	<% 
					 b_nm = bean.getDept_nm();
			 	
		   		}              	
   			%>  
                <tr> 
                    <td align="center" width="30%" height="20"><%=bean.getDept_nm()%></td>
                    <td align="center" width="10%" height="20"><%=i+1%></td>
                    <td align="center" width="20%" height="20"><%=bean.getUser_nm()%></font></a></td>
                    <td align="center" width="40%" height="20"><%=AddUtil.ChangeDate2(bean.getEnter_dt())%>  </td>
             
                </tr>
         <% } %> 
  	       <tr> 
                    <td class=title align="center" colspan="4" height="20"><%=b_nm%>&nbsp;소합계</td>                 
                </tr>
		    
                <tr> 
                    <td class=title_p align="center" colspan="4" height="20">총합계</td>                
                </tr>
            </table>
        </td>  
        
	    <td class='line' width='1060'>
	        <table border="0" cellspacing="1" cellpadding="0" width='1060'>
          <%for (int i = 0 ; i < bus_size ; i++){
				StatBusBean bean = (StatBusBean)buss.elementAt(i);
			
								
				 hg_cnt1[1] += bean.getGen_cnt_1(); //일반식-신규
				 hg_cnt2[1] += bean.getGen_cnt_2(); //일반식-대차
				 hg_cnt3[1] += bean.getGen_cnt_3(); //일반식-증차
				 hg_cnt4[1] += bean.getGen_cnt_4(); //일반식-보유차
				 hg_cnt5[1] += bean.getGen_cnt_5(); //일반식-연장
			 	 hg_ga[1] += bean.getGen_ga(); //일반식-가중치
				 hb_cnt1[1] += bean.getBas_cnt_1();  //기본식 - 신규
			 	 hb_cnt2[1] += bean.getBas_cnt_2();  //기본식 - 대차
			 	 hb_cnt3[1] += bean.getBas_cnt_3();  //기본식 - 증차
			 	 hb_cnt4[1] += bean.getBas_cnt_4();  //기본식 - 신규
			 	 hb_cnt5[1] += bean.getBas_cnt_5();  //기본식 - 신규
			 	 hb_ga[1]     += bean.getBas_ga();  //기본식 - 가중치
				 hc_cnt[1]   += 	bean.getClient_cnt(); // 업체수  	 	 	 
				 hc_ga[1]      +=  bean.getClient_ga();  //업체 가중치
				
				htot_ga[1]   +=  bean.getGen_ga() +  bean.getBas_ga() + bean.getClient_ga() ;
				ht_cnt1[1]  +=   bean.getGen_cnt_1() +  bean.getBas_cnt_1()  ;
				ht_cnt2[1]  +=   bean.getGen_cnt_2() +  bean.getBas_cnt_2()  ;
				ht_cnt3[1]  +=   bean.getGen_cnt_3() +  bean.getBas_cnt_3()  ;
				ht_cnt4[1]  +=   bean.getGen_cnt_4() +  bean.getBas_cnt_4()  ;
				ht_cnt5[1]  +=   bean.getGen_cnt_5() +  bean.getBas_cnt_5()  ;
				ht_ga[1] 	+=  bean.getGen_ga() +  bean.getBas_ga() ;
					
				if (i == 0) {
    					b_nm = bean.getDept_nm();
    				}
							
							
				 if (b_nm.equals(bean.getDept_nm()  )) {    		
					 hg_cnt1[0] += bean.getGen_cnt_1(); //일반식-신규
					 hg_cnt2[0] += bean.getGen_cnt_2(); //일반식-대차
					 hg_cnt3[0] += bean.getGen_cnt_3(); //일반식-증차
					 hg_cnt4[0] += bean.getGen_cnt_4(); //일반식-보유차
					 hg_cnt5[0] += bean.getGen_cnt_5(); //일반식-연장
				 	 hg_ga[0] += bean.getGen_ga(); //일반식-가중치
					 hb_cnt1[0] += bean.getBas_cnt_1();  //기본식 - 신규
				 	 hb_cnt2[0] += bean.getBas_cnt_2();  //기본식 - 대차
				 	 hb_cnt3[0] += bean.getBas_cnt_3();  //기본식 - 증차
				 	 hb_cnt4[0] += bean.getBas_cnt_4();  //기본식 - 신규
				 	 hb_cnt5[0] += bean.getBas_cnt_5();  //기본식 - 신규
				 	 hb_ga[0]     += bean.getBas_ga();  //기본식 - 가중치
					 hc_cnt[0]   += 	bean.getClient_cnt(); // 업체수  	 	 	 
					 hc_ga[0]      +=  bean.getClient_ga();  //업체 가중치
					 
					 htot_ga[0]   +=  bean.getGen_ga() +  bean.getBas_ga() + bean.getClient_ga() ;
					 ht_cnt1[0]  +=   bean.getGen_cnt_1() +  bean.getBas_cnt_1()  ;
					 ht_cnt2[0]  +=   bean.getGen_cnt_2() +  bean.getBas_cnt_2()  ;
					 ht_cnt3[0]  +=   bean.getGen_cnt_3() +  bean.getBas_cnt_3()  ;
					 ht_cnt4[0]  +=   bean.getGen_cnt_4() +  bean.getBas_cnt_4()  ;
					 ht_cnt5[0]  +=   bean.getGen_cnt_5() +  bean.getBas_cnt_5()  ;
					 ht_ga[0] 	+=  bean.getGen_ga() +  bean.getBas_ga() ;
				}
					 				
			        if (!b_nm.equals(bean.getDept_nm()  )) {
			       
		%>
	        <tr> 
	           <td class=title  align="center"   height="20"  width="60"> <%=AddUtil.parseFloatCipher(htot_ga[0],1)%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt1[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt2[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt3[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt4[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt5[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=AddUtil.parseFloatCipher(ht_ga[0], 1) %></td>
                  <td class=title align="center" height="20" width="50"><%=hg_cnt1[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt2[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt3[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt4[0]%></td>                    
                    <td class=title align="center" height="20" width="50"><%=hg_cnt5[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=AddUtil.parseFloatCipher(hg_ga[0],1)%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt1[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt2[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt3[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt4[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt5[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_ga[0]%></td>
		 <td class=title align="center" height="20" width="50"><%=hc_cnt[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=AddUtil.parseFloatCipher(hc_ga[0],1)%> </td>
                </tr>
               <% 
				b_nm = bean.getDept_nm();
				
				 hg_cnt1[0] =0; //일반식-신규
				 hg_cnt2[0] = 0; //일반식-대차
				 hg_cnt3[0] = 0; //일반식-증차
				 hg_cnt4[0] = 0; //일반식-보유차
				 hg_cnt5[0] = 0; //일반식-연장
			 	 hg_ga[0] =    0; //일반식-가중치
				 hb_cnt1[0] = 0;  //기본식 - 신규
			 	 hb_cnt2[0] = 0;  //기본식 - 대차
			 	 hb_cnt3[0] = 0;  //기본식 - 증차
			 	 hb_cnt4[0] = 0;  //기본식 - 신규
			 	 hb_cnt5[0] = 0;  //기본식 - 신규
			 	 hb_ga[0]     = 0;  //기본식 - 가중치
				 hc_cnt[0]   = 	0; // 업체수  	 	 	 
				 hc_ga[0]     =  0;  //업체 가중치
				 htot_ga[0]   =  0 ;
				 ht_cnt1[0]  =   0 ;
				 ht_cnt2[0]  =   0 ;
				 ht_cnt3[0]  =   0 ;
				 ht_cnt4[0]  =   0 ;
				 ht_cnt5[0]  =   0 ;
				 ht_ga[0] 	= 0 ;
					 
				
				 hg_cnt1[0] += bean.getGen_cnt_1(); //일반식-신규
				 hg_cnt2[0] += bean.getGen_cnt_2(); //일반식-대차
				 hg_cnt3[0] += bean.getGen_cnt_3(); //일반식-증차
				 hg_cnt4[0] += bean.getGen_cnt_4(); //일반식-보유차
				 hg_cnt5[0] += bean.getGen_cnt_5(); //일반식-연장
			 	 hg_ga[0] += bean.getGen_ga(); //일반식-가중치
				 hb_cnt1[0] += bean.getBas_cnt_1();  //기본식 - 신규
			 	 hb_cnt2[0] += bean.getBas_cnt_2();  //기본식 - 대차
			 	 hb_cnt3[0] += bean.getBas_cnt_3();  //기본식 - 증차
			 	 hb_cnt4[0] += bean.getBas_cnt_4();  //기본식 - 신규
			 	 hb_cnt5[0] += bean.getBas_cnt_5();  //기본식 - 신규
			 	 hb_ga[0]     += bean.getBas_ga();  //기본식 - 가중치
				 hc_cnt[0]   += 	bean.getClient_cnt(); // 업체수  	 	 	 
				 hc_ga[0]      +=  bean.getClient_ga();  //업체 가중치
				 
				 htot_ga[0]   +=  bean.getGen_ga() +  bean.getBas_ga() + bean.getClient_ga() ;
				 ht_cnt1[0]  +=   bean.getGen_cnt_1() +  bean.getBas_cnt_1()  ;
				 ht_cnt2[0]  +=   bean.getGen_cnt_2() +  bean.getBas_cnt_2()  ;
				 ht_cnt3[0]  +=   bean.getGen_cnt_3() +  bean.getBas_cnt_3()  ;
				 ht_cnt4[0]  +=   bean.getGen_cnt_4() +  bean.getBas_cnt_4()  ;
				 ht_cnt5[0]  +=   bean.getGen_cnt_5() +  bean.getBas_cnt_5()  ;
				 ht_ga[0] 	+=  bean.getGen_ga() +  bean.getBas_ga() ;
					 
		}        
		%>  
				
                <tr> 
                     <td align="center"   height="20" width="60"><%=AddUtil.parseFloatCipher(bean.getGen_ga() +  bean.getBas_ga() + bean.getClient_ga() , 1)  %></td> <!--총평점 -->
                    <td align="center" height="20" width="50"><%=bean.getGen_cnt_1() +  bean.getBas_cnt_1() %> <!-- 합계 - 신규 -->  
                    </td>
                    <td align="center" height="20" width="50"><%=bean.getGen_cnt_2() +  bean.getBas_cnt_2()%><!-- 합계 -대차 -->   
                     </td>
                    <td align="center" height="20" width="50"> <%= bean.getGen_cnt_3() +  bean.getBas_cnt_3()%><!-- 합계 - 증차-->  
                     </td>
                    <td align="center" height="20" width="50"> <%=bean.getGen_cnt_4() +  bean.getBas_cnt_4() %><!-- 합계 - 연장 -->  
                      </td>
                    <td align="center" height="20" width="50"> <%=bean.getGen_cnt_5() +  bean.getBas_cnt_5() %><!-- 합계 - 보유차 -->  
                     </td>
                    <td align="center" height="20" width="50"> <%= bean.getGen_ga() +  bean.getBas_ga()  %><!-- 합계 - 가중치 -->  
                     </td>
                    <td align="center" width="50" height="20"> <%=bean.getGen_cnt_1()%>                 
                    </td>
                    <td align="center" width="50" height="20"> <%=bean.getGen_cnt_2()%>           
                    </td>
                    <td align="center" width="50" height="20"> <%=bean.getGen_cnt_3()%></td>
                    <td align="center" width="50" height="20"> <%=bean.getGen_cnt_4()%> </td>
                    <td align="center" width="50" height="20"> <%=bean.getGen_cnt_5()%></td>
                    <td align="center" width="50" height="20"> <%=AddUtil.parseFloatCipher(bean.getGen_ga(),1)%> </td>
                    <td align="center" width="50" height="20"> <%=bean.getBas_cnt_1()%> </td>
                    <td align="center" width="50" height="20"> <%=bean.getBas_cnt_2()%> </td>
                    <td align="center" width="50" height="20"> <%=bean.getBas_cnt_3()%> </td>
                    <td align="center" width="50" height="20"> <%=bean.getBas_cnt_4()%> </td>
                    <td align="center" width="50" height="20"> <%=bean.getBas_cnt_5()%> </td>
                    <td align="center" width="50" height="20"> <%=AddUtil.parseFloatCipher(bean.getBas_ga(),1)%> </td>	
                    <td align="center" width="50" height="20"> <%=bean.getClient_cnt()%> </td>
                    <td align="center" width="50" height="20"> <%=AddUtil.parseFloatCipher(bean.getClient_ga(),1)%></td>
                </tr>
          <%}%>
                <tr> 
                     <td class=title  align="center"   height="20"  width="60"> <%=AddUtil.parseFloatCipher(htot_ga[0],1)%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt1[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt2[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt3[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt4[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt5[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=AddUtil.parseFloatCipher(ht_ga[0],1)%></td>
                  <td class=title align="center" height="20" width="50"><%=hg_cnt1[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt2[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt3[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hg_cnt4[0]%></td>                    
                    <td class=title align="center" height="20" width="50"><%=hg_cnt5[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=AddUtil.parseFloatCipher(hg_ga[0],1)%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt1[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt2[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt3[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt4[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_cnt5[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=hb_ga[0]%></td>
		 <td class=title align="center" height="20" width="50"><%=hc_cnt[0]%></td>
                    <td class=title align="center" height="20" width="50"><%=AddUtil.parseFloatCipher(hc_ga[0],1)%> </td>
                </tr>    
            
                <tr>
                    <td class=title_p  align="center" height="20" width="60"><%=AddUtil.parseFloatCipher(htot_ga[1],1)%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt1[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt2[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt3[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt4[1]%></td>
                    <td class=title_p align="center" height="20" width="50"> <%=hg_cnt5[1]%></td>
                    <td class=title_p align="center" height="20" width="50"> <%=AddUtil.parseFloatCipher(ht_ga[1],1)%></td>                            
                    <td class=title_p align="center" height="20" width="50"> <%=hg_cnt1[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt2[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt3[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt4[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=hg_cnt5[1]%></td>
                    <td class=title_p align="center" height="20" width="50"><%=AddUtil.parseFloatCipher(hg_ga[1],1)%></td>
                    <td class=title_p align="center" height="20" width="50"> <%=hb_cnt1[1]%></td>
                    <td class=title_p align="center" height="20" width="50">  <%=hb_cnt2[1]%></td>
                    <td class=title_p align="center" height="20" width="50">  <%=hb_cnt3[1]%></td>
                    <td class=title_p align="center" height="20" width="50">  <%=hb_cnt4[1]%></td>
                    <td class=title_p align="center" height="20" width="50">  <%=hb_cnt5[1]%></td>
                    <td class=title_p align="center" height="20" width="50"> <%=hb_ga[1]%></td>
                    <td class=title_p align="center" height="20" width="50">  <%=hc_cnt[1]%></td>
                    <td class=title_p align="center" height="20" width="50">  <%=AddUtil.parseFloatCipher(hc_ga[1],1)%></td>
                </tr>
            </table>
	    </td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
//	set_sum();
//-->
</script>
</body>
</html>
