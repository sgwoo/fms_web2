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
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}
#cbtn { text-align:center; margin:0 0 0 0;}



</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.* "%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.* "%>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
	<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String car_comp_id = "0001";
	
	e_bean = e_db.getEstimateCase(est_id);
	
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	//차종변수
  ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	if(!est_id.equals("")){
		car_comp_id = e_bean.getCar_comp_id();
	}else{
		e_bean.setCar_ja(300000);
	}
	
	/* 코드 구분:대여상품명 */
	CodeBean[] goods = c_db.getCodeAll("0009"); 
	int good_size = goods.length;
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//자동차회사 리스트
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	
	//차종리스트-디폴트=>현대자동차
	Vector cars = a_cmb.getSearchCode(car_comp_id, "", "", "", "8", "");
	int car_size = cars.size();
	
	//제조사 목록의 비고 표시
	Hashtable com_ht = umd.getCarCompCase(cm_bean.getCar_comp_id());
	String etc 	= String.valueOf(com_ht.get("ETC"));
	String bigo = String.valueOf(com_ht.get("BIGO"));
%>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//고객수정하기
	function CustUpate(){
		var fm = document.form1;
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}
	
	//견적서보기
	function viewEstiDoc(){
		var SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&mobile_yn=Y&opt_chk=<%=e_bean.getOpt_chk()%>";									
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}

	//재견적하기
	function ReEsti(){
		var fm = document.form1;
		fm.cmd.value = 're';
		fm.action = 'new_car_esti_i.jsp';		
		fm.target = '_self';		
		fm.submit();		
	}

	function view_before()
	{
		var fm = document.form1;		
		fm.action = "new_car_esti_list.jsp";		
		fm.submit();
	}				

//-->
</script>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="cmd" value="">
    <input type="hidden" name="from_page" value="new_car_esti_u.jsp">
	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">신차견적보기</div>
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
							<td valign=top><input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="25" class=text style='IME-MODE: active'></td>
						</tr>
						<tr>
							<th valign=top>사업자/<br>생년월일</th>
							<td valign=top><input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>전화번호</th>
							<td valign=top><input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>FAX</th>
							<td valign=top><input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=text></td>
						</tr>
						<tr>
							<th valign=top>E-MAIL</th>
							<td valign=top><input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="25" class=text style='IME-MODE: inactive'></td>
						</tr>
				    	<tr>
				    		<th>고객구분</th>
				    		<td><select name="doc_type">
					   <option value="">선택</option>
                        <option value="1" <%if(e_bean.getDoc_type().equals("1"))%>selected<%%>>법인고객</option>
                        <option value="2" <%if(e_bean.getDoc_type().equals("2"))%>selected<%%>>개인사업자</option>
						<option value="3" <%if(e_bean.getDoc_type().equals("3"))%>selected<%%>>개인</option>
                      </select>
        	 		  		</td>
				    	</tr>								
				    	<tr>
				    		<th>견적유효기간</th>
				    		<td><select name="vali_type">
					    		<option value="">선택</option>
                        		<option value="0" <%if(e_bean.getVali_type().equals("0"))%>selected<%%>>날짜만표기(10일)</option>
                        		<option value="1" <%if(e_bean.getVali_type().equals("1"))%>selected<%%>>메이커D/C 변경 가능성 언급</option>
                       			<option value="2" <%if(e_bean.getVali_type().equals("2"))%>selected<%%>>미확정견적</option>						
                      		</select>
        	 		  		</td>
				    	</tr>
				    	<tr>
				    		<th>보증보험료<br>산출 등급</th>
				    		<td>
				    			<select name="gi_grade">
				    				<option value="" <%if(e_bean.getGi_grade().equals("")){%>selected<%}%>>보험료미표기</option>
			    					<option value="1" <%if(e_bean.getGi_grade().equals("1")){%>selected<%}%>>1등급</option>
			    					<option value="2" <%if(e_bean.getGi_grade().equals("2")){%>selected<%}%>>2등급</option>
			    					<option value="3" <%if(e_bean.getGi_grade().equals("3")){%>selected<%}%>>3등급</option>
			    					<option value="4" <%if(e_bean.getGi_grade().equals("4")){%>selected<%}%>>4등급</option>
			    					<option value="5" <%if(e_bean.getGi_grade().equals("5")){%>selected<%}%>>5등급</option>
			    					<option value="6" <%if(e_bean.getGi_grade().equals("6")){%>selected<%}%>>6등급</option>
			    					<option value="7" <%if(e_bean.getGi_grade().equals("7")){%>selected<%}%>>7등급</option>			    					
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
          			    <option value='<%=user.get("USER_ID")%>' <% if(e_bean.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			  &nbsp;&nbsp;&nbsp;
        			  <input type="radio" name="caroff_emp_yn" value="1" <%if(e_bean.getCaroff_emp_yn().equals("1") || e_bean.getCaroff_emp_yn().equals("")){%>checked<%}%>  >영업사원없음
        			  <input type="radio" name="caroff_emp_yn" value="2" <%if(e_bean.getCaroff_emp_yn().equals("2")){%>checked<%}%>  >영업사원있음(당사 담당자 표기)
        			  <input type="radio" name="caroff_emp_yn" value="3" <%if(e_bean.getCaroff_emp_yn().equals("3")){%>checked<%}%>  >영업사원있음(당사 담당자 미표기)
        		        			  
        	 		  		</td>
				    	</tr>																																																								
				    	<tr>
				    		<th>신용도구분</th>
				    		<td><b><% if(e_bean.getSpr_yn().equals("2")){%>초우량기업<% }else if(e_bean.getSpr_yn().equals("1")){%>우량기업<% }else if(e_bean.getSpr_yn().equals("0")){%>일반기업<% }else if(e_bean.getSpr_yn().equals("3")){%>신설법인<%}%></b></td>
				    	</tr>												
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>
			
	</div>
	<div id="cbtn"><a href="javascript:CustUpate();"><img src=/smart/images/btn_modify.gif align=absmiddle></a></div>
	<div style="height:10px"></div>
	<div id="contents">
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">차량정보</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="90">제조사</th>
				    		<td><%=cm_bean.getCar_comp_nm()%></td>
				    	</tr>
				    	<tr>
				    		<th width="90"></th>
				    		<td><%=etc%></td>
				    	</tr>
				    	<tr>
				    		<th>차명</th>
				    		<td><%=cm_bean.getCar_nm()%> (차종코드:<%=cm_bean.getJg_code()%>)</td>
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
										<td><%if(!e_bean.getIn_col().equals("")){%>외장: <%}%><%=e_bean.getCol()%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;내장: <%=e_bean.getIn_col()%><%}%></td>
									</tr>
									<tr>
										<td align="right"><%=AddUtil.parseDecimal(e_bean.getCol_amt())%>원</td>
									</tr>
								</table>
							</td>
						</tr>		
						<tr>
							<th>연비</th>
							<td>
								<%=e_bean.getConti_rat()%>
							</td>
							<td></td>
						</tr>				
						<tr>
							<th>제조사DC</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=e_bean.getDc()%></td>
									</tr>
									<tr>
										<td align="right">-<%=AddUtil.parseDecimal(e_bean.getDc_amt())%>원</td>
									</tr>
								</table>
							</td>
						</tr>	
				    	<tr>
				    		<th width="90"></th>
				    		<td><%=bigo%></td>
				    	</tr>
						
						<%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>			
						<tr>
							<th>개소세 감면</th>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>개별소비세 및 교육세 감면 </td>
									</tr>
									<tr>
										<td align="right">-<%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%>원</td>
									</tr>
								</table>
							</td>
						</tr>										
						<%}%>
				    	<tr>
				    		<th width="90">비고</th>
				    		<td><%=cm_bean.getEtc()%></td>
				    	</tr>						
						<tr>
							<th>차량가격</th>
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
				    		<th>견적일시</th>
				    		<td><%=AddUtil.ChangeDate3(e_bean.getReg_dt())%></td>
				    	</tr>	
				    	<tr>
				    		<th>대여상품</th>
				    		<td><%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%></td>
				    	</tr>	
						<tr>
							<th>대여기간</th>
							<td><%=e_bean.getA_b()%>개월</td>
						</tr>																
						<tr>
							<th>최대잔가</th>
							<td><%=e_bean.getO_13()%>%</td>
						</tr>																
				    	<tr>
				    		<th width="90">적용잔가</th>
				    		<td><%=e_bean.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>원
        	 		  		</td>
				    	</tr>																													
				    	<tr>
				    		<th>매입옵션</th>
				    		<td><%if(e_bean.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean.getOpt_chk().equals("1")){%>부여<%}%>
							</td>
				    	</tr>
				    	<tr>
				    		<th>보증금</th>
				    		<td><%=e_bean.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>원
        	 		  		</td>
				    	</tr>				
				    	<tr>
				    		<th>선납금</th>
				    		<td><%=e_bean.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>원
        	 		  		</td>
				    	</tr>			
				    	<tr>
				    		<th>개시대여료</th>
				    		<td><%=e_bean.getG_10()%>개월치</td>
				    	</tr>	
				    	<tr>
				    		<th>보험계약자</th>
				    		<td><%if(e_bean.getInsurant().equals("1")){%>아마존카<%}else if(e_bean.getInsurant().equals("2")){%>고객<%}%></td>
				    	</tr>	
				    	<tr>
				    		<th>피보험자</th>
				    		<td><%if(e_bean.getIns_per().equals("1")){%>아마존카(보험포함)<%}else if(e_bean.getIns_per().equals("2")){%>고객(보험미포함)<%}%></td>
				    	</tr>	
				    	<tr>
				    		<th>대물/자손</th>
				    		<td><%if(e_bean.getIns_dj().equals("1")){%>5천만원/5천만원<%}else if(e_bean.getIns_dj().equals("2")){%>1억원/1억원<%}else if(e_bean.getIns_dj().equals("4")){%>2억원/1억원<%}else if(e_bean.getIns_dj().equals("8")){%>3억원/1억원<%}else if(e_bean.getIns_dj().equals("3")){%>5억원/1억원<%}%></td>
				    	</tr>																																																	
																																																						
				    	<tr>
				    		<th>운전자연령</th>
				    		<td><%if(e_bean.getIns_age().equals("1")){%>만26세이상<%}else if(e_bean.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean.getIns_age().equals("3")){%>만24세이상<%}%></td>
				    	</tr>																																																																																																							
				    	<tr>
				    		<th>자차면책금</th>
				    		<td><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>원</td>
				    	</tr>																																																							
				    	<tr>
				    		<th>보증보험</th>
				    		<td><%=e_bean.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>원</td>
				    	</tr>	
				    	<tr>
				    		<th>용품</th>
				    		<td><%if(e_bean.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%><br><%if(e_bean.getTint_s_yn().equals("Y")){%>전면 썬팅(기본형)<%}%><br><%if(e_bean.getTint_ps_yn().equals("Y")){%>고급썬팅<%}%><%if(e_bean.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">내용 : <%=e_bean.getTint_ps_nm()%></span><%}%><%if(e_bean.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">추가금액(공급가) : <%=AddUtil.parseDecimal(e_bean.getTint_ps_amt())%> 원</span><%}%><br><%if(e_bean.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%><br><%if(e_bean.getTint_bn_yn().equals("Y")){%>블랙박스 미제공 할인 (빌트인캠,고객장착..)<%}%><br><%if(e_bean.getTint_eb_yn().equals("Y")){%>이동형 충전기(전기차)<%}%><%if (e_bean.getTint_cons_amt() != 0) {%><br>추가탁송료등 : <%=AddUtil.parseDecimal(e_bean.getTint_cons_amt())%> 원<%}%><br>
				    			<%if(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")){%>신형번호판<%} else if(e_bean.getNew_license_plate().equals("0")){%>구형번호판<%} %>
				    			<%-- <%if(e_bean.getNew_license_plate().equals("1") || e_bean.getNew_license_plate().equals("2")){%>신형번호판신청<%}%> --%>
<%-- 				    			<%if(e_bean.getNew_license_plate().equals("1")){%>신형번호판신청(수도권)<%} else if (e_bean.getNew_license_plate().equals("2")){%>신형번호판신청(대전/대구/광주/부산)<%}%> --%>
				    		</td>
				    	</tr>
				    	<%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>		
				    	<tr>
				    		<th>전기차 고객주소지</th>
				    		<td><%=c_db.getNameByIdCode("0034", "", e_bean.getEcar_loc_st())%></td>
				    	</tr>
				    	<%if (!(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4"))) {%>
				    	<tr>
				    		<th>맑은서울스티커 발급</th>
				    		<td><%if(e_bean.getEco_e_tag().equals ("0")){%>미발급<%}else if(e_bean.getEco_e_tag().equals("1")){%>발급<%}%></td>
				    	</tr>
				    	<%}%>
				    	<%}%>
				    	<tr>
				    		<th>차량인수지점</th>
				    		<td><%=c_db.getNameByIdCode("0035", "", e_bean.getUdt_st())%></td>
				    	</tr>			
				    	<tr>
				    		<th>실등록지역</th>
				    		<td><%=c_db.getNameByIdCode("0032", "", e_bean.getA_h())%></td>
				    	</tr>																																																						
				    	<tr>
				    		<th>영업수당</th>
				    		<td>차가의<%=e_bean.getO_11()%>%</td>
				    	</tr>																																																	
				    	<tr>
				    		<th>대여료D/C</th>
				    		<td>대여료의<%=e_bean.getFee_dc_per()%>%</td>
				    	</tr>	
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>		
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>
    	<div id="ctitle">견적결과</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				    	<tr>
				    		<th width="90">공급가</th>
				    		<td><%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>원</td>
				    	</tr>	
				    	<tr>
				    		<th>부가세</th>
				    		<td><%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>원</td>
				    	</tr>	
						<tr>
							<th>월대여요금</th>
							<td><%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>원</td>
						</tr>																
						<tr>
							<th>필요위약율</th>
							<td><%=e_bean.getCls_n_per()%>%</td>
						</tr>																
				    	<tr>
				    		<th>적용위약율</th>
				    		<td><%=e_bean.getCls_per()%>%</td>
				    	</tr>																													
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>				
						
	</div>
	<div id="cbtn">
			<a href="javascript:viewEstiDoc();"><img src=/smart/images/btn_see_est.gif align=absmiddle></a>&nbsp;&nbsp;&nbsp;
			<a href="javascript:ReEsti();"><img src=/smart/images/btn_re_est.gif align=absmiddle></a></div>
	<div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
