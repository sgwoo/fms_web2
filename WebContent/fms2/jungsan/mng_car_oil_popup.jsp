<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('������ �۾��մϱ�? �� �� �����ϴ�.'); return;}
		
		fm.work_st.value = work_st;
		fm.target = 'i_no';
		fm.action = 'mng_car_oil_popup_a.jsp';
		fm.submit();
		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int year =AddUtil.getDate2(1);
	
	String st_mon		= request.getParameter("st_mon")==null?"2":request.getParameter("st_mon");
	String mode		= request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	String o_year		 =request.getParameter("o_year")==null?"":request.getParameter("o_year"); //���������� �⵵
	String o_mon		= request.getParameter("o_mon")==null?"":request.getParameter("o_mon"); //���������� �б�
	
%>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<input type='hidden' name='o_year' value='<%=o_year%>'>
<input type='hidden' name='o_mon' value='<%=o_mon%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5> �ܱ������� ķ���ιݿ�</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td></td></tr>
	<tr><td class=line2></td></tr>
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td width='25%' class='title'>�ݿ� ����</td>
		  <td width="75%">
		   <select name="mode"  >
  	               <option value="1" <%if(mode.equals("1"))%>selected<%%>>ä��</option>
                        <option value="2" <%if(mode.equals("2"))%>selected<%%>>����</option>
                        <option value="5" <%if(mode.equals("5"))%>selected<%%>>���(1��-����)</option>
                        <option value="28" <%if(mode.equals("28"))%>selected<%%>>���(1��-���)</option>
                        <option value="29" <%if(mode.equals("29"))%>selected<%%>>���(2��)</option>
                        <option value="6" <%if(mode.equals("6"))%>selected<%%>>����</option>
	           </select>		
	     
              &nbsp;&nbsp;<select name="st_year">
                <%for(int i=2012; i<=year; i++){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>��</option>
                <%}%>
              </select>
       	    <select name="st_mon"  >
  	               <option value="1" <%if(st_mon.equals("1"))%>selected<%%>>1�б�</option>
                        <option value="2" <%if(st_mon.equals("2"))%>selected<%%>>2�б�</option>
                        <option value="3" <%if(st_mon.equals("3"))%>selected<%%>>3�б�</option>
	               <option value="4" <%if(st_mon.equals("4"))%>selected<%%>>4�б�</option>
	     </select>						
    		  </td>
		</tr>
	  </table>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>  
  <tr>
	<td align=right><a href="javascript:save('oil_jung')"><img src=/acar/images/center/button_jungs.gif align=absmiddle border=0></a>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
