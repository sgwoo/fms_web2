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
	
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	bean = e_db.getEstiCommVarCase(a_a, seq);
	
	String em_a_j  = e_db.getVar_b_dt_Chk("em", a_a, AddUtil.getDate(4));
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(cmd){
		var fm = document.form1;
		if(cmd == 'i'){
			if(!confirm('등록하시겠습니까?')){	return;	}
		}else if(cmd == 'up'){
			if(!confirm('입력한 데이타로 업그레이드합니다.\n\n진짜로 업그레이드하시겠습니까?')){	return;	}			
		}else{
			if(!confirm('수정하시겠습니까?')){	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
		fm.submit();		
	}
	
	//목록보기
	function go_list(){
		location='esti_var_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>';
	}
	

//-->
</script>
</head>
<body>
<form name="form1" method="post" action="esti_comm_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 견적변수관리 > <span class=style5>공통변수 
                    <%if(seq.equals("")){%>
                    등록 
                    <%}else{%>
                    수정 
                    <%}%></span></span>
                    </td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr> 
        <td align="right"> 
        
        <%if(!auth_rw.equals("1") && em_a_j.equals(bean.getA_j())){ //최근것만 수정,업그레이드 할수 있다%>
        <%    if(seq.equals("")){%>
        <a href="javascript:save('i');"><img src=../images/center/button_reg.gif border=0></a> 
        <%    }else{%>
        <a href="javascript:save('u');"><img src=../images/center/button_modify.gif border=0></a> <a href="javascript:save('up');"><img src=../images/center/button_upgrade.gif border=0></a> 
        <%    }%>
        <%}%>
        <a href="javascript:go_list();"><img src=../images/center/button_list.gif border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">대여구분</td>
                    <td > <select name="a_a">
                        <option value="1" <%if(a_a.equals("1"))%>selected<%%>>리스</option>
                        <option value="2" <%if(a_a.equals("2"))%>selected<%%>>렌트</option>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title width="400">견적적용일</td>
                    <td > <input type="text" name="a_j" value='<%=AddUtil.ChangeDate2(bean.getA_j())%>' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><span class=style2>1. 핵심변수</span></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=275>적용이자율</td>
                    <td> <input type="text" name="a_f" size="15" class=num value='<%=bean.getA_f()%>'>
                      %</td>
                </tr>
                <!-- 20080901 이후 미사용  -->
                <!-- 
                <tr> 
                    <td class=title width="400">10만원당 월할부금</td>
                    <td> 48개월 
                      <input type="text" name="a_g_7" value='<%=AddUtil.parseDecimal(bean.getA_g_7())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 42개월 
                      <input type="text" name="a_g_5" value='<%=AddUtil.parseDecimal(bean.getA_g_5())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 36개월 
                      <input type="text" name="a_g_1" value='<%=AddUtil.parseDecimal(bean.getA_g_1())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 30개월 
                      <input type="text" name="a_g_6" value='<%=AddUtil.parseDecimal(bean.getA_g_6())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, <br>24개월 
                      <input type="text" name="a_g_2" value='<%=AddUtil.parseDecimal(bean.getA_g_2())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 18개월 
                      <input type="text" name="a_g_3" value='<%=AddUtil.parseDecimal(bean.getA_g_3())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 12개월 
                      <input type="text" name="a_g_4" value='<%=AddUtil.parseDecimal(bean.getA_g_4())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">특소세 환입율</td>
                    <td> <input type="text" name="o_12" value='<%=bean.getO_12()%>' size="15" class=num>
                      % (12개월후)</td>
                </tr>
                <tr> 
                    <td class=title width="400">종합보험비용 적용율</td>
                    <td> <input type="text" name="g_3" value='<%=bean.getG_3()%>' size="15" class=num>
                      % (현보험료 대비)</td>
                </tr>
                <tr> 
                    <td class=title width="400">자차보험비용 적용율</td>
                    <td> <input type="text" name="g_5" value='<%=bean.getG_5()%>' size="15" class=num>
                      % (일반법인보험료대비)</td>
                </tr>
                <!-- 미사용 
                <tr> 
                    <td class=title width="400">대물,자손보험 1억 가입시<br>
                      대여료 인상액</td>
                    <td> <input type="text" name="oa_b" value='<%=bean.getOa_b()%>' size="15" class=num>
                      원</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">만21세이상 운전보험 가입시<br>
                      대여료 인상1</td>
                    <td> <input type="text" name="oa_c" value='<%=bean.getOa_c()%>' size="15" class=num>
                      % (차가대비)</td>
                </tr>
                <tr> 
                    <td class=title width="400">기본식 기본보증금율</td>
                    <td> <input type="text" name="g_8" value='<%=bean.getG_8()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">기본식 목표마진</td>
                    <td> <!-- 48개월 
                      <input type="text" name="g_9_7" value='<%=bean.getG_9_7()%>' size="6" class=num>
                      %, 42개월 
                      <input type="text" name="g_9_6" value='<%=bean.getG_9_6()%>' size="6" class=num>
                      %, 36개월 
                      <input type="text" name="g_9_5" value='<%=bean.getG_9_5()%>' size="6" class=num>
                      %, 30개월 
                      <input type="text" name="g_9_4" value='<%=bean.getG_9_4()%>' size="6" class=num>
                      %, <br>24개월 
                      <input type="text" name="g_9_3" value='<%=bean.getG_9_3()%>' size="6" class=num>
                      %, 18개월 
                      <input type="text" name="g_9_2" value='<%=bean.getG_9_2()%>' size="6" class=num>
                      %, 12개월
                       --> 
                      <input type="text" name="g_9_1" value='<%=bean.getG_9_1()%>' size="6" class=num>
                      % (계약고 대비) </td>
                </tr>
                <tr> 
                    <td class=title width="400">일반식 개시대여료 기본납입 개월수</td>
                    <td> <input type="text" name="g_10" value='<%=bean.getG_10()%>' size="6" class=num>
                      개월</td>
                </tr>
                <tr> 
                    <td class=title width="400">일반식 목표마진</td>
                    <td> <!-- 48개월 
                      <input type="text" name="g_11_7" value='<%=bean.getG_11_7()%>' size="6" class=num>
                      %, 42개월 
                      <input type="text" name="g_11_6" value='<%=bean.getG_11_6()%>' size="6" class=num>
                      %, 36개월 
                      <input type="text" name="g_11_5" value='<%=bean.getG_11_5()%>' size="6" class=num>
                      %, 30개월 
                      <input type="text" name="g_11_4" value='<%=bean.getG_11_4()%>' size="6" class=num>
                      %, <br>24개월 
                      <input type="text" name="g_11_3" value='<%=bean.getG_11_3()%>' size="6" class=num>
                      %, 18개월 
                      <input type="text" name="g_11_2" value='<%=bean.getG_11_2()%>' size="6" class=num>
                      %, 12개월 
                      --> 
                      <input type="text" name="g_11_1" value='<%=bean.getG_11_1()%>' size="6" class=num>
                      % (계약고 대비) </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><span class=style2>2. 기타변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">채권할인율</td>
                    <td >서울 
                      <input type="text" name="o_8_1" value='<%=bean.getO_8_1()%>' size="8" class=num>
                      %, 경기 
                      <input type="text" name="o_8_2" value='<%=bean.getO_8_2()%>' size="8" class=num>
                      %, 부산
                      <input type="text" name="o_8_3" value='<%=bean.getO_8_3()%>' size="8" class=num>
                      %, 경남
                      <input type="text" name="o_8_4" value='<%=bean.getO_8_4()%>' size="8" class=num>
                      %, 대전
                      <input type="text" name="o_8_5" value='<%=bean.getO_8_5()%>' size="8" class=num>
                      %, 인천
                      <input type="text" name="o_8_7" value='<%=bean.getO_8_7()%>' size="8" class=num>
                      %, 광주/대구
                      <input type="text" name="o_8_8" value='<%=bean.getO_8_8()%>' size="8" class=num>
                      % </td>
                </tr>
                <tr> 
                    <td class=title>등록부대비용</td>
                    <td>서울 
                      <input type="text" name="o_9_1" value='<%=AddUtil.parseDecimal(bean.getO_9_1())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 경기 
                      <input type="text" name="o_9_2" value='<%=AddUtil.parseDecimal(bean.getO_9_2())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 부산 
                      <input type="text" name="o_9_3" value='<%=AddUtil.parseDecimal(bean.getO_9_3())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 경남
                      <input type="text" name="o_9_4" value='<%=AddUtil.parseDecimal(bean.getO_9_4())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 대전
                      <input type="text" name="o_9_5" value='<%=AddUtil.parseDecimal(bean.getO_9_5())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 인천
                      <input type="text" name="o_9_7" value='<%=AddUtil.parseDecimal(bean.getO_9_7())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 광주/대구
                      <input type="text" name="o_9_8" value='<%=AddUtil.parseDecimal(bean.getO_9_8())%>' size="8" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>공급가대비 대출율</td>
                    <td> <input type="text" name="o_10" value='<%=bean.getO_10()%>' size="15" class=num>
                      %</td>
                </tr>
                <!-- 미사용
                 
                <tr> 
                    <td class=title>견적기준일의 년말일자</td>
                    <td> <input type="text" name="o_e" value='<%=AddUtil.ChangeDate2(bean.getO_e())%>' size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>
                </tr>
                -->
                <tr> 
                    <td class=title>차고지 유지비</td>
                    <td> <input type="text" name="g_1" value='<%=AddUtil.parseDecimal(bean.getG_1())%>' size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>보증보험가입금 적용율-일반식</td>
                    <td> <input type="text" name="oa_f" value='<%=bean.getOa_f()%>' size="15" class=num>
                      %</td>
                </tr>
                <!--  미사용
                <tr> 
                    <td class=title>보증보험가입금 적용율-기본식</td>
                    <td> <input type="text" name="oa_h" value='<%=bean.getOa_h()%>' size="15" class=num>
                      %</td>
                </tr>
                -->
                <tr> 
                    <td class=title>보증보험료 적용율</td>
                    <td> <input type="text" name="oa_g" value='<%=bean.getOa_g()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>현재 중고차 경기지수</td>
                    <td> <input type="text" name="a_m_1" value='<%=bean.getA_m_1()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>36개월후 현재 중고차 경기지수 반영율</td>
                    <td> <input type="text" name="a_m_2" value='<%=bean.getA_m_2()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>(재리스)현재 중고차 경기지수</td>
                    <td> <input type="text" name="sh_a_m_1" value='<%=bean.getSh_a_m_1()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title>(재리스)36개월후 현재 중고차 경기지수 반영율</td>
                    <td> <input type="text" name="sh_a_m_2" value='<%=bean.getSh_a_m_2()%>' size="15" class=num>
                      %</td>
                </tr>  
                <!--       미사용       
                <tr> 
                    <td class=title>CASH BACK율</td>
                    <td> <input type="text" name="bc_s_i" value='<%=bean.getBc_s_i()%>' size="15" class=num>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">카드결제리베이트율</td>
                    <td> <input type="text" name="ax_n" value='<%=bean.getAx_n()%>' size="15" class=num>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">카드결제금액율</td>
                    <td> <input type="text" name="ax_n_c" value='<%=bean.getAx_n_c()%>' size="15" class=num>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">위약금산출기준 이용기간</td>
                    <td> <input type="text" name="ax_p" value='<%=bean.getAx_p()%>' size="15" class=num>
                      개월</td>
                </tr>
                 -->				
                <tr> 
                    <td class=title width="400">정비비용상한금액-일반식 추가관리비대비</td>
                    <td> <input type="text" name="ax_q" value='<%=bean.getAx_q()%>' size="15" class=num>
                      %</td>
                </tr>
                <!-- 미사용								
                <tr> 
                    <td class=title width="400">주행거리 무제한견적 가능 차종-예상주행거리율</td>
                    <td> <input type="text" name="ax_r_1" value='<%=bean.getAx_r_1()%>' size="15" class=num>
                      %</td>
                </tr>								
                <tr> 
                    <td class=title width="400">주행거리 약정견적만 가능 차종-예상주행거리율</td>
                    <td> <input type="text" name="ax_r_2" value='<%=bean.getAx_r_2()%>' size="15" class=num>
                      %</td>
                </tr>
                 -->	
                <!-- 	미사용						
                <tr> 
                    <td class=title>장기대여차량 이용 주요 법인</td>
                    <td> <textarea name="companys" cols="80" class="text" rows="7"><%=bean.getCompanys()%></textarea> 
                    </td>
                </tr>                 
                <tr> 
                    <td class=title>이용문의</td>
                    <td> 담당자 
                      <input type="text" name="quiry_nm" value='<%=bean.getQuiry_nm()%>' size="15" class=text>
                      , 연락처 
                      <input type="text" name="quiry_tel" value='<%=bean.getQuiry_tel()%>' size="15" class=text> 
                    </td>
                </tr>
                -->
                <tr>
                	<td class=title>차선이탈제어형</td>
                	<td>
                		<input type="text" name="a_y_1" value='<%=bean.getA_y_1()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>차선이탈경고형</td>
                	<td>
                		<input type="text" name="a_y_2" value='<%=bean.getA_y_2()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>긴급제동제어형</td>
                	<td>
                		<input type="text" name="a_y_3" value='<%=bean.getA_y_3()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>긴급제동경고형</td>
                	<td>
                		<input type="text" name="a_y_4" value='<%=bean.getA_y_4()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>전기차여부</td>
                	<td>
                		<input type="text" name="a_y_5" value='<%=bean.getA_y_5()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr>
                	<td class=title>견인고리(트레일러용)</td>
                	<td>
                		<input type="text" name="a_y_6" value='<%=bean.getA_y_6()%>' size="5" class=num>%
                	</td>
                </tr>
                <tr> 
                    <td class=title>초기납입금 적용 이자율</td>
                    <td> <input type="text" name="a_f_2" size="15" class=num value='<%=bean.getA_f_2()%>'>
                      %</td>
                </tr>  
                <tr> 
                    <td class=title>중고차 잔존가치 환산 이자율</td>
                    <td> <input type="text" name="a_f_3" size="15" class=num value='<%=bean.getA_f_3()%>'>
                      %</td>
                </tr>  
                <tr> 
                    <td class=title>서울보증보험 아마존카 할인할증율</td>
                    <td> <input type="text" name="oa_extra" value='<%=bean.getOa_extra()%>' size="15" class=num>
                      %</td>
                </tr>          
                <tr> 
                    <td class=title>서울보증보험 신용1등급 보험요율</td>
                    <td> <input type="text" name="oa_g_1" value='<%=bean.getOa_g_1()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>서울보증보험 신용2등급 보험요율</td>
                    <td> <input type="text" name="oa_g_2" value='<%=bean.getOa_g_2()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>서울보증보험 신용3등급 보험요율</td>
                    <td> <input type="text" name="oa_g_3" value='<%=bean.getOa_g_3()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>서울보증보험 신용4등급 보험요율</td>
                    <td> <input type="text" name="oa_g_4" value='<%=bean.getOa_g_4()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>서울보증보험 신용5등급 보험요율</td>
                    <td> <input type="text" name="oa_g_5" value='<%=bean.getOa_g_5()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>서울보증보험 신용6등급 보험요율</td>
                    <td> <input type="text" name="oa_g_6" value='<%=bean.getOa_g_6()%>' size="15" class=num>
                      %</td>
                </tr>                                          
                <tr> 
                    <td class=title>서울보증보험 신용7등급 보험요율</td>
                    <td> <input type="text" name="oa_g_7" value='<%=bean.getOa_g_7()%>' size="15" class=num>
                      %</td>
                </tr>                                          
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
                <!-- 20080901 이후 미사용  -->
                <!--    
    <tr>
        <td><span class=style2>3. 우량기업 변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">적용이자율</td>
                    <td > <input type="text" name="a_f_w" size="15" class=num value='<%=bean.getA_f_w()%>'>
                      %</td>
                </tr>

                <tr> 
                    <td class=title>10만원당 월할부금</td>
                    <td> 48개월 
                      <input type="text" name="a_g_7_w" value='<%=AddUtil.parseDecimal(bean.getA_g_7_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 42개월 
                      <input type="text" name="a_g_6_w" value='<%=AddUtil.parseDecimal(bean.getA_g_6_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 36개월 
                      <input type="text" name="a_g_5_w" value='<%=AddUtil.parseDecimal(bean.getA_g_5_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 30개월 
                      <input type="text" name="a_g_4_w" value='<%=AddUtil.parseDecimal(bean.getA_g_4_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, <br>24개월 
                      <input type="text" name="a_g_3_w" value='<%=AddUtil.parseDecimal(bean.getA_g_3_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 18개월 
                      <input type="text" name="a_g_2_w" value='<%=AddUtil.parseDecimal(bean.getA_g_2_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 12개월 
                      <input type="text" name="a_g_1_w" value='<%=AddUtil.parseDecimal(bean.getA_g_1_w())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>기본식 목표마진</td>
                    <td> <input type="text" name="g_9_11_w" value='<%=bean.getG_9_11_w()%>' size="6" class=num>
                      % (계약고 대비) </td>
                </tr>
                <tr>
                    <td class=title>일반식 목표마진</td>
                    <td><input type="text" name="g_11_w" value='<%=bean.getG_11_w()%>' size="6" class=num>
                      % (계약고 대비) </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
                -->
                <!-- 20080901 이후 미사용  -->
                <!--    
    <tr>
        <td><span class=style2>4. 초우량기업 변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">적용이자율</td>
                    <td> <input type="text" name="a_f_uw" size="15" class=num value='<%=bean.getA_f_uw()%>'>
                      %</td>
                </tr>

                <tr> 
                    <td class=title>10만원당 월할부금</td>
                    <td> 48개월 
                      <input type="text" name="a_g_7_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_7_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 42개월 
                      <input type="text" name="a_g_6_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_6_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 36개월 
                      <input type="text" name="a_g_5_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_5_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 30개월 
                      <input type="text" name="a_g_4_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_4_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, <br>24개월 
                      <input type="text" name="a_g_3_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_3_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 18개월 
                      <input type="text" name="a_g_2_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_2_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원, 12개월 
                      <input type="text" name="a_g_1_uw" value='<%=AddUtil.parseDecimal(bean.getA_g_1_uw())%>' size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>기본식 목표마진</td>
                    <td> <input type="text" name="g_9_11_uw" value='<%=bean.getG_9_11_uw()%>' size="6" class=num>
                    % (계약고 대비) </td>
                </tr>
                <tr>
                    <td class=title>일반식 목표마진</td>
                    <td> <input type="text" name="g_11_uw" value='<%=bean.getG_11_uw()%>' size="6" class=num>
                     % (계약고 대비) </td>
                </tr>
            </table>
        </td>
    </tr>
    -->
    
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>5. 잔가공통변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">0개월기준잔가</td>
                    <td> <input type="text" name="jg_c_1" size="15" class=num value='<%=bean.getJg_c_1()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">차령24개월 잔가율 2년간 변동율</td>
                    <td> <input type="text" name="jg_c_2" size="15" class=num value='<%=bean.getJg_c_2()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">신차 등록월에 따른 12개월당 잔가율 변동값</td>
                    <td> <input type="text" name="jg_c_3" size="15" class=num value='<%=bean.getJg_c_3()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">재리스차량 등록월에 따른 12개월당 잔가율 변동값</td>
                    <td> <input type="text" name="jg_c_32" size="15" class=num value='<%=bean.getJg_c_32()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">LPG겸용차 잔가율 기초 조정값</td>
                    <td> <input type="text" name="jg_c_4" size="15" class=num value='<%=bean.getJg_c_4()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">LPG겸용차 잔가율 1년동 조정값</td>
                    <td> <input type="text" name="jg_c_5" size="15" class=num value='<%=bean.getJg_c_5()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">3년 초과견적시 잔가율 1년동 조정값</td>
                    <td> <input type="text" name="jg_c_6" size="15" class=num value='<%=bean.getJg_c_6()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">3년 표준주행거리(km)-가솔린엔진</td>
                    <td> <input type="text" name="jg_c_71" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_71())%>'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title width="400">3년 표준주행거리(km)-디젤엔진</td>
                    <td> <input type="text" name="jg_c_72" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_72())%>'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title width="400">3년 표준주행거리(km)-LPG엔진(전용차)</td>
                    <td> <input type="text" name="jg_c_73" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_73())%>'>
                      원</td>
                </tr>
                <!-- 미사용
                <tr> 
                    <td class=title width="400">표준주행거리 초과 10,000km당 중고차가 조정율 (가솔린,LPG)</td>
                    <td> <input type="text" name="jg_c_81" size="15" class=num value='<%=bean.getJg_c_81()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">표준주행거리 초과 10,000km당 중고차가 조정율 (디젤)</td>
                    <td> <input type="text" name="jg_c_82" size="15" class=num value='<%=bean.getJg_c_82()%>'>
                      %</td>
                </tr>
                 -->				
                <tr> 
                    <td class=title width="400">24개월 시간경과에 따른 중고차가 하락율</td>
                    <td> <input type="text" name="jg_c_9" size="15" class=num value='<%=bean.getJg_c_9()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">LPG전용차량 24개월 시간경과에 따른 중고차가 하락율</td>
                    <td> <input type="text" name="jg_c_10" size="15" class=num value='<%=bean.getJg_c_10()%>'>
                      %</td>
                </tr>				
                <tr> 
                    <td class=title width="400">24개월 시간경과에 따른 중고차 리스트 완충율</td>
                    <td> <input type="text" name="jg_c_11" size="15" class=num value='<%=bean.getJg_c_11()%>'>
                      %</td>
                </tr>
                <!-- 		미사용		
                <tr> 
                    <td class=title width="400">간접분사LPG키트장착/탈착비용(공급가)</td>
                    <td> <input type="text" name="jg_c_a" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_a())%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">직접분사LPG키트장착/탈착비용(공급가)</td>
                    <td> <input type="text" name="jg_c_b" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getJg_c_b())%>'>
                      %</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">최대잔가대비 적용잔가율 1% 차이당 D/C율</td>
                    <td> <input type="text" name="jg_c_c" size="15" class=num value='<%=bean.getJg_c_c()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">적용잔가율 조정에 따른 최대 D/C율</td>
                    <td> <input type="text" name="jg_c_d" size="15" class=num value='<%=bean.getJg_c_d()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">제조사 DC의 잔가조정 효과</td>
                    <td> <input type="text" name="jg_c_12" size="15" class=num value='<%=bean.getJg_c_12()%>'>
                      %</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>6. 재리스공통변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">낙찰예상가 대비 현재가치 산출 승수</td>
                    <td> <input type="text" name="sh_c_a" size="15" class=num value='<%=bean.getSh_c_a()%>'>
                      %</td>
                </tr>
                <!-- 미사용
                <tr> 
                    <td class=title width="400">재리스 초기 영업비용 적용율-재리스</td>
                    <td> <input type="text" name="sh_c_b1" size="15" class=num value='<%=bean.getSh_c_b1()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">재리스 초기 영업비용 적용율-연장</td>
                    <td> <input type="text" name="sh_c_b2" size="15" class=num value='<%=bean.getSh_c_b2()%>'>
                      %</td>
                </tr>
                 -->
                <tr> 
                    <td class=title width="400">재리스 초기 영업비용 할증율-재리스</td>
                    <td> <input type="text" name="sh_c_d1" size="15" class=num value='<%=bean.getSh_c_d1()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">재리스 초기 영업비용 할증율-연장</td>
                    <td> <input type="text" name="sh_c_d2" size="15" class=num value='<%=bean.getSh_c_d2()%>'>
                      %</td>
                </tr>
                <!-- 미사용 
                <tr> 
                    <td class=title width="400">중고차 딜러마진 정액변수</td>
                    <td> <input type="text" name="sh_p_1" size="15" class=num value='<%=AddUtil.parseDecimal(bean.getSh_p_1())%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">중고차 딜러마진 정율변수</td>
                    <td> <input type="text" name="sh_p_2" size="15" class=num value='<%=bean.getSh_p_2()%>'>
                      %</td>
                </tr>
                 
                <tr> 
                    <td class=title width="400">일반승용LPG 재리스 시작시점 차령60개월 이상일 경우 잔가조정율</td>
                    <td> <input type="text" name="sh_c_k" size="15" class=num value='<%=bean.getSh_c_k()%>'>
                      %</td>
                </tr>
                <tr> 
                    <td class=title width="400">일반승용LPG 재리스 종료시점 차령60개월 이상일 경우 잔가조정율</td>
                    <td> <input type="text" name="sh_c_m" size="15" class=num value='<%=bean.getSh_c_m()%>'>
                      %</td>
                </tr>
                -->
                <tr> 
                    <td class=title width="400">재리스 지점간 이동 탁송료 : 서울출발</td>
                    <td>
                         서울<input type="text" name="br_cons_00" size="10" class=num value='<%=bean.getBr_cons_00()%>'>원 
                         대전<input type="text" name="br_cons_01" size="10" class=num value='<%=bean.getBr_cons_01()%>'>원 
                         대구<input type="text" name="br_cons_02" size="10" class=num value='<%=bean.getBr_cons_02()%>'>원 
                         광주<input type="text" name="br_cons_03" size="10" class=num value='<%=bean.getBr_cons_03()%>'>원 
                         부산<input type="text" name="br_cons_04" size="10" class=num value='<%=bean.getBr_cons_04()%>'>원 
                    </td>
                </tr>     
                <tr> 
                    <td class=title width="400">재리스 지점간 이동 탁송료 : 대전출발</td>
                    <td>
                         서울<input type="text" name="br_cons_10" size="10" class=num value='<%=bean.getBr_cons_10()%>'>원 
                         대전<input type="text" name="br_cons_11" size="10" class=num value='<%=bean.getBr_cons_11()%>'>원 
                         대구<input type="text" name="br_cons_12" size="10" class=num value='<%=bean.getBr_cons_12()%>'>원 
                         광주<input type="text" name="br_cons_13" size="10" class=num value='<%=bean.getBr_cons_13()%>'>원 
                         부산<input type="text" name="br_cons_14" size="10" class=num value='<%=bean.getBr_cons_14()%>'>원 
                    </td>
                </tr>   
                <tr> 
                    <td class=title width="400">재리스 지점간 이동 탁송료 : 대구출발</td>
                    <td>
                         서울<input type="text" name="br_cons_20" size="10" class=num value='<%=bean.getBr_cons_20()%>'>원 
                         대전<input type="text" name="br_cons_21" size="10" class=num value='<%=bean.getBr_cons_21()%>'>원 
                         대구<input type="text" name="br_cons_22" size="10" class=num value='<%=bean.getBr_cons_22()%>'>원 
                         광주<input type="text" name="br_cons_23" size="10" class=num value='<%=bean.getBr_cons_23()%>'>원 
                         부산<input type="text" name="br_cons_24" size="10" class=num value='<%=bean.getBr_cons_24()%>'>원 
                    </td>
                </tr>   
                <tr> 
                    <td class=title width="400">재리스 지점간 이동 탁송료 : 광주출발</td>
                    <td>
                         서울<input type="text" name="br_cons_30" size="10" class=num value='<%=bean.getBr_cons_30()%>'>원 
                         대전<input type="text" name="br_cons_31" size="10" class=num value='<%=bean.getBr_cons_31()%>'>원 
                         대구<input type="text" name="br_cons_32" size="10" class=num value='<%=bean.getBr_cons_32()%>'>원 
                         광주<input type="text" name="br_cons_33" size="10" class=num value='<%=bean.getBr_cons_33()%>'>원 
                         부산<input type="text" name="br_cons_34" size="10" class=num value='<%=bean.getBr_cons_34()%>'>원 
                    </td>
                </tr>   
                <tr> 
                    <td class=title width="400">재리스 지점간 이동 탁송료 : 부산출발</td>
                    <td>
                         서울<input type="text" name="br_cons_40" size="10" class=num value='<%=bean.getBr_cons_40()%>'>원 
                         대전<input type="text" name="br_cons_41" size="10" class=num value='<%=bean.getBr_cons_41()%>'>원 
                         대구<input type="text" name="br_cons_42" size="10" class=num value='<%=bean.getBr_cons_42()%>'>원 
                         광주<input type="text" name="br_cons_43" size="10" class=num value='<%=bean.getBr_cons_43()%>'>원 
                         부산<input type="text" name="br_cons_44" size="10" class=num value='<%=bean.getBr_cons_44()%>'>원 
                    </td>
                </tr>                                                                              
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>7. 수입차공통변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">수입차 개소세전차량가 추정용 세율조정치</td>
                    <td> <input type="text" name="k_su_1" size="15" class=num value='<%=bean.getK_su_1()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>수입차 통관면세가 산출승수</td>
                    <td> <input type="text" name="k_su_2" value='<%=bean.getK_su_2()%>' size="15" class=num>
                    </td>
                </tr>
                <tr>
                    <td class=title>국산차 카드결재 cash back 반영요율</td>
                    <td> <input type="text" name="a_cb_1" value='<%=bean.getA_cb_1()%>' size="15" class=num>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    	
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>8. 재리스/연장 사고수리비 반영 공통변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">차가 자승수</td>
                    <td> <input type="text" name="accid_a" size="15" class=num value='<%=bean.getAccid_a()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">대파기준 수리비 승수</td>
                    <td> <input type="text" name="accid_b" size="15" class=num value='<%=bean.getAccid_b()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">수입차 승수</td>
                    <td> <input type="text" name="accid_c" size="15" class=num value='<%=bean.getAccid_c()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">2위 사고수리비 반영율</td>
                    <td> <input type="text" name="accid_d" size="15" class=num value='<%=bean.getAccid_d()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">기준수리비미만 자승수</td>
                    <td> <input type="text" name="accid_e" size="15" class=num value='<%=bean.getAccid_e()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">기준수리비이상 자승수</td>
                    <td> <input type="text" name="accid_f" size="15" class=num value='<%=bean.getAccid_f()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">기준 감가율</td>
                    <td> <input type="text" name="accid_g" size="15" class=num value='<%=bean.getAccid_g()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">차령적용승수</td>
                    <td> <input type="text" name="accid_h" size="15" class=num value='<%=bean.getAccid_h()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">차령반영비율</td>
                    <td> <input type="text" name="accid_j" size="15" class=num value='<%=bean.getAccid_j()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">주행거리적용승수</td>
                    <td> <input type="text" name="accid_k" size="15" class=num value='<%=bean.getAccid_k()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">주행거리반영비율</td>
                    <td> <input type="text" name="accid_m" size="15" class=num value='<%=bean.getAccid_m()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">차령,주행거리반영 조정승수</td>
                    <td> <input type="text" name="accid_n" size="15" class=num value='<%=bean.getAccid_n()%>'>
                    </td>
                </tr>                                                
            </table>
        </td>
    </tr>    	
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>9. 전기차공통변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">전기차/수소차 자동차세(년간)</td>
                    <td> <input type="text" name="ecar_tax" size="15" class=num value='<%=bean.getEcar_tax()%>'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 서울</td>
                    <td> 지급여부 <input type="text" name="ecar_0_yn" value='<%=bean.getEcar_0_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_0_amt" value='<%=bean.getEcar_0_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 인천/경기</td>
                    <td> 지급여부 <input type="text" name="ecar_1_yn" value='<%=bean.getEcar_1_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_1_amt" value='<%=bean.getEcar_1_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 강원</td>
                    <td> 지급여부 <input type="text" name="ecar_2_yn" value='<%=bean.getEcar_2_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_2_amt" value='<%=bean.getEcar_2_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 대전</td>
                    <td> 지급여부 <input type="text" name="ecar_3_yn" value='<%=bean.getEcar_3_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_3_amt" value='<%=bean.getEcar_3_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 광주</td>
                    <td> 지급여부 <input type="text" name="ecar_4_yn" value='<%=bean.getEcar_4_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_4_amt" value='<%=bean.getEcar_4_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 대구</td>
                    <td> 지급여부 <input type="text" name="ecar_5_yn" value='<%=bean.getEcar_5_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_5_amt" value='<%=bean.getEcar_5_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 부산</td>
                    <td> 지급여부 <input type="text" name="ecar_6_yn" value='<%=bean.getEcar_6_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_6_amt" value='<%=bean.getEcar_6_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 세종/충남/충북</td>
                    <td> 지급여부 <input type="text" name="ecar_7_yn" value='<%=bean.getEcar_7_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_7_amt" value='<%=bean.getEcar_7_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 경북</td>
                    <td> 지급여부 <input type="text" name="ecar_8_yn" value='<%=bean.getEcar_8_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_8_amt" value='<%=bean.getEcar_8_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>전기차 지자체보조금 울산/경남</td>
                    <td> 지급여부 <input type="text" name="ecar_9_yn" value='<%=bean.getEcar_9_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_9_amt" value='<%=bean.getEcar_9_amt()%>' size="15" class=num>만원
                    </td>
                </tr>      
                                                                                          <tr> 
                    <td class=title>전기차 지자체보조금 전남/전북(광주제외)</td>
                    <td> 지급여부 <input type="text" name="ecar_10_yn" value='<%=bean.getEcar_10_yn()%>' size="2" class=text>
                    	&nbsp;&nbsp;
                    	지급금액 <input type="text" name="ecar_10_amt" value='<%=bean.getEcar_10_amt()%>' size="15" class=num>만원
                    </td>
                </tr>    
                <tr> 
                    <td class=title>전기차 완속충전기 이전비용</td>
                    <td> <input type="text" name="ecar_bat_cost" value='<%=bean.getEcar_bat_cost()%>' size="15" class=num>
                    </td>
                </tr>                                                                
            </table>
        </td>
    </tr> 
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><span class=style2>10. 수소차공통변수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">수소차 지자체보조금 서울/경기</td>
                    <td> 지급금액 <input type="text" name="hcar_0_amt" value='<%=bean.getHcar_0_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 인천</td>
                    <td> 지급금액 <input type="text" name="hcar_1_amt" value='<%=bean.getHcar_1_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 강원</td>
                    <td> 지급금액 <input type="text" name="hcar_2_amt" value='<%=bean.getHcar_2_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 대전</td>
                    <td> 지급금액 <input type="text" name="hcar_3_amt" value='<%=bean.getHcar_3_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 광주/전남/전북</td>
                    <td> 지급금액 <input type="text" name="hcar_4_amt" value='<%=bean.getHcar_4_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 대구/경북</td>
                    <td> 지급금액 <input type="text" name="hcar_5_amt" value='<%=bean.getHcar_5_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 부산/울산/경남</td>
                    <td> 지급금액 <input type="text" name="hcar_6_amt" value='<%=bean.getHcar_6_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 세종/충남/충북(대전제외)</td>
                    <td> 지급금액 <input type="text" name="hcar_7_amt" value='<%=bean.getHcar_7_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 기타</td>
                    <td> 지급금액 <input type="text" name="hcar_8_amt" value='<%=bean.getHcar_8_amt()%>' size="15" class=num>만원
                    </td>
                </tr>
                <tr> 
                    <td class=title>수소차 지자체보조금 기타</td>
                    <td> 지급금액 <input type="text" name="hcar_9_amt" value='<%=bean.getHcar_9_amt()%>' size="15" class=num>만원
                    </td>
                </tr>                                                                
                <tr> 
                    <td class=title>수소차 중도해지 리스크 조절값</td>
                    <td> <input type="text" name="hcar_cost" value='<%=bean.getHcar_cost()%>' size="15" class=num>
                    </td>
                </tr>                                                                
            </table>
        </td>
    </tr>   
    <tr>
        <td></td>
    </tr>     
    <tr> 
        <td><span class=style2>11. 비용금액</span></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="400">자동차정기검사수수료</td>
                    <td> <input type="text" name="car_maint_amt1" value='<%=bean.getCar_maint_amt1()%>' size="15" class=num> 원</td>
                </tr>
                <tr> 
                    <td class=title width="400">자동차종합검사수수료</td>
                    <td> <input type="text" name="car_maint_amt2" value='<%=bean.getCar_maint_amt2()%>' size="15" class=num> 원
                         (전기/수소차 <input type="text" name="car_maint_amt3" value='<%=bean.getCar_maint_amt3()%>' size="15" class=num> 원)                    
                    </td>
                </tr>
                <tr> 
                    <td class=title width="400">수소차내압용기점사비용</td>
                    <td> <input type="text" name="car_maint_amt4" value='<%=bean.getCar_maint_amt4()%>' size="15" class=num> 원 (내압검사수수료+탁송료/인건비)</td>
                </tr>
                <tr> 
                    <td class=title width="400">용품비-블랙박스</td>
                    <td> <input type="text" name="tint_b_amt" value='<%=bean.getTint_b_amt()%>' size="15" class=num> 원</td>
                </tr>
                <tr> 
                    <td class=title width="400">용품비-전면썬팅</td>
                    <td> <input type="text" name="tint_s_amt" value='<%=bean.getTint_s_amt()%>' size="15" class=num> 원</td>
                </tr>
                <tr> 
                    <td class=title width="400">용품비-내비게이션</td>
                    <td> <input type="text" name="tint_n_amt" value='<%=bean.getTint_n_amt()%>' size="15" class=num> 원</td>
                </tr>
                <tr> 
                    <td class=title width="400">용품비-이동형충전기</td>
                    <td> <input type="text" name="tint_eb_amt" value='<%=bean.getTint_eb_amt()%>' size="15" class=num> 원</td>
                </tr>
                <tr> 
                    <td class=title width="400">용품비-블랙박스미제공 가감</td>
                    <td> <input type="text" name="tint_bn_amt" value='<%=bean.getTint_bn_amt()%>' size="15" class=num> 원</td>
                </tr>          
                <tr> 
                    <td class=title width="400">법률비용지원금</td>
                    <td> <input type="text" name="legal_amt" value='<%=bean.getLegal_amt()%>' size="15" class=num> 원</td> 
                </tr>                                                                             
            </table>
        </td>
    </tr>
        	        
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>