<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%
	String m_id =  request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd =  request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_start_dt =  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt =  request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	String cls_dt =  request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	Hashtable base = as_db.getSettleBase(m_id, l_cd, AddUtil.replace(cls_dt,"-",""), "");
	
	int  r_day = AddUtil.parseInt( (String)base.get("R_DAY") ); //2월달 계약인 경우 일수 계산시 문제 : 28일이 1달  30일이 1달???	
%>
	t_fm = parent.form1;
	t_fm.r_mon.value		= '<%=base.get("R_MON")%>';
<% if (r_day < 0 ) { %> 
	t_fm.r_day.value 		= '<%=base.get("S_DAY")%>';
<% } else  { %>
	t_fm.r_day.value 		= '<%=base.get("R_DAY")%>';
<% } %>
	
	<%if(from_page.equals("")){%>
	
	t_fm.ex_di_amt.value 	= '<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT2")))%>';
	t_fm.ex_di_v_amt.value 	= '<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_V_AMT"))+AddUtil.parseInt((String)base.get("DI_V_AMT2")))%>';
	t_fm.nfee_mon.value		= '<%=base.get("S_MON")%>';
	t_fm.nfee_day.value		= '<%=base.get("S_DAY")%>';	
	t_fm.nfee_amt.value 	= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>';
	t_fm.dly_amt.value 		= '<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>';
	//t_fm.hs_mon.value		= '<%=base.get("HS_MON")%>';
	//t_fm.hs_day.value		= '<%=base.get("HS_DAY")%>';	

	if(t_fm.r_day.value != '0'){
		t_fm.rcon_mon.value 		= toInt(t_fm.con_mon.value) - toInt(t_fm.r_mon.value) - 1;
		t_fm.rcon_day.value 		= 30-toInt(t_fm.r_day.value);
	}else{
		t_fm.rcon_mon.value 		= toInt(t_fm.con_mon.value) - toInt(t_fm.r_mon.value);
	}	
		
	parent.set_init();	

	<%}%>
</script>
</body>
</html>
