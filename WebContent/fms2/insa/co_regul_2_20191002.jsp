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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 복리후생관리 > <span class=style5>경조휴가/부조금규정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>2019년 10월 2일 이전</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td colspan=2 class=title style='height:38'>구분</td>
                    <td class=title>유급휴가</td>
                    <td class=title>부조금액<br>(근속1년이하/이상)</td>
                    <td class=title>비고</td>
                </tr>
                <tr>
                    <td width=10% rowspan=4 class=title>결혼</td>
                    <td width=22%>&nbsp;&nbsp;&nbsp;본인</td>
                    <td width=17% align=center>7일</td>
                    <td width=23% align=center>30만원/50만원</td>
                    <td width=23% rowspan=2 align=center>화환지급(3단)</td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;자녀</td>
                    <td align=center>2일</td>
                    <td align=center>20만원/30만원</td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;부모(본인)</td>
                    <td align=center>1일</td>
                    <td align=center>없음</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;형제(본인)</td>
                    <td align=center>2일</td>
                    <td align=center>없음</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td rowspan=6 class=title>사망</td>
                    <td>&nbsp;&nbsp;&nbsp;본인(재직중)</td>
                    <td align=center colspan=2>별도심의</td>
                    <td rowspan=6 align=center>조화지급(3단)</td>
                </tr>
                 <tr>
                    <td>&nbsp;&nbsp;&nbsp;배우자</td>
                    <td align=center>7일</td>
                    <td align=center>60만원/100만원</td>
                </tr>
                  <tr>
                    <td>&nbsp;&nbsp;&nbsp;부모/자녀</td>
                    <td align=center>5일</td>
                    <td align=center>50만원/100만원</td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;배우자부모</td>
                    <td align=center>5일</td>
                    <td align=center>40만원/60만원</td>
                </tr>              
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;조부모(본인의 친조부모)</td>
                    <td align=center>5일</td>
                    <td align=center>20만원/30만원</td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;형제(본인)</td>
                    <td align=center>5일</td>
                    <td align=center>20만원/30만원</td>
                </tr>
                <!--
                <tr>
                    <td class=title>회갑</td>
                    <td>&nbsp;&nbsp;&nbsp;부모</td>
                    <td align=center>1일</td>
                    <td align=center>10만원/20만원</td>
                    <td align=center style='height:44'>화환지급(3단)<br>단, 임직원 초대 행사 진행시에 해당</td>
                </tr>-->
                <tr>
                    <td class=title rowspan=2>출산</td>
                    <td>&nbsp;&nbsp;&nbsp;본인</td>
                    <td align=center>90일</td>
                    <td align=center>10만원</td>
                    <td align=center>&nbsp;</td>
                </tr>
                <tr>
                    <td style="height:40px;">&nbsp;&nbsp;&nbsp;배우자</td>
                    <td align=center>3일</td>
                    <td align=center>없음</td>
                    <td align=left>&nbsp;&nbsp;&nbsp;배우자는 3~5일의 출산 휴가를 사용할 수 있으며, <br>&nbsp;&nbsp;&nbsp;최초 3일은 유급입니다.</td>
                </tr>
                <tr>
                    <td class=title>돌</td>
                    <td>&nbsp;&nbsp;&nbsp;자녀</td>
                    <td align=center>없음</td>
                    <td align=center>10만원</td>
                    <td align=center>단, 임직원 초대 행사 진행시에 해당</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align=right><img src=/acar/images/center/arrow.gif> <a href=co_regul_2.jsp>현재</a> &nbsp;<img src=/acar/images/center/arrow.gif> <a href=co_regul_2_20140101.jsp>2014년 1월 1일 이전</a>&nbsp;<img src=/acar/images/center/arrow.gif> <a href=co_regul_2_20130905.jsp>2013년 9월 5일 이전</a> &nbsp;<img src=/acar/images/center/arrow.gif> <a href=co_regul_2_20100928.jsp>2010년 9월 28일 이전</a> &nbsp;<img src=/acar/images/center/arrow.gif> <a href=co_regul_2_20100226.jsp>2010년 2월 26일 이전</a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
        <td>&nbsp;&nbsp;※ 직계존비속/친형제를 제외한 부모의 형제, 방계혈족 등은 유급휴가 및 회사에서 지급하는 부조금이 없습니다.</td>
    </tr>
    <tr>
        <td> &nbsp;&nbsp;<font color=red>※ 유급휴가 기간내 주휴일, 국경일 등이 포함된 경우 유급휴가기간은 이를 모두 포함하여 산정합니다.</font><br><br></td>
    </tr>
    <tr>
        <td > &nbsp;&nbsp;<b>Ο 협력업체와의 규정 (2013-09-05)</b></td>
    </tr>
    <tr>
        <td style='line-height:18px;'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.	경조사에 대해 당사직원과 협력업체직원간에 굳이 확대하여 알리지 않는다.<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.  어떤 사정으로 알게 되더라도 다음과 같은 원칙하에 처리한다.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1) 경사의 경우 직원본인에 한해 참석할 경우에만 최소한의 부조를 한다.<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(불참 시 다른 직원을 통한 대리부조는 하지 않는 것으로 합니다.)<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) 조사의 경우 본인 및 본인의 부모(배우자부모제외)상에 한해 참석하는 
				경우에만 최소한의 부조를 한다.<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(역시 불참 시 다른 사람을 통한 대리부조는 하지 않습니다.)</td>
    </tr>   
</table>
</body>
</html>