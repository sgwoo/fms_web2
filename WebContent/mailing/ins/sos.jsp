<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*,  acar.util.*"%>
<%@ page import="acar.accid.*"%>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//����ȣ
	
	String firm_nm 	= request.getParameter("f_nm")==null? "":request.getParameter("f_nm");
	String u_nm 	= request.getParameter("u_nm")==null? "":request.getParameter("u_nm");
	String u_tel 	= request.getParameter("u_tel")==null? "":request.getParameter("u_tel");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>����⵿���� ���� �ȳ���</title>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type=text/css>
<!--
.style1 {color: #2e4168; font-weight: bold;}
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
            <!-- �� FMS�α��� ��ư -->
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
    <!-- ��¥ -->
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
                    <td width=250 align=right>&nbsp;</td>
                </tr> 
            </table>
    <!-- ��¥ -->
        </td>
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
                    <td align=center>
                        <table width=608 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/ins/images/sos_1.gif>
                            <tr>
                                <td height=92></td>
                            </tr>
                            <tr>
                                <td align=center>                
                                    <table width=510 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=18><span class=style1><%=cont.get("FIRM_NM")%></span> ����</td>
                                        </tr>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=18 class=style2>�ȳ��ϼ��� �Ƹ���ī�Դϴ�. </td>
                                        </tr>
                                        <tr>
                                            <td height=18 class=style2>����� ��� ������ ��������� ����⵿ ������ü��</td>
                                        </tr>
                                        <tr>
                                            <td height=18 class=style2><span class=style10>����Ÿ�ڵ�������</span>���� ����⵿���񽺸� �����ϰ� �ֽ��ϴ�.
                                        <tr>
                                            <td height=18 class=style2>�ñ��Ͻ� ������ �����ø� ����ڿ��� �����Ͻñ� �ٶ��ϴ�. </td>
                                        </tr>
                                        <tr>
                                            <td height=30 class=style2>* �����  | <%=cont.get("USER_NM")%> ( <%=cont.get("USER_M_TEL")%> ) </td>
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
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/sos.gif></td>
                </tr>
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
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
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
</body>
</html>