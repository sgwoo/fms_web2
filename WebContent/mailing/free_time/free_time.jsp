<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.attend.*"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	Hashtable ht = v_db.getVacation(user_id);
	
	Vector vt = v_db.getVacationList(user_id, (String)ht.get("YEAR"));
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�Ƹ���ī �̻�� ������ ����ȹ��</title>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type="text/css">
<!--
.style2 {color: #747474}
-->
</style>

<style type="text/css">
<!--
.style15 {
	font-size: x-large;
	font-weight: bold;
	font-family: "����", "�ü�", AppleMyungjo;
}
-->
</style>
<style type="text/css">
<!--
.style23 {font-size: 12px}
.style24 {font-size: 14px}
.style26 {font-size: 14pt}
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
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/free_time/images/logo.gif width=332 height=52 border=0></a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td ><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
		<td align="center" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
			<table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_bg.gif>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_up.gif width=677 height=44></td>
                </tr>
                <tr>
                    <td height=25></td>
                </tr>
                <!--
                <tr>
            		<td align="center">
            			<table width=650 border=0 cellspacing=0 cellpadding=0>
            				<tr>
            				    <td height="30" align=left><span class="style24">������ȣ : �λ�09-02-01 </span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">�������� : 2009�� 02�� 24�� </span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">�� &nbsp;&nbsp;&nbsp;&nbsp; �� : <%if(ht.get("DEPT_ID").equals("0001")){%>������<%}else if(ht.get("DEPT_ID").equals("0002")){%>��������<%}else if(ht.get("DEPT_ID").equals("0003")){%>�ѹ���<%}else if(ht.get("DEPT_ID").equals("0007")){%>�λ�����<%}else if(ht.get("DEPT_ID").equals("0008")){%>��������<%}%> - <%=ht.get("USER_NM")%></span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">�� &nbsp;&nbsp;&nbsp;&nbsp; �� : <%if(ht.get("DEPT_ID").equals("0001")){%>��ä�� �����<%}else if(ht.get("DEPT_ID").equals("0002")){%>��¹� �����<%}else if(ht.get("DEPT_ID").equals("0003")){%>�Ⱥ��� �����<%}else if(ht.get("DEPT_ID").equals("0007")){%>������ �������<%}else if(ht.get("DEPT_ID").equals("0008")){%>�ڿ��� �������<%}%></span></td>
            				</tr>
            				<tr>
            				    <td height="30" align=left><span class="style24">�� &nbsp;&nbsp;&nbsp;&nbsp; �� : �̻�� ������ ����ȹ�� ����(��û) </span></td>
            				</tr>
            			</table>
            		</td>
                </tr>-->
                <tr>
            		<td align="center">
            			<table width=608 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/free_time/images/img_bg.gif>
            				<tr>
            				    <td height=90></td>
            				</tr>
            				<tr>
            				    <td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><font color=979797><%=ht.get("USER_NM")%> ��</font></b></td>
            				</tr>
            				<tr>
            					<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ ��� ������ ������ �帳�ϴ�.</td>
            		        </tr>
            		        <tr>
            		    		<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Ʒ��� ���� ������ �̻�� ������Ȳ�� �뺸�Ͽ���</td>
            		        </tr>
            		        <tr>
            		    		<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=a80331><b>����(<%= AddUtil.getDate3((String)ht.get("END_DT"))%>)</b></font>�� ����ȹ���� �ۼ��ϰ� �μ�����</td>
            		    	</tr>
            		    	<tr>
            		    		<td height=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����Ͽ� �ѹ��� �λ����ڿ��� ������ �ֽñ� �ٶ��ϴ�.</td>
            				</tr>
            		        <tr>
                                <td height=30></td>
                            </tr>
            			</table>
            		</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <img src=https://fms5.amazoncar.co.kr/mailing/free_time/images/bar.gif></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
            		<td align="center">
            			<table width=520 border=0 cellspacing=1 cellpadding=0 bgcolor=cacaca>
            		        <tr>
            			        <td colspan="3" bgcolor=f2f2f2 height=27 align=center>������Ȳ </td>
            			        <td colspan="3" bgcolor=f2f2f2 align=center>�̻�뿬���Ҹ��� </td>
            			        <td rowspan="3" width="108" bgcolor=ecf9fb align=center>��ȿ������<br>����� �̻��<br>������ ó�� </td>
            		        </tr>
            		        <tr>
            			        <td width=14% rowspan="2" bgcolor=f9f9f9 height=27 align=center>�����ϼ� </td>
            				    <td width=13% rowspan="2" bgcolor=f9f9f9 align=center>��� </td>
            			        <td width=13% rowspan="2" bgcolor=f9f9f9 align=center>�̻�� </td>
            				    <td width=14% rowspan="2" bgcolor=f9f9f9 align=center>����� </td>
            				    <td colspan="2" bgcolor=f9f9f9 align=center height=27>�����Ⱓ </td>
            			    </tr>
            			    <tr>
            			        <td width=13% bgcolor=f9f9f9 height=27 align=center>����</td>
            				    <td width=13% bgcolor=f9f9f9 align=center> �� </td>
            			    </tr>
            			    <tr>
            				    <td align="center" bgcolor=FFFFFF height=100><%= ht.get("VACATION") %></td>
            				    <td align="center" bgcolor=FFFFFF><%= ht.get("SU") %></td>
            				    <td align="center" bgcolor=FFFFFF><font color=a80331><b><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU")) %></b></font></td>
            				    <td align="center" bgcolor=FFFFFF><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></td>
            				    <td align="center" bgcolor=FFFFFF><%= ht.get("RE_MONTH") %></td>
            				    <td align="center" bgcolor=FFFFFF><%= ht.get("RE_DAY") %></td>
            				    <td align="center" bgcolor=FFFFFF>��������<br>��������<br>�ƴ��ϰ�<br>�Ҹ���</td>
            		        </tr>
            		    </table>
            	    </td>
                </tr>
                <tr>
                    <td height=30 align=center></td>
                </tr>
                <tr>
                    <td  align=center><a href=#><img src=https://fms5.amazoncar.co.kr/mailing/free_time/images/button_down.gif border=0></a></td>
                </tr>
                <tr>
                    <td height=40></td>
                </tr>
                <tr>
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/ser_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=20 colspan="3" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td height=20 colspan="3" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td colspan="3" align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
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
        <td ><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>