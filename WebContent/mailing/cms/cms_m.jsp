<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*,  acar.util.*, acar.common.*"%>

<%
	String client_id 	= request.getParameter("client_id")==null?"002316":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		//cont_view
	Hashtable base = c_db.getContViewCmsCase(client_id);
		
	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>CMS변경사항안내</title>
<link href=http://fms1.amazoncar.co.kr/mailing/style.css rel=stylesheet type=text/css>
<style type="text/css">
<!--
td {line-height:22px; font-size:13px;}
.style1 {font-size:14px;}
.style2 {color:#FF0000;}

-->
</style>

</head>
<body topmargin=0 leftmargin=0 >
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=http://fms1.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=http://fms1.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=http://fms1.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0 background="http://fms1.amazoncar.co.kr/mailing/images/cms_mod.jpg">
                <tr>
                    <td height=1000 align=center valign=top>
                    	<table width=520 border=0 cellspacing=0 cellpadding=0>
							<tr>
								<td height=160></td>
							</tr>
                    		<tr>
                    			<td class="style1" valign=top height=30> <b><%=String.valueOf(base.get("FIRM_NM"))%></b> 고객님</td>
                    		</tr>
                    		<tr>
                    			<td height=30>연체대여료 납부방법이 다음과 같이 변경되었음을 알려드립니다.</td>
                    		</tr>
                    		<tr>
                    			<td height=40><b>1.</b> 변경일자: 2017년 04월 01일</td>
                    		</tr>
                    		<tr>
                    			<td height=30><b>2.</b> 변경내용</td>
                    		</tr>
                    		<tr>
                    			<td>
                    				<table width=520 border=0 cellpadding=3 cellspacing=1 bgcolor=cacaca  align=center>
                    					<tr>
                    						<th height=40 bgcolor=f2f2f2 width=14%>이용대수</th>
                    						<th bgcolor=f2f2f2 width=43%>현행 (3월 31일 까지)</th>
                    						<th bgcolor=f2f2f2 width=43%><span class="style2 style1">변경 (4월 1일 이후)</span></th>
                    					</tr>
                    					<tr bgcolor=#FFFFFF align=center>
                    						<td height=85>1대</td>
                    						<td>다음 회차 대여료와 합산 청구 <br>및 CMS 납부<br>(단, 사전 협의 시 변경 가능)</td>
                    						<td>현행과 동일</td>
                    					</tr>
                    					<tr bgcolor=#FFFFFF align=center>
                    						<td height=85>1대 이상</td>
                    						<td>연체대여료 발생 사실 안내 후 <br>사후(해지 시) 정산</td>
                    						<td>다음 회차 대여료와 합산 청구 <br>및 CMS 납부 <br>(단, 사전 협의 시 변경 가능)</td>
                    					</tr>
                    				</table>
                    			</td>
                    		</tr>
                    		<tr>
                    			<td height=10></td>
                    		</tr>
                    		<tr>
                    			<td height=40><b>3.</b> 변경일(4월 1일) 이전에 발생한 연체대여료 납부 방법은 현행과 동일합니다.</td>
                    		</tr>
                    		<tr>
                    			<td height=50><b>4.</b> 변경 이후에도 현행 방식으로 납부하기를 원하시면, 다음 회차일(2017년  3월  00일) 이전까지 아래 담당자와 협의해 주시기 바랍니다.</td>
                    		</tr>
                    		<tr>
                    			<td height=120><b>5.</b> 위 내용은 고객님의 연체 연부와 상관없이 아마존카 상품을 이용하는 모든 고객에게 일괄적으로 발송하는 안내문입니다.
                    			       현재 이용중인 차량의 대여료 연체 여부 및 연체 금액 확인은 <b>고객용 FMS</b>(<a href="https://fms.amazoncar.co.kr/service/index.jsp" target="_blank">http://fms.amazoncar.co.kr/service/index.jsp</a>)에서 
                    			       직접 하실 수 있으며, 아래 담당자를 통해서 안내 받으실 수도 있습니다</td>
                    		</tr>
                    		<tr>
                    			<td height=50><span class="style1"><b>※ <%=String.valueOf(base.get("FIRM_NM"))%> 고객님의 담당자입니다.</b></span><br>
									&nbsp;&nbsp;&nbsp;&nbsp;<b>·</b> 성명 :  <b><%=String.valueOf(base.get("USER_NM"))%></b>  &nbsp;&nbsp;&nbsp;&nbsp; <b>·</b> 연락처 : <b><%=String.valueOf(base.get("USER_M_TEL"))%></b> 
								</td>
							</tr>
							<tr>
								<td  height=120>고객용 FMS에 접속하시면 메신저 및 문자 서비스(무료)를 이용해 아마존카 이용과 관련된 모든 업무를 편리하고 신속하게 
								처리할 수 있습니다(별도의 회원가입 절차 없음). <br>각 업무별(영업, 차량관리, 경리회계 등) 담당자와 실시간으로 업무를 
								진행 할 수 있고, <br>담당자 변경 등으로 인한 불편함도 줄어드니 적극 이용 바랍니다.</td>
							</tr>
						</table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
                    
    <tr>
        <td height=30 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <!--
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=http://fms1.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax@amazoncar.co.kr><span class=style14>수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span></td>
    </tr>
    <tr>
        <td height=20 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>-->
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=http://fms1.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=86><img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=http://fms1.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=http://fms1.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>