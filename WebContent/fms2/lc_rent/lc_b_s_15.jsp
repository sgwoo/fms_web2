<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.car_office.*, card.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
			
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//사전계출계약
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);	
	
	//예약자리스트
	Vector cop_res_vt = cop_db.getCarOffPreSeqResList(String.valueOf(cop_bean.getSeq()));
	int cop_res_vt_size = cop_res_vt.size();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}

	//영업소담당자 조회
	function search_emp(st){
		var fm = document.form1;
		var one_self = "N";
		var pur_bus_st = "";
		if(fm.one_self[0].checked == true) 	one_self 	= "Y";
		if(fm.pur_bus_st[0].checked == true) 	pur_bus_st 	= "1";
		if(fm.pur_bus_st[1].checked == true) 	pur_bus_st 	= "2";
		if(fm.pur_bus_st[2].checked == true) 	pur_bus_st 	= "4";
		window.open("search_emp.jsp?bus_id=<%=base.getBus_id()%>&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");
	}
	//영업소담당자 입력취소
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'BUS'){fm.emp_nm[0].value = '';fm.emp_id[0].value = '';fm.car_off_nm[0].value = '';fm.car_off_id[0].value = '';fm.car_off_st[0].value = '';fm.cust_st.value = '';fm.comm_rt.value = '';fm.comm_r_rt.value = '';fm.ch_remark.value = '';fm.ch_sac_id.value = '';fm.emp_bank.value = '';fm.emp_bank_cd.value = '';fm.emp_acc_no.value = '';fm.emp_acc_nm.value = '';
		}else{fm.emp_nm[1].value = '';fm.emp_id[1].value = '';fm.car_off_nm[1].value = '';fm.car_off_st[1].value = '';fm.car_off_id[1].value = '';}
	}
	//출고 영업소담당자를 영업 영업소담당자 상동처리
	function set_emp_sam(){
		var fm = document.form1;
		if(fm.emp_chk.checked == true){
			fm.emp_nm[1].value = fm.emp_nm[0].value;
			fm.emp_id[1].value = fm.emp_id[0].value;
			fm.car_off_nm[1].value = fm.car_off_nm[0].value;
			fm.car_off_st[1].value = fm.car_off_st[0].value;
		}else{
			cancel_emp('DLV');
		}
	}

	//수정
	function update(idx) {
		var fm = document.form1;

		if(fm.emp_id[0].value != ''){
		
			if(fm.car_gu.value == '1' && <%=base.getRent_dt()%> >= 20121220){
				if(fm.pur_bus_st[0].checked == false && fm.pur_bus_st[1].checked == false && fm.pur_bus_st[2].checked == false){
					alert('신차인 경우 영업구분을 선택하십시오.'); fm.pur_bus_st[0].focus(); 	return;
				}
			}		
			
			//if(fm.comm_r_rt.value == '')		{ alert('영업담당영업사원-영업수당 적용수수료율를 입력하십시오.'); 	fm.comm_r_rt.focus(); 		return; }
			//if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //최대수수료율보다 적용수수료율이 더 클수는 없다.
			//	alert('영업담당영업사원-영업수당 최대수수료율보다 적용수수료율이 더 클수 는 없습니다. 확인하십시오.'); 		fm.comm_rt.focus(); return;
			//}		
			
		}

		if('<%=base.getCar_gu()%>' == '1'){//신차
			if(fm.one_self[0].checked == false && fm.one_self[1].checked == false){
				alert('신차인 경우 출고구분을 선택하십시오.'); fm.one_self[0].focus(); 	return;
			}

			<%if(!base.getCar_st().equals("5")){%>
			//기타(자체)
			if(fm.dir_pur_yn[0].checked == false){
				var con_amt 		= toInt(parseDigit(fm.con_amt.value));
				//if(fm.one_self[1].checked == true && con_amt > 0){
					//if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){
					//	alert('영업사원출고인 경우 출고영업소에 차량대금를 지급할 계좌를 입력하십시오.'); return;
					//}
				//}
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value == '법인판매팀장'){
					alert('현대 법인판매팀장인데 특판이 아닙니다. 출고영업소를 확인하십시오.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == 'Y'){
					alert('출고보전수당이 있고 특판출고(실적이관가능)인데 특판이 아닙니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
				}
				if(fm.dir_pur_commi_yn.value == 'N'){
					alert('출고보전수당이 있고 특판출고(실적이관가능)인데 특판이 아닙니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
				}
			//특판출고		
			}else{
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value == ''){ alert('출고영업소를 입력하십시오.'); return; }
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value != '030849'){ alert('특판출고 선택되었으나 출고영업소가 법인판매팀이 아닙니다. 확인하십시오.'); return; }
				if('<%=cm_bean.getCar_comp_id()%>' == '0003' && fm.emp_id[1].value != '038036'){ alert('특판출고 선택되었으나 출고영업소가 법인판매팀이 아닙니다. 확인하십시오.'); return; }
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value != '법인판매팀장'){
					alert('현대 특판인데 법인판매팀장 아닙니다. 출고영업소를 확인하십시오.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == '2'){
					alert('출고보전수당이 있고 자체출고대리점출고인데 특판입니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
				}
			}
				<%if(cm_bean.getCar_comp_id().equals("0001") || cm_bean.getCar_comp_id().equals("0003")){%>
					if(fm.dir_pur_yn[0].checked == true && fm.pur_bus_st[0].checked == true && fm.one_self[1].checked == true ){
						alert('자동차 특판출고 : 자체영업인데 영업사원출고로 되어 있습니다. 확인하십시오.'); return;
					}
				<%}%>
				if(fm.emp_id[1].value != ''){
					if(fm.con_amt.value == '' || fm.con_amt.value == '0')	{
						
					}else{	
						if(fm.trf_st0.value == '')			{ alert('출고영업소-선수금 지급수단을 선택하십시오.'); 	fm.trf_st0.focus(); 		return; }
						if(fm.trf_st0.value == '1'){
							if(fm.con_bank.value == '') 	{ alert('출고영업소-선수금 지급금융사를 입력하십시오.'); 	fm.con_bank.focus(); 		return; }
							if(fm.con_acc_no.value == '') 	{ alert('출고영업소-선수금 계좌번호를 입력하십시오.'); 	fm.con_acc_no.focus(); 		return; }
							if(fm.con_acc_nm.value == '') 	{ alert('출고영업소-선수금 계좌예금주를 입력하십시오.'); 	fm.con_acc_nm.focus(); 		return; }							
						}	
						if(fm.con_est_dt.value == '') 	{ alert('출고영업소-선수금 지급예정일을 입력하십시오.'); 	fm.con_est_dt.focus(); 		return; }
					}	
					
					<%if(!base.getCar_gu().equals("2")){%>  
					if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0')	{
						
					}else{	
						if(fm.trf_st5.value == '')			{ alert('임시운행보험료 지급수단을 선택하십시오.'); 	fm.trf_st5.focus(); 		return; }
						if(fm.trf_st5.value == '1'){
							if(fm.card_kind5.value == '') 	{ alert('임시운행보험료 지급금융사를 입력하십시오.'); 	fm.card_kind5.focus(); 		return; }
							if(fm.cardno5.value == '') 		{ alert('임시운행보험료 계좌번호를 입력하십시오.'); 		fm.cardno5.focus(); 	return; }
							if(fm.trf_cont5.value == '') 	{ alert('임시운행보험료 계좌예금주를 입력하십시오.'); 	fm.trf_cont5.focus(); 		return; }
						}	
						if(fm.trf_est_dt5.value == '') 	{ alert('임시운행보험료 지급예정일을 입력하십시오.'); 	fm.trf_est_dt5.focus(); 	return; }
					}	
					<%}%>	
				}
		  <%}%>
		}
		
		<%if(base.getCar_gu().equals("1")){%>
		
		//영업구분
		var pur_bus_st_chk = $("input[name=pur_bus_st]").is(":checked");
		var pur_bus_st_val = $("input[name=pur_bus_st]:checked").val();
		//출고보전수당지급여부
		var dlv_con_commi_yn_chk = $("input[name=dlv_con_commi_yn]").is(":checked");
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		//입력된 출고보전수당금액
		var dlv_con_commi_val = $("#dlv_con_commi").val();
		
		/* if (pur_bus_st_chk) {
			if (pur_bus_st_val == "2" || pur_bus_st_val == "4") {
				if (dlv_con_commi_yn_val == "N" && Number(dlv_con_commi_val) > 0) {
					alert("출고보전수당금액이 입력되어 출고보전수당 지급여부를 없음으로 수정 할 수 없습니다.\n영업사원수당지급요청 메뉴에서 금액을 확인해주세요.");
					return;
				}
			}
		} */
		<%}%>

		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}
	}


	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}
	
	// 현대해상 임시운행보험료 2018.04.19
	function openHc(){
  		window.open('/acar/common/hyundai_confidentiality.jsp','_blank', 'width=800, height=600, menubars=no, scrollbars=auto');
 	}
	
	//출고보전수당
	function cng_input(){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> >= 20190610){
			if('<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true){  // && fm.dir_pur_yn[0].checked == true
				
				if(fm.dir_pur_commi_yn.value == ''){
					if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){
						fm.dir_pur_commi_yn.value = 'N';
					}else{
						fm.dir_pur_commi_yn.value = 'Y';
					}
					//기타(자체)
					if(fm.dir_pur_yn[0].checked == false){
						fm.dir_pur_commi_yn.value = '2';
					}
				}
			}else{										
				
				fm.dir_pur_commi_yn.value = '';
			}
		}			
	}			
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>

<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" value="<%=user_id%>">
  <input type='hidden' name="br_id"   value="<%=br_id%>">
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_15.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">  
  <input type='hidden' name="idx"	value="">
  <input type='hidden' name="client_id"	value="<%=base.getClient_id()%>">
  <input type='hidden' name="car_st"	value="<%=base.getCar_st()%>">
  <input type='hidden' name="car_gu"	value="<%=base.getCar_gu()%>">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결계약</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>영업사원<%}else if(base.getCar_gu().equals("2")){%>중고차딜러<%}%>-영업담당</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:<%if(!base.getCar_gu().equals("0") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 		
        <td class=line> 
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="3%" rowspan="6" class='title'>영<br>
     			  	업</td>
					<td class='title'>영업구분</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="pur_bus_st" value='1' <%if(pur.getPur_bus_st().equals("1")){%>checked<%}%>>
                  		자체영업</label>
                  		<label><input type='radio' name="pur_bus_st" value='2' <%if(pur.getPur_bus_st().equals("2")){%>checked<%}%>>
                  		영업사원영업</label>
                   		<label><input type='radio' name="pur_bus_st" value='4' <%if(pur.getPur_bus_st().equals("4")){%>checked<%}%>>
                  		에이전트</label>
					</td>		
				</tr>
				<tr id="dlv_con_commi_yn_tr">
	              	<td class='title'>출고보전수당<br>지급여부</td>
	              	<td colspan='5'>&nbsp;
	              		<%-- <label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() == 0){%>checked<%}%> onClick="javascript:cng_input()"> --%>
	              		<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
	              		없음</label>　　
	              		<%-- <label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() > 0){%>checked<%}%> onClick="javascript:cng_input()"> --%>
	              		<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
	              		있음</label>
	              		<input type="hidden" id="dlv_con_commi" value="<%=emp1.getDlv_con_commi()%>">
	              		<table>
	              		   	<tr>
	              		       	<td>&nbsp;
									<select name='dir_pur_commi_yn'>
	                          			<option  value="">선택</option>
	                          			<option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>특판출고(실적이관가능)</option>
	                          			<option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>특판출고(실적이관불가능)</option>
	                          			<option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>자체출고대리점출고</option>
	                        		</select>
	              		       	</td>
	              		   	</tr>
              			</table>
					</td>
				</tr>
				<tr>
                    <td width="10%" class='title'>영업담당</td>
                    <td width="25%" >&nbsp;
                      <input type='text' name='emp_nm' size='10' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
                      <span class="b"><a href="javascript:search_emp('BUS')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        		      <span class="b"><a href="javascript:cancel_emp('BUS')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
        		    </td>
                    <td width="10%" class='title'>상호/영업소명</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
					  </td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
                <tr>
                    <td class='title'>소득구분</td>
                    <td >&nbsp;
                      <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>
                    <td class='title'>최대수수료율</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3"<%}else{%>size="4"<%}%> class='whitenum' readonly>
        			  % 
        			</td>
                    <td class='title'>적용수수료율</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3"<%}else{%>size="4"<%}%> class='whitenum' readonly>
        		      % 
        			  <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' maxlength='7' class='whitenum' readonly>
        			  원			  
        			</td>
                </tr>
                <tr>
                    <td class='title'>변경사유</td>
                    <td colspan="3" >&nbsp;
        		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
                    </td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ch_sac_id" value="<%=emp1.getCh_sac_id()%>">			
			<a href="javascript:User_search('ch_sac_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			
        	    </td>
                </tr>
                <tr>
                    <td class='title'>은행명</td>
                    <td >&nbsp;
                    	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
        		      <select name='emp_bank_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//신규인경우 미사용은행 제외
																if(bank.getUse_yn().equals("N")){	 continue; }%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                      </select>
        			</td>
                    <td class='title'>계좌번호</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
        			</td>
                    <td class='title'>예금주명</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>영업사원-출고담당<%}else if(base.getCar_gu().equals("2")){%>중고차구입처<%}%></span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:<%if(!base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                    <td width="3%" rowspan="<%if(base.getCar_gu().equals("1")){%>5<%}else if(base.getCar_gu().equals("2")){%>5<%}%>" class='title'>출<br>
                      고</td>			  
                <td class='title'>출고구분</td>
                <td>&nbsp;
				  <label><input type='radio' name="one_self" value='Y' <%if(pur.getOne_self().equals("Y")){%>checked<%}%>>
        				자체출고</label>
        		  <label><input type='radio' name="one_self" value='N' <%if(pur.getOne_self().equals("N")){%>checked<%}%>>
        				영업사원출고</label>
    			</td>
    		<td class='title'>특판출고여부</td>
                <td>&nbsp;
                    <input type='radio' name="dir_pur_yn" value='Y' <%if(pur.getDir_pur_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
        				특판
        	    <input type='radio' name="dir_pur_yn" value='' <%if(pur.getDir_pur_yn().equals("")){%>checked<%}%> onClick="javascript:cng_input()">
        				기타(자체)        		  
    			</td>	
    		<td class='title'>출고요청일</td>
                <td>&nbsp;
                		  <input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
                		  &nbsp;
        		  <input type="checkbox" name="pur_req_yn" value="Y" <%if(pur.getPur_req_yn().equals("Y")){%>checked<%}%>>				  
        				출고요청한다
        		  
    			</td>	
              </tr>		
                <tr>
                    <td width="10%" class='title'>출고담당</td>
                    <td width="25%" >&nbsp;
                      <input type='text' name='emp_nm' size='10' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                      <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
                      <input type='checkbox' name="emp_chk" onClick="javascript:set_emp_sam()"><font size='1'>상동</font></td>
                    <td width="10%" class='title'>영업소명</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			</td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
    		  <%if(!base.getCar_gu().equals("2")){
    		  		String dlv_auth = "";
    		  		if(!nm_db.getWorkAuthUser("출고일자등록",user_id) && !nm_db.getWorkAuthUser("납품준비상황등록업무",user_id)){
    		  			dlv_auth = "white";
    		  		}
    		  %>    		  
              <tr>
                <td class='title'>계출번호</td>
                <td >&nbsp;
                  <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
                    <%if(!cop_bean.getRent_l_cd().equals("")){%>
                	<br>&nbsp;<font color=red>
                	(사전계약 <%=cop_bean.getCom_con_no()%>
                	
                	<%	if(cop_res_vt_size>0){
                			for (int i = 0 ; i < 1 ; i++) {
								Hashtable cop_res_ht = (Hashtable)cop_res_vt.elementAt(i);
					%>
					<%=cop_res_ht.get("FIRM_NM")%><%=cop_res_ht.get("CUST_Q")%>
					<%		}
						}
					%>
					
                	)
                	</font>
                	<%}%>
    		    </td>
                <td class='title'>출고예정일</td>
                <td>&nbsp;
                  <input type='text' name='dlv_est_dt' value='<%=pur.getDlv_est_dt()%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			  &nbsp;
              	  <input type='text' size='2' name='dlv_est_h' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> value='<%=pur.getDlv_est_h()%>'>
             	   시 
    			</td>
                <td class='title'>출고일자</td>
                <td>&nbsp;
                  <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
              </tr>              
    		  <%}else if(base.getCar_gu().equals("2")){%>
              <tr>
                <td class='title'>매매일자</td>
                <td >&nbsp;
                  <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='text' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
                <td class='title'>매매금액</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='trf_amt1' value='<%=AddUtil.parseDecimal(pur.getTrf_amt1())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>
              </tr>
              <tr>
                <td class='title'>전차량번호</td>
                <td >&nbsp;
                  <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='text' maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
    		    </td>
                <td class='title'>차대번호</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='car_num' value='<%=pur.getCar_num()%>' class='text' maxlength='20' size='20' onBlur='javascript:this.value=this.value.toUpperCase()'>
    			</td>
              </tr>
    		  <%}%>
    		  <%	if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getTrf_st0().equals("") && pur.getCon_bank().indexOf("은행") == 0){
                		if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002") || emp2.getCar_comp_id().equals("0003")){
                			if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){
                				pur.setTrf_st0("3");
                			}else{
                   				pur.setTrf_st0("1");
                   			}	
                		}	
                	}
    		  if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_st5().equals("")){
          		//20220916 현대총신대대리점만 우선 카드 디폴트 처리
         			if(emp2.getCar_off_id().equals("00588")){
          				pur.setTrf_st5("3");
         			}else{
           				pur.setTrf_st5("1");
           			}	
          	}
                %>		
    		  <tr>
                <td class='title'>계약금</td>
                <td colspan="5">&nbsp;
                	금액 : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='con_bank'class='default'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	계좌종류 :
				  	<select name="acc_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        								  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;(계약금지급일:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%}%>        			
        			
    			</td>															
              </tr>
              
              	  		  
    		  <%if(!base.getCar_gu().equals("2")){%>   
    		  <tr>				
                <td class='title'>임시운행보험료</td>
                <td colspan='5'>&nbsp;
                  금액 : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st5" class='default'>
                        <option value="">==선택==</option>
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>현금</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='card_kind5' class='default'>
                        <option value=''>선택</option>                        
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCard_kind5().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	계좌종류 :
				  	<select name="acc_st5" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
				    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='현대해상 보험료 보기' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');">-->
    			</td>				
              </tr>     		                              
    		  <%}%>                     
            </table>
        </td>
    </tr>
	<tr>
	    <td>* 출고영업소에 차량대금를 지급할 계좌를 입력하십시오. 개인명의 계좌는 사용할 수 없습니다.</td>
	<tr>		
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('15')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
    	</td>
	<tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script>
<%if(base.getCar_gu().equals("1")){%>
	// 페이지 로드 시 출고보전수당 지급여부 초기화		2017. 12. 06
	// 초기 팝업에서 DB에서 값을 가져오는 것으로 수정 2017. 12. 18
	document.addEventListener("DOMContentLoaded", function(){
		var pur_bus_st_chk = $("input[name=pur_bus_st]").is(":checked");
		var pur_bus_st_val = $("input[name=pur_bus_st]:checked").val();					// 영업구분
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		
		$("#dlv_con_commi_yn_tr").hide();																	// 출고보전수당 지급여부 -> 필드 숨기기
		if(pur_bus_st_chk){
			if(pur_bus_st_val == "1"){
			}else if(pur_bus_st_val == "2" || pur_bus_st_val == "4"){							// 영업구분 -> 영업사원영업, 에이전트
				$("#dlv_con_commi_yn_tr").show();														// 출고보전수당 지급여부 -> 필드 보여주기
			}
		}else {		// 영업구분 선택이 안되있는 경우 출고보전수당 지급여부를 보여준다 2017.12.18
			$("#dlv_con_commi_yn_tr").show();
		}
	});
	
	// 출고보전수당		2017. 12. 06
	var one_self_no = $("input[name='one_self']:radio[value='N']");		// 출고구분 영업사원출고
	$("input[name=pur_bus_st]").change(function(){ 
		if($(this).val() == "1"){							// 영업구분 자체영업 선택 시
			$("#dlv_con_commi_yn_tr").hide();		// 출고보전수당 지급여부 숨김
			one_self_no.prop("disabled", false);		// 출고구분 영업사원출고 활성화
		}else{														// 영업구분 영업사원영업, 에이전트 선택 시
			$("#dlv_con_commi_yn_tr").show();	// 출고보전수당 지급여부 보이기
		}
	});
	$("input[name=dlv_con_commi_yn]").change(function(){
		if($(this).val() == "Y"){																			// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 있음 선택 시
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// 출고구분 자체출고 선택
			one_self_no.prop("disabled", true);														// 출고구분 영업사원출고 비활성화
		}else{																										// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 없음 선택 시
			one_self_no.prop("disabled", false);														// 출고구분 영업사원출고 활성화
			//one_self_no.prop("checked", true);														// 출고구분 영업사원출고 선택		2017.12.13 기능 제거
		}
	});
<%}%>	
	
</script>
</body>
</html>
