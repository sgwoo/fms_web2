<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	int  seq 		= request.getParameter("seq")==null?1:AddUtil.parseInt(request.getParameter("seq"));
	String r_name 		= request.getParameter("r_name")==null?"":request.getParameter("r_name");
		
	//����� ���� ��ȸ
	Vector vt = ic_db.InsaCardUserList(user_id);
	int vt_size = vt.size();
			
	 boolean  flag = ic_db.getUpdateSeq("1", Integer.toString(AddUtil.getDate2(1)),  seq  ); //�������� ���� getUpdateSeq
			
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>��������</title>

<STYLE>
<!--
* {line-height:130%; font-size:10.0pt; font-family:����;}


.style1 {font-size:10.5pt; border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style2 {font-size:10.5pt; border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style3 {font-size:10.5pt; border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style4 {font-size:10.5pt; border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style5 {font-size:10.5pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style6 {font-size:10pt; border-left:solid #000000 1px;border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style7 {font-size:10pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}

.f1{font-size:20pt; font-weight:bold; line-height:150%;}
.f2{font-size:10.5pt; line-height:150%;}
-->
</STYLE>


</head>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body onLoad="javascript:onprint();">
<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0" height=90>
				            <tr>
				                <td valign=top>
				                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
					                    <TR>
					                        <TD width="60" height="33" class=style3 style="font-size:10pt;" align=center>������ȣ</TD>
					                        <TD width="90" class=style6 align=center><%=AddUtil.getDate2(1)%>-<%=seq%></TD>
					                    </TR>
				                	</TABLE>
				                </td>
				            </tr>
				            <tr>
				                <td align=center valign=top><span class=f1>�� �� �� �� ��</td>
				           	</tr>	
				           	<tr>
				           		<td height=30></td>
				           	</tr>			            
			        	</table>
			        </td>
			    </tr>
<% for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);	 %>		    
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <TR>
								<TD width="100" height="54" class=style1 align=center>�� ��(�ѱ�)</TD>
								<TD width="250" class=style1 align=center>&nbsp;&nbsp;<%=ht.get("USER_NM")%></TD>
								<TD width="100" class=style1 align=center>�������</TD>
								<TD class=style2 align=center>&nbsp;&nbsp<%=ht.get("SSN1")%><!---<%=ht.get("SSN2")%>--></TD>
				            </TR>
							<TR>
								<TD height="54" class=style3 align=center>�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD class=style3 align=center>&nbsp;&nbsp;<%=ht.get("DEPT_NM")%></TD>
								<TD class=style3 align=center>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
							    <TD class=style4 align=center>&nbsp;&nbsp;<%=ht.get("USER_POS")%></TD>
						    </TR>
							<TR>
								<TD height="54" class=style3 align=center>��&nbsp;��&nbsp;��&nbsp;��</TD>
								<TD class=style3>&nbsp;&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> ���� �������</TD>
								<TD class=style3 align=center>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
								<TD class=style4>&nbsp;&nbsp;</TD>
						    </TR>
							<TR>
								<TD height="54" class=style3 align=center>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
							    <TD colspan="3" class=style4>&nbsp;&nbsp;<%=ht.get("ADDR")%> </TD>
						    </TR>
						</table>
					</td>
				</tr> 
<% }%>				
			    <tr>
			        <td align=center>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
			            	<TR>
								<TD height="180" align="center" class=style5 colspan="2">���� ���� �����ϰ� ������ ������.</TD>
				    		</TR>
							<TR>
								<TD height="20" align="center" class=style5 colspan="2">(&nbsp; �� &nbsp;&nbsp; �� &nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<%=r_name%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								����� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</TD>
							</TR>
							<tr>
								<td height="120" colspan="2"></td>
							</tr>
							<TR>
								<TD height="22" align=center class=style5 colspan="2"><%=AddUtil.getDate2(1)%> �� &nbsp;&nbsp;<%=AddUtil.getDate2(2)%> �� &nbsp;&nbsp;<%=AddUtil.getDate2(8)%> ��</td>
							</TR>
							<tr>
								<td height="120" colspan="2"></td>
							</tr>
							<TR>
								<td width=250 align="right" STYLE="font-size:14.0pt;line-height:160%;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ȣ</td>
								<TD width=450 height="22" STYLE="font-size:14.0pt;line-height:160%;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��)�Ƹ���ī</TD>
							</TR>
							<tr>
								<td height="20"></td>
							</tr>
							<TR>
								<td align=right STYLE="font-size:14.0pt;line-height:160%;">�� &nbsp;ǥ &nbsp;��</td>
								<TD height="22" STYLE="font-size:14.0pt;line-height:160%;font-weight:bold;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;������ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
							</TR>
						</table>
					</td>
			    </tr>
			    <tr>
			        <td height=60></td>
			    </tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>

<script>
function onprint(){

factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 12.0; //��������   
factory.printing.topMargin = 25.0; //��ܿ���    
factory.printing.rightMargin = 10.0; //��������
factory.printing.bottomMargin = 20.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
