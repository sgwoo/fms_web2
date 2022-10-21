<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.common.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='javascript'>
<!--
	function change_c_user(c_id){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		window.open("/acar/mng_client/cng_client_user.jsp?c_id="+c_id+"&auth_rw="+auth_rw, "�������LOGIN_ID����", "left=100, top=100, width=430, height=200");
	}
	
	function drop_c_user(client_id){
		if(confirm('�ش� ���� LOGIN ID�� �����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			fm.target='i_no';
			fm.page_mode.value='2';
			fm.action='/acar/mng_client/cng_user_u_a.jsp';
			fm.submit();
		}
	}
	
	function refresh(){
		var fm = document.form1;
		fm.action='/acar/mng_client/client_c.jsp';
		fm.target='d_content';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	ClientBean client = al_db.getClient(c_id);
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='page_mode' value=''>
</form>
<table border=0 cellspacing=0 cellpadding=0 width='800'>
  <tr> 
    <td colspan="2"> <font color="navy">�������� -> </font><font color="navy">�ŷ�ó 
      ���� -> </font><font color="red"> �ŷ�ó���� ��ȸ</font> </td>
  </tr>
  <tr> 
    <td> 
	  <font color="#999999">
        <%//if(!client.getReg_id().equals("")){%>
        �� ���ʵ���� : <%=c_db.getNameById(client.getReg_id(), "USER")%>&nbsp;&nbsp; �� ���ʵ���� : 
        <%=AddUtil.ChangeDate2(client.getReg_dt())%>
		&nbsp;&nbsp;
        <%//}%>
        <%//if(!client.getUpdate_id().equals("")){%>
        �� ���������� : <%=c_db.getNameById(client.getUpdate_id(), "USER")%>&nbsp;&nbsp; �� ���������� : 
        <%=AddUtil.ChangeDate2(client.getUpdate_dt())%>
        <%//}%>
        </font> 
    </td>
    <td align='right'>
      <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
      <a href='/acar/mng_client/client_u.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&c_id=<%=c_id%>'> 
      ����ȭ�� </a> 
      <%}%>
	</td>
  </tr>
  <tr> 
    <td colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding='0' width=800>
        <tr> 
          <td class='title' width='100'> ������</td>
          <td width='170'> &nbsp; 
            <%if(client.getClient_st().equals("1")){%>
            ���� 
            <%}else if(client.getClient_st().equals("2")){%>
            ���� 
            <%}else if(client.getClient_st().equals("3")){%>
            ���λ����(�Ϲݰ���) 
            <%}else if(client.getClient_st().equals("4")){%>
            ���λ����(���̰���) 
            <%}else if(client.getClient_st().equals("5")){%>
            ���λ����(�鼼�����) 
            <%}%>
          </td>
          <td width='0' class='title'>����ڵ�Ϲ�ȣ</td>
          <td>&nbsp;<%=client.getEnp_no1()%> 
            <%if(!client.getEnp_no1().equals("")){%>
            - 
            <%}%>
            <%=client.getEnp_no2()%> 
            <%if(!client.getEnp_no1().equals("")){%>
            - 
            <%}%>
            <%=client.getEnp_no3()%></td>
          <td class='title'>�������<br>
            (���ι�ȣ)</td>
          <td>&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%>
          </td>
        </tr>
        <tr> 
          <td width='100' class='title' >��ȣ</td>
          <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
          <td class='title' width="100">�̸�/��ǥ</td>
          <td width="160">&nbsp;<%=client.getClient_nm()%></td>
        </tr>
        <tr> 
          <td class='title'>������ȭ��ȣ</td>
          <td width="170">&nbsp;<%=client.getH_tel()%></td>
          <td class='title' width="0">ȸ����ȭ��ȣ</td>
          <td>&nbsp;<%=client.getO_tel()%></td>
          <td class='title'>�޴���</td>
          <td>&nbsp;<%=client.getM_tel()%></td>
        </tr>
        <tr> 
          <td class='title'>FAX</td>
          <td width="170">&nbsp;<%=client.getFax()%></td>
          <td class='title' width="0">Homepage</td>
          <td colspan='3'>&nbsp;<%=client.getHomepage()%></td>
        </tr>
        <tr> 
          <td class='title'>���������� �ּ�</td>
          <td colspan="5">&nbsp; 
            <%if(!client.getHo_addr().equals("")){%>
            ( 
            <%}%>
            <%=client.getHo_zip()%> 
            <%if(!client.getHo_addr().equals("")){%>
            ) 
            <%}%>
            <%=client.getHo_addr()%></td>
        </tr>
        <tr> 
          <td class='title'>����� �ּ�</td>
          <td colspan="5">&nbsp; 
            <%if(!client.getO_addr().equals("")){%>
            ( 
            <%}%>
            <%=client.getO_zip()%> 
            <%if(!client.getO_addr().equals("")){%>
            ) 
            <%}%>
            <%=client.getO_addr()%></td>
        </tr>
        <tr> 
          <td class='title'>����</td>
          <td width="170">&nbsp;<%=client.getBus_cdt()%></td>
          <td class='title'>����</td>
          <td colspan='3'>&nbsp;<%=client.getBus_itm()%></td>
        </tr>
        <tr> 
          <td class='title'>���������</td>
          <td width="170">&nbsp;<%= client.getOpen_year()%></td>
          <td class='title' width="0">�ں���/������</td>
          <td>&nbsp; 
            <%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+" �鸸�� / "+client.getFirm_day());%>
          </td>
          <td class='title'>������/������</td>
          <td>&nbsp; 
            <%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+" �鸸�� / "+client.getFirm_day_y());%>
          </td>
        </tr>        
      </table></td>
  </tr>
</table>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
