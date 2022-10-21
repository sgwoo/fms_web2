<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%

String user_id  = request.getParameter("user_id")==null?"":request.getParameter("user_id");
//System.out.println(user_id);

MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function test(idx) {
		
		var open_link = "";
	
		if (idx == 0) {
			open_link = "https://fms3.amazoncar.co.kr/data/doc/" + encodeURIComponent("여신전문금융업법") + ".pdf";
		} else if (idx == 1) {
			open_link = "https://fms3.amazoncar.co.kr/data/doc/" + encodeURIComponent("조세특례제한법") + ".pdf";
		}
		
		window.open(open_link);
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 사규관리 > <span class=style5>거래 유형별 신용카드 결제 규정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
     
	<tr>
        <td colspan=2></td>
    </tr>
	<tr>
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래 유형별 신용카드 결제 규정 / 관련 법률</span></td>
        <td align=right>&nbsp;(2019-10-24, 2022-05-31 현재)</td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>  
    
    <tr>
        <td  colspan=2 class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title style=height:35 width=15%>구분</td>
                    <td class=title width=20%>신용카드거래 가능 여부</td>  
                    <td class=title width=20%>CMS약정할인액 환입대상 여부</td>
                    <td class=title>적요</td>                     
                </tr>
                <tr>
                	<td class=title>월 대여료</td>
                	<td style=height:35>가능</td>
                	<td>환입대상</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>초과운행 대여료</td>
                	<td style=height:35>가능</td>
                	<td>환입대상</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>개시대여료</td>
                	<td style=height:35>가능</td>
                	<td>환입대상</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>선납금</td>
                	<td style=height:35>가능</td>
                	<td>환입대상</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>면책금</td>
                	<td style=height:35>불가</td>
                	<td>대상 아님</td>
                	<td style="text-align:left;">&nbsp;상품거래 또는 용역의 대가가 아닙니다.</td>
				</tr>
				<tr>
                	<td class=title>보증금</td>
                	<td style=height:35>불가</td>
                	<td>대상 아님</td>
                	<td style="text-align:left;">&nbsp;조세특례제한법 및 여신전문금융업법 위반</td>
				</tr>
				<tr>
                	<td class=title>위약금</td>
                	<td style=height:35>불가</td>
                	<td>대상 아님</td>
                	<td style="text-align:left;">&nbsp;조세특례제한법 및 여신전문금융업법 위반</td>
				</tr>
                
            </table>
        </td>
    </tr>
    <tr>
        <td colspan=2></td>
    </tr>
	
    <tr>
    	<td>⊙ 상기 신용카드거래 가능 여부 구분은 조세특례제한법 및 여신전문금융업법 등에 근거하여 거래대금 결제수단으로 사용 가능 여부를 구분하였습니다.</td>
 	</tr>
	<tr>
        <td style="height:20;"></td>
    </tr>
    <tr>
    	<td>⊙ 고객이 상기 규정들에서 벗어난 요청을 한 경우라도 그 자리에서 단호하게 거부하지 말고 고객의 정황을 잘 살펴보고 총무팀장과 상의하여 대응하시기 바랍니다.</td>
 	</tr> 
	<tr>
        <td style="height:20;"></td>
    </tr>
	<tr>
    	<td>⊙ 고객이 거래대금을 신용카드로 결제를 요청하는 이유로는 카드사 리워드 포인트 등과 연말정산에서 신용카드소득공제로 활용할 목적이 대부분일 것입니다.<br>&nbsp;&nbsp;&nbsp;
    	         한편으로는 계약자의 신용 또는 재무상태에 문제가 발생했을 수 있다는 신호일 수도 있습니다. 따라서 고객과 상담하면서 주의 목적에도 주시하여 대응해야만 할 것입니다.
        </td>
 	</tr>
	<tr>
        <td style="height:20;"></td>
    </tr>
	<tr>
    	<td>⊙ 자동차 구입비용 및 자동차 리스료 및 대여료는 소득공제 제외대상입니다. 단, 중고차를 신용카드 등으로 구입한 경우 구입금액의 10%는 소득공제 <br>&nbsp;&nbsp;&nbsp; 대상에 포함됩니다  (법률근거 : 조세특례제한법 및 시행규칙 참조)</td>
 	</tr> 
	<tr>
        <td style="height:35;"></td>
    </tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp; 『<span class=style5>여신전문금융업법</span>』 <a href="https://fms3.amazoncar.co.kr/data/doc/여신전문금융업법.pdf" target=_blank><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;『<span class=style5>조세특례제한법 및 시행규칙</span>』 <a href="https://fms3.amazoncar.co.kr/data/doc/조세특례제한법.pdf" target=_blank><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>
		</td>
	</tr>
	<tr>
        <td style="height:35;"></td>
    </tr>
	<tr>
		<td>⊙ 관련법 PDF파일이 일부 브라우저에서 안 열릴수도 있습니다. <a href=https://helpx.adobe.com/kr/acrobat/kb/cant-view-pdf-web.html target=_blank>[어도비 사이트 문제해결]</a> 혹은 자료실-총무팀업무서식에 있는 [거래유형별신용카드결제규정 및 관련법규] 파일을 참고하세요.
		
		</td>
	</tr>	
	<%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	<!--  
	<tr>
        <td style="height:50;"></td>
    </tr>	
	<tr>
		<td>&nbsp;&nbsp;&nbsp; 『<span class=style5>여신전문금융업법</span>』 <img src=/acar/images/center/button_see.gif align=absmiddle border=0 style="cursor: pointer;" onclick="test(0);">&nbsp;&nbsp;&nbsp;&nbsp;『<span class=style5>조세특례제한법 및 시행규칙</span>』 <img src=/acar/images/center/button_see.gif align=absmiddle border=0 style="cursor: pointer;" onclick="test(1);">
		</td>
	</tr>
	-->
    <%}%>
</table>
</body>
</html>