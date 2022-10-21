<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS Client_Info</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40Px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}



.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}


/* 둥근테이블 시작 */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}





/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:16px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:15px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:15px 0 0 0;}




</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.* "%>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")	==null?"":request.getParameter("car_no");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String est_nm 		= request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
	String est_ssn		= request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn");
	String est_tel 		= request.getParameter("est_tel")==null?"":request.getParameter("est_tel");
	String est_fax 		= request.getParameter("est_fax")==null?"":request.getParameter("est_fax");
	String est_email 	= request.getParameter("est_email")==null?"":request.getParameter("est_email");
	String doc_type 	= request.getParameter("doc_type")==null?"1":request.getParameter("doc_type");
	String damdang_id	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	
	String st 			= request.getParameter("st")		==null?"":request.getParameter("st");
	String esti_nm 		= request.getParameter("esti_nm")	==null?"":request.getParameter("esti_nm");
	String a_a 			= request.getParameter("a_a")		==null?"":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")		==null?"":request.getParameter("a_b");
	String pp_st 		= request.getParameter("pp_st")		==null?"":request.getParameter("pp_st");
	String rg_8 		= request.getParameter("rg_8")		==null?"":request.getParameter("rg_8");
	String est_code 	= request.getParameter("est_code")	==null?"":request.getParameter("est_code");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	String o_1 			= request.getParameter("o_1")		==null?"":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":request.getParameter("rent_dt");
	String amt 			= request.getParameter("amt")		==null?"":request.getParameter("amt");
	String page_kind 	= request.getParameter("page_kind")	==null?"":request.getParameter("page_kind");
	
	//불량고객 확인
	Vector vt_chk1 = bc_db.getBadCustRentCheck(est_nm, est_nm, "", "", est_tel, "", "", est_email, est_fax, "", "");
	int vt_chk1_size = vt_chk1.size(); 	
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String car_comp_id = "0001";
	
	//기본견적,조정견적
	if(!st.equals("1")){
		est_id = e_db.getSearchEstIdSh(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
	//출고지연대차견적
	}else{
		est_id = e_db.getSearchEstIdTaeSh(car_mng_id, a_a, o_1, today_dist, rent_dt, est_code);
	}
	e_bean = e_db.getEstimateShCase(est_id);
	
	
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	if(st.equals("1")){
		e_bean.setA_a	(a_a);
		e_bean.setA_b	(a_b);
	}
	
	//차량정보
	Hashtable ht = e_db.getShBase(car_mng_id);
	
	String a_e = String.valueOf(ht.get("S_ST"));
	
	/* 코드 구분:대여상품명 */
	CodeBean[] goods = c_db.getCodeAll("0009"); 
	int good_size = goods.length;
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	String jg_b_dt = e_db.getVar_b_dt(String.valueOf(ht.get("JG_CODE")), "jg", rent_dt);
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(String.valueOf(ht.get("JG_CODE")), jg_b_dt);		
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//한도와 비교, 비율==금액 변환
	function compare(obj){
		var fm = document.form1;
		var a_a = '<%=e_bean.getA_a()%>';
		if(obj == fm.rg_8){
			fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8.value)/100);	
		}else if(obj == fm.rg_8_amt){
			var rg_8 = toInt(parseDigit(fm.rg_8_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			fm.rg_8.value = Math.round(rg_8);	
		}else if(obj == fm.pp_per){
			fm.pp_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per.value)/100);						
		}else if(obj == fm.pp_amt){
			fm.pp_per.value = Math.round(toInt(parseDigit(fm.pp_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}else if(obj == fm.ro_13){
			fm.ro_13_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.ro_13.value)/100);		
		}else if(obj == fm.ro_13_amt){
			var ro_13 = toInt(parseDigit(fm.ro_13_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			fm.ro_13.value = Math.round(ro_13);		
		}else if(obj == fm.gi_per){
			fm.gi_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.gi_per.value)/100);						
		}else if(obj == fm.gi_amt){
			fm.gi_per.value = Math.round(toInt(parseDigit(fm.gi_amt.value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}	
	}	
	
	//견적내기
	function EstiReg(){
		var fm = document.form1;
		
		
		<%if(vt_chk1_size>0){%>
		if(fm.st.value == '2'){//기본견적
			alert('[<%=est_nm%>]은 불량고객으로 등록된 고객과 동일인지 여부를 확인 후 진행하시기 바랍니다. 조정견적에서 확인하고 처리하세요.'); 
			return;
		}
		<%}%>
		
				
		var a_a = '<%=e_bean.getA_a()%>';
		var ins_age = fm.ins_age.options[fm.ins_age.selectedIndex].value;
				
		var a_h = 1;
		var a_e = '<%=a_e%>';
		var a_a = a_a.substring(0,1);
		var au28 = 0;
		var av28 = 0;
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;//7-9인승2000cc초과짚여부
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;//대형승용여부
		
		if(a_a != ''){
			if(a_a=='1'){//리스		
				if(av28==1){
					a_h = 4;	
				}else{
					if(au28==1){
						if(fm.udt_st.value == '1') 			a_h = 1; //본사인수일때 서울
						else if(fm.udt_st.value == '2') 	a_h = 4; //부산인수일대 경남
						else if(fm.udt_st.value == '3') 	a_h = 4; //대전인수일때 경남
						else if(fm.udt_st.value == '4') 	a_h = 1; //고객인수일대 서울
					}else{
						if(fm.udt_st.value == '1') 			a_h = 2; //본사인수일때 경기
						else if(fm.udt_st.value == '2') 	a_h = 4; //부산인수일대 경남
						else if(fm.udt_st.value == '3') 	a_h = 4; //대전인수일때 경남
						else if(fm.udt_st.value == '4') 	a_h = 1; //고객인수일대 서울
					}
				}				
			}else{//렌트
				if(fm.udt_st.value == '1') 					a_h = 2; //본사인수일때 경기
				else if(fm.udt_st.value == '2') 			a_h = 4; //부산인수일대 경남
				else if(fm.udt_st.value == '3') 			a_h = 4; //대전인수일때 경남
			}
			fm.a_h.value = a_h;
		}
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		/*
		if(a_a == '12'){
			if(fm.insurant.value == '2' && fm.ins_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('보험계약자 고객은 리스기본식만 가능합니다.');
				return;
			}			
		}	
		*/		
		// 보증금 차가 100% 제한		2018.1.4
		/* var car_o_1 = fm.o_1.value;
		var car_rg_8_amt = fm.rg_8_amt.value.replace(/,/gi,'');		
	    if(Number(car_rg_8_amt) > Number(car_o_1)){
	    	alert('보증금은 차가의 100% 이내만 납부 가능합니다. \n\n추가로 초기납입금 납부를 원할 경우 선납금으로 납부하시면 됩니다.');
	    	return;
	    } */
		
		<%if(ej_bean.getJg_w().equals("1")){%>
			if(parseDigit(fm.car_ja.value) != '500000'){
      	alert('면책금 금액이 틀렸습니다.'); return;
      }
		<%}else{%>
			if(parseDigit(fm.car_ja.value) == '300000' || parseDigit(fm.car_ja.value) == '200000' || parseDigit(fm.car_ja.value) == '100000'){
      }else{
      	alert('면책금 금액이 틀렸습니다.'); return;
      }
		<%}%>
		
		if(!fm.st.value == '2'){//기본견적
			if(!confirm('견적하시겠습니까?')){	return; }
		}
		fm.cmd.value = "i";
		fm.action = 'sh_car_esti_i_a.jsp';
//		fm.target = "_self";
		fm.target = "i_no";
		fm.submit();
	}
	
	//불량고객
	function view_badcust(est_nm, lic_no, est_tel, est_o_tel, est_mail, est_fax, est_comp_tel, est_comp_cel, driver_cell)
	{
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_i_20090901.jsp&est_nm='+est_nm+'&lic_no='+lic_no+'&est_tel='+est_tel+'&est_o_tel='+est_o_tel+'&est_mail='+est_mail+'&est_fax='+est_fax+'&est_comp_tel='+est_comp_tel+'&est_comp_cel='+est_comp_cel+'&driver_cell='+driver_cell, "BADCUST", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}			

//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>

    <input type="hidden" name="est_id" 		value="<%=est_id%>">		
	<input type="hidden" name="est_nm" 		value="<%=est_nm%>">		
    <input type="hidden" name="est_ssn" 	value="<%=est_ssn%>">		
    <input type="hidden" name="est_tel" 	value="<%=est_tel%>">			
    <input type="hidden" name="est_fax" 	value="<%=est_fax%>">		
    <input type="hidden" name="est_email" 	value="<%=est_email%>">		
    <input type="hidden" name="doc_type" 	value="<%=doc_type%>">			
    <input type="hidden" name="damdang_id" 	value="<%=damdang_id%>">			
	
	<input type="hidden" name="st"	 			value="<%=st%>">
	<input type="hidden" name="esti_nm"			value="<%=esti_nm%>">
	<input type="hidden" name="a_a"				value="<%=a_a%>">
	<input type="hidden" name="a_b"				value="<%=a_b%>">
	<input type="hidden" name="o_1"				value="<%=o_1%>">	
	<input type="hidden" name="rent_dt"			value="<%=rent_dt%>">
	<input type="hidden" name="today_dist"		value="<%=today_dist%>">	
	<input type="hidden" name="est_code"		value="<%=est_code%>">			
	<input type="hidden" name="page_kind"		value="<%=page_kind%>">
	
    <input type="hidden" name="a_e" value="<%=a_e%>">
	<input type="hidden" name="a_h" value="">	
	<input type="hidden" name="ins_good" value="0"><!--애니카보험:미가입-->			
    <input type="hidden" name="cmd" value="">	
	
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><%=car_no%> 재리스견적내기</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
            
        </div>
    </div>
    <div id="contents">
    	<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">고객정보</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th width="90" valign=top>상호/성명</th>
							<td valign=top><%=est_nm%>
    <%if(vt_chk1_size>0){%>
    <br>※ [<%=est_nm%>]은 불량고객으로 등록된 고객과 동일인지 여부를 확인 후 진행하시기 바랍니다.
        	<input type="button" class="button" id="bad_cust" value='내용보기' onclick="javascript:view_badcust('<%=est_nm%>', '', '<%=est_tel%>', '', '<%=est_email%>', '<%=est_fax%>', '', '', '');">	        
    <%}%>								
								
								</td>
						</tr>
				    	<tr>
				    		<th>신용도구분</th>
				    		<td><select name="spr_yn">
                        		  <option value="">=선 택=</option>
								  <option value="3" <% if(e_bean.getSpr_yn().equals("3")) out.print("selected"); %>>신설법인</option>
								  <option value="0" <% if(e_bean.getSpr_yn().equals("0")) out.print("selected"); %>>일반기업</option>
								  <option value="1" <% if(e_bean.getSpr_yn().equals("1")) out.print("selected"); %>>우량기업</option>
								  <option value="2" <% if(e_bean.getSpr_yn().equals("2")||e_bean.getSpr_yn().equals("")) out.print("selected"); %>>초우량기업</option>
                      			</select></td>
				    	</tr>																									
				    	<tr>
				    		<th>견적유효기간</th>
				    		<td><select name="vali_type">
					    		<option value="">선택</option>
                        		<option value="0" <%if(e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals(""))%>selected<%%>>날짜만표기(10일)</option>
                        		<option value="1" <%if(e_bean.getVali_type().equals("1"))%>selected<%%>>메이커D/C 변경 가능성 언급</option>
                       			<option value="2" <%if(e_bean.getVali_type().equals("2"))%>selected<%%>>미확정견적</option>						
                      		</select>
        	 		  		</td>
				    	</tr>																																																								
				    	<tr>
				    		<th>담당자</th>
				    		<td><select name='damdang_id' class=default>            
                        <option value="">미지정</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(ck_acar_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        	 		  		</td>
				    	</tr>																																																								
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">차량정보</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="100">제조사</th>
				    		<td><%=cm_bean.getCar_comp_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>차명</th>
				    		<td><%=cm_bean.getCar_nm()%></td>
				    	</tr>	
						<tr>
							<th>차종</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=cm_bean.getCar_name()%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getCar_amt())%>원</td>
									</tr>
								</table>
							</td>
						</tr>					
						<tr>
							<th>옵션</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=e_bean.getOpt()%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>원</td>
									</tr>
								</table>
							</td>
						</tr>				
						<tr>
							<th>색상</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=e_bean.getCol()%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getCol_amt())%>원</td>
									</tr>
								</table>
							</td>
						</tr>						
						<tr>
							<th>감가상각</th>
							<td align="right"><%=AddUtil.parseDecimal(e_bean.getCar_amt()+e_bean.getOpt_amt()+e_bean.getCol_amt()-e_bean.getO_1())%>원
							</td>
						</tr>																																
						<tr>
							<th>재리스기준가격</th>
							<td align="right"><%=AddUtil.parseDecimal(e_bean.getO_1())%>원
							</td>
						</tr>																																
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">계약조건</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th>대여상품</th>
				    		<td><%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%>
								<%if(st.equals("1")){%>
								- 출고전대차
								<%}%>
							</td>
				    	</tr>	
						<tr>
							<th>대여기간</th>
							<td><%=e_bean.getA_b()%>개월</td>
						</tr>	
                <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20150216){%>
                <%
              		int b_agree_dist =0;
              		int agree_dist   =0;
              	
           		b_agree_dist = 30000;
           		
			//국산 디젤 +5000
			if(!ej_bean.getJg_w().equals("1") && ej_bean.getJg_b().equals("1")){
				b_agree_dist = b_agree_dist+5000;
			}				
			//LPG +5000
			if(ej_bean.getJg_b().equals("2")){
				b_agree_dist = b_agree_dist+5000;				
			}
			
			agree_dist = b_agree_dist;
					
			//수입차-10000			
			if(ej_bean.getJg_w().equals("1")){	
				agree_dist = agree_dist-10000;				
			}
		
              %>     						
				    	<tr>
				    		<th width="90">표준약정운행거리</th>
				    		<td><input type="text" name="b_agree_dist" class=whitenum size="10" value='<%=AddUtil.parseDecimal(b_agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/년
				    		</td>
				    	</tr>																	
				    	<tr>
				    		<th width="90">적용약정운행거리</th>
				    		<td><input type="text" name="agree_dist" class=whitenum size="10" value='<%=AddUtil.parseDecimal(agree_dist)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km/년
				    		</td>
				    	</tr>	
    	      <%}%>																
				    	<tr>
				    		<th width="90">적용잔가</th>
				    		<td><input type="text" name="ro_13" size="4" class=text  value='<%//=e_bean.getRo_13()%>' onblur="javascript:compare(this)">%
	                      		<input type="text" name="ro_13_amt" class=num size="10" value='<%//=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		원<br>
						  		(매입옵션 금액임, 미입력시 최대잔가율로 계산됨)
        	 		  		</td>
				    	</tr>																													
				    	<tr>
				    		<th>매입옵션</th>
				    		<td><input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")||e_bean.getOpt_chk().equals("")){%> checked <%}%>>
                      			미부여
                      			<input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		 			부여
							</td>
				    	</tr>
				    	<tr>
				    		<th>보증금</th>
				    		<td><input type="text" name="rg_8" class=num size="4" value='<%=e_bean.getRg_8()%>' onBlur="javascript:compare(this)">%
								<%if(st.equals("1")){%>
								||
								<%}%>
	                      		<input type="text" name="rg_8_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		원
								<%if(st.equals("1")){%>
								<br>
								(신차 계약시 받은 보증금 금액을 입력해 주세요.)
								<%}%>
        	 		  		</td>
				    	</tr>				
				    	<tr>
				    		<th>선납금</th>
				    		<td><input type="text" name="pp_per" class=num size="4" value="<%=e_bean.getPp_per()%>" onBlur="javascript:compare(this)">%
								<%if(st.equals("1")){%>
								||
								<%}%>
	                      		<input type="text" name="pp_amt" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		원
								<%if(st.equals("1")){%>
								<br>
								(신차 계약시 받은 선납금 금액을 입력해 주세요.)
								<%}%>								
        	 		  		</td>
				    	</tr>			
				    	<tr>
				    		<th>개시대여료</th>
				    		<td><input type="text" name="g_10" class=num size="2" value="<%=e_bean.getG_10()%>">개월치
								<%if(st.equals("1")){%>
								||
	                      		<input type="text" name="g_10_amt" class=num size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
    	                  		원								
								<%}%>
								<%if(st.equals("1")){%>
								<br>
								(신차 계약시 받은 개시대여료 금액을 입력해 주세요.)
								<%}%>							
        	 		  		</td>
				    	</tr>	
				    	<!--
				    	<tr>
				    		<th>보험계약자</th>
				    		<td><select name="insurant">
                            <option value="1" <%if(e_bean.getInsurant().equals("1")||e_bean.getInsurant().equals(""))%>selected<%%>>아마존카</option>
                            <option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>고객</option>
                          </select>
        	 		  		</td>
				    	</tr>
				    	-->
				    	<tr>
				    		<th>피보험자</th>
				    		<td><select name="ins_per">
                            <option value="1" <%if(e_bean.getIns_per().equals("1")||e_bean.getIns_per().equals(""))%>selected<%%>>아마존카(보험포함)</option>
                            <!--<option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>고객(보험미포함)</option>-->
                          </select>
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>운전자연령</th>
				    		<td><select name="ins_age">
                			<option value="1" <%if(e_bean.getIns_age().equals("1")||e_bean.getIns_age().equals(""))%>selected<%%>>만26세이상</option>
   							<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>만24세이상</option>
                			<option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>만21세이상</option>
               			 	</select>
        	 		  		</td>
				    	</tr>																																																																																																							
				    	<tr>
				    		<th>대물/자손</th>
				    		<td><select name="ins_dj" >
                			<option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5천만원/5천만원</option>
                			<option value="2" <%if(e_bean.getIns_dj().equals("2")||e_bean.getIns_dj().equals(""))%>selected<%%>>1억원/1억원</option>
                			<option value="4" <%if(e_bean.getIns_dj().equals("4"))%>selected<%%>>2억원/1억원</option>
               	 			</select>
        	 		  		</td>
				    	</tr>																																																				
				    	<tr>
				    		<th>자차면책금</th>
				    		<td><input type="text" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
        	 		  		</td>
				    	</tr>																																																							
				    	<tr <%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>style="display: none;"<%}%>>
				    		<th>보증보험</th>
				    		<td><input type="text" name="gi_per" class=num size="4" value='<%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>0<%} else {%><%=e_bean.getGi_per()%><%}%>' onBlur="javascript:compare(this)">%
							<input type="text" name="gi_amt" class=num size="10" value='<%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>0<%} else {%><%=AddUtil.parseDecimal(e_bean.getGi_amt())%><%}%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>원
        	 		  		</td>
				    	</tr>
				    	<tr <%if (e_bean.getA_a().equals("12") || e_bean.getA_a().equals("11")) {%>style="display: none;"<%}%>>
				    		<th>보증보험료<br>산출등급</th>
				    		<td>
				    			<select name="gi_grade" id="gi_grade">
		               				<option value="" selected>보험료미표기</option>
		                			<option value="1">1등급</option>
		                			<option value="2">2등급</option>
		                			<option value="3">3등급</option>
		                			<option value="4">4등급</option>
		                			<option value="5">5등급</option>
		                			<option value="6">6등급</option>
		                			<option value="7">7등급</option>
		                		</select>
				    		</td>
				    	</tr>
				    	<tr>
				    		<th>등록지역</th>
				    		<td><select name="udt_st">
                        <option value="1" <%if(e_bean.getUdt_st().equals("1"))%>selected<%%>>서울본사</option>
                        <option value="2" <%if(e_bean.getUdt_st().equals("2"))%>selected<%%>>부산지점</option>
                        <option value="3" <%if(e_bean.getUdt_st().equals("3"))%>selected<%%>>대전지점</option>
                        <option value="5" <%if(e_bean.getUdt_st().equals("5"))%>selected<%%>>대구지점</option>
                        <option value="6" <%if(e_bean.getUdt_st().equals("6"))%>selected<%%>>광주지점</option>
                        <option value="4" <%if(e_bean.getUdt_st().equals("4"))%>selected<%%>>고객</option>
                      </select>
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>영업수당</th>
				    		<td>차가의 <input type="text" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=text>
                      		%
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>대여료D/C</th>
				    		<td>대여료의 
                     		<input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=text>
                      		%
        	 		  		</td>
				    	</tr>	
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>								
			
	</div>
	<div id="cbtn"><a href="javascript:EstiReg();"><img src=/smart/images/btn_est.gif align=absmiddle border=0></a></div>	
	<div id="footer"></div>  
</div>
</form>
<script>
<!--	
	var fm = document.form1;
	
	if(toInt(fm.gi_per.value) == 0 && toInt(parseDigit(fm.gi_amt.value)) > 0){
		compare(fm.gi_amt);
	}
	
	if(fm.st.value == '2'){//기본견적
		EstiReg();
	}
	
//-->
</script>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
