<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
function Tour1()
{
	
	var SUBWIN="/fms2/tour/tour_frame.jsp";	
	window.open(SUBWIN, "Tour1", "left=50, top=50, width=1150, height=700, scrollbars=yes");
}
function Tour2()
{
	
	var SUBWIN="/fms2/tour/tour_year_frame.jsp";	
	window.open(SUBWIN, "Tour2", "left=100, top=100, width=1000, height=600, scrollbars=yes");
}
//-->
</script>
</head>

<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 포상금지급규정 > <span class=style5>장기근속사원포상</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
		<td>&nbsp; <img src=/acar/images/center/arrow.gif> 2013-08-07 개정</td>
        <td align=right><img src=/acar/images/center/arrow.gif> <a href=co_regul_3.jsp>2017-11-15 개정</a>&nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> <a href=co_regul_3_2008.jsp>2013-08-07 이전</a>&nbsp;</td>
    </tr> 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line colspan=2>
            <table width="100%"  border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td colspan="2" class=title>선정방식</td>
                    <td><br>&nbsp;&nbsp;규정한 장기근속기간을 충족한 모든 사원<br><br></td>
                </tr>
                <tr>
                    <td width="5%" rowspan="3" class=title>규<br>정</td>
                    <td width="12%" class=title>근무기간</td>
                    <td><br>&nbsp;&nbsp;● 입사일자 기준 <font color=red>만5년</font>이 도래한 날<br>
                        &nbsp;&nbsp;● 입사일자 기준 <font color=red>만11년</font>이 도래한 날<br>
                        &nbsp;&nbsp;● 입사일자 기준 <font color=red>만18년</font>이 도래한 날, 이후 만7년주기로 포상<br><br>
                    </td>
                </tr>
                <tr>
                    <td class=title>포상금</td>
                    <td><br>&nbsp;&nbsp;● 만&nbsp;5년차 : <font color=red>150만원</font><br>
                        &nbsp;&nbsp;● 만11년차 : <font color=red>170만원</font><br>
                        &nbsp;&nbsp;● 만18년차 : <font color=red>200만원(18년차 이상은 동일)</font><br>
                        &nbsp;&nbsp;● 포상금(여행경비)은 부여된 전액을 법인카드로 사용해야 합니다. 사용(여행)후 잔액은 수상사 본인의 복지비사용 한도를 추가 부여하는 것으로 하고<br/> 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;현금지출 또는 법인카드 사용 후 잔액에 대한 현금정산(지급)은 하지 않습니다.(개정2013-08-07)<br><br>
                    </td>
                </tr>
                <tr>
                    <td class=title>휴가일수</td>
                    <td><br>&nbsp;&nbsp;● 년한에 관계없이 5일<br>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 유급휴가<br>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 년차외 별도로 처리<br>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 단,휴가기간내 국경일,임시공휴일,공휴일,토요휴무일 등은
                                휴가일수에 포함하며, 휴가기간을 1회로 한정 사용해야 하며 
                                잔여 휴가일수는 소멸함으로<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;나누어 사용할 수 없음.<br><br>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class=title>예외조항</td>
                    <td><br>&nbsp;&nbsp;년간(회계년도기준) 총 포상휴가 대상자가 전체 재직인원대비 20%를 초과할 
                         경우 초과인원은 휴가일정을 다음해로 지정할 수 있습니다.
                         지정방식은 입사<br>&nbsp;&nbsp;일자기준 우선배정하고 나머지 인원은 추첨하겠습니다.<br><br>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h colspan=2></td>
    </tr>
	<tr>
        <td class=h colspan=2></td>
    </tr>
	<tr>
		<td colspan=2><img src=/acar/images/center/arrow.gif> 관련메뉴 바로가기</td>
	</tr>
	<tr>
		<td colspan=2>1.장기근속 포상일정 <a href='javascript:Tour1()'><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
		<td colspan=2>2.년도별 장기근속자 <a href='javascript:Tour2()'><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a></td>
	</tr>
</table>
</body>
</html>