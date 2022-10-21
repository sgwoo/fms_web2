<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.car_office.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

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
		
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);	
		
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
  	//차량등록지역
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;
  
  	//전기차 고객주소지
  	CodeBean[] code34 = c_db.getCodeAll3("0034");
  	int code34_size = code34.length;	
  
  	//수소차 고객주소지
  	CodeBean[] code37 = c_db.getCodeAll3("0037");
  	int code37_size = code37.length;	
  
  	//차량인수지점
  	CodeBean[] code35 = c_db.getCodeAll3("0035");
  	int code35_size = code35.length;
	
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
	//수정
	function update(idx){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> > 20070831){
				if(fm.color.value == ''){ alert('대여차량-색상을 입력하십시오.');fm.color.focus();return; }
				if(<%=base.getRent_dt()%> > 20161231 && '<%=base.getCar_gu()%>' == '1'){//신차
					if(fm.in_col.value == ''){ alert('대여차량-내장색상을 입력하십시오.');fm.in_col.focus();return; }	
				}
				if(fm.car_ext.value == ''){ alert('대여차량-등록지역을 입력하십시오.');fm.car_ext.focus();return; }
				
				<%if(base.getCar_mng_id().equals("") || AddUtil.parseInt(base.getRent_dt()) > 20180208){%>
				
				<%if(ej_bean.getJg_g_7().equals("3") && !nm_db.getWorkAuthUser("전산팀",user_id) && !nm_db.getWorkAuthUser("영업팀내근직",user_id)){//전기차%>
					if(fm.ecar_loc_st.value == ''){	
						alert("전기차 고객주소지를 선택하십시오.");
						return;
					}
					//else{
					
					//1.서울, 2.파주, 3.부산, 4.김해, 5.대전, 6.포천, 7.인천, 8.제주, 9.광주, 10.대구
					
					//서울 -> 서울 등록
					/* if(fm.ecar_loc_st.value == '0'){
						fm.car_ext.value = '1';
					}
					//인천,경기 -> 서울 등록
					if(fm.ecar_loc_st.value == '1'){
						fm.car_ext.value = '1';
					}
					//강원 -> 서울 등록
					if(fm.ecar_loc_st.value == '2'){
						fm.car_ext.value = '1';
					}
					//대전 -> 서울 등록
					if(fm.ecar_loc_st.value == '3'){
						fm.car_ext.value = '1';
					}
					//광주 -> 광주 등록
					if(fm.ecar_loc_st.value == '4'){
						fm.car_ext.value = '9';
					}
					//대구 -> 대구 등록
					if(fm.ecar_loc_st.value == '5'){
						fm.car_ext.value = '10';
					}
					//부산 -> 서울 등록
					if(fm.ecar_loc_st.value == '6'){
						fm.car_ext.value = '1';
					}
					//세종,충남,충북(대전제외) -> 서울 등록
					if(fm.ecar_loc_st.value == '7'){
						fm.car_ext.value = '1';
					}
					//경북(대구제외) -> 서울 등록
					if(fm.ecar_loc_st.value == '8'){
						fm.car_ext.value = '1';
					}
					//울산,경남 -> 서울 등록
					if(fm.ecar_loc_st.value == '9'){
						fm.car_ext.value = '1';
					}
					//전남,전북(광주제외) -> 서울 등록
					if(fm.ecar_loc_st.value == '10'){
						fm.car_ext.value = '1';
					} */
					
					// 기존 전기화물차(등록지: 서울) 외 모든 전기차 고객 주소지와 관련 없이 인천으로 등록. 2021.02.18.
					// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주서지는 인천 등록. 20210224
					// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주소지는 부산 등록. 20210520
<%-- 					<%if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%> --%>
// 						fm.car_ext.value = '1';
<%-- 					<%} else{%> --%>
// 						if(fm.ecar_loc_st.value == '0'){	// 서울
// 							fm.car_ext.value = '1';
// 						} else if(fm.ecar_loc_st.value == '1'){	// 인천
// 							fm.car_ext.value = '7';
// 						} else if(fm.ecar_loc_st.value == '3'){	// 대전
// 							fm.car_ext.value = '5';
// 						} else if(fm.ecar_loc_st.value == '4'){	// 광주
// 							fm.car_ext.value = '9';
// 						} else if(fm.ecar_loc_st.value == '5'){	// 대구
// 							fm.car_ext.value = '10';
// 						} else if(fm.ecar_loc_st.value == '6'){	// 부산
// 							fm.car_ext.value = '3';
// 						} else{
// 							//fm.car_ext.value = '7';	// 나머지 인천
// 							fm.car_ext.value = '3';	// 나머지 지역 부산으로 등록 처리.
// 						}
<%-- 					<%}%> --%>
					
					<%-- <%if (cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {//20200221 모델3는 서울로등록%>
						// fm.car_ext.value = '1';
						fm.car_ext.value = '7'; // 20210216 테슬라 모델3 실등록지역 인천으로 변경.
					<%} else if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {//20200313 포터일렉트릭, 봉고EV는 대구등록%>
						//fm.car_ext.value = '7';
						fm.car_ext.value = '1';
					<%}%> --%>
// 				}
				<%}%>
				
				<%if(ej_bean.getJg_g_7().equals("4") && !nm_db.getWorkAuthUser("전산팀",user_id) && !nm_db.getWorkAuthUser("영업팀내근직",user_id)){//수소차%>
				if(fm.hcar_loc_st.value == ''){
					alert("수소차 고객주소지를 선택하십시오.");
					return;			
				}
				/* else{
					fm.car_ext.value = '1';
				} */
				//인천 -> 인천 등록
// 				if(fm.hcar_loc_st.value == '1'){	
// 					fm.car_ext.value = '7';
// 				}
// 				//대전 리스 -> 리스는 대전 등록
// 				if(fm.hcar_loc_st.value == '3'  && fm.car_st.value == '3'){	
// 					fm.car_ext.value = '5';
// 				}
// 				//광주/전남/전북 -> 광주 등록
// 				if(fm.hcar_loc_st.value == '4'){	
// 					fm.car_ext.value = '9';
// 				}
// 				//부산/울산/경남 -> 부산 등록
// 				if(fm.hcar_loc_st.value == '6'){	
// 					fm.car_ext.value = '3';
// 				}
// 				//20190701 수소차 인천등록
// 				//fm.car_ext.value = '7';
// 				fm.car_ext.value = '7'; //20191206 수소차는 모두 인천
				//fm.car_ext.value = '1'; //20200324 수소차는 모두 인천 -> 서울로 등록
				<%}%>				
		
				<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차-엔진종류%>
				if(fm.eco_e_tag.value == ''){	
					alert("맑은서울스티커 발급(남산터널 이용 전자태그)을 선택하십시오.");
					return;
				}		
				/* if(fm.eco_e_tag.value == '1'){
					fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
				} */
				
					<%if (!nm_db.getWorkAuthUser("전산팀",user_id) && !nm_db.getWorkAuthUser("영업팀내근직",user_id)) {%>
						<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차:연료종류%>
						if(fm.eco_e_tag.value == '1'){
							alert("전기차/수소차는 현재 맑은서울스티커 발급(남산터널 이용 전자태그)이 불가합니다.");
							return;
						}
						<%}else{%>
						if(fm.eco_e_tag.value == '1'){
							fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
						}
						<%}%>
					<%}%>
				
				<%}%> --%>
				
				<%}%>
						
				
				if(fm.pur_color.value != ''){
					if(fm.old_color.value != fm.color.value || fm.old_in_col.value != fm.in_col.value || fm.old_garnish_col.value != fm.garnish_col.value){
						alert('특판배정에 있는 색상('+fm.pur_color.value+')하고 대여차량-색상이 다릅니다. 색상 변경분이면 수정후 협력업체관리-자체출고관리에서 배정(예정) 색상도 변경하십시오.');
					}				
				}
				
		}
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
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
<form action='lc_b_s_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>  
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_8_1.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">  
  <input type='hidden' name="idx"	value="">
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td class='title' width='13%'>색상</td>
                    <td>&nbsp;<input type='text' name='color' size='45' maxlength='100' class='text' value='<%=car.getColo()%>'>
					              &nbsp;&nbsp;&nbsp;(내장색상(시트): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )
					              &nbsp;&nbsp;&nbsp;(가니쉬: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )
					              
		              <input type="hidden" name="old_color" value="<%=car.getColo()%>">
					  <input type="hidden" name="old_in_col" value="<%=car.getIn_col()%>">
					  <input type="hidden" name="old_garnish_col" value="<%=car.getGarnish_col()%>">
        			</td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>	
                <tr>
                    <td class='title'>전기차 고객주소지</td>
                    <td>&nbsp;
                        <select name="ecar_loc_st">
                    	  <option value=""  <%if(pur.getEcar_loc_st().equals(""))%>selected<%%>>선택</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%> <%if(Integer.parseInt(cm_bean.getJg_code()) > 8000000 && (code.getNm_cd().equals("12") || code.getNm_cd().equals("13"))){ %>style='display: none;'<%} %>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			      </td>
                </tr>
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("4")){//수소차%>	
                <tr>
                    <td class='title'>수소차 고객주소지</td>
                    <td>&nbsp;
                        <select name="hcar_loc_st">
                    	  <option value=""  <%if(pur.getHcar_loc_st().equals(""))%>selected<%%>>선택</option>
                    	  <%for(int i = 0 ; i < code37_size ; i++){
                            CodeBean code = code37[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getHcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			      </td>
                </tr>
                <%}%>                
                	<input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">		
                <tr>
                    <td class='title'>차량인수지</td>
                    <td>&nbsp;
                        <select name="udt_st">
                        <option value=''>선택</option>
                    	  <%for(int i = 0 ; i < code35_size ; i++){
                            CodeBean code = code35[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getUdt_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
        			        &nbsp; 인수시 탁송료 :
        			        <input type='text' name='cons_amt1' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					    원 (고객인수일 때는 직접 입력하세요.)
        			</td>
                </tr>
                <tr>
                    <td width='13%' class='title'>등록지역</td>
                    <td>&nbsp;
                      <select name="car_ext" id="car_ext">
                        	<option value=''>선택</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("해지")){%>
	<tr>
        <td><font color='red'>※ 특판배정관리 등록분입니다. 색상을 변경할 경우 협력업체관리-자체출고관리에서 계약변경 처리하십시오.</font></td>
    </tr> 
    <input type="hidden" name="pur_color" value="<%=pur_com.get("R_COLO")%>">   
    <%}else{ %>
    <input type="hidden" name="pur_color" value="">
	<%} %>	    
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('8_1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
    	</td>
	<tr>	
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script type="text/javascript">
	
</script>
</body>
</html>
