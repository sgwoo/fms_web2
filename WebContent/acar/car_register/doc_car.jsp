<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.master_car.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	
	String ch_cd 	= request.getParameter("ch_cd")==null?"":request.getParameter("ch_cd");
	
    out.println(ch_cd);
    
	ch_cd=AddUtil.substring(ch_cd, ch_cd.length() -1);
	
//	out.println(ch_cd);
	
	Vector vt = new Vector();
	
	Hashtable h_bean = new Hashtable(); 
	
	String car_no="";
	if (!ch_cd.equals("") ) {
                 
		 car_no =mc_db.getMasterCarNo(ch_cd);		 
		 //�ּ�
		   h_bean = mc_db.getMasterCarAddr(ch_cd );			
	}	 
		 
		
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>������ڵ�������������û��</title>

<STYLE>
<!--
* {line-height:130%; font-size:10.5pt; font-family:����; font-weight:bold;}


.style3 {font-size:10.5pt; border-left:solid #000000 1px;border-bottom:solid #000000 1px; border-right:0px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style5 {font-size:10.5pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style6 {font-size:10pt; border-left:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style7 {font-size:10pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}

.style1 {font-size:10.5pt; border-left:solid #000000 1px; padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style2 {font-size:10.5pt; border-right:solid #000000 0px;padding:1.4pt 1.4pt 1.4pt 1.4pt}


.f1{font-size:20pt; font-weight:bold; line-height:150%;}
.f2{font-size:15pt; line-height:150%;}
-->
</STYLE>	

</head>

<body>
<div id="Layer1" style="position:absolute; left:568px; top:540px; width:54px; height:41px; z-index:1"></div>
<table width="700" border="0" cellspacing="2" cellpadding="0" >
	<tr>
		<td>	
			<table width="700" border="0" cellspacing="1" cellpadding="0" bgcolor="#000000">
				<tr>
			        <td  bgcolor="#FFFFFF">
			        	<table width="700" border="0" cellspacing="1" cellpadding="0" bgcolor="#000000">
				            <tr bgcolor="#FFFFFF">
				                <td colspan=5>
				                	<table width=700 border=0 cellspacing=0 cellpadding=0 style='border-collapse:collapse;border:none;'>
				                		<tr>
				                			<td rowspan=2 width=600 align=center><span class=f1>������ڵ�������������û��</span></td>
				                			<td width=100 height="55" align=center class=style3>ó���Ⱓ</td>
										</tr>
										<tr>
					           				<td height="55" align=center class=style1>�� ��</td>
					           			</tr>
					           		</table>
					           	</td>
					     	</tr>			            
				            <tr bgcolor="#FFFFFF">
								<td width="50" align=center rowspan=2>��û��</td>
								<td width="170" align=center height=70>�� �� �� ( ������ ��� <br>��Ī �� ��ǥ�� ����)</td>
								<td width="160" align=left>&nbsp;&nbsp;(��) �Ƹ���ī</td>
								<td width="160" align=center >�� �ֹε�Ϲ�ȣ</td>
								<td width="160" align=left>&nbsp;&nbsp;115611-0019610</td>
				            </tr>
							<tr bgcolor="#FFFFFF">
								<td width="168" align=center height=65>���� ��</td>
								<td colspan=3 align=left>&nbsp;&nbsp;<%=h_bean.get("BR_ADDR")%></td>
							</tr>
							<tr bgcolor="#FFFFFF">
								<td align=center colspan=2 height=65>��� �� �� �� ��</td>
							    <td colspan=3 align=left>&nbsp;&nbsp;�ڵ��� �뿩��</td>
						    </tr>
							<tr bgcolor="#FFFFFF">
								<td align=center colspan=2 height=100>������������û���<br>�ڵ����ǵ�Ϲ�ȣ</td>
							    <td colspan="3" colspan=3 align=left>&nbsp;&nbsp;<%=car_no%>&nbsp;&nbsp;</td>
						    </tr>
			            	<tr bgcolor="#FFFFFF"  valign=top>
								<td align="center" colspan="5">
									<table width=650 border=0 cellspacing=0 cellpadding=15>
										<tr>
											<td><br>�����ڵ����������������Ģ �� 103����1���� ������ ���Ͽ� ������ڵ����� ���������� ��û�մϴ�.</td>
										</tr>
										<tr>
											<td align=center><%=AddUtil.getDate(1)%>�� <%=AddUtil.getDate(2)%>�� <%=AddUtil.getDate(3)%>��</td>
										</tr>
										<tr>
											<td align=right>��û��(��) �� �� �� ī (���� �Ǵ� ��)</td>
										</tr>
										<tr>
											<td height=300 align=center><span class=f2><%=h_bean.get("BR_NM")%>���� ����</span></td>
										</tr>
									</table>
								</td>
				    		</tr>
							<tr bgcolor="#FFFFFF">
								<td height="70" align="left" colspan="5">&nbsp;&nbsp;���񼭷� : �ڵ��������� �� 44���� ������ ���� �ڵ����˻�����ڰ� ������ �ڵ����ӽð˻�<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�հ������� 1��</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>

</html>

