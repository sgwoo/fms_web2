<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<html>
<head><title>FMS</title>
</head>
<body>
<%
	int flag = 0;
	String c_id = request.getParameter("c_id");

	ClientBean client = l_db.getClient(c_id);
	
	client.setClient_st(request.getParameter("s_cl_gbn"));	
	client.setClient_nm(request.getParameter("t_client_nm"));
	client.setFirm_nm(request.getParameter("t_firm_nm"));	    
	client.setSsn1(request.getParameter("t_ssn1"));
	client.setSsn2(request.getParameter("t_ssn2"));
	//개인사업자는 생년월일만
		if(client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {
			client.setSsn2	("");
		}
	client.setEnp_no1(request.getParameter("t_enp_no1"));
	client.setEnp_no2(request.getParameter("t_enp_no2"));
	client.setEnp_no3(request.getParameter("t_enp_no3"));
	client.setH_tel(request.getParameter("t_h_tel"));
	client.setO_tel(request.getParameter("t_o_tel"));
	client.setM_tel(request.getParameter("t_m_tel"));
	client.setHomepage(request.getParameter("t_homepage"));
	client.setFax(request.getParameter("t_fax"));
	client.setBus_cdt(request.getParameter("t_cdt"));
	client.setBus_itm(request.getParameter("t_itm"));	
	String zip[] = request.getParameterValues("t_zip");
	String addr[] = request.getParameterValues("t_addr");	
	client.setHo_addr(addr[0]);
	client.setHo_zip(zip[0]);
	client.setO_addr(addr[1]);
	client.setO_zip(zip[1]);
	//추가된 항목
	client.setFirm_price(request.getParameter("t_firm_price").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price")));	client.setFirm_price_y(request.getParameter("t_firm_price_y").equals("")?0:AddUtil.parseDigit2(request.getParameter("t_firm_price_y")));
	client.setOpen_year(request.getParameter("t_open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("t_open_year")));
	client.setFirm_day(request.getParameter("t_firm_day").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day")));
	client.setFirm_day_y(request.getParameter("t_firm_day_y").equals("")?"":AddUtil.ChangeString(request.getParameter("t_firm_day_y")));
	
	if(!al_db.updateClient(client))	flag += 1;
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>
<form name='form1' method='post' target='d_content' action='/acar/mng_client/client_s_frame.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
</form>
<script language='javascript'>

<%	if(flag == 0){%>

		alert('수정되었습니다');

<%	}else{%>

		alert('수정되지 않았습니다');

<%	}%>
		document.form1.submit();
</script>
</body>
</html>
