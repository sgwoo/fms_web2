<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	Vector cars = cod.getCarEmpEmail(t_wd);
	int car_size = cars.size();
		
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function Search(){
		var fm = document.form1;
		if(fm.t_wd.value==""){	alert("����������� �Է��� �ּ���!"); fm.t_wd.focus();	return; }
		fm.action =  'caremp_email.jsp';		
		//fm.target = 'i_no';	
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
		
	function modify(id)
	{
		if(confirm('�����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			fm.emp_id.value = id;
			fm.target='i_no';
			fm.action = 'caremp_email_a.jsp';
			fm.submit();
		}
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus()">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='emp_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ������Ȳ > ����� �̸��ϵ����Ȳ > <span class=style5>������� �̸��� �ּ� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_sm.gif align=absmiddle>&nbsp;
        <input name='t_wd' type='text' class='text' value="<%=t_wd%>" size='30' maxlength='20' onKeyDown="javascript:enter()" style='IME-MODE: active'> 
        <a href="javascript:Search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td align='right' class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='3%' rowspan="2" class='title'>����</td>
                    <td colspan="3"class='title'>�Ҽ�</td>
                    <td width="8%" rowspan="2" class='title'> ����</td>
                    <td width="5%" rowspan="2" class='title'>���<br>
                      ���</td>
                    <td width="12%" rowspan="2" class='title'>��ȭ��ȣ</td>
                    <td width="11%" rowspan="2" class='title'>�ڵ�����ȣ</td>
                    <td width="18%" rowspan="2" class='title'>�����ּ�</td>
                    <td width="4%" rowspan="2" class='title'>����<br>
                      �ź�</td>
                    <td width="7%" rowspan="2" class='title'>ó��</td>
                </tr>
                <tr> 
                    <td width="11%" height="26"class='title'>ȸ���</td>
                    <td width="9%"class='title'>�ҵ汸��</td>
                    <td width="12%"class='title'>����/�븮����</td>
                </tr>
          <%if(car_size > 0){
				for(int i = 0 ; i < car_size ; i++){
					Hashtable car = (Hashtable)cars.elementAt(i);%>
                <tr> 
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%= i+1 %></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=car.get("NM")%></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"> 
                      <%if(((String)car.get("CAR_OFF_ST")).equals("3")) out.print("��Ÿ���"); else out.print("���");%>
                    </td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=car.get("CAR_OFF_NM")%></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=car.get("EMP_NM")%></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=car.get("CNT")%></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=car.get("CAR_OFF_TEL")%></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=car.get("EMP_M_TEL")%></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type='text' size='25' name='emp_email' value='<%=car.get("EMP_EMAIL")%>' class='text'></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type="checkbox" name="use_yn" value="N" <% if(((String)car.get("USE_YN")).equals("N")) out.print("checked"); %>></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><a href="javascript:modify('<%=car.get("EMP_ID")%>')"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a></td>
                </tr>
          <%	}
			}else{%>
                <tr> 
                    <td colspan="11" align="center">�ش� ��������� �����ϴ�. </td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
