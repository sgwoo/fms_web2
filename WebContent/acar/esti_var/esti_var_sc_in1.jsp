<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiCommVarCase(gubun1, gubun2, gubun3);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function update(){
		var fm = document.form1;
		fm.target='d_content';
		fm.submit();
	}
	

//-->
</script>
</head>
<body>
<form name="form1" method="post" action="esti_comm_var_i.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_a" value="<%=bean.getA_a()%>">          
  <input type="hidden" name="seq" value="<%=bean.getSeq()%>">          
  <input type="hidden" name="cmd" value="">
</form>  
<table border=0 cellspacing=0 cellpadding=0 width=100%>    
    <tr> 
        <td><span class=style2>1. <a href="javascript:update()">핵심변수</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
        <td align="right"><img src=/acar/images/center/arrow.gif align=absmiddle> <span class="style1">기준일자 : <%=AddUtil.ChangeDate2(bean.getA_j())%></span>&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="150">변수기호</td>
                    <td class=title width="150">변수코드</td>
                    <td class=title colspan="2">변수명</td>
                    <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                    <td align="center">F</td>
                    <td align="center">a_f</td>
                    <td colspan="2">&nbsp;적용이자율</td>
                    <td align="right" ><%=bean.getA_f()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 20080901 미사용  -->
                <!-- 
                <tr> 
                    <td align="center" rowspan="7" width="95">G</td>
                    <td align="center">a_g_7</td>
                    <td rowspan="7" width="396">&nbsp;10만원당 월할부금</td>
                    <td align="center">48개월</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_7())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">a_g_5</td>
                    <td align="center">42개월</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_5())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_1</td>
                    <td align="center">36개월</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_1())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">a_g_6</td>
                    <td align="center">30개월</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_6())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_2</td>
                    <td align="center">24개월</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_2())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_3</td>
                    <td align="center">18개월</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_3())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >a_g_4</td>
                    <td align="center">12개월</td>
                    <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_4())%>원&nbsp;&nbsp;</td>
                </tr>
                -->
                <tr> 
                    <td align="center" >⑫</td>
                    <td align="center" >o_12</td>
                    <td colspan="2">&nbsp;특소세 환입율(12개월후)</td>
                    <td align="right" ><%=bean.getO_12()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(3)</td>
                    <td align="center" >g_3</td>
                    <td colspan="2">&nbsp;종합보험비용 적용율(현보험료 대비)</td>
                    <td align="right" ><%=bean.getG_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(5)</td>
                    <td align="center" >g_5</td>
                    <td colspan="2">&nbsp;자차보험비용 적용율(일반법인보험료대비)</td>
                    <td align="right" ><%=bean.getG_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용
                <tr> 
                    <td align="center">추가ⓑ</td>
                    <td align="center">oa_b</td>
                    <td colspan="2">&nbsp;대물, 자손 보험 1억 가입시 대여료 인상액</td>
                    <td align="right"><%=AddUtil.parseDecimal(bean.getOa_b())%>원&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                    <td align="center">추가ⓒ</td>
                    <td align="center">oa_c</td>
                    <td colspan="2">&nbsp;만21세이상 운전보험 가입시 대여료 인상1(차가대비)</td>
                    <td align="right"><%=bean.getOa_c()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(8)</td>
                    <td align="center" >g_8</td>
                    <td colspan="2">&nbsp;기본식 기본보증금율</td>
                    <td align="right" ><%=bean.getG_8()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" rowspan="7" width="95">(9)</td>
                    <td align="center">g_9_7</td>
                    <td rowspan="7" width="500">&nbsp;기본식 목표마진(계약고 대비)</td>
                    <td align="center">48개월</td>
                    <td align="right"><%=bean.getG_9_7()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_6</td>
                    <td align="center">42개월</td>
                    <td align="right" ><%=bean.getG_9_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_5</td>
                    <td align="center">36개월</td>
                    <td align="right" ><%=bean.getG_9_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_4</td>
                    <td align="center">30개월</td>
                    <td align="right" ><%=bean.getG_9_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_9_3</td>
                    <td align="center"> 24개월</td>
                    <td align="right" ><%=bean.getG_9_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_9_2</td>
                    <td align="center">18개월</td>
                    <td align="right"><%=bean.getG_9_2()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                    <td align="center" >(9)</td>
                    <td align="center">g_9_1</td>
                    <td colspan="2">&nbsp;기본식 목표마진(계약고 대비)</td>
                    <td align="right"><%=bean.getG_9_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >(10)</td>
                    <td align="center" >g_10</td>
                    <td colspan="2">&nbsp;일반식 개시대여료 기본납입 개월수</td>
                    <td align="right" ><%=bean.getG_10()%>&nbsp;&nbsp;</td>
                </tr>
                <!-- 
                <tr> 
                    <td align="center" rowspan="7">(11)</td>
                    <td align="center">g_11_7</td>
                    <td rowspan="7">&nbsp;일반식 목표마진(계약고 대비)</td>
                    <td align="center">48개월</td>
                    <td align="right"><%=bean.getG_11_7()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_11_6</td>
                    <td align="center">42개월</td>
                    <td align="right" ><%=bean.getG_11_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_11_5</td>
                    <td align="center">36개월</td>
                    <td align="right" ><%=bean.getG_11_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center" >g_11_4</td>
                    <td align="center">30개월</td>
                    <td align="right" ><%=bean.getG_11_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_11_3</td>
                    <td align="center">24개월</td>
                    <td align="right"><%=bean.getG_11_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">g_11_2</td>
                    <td align="center">18개월</td>
                    <td align="right"><%=bean.getG_11_2()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                 <tr>
                    <td align="center">(11)</td>
                    <td align="center" >g_11_1</td>
                    <td colspan="2">&nbsp;일반식 목표마진(계약고 대비)</td>
                    <td align="right" ><%=bean.getG_11_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용
                <tr> 
                    <td align="center">기타</td>
                    <td align="center">ax_n</td>
                    <td colspan="2">&nbsp;카드결제 리베이트율</td>
                    <td align="right"><%=bean.getAx_n()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">기타</td>
                    <td align="center">ax_n_c</td>
                    <td colspan="2">&nbsp;카드결제금액율</td>
                    <td align="right"><%=bean.getAx_n_c()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">기타</td>
                    <td align="center">ax_p</td>
                    <td colspan="2">&nbsp;위약금산출기준 이용기간</td>
                    <td align="right"><%=bean.getAx_p()%>개월&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                    <td align="center">기타</td>
                    <td align="center">ax_q</td>
                    <td colspan="2">&nbsp;정비비용상한금액-일반식 추가관리비대비</td>
                    <td align="right"><%=bean.getAx_q()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용
                <tr> 
                    <td align="center">기타</td>
                    <td align="center">ax_r_1</td>
                    <td colspan="2">&nbsp;주행거리 무제한견적 가능 차종-예상주행거리율</td>
                    <td align="right"><%=bean.getAx_r_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td align="center">기타</td>
                    <td align="center">ax_r_2</td>
                    <td colspan="2">&nbsp;주행거리 약정견적만 가능 차종-예상주행거리율</td>
                    <td align="right"><%=bean.getAx_r_2()%>%&nbsp;&nbsp;</td>
                </tr>
                -->
				
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td colspan="2"><span class=style2>2. <a href="javascript:update()">기타변수</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="7">⑧</td>
                  <td align="center">o_8_1</td>
                  <td rowspan="7" width="150">&nbsp;채권할인율</td>
                  <td align="center">서울</td>
                  <td align="right"><%=bean.getO_8_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_2</td>
                  <td align="center">경기</td>
                  <td align="right"><%=bean.getO_8_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_3</td>
                  <td align="center">부산</td>
                  <td align="right"><%=bean.getO_8_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_4</td>
                  <td align="center">경남</td>
                  <td align="right"><%=bean.getO_8_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_5</td>
                  <td align="center">대전</td>
                  <td align="right"><%=bean.getO_8_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_7</td>
                  <td align="center">인천</td>
                  <td align="right"><%=bean.getO_8_7()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_8_8</td>
                  <td align="center">광주/대구</td>
                  <td align="right"><%=bean.getO_8_8()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="7">⑨</td>
                  <td align="center">o_9_1</td>
                  <td rowspan="7">&nbsp;등록부대비용</td>
                  <td  align="center">서울</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_1())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_2</td>
                  <td align="center">경기</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_2())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_3</td>
                  <td align="center">부산</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_3())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_4</td>
                  <td align="center">경남</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_4())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_5</td>
                  <td align="center">대전</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_5())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_7</td>
                  <td align="center">인천</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_7())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">o_9_8</td>
                  <td align="center">광주/대구</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getO_9_8())%>원&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용 
                <tr> 
                  <td align="center">⑩</td>
                  <td align="center">o_10</td>
                  <td colspan="2">&nbsp;공급가대비 대출율</td>
                  <td align="right"><%=bean.getO_10()%>%&nbsp;&nbsp;</td>
                </tr>
                 
                <tr> 
                  <td align="center">ⓔ</td>
                  <td align="center">o_e</td>
                  <td colspan="2">&nbsp;견적기준일의 년말일자</td>
                  <td align="right"><%=AddUtil.ChangeDate2(bean.getO_e())%>&nbsp;&nbsp;</td>
                </tr>
                -->
                <tr> 
                  <td align="center">(1)</td>
                  <td align="center">g_1</td>
                  <td colspan="2">&nbsp;차고지 유지비</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getG_1())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">추가ⓕ</td>
                  <td align="center">oa_f</td>
                  <td colspan="2">&nbsp;보증보험가입금 적용율-일반식</td>
                  <td align="right"><%=bean.getOa_f()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용
                <tr> 
                  <td align="center">추가ⓕ</td>
                  <td align="center">oa_h</td>
                  <td colspan="2">&nbsp;보증보험가입금 적용율-기본식</td>
                  <td align="right"><%=bean.getOa_h()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">추가ⓖ</td>
                  <td align="center">oa_g</td>
                  <td colspan="2">&nbsp;보증보험료 적용율</td>
                  <td align="right"><%=bean.getOa_g()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="2">M</td>
                  <td align="center">a_m_1</td>
                  <td colspan="2">&nbsp;현재 중고차 경기지수</td>
                  <td align="right"><%=bean.getA_m_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_m_2</td>
                  <td colspan="2">&nbsp;36개월후 현재 중고차 경기지수 반영율</td>
                  <td align="right"><%=bean.getA_m_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="2">M</td>
                  <td align="center">sh_a_m_1</td>
                  <td colspan="2">&nbsp;(재리스)현재 중고차 경기지수</td>
                  <td align="right"><%=bean.getSh_a_m_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">sh_a_m_2</td>
                  <td colspan="2">&nbsp;(재리스)36개월후 현재 중고차 경기지수 반영율</td>
                  <td align="right"><%=bean.getSh_a_m_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용                
                <tr> 
				  <td align="center">i</td>
                  <td align="center">bc_s_i</td>
                  <td colspan="2">&nbsp;CASH BACK율</td>
                  <td align="right"><%=bean.getBc_s_i()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <!-- 미사용
                <tr> 
                  <td align="center">-</td>
                  <td align="center">-</td>
                  <td colspan="2">&nbsp;장기대여차량 이용 주요 법인</td>
                  <td align="right"><span title='<%=bean.getCompanys()%>'><%=Util.subData(bean.getCompanys(), 6)%></span></td>
                </tr>
                <tr> 
                  <td align="center">-</td>
                  <td align="center">-</td>
                  <td colspan="2">&nbsp;이용문의 담당자</td>
                  <td align="right"><%=bean.getQuiry_nm()%></td>
                </tr>
                <tr> 
                  <td align="center">-</td>
                  <td align="center">-</td>
                  <td colspan="2">&nbsp;이용문의 연락처</td>
                  <td align="right"><%=bean.getQuiry_tel()%></td>
                </tr>
                 -->
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_1</td>
                	<td colspan="2">&nbsp;차선이탈제어형</td>
                	<td align="right"><%=bean.getA_y_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_2</td>
                	<td colspan="2">&nbsp;차선이탈경고형</td>
                	<td align="right"><%=bean.getA_y_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_3</td>
                	<td colspan="2">&nbsp;긴급제동제어형</td>
                	<td align="right"><%=bean.getA_y_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_4</td>
                	<td colspan="2">&nbsp;긴급제동경고형</td>
                	<td align="right"><%=bean.getA_y_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_5</td>
                	<td colspan="2">&nbsp;전기차여부</td>
                	<td align="right"><%=bean.getA_y_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_y_6</td>
                	<td colspan="2">&nbsp;견인고리(트레일러용)</td>
                	<td align="right"><%=bean.getA_y_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_f_2</td>
                	<td colspan="2">&nbsp;초기납입금 적용 이자율</td>
                	<td align="right"><%=bean.getA_f_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">a_f_3</td>
                	<td colspan="2">&nbsp;중고차 잔존가치 환산 이자율</td>
                	<td align="right"><%=bean.getA_f_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_extra</td>
                	<td colspan="2">&nbsp;서울보증보험 아마존카 할인할증율</td>
                	<td align="right"><%=bean.getOa_extra()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_1</td>
                	<td colspan="2">&nbsp;서울보증보험 신용1등급 보험요율</td>
                	<td align="right"><%=bean.getOa_g_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_2</td>
                	<td colspan="2">&nbsp;서울보증보험 신용2등급 보험요율</td>
                	<td align="right"><%=bean.getOa_g_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_3</td>
                	<td colspan="2">&nbsp;서울보증보험 신용3등급 보험요율</td>
                	<td align="right"><%=bean.getOa_g_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_4</td>
                	<td colspan="2">&nbsp;서울보증보험 신용4등급 보험요율</td>
                	<td align="right"><%=bean.getOa_g_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_5</td>
                	<td colspan="2">&nbsp;서울보증보험 신용5등급 보험요율</td>
                	<td align="right"><%=bean.getOa_g_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_6</td>
                	<td colspan="2">&nbsp;서울보증보험 신용6등급 보험요율</td>
                	<td align="right"><%=bean.getOa_g_6()%>%&nbsp;&nbsp;</td>
                </tr>                                
                <tr>
                	<td align="center">-</td>
                	<td align="center">oa_g_7</td>
                	<td colspan="2">&nbsp;서울보증보험 신용7등급 보험요율</td>
                	<td align="right"><%=bean.getOa_g_7()%>%&nbsp;&nbsp;</td>
                </tr>                                
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
                <!-- 20080901 미사용  -->
                <!--     
    <tr>
        <td colspan="2"><span class=style2>3. <a href="javascript:update()">우량기업 변수</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="95">변수기호</td>
                  <td class=title width="99">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="97">변수값</td>
                </tr>
                <tr> 
                  <td align="center" width="95">F</td>
                  <td align="center" width="99">a_f_w</td>
                  <td colspan="2">&nbsp;적용이자율</td>
                  <td align="right" width="97"><%=bean.getA_f_w()%>%&nbsp;&nbsp;</td>
                </tr>

                <tr> 
                  <td align="center" rowspan="7" width="95">G</td>
                  <td align="center">a_g_7_w</td>
                  <td rowspan="7" width="500">&nbsp;10만원당 월할부금</td>
                  <td align="center">48개월</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_7_w())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_g_6_w</td>
                  <td align="center">42개월</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_6_w())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_5_w</td>
                  <td align="center">36개월</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_5_w())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_g_4_w</td>
                  <td align="center">30개월</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_4_w())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_3_w</td>
                  <td align="center">24개월</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getA_g_3_w())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_2_w</td>
                  <td align="center">18개월</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_2_w())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_1_w</td>
                  <td align="center">12개월</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_1_w())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(9) </td>
                  <td align="center" width="99">g_9_11_w</td>
                  <td colspan="2">&nbsp;기본식 목표마진(계약고 대비)</td>
                  <td align="right" width="97"><%=bean.getG_9_11_w()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td align="center">(11)</td>
                  <td align="center">g_11_w</td>
                  <td colspan="2">&nbsp;일반식 목표마진(계약고 대비)</td>
                  <td align="right"><%=bean.getG_11_w()%>%&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td></td>
    </tr> 
                -->
                <!-- 20080901 미사용  -->
                <!--
    
    <tr>
        <td colspan="2"><span class=style2>4. <a href="javascript:update()">초우량기업 변수</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="95">변수기호</td>
                  <td class=title width="99">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="97">변수값</td>
                </tr>
                <tr> 
                  <td align="center" width="95">F</td>
                  <td align="center" width="99">a_f_uw</td>
                  <td colspan="2">&nbsp;적용이자율</td>
                  <td align="right" width="97"><%=bean.getA_f_uw()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" rowspan="7" width="95">G</td>
                  <td align="center">a_g_7_uw</td>
                  <td rowspan="7" width="500">&nbsp;10만원당 월할부금</td>
                  <td align="center">48개월</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_7_uw())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_6_uw</td>
                  <td align="center">42개월</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_6_uw())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_5_uw</td>
                  <td align="center">36개월</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getA_g_5_uw())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">a_g_4_uw</td>
                  <td align="center">30개월</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getA_g_4_uw())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_3_uw</td>
                  <td align="center">24개월</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_3_uw())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_2_uw</td>
                  <td align="center">18개월</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_2_uw())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >a_g_1_uw</td>
                  <td align="center">12개월</td>
                  <td align="right" ><%=AddUtil.parseDecimal(bean.getA_g_1_uw())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(9)</td>
                  <td align="center">g_9_11_uw</td>
                  <td colspan="2">&nbsp;기본식 목표마진(계약고 대비)</td>
                  <td align="right" ><%=bean.getG_9_11_uw()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr>
                  <td align="center"> (11)</td>
                  <td align="center">g_11_uw</td>
                  <td colspan="2">&nbsp;일반식 목표마진(계약고 대비)</td>
                  <td align="right"><%=bean.getG_11_uw()%>%&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
                -->
    
    <tr>
        <td colspan="2"><span class=style2>5. <a href="javascript:update()">잔가공통변수</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center">(1)</td>
                  <td align="center">jg_c_1</td>
                  <td colspan="2">&nbsp;0개월기준잔가</td>
                  <td align="right"><%=bean.getJg_c_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(2)</td>
                  <td align="center">jg_c_2</td>
                  <td colspan="2">&nbsp;차령24개월 잔가율 2년간 변동율</td>
                  <td align="right"><%=bean.getJg_c_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(3)</td>
                  <td align="center">jg_c_3</td>
                  <td colspan="2">&nbsp;신차등록월에 따른 12개월당 잔가율 변동값</td>
                  <td align="right"><%=bean.getJg_c_3()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(3)2</td>
                  <td align="center">jg_c_32</td>
                  <td colspan="2">&nbsp;재리스 등록월에 따른 12개월당 잔가율 변동값</td>
                  <td align="right"><%=bean.getJg_c_32()%>%&nbsp;&nbsp;</td>
                </tr>				
                <tr> 
                  <td align="center">(4)</td>
                  <td align="center">jg_c_4</td>
                  <td colspan="2">&nbsp;LPG겸용차 잔가율 기초 조정값</td>
                  <td align="right"><%=bean.getJg_c_4()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(5)</td>
                  <td align="center">jg_c_5</td>
                  <td colspan="2">&nbsp;LPG겸용차 잔가율 1년동 조정값</td>
                  <td align="right"><%=bean.getJg_c_5()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(6)</td>
                  <td align="center">jg_c_6</td>
                  <td colspan="2">&nbsp;3년 초과견적시 잔가율 1년동 조정값</td>
                  <td align="right"><%=bean.getJg_c_6()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(7)1</td>
                  <td align="center">jg_c_71</td>
                  <td colspan="2">&nbsp;3년 표준주행거리(km)-가솔린엔진</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getJg_c_71())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(7)2</td>
                  <td align="center">jg_c_72</td>
                  <td colspan="2">&nbsp;3년 표준주행거리(km)-디젤엔진</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getJg_c_72())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(7)3</td>
                  <td align="center">jg_c_73</td>
                  <td colspan="2">&nbsp;3년 표준주행거리(km)-LPG엔진(전용차)</td>
                  <td align="right"><%=AddUtil.parseDecimal(bean.getJg_c_73())%>원&nbsp;&nbsp;</td>
                </tr>
                <!-- 
                <tr> 
                  <td align="center" width="95">(8)1</td>
                  <td align="center" width="99">jg_c_81</td>
                  <td colspan="2">&nbsp;표준주행거리 초과 10,000km당 중고차가 조정율 (가솔린,LPG)</td>
                  <td align="right" width="97"><%=bean.getJg_c_81()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(8)2</td>
                  <td align="center" width="99">jg_c_82</td>
                  <td colspan="2">&nbsp;표준주행거리 초과 10,000km당 중고차가 조정율 (디젤)</td>
                  <td align="right" width="97"><%=bean.getJg_c_82()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">(9)</td>
                  <td align="center">jg_c_9</td>
                  <td colspan="2">&nbsp;24개월 시간경과에 따른 중고차가 하락율</td>
                  <td align="right"><%=bean.getJg_c_9()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >(10)</td>
                  <td align="center">jg_c_10</td>
                  <td colspan="2">&nbsp;LPG전용차량 24개월 시간경과에 따른 중고차가 하락율</td>
                  <td align="right"><%=bean.getJg_c_10()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(11)</td>
                  <td align="center">jg_c_11</td>
                  <td colspan="2">&nbsp;24개월 시간경과에 따른 중고차 리스트 완충율</td>
                  <td align="right"><%=bean.getJg_c_11()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용
                <tr> 
                  <td align="center" width="95">(a)</td>
                  <td align="center" width="99">jg_c_a</td>
                  <td colspan="2">&nbsp;간접분사LPG키트장착/탈착비용(공급가)</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getJg_c_a())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(b)</td>
                  <td align="center" width="99">jg_c_b</td>
                  <td colspan="2">&nbsp;직접분사LPG키트장착/탈착비용(공급가)</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getJg_c_b())%>원&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">(c)</td>
                  <td align="center">jg_c_c</td>
                  <td colspan="2">&nbsp;최대잔가대비 적용잔가율 1% 차이당 D/C율</td>
                  <td align="right" ><%=bean.getJg_c_c()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(d)</td>
                  <td align="center">jg_c_d</td>
                  <td colspan="2">&nbsp;적용잔가율 조정에 따른 최대 D/C율</td>
                  <td align="right"><%=bean.getJg_c_d()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" >(12)</td>
                  <td align="center" >jg_c_12</td>
                  <td colspan="2">&nbsp;제조사 DC의 잔가조정 효과</td>
                  <td align="right" ><%=bean.getJg_c_12()%>%&nbsp;&nbsp;</td>
                </tr>                
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>6. <a href="javascript:update()">재리스공통변수</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center">(a)</td>
                  <td align="center">sh_c_a</td>
                  <td colspan="2">&nbsp;낙찰예상가 대비 현재가치 산출 승수</td>
                  <td align="right"><%=bean.getSh_c_a()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용
                <tr> 
                  <td align="center" width="95">(b)1</td>
                  <td align="center" width="99">sh_c_b1</td>
                  <td colspan="2">&nbsp;재리스 초기 영업비용 적용율-재리스</td>
                  <td align="right" width="97"><%=bean.getSh_c_b1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(b)2</td>
                  <td align="center" width="99">sh_c_b2</td>
                  <td colspan="2">&nbsp;재리스 초기 영업비용 적용율-연장</td>
                  <td align="right" width="97"><%=bean.getSh_c_b2()%>%&nbsp;&nbsp;</td>
                </tr>
                 -->
                <tr> 
                  <td align="center">(d)1</td>
                  <td align="center">sh_c_d1</td>
                  <td colspan="2">&nbsp;재리스 초기 영업비용 할증율-재리스</td>
                  <td align="right"><%=bean.getSh_c_d1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">(d)2</td>
                  <td align="center" >sh_c_d2</td>
                  <td colspan="2">&nbsp;재리스 초기 영업비용 할증율-연장</td>
                  <td align="right"><%=bean.getSh_c_d2()%>%&nbsp;&nbsp;</td>
                </tr>
                <!-- 미사용
                <tr> 
                  <td align="center" width="95">(p)1</td>
                  <td align="center" width="99">sh_p_1</td>
                  <td colspan="2">&nbsp;중고차 딜러마진 정액변수</td>
                  <td align="right" width="97"><%=AddUtil.parseDecimal(bean.getSh_p_1())%>원&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">(p)2</td>
                  <td align="center" width="99">sh_p_2</td>
                  <td colspan="2">&nbsp;중고차 딜러마진 정율변수</td>
                  <td align="right" width="97"><%=bean.getSh_p_2()%>%&nbsp;&nbsp;</td>
                </tr>
                 
                <tr> 
                  <td align="center" width="95">k</td>
                  <td align="center" width="99">sh_c_k</td>
                  <td colspan="2">&nbsp;일반승용LPG 재리스 시작시점 차령60개월 이상일 경우 잔가조정율</td>
                  <td align="right" width="97"><%=bean.getSh_c_k()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">m</td>
                  <td align="center" width="99">sh_c_m</td>
                  <td colspan="2">&nbsp;일반승용LPG 재리스 종료시점 차령60개월 이상일 경우 잔가조정율</td>
                  <td align="right" width="97"><%=bean.getSh_c_m()%>%&nbsp;&nbsp;</td>
                </tr>
                -->
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons00~04</td>
                  <td colspan="3">&nbsp; 재리스 지점간 이동 탁송료 : 서울출발 ->                   
                                   서울<%=bean.getBr_cons_00()%>원&nbsp;
                                   대전<%=bean.getBr_cons_01()%>원&nbsp;
                                   대구<%=bean.getBr_cons_02()%>원&nbsp;
                                   광주<%=bean.getBr_cons_03()%>원&nbsp;
                                   부산<%=bean.getBr_cons_04()%>원&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons10~14</td>
                  <td colspan="3">&nbsp; 재리스 지점간 이동 탁송료 : 대전출발 ->                   
                                   서울<%=bean.getBr_cons_10()%>원&nbsp;
                                   대전<%=bean.getBr_cons_11()%>원&nbsp;
                                   대구<%=bean.getBr_cons_12()%>원&nbsp;
                                   광주<%=bean.getBr_cons_13()%>원&nbsp;
                                   부산<%=bean.getBr_cons_14()%>원&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons20~24</td>
                  <td colspan="3">&nbsp; 재리스 지점간 이동 탁송료 : 대구출발 ->                   
                                   서울<%=bean.getBr_cons_20()%>원&nbsp;
                                   대전<%=bean.getBr_cons_21()%>원&nbsp;
                                   대구<%=bean.getBr_cons_22()%>원&nbsp;
                                   광주<%=bean.getBr_cons_23()%>원&nbsp;
                                   부산<%=bean.getBr_cons_24()%>원&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons30~34</td>
                  <td colspan="3">&nbsp; 재리스 지점간 이동 탁송료 : 광주출발 ->                   
                                   서울<%=bean.getBr_cons_30()%>원&nbsp;
                                   대전<%=bean.getBr_cons_31()%>원&nbsp;
                                   대구<%=bean.getBr_cons_32()%>원&nbsp;
                                   광주<%=bean.getBr_cons_33()%>원&nbsp;
                                   부산<%=bean.getBr_cons_34()%>원&nbsp;                                  
                  </td>
                </tr>
                <tr> 
                  <td align="center"></td>
                  <td align="center">br_cons40~44</td>
                  <td colspan="3">&nbsp; 재리스 지점간 이동 탁송료 : 부산출발 ->                   
                                   서울<%=bean.getBr_cons_40()%>원&nbsp;
                                   대전<%=bean.getBr_cons_41()%>원&nbsp;
                                   대구<%=bean.getBr_cons_42()%>원&nbsp;
                                   광주<%=bean.getBr_cons_43()%>원&nbsp;
                                   부산<%=bean.getBr_cons_44()%>원&nbsp;                                  
                  </td>
                </tr>                                                                
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>7. <a href="javascript:update()">수입차공통변수</a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center">수1</td>
                  <td align="center">k_su_1</td>
                  <td colspan="2">&nbsp;수입차 개소세전차량가 추정용 세율조정치</td>
                  <td align="right"><%=bean.getK_su_1()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">수3</td>
                  <td align="center">k_su_2</td>
                  <td colspan="2">&nbsp;수입차 통관면세가 산출승수</td>
                  <td align="right"><%=bean.getK_su_2()%>%&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">CB1</td>
                  <td align="center">a_cb_1</td>
                  <td colspan="2">&nbsp;국산차 카드결재 cash back 반영요율</td>
                  <td align="right"><%=bean.getA_cb_1()%>%&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>      
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>8. <a href="javascript:update()">재리스/연장 사고수리비 반영 공통변수 </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center">사고 a.</td>
                  <td align="center">accid_a</td>
                  <td colspan="2">&nbsp;차가 자승수</td>
                  <td align="right"><%=bean.getAccid_a()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">사고 b.</td>
                  <td align="center">accid_b</td>
                  <td colspan="2">&nbsp;대파기준 수리비 승수</td>
                  <td align="right"><%=bean.getAccid_b()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">사고 c.</td>
                  <td align="center">accid_c</td>
                  <td colspan="2">&nbsp;수입차 승수</td>
                  <td align="right" width="97"><%=bean.getAccid_c()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 d.</td>
                  <td align="center" width="99">accid_d</td>
                  <td colspan="2">&nbsp;2위 사고수리비 반영율</td>
                  <td align="right" width="97"><%=bean.getAccid_d()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 e.</td>
                  <td align="center" width="99">accid_e</td>
                  <td colspan="2">&nbsp;기준수리비미만 자승수</td>
                  <td align="right" width="97"><%=bean.getAccid_e()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 f.</td>
                  <td align="center" width="99">accid_f</td>
                  <td colspan="2">&nbsp;기준수리비이상 자승수</td>
                  <td align="right" width="97"><%=bean.getAccid_f()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 g.</td>
                  <td align="center" width="99">accid_g</td>
                  <td colspan="2">&nbsp;기준 감가율</td>
                  <td align="right" width="97"><%=bean.getAccid_g()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 h.</td>
                  <td align="center" width="99">accid_h</td>
                  <td colspan="2">&nbsp;차령적용승수</td>
                  <td align="right" width="97"><%=bean.getAccid_h()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 j.</td>
                  <td align="center" width="99">accid_j</td>
                  <td colspan="2">&nbsp;차령반영비율</td>
                  <td align="right" width="97"><%=bean.getAccid_j()%>&nbsp;&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95">사고 k.</td>
                  <td align="center" width="99">accid_k</td>
                  <td colspan="2">&nbsp;주행거리적용승수</td>
                  <td align="right" width="97"><%=bean.getAccid_k()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 m.</td>
                  <td align="center" width="99">accid_m</td>
                  <td colspan="2">&nbsp;주행거리반영비율</td>
                  <td align="right" width="97"><%=bean.getAccid_m()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">사고 n.</td>
                  <td align="center" width="99">accid_n</td>
                  <td colspan="2">&nbsp;차령,주행거리반영 조정승수</td>
                  <td align="right" width="97"><%=bean.getAccid_n()%>&nbsp;&nbsp;</td>
                </tr>                                              
            </table>
        </td>
    </tr>  
    <tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2"><span class=style2>9. <a href="javascript:update()">전기차공통변수 </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>       
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">ecar_tax</td>
                  <td colspan="2">&nbsp;전기차/수소차 자동차세(년간)</td>
                  <td align="right" width="97"><%=bean.getEcar_tax()%>&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="95">ecar_0_yn</td>
                  <td align="center" width="99">ecar_0_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 서울</td>
                  <td align="right" width="97"><%=bean.getEcar_0_yn()%>&nbsp;<%=bean.getEcar_0_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_1_yn</td>
                  <td align="center" width="99">ecar_1_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 인천/경기</td>
                  <td align="right" width="97"><%=bean.getEcar_1_yn()%>&nbsp;<%=bean.getEcar_1_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_2_yn</td>
                  <td align="center" width="99">ecar_2_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 강원</td>
                  <td align="right" width="97"><%=bean.getEcar_2_yn()%>&nbsp;<%=bean.getEcar_2_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_3_yn</td>
                  <td align="center" width="99">ecar_3_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 대전</td>
                  <td align="right" width="97"><%=bean.getEcar_3_yn()%>&nbsp;<%=bean.getEcar_3_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_4_yn</td>
                  <td align="center" width="99">ecar_4_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 광주</td>
                  <td align="right" width="97"><%=bean.getEcar_4_yn()%>&nbsp;<%=bean.getEcar_4_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_5_yn</td>
                  <td align="center" width="99">ecar_5_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 대구</td>
                  <td align="right" width="97"><%=bean.getEcar_5_yn()%>&nbsp;<%=bean.getEcar_5_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_6_yn</td>
                  <td align="center" width="99">ecar_6_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 부산</td>
                  <td align="right" width="97"><%=bean.getEcar_6_yn()%>&nbsp;<%=bean.getEcar_6_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_7_yn</td>
                  <td align="center" width="99">ecar_7_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 세종/충남/충북</td>
                  <td align="right" width="97"><%=bean.getEcar_7_yn()%>&nbsp;<%=bean.getEcar_7_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_8_yn</td>
                  <td align="center" width="99">ecar_8_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 경북</td>
                  <td align="right" width="97"><%=bean.getEcar_8_yn()%>&nbsp;<%=bean.getEcar_8_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95">ecar_9_yn</td>
                  <td align="center" width="99">ecar_9_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 울산/경남</td>
                  <td align="right" width="97"><%=bean.getEcar_9_yn()%>&nbsp;<%=bean.getEcar_9_amt()%>만원&nbsp;</td>
                </tr>    
                <tr> 
                  <td align="center" width="95">ecar_10_yn</td>
                  <td align="center" width="99">ecar_10_amt</td>
                  <td colspan="2">&nbsp;전기차 지자체보조금 전남/전북(광주제외)</td>
                  <td align="right" width="97"><%=bean.getEcar_10_yn()%>&nbsp;<%=bean.getEcar_10_amt()%>만원&nbsp;</td>
                </tr>                                                      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">ecar_bat_cost</td>
                  <td colspan="2">&nbsp;전기차 완속충전기 이전비용</td>
                  <td align="right" width="97"><%=bean.getEcar_bat_cost()%>원&nbsp;</td>
                </tr>                                                         
            </table>
        </td>
    </tr>      
    <tr>
        <td colspan="2"><span class=style2>10. <a href="javascript:update()">수소차공통변수 </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>       
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_0_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 서울/경기</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_0_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_1_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 인천</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_1_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_2_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 강원</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_2_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_3_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 대전</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_3_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_4_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 광주/전남/전북</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_4_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_5_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 대구/경북</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_5_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_6_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 부산/울산/경남</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_6_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_7_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 세종/충남/충북(대전제외)</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_7_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_8_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 기타</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_8_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_9_amt</td>
                  <td colspan="2">&nbsp;수소차 지자체보조금 기타</td>
                  <td align="right" width="97">&nbsp;<%=bean.getHcar_9_amt()%>만원&nbsp;</td>
                </tr>                                                         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">hcar_cost</td>
                  <td colspan="2">&nbsp;수소차 중도해지 리스크 조절값</td>
                  <td align="right" width="97"><%=bean.getHcar_cost()%>원&nbsp;</td>
                </tr>                                                         
            </table>
        </td>
    </tr>          
    <tr>
        <td colspan="2"><span class=style2>11. <a href="javascript:update()">비용금액 </a></span>&nbsp;<a href="javascript:update()"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>       
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class=title width="150">변수기호</td>
                  <td class=title width="150">변수코드</td>
                  <td class=title colspan="2">변수명</td>
                  <td class=title width="200">변수값</td>
                </tr>
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">car_maint_amt1</td>
                  <td colspan="2">&nbsp;자동차정기검사수수료</td>
                  <td align="right" width="97">&nbsp;<%=bean.getCar_maint_amt1()%>원&nbsp;</td>
                </tr>        
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">car_maint_amt2</td>
                  <td colspan="2">&nbsp;자동차종합검사수수료</td>
                  <td align="right" width="97">&nbsp;<%=bean.getCar_maint_amt2()%>원&nbsp;(전기/수소차:<%=bean.getCar_maint_amt3()%>원)&nbsp;</td>
                </tr>   
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">car_maint_amt4</td>
                  <td colspan="2">&nbsp;수소차내압용기점사비용 (내압검사수수료+탁송료/인건비)</td>
                  <td align="right" width="97">&nbsp;<%=bean.getCar_maint_amt4()%>원&nbsp;</td>
                </tr>     
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_b_amt</td>
                  <td colspan="2">&nbsp;용품비-블랙박스</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_b_amt()%>원&nbsp;</td>
                </tr>        
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_s_amt</td>
                  <td colspan="2">&nbsp;용품비-전면썬팅</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_s_amt()%>원&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_n_amt</td>
                  <td colspan="2">&nbsp;용품비-내비게이션</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_n_amt()%>원&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_eb_amt</td>
                  <td colspan="2">&nbsp;용품비-이동형충전기</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_eb_amt()%>원&nbsp;</td>
                </tr>      
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">tint_bn_amt</td>
                  <td colspan="2">&nbsp;용품비-블랙박스미제공가감</td>
                  <td align="right" width="97">&nbsp;<%=bean.getTint_bn_amt()%>원&nbsp;</td>
                </tr>         
                <tr> 
                  <td align="center" width="95"></td>
                  <td align="center" width="99">legal_amt</td>
                  <td colspan="2">&nbsp;법률비용지원금</td>
                  <td align="right" width="97">&nbsp;<%=bean.getLegal_amt()%>원&nbsp;</td>
                </tr>                                                                                               
            </table>
        </td>
    </tr>                 
</table>
</body>
</html>