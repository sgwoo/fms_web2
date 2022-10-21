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
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 사규관리 > <span class=style5>성과급 지급 규정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>성과급 지급 규정</span></td>
        <td align=right>&nbsp;</td>
    </tr>
    <tr>
        <td class=line align=center colspan=2>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td align=center>
                        <table width=95% border=0 cellspacing=0 cellpadding=0>
                            <tr>    
                                <td></td>
                            </tr>
                            <tr>
                                <td>1. 지급일자: 전년도 영업성과 지표가 정리되고 외부회계감사 수검 준비가 완료된 직후</td>
							</tr>
							<tr><td></td></tr>
							<tr>
								<td>2. 지급기준 금액 산출 방법: = {(매출신장률 ÷ 5) + 세전 이익률}× 10</td>
							</tr>
							<tr><td></td></tr>
							<tr>
								<td>3. 지급대상 / 기준</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1) 지급일 현재 재직자 중 근무 중인 자</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) 1년 이상 재직자: 지급기준 금액의 전액</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3) 1년 미만 재직자: 일할계산(지급기준 금액 × 재직일수 ÷ 365)</td>
							</tr>
							<tr>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4) 휴직자: 지급대상이 아님</td>
							</tr>
							<tr>
							<tr>
								<td></td>
							</tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>