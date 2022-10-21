<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	EstiCarVarBean [] ec_r = e_db.getEstiCarVarList(gubun1, gubun2, gubun3);
	int size = ec_r.length;
	
	String a_j = "";
	
	if(size>0 && gubun3.equals("")){
		for(int i=0; i<1; i++){
        		bean = ec_r[i];
        		gubun3 = bean.getA_j();
        	}  			
        }
	
	int td_size = 80;
	
	String ea_a_j  = e_db.getVar_b_dt_Chk("ea", gubun1, AddUtil.getDate(4));
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//차종별 수정
	function update(a_e, a_a, seq, a_j){
		var fm = document.form1;
		fm.a_e.value = a_e;
		fm.a_a.value = a_a;
		fm.seq.value = seq;				
		fm.gubun3.value = a_j;				
		fm.target='d_content';
		fm.action = 'esti_car_var_i.jsp';
		fm.submit();
	}
	
	//변수별 수정
	function update2(var_nm, var_cd, d_type){
		var fm = document.form1;
		<%if(ea_a_j.equals(gubun3)){%>
		
		if(fm.auth_rw.value = '6'){
			var SUBWIN="./esti_car_var_list_i.jsp?var_cd="+var_cd+"&var_nm="+var_nm+"&d_type="+d_type+"&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>";	
			window.open(SUBWIN, "CarVar", "left=50, top=50, width=1500, height=170, scrollbars=yes");
		}else{
			alert('권한이 없습니다.');
		}
		<%}else{%>
		alert('최신버전만 수정가능합니다.');
		<%}%>
		
	}
	

	
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_title2.style.pixelLeft = document.body.scrollLeft ; 		
	    document.all.td_title3.style.pixelLeft = document.body.scrollLeft ; 		
	    document.all.td_title4.style.pixelLeft = document.body.scrollLeft ; 						
	}
	
	function init(){		
		setupEvents();
	}	
	
	function Esti_Car_Var_Up(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "esti_car_var_upg.jsp";
		fm.submit();		
	}	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body onLoad="javascript:init()">
<form name="form1" method="post" action="esti_car_var_i.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_e" value="">
  <input type="hidden" name="a_a" value="">
  <input type="hidden" name="seq" value="">
  <input type="hidden" name="cmd" value="u">
</form>  
<table border=0 cellspacing=0 cellpadding=0 width=<%=400+(td_size*size)%>>
    <tr> 
        <td id='td_title3' style='position:relative;'><span class=style2>1. 핵심변수 (<%=gubun3%>)</span></td>
        <td align="right">
        	<%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
        	※ 견적기준일 <input type="text" name="a_j" value='<%=AddUtil.ChangeDate2(AddUtil.getDate(4))%>' size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
        	<a href="javascript:Esti_Car_Var_Up();"><!-- <a href="esti_car_var_upg.jsp?gubun1=<%=gubun1%>&gubun3=<%=gubun3%>" target="_blank"> -->[업그레이드]</a>
        	<%}%>&nbsp;
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line width="370" id='td_title' style='position:relative;'> 
            <table border=0 cellspacing=1 width=400>
                <tr> 
                    <td class=title width="55">변수기호</td>
                    <td class=title width="55">변수코드</td>
                    <td class=title colspan="2">변수명</td>
                </tr>
                <tr> 
                    <td align="center" width="55">C</td>
                    <td align="center" width="55">a_c</td>
                    <td colspan="2">대분류</td>
                </tr>
                <tr> 
                    <td align="center" width="55">-</td>
                    <td align="center" width="55">m_st</td>
                    <td colspan="2">중분류<br> &nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" rowspan="4" width="55">E</td>
                    <td align="center" width="55">a_e</td>
                    <td rowspan="4" width="160">소분류</td>
                    <td width="100" align="center">소분류코드</td>
                </tr>
                <tr> 
                    <td align="center" width="55">-</td>
                    <td align="center" width="100">소분류<br> &nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" width="55">s_sd</td>
                    <td align="center" width="100">소분류의 기준<br> &nbsp;<br> &nbsp;<br> &nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" width="55">cars</td>
                    <td align="center" width="100">해당차종</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" rowspan="7" width="55">(9)</td>
                    <td align="center" width="55">o_13_7</td>
                    <td rowspan="4" width="160">최대잔가율(VAT포함)<br>
                    (필요한 경우 차량별/모델별로 값을 직접 입력)</td>
                    <td align="center" width="100"><a href="javascript:update2('최대잔가율-48개월', 'o_13_7', 'f')">48개월</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">o_13_6</td>
                    <td align="center" width="100"><a href="javascript:update2('최대잔가율-42개월', 'o_13_6', 'f')">42개월</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">o_13_5</td>
                    <td align="center" width="100"><a href="javascript:update2('최대잔가율-36개월', 'o_13_5', 'f')">36개월</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">o_13_4</td>
                    <td align="center" width="100"><a href="javascript:update2('최대잔가율-30개월', 'o_13_4', 'f')">30개월</a></td>
                </tr>
                <tr> 
                    <td align="center">o_13_3</td>
                    <td>&nbsp;</td>
                    <td align="center"><a href="javascript:update2('최대잔가율-24개월', 'o_13_3', 'f')">24개월</a></td>
                </tr>
                <tr> 
                    <td align="center">o_13_2</td>
                    <td>&nbsp;</td>
                    <td align="center"><a href="javascript:update2('최대잔가율-18개월', 'o_13_2', 'f')">18개월</a></td>
                </tr>
                <tr> 
                    <td align="center">o_13_1</td>
                    <td>&nbsp;</td>
                    <td align="center"><a href="javascript:update2('최대잔가율-12개월', 'o_13_1', 'f')">12개월</a></td>
                </tr>
                 -->
                <!-- 
                <tr> 
                    <td align="center" width="55">(6)</td>
                    <td align="center" width="55">g_6</td>
                    <td colspan="2"><a href="javascript:update2('기본식 일반관리비/월', 'g_6', 'i')">기본식 
                    일반관리비/월</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(7)</td>
                    <td align="center" width="55">g_7</td>
                    <td colspan="2"><a href="javascript:update2('일반식 추가관리비/월', 'g_7', 'i')">일반식 
                    추가관리비/월</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">⑪</td>
                    <td align="center" width="55">o_11</td>
                    <td colspan="2"><a href="javascript:update2('영업사원수당율', 'o_11', 'f')">영업사원수당율</a></td>
                </tr>
                 -->
                <tr> 
                    <td align="center" width="55">(2)</td>
                    <td align="center" width="55">g_2</td>
                    <td colspan="2"><a href="javascript:update2('현재 아마존카 종합보험료(신차)', 'g_2', 'i')">현재 
                    아마존카 종합보험료(신차)(만단위반올림)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(sh_2)</td>
                    <td align="center" width="55">sh_g_2</td>
                    <td colspan="2"><a href="javascript:update2('현재 아마존카 종합보험료(재리스)', 'sh_g_2', 'i')">현재 
                    아마존카 종합보험료(재리스)(만단위반올림)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(2)c</td>
                    <td align="center" width="55">g_2_c</td>
                    <td colspan="2"><a href="javascript:update2('비용비교 일반법인 업무용 종합보험료(긴급출동포함)', 'g_2_c', 'i')">비용비교 일반법인 업무용
                    종합보험료..</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(3)</td>
                    <td align="center" width="55">g_3</td>
                    <td colspan="2"><a href="javascript:update2('종합보험료 적용율', 'g_3', 'f')">종합보험료 적용율</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(3)c</td>
                    <td align="center" width="55">g_3_c</td>
                    <td colspan="2"><a href="javascript:update2('비용비교 종합보험료 적용율', 'g_3_c', 'f')">비용비교 종합보험료 적용율</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(4)</td>
                    <td align="center" width="55">g_4</td>
                    <td colspan="2"><a href="javascript:update2('자차보험 기준요율', 'g_4', 'f')">자차보험 기준요율(아마존카면책금30만원)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(4)b</td>
                    <td align="center" width="55">g_4_b</td>
                    <td colspan="2"><a href="javascript:update2('일반법인 업무용 차량 자차보험요율', 'g_4_b', 'f')">일반법인 업무용 차량 자차보험요율</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(5)</td>
                    <td align="center" width="55">g_5</td>
                    <td colspan="2"><a href="javascript:update2('자차보험 적용율', 'g_5', 'f')">자차보험 적용율(아마존카)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">(5)b</td>
                    <td align="center" width="55">g_5_b</td>
                    <td colspan="2"><a href="javascript:update2('비용비교 자차보험 적용율', 'g_5_b', 'f')">비용비교 자차보험 적용율</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">터</td>
                    <td align="center" width="55">k_tu</td>
                    <td colspan="2"><a href="javascript:update2('만21세이상운전보험가입시대여료인상1', 'k_tu', 'f')">만21세이상보험 대여료인상1(차가대비)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">터b</td>
                    <td align="center" width="55">k_tu_b</td>
                    <td colspan="2"><a href="javascript:update2('비용비교 만21세이상운전보험가입시대여료인상1', 'k_tu_b', 'f')">비용비교 만21세이상보험 대여료인상1</a></td>
                </tr>                
                <tr> 
                    <td align="center" width="55">퍼</td>
                    <td align="center" width="55">k_pu</td>
                    <td colspan="2"><a href="javascript:update2('만21세이상운전보험가입시대여료인상2', 'k_pu', 'i')">만21세이상보험 대여료인상2(금액)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">퍼b</td>
                    <td align="center" width="55">k_pu_b</td>
                    <td colspan="2"><a href="javascript:update2('비용비교 만21세이상운전보험가입시대여료인상2', 'k_pu_b', 'i')">비용비교 만21세이상보험 대여료인상2(금액)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">긴</td>
                    <td align="center" width="55">k_gin</td>
                    <td colspan="2"><a href="javascript:update2('긴급출동서비스', 'k_gin', 'i')">긴급출동서비스</a></td>
                </tr>
                
                <!--
                <tr> 
                    <td align="center" width="55">추가ⓓ</td>
                    <td align="center" width="55">oa_d</td>
                    <td colspan="2"><a href="javascript:update2('만21세이상운전보험가입시대여료인상2', 'oa_d', 'i')">만21세이상운전보험가입시대여료인상2(금액)</a></td>
                </tr>
                
                <tr> 
                    <td align="center" width="55">④</td>
                    <td align="center" width="55">o_4</td>
                    <td colspan="2"><a href="javascript:update2('탁송료', 'o_4', 'i')">탁송료</a></td>
                </tr>                
                <tr> 
                    <td align="center" rowspan="7">추가ⓔ</td>
                    <td align="center" width="55">oa_e_7</td>
                    <td rowspan="7" width="160">LPG키트 장착료</td>
                    <td width="100" align="center"><a href="javascript:update2('LPG키트 장착료-48개월', 'oa_e_7', 'i')">48개월</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">oa_e_6</td>
                    <td width="100" align="center"><a href="javascript:update2('LPG키트 장착료-42개월', 'oa_e_6', 'i')">42개월</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_5</td>
                    <td align="center"><a href="javascript:update2('LPG키트 장착료-36개월', 'oa_e_5', 'i')">36개월</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_4</td>
                    <td align="center"><a href="javascript:update2('LPG키트 장착료-30개월', 'oa_e_4', 'i')">30개월</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_3</td>
                    <td align="center"><a href="javascript:update2('LPG키트 장착료-24개월', 'oa_e_3', 'i')">24개월</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_2</td>
                    <td align="center"><a href="javascript:update2('LPG키트 장착료-18개월', 'oa_e_2', 'i')">18개월</a></td>
                </tr>
                <tr> 
                    <td align="center">oa_e_1</td>
                    <td align="center"><a href="javascript:update2('LPG키트 장착료-12개월', 'oa_e_1', 'i')">12개월</a></td>
                </tr>
                -->
            </table>
        </td>
        <td class=line width="<%=td_size*size%>"> 
            <table border=0 cellspacing=1 width=<%=td_size*size%>>
                <tr> 
                    <td class=title colspan="<%=size%>">변수값</td>
                </tr>
                <tr> 
                      <!--대분류-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getA_c()%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--중분류-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getM_st()%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--소분류코드-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getA_e()%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--소분류-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><!--  <a href="javascript:update('<%=bean.getA_e()%>','<%=bean.getA_a()%>','<%=bean.getSeq()%>')"></a>--><%=c_db.getNameByIdCode("0008", "", bean.getA_e())%></td>
                      <%}%>
                </tr>
                <tr> 
                      <!--소분류기준-->
                      <%for(int i=0; i<size; i++){
            			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><%=bean.getS_sd()%></td>
                      <%}%>
                </tr>
                <tr> 
                  <!--해당차종-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="center" width="<%=td_size%>"><span title='<%=bean.getCars()%>'><%=Util.subData(bean.getCars(), 3)%></span></td>
                  <%}%>
                </tr>
                <!-- 
                <tr> 
                  최대잔가율-48
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_7()%>%</td>
                  <%}%>
                </tr>
                <tr>
                  최대잔가율-42
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_6()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  최대잔가율-36
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_5()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  최대잔가율-30
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_4()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  최대잔가율-24
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_3()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  최대잔가율-18
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_13_2()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  최대잔가율-12
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                  <td align="right" width="<%=td_size%>"><%=bean.getO_13_1()%>%</td>
                  <%}%>
                </tr>
                 -->
                <!-- 
                <tr> 
                  기본식 일반관리비/월
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_6())%></td>
                  <%}%>
                </tr>
                <tr> 
                  일반식 추가관리비/월
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_7())%></td>
                  <%}%>
                </tr>
                <tr> 
                  영업사원수당율
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getO_11()%>%</td>
                  <%}%>
                </tr>
                 -->
                <tr> 
                  <!--종합보험료(신차)-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_2())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--종합보험료(재리스)-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_g_2())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--비용비교 종합보험료-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getG_2_c())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--종합보험적용율-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_3()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--비용비교 종합보험적용율-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_3_c()%>%</td>
                  <%}%>
                </tr>                
                <tr> 
                  <!--자차보험 기준료율-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_4()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--일반법인 업무용 자차보험 기준료율(삼성화재기준)-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_4_b()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--자차보험 적용율-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_5()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--비용비교 자차보험 적용율-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getG_5_b()%>%</td>
                  <%}%>
                </tr>  
                <tr> 
                  <!--21세이상보험 차가대비-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getK_tu()%>%</td>
                  <%}%>
                </tr>
                <tr> 
                  <!--비용비교 21세이상보험 차가대비-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=bean.getK_tu_b()%>%</td>
                  <%}%>
                </tr>                  
               <tr> 
                  <!--21세이상보험 금액-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getK_pu())%></td>
                  <%}%>
                </tr>
                <tr> 
                  <!--비용비교 21세이상보험 금액-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getK_pu_b())%></td>
                  <%}%>
                </tr>                        
               <tr> 
                  <!--긴급출동서비스-->
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getK_gin())%></td>
                  <%}%>
                </tr>
                
                <!--              
                <tr> -->
                  <!--21세보험-->
                  <!--<%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_d())%></td>
                  <%}%>
                </tr>               
                <tr> 
                  탁송료
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_4())%></td>
                  <%}%>
                </tr>                
                <tr> 
                  LPG키트-서울
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_7())%></td>
                  <%}%>
                </tr>
                <tr> 
                  LPG키트-경기
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_6())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPG키트-경기
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_5())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPG키트-경기
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_4())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPG키트-경기
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_3())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPG키트-경기
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_2())%></td>
                  <%}%>
                </tr>
                <tr>
                  LPG키트-경기
                  <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getOa_e_1())%></td>
                  <%}%>
                </tr>
                -->
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td id='td_title4' style='position:relative;'><span class=style2>2. 기타변수</span></td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line width="400" id='td_title2' style='position:relative;'>
            <table border=0 cellspacing=1 width=400>
                <tr> 
                    <td class=title width="55">변수기호</td>
                    <td class=title width="55">변수코드</td>
                    <td class=title colspan="2">변수명</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" width="55">②</td>
                    <td align="center" width="55">o_2</td>
                    <td colspan="2"><a href="javascript:update2('특소세율', 'o_2', 'f')">특소세율(주민세포함)</a></td>
                </tr>                 
                <tr> 
                    <td align="center" width="55">f</td>
                    <td align="center" width="55">s_f</td>
                    <td colspan="2"><a href="javascript:update2('취득세율', 's_f', 'f')">취득세율</a></td>
                </tr>
                -->
                <tr> 
                    <td align="center" width="55">⑤</td>
                    <td align="center" width="55">o_5</td>
                    <td colspan="2"><a href="javascript:update2('등록세율(통합취득세율)', 'o_5', 'f')">등록세율(통합취득세율)</a></td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" width="55">⑤c</td>
                    <td align="center" width="55">o_5_c</td>
                    <td colspan="2"><a href="javascript:update2('통합취득세율-리스/제주도', 'o_5_c', 'f')">통합취득세율-리스/제주도</a></td>
                </tr>                 
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6</td>
                    <td rowspan="2" width="160">과세표준액 기준 채권매입율 및 차종 채권매입액</td>
                    <td width="100" align="center"><a href="javascript:update2('과세표준액 기준 채권매입율 및 차종 채권매입액-서울', 'o_6', 'if')">서울</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">⑦</td>
                    <td align="center" width="55">o_7</td>
                    <td width="100" align="center"><a href="javascript:update2('과세표준액 기준 채권매입율 및 차종 채권매입액-경기', 'o_7', 'if')">경기</a></td>
                </tr>
                -->
                <tr> 
                    <td align="center" width="55">⑭</td>
                    <td align="center" width="55">o_14</td>
                    <td colspan="2"><a href="javascript:update2('cc당자동차세/년(7~9인승제외)', 'o_14', 'i')">cc당 
                    자동차세/년 (7~9인승 제외)</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">⑮</td>
                    <td align="center" width="55">o_15</td>
                    <td colspan="2"><a href="javascript:update2('차종별자동차세/년(7~9인승제외)', 'o_15', 'i')">차종별 
                    자동차세/년 (7~9인승 제외)</a></td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" width="55">ⓐ</td>
                    <td align="center" width="55">o_a</td>
                    <td colspan="2"><a href="javascript:update2('2004년7~9인승cc당자동차세/년', 'o_a', 'i')">2004년 
                    7~9인승 cc당 자동차세/년</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">ⓑ</td>
                    <td align="center" width="55">o_b</td>
                    <td colspan="2"><a href="javascript:update2('2004년7~9인승차종별자동차세/년', 'o_b', 'i')">2004년 
                    7~9인승 차종별 자동차세/년</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">ⓒ</td>
                    <td align="center" width="55">o_c</td>
                    <td colspan="2"><a href="javascript:update2('2007년7~9인승cc당자동차세/년', 'o_c', 'i')">2007년 
                    7~9인승 cc당 자동차세/년</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">ⓓ</td>
                    <td align="center" width="55">o_d</td>
                    <td colspan="2"><a href="javascript:update2('2007년7~9인승차종별자동차세/년', 'o_d', 'i')">2007년 
                    7~9인승 차종별 자동차세/년</a></td>
                </tr>
                -->
                <tr> 
                    <td align="center" width="55">ⓔ</td>
                    <td align="center" width="55">o_e</td>
                    <td colspan="2"><a href="javascript:update2('1년차 7~9인승차종별자동차세/년', 'o_e', 'f')">1년차 
                    7~9인승 차종별 자동차세/년</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">ⓕ</td>
                    <td align="center" width="55">o_f</td>
                    <td colspan="2"><a href="javascript:update2('2년차 7~9인승cc당자동차세/년', 'o_f', 'f')">2년차 
                    7~9인승 cc당 자동차세/년</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">ⓖ</td>
                    <td align="center" width="55">o_g</td>
                    <td colspan="2"><a href="javascript:update2('3년차 7~9인승차종별자동차세/년', 'o_g', 'f')">3년차 
                    7~9인승 차종별 자동차세/년</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_1</td>
                    <td rowspan="8" width="160">[신차]채권매입율 및 채권매입액</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-서울', 'o_6_1', 'if')">서울</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_2_1</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-경기(~20071231)', 'o_6_2_1', 'if')">경기1</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_2_2</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-경기(20080101~)', 'o_6_2_2', 'if')">경기2</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_3</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-부산', 'o_6_3', 'if')">부산</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_4</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-경남', 'o_6_4', 'if')">경남</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_5</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-대전', 'o_6_5', 'if')">대전</a></td>
                </tr>								
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_7</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-인천', 'o_6_7', 'if')">인천</a></td>
                </tr>								
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">o_6_8</td>
                    <td width="100" align="center"><a href="javascript:update2('채권매입율 및 차종 채권매입액-광주/대구', 'o_6_8', 'if')">광주/대구</a></td>
                </tr>								
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_1</td>
                    <td rowspan="8" width="160">[재리스]채권매입율 및 채권매입액</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-서울', 'sh_o_6_1', 'if')">서울</a></td>
                </tr>
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_2_1</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-경기(~20071231)', 'sh_o_6_2_1', 'if')">경기1</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_2_2</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-경기(20080101~)', 'sh_o_6_2_2', 'if')">경기2</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_3</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-부산', 'sh_o_6_3', 'if')">부산</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_4</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-경남', 'sh_o_6_4', 'if')">경남</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_5</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-대전', 'sh_o_6_5', 'if')">대전</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_7</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-인천', 'sh_o_6_7', 'if')">인천</a></td>
                </tr>				
                <tr> 
                    <td align="center" width="55">⑥</td>
                    <td align="center" width="55">sh_o_6_8</td>
                    <td width="100" align="center"><a href="javascript:update2('[재리스]채권매입율 및 차종 채권매입액-광주/대구', 'sh_o_6_8', 'if')">광주/대구</a></td>
                </tr>				
            </table>
        </td>
        <td class=line width="<%=td_size*size%>"> 
            <table border=0 cellspacing=1 width=<%=td_size*size%>>
                <tr> 
                    <td class=title colspan="<%=size%>">변수값</td>
                </tr>
                <!--
                <tr> 
        		특소세율 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getO_2()%>%</td>
        		<%}%>
                </tr>                
                <tr> 
        		취득세율 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getS_f()%>%</td>
        		<%}%>
                </tr>
                -->
                <tr> 
        		<!--등록세율(통합취득세율)--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getO_5()%>%</td>
        		<%}%>
                </tr>
                <!-- 
                <tr> 
        		등록세율 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=bean.getO_5_c()%>%</td>
        		<%}%>
                </tr>                 
                <tr> 
        		채권매입율/액-서울 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];
        			String o_6= String.valueOf(bean.getO_6());%>		
                    <td align="right" width="<%=td_size%>"><%if(o_6.length() >4){%><%=AddUtil.parseDecimal(bean.getO_6())%><%}else{%><%=bean.getO_6()%>%<%}%></td>
        		<%}%>
                </tr>
                <tr> 
        		채권매입율/액-서울 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];
        			String o_7 = String.valueOf(bean.getO_7());%>		
                    <td align="right" width="<%=td_size%>"><%if(o_7.length() >4){%><%=AddUtil.parseDecimal(bean.getO_7())%><%}else{%><%=bean.getO_7()%>%<%}%></td>
        		<%}%>
                </tr>
                -->
                <tr> 
        		<!--자동차세cc당--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_14())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--자동차세차종별--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_15())%></td>
        		<%}%>
                </tr>
                <!--
                <tr> 
        		자동차세cc당-2004 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_a())%></td>
        		<%}%>
                </tr>
                <tr> 
        		자동차세차종별-2004 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_b())%></td>
        		<%}%>
                </tr>
                <tr> 
        		자동차세cc당-2007 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_c())%></td>
        		<%}%>
                </tr>
                <tr> 
        		자동차세차종별-2007 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_d())%></td>
        		<%}%>
                </tr>
                -->
                <tr> 
        		<!--자동차세cc당-1년차--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_e())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--자동차세cc당-2년차--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_f())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--자동차세cc당-3년차--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_g())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_2_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_2_2())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_3())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_4())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_5())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_7())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getO_6_8())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_2_1())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_2_2())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_3())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_4())%></td>
        		<%}%>
                </tr>
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_5())%></td>
        		<%}%>
                </tr>				
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_7())%></td>
        		<%}%>
                </tr>				
                <tr> 
        		<!--[재리스]채권매입율--> 
                <%for(int i=0; i<size; i++){
        			bean = ec_r[i];%>		
                    <td align="right" width="<%=td_size%>"><%=AddUtil.parseDecimal(bean.getSh_o_6_8())%></td>
        		<%}%>
                </tr>				
            </table>
        </td>
    </tr>
</table>
</body>
</html>