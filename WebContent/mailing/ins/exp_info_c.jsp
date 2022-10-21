<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.insur.*"%>

<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	InsDatabase c_db = InsDatabase.getInstance();
	
	Vector client_vt = c_db.getIjwListmailing(client_id);		
	int client_vt_size = client_vt.size();		

%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>업무용 승용차 손비처리 기준 변경 안내(법인고객용)</title>
<script language='JavaScript' src='/include/common.js'></script>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type=text/css>
<!--
.style1 {color: #333333; font-weight: bold; font-size:12px;}
.style2 {color: #636262}
.style10 {color: #0441da}
.style11 {
	color: #ff00ff;
	font-weight: bold;


}
-->
</style>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>            
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif height=10></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_bg.gif>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_up.gif width=677 height=44></td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/exp_c_img_01.gif></td>
                </tr>
                <tr>
                	<td height=10></td>
                </tr>
                <tr>
                	<td align=center  >
                		<table width=570 border=0 cellpadding=0 cellspacing=1 bgcolor=#ccccc;>
                			<tr bgcolor=#ececec>
                				<th height=35 width=15% style="font-family:nanumgothic;font-size:12px;font-weight:bold;">기존 보험<br>만료일</th>
                				<th width=35% style="font-family:nanumgothic;font-size:12px;font-weight:bold;">차종</th>
                				<th width=25% style="font-family:nanumgothic;font-size:12px;font-weight:bold;">차량번호</th>
                				<th width=25% style="font-family:nanumgothic;font-size:12px;font-weight:bold;">임직원 전용보험<br>가입대상여부</th>
                			</tr>                			
                			<%														
							for(int k=0;k<client_vt_size;k++){
							
        							  Hashtable ht = (Hashtable)client_vt.elementAt(k);
        							          						  
 					%>
        						 <tr bgcolor=#ffffff>
        						 		<td height=40 align=center style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INS_EXP_DT")))%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;color: #a74073;"><b><%=ht.get("CAR_NO")%></b></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("COM_EMP_YN")%></td>
										 </tr>
										<% }%>
                		</table>
                	</td>
                </tr>
                <tr>
                	<td height=10></td>
                </tr>
                <tr>
                	<td><span style="font-family:nanumgothic;font-size:12px;padding-left:60px;">* 임직원 전용보험 가입대상여부가 X인 경우는 경차 또는 9인승이상 차량 또는 화물에 해당되기 때문에
                	</span><br> <span style="font-family:nanumgothic;font-size:12px;padding-left:70px;">가입할 필요가 없습니다.</span></td>
                </tr>
                <tr>
                	<td><span style="font-family:nanumgothic;font-size:12px;padding-left:60px;">* 비영리법인 등의 경우에는 임직원 전용 자동차 보험가입 필요여부를 각 법인의 상황을 고려하여 판단하여 
                	</span><br> <span style="font-family:nanumgothic;font-size:12px;padding-left:70px;">주시기 바랍니다.</span></td>
                </tr>
               	<tr>
                	<td height=10></td>
                </tr>
                <tr>
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/exp_c_img_02.gif></td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/sos_3.gif></td>
                </tr>
            </table> 
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=40>&nbsp;</td>
                    <td width=82><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=453><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>