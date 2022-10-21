<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*,  acar.util.*"%>
<%@ page import="acar.accid.*"%>

<%
	String m_id 	= request.getParameter("m_id")==null?"002316":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S105YNCL00040":request.getParameter("l_cd");

	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//차량관리번호
	
	String firm_nm 	= request.getParameter("f_nm")==null? "":request.getParameter("f_nm");
	String u_nm 	= request.getParameter("u_nm")==null? "":request.getParameter("u_nm");
	String u_tel 	= request.getParameter("u_tel")==null? "":request.getParameter("u_tel");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>자동차 정기검사 안내</title>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type=text/css>
<!--
.style1 {color: #a11919; font-weight: bold;}
.style2 {color: #636262}
.style10 {color: #0441da;
		font-weight: bold;}
.style11 {
	color: #ff00ff;
	font-weight: bold;
}

-->

</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function ImEmail_Reg(){
		var fm = document.form1;	
		if(confirm('메일발송을 하시겠습니까? \n\n[확인:발행] / [취소:미발행] '))
		{
			fm.m_id.value = "<%=m_id%>";
			fm.l_cd.value = "<%=l_cd%>";
			fm.target = "i_no";
			fm.action = "insp_email_a.jsp";
			fm.submit();						
		}
}

-->
</script>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:ImEmail_Reg()">
<form action="" name="form1" method="POST" >
<input type='hidden' name='m_id' value='<%=m_id%>'> 
<input type='hidden' name='l_cd' value='<%=l_cd%>'> 
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            <!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
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
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
    <!-- 날짜 -->
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
                    <td width=250 align=right>&nbsp;</td>
                </tr> 
            </table>
    <!-- 날짜 -->
        </td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_bg.gif>
                <tr>
                    <td align=center>
                        <table width=677 border=0 cellspacing=0  height=298 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_img1.gif>
                   			<tr>
                   				<td height=160></td>
                   			</tr>
                   			<tr>
                   				<td align=center>
	                   				<table width=500 border=0 cellspacing=0 cellpadding=0>
			                   			<tr>
			                   				<td height=18><span class=style2><span class=style1><%=cont.get("FIRM_NM")%></span> 고객님</span></td>
			                       		</tr>
			                        	<tr>
			                           		<td height=5></td>
			                     		</tr>
			                          	<tr>
			                          		<td height=18 class=style2>안녕하세요 아마존카입니다. </td>
			                      		</tr>
			                       		<tr>
			                           		<td height=18 class=style2>고객님 자동차의 정기검사일이 도래하여 안내문을 보내드리며,</td>
			                      		</tr>
			                       		<tr>
			                       		<td height=18 class=style2> 검사와 관련된 궁금하신 사항이 있으시면 담당자에게  문의</td>
			                       		</tr>
			                       		<tr>
			                       		<td height=18 class=style2>해주시길 바랍니다. </td>
			                       		</tr>
			                        	<tr>
			                         		<td height=30 class=style2>* 담당자  | <%=cont.get("USER_NM")%> ( <%=cont.get("USER_M_TEL")%> ) </td>
			                        	</tr> 
			                        </table>
		                      	</td>
		                     </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                	<td align=center>
                		<table width=497 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_imgbg.gif>
                			<tr>
                				<td><img src=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_imgup.gif></td>
                			</tr>
                			<tr>
                				<td height=20></td>
                			</tr>
                			<tr>
                				<td align=center>
                					<table width=400 border=0 cellspacing=0 cellpadding=0>
                						<tr>
                							<td height=24><span class=style2><img src=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_arrow.gif> 차량번호 </span></td>
                							<td><span class=style2><%=cont.get("CAR_NO")%></span></td>
                						</tr>
                						<tr>
                							<td height=24><span class=style2><img src=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_arrow.gif> 차 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;종</span></td>
                							<td><span class=style2><%=cont.get("CAR_NM")%></span></td>
                						</tr>
                						<tr>
                							<td height=24><span class=style2><img src=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_arrow.gif> 검사유효기간</span></td>
                							<td><span class=style10><%=AddUtil.getDate3(String.valueOf(cont.get("MAINT_ST_DT")))%> ~ <%=AddUtil.getDate3(String.valueOf(cont.get("MAINT_END_DT")))%></span></td>
                						</tr>
                					</table>
                				</td>
                			</tr>
                			<tr>
                				<td height=15></td>
                			</tr>
                			<tr>
                				<td><img src=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_imgdw.gif></td>
                			</tr>
                		</table>
                	</td>
                </tr>
                <tr>
                	<td height=50></td>
        		</tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/ser/images/ins_img2.gif></td>
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
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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
</form>
</body>
</html>