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
<%@ page import="acar.car_office.*, acar.car_mst.*, acar.estimate_mng.* "%>
<%@ page import="acar.cont.*, acar.car_register.*, acar.fee.*, acar.insur.*, acar.client.*, acar.res_search.* "%>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//차량등록정보
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//차명정보
	cm_bean = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//최종대여정보
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	
	String fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	int    fee_opt_amt 	= ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt();
	
	//보험정보
	String ins_st = ai_db.getInsSt(base.getCar_mng_id());
	ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	
	//변수----------------------------
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
		
	String o_13= "0";
	float ro_13 = 0;
	Hashtable sh_ht = new Hashtable();
	
	
	
			//재리스차량기본정보테이블
			Hashtable ht = e_db.getShBase(base.getCar_mng_id());
			
			//차량정보-여러테이블 조인 조회
			Hashtable ht2 = e_db.getBase(base.getCar_mng_id(), fee_start_dt);
			
			if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
				ht2.put("REG_ID", user_id);
				ht2.put("SECONDHAND_DT", fee_start_dt);
				//sh_base table insert
				int count = e_db.insertShBase(ht2);
			}else{
				int chk = 0;
				if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(fee_start_dt)) 									chk++;
				if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
				if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
				if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
				if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
				if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
				if(chk >0){
					ht2.put("SECONDHAND_DT", fee_start_dt);
					//sh_base table update
					int count = e_db.updateShBase(ht2);
				}
			}
		//차량정보
		sh_ht = e_db.getShBase(base.getCar_mng_id());
	
	
	
	/* 코드 구분:대여상품명 */
	CodeBean[] goods = c_db.getCodeAll("0009"); 
	int good_size = goods.length;
	
	
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//견적내기
	function EstiReg(){
		var fm = document.form1;
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		/*
		if(fm.a_a.value == '12'){
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
				
		if(!confirm('견적하시겠습니까?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'ext_car_esti_i_a.jsp';
		fm.target = "_self";
//		fm.target = "i_no";
		fm.submit();
	}
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "/smart/fms/fms_list.jsp";		
		fm.submit();
	}		
	function setSelect(sgubun)
	{
		var fm = document.form1;
		if(sgubun=='a'){
			if(fm.a_b_s1.value == ''){
				fm.a_b.value = fm.a_b_s2.value;
				document.getElementById("a_b_s2_span").style.display ='inline';
			}else{
				fm.a_b.value = fm.a_b_s1.value;
				document.getElementById("a_b_s2_span").style.display ='none';
			}
		}
	}				
//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd'	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>
	<input type='hidden' name='from_page'	value='<%=from_page%>'>

	<input type="hidden" name="est_nm" 		value="<%=firm_nm%>">		
    <input type="hidden" name="est_tel" 	value="<%=client.getO_tel()%>">			
    <input type="hidden" name="est_fax" 	value="<%=client.getFax()%>">	
	<%if(client.getClient_st().equals("1")){%>	
    <input type="hidden" name="est_ssn" 	value="<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>">	
    <input type="hidden" name="doc_type" 	value="1">			
	<%}else if(client.getClient_st().equals("2")){%>
    <input type="hidden" name="est_ssn" 	value="<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******<%//=client.getSsn2()%>">	
    <input type="hidden" name="doc_type" 	value="3">				
	<%}else{%>
    <input type="hidden" name="est_ssn" 	value="<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>">	
    <input type="hidden" name="doc_type" 	value="2">				
	<%}%>	
	<input type="hidden" name="est_email" 	value="<%=client.getCon_agnt_email()%>">		
	
    <input type="hidden" name="fee_rent_st" value="<%=fee_size+1%>">
    <input type="hidden" name="fee_start_dt" value="<%=fee_start_dt%>">
    <input type="hidden" name="udt_st" 	value="<%=pur.getUdt_st()%>">	
    <input type="hidden" name="a_h" 	value="<%=cr_bean.getCar_ext()%>">		
    <input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">		
	<input type="hidden" name="ins_good" value="0"><!--애니카보험:미가입-->			
    <input type="hidden" name="cmd" value="">
    
	<input type="hidden" name="lkas_yn" value="<%=cont_etc.getLkas_yn()%>">				<!-- 차선이탈 제어형 -->
	<input type="hidden" name="ldws_yn" value="<%=cont_etc.getLdws_yn()%>">			<!-- 차선이탈 경고형 -->
	<input type="hidden" name="aeb_yn" value="<%=cont_etc.getAeb_yn()%>">				<!-- 긴급제동 제어형 -->
	<input type="hidden" name="fcw_yn" value="<%=cont_etc.getFcw_yn()%>">				<!-- 긴급제동 경고형 -->
	<input type="hidden" name="hook_yn" value="<%=cont_etc.getHook_yn()%>">			<!-- 견인고리 -->
	
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login"><%=car_no%> 연장견적내기</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>            
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
							<td valign=top><%=firm_nm%></td>
						</tr>
				    	<tr>
				    		<th>신용도구분</th>
				    		<td><select name="spr_yn">
                        		  <option value="">=선 택=</option>
                  				  <option value='3' <%if(base.getSpr_kd().equals("3"))%>selected<%%>>신설법인</option>
                  				  <option value='0' <%if(base.getSpr_kd().equals("0"))%>selected<%%>>일반고객</option>
                  				  <option value='1' <%if(base.getSpr_kd().equals("1")||base.getSpr_kd().equals(""))%>selected<%%>>우량기업</option>
                  				  <option value='2' <%if(base.getSpr_kd().equals("2"))%>selected<%%>>초우량기업</option>
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
          			    <option value='<%=user.get("USER_ID")%>' <% if(base.getBus_id2().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
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
				    		<th width="100">차량번호</th>
				    		<td><%=cr_bean.getCar_no()%> (차종코드:<%=cm_bean.getJg_code()%>)</td>
				    	</tr>					
				    	<tr>
				    		<th width="100">신차등록일</th>
				    		<td><%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
				    	</tr>										
				    	<tr>
				    		<th width="100">제조사</th>
				    		<td><%=cm_bean.getCar_comp_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th>차명</th>
				    		<td><%=cm_bean.getCar_nm()%></td>
				    	</tr>	
						<tr>
							<th>기존 매입옵션</th>
							<td><%=AddUtil.parseDecimal(fee_opt_amt)%>원</td>
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
					    <%	String s_a_a= "";
							if(base.getCar_st().equals("1")) 		s_a_a = "2";
							else                             		s_a_a = "1";
							if(ext_fee.getRent_way().equals("1")) 	s_a_a = s_a_a+"1";
							else                              		s_a_a = s_a_a+"2";
							%>					
				    	<tr>
				    		<th>대여상품</th>
				    		<td><select name="a_a">
                        		<option value="">=선 택=</option>
								<%for(int i = 0 ; i < good_size ; i++){
        							CodeBean good = goods[i];%>
                        		  <option value='<%= good.getNm_cd()%>' <%if(s_a_a.equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        		<%}%>
                      			</select>
							</td>
				    	</tr>	
						<tr>
							<th>대여기간</th>
							<td><select name="a_b_s1" onChange="setSelect('a');">
              		  <option value='12' selected >12개월</option>
              		  <option value='24'>24개월</option>
              		  <option value='36'>36개월</option>
              		  <option value='48'>48개월</option>
              		  <option value='' >직접입력</option>
            			</select>
                 <span id = "a_b_s2_span" style="display:none;"><input type="text" name="a_b_s2" value="" size="3" class=text onChange="setSelect('a');">개월</span>
                 <input type="hidden" name="a_b" value="12" size="3"></td>
						</tr>											
				    	<tr>
				    		<th width="90">적용잔가</th>
				    		<td><input type="text" name="ro_13" size="4" class=text  value=''>%	                      		
        	 		  		</td>
				    	</tr>																													
				    	<tr>
				    		<th>매입옵션</th>
				    		<td><input type='radio' name="opt_chk" value='0' <%if(fee_opt_amt==0){%> checked <%}%>>
                      			미부여
                      			<input type='radio' name="opt_chk" value='1' <%if(fee_opt_amt>0){%> checked <%}%>>
        	 		 			부여
							</td>
				    	</tr>
				    	<tr>
				    		<th>보증금</th>
				    		<td><input type="text" name="rg_8_amt" class=num size="10" value="<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
    	                  		원
        	 		  		</td>
				    	</tr>				
				    	<tr>
				    		<th>선납금</th>
				    		<td><input type="text" name="pp_amt" class=num size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
    	                  		원
        	 		  		</td>
				    	</tr>			
				    	<tr>
				    		<th>개시대여료</th>
				    		<td><input type="text" name="g_10" class=num size="2" value="">개월치
        	 		  		</td>
				    	</tr>	
						<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
				    	<tr>
				    		<th>피보험자</th>
				    		<td><select name="ins_per">
                          		<option value="1" <%if(cont_etc.getInsur_per().equals("1")){%> selected <%}%>>아마존카</option>
                          		<%if(cont_etc.getInsur_per().equals("2")){%>
                          		<option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                          		<%}%>
                          </select>
        	 		  		</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>운전자연령</th>
				    		<td><select name="ins_age">
                			<option value="1" <%if(base.getDriving_age().equals("0"))%>selected<%%>>만26세이상</option>
   							<option value="3" <%if(base.getDriving_age().equals("3"))%>selected<%%>>만24세이상</option>
                			<option value="2" <%if(base.getDriving_age().equals("1"))%>selected<%%>>만21세이상</option>
               			 	</select>
        	 		  		</td>
				    	</tr>																																																																																																							
				    	<tr>
				    		<th>대물/자손</th>
				    		<td><select name="ins_dj" >
                			<option value="1" <%if(base.getGcp_kd().equals("1"))%>selected<%%>>5천만원/5천만원</option>
                			<option value="2" <%if(base.getGcp_kd().equals("2"))%>selected<%%>>1억원/1억원</option>
                			<option value="4" <%if(base.getGcp_kd().equals("4")||base.getGcp_kd().equals("3"))%>selected<%%>>2억원/1억원</option>
               	 			</select>
        	 		  		</td>
				    	</tr>																																																				
				    	<tr>
				    		<th>자차면책금</th>
				    		<td><input type="text" name="car_ja" class=num size="10" value="<%=AddUtil.parseDecimal(base.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
        	 		  		</td>
				    	</tr>																																																							
				    	<tr>
				    		<th>적용주행거리</th>
				    		<td><input type="text" name="today_dist" class=num size="10" value="<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>" onBlur='javascript:this.value=parseDecimal(this.value);'> km
        	 		  		</td>
				    	</tr>																																																							
				    	<tr>
				    		<th>대여료D/C</th>
				    		<td>대여료의 
                     		<input type="text" name="fee_dc_per" value="" size="4" class=text>
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
//-->
</script>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
