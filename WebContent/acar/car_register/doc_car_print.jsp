<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.master_car.*" %>	
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ������� �˻� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
		
	//��������
	Hashtable   h_bean = mc_db.getCarReqMaintInfo(c_id );		
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title> �ڵ��� �˻� ��û��</title>

<STYLE>
<!--
* {line-height:130%; font-size:10pt; font-family:����;}




.f1{font-size:20pt; font-weight:bold; line-height:150%;}
.f2{font-size:13pt; line-height:180%; font-weight:bold;}
.f3{font-size:8.5pt;}
.f4{font-size:11pt;}

.t1 table{border-top:1px solid #000000; border-bottom:1px solid #000000;}
.t1 table td{border-right:1px solid #000000;}
.t1 table td.n1{border-right:0px;}
.t1 table td.n1 table{border:0px;}
.t1 table td.n1 table td{border-right:0px;}

.t2 table{border-top:2px solid #000000; border-bottom:1px solid #000000;}
.t2 table td{border-left:1px solid #000000; border-bottom:1px solid #000000;}
.t2 table td.n1{border-left:0px;}

.t3 table {border:0px;}
.t3 table td {border:0px;}
.t3 table td.n1 {border-right:0px;}

.t4 {border:0px;}
-->
</STYLE>	

</head>

<body>
<div id="Layer1" style="position:absolute; left:588px; top:480px; width:54px; height:41px; z-index:1"></div>
<table width="750" border="0" cellspacing="2" cellpadding="0" >
	<tr>
		<td>	
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height=10 class="f3">[���� ��47ȣ����] <���� 2017. 2. 14.></td>
				</tr>
				<tr>
					<td align=center><span class=f1>�ڵ��� �˻� ��û��</span></td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
			        <td class="t1">
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <tr bgcolor="#eeeeee">
				                <td width=34% height=30 valign=top>&nbsp;������ȣ</td>
					           	<td width=33% valign=top>&nbsp;������</td>
					           	<td width=33% valign=top class=n1>&nbsp;ó���Ⱓ ���</td>
					     	</tr>	
					     </table>
					 </td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center rowspan=4 class="n1"><span class="f4">��û��</span></td>
								<td width="200" height=25>&nbsp;&nbsp;����(��Ī)</td>
								<td width="400" class="n1">&nbsp;&nbsp;(��) �Ƹ���ī</td>
							</tr>
							<tr>
								<td height=25>&nbsp;&nbsp;������϶Ǵ� ����� ��Ϲ�ȣ</td>
								<td class="n1">&nbsp;&nbsp;115611-0019610 (128-81-47957)</td>
				            </tr>
							<tr>
								<td height=25>&nbsp;&nbsp;�� ��</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("BR_ADDR")%></td>
							</tr>
							<tr>
								<td height=25>&nbsp;&nbsp;��ȭ��ȣ</td>
							    <td class="n1">&nbsp;&nbsp;02-392-4242</td>
						    </tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center rowspan=4 class="n1"><span class="f4">�ڵ���</span></td>
								<td width="200" height=25>&nbsp;&nbsp;����</td>
								<td width="400" class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_NM")%></td>
							</tr>
							<tr>
								<td height=25>&nbsp;&nbsp;����</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_FORM")%></td>
				            </tr>
							<tr>
								<td height=25>&nbsp;&nbsp;��Ϲ�ȣ</td>
								<td class="n1">&nbsp;&nbsp;<%=h_bean.get("CAR_NO")%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
					<td class="t2">
						<table width=700 border=0 cellspacing=0 cellpadding=0>		            
				            <tr>
								<td width="100" align=center class="n1"><span class="f4">�˻籸��</span></td>
								<td width="250" height=50>&nbsp;&nbsp;[ &nbsp; ] Ʃ�װ˻�&nbsp;&nbsp;[ �� ] �ӽð˻�</td>
								<td width="350" class=n1>&nbsp;&nbsp;[ &nbsp; ] �����˻�<br><div class="f3">&nbsp;&nbsp;(���� ó�� ����: [ ]ħ��  [ ]���  [ ]�������н� [ ] ��Ÿ)</div></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td>���ڵ����������� ��43����1��, ���� �� �����Ģ ��78��, ��79�� �� ��79����2�� ���� ���� ���� ��û�մϴ�.</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
				<!--	<td align=right><%=AddUtil.getDate(1)%>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(2)%>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate(3)%>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;</td> -->
					<td align=right>&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td align=center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��û�� &nbsp;&nbsp;&nbsp;(��)�Ƹ���ī</td>
				</tr>
					<td align=right><span class="f3">(���� �Ǵ� ��)</span> &nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td><span class=f2>&nbsp;�ڵ����˻������</span> ����</td>
				</tr>
				<tr>
					<td height=3 bgcolor="#000000"></td>
				</tr>
				<tr>
					<td height=20></td>
				</tr>
				<tr>
			        <td class="t2">
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <tr>
								<td colspan="2" class="n1" width=100>
									<p style="text-align: center;" class="n1" class="f3">÷�μ���<br></p>
								</td>
								<td width=100>
									<p style="text-align: center;" class="f3">������<br></p>
								</td>
							</tr>
							<tr>
								<td class="n1"  width=100>
									<p style="text-align: center;"  class="f3">Ʃ�װ˻�<br></p>
								</td>
								<td>
									<p class="f3"><br>&nbsp;1. �ڵ��������</p>
									<p class="f3">&nbsp;2. Ʃ�׽��μ�</p>
									<p class="f3">&nbsp;3. Ʃ�� ������ �ֿ��������ǥ</p>
									<p class="f3">&nbsp;4. Ʃ�� �������� �ڵ����ܰ���(�ܰ��� ������ �ִ� ��쿡�� �����մϴ�)</p>
									<p class="f3">&nbsp;5. Ʃ���Ϸ��� ��������ġ�� ���赵</p>
									<p class="f3"></p>
								</td>
								<td rowspan="3" scope="">
									<p class="f3"><br>&nbsp;�˻�����ڰ� ���� �ݾ�</p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
									<p class="������" style="line-height: 100%; margin-top: 1pt; -ms-layout-grid-mode: char;"><br></p>
								</td>
							</tr>
							<tr>
								<td class="n1" width=100>
									<p style="text-align: center;" class="f3">�ӽð˻�<br></p>
								</td>
								<td >
									<p class="f3"><br>&nbsp;1. �ڵ��������</p>
									<p class="f3">&nbsp;2. �ڵ������ˤ�������˻� �Ǵ� ���󺹱���ɼ�</p>
									<p class="f3"></p>
								</td>
							</tr>
							<tr>
								<td class="n1" width=100>
									<p style="text-align: center;" class="f3">�����˻�<br></p>
								</td>
								<td >
									<p class="f3"><br>&nbsp;1. �ڵ��������</p>
									<p class="f3">&nbsp;2. �ڵ���������ڰ� �߱��� ���� ��89ȣ��2������ ���ˤ��������(���� ó���� ������  <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ ���� ���ˤ���������� ���մϴ�)</p>
									<p class="f3">&nbsp;3. �ڵ��������� �����Ģ�� ��79����2��3ȣ�� ���� ����</p>
									<p class="f3">&nbsp;4. �ڵ����˻�����ڰ� ������ �䱸�ϴ� ���� �� ���� ����</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��. ����ȸ�簡 �߱��� ���� ó���� ���� Ȯ�μ�(�������, ������ �� ���� �Ǵ� �ļ���<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;�� ������ ��ġ�� ��Ī�� ����� ���� ���մϴ�)</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��. �پ���θ�Ʈ ���� ���</p>
									<p class="f3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��. �ջ�� ���� �Ǵ� ��ġ�� ���� ���� �� ����</p>
									<p class="f3"></p>
								</td>
							</tr>
					     </table>
					 </td>
				</tr>
				<tr>
					<td colspan="3" align="right" class="f3"><br>210����297��[�Ϲݿ��� 60g/��]</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>

</html>

