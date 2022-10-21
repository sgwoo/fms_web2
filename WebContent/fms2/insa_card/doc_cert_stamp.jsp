<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	//����� ���� ��ȸ
	Vector vt = ic_db.InsaCardUserList(user_id);
	int vt_size = vt.size();
	
	int seq =  ic_db.getSeq("1", Integer.toString(AddUtil.getDate2(1))); //�������� ����
			
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
<script language="JavaScript" type="text/JavaScript">
<!--
//�μ��ϱ�
	function go_print(){
		
		var fm = document.form1;
		
	//	alert("aaa");
		
		fm.action = "doc_cert_print.jsp";
	
		fm.target = "_blank";
	
		fm.submit();		
	}		
//-->
</script>	

</head>

<body onLoad="javascript:onprint();">
<form name="form1" method="POST">	
<input type="hidden" name="seq" value="<%=seq%>" >
<input type="hidden" name="user_id" value="<%=user_id%>" >

<div id="Layer1" style="position:absolute; left:475px; top:870px; width:109px; height:108px; z-index:1"><img src="/acar/images/stamp.png" width="109" height="108"></div>
<table width="700" border="0" cellspacing="2" cellpadding="0" >
<tr>
		<td height=70 align=right><a href=javascript:go_print();><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a></td>
	</tr>
</td>
	
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
								<TD width="250" class=style1>&nbsp;&nbsp;<%=ht.get("USER_NM")%></TD>
								<TD width="100" class=style1 align=center>�������</TD>
								<TD class=style2>&nbsp;&nbsp<%=ht.get("SSN1")%><!---<%//=ht.get("SSN3")%>--></TD>
				            </TR>
							<TR>
								<TD height="54" class=style3 align=center>�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
								<TD class=style3>&nbsp;&nbsp;<%=ht.get("DEPT_NM")%></TD>
								<TD class=style3 align=center>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</TD>
							    <TD class=style4>&nbsp;&nbsp;<%=ht.get("USER_POS")%></TD>
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
								<TD height="20" align="center" class=style5 colspan="2">(&nbsp; �� &nbsp;&nbsp; �� &nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<input type='text' name="r_name"   size='25'  style=' text-align:left; font-size : 12pt; background-color:#ffffff; border-color:#000000; border-width:1;' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								����� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</TD>
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
								<td width=300 align="right" STYLE="font-size:14.0pt;line-height:160%;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ȣ</td>
								<TD width=400 height="22" STYLE="font-size:14.0pt;line-height:160%;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��)�Ƹ���ī</TD>
							</TR>
							<tr>
								<td height="20"></td>
							</tr>
							<TR>
								<td align=right STYLE="font-size:14.0pt;line-height:160%;">�� &nbsp;ǥ &nbsp;��</td>
								<TD height="22" STYLE="font-size:14.0pt;line-height:160%;font-weight:bold;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								������ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</TD>
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
</form>
</body>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>

</html>

<script>
function onprint(){


}
</script>
