<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search()
	{
		document.form1.submit();
	}
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//�ܾ�/��¥�˻� ���ο� ���� �Է� ����
	function set_input()
	{
		var fm = document.form1;
		var kd = fm.s_kd.options[fm.s_kd.selectedIndex].value;
		if((kd == '4') || (kd == '5') || (kd == '6')){
			td_text.style.display = 'none';
			td_term.style.display = 'block';
		}else{
			td_text.style.display = 'block';
			td_term.style.display = 'none';
		}
	}
		
	//���ؾ� ���ý� �ؾ籸�� ��ü�� ����Ʈ��
	function set_cls_st()
	{
		var fm = document.form1;
		if(fm.r_cls[1].checked == true) 
			fm.s_cls_st.options[0].selected = true;
	}
-->
</script>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"R/W":request.getParameter("auth_rw");
	String r_cls = request.getParameter("r_cls")==null?"0":request.getParameter("r_cls");
	String s_cls_st = request.getParameter("s_cls_st")==null?"0":request.getParameter("s_cls_st");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String t_st_dt = request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");	
	String t_end_dt = request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");	
%>
<form name='form1' method='post' target='c_body' action='./cls_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td>
			<font color="navy">������ -> </font><font color="red">�ߵ��������� </font>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td width='400' colspan='2' align='left'>
						�ؾ�:
						<input type='radio' name='r_cls' value='0' <%if(r_cls.equals("0")){%>checked<%}%> onClick='javascript:set_cls_st()'>�ؾ�
						<input type='radio' name='r_cls' value='1' <%if(r_cls.equals("1")){%>checked<%}%> onClick='javascript:set_cls_st()'>���ؾ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						�ؾ౸��:
						<select name='s_cls_st'>
							<option value='0' <%if(s_cls_st.equals("0")){%>selected<%}%>>��ü	</option>
							<option value='1' <%if(s_cls_st.equals("1")){%>selected<%}%>>��������� 	</option>
							<option value='2' <%if(s_cls_st.equals("2")){%>selected<%}%>>�ߵ����� 		</option>
							<option value='3' <%if(s_cls_st.equals("3")){%>selected<%}%>>������������� </option>
							<option value='4' <%if(s_cls_st.equals("4")){%>selected<%}%>>������������� </option>
							<option value='5' <%if(s_cls_st.equals("5")){%>selected<%}%>>�����Һ��� 	</option>
						</select>
					</td>
				</tr>
				<tr>
					<td width='180' align='left'>
						��Ÿ�˻�����:
						<select name='s_kd' onChange='javascript:set_input()'>
							<option value='0' <%if(s_kd.equals("0")){%>selected<%}%>>��ü</option>
							<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ	</option>
							<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�����	</option>
							<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
							<option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>����� </option>
							<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�뿩������ </option>
							<option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>�ؾ��� </option>
							<option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>��������� </option>
							<option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>����ȣ </option>
							<option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>������	</option>
							
<!--	���� : ������� -->
						</select>
					</td>
					<td width='620' id='td_text' align='left'>
						<input type='text' name='t_wd' size='15' class='text' onKeyDown='javascript:enter()'>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true">�˻�</a>
					</td>
					<td width='620' id='td_term' style='display:none' align='left'>
						<input type='text' name='t_st_dt' size='8' class='text'>~
						<input type='text' name='t_end_dt' size='8' class='text' onKeyDown='javascript:enter()'>&nbsp;&nbsp;
						<a href='javascript:search()' onMouseOver="window.status=''; return true">�˻�</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>