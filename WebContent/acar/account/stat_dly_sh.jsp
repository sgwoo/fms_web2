<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //���������
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		fm.submit()
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//�˻�1 ���÷���
	function change_gubun1(){
		var fm = document.form1;
		var gbn_idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		drop_gubun2();
		if((gbn_idx == 0) || (gbn_idx == 4))//��ü,��ü
		{
			add_gubun2(0, '0', '����');
			add_gubun2(1, '2', '�Ⱓ');
		}
		if((gbn_idx == 1))//����
		{
			add_gubun2(0, '0', '����');
		}
		else if((gbn_idx == 2) ||(gbn_idx == 3))//����,�̼�
		{
			add_gubun2(0, '3', '����+��ü');
			add_gubun2(1, '0', '����');
			add_gubun2(2, '1', '��ü');
			add_gubun2(3, '2', '�Ⱓ');
		}
		if((gbn_idx == 5))//�˻�
		{
			add_gubun2(0, '0', '�˻�');
		}
		if((gbn_idx == 6))//�˻�
		{
			add_gubun2(0, '2', '�뿩����Ȳ');
			add_gubun2(1, '0', '����ں�������Ȳ');				
			add_gubun2(2, '1', '����ں���ü��Ȳ');
		}
		change_gubun2();
	}
	
	function change_gubun2(){
		var fm = document.form1;
		var gbn = fm.gubun1.options[fm.gubun1.selectedIndex].value;
		var gbn_idx = fm.gubun2.options[fm.gubun2.selectedIndex].value;
		if(gbn == 6){
			if(gbn_idx == 2){
				td_blank.style.display 	= 'none';
				td_term.style.display 	= 'none';
				td_term2.style.display 	= '';
			}else{
				td_blank.style.display 	= '';
				td_term.style.display 	= 'none';
				td_term2.style.display 	= 'none';
			}
		}else{
			if(gbn_idx == 2){
				td_blank.style.display 	= 'none';
				td_term.style.display 	= '';
				td_term2.style.display 	= 'none';
			}else{
				td_blank.style.display 	= '';
				td_term.style.display 	= 'none';
				td_term2.style.display 	= 'none';
			}
		}
	}	
	
	function drop_gubun2(){
		var fm = document.form1;
		var len = fm.gubun2.length;
		for(var i = 0 ; i < len ; i++)
		{
			fm.gubun2.options[len-(i+1)] = null;
		}
	}
	
	function add_gubun2(idx, val, str){
		document.form1.gubun2[idx] = new Option(str, val);
	}	
	
	//���÷��� Ÿ��(�˻�)
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //���������
			td_input.style.display	= 'none';
			td_bus.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_bus.style.display	= 'none';
		}
	}	
//-->
</script>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String gubun1		= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String im_dt 		= request.getParameter("im_dt")==null?"":request.getParameter("im_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	Vector users = c_db.getUserList("", "", "BUS_EMP"); //��������� ����Ʈ
	int user_size = users.size();	
	Vector users2 = c_db.getUserList("", "", "MNG_EMP"); //��������� ����Ʈ
	int user_size2 = users2.size();	
%>
<form name='form1' action='fee_sc.jsp' target='c_body' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<!--
����1:��ü(0), ����(1), ����(2), �̼�(3), ��ü(4)
����2:����(0), ��ü(1), �Ⱓ(2), ����+��ü(3)
-->
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td>
			<font color="navy">������ -> </font><font color="red">�뿩�� ���� </font>
		</td>
	</tr>
	<tr>
		<td>			
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='310'> ��ȸ����: 
              <select name='gubun1' onChange='javascript:change_gubun1()'>
                <option value='0' <%if(gubun1.equals("0")){%>selected<%}%>>��ü</option>
                <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>����</option>
                <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>����</option>
                <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>�̼�</option>
                <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>��ü</option>
                <option value='5' <%if(gubun1.equals("5")){%>selected<%}%>>�˻�</option>
                <option value='6' <%if(gubun1.equals("6")){%>selected<%}%>>��Ȳ</option>
              </select>
              &nbsp; ����ȸ: 
              <select name='gubun2' onChange='javascript:change_gubun2()'>
              </select>
            </td>
            <td width='160' id='td_term' style='display:none' align="left"> 
              <input type='text' size='11' name='st_dt' class='text'>
              ~ 
              <input type='text' size='11' name='end_dt' class='text'>
            </td>
            <td width='160' id='td_term2' style='display:none' align="left"> 
              <input type='text' size='11' name='im_dt' class='text'>&nbsp;(��������)
            </td>
            <td width='160' id='td_blank' align="left">&nbsp;</td>
            <td align="left" width="140"> ����: 
              <select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
                <option value='0' <%if(s_kd.equals("0")){%> selected <%}%>>��ü</option>
                <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
                <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>����</option>
                <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>����ڵ�</option>
                <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>������ȣ</option>
                <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>���뿩��</option>
                <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>�������ڵ�</option>
                <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>��뺻����</option>
                <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>���������</option>
              </select>
              &nbsp;&nbsp; </td>
            <td id='td_input' width="90" <%if(s_kd.equals("8")){%> style='display:none'<%}%> align="left"> 
              <input type='text' name='t_wd' size='12' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
            </td>
            <td id='td_bus' width="90" <%if(!s_kd.equals("8")){%> style='display:none'<%}%> align="left"> 
              <select name='s_bus'>
                <option value="">������</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                <%		}
					}		%>
                <%	if(user_size2 > 0){
						for (int i = 0 ; i < user_size2 ; i++){
							Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
                <%		}
					}		%>
              </select>
            </td>
            <td align="left"><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/images/search.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
          </tr>
          <tr> 
            <td colspan='7' align='right'>��������: 
              <select name='sort_gubun' onChange='javascript:search()'>
                <option value='0' <%if(sort_gubun.equals("0")){%> selected <%}%>>�Աݿ�����</option>
                <option value='1' <%if(sort_gubun.equals("1")){%> selected <%}%>>��ȣ</option>
                <option value='2' <%if(sort_gubun.equals("2")){%> selected <%}%>>��������</option>
                <option value='3' <%if(sort_gubun.equals("3")){%> selected <%}%>>���뿩��</option>
                <option value='4' <%if(sort_gubun.equals("4")){%> selected <%}%>>��ü�ϼ�</option>
              </select>
              <input type='radio' name='asc' value='0' checked onClick='javascript:search()'>
              �������� 
              <input type='radio' name='asc' value='1' onClick='javascript:search()'>
              ��������&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
          </tr>
        </table>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
change_gubun1();
-->
</script>
</body>
</html>
