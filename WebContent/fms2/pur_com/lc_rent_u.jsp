<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//영업사원
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");

	//배정관리		
	CarPurDocListBean cpd_bean = cod.getCarPurCom(rent_mng_id, rent_l_cd, com_con_no);
		
	//변경계약
	Vector vt = cod.getCarPurComCngs(rent_mng_id, rent_l_cd, com_con_no);
	int vt_size = vt.size();
	
	UsersBean dlv_mng_bean 	= umd.getUsersBean(cpd_bean.getDlv_mng_id());
		
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산주차장관리"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));
	
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"";		
	
	if(car.getPurc_gu().equals("")){
		if(base.getCar_st().equals("3")){
			car.setPurc_gu("1");	
		}else{
			car.setPurc_gu("0");	
		}
	}	
	
	String add_dc_yn = e_db.getEstiSikVarCase("1", "", "add_dc_yn");//추가DC점검여부
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//등록
	function save(){
		var fm = document.form1;
		
		//계약변경
		<%if(cng_item.equals("cng")){%>  
			if(fm.cng_cont.value == ''){	alert('변경항목이 무엇인지 변경구분에 입력하여 주십시오.'); 	fm.cng_cont.focus(); 	return;	}
		<%}%>
		
		
		//계약해지
		<%if(cng_item.equals("cls1")){// || cng_item.equals("cls2")%>  
		
			if(fm.cng_cont.checked == false){ //  && fm.cng_cont[1].checked == false && fm.cng_cont[2].checked == false
				alert('해지구분을 선택하여 주십시오.');
				return;
			}
		
			<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("출고업무대체자",user_id)){%>
			<%}else{%>
			//if(fm.cng_cont[1].checked == true && '<%=base.getUse_yn()%>' != 'N'){
			//	alert('신차취소현황으로 보내기 전에 출고전해지를 먼저 처리하십시오.');  	return;
			//}
			<%}%>
		
			if(fm.bigo.value == ''){	alert('사유를 입력하여 주십시오.'); 		fm.bigo.focus(); 	return;	}
		
			<%	if(cng_item.equals("cls1") && base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>    
					if(fm.cont_use_yn[0].checked == false && fm.cont_use_yn[1].checked == false){
						alert('계약해지여부를 선택하여 주십시오.');
						return;
					}
			<%	}%>
		
			<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("출고업무대체자",user_id)){%>
			<%}else{%>	
			//팰리세이드는 납품취소 안되게
			//if(fm.cng_cont[0].checked == true && '<%=pur_com.get("R_CAR_NM")%>'.indexOf('팰리세이드') != -1){
			//	alert('팰리세이드는 납품취소를 하지 마십시오. 신차취소현황으로 처리 하십시오.');
			//	return;
			//}
			<%}%>
		
		<%}%>
		
		
		//출고배정
		<%if(cng_item.equals("con")){%>
		//추가DC : 현대특판, 전기차 제외
		if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){ 
		}else{	
			if('<%=add_dc_yn%>'=='Y' && fm.car_off_id.value == '03900' && toInt(parseDigit(fm.add_dc_amt.value)) ==0){ 
				alert('추가D/C를 입력하고 배정처리하십시오.'); 	return;
			}
		}
		if(fm.dlv_con_dt.value == ''){	alert('출고배정일자를 입력하여 주십시오.'); 	fm.dlv_con_dt.focus(); 	return;	}
		if(fm.dlv_ext.value == ''){	alert('출고사무소를 입력하여 주십시오.'); 	fm.dlv_ext.focus(); 	return;	}
		if(fm.udt_st.value == ''){	alert('배달지구분을 선택하여 주십시오.'); 	fm.udt_st.focus(); 	return;	}		
		<%}%>
	
		//출고수정
		<%if(cng_item.equals("dlv")){%>
		<%if(cpd_bean.getDlv_st().equals("2")){%>
			if(fm.dlv_con_dt.value == ''){	alert('배정일자를 입력하여 주십시오.'); 	fm.dlv_con_dt.focus(); 	return;	}
		<%}else{%>
			//if(fm.dlv_est_dt.value == ''){	alert('예정일자를 입력하여 주십시오.'); 	fm.dlv_est_dt.focus(); 	return;	}
		<%}%>
		if(fm.dlv_ext.value == ''){	alert('출고사무소를 입력하여 주십시오.'); 	fm.dlv_ext.focus(); 	return;	}
		if(fm.udt_st.value == ''){	alert('배달지구분을 선택하여 주십시오.'); 	fm.udt_st.focus(); 	return;	}
		<%}%>
		
		//배달탁송사
		<%if(cng_item.equals("cons_off")){%>
		if(fm.cons_off_nm.value == ''){		alert('배달탁송사 상호를 입력하여 주십시오.'); 	fm.cons_off_nm.focus(); 	return;	}
		if(fm.cons_off_tel.value == ''){	alert('배달탁송사 연락처를 입력하여 주십시오.'); 	fm.cons_off_tel.focus(); 	return;	}
		<%}%>		
		
		//재배정요청
		<%if(cng_item.equals("re")){%>
		if(fm.pur_req_dt.value == ''){	alert('출고희망일를 입력하여 주십시오.'); 	fm.pur_req_dt.focus(); 	return;	}
		if(fm.bigo.value == ''){	alert('사유를 입력하여 주십시오.'); 		fm.bigo.focus(); 	return;	}
		<%}%>
		
		//배정후변경사항
		<%if(cng_item.equals("cng2")){%>
		if(fm.dlv_dt.value == ''){	alert('변경후 출고일자를 입력하여 주십시오.'); 	fm.dlv_dt.focus(); 	return;	}		
		if(fm.udt_st.value == ''){	alert('배달지구분을 선택하여 주십시오.'); 	fm.udt_st.focus(); 	return;	}		
		<%}%>
		
		//배정취소
		<%if(cng_item.equals("cls3")){%>  
		if(fm.bigo.value == ''){	alert('사유를 입력하여 주십시오.'); 		fm.bigo.focus(); 	return;	}				
		
		<%	if(base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>    
				if(fm.cont_use_yn[0].checked == false && fm.cont_use_yn[1].checked == false){
					alert('계약해지여부를 선택하여 주십시오.');
					return;
				}
		<%	}%>		
		<%}%>
		
		//출고
		<%if(cng_item.equals("settle")){%>  
		if(fm.dlv_dt.value == ''){	alert('출고일자를 입력하여 주십시오.'); 	fm.dlv_dt.focus(); 	return;	}		
		<%}%>
		
		//출고
		<%if(cng_item.equals("dlv_dt")){%>  
		//if(fm.dlv_dt.value == ''){	alert('출고일자를 입력하여 주십시오.'); 	fm.dlv_dt.focus(); 	return;	}		
		<%}%>

		
		if(confirm('수정 하시겠습니까?')){	
			fm.action='lc_rent_u_a.jsp';	
			fm.target='i_no';		
			fm.submit();
		}	
	}		
	
	//차량 소비자가 합계
	function set_car_amt(){
		var fm = document.form1;
		
		fm.car_d_amt.value 	= parseDecimal( toInt(parseDigit(fm.dc_amt.value)) + toInt(parseDigit(fm.add_dc_amt.value)) );
		fm.car_g_amt.value 	= parseDecimal( toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_d_amt.value)) );
		fm.car_amt1.value 	= fm.car_g_amt.value;		
		fm.car_amt2.value 	= fm.cons_amt.value;		
		fm.car_amt3.value 	= parseDecimal( toInt(parseDigit(fm.car_g_amt.value)) + toInt(parseDigit(fm.cons_amt.value)) );
		
	}
	
	//구입가계산
	function set_car_f_amt(){
		var fm = document.form1;
						
		if(fm.purc_gu.value == '과세'){//과세1
			fm.car_f_amt.value = fm.car_c_amt.value;
		}else{//과세2(면세) 
			if('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || '<%=cm_bean.getS_st()%>' == '301' || '<%=cm_bean.getS_st()%>' =='302' || '<%=cm_bean.getS_st()%>' == '300'))){
				fm.car_f_amt.value = fm.car_c_amt.value;
			}else{
			
				var o_1 = toInt(parseDigit(fm.car_c_amt.value));
										
				//차종별 특소세율
				var o_2 = <%=ej_bean.getJg_3()%>;	
				
				//특소세전차량가 o_3 = o_1/(1+o_2), 차량가격/(1+특소세율);
				var o_3 = Math.round(o_1/(1+o_2));	
					
				fm.car_f_amt.value  = parseDecimal(o_3);				
			}									
		}	
		
		if(fm.car_off_id.value == '03900'){		
			fm.dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
		}
		
		set_car_amt();				
	}				
	
	//인수지로 배달지 디폴트
	function setOff(){
		var fm = document.form1;
		
		var deposit_len = fm.udt_firm.length;			
		for(var i = 1 ; i < deposit_len ; i++){
			fm.udt_firm.options[i] = null;			
		}
		
		if(fm.udt_st.value == '1'){
			fm.udt_firm.options[1] = new Option('영등포 영남주차장', '영등포 영남주차장');					
			fm.udt_firm.value = '영등포 영남주차장';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '2'){
			<%if(AddUtil.getDate2(4) >= 20210205){%>
			fm.udt_firm.options[1] = new Option('스마일TS', '스마일TS');
			fm.udt_firm.options[2] = new Option('웰메이드오피스텔 지하1층 주차장', '웰메이드오피스텔 지하1층 주차장');
			fm.udt_firm.options[3] = new Option('유림카(썬팅집)', '유림카(썬팅집)');
			fm.udt_firm.value = '스마일TS';
			<%}else{%>
			fm.udt_firm.options[1] = new Option('조양골프연습장 주차장', '조양골프연습장 주차장');
			fm.udt_firm.options[2] = new Option('웰메이드오피스텔 지하1층 주차장', '웰메이드오피스텔 지하1층 주차장');
			fm.udt_firm.options[3] = new Option('유림카(썬팅집)', '유림카(썬팅집)');
			fm.udt_firm.options[4] = new Option('스마일TS', '스마일TS');
			fm.udt_firm.value = '조양골프연습장 주차장';
			<%}%>
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '3'){
			fm.udt_firm.options[1] = new Option('미성테크', '미성테크');								
			fm.udt_firm.value = '미성테크';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '5'){
			fm.udt_firm.options[1] = new Option('대구 썬팅집', '대구 썬팅집');											
			fm.udt_firm.value = '대구 썬팅집';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '6'){
			fm.udt_firm.options[1] = new Option('용용이자동차용품점', '용용이자동차용품점');											
			fm.udt_firm.value = '용용이자동차용품점';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '4'){
			fm.udt_firm.options[1] = new Option('<%=client.getFirm_nm()%>', '<%=client.getFirm_nm()%>');											
			fm.udt_firm.value = '<%=client.getFirm_nm()%>';
			cng_input1(fm.udt_firm.value);
		}			
	}	
		
	//차량인수지 선택시 용품업체 셋팅
	function cng_input1(value){
		var fm = document.form1;
		
		
		
		if(fm.udt_firm.value == '영등포 영남주차장'){					
			fm.udt_addr.value 	= '서울시 영등포구 영등포로 34길 9';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_s.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_s.getUser_id()%>';			
		}else if(fm.udt_firm.value == '유림카(썬팅집)'){				
			fm.udt_addr.value 	= '부산광역시 연제구 연산4동 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';			
		}else if(fm.udt_firm.value == '조양골프연습장 주차장'){					
			fm.udt_addr.value 	= '부산광역시 연제구 연산4동 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '스마일TS'){			
			fm.udt_addr.value 	= '부산시 연제구 안연로7번나길 10(연산동 363-13번지)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';	

		}else if(fm.udt_firm.value == '웰메이드오피스텔 지하1층 주차장'){					
			fm.udt_addr.value 	= '부산광역시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';			
		}else if(fm.udt_firm.value == '오토카용품'){			
			fm.udt_addr.value 	= '대전광역시 유성구 노은동 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';						
		}else if(fm.udt_firm.value == '미성테크'){				
			fm.udt_addr.value = '대전광역시 유성구 온천북로59번길 10(봉명동 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';			
		}else if(fm.udt_firm.value == '대구 썬팅집'){				
			fm.udt_addr.value 	= '대구광역시 달서구 신당동 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';			
		}else if(fm.udt_firm.value == '용용이자동차용품점'){				
			fm.udt_addr.value 	= '광주광역시 광산구 상무대로 233 (송정동 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';			
		}else if(fm.udt_firm.value == '<%=client.getFirm_nm()%>'){				
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';		
		}
					
	}
	
	//재고여부 디스플레이
	function cng_input2(){
		var fm = document.form1;
		if(fm.stock_yn[0].checked == true){ 				//없음
			tr_stock1.style.display = '';		
			tr_stock2.style.display = 'none';		
		}else{								//있음
			tr_stock1.style.display = 'none';		
			tr_stock2.style.display = '';		
		}
	}	
		
	//계약관리-자동차를 반영하기
	function fms_copy(){
		var fm = document.form1;
		<%if(cng_item.equals("cng")){%>  
		
			
			fm.car_nm.value 	= fm.f_car_nm.value;
			fm.opt.value 		= fm.f_opt.value;
			fm.purc_gu.value 	= fm.f_purc_gu.value;
			fm.colo.value 		= fm.f_colo.value;
			fm.auto.value    	= fm.f_auto.value;
			fm.car_c_amt.value    	= fm.f_car_c_amt.value;
			fm.car_f_amt.value    	= fm.f_car_f_amt.value;
			
			if(fm.car_off_id.value == '03900'){
				fm.dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
			}
	
			set_car_amt();
		<%}%>
		
		<%if(cng_item.equals("amt")){%>
		
			fm.car_c_amt.value    	= fm.f_car_c_amt.value;
			fm.car_f_amt.value    	= fm.f_car_f_amt.value;
			
			//구입가 계산
			if(fm.car_f_amt.value == '0'){
				set_car_f_amt();
			}
			
			if(fm.car_off_id.value == '03900'){
				fm.dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
			}
	
			set_car_amt();
		
		<%}%>
	}
	

				
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="com_con_no" 	value="<%=com_con_no%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">    
  <input type='hidden' name="cng_item" 		value="<%=cng_item%>">
  <input type='hidden' name="seq" 		value="<%=seq%>">  
  <input type='hidden' name="udt_mng_id" 	value="">
  <input type='hidden' name="cng_size" 		value="<%=vt_size%>">
  <input type='hidden' name="car_off_id" 		value="<%=cpd_bean.getCar_off_id()%>">
  
  
  
  

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>계출수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>계약번호</td>
                    <td width=7% class=title>아마존카</td>
                    <td width=19%>&nbsp;<%=rent_l_cd%></td>
                    <td width=7% rowspan="2" class=title>계출일자</td>
                    <td width=7% class=title>계약등록일</td>
                    <td width="19%" >&nbsp;<%=AddUtil.ChangeDate10(cpd_bean.getReg_dt())%></td>
                    <td width=7% rowspan="2" class=title>담당자</td>
                    <td width=7% class=title>계출담당</td>
                    <td width="20%">&nbsp;<%=dlv_mng_bean.getDept_nm()%>&nbsp;<%=dlv_mng_bean.getUser_nm()%>&nbsp;<%=dlv_mng_bean.getUser_pos()%></td>
    		    </tr>
                <tr>
                  <td class=title><%=cm_bean.getCar_comp_nm()%></td>
                  <td>&nbsp;<%=cpd_bean.getCom_con_no()%></td>
                  <td class=title>출고희망일</td>
                  <td >&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_req_dt())%></td>
                  <td width=5% class=title>연락처</td>
                  <td>&nbsp;<%=dlv_mng_bean.getHot_tel()%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>    
    
    <%if(cng_item.equals("dlv")){%>          
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>배정</td>
                    <td width=7% class=title>구분</td>
                    <td width=19%>&nbsp;
                        <%if(cpd_bean.getDlv_st().equals("2")){%>
                        [배정]
        		&nbsp;
        		<input type='text' size='11' name='dlv_con_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		(날짜)
        		<%}else{%>
                        [예정]
        		&nbsp;
        		<input type='text' size='11' name='dlv_est_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		(날짜)
        		<%}%>
        	    </td>
                    <td width=7% rowspan="3" class=title>배달지</td>
                    <td width=7% class=title>구분</td>
                    <td width="19%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1")){%> selected<%}%>>서울본사</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2")){%> selected<%}%>>부산지점</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3")){%> selected<%}%>>대전지점</option>				
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5")){%> selected<%}%>>대구지점</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6")){%> selected<%}%>>광주지점</option>				        				
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4")){%> selected<%}%>>고객</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>담당자</td>
                    <td width="7%" class=title>부서/성명</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>    		   
                <tr>
                  <td class=title>출고사무소</td>
                  <td>&nbsp;<%	//출고지코드
        				if(emp2.getCar_comp_id().equals("0001")){
        					CodeBean[] p_codes = c_db.getCodeAll("0018");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0002")){
        					CodeBean[] p_codes = c_db.getCodeAll("0019");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0004")||emp2.getCar_comp_id().equals("0005")){
        					CodeBean[] p_codes = c_db.getCodeAll("0020");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0003")){
        					CodeBean[] p_codes = c_db.getCodeAll("0021");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			  <%}else{%>
        			  &nbsp;<input type='text' name='dlv_ext' size='15' value='<%=cpd_bean.getDlv_ext()%>' class='default' >
        			  <%}%>		
        	  </td>
                  <td class=title>지점/상호</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==선택==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="영등포 영남주차장" <%if(cpd_bean.getUdt_firm().equals("영등포 영남주차장")){%> selected<%}%>>영등포 영남주차장</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="조양골프연습장 주차장" <%if(cpd_bean.getUdt_firm().equals("조양골프연습장 주차장")){%> selected<%}%>>조양골프연습장 주차장</option>
        		    <option value="웰메이드오피스텔 지하1층 주차장" <%if(cpd_bean.getUdt_firm().equals("웰메이드오피스텔 지하1층 주차장")){%> selected<%}%>>웰메이드오피스텔 지하1층 주차장</option>
        		    <option value="유림카(썬팅집)" <%if(cpd_bean.getUdt_firm().equals("유림카(썬팅집)")){%> selected<%}%>>유림카(썬팅집)</option>
        		    <option value="스마일TS" <%if(cpd_bean.getUdt_firm().equals("스마일TS"))%> selected<%%>>스마일TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="미성테크" <%if(cpd_bean.getUdt_firm().equals("미성테크")){%> selected<%}%>>미성테크</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="대구 썬팅집" <%if(cpd_bean.getUdt_firm().equals("대구 썬팅집")){%> selected<%}%>>대구 썬팅집</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="용용이자동차용품점" <%if(cpd_bean.getUdt_firm().equals("용용이자동차용품점")){%> selected<%}%>>용용이자동차용품점</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm())){%> selected<%}%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
        		</td>
                  <td class=title>연락처</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>배달탁송료</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                  <td class=title>주소</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
        
    <%}%>
    
    <%if(cng_item.equals("stock")){%>          
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>주문차</td>
                    <td colspan='2'>&nbsp;
                    	<%if(cpd_bean.getOrder_car().equals("") || cpd_bean.getOrder_car().equals("N") || (cpd_bean.getOrder_car().equals("Y") && cpd_bean.getOrder_req_dt().equals(""))){%>
                    	<input type="checkbox" name="order_car" value="Y" <%if(cpd_bean.getOrder_car().equals("Y")){%>checked<%}%>>주문차
                    	<%}else{%>
                    	고객확인처리가 된 상태에서는 주문차 수정이 안됩니다.
                    	<input type='hidden' name='order_car' value='<%=cpd_bean.getOrder_car()%>'>
                    	<%}%>
                    </td>
                </tr>
                <tr>
                    <td width=14% class=title>재고여부</td>
                    <td width=19%>&nbsp;<input type='radio' name="stock_yn" value='N' <%if(cpd_bean.getStock_yn().equals("N")){%>checked<%}%> onClick="javascript:cng_input2()">
                      없음
                      <input type='radio' name="stock_yn" value='Y' <%if(cpd_bean.getStock_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input2()">
                      있음</td>
                    <td>
                        <table>
                            <tr id=tr_stock1 style="display:<%if(cpd_bean.getStock_yn().equals("N") || cpd_bean.getStock_yn().equals("")){%>''<%}else{%>none<%}%>">
                                <td>
                                    <input type='radio' name="stock_st" value='1' <%if(cpd_bean.getStock_st().equals("1")){%>checked<%}%>>
                      			납기정체(1주일이상)
                      		    <input type='radio' name="stock_st" value='2' <%if(cpd_bean.getStock_st().equals("2")){%>checked<%}%>>
                      			납기지체(1주일이내)
                      		    <input type='radio' name="stock_st" value='3' <%if(cpd_bean.getStock_st().equals("3")){%>checked<%}%>>
                      			납기지연(약1~2일)
                                </td>  
                            </tr>
                            <tr id=tr_stock2 style="display:<%if(cpd_bean.getStock_yn().equals("Y")){%>''<%}else{%>none<%}%>">
                                <td>
                                    재고상태 : 
                                    <input type='radio' name="stock_st" value='4' <%if(cpd_bean.getStock_st().equals("4")){%>checked<%}%>>
                      			일시적
                      		    <input type='radio' name="stock_st" value='5' <%if(cpd_bean.getStock_st().equals("5")){%>checked<%}%>>
                      			상시적
                                </td>  
                            </tr>                          
                        </table>                      
                    </td>     
                </tr>
                <tr> 
                    <td width=14% class=title>특이사항</td>
                    <td colspan='2'>&nbsp;<textarea rows='2' cols='90' name='bigo'><%=cpd_bean.getBigo()%></textarea></td>
                </tr>                 
            </table>
        </td>
    </tr>      
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>
        
    <%if(cng_item.equals("amt")){%> 
    <%		if(vt_size ==0 && nm_db.getWorkAuthUser("전산팀",user_id)){%> 
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>차명</td>
                    <td colspan="3">&nbsp;<input type='text' name='car_nm' size='100' value='<%=pur_com.get("R_CAR_NM")%>' class='text' ></td>
                </tr>
                <tr> 
                    <td width=14% class=title>선택사양</td>
                    <td colspan="3">&nbsp;<textarea rows='3' cols='100' name='opt' ><%=pur_com.get("R_OPT")%></textarea></td>
                </tr>
                 <tr> 
                    <td width=14% class=title>색상(외장/내장/가니쉬)</td>
                    <td colspan="3">&nbsp;<input type='text' name='colo' size='100' value='<%=pur_com.get("R_COLO")%>' class='text' ></td>
                </tr>
                <tr>
                  <td class=title>과세구분</td>
                  <td width="19%">&nbsp;<input type='text' name='purc_gu' size='4' value='<%=pur_com.get("R_PURC_GU")%>' class='text' ></td>                  
                  <td width=14% class=title>T/M</td>
                  <td>&nbsp;<input type='text' name='auto' size='4' value='<%=pur_com.get("R_AUTO")%>' class='text' ></td>
                </tr>	
            </table>
        </td>
    </tr>    
    <%		}%>   
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>차가</td>
                    <td width=7% class=title>소비자가</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_c_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_f_amt();'>원</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getDc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                    <td width="14%" class=title>D/C합계</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_d_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
    		    </tr>
                <tr>
                  <td class=title>구입가</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_f_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원<a href="javascript:set_car_f_amt()" onMouseOver="window.status=''; return true" title="구입가 계산하기">[계산]</a></td>
                  <td class=title>추가D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getAdd_dc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                  <td class=title>거래금액계</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>   
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>차량가격</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원</td>
                    <td width=14% class=title>배달탁송료</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원
                    <input type='hidden' name="cons_amt" value="<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>">    
                    <input type='hidden' name="purc_gu" value="<%=cpd_bean.getPurc_gu()%>">    
                    </td>
                    <td width=14% class=title>합계</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cpd_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원</td>
                </tr>
            </table>
        </td>
    </tr>           
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>
    <tr>
        <td><hr></td>
    </tr>       
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약관리 - 자동차</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <input type='hidden' name="f_car_c_amt" value="<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>">
                <input type='hidden' name="f_car_f_amt" value="<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>">
                <tr>
                  <td width=10% class=title>소비자가</td>
                  <td width=40%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>원</td>
                  <td width=10% class=title>구입가</td>
                  <td width=40%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>원</td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>D/C - 현재 견적변수 반영</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                  <td width=10% class=title>D/C</td>
                  <td width=90%>&nbsp;<input type='text' name='v_dc_amt' size='10' value=''  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>원
                      &nbsp;&nbsp;&nbsp;&nbsp;(<%=ej_bean.getJg_y()*100%>%)
                  </td>
                </tr>	
            </table>
        </td>
    </tr>     
    <!--
    <tr>
	<td align='center'>
	    <a href="javascript:fms_copy()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[계약관리-자동차 정보를 배정관리에 반영하기]</a>
	</td>
    </tr>        	                 
    -->
    <%}%>
    <%if(cng_item.equals("cng")){%>     
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약변경</span></td>
    </tr>         
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>변경구분</td>
                    <td colspan="3">&nbsp;<input type='text' name='cng_cont' size='60' value='' class='text' ></td>
                </tr>
                <tr> 
                    <td width=14% class=title>차명</td>
                    <td colspan="3">&nbsp;<input type='text' name='car_nm' size='100' value='<%=pur_com.get("R_CAR_NM")%>' class='text' ></td>
                </tr>
                <tr> 
                    <td width=14% class=title>선택사양</td>
                    <td colspan="3" >&nbsp;<textarea rows='3' cols='100' name='opt' ><%=pur_com.get("R_OPT")%></textarea></td>
                </tr>
                <tr> 
                    <td width=14% class=title>색상(외장/내장)</td>
                    <td colspan="3" >&nbsp;<input type='text' name='colo' size='100' value='<%=pur_com.get("R_COLO")%>' class='text' ></td>
                </tr>
                <tr>
                  <td class=title>과세구분</td>
                  <td width="19%">&nbsp;<input type='text' name='purc_gu' size='4' value='<%=pur_com.get("R_PURC_GU")%>' class='text' ></td>
                  <td width=14% class=title>T/M</td>
                  <td>&nbsp;<input type='text' name='auto' size='4' value='<%=pur_com.get("R_AUTO")%>' class='text' ></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>차가</td>
                    <td width=7% class=title>소비자가</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_C_AMT")))%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_DC_AMT")))%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                    <td width="14%" class=title>D/C합계</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_D_AMT")))%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
    		    </tr>
                <tr>
                  <td class=title>구입가</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_F_AMT")))%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원<a href="javascript:set_car_f_amt()" onMouseOver="window.status=''; return true" title="구입가 계산하기">[계산]</a></td>
                  <td class=title>추가D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_ADD_DC_AMT")))%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                  <td class=title>거래금액계</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_G_AMT")))%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                </tr>	
            </table>
        </td>
    </tr>        
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>차량가격</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_G_AMT")))%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원</td>
                    <td width=14% class=title>배달탁송료</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원
                    <input type='hidden' name="cons_amt" value="<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>">    
                    </td>
                    <td width=14% class=title>합계</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(pur_com.get("R_CAR_G_AMT")))+cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원</td>
                </tr>
            </table>
        </td>
    </tr>      
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>
    <tr>
        <td><hr></td>
    </tr>       
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약관리-자동차</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <input type='hidden' name="f_car_nm" 	value="<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%>">
                <input type='hidden' name="f_opt" 	value="<%=car.getOpt()%>">
                <input type='hidden' name="f_purc_gu" 	value="<%if(car.getPurc_gu().equals("1")){%>과세<%}else if(car.getPurc_gu().equals("0")){%>면세<%}%>">
                <input type='hidden' name="f_colo" 	value="<%=car.getColo()%>/<%=car.getIn_col()%>/<%=car.getGarnish_col()%>">                
                <input type='hidden' name="f_car_c_amt" value="<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>">
                <input type='hidden' name="f_car_f_amt" value="<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>">
                <input type='hidden' name="f_car_b" 	value="<%=cm_bean.getCar_b()%>">
                <tr> 
                    <td width=10% class=title>차명</td>
                    <td colspan="3">&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td class=title>선택사양</td>
                    <td colspan="5" >&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                  <td class=title>과세구분</td>
                  <td width=5%>&nbsp;<%if(car.getPurc_gu().equals("1")){%>과세<%}else if(car.getPurc_gu().equals("0")){%>면세<%}%></td>
                  <td width=10% class=title>색상</td>
                  <td width=20%>&nbsp;외장:<%=car.getColo()%>/내장:<%=car.getIn_col()%>/가니쉬:<%=car.getGarnish_col()%></td>
                  <td width=10% class=title>T/M</td>
                  <td width=5%>&nbsp;<input type='text' name='f_auto' size='4' value='<%if(cm_bean.getAuto_yn().equals("Y")){%>A/T<%}else{%>M/T<%}%>' class='whitetext' ></td>
                  <td width=10% class=title>소비자가</td>
                  <td width=10%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>원</td>
                  <td width=10% class=title>구입가</td>
                  <td width=10%>&nbsp;<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>원</td>

                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
	<td align='center'>
	    <a href="javascript:fms_copy()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[계약관리-자동차 정보를 배정관리에 반영하기]</a>
	</td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>D/C - 현재 견적변수 반영</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                  <td width=10% class=title>D/C</td>
                  <td width=90%>&nbsp;<input type='text' name='v_dc_amt' size='10' value=''  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>원
                      &nbsp;&nbsp;&nbsp;&nbsp;(<%=ej_bean.getJg_y()*100%>%)
                  </td>
                </tr>	
            </table>
        </td>
    </tr>         
    	     
    <%}%>
    <%if(cng_item.equals("cls1") || cng_item.equals("cls2")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약해지</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>해지구분</td>
                    <td>&nbsp;<input type="radio" name="cng_cont" value="납품취소" <%if(cng_item.equals("cls1")){%>checked<%}%>>
            			납품취소 
            			<!--
            			&nbsp;<input type="radio" name="cng_cont" value="신차취소현황으로 보내기">
            			신차취소현황으로 보내기 
            			&nbsp;<input type="radio" name="cng_cont" value="차종변경" <%if(cng_item.equals("cls2")){%>checked<%}%>>
            			차종변경
            			 -->
            	    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>사유</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='bigo'></textarea></td>
                </tr>   
                <%if(cng_item.equals("cls1") && base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>      
                <tr> 
                    <td width=14% class=title>계약해지</td>
                    <td>&nbsp;<input type="radio" name="cont_use_yn" value="N">
            			해지한다
            		<input type="radio" name="cont_use_yn" value="Y">
            			계약유지한다
            			&nbsp;&nbsp;&nbsp;&nbsp;
            			( 계약자가 (주)아마존카인 가계약상태일 때 해지처리 여부)
            	    </td>
                </tr>                
                <%}%> 
                
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>
    <%if(cng_item.equals("re")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재배정요청</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>구분</td>
                    <td>&nbsp;재배정요청 <input type='hidden' name='cng_cont' value='재배정요청'> </td>
                </tr>
                <tr> 
                    <td width=14% class=title>출고희망일</td>
                    <td>&nbsp;<input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td width=14% class=title>사유</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='bigo'></textarea></td>
                </tr>
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>    
    <%if(cng_item.equals("re_act")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>재배정요청 반영</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>배정구분</td>
                    <td>&nbsp;예정 <input type='hidden' name='dlv_st' value='1'> </td>
                </tr>
                <tr> 
                    <td width=14% class=title>출고예정일</td>
                    <td>&nbsp;<input type='text' size='11' name='dlv_est_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>      
    <%if(cng_item.equals("cng_amt")){
    		//변경관리		
		CarPurDocListBean cng_bean = cod.getCarPurComCng(rent_mng_id, rent_l_cd, com_con_no, seq);
    	%>   
    	<input type='hidden' name="purc_gu" 		value="<%=cpd_bean.getPurc_gu()%>">
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>차가</td>
                    <td width=7% class=title>소비자가</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_c_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getDc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                    <td width="14%" class=title>D/C합계</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_d_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
    		    </tr>
                <tr>
                  <td class=title>구입가</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_f_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원<a href="javascript:set_car_f_amt()" onMouseOver="window.status=''; return true" title="구입가 계산하기">[계산]</a></td>
                  <td class=title>추가D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getAdd_dc_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                  <td class=title>거래금액계</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>원</td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>   
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>차량가격</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원</td>
                    <td width=14% class=title>배달탁송료</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원
                    <input type='hidden' name="cons_amt" value="<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>">    
                    </td>
                    <td width=14% class=title>합계</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(cng_bean.getCar_g_amt()+cpd_bean.getCons_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원</td>
                </tr>
            </table>
        </td>
    </tr>            
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>D/C - 현재 견적변수 반영</span></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                  <td width=10% class=title>D/C</td>
                  <td width=90%>&nbsp;<input type='text' name='v_dc_amt' size='10' value=''  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>원
                      &nbsp;&nbsp;&nbsp;&nbsp;(<%=ej_bean.getJg_y()*100%>%)
                  </td>
                </tr>	
            </table>
        </td>
    </tr>              
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	                 
    <%}%>   
    <%if(cng_item.equals("con")){%>          
    <input type='hidden' name="add_dc_amt" 		value="<%=pur_com.get("R_ADD_DC_AMT")%>">
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>배정</td>
                    <td width=7% class=title>구분</td>
                    <td width=19%>&nbsp;[배정]
        		&nbsp;
        		<%  cpd_bean.setDlv_con_dt(AddUtil.getDate()); %>
        		<input type='text' size='11' name='dlv_con_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		(날짜)
        	    </td>
                    <td width=7% rowspan="3" class=title>배달지</td>
                    <td width=7% class=title>구분</td>
                    <td width="19%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1")){%> selected<%}%>>서울본사</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2")){%> selected<%}%>>부산지점</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3")){%> selected<%}%>>대전지점</option>				
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5")){%> selected<%}%>>대구지점</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6")){%> selected<%}%>>광주지점</option>				        				        				
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4")){%> selected<%}%>>고객</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>담당자</td>
                    <td width="7%" class=title>부서/성명</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>
    		    <%	//현대자동차 출고지코드
    		    	CodeBean[] p_codes = c_db.getCodeAll("0018");
        		int p_size = p_codes.length;
        		String dlv_ext_yn = "";
    		    %>
                <tr>
                  <td class=title>출고사무소</td>
                  <td>&nbsp;<select name='dlv_ext' class='default'>
                                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	        						
        						%>
        				<option value='<%=code.getNm()%>' <%if(cpd_bean.getDlv_ext().equals(code.getNm())){  dlv_ext_yn = "Y";%> selected<%}%>><%= code.getNm()%></option>
        				<%	}%>        		
        				<option value="other">직접입력</option>		
                                    </select>
                                    &nbsp;
                                    <input type='text' name='dlv_ext_sub' size='8' value='<%if(dlv_ext_yn.equals("")){%><%=cpd_bean.getDlv_ext()%><%}%>' class='text' >
        	  </td>
                  <td class=title>지점/상호</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==선택==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="영등포 영남주차장" <%if(cpd_bean.getUdt_firm().equals("영등포 영남주차장")){%> selected<%}%>>영등포 영남주차장</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="조양골프연습장 주차장" <%if(cpd_bean.getUdt_firm().equals("조양골프연습장 주차장")){%> selected<%}%>>조양골프연습장 주차장</option>
        		    <option value="웰메이드오피스텔 지하1층 주차장" <%if(cpd_bean.getUdt_firm().equals("웰메이드오피스텔 지하1층 주차장")){%> selected<%}%>>웰메이드오피스텔 지하1층 주차장</option>
        		    <option value="유림카(썬팅집)" <%if(cpd_bean.getUdt_firm().equals("유림카(썬팅집)")){%> selected<%}%>>유림카(썬팅집)</option>
        		    <option value="스마일TS" <%if(cpd_bean.getUdt_firm().equals("스마일TS"))%> selected<%%>>스마일TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="미성테크" <%if(cpd_bean.getUdt_firm().equals("미성테크")){%> selected<%}%>>미성테크</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="대구 썬팅집" <%if(cpd_bean.getUdt_firm().equals("대구 썬팅집")){%> selected<%}%>>대구 썬팅집</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="용용이자동차용품점" <%if(cpd_bean.getUdt_firm().equals("용용이자동차용품점")){%> selected<%}%>>용용이자동차용품점</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm())){%> selected<%}%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select></td>
                  <td class=title>연락처</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>배달탁송료</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                  <td class=title>주소</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>     
    
    <%if(cng_item.equals("cng2")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배정후 변경사항</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>출고일자</td>
                    <td width=7% class=title>변경전</td>
                    <td width=19%>&nbsp;<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%><input type='hidden' name='dlv_con_dt_a' value='<%=cpd_bean.getDlv_con_dt()%>'></td>
                    <td width=7% rowspan="3" class=title>배달지<br>(변경후)</td>
                    <td width=7% class=title>구분</td>
                    <td width="19%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==선택==</option>
        				<option value="1" <%if(cpd_bean.getUdt_st().equals("1")){%> selected<%}%>>서울본사</option>
        				<option value="2" <%if(cpd_bean.getUdt_st().equals("2")){%> selected<%}%>>부산지점</option>
        				<option value="3" <%if(cpd_bean.getUdt_st().equals("3")){%> selected<%}%>>대전지점</option>				
        				<option value="5" <%if(cpd_bean.getUdt_st().equals("5")){%> selected<%}%>>대구지점</option>
        				<option value="6" <%if(cpd_bean.getUdt_st().equals("6")){%> selected<%}%>>광주지점</option>				        				        				        				
        				<option value="4" <%if(cpd_bean.getUdt_st().equals("4")){%> selected<%}%>>고객</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>담당자</td>
                    <td width="7%" class=title>부서/성명</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cpd_bean.getUdt_mng_nm()%>' class='text' ></td>
    		    </tr>    		    
                <tr>
                  <td class=title>변경후</td>
                  <td>&nbsp;<input type='text' size='11' name='dlv_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_con_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>        		
        	  </td>
                  <td class=title>지점/상호</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==선택==</option>
        		    <%if(cpd_bean.getUdt_st().equals("1")){%>
        		    <option value="영등포 영남주차장" <%if(cpd_bean.getUdt_firm().equals("영등포 영남주차장")){%> selected<%}%>>영등포 영남주차장</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("2")){%>
        		    <option value="조양골프연습장 주차장" <%if(cpd_bean.getUdt_firm().equals("조양골프연습장 주차장")){%> selected<%}%>>조양골프연습장 주차장</option>
        		    <option value="웰메이드오피스텔 지하1층 주차장" <%if(cpd_bean.getUdt_firm().equals("웰메이드오피스텔 지하1층 주차장")){%> selected<%}%>>웰메이드오피스텔 지하1층 주차장</option>
        		    <option value="유림카(썬팅집)" <%if(cpd_bean.getUdt_firm().equals("유림카(썬팅집)")){%> selected<%}%>>유림카(썬팅집)</option>
        		    <option value="스마일TS" <%if(cpd_bean.getUdt_firm().equals("스마일TS"))%> selected<%%>>스마일TS</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("3")){%>
        		    <option value="미성테크" <%if(cpd_bean.getUdt_firm().equals("미성테크")){%> selected<%}%>>미성테크</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("5")){%>
        		    <option value="대구 썬팅집" <%if(cpd_bean.getUdt_firm().equals("대구 썬팅집")){%> selected<%}%>>대구 썬팅집</option>
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("6")){%>
        		    <option value="용용이자동차용품점" <%if(cpd_bean.getUdt_firm().equals("용용이자동차용품점")){%> selected<%}%>>용용이자동차용품점</option>				
        		    <%}%>
        		    <%if(cpd_bean.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cpd_bean.getUdt_firm().equals(client.getFirm_nm())){%> selected<%}%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
        		</td>
                  <td class=title>연락처</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cpd_bean.getUdt_mng_tel()%>' class='text' ></td>
                </tr>
                <tr>
                  <td class=title colspan="2">배달탁송료</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(cpd_bean.getCons_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                  <td class=title>주소</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cpd_bean.getUdt_addr()%>' class='text' ></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>   
    
    <%if(cng_item.equals("cls3")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배정취소</span></td>
    </tr>             
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            
                <tr> 
                    <td width=14% class=title>해지구분</td>
                    <td>&nbsp;배정취소 <input type='hidden' name='cng_cont' value='배정취소'>
            	    </td>
                </tr>
                <tr> 
                    <td width=14% class=title>사유</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='bigo'></textarea></td>
                </tr>       
                <%if(base.getClient_id().equals("000228") && !base.getCar_st().equals("2")){%>      
                <tr> 
                    <td width=14% class=title>계약해지</td>
                    <td>&nbsp;<input type="radio" name="cont_use_yn" value="N">
            			해지한다
            		<input type="radio" name="cont_use_yn" value="Y">
            			계약유지한다
            			&nbsp;&nbsp;&nbsp;&nbsp;
            			( 계약자가 (주)아마존카인 가계약상태일 때 해지처리 여부)
            	    </td>
                </tr>                
                <%}%>                             
            </table>
        </td>
    </tr>   
    <tr>
        <td> <font color=red>* 배정취소처리되면 <b>예정현황</b>으로 넘어가 배정 대기상태가 됩니다. 해지는 아닙니다.</font>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>     
    
    <%if(cng_item.equals("settle")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고요청</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <%if(cpd_bean.getDlv_dt().equals("")) cpd_bean.setDlv_dt(AddUtil.getDate());%>
                    <td width=14% class=title>출고일자</td>
                    <td>&nbsp;<input type='text' size='11' name='dlv_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>      
    
    <%if(cng_item.equals("dlv_dt")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고일자</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                    
                    <td width=14% class=title>출고일자</td>
                    <td>&nbsp;<input type='text' size='11' name='dlv_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(cpd_bean.getDlv_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>    
        
    <%if(cng_item.equals("com_con_no")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>특판계약번호 변경</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                     
                    <td width=14% class=title>계약번호</td>
                    <td>&nbsp;<%=cpd_bean.getCom_con_no()%><input type='hidden' name="o_com_con_no" value="<%=cpd_bean.getCom_con_no()%>"> -> <input type='text' size='15' name='n_com_con_no' maxlength='20' class='default' value='<%=cpd_bean.getCom_con_no()%>'></td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    
    <%}%>        
    
    
    <%if(cng_item.equals("cons_off")){%>      
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배달탁송사</span></td>
    </tr>            
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>                    
                    <td width=14% class=title>배달탁송사</td>
                    <td>&nbsp;상호 : <input type='text' name='cons_off_nm' maxlength='50' value='<%=cpd_bean.getCons_off_nm()%>' class='text' size='40' >
                  	&nbsp;&nbsp;&nbsp;&nbsp;
                  	연락처 : <input type='text' name='cons_off_tel' maxlength='50' value='<%=cpd_bean.getCons_off_tel()%>' class='text' size='20' >
                  </td>
 		</tr>    		    
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align='center'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	    
    <%}%>     
    
    <%if((cng_item.equals("cls1") || cng_item.equals("cls2")) && !base.getUse_yn().equals("N")){%>  
    <tr> 
        <td>※ 출고전해지는 해지처리 완료되면 사전계약관리에 자동등록됩니다. (신차취소현황으로 보내기는 사전계약관리에서 대체 관리합니다.)<!-- 신차취소현황으로 보내기는 출고전해지를 먼저 처리해야 합니다. --></td>
    </tr>  
    <!-- 
    <%	if(cpd_bean.getDlv_st().equals("1") && AddUtil.parseInt(cpd_bean.getDlv_est_dt()) <= AddUtil.parseInt(AddUtil.getDate(4)) ){%>
    <tr> 
        <td>※ 예정일자가 경과되었습니다. 납기단축 예약기간 등록이 안됩니다. 신차취소현황으로 보내기를 하려면 출고담당자에게 예정일 변경요청을 하십시오.</td>
    </tr>      
    <%	}%>
    <%	if(cpd_bean.getDlv_st().equals("2") && AddUtil.parseInt(cpd_bean.getDlv_con_dt()) <= AddUtil.parseInt(AddUtil.getDate(4)) ){%>
    <tr> 
        <td>※ 배정일자가 경과되었습니다. 납기단축 예약기간 등록이 안됩니다. 신차취소현황으로 보내기를 하려면 출고담당자에게 배정일 변경요청을 하십시오.</td>
    </tr>      
    <%	}%>
     -->
    <%}%>         
              
</table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	<%if(cng_item.equals("cng")){%>     
		if(fm.f_auto.value == 'M/T' && fm.f_car_b.value.indexOf('자동변속기') != -1){
			fm.f_auto.value = 'A/T';
		}
		if(fm.f_auto.value == 'M/T' && fm.f_opt.value.indexOf('변속기') != -1){
			fm.f_auto.value = 'A/T';
		}
		if(fm.f_auto.value == 'M/T' && fm.f_opt.value.indexOf('DCT') != -1){
			fm.f_auto.value = 'A/T';
		}
		if(fm.f_auto.value == 'M/T' && fm.f_opt.value.indexOf('C-TECH') != -1){
			fm.f_auto.value = 'A/T';
		}	
		if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('A/T') != -1){
			fm.auto.value = 'A/T';
		}			
		if(fm.f_auto.value == 'M/T' && fm.f_car_b.value.indexOf('무단 변속기') != -1){
			fm.f_auto.value = 'A/T';
		}
	<%}%>
	
	
	<%if(cng_item.equals("amt") || cng_item.equals("cng") || cng_item.equals("cng_amt")){%>         
        fm.v_dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );         
        <%}%>
        
        //대전지점은 배달탁송료 수정못하게 한다.
        <%if(cng_item.equals("dlv") || cng_item.equals("con") || cng_item.equals("cng2")){%>
        <%	if(cpd_bean.getUdt_st().equals("3")){%>
        <%		if(user_id.equals("000048") || user_id.equals("000197")){%>								
			<%}else{%>
        //fm.cons_amt.readOnly = true;   // readonly
        <%		}%>
        <%	}%>
        <%}%>
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

