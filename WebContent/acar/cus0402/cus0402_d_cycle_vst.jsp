<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus0402.*" %>
<jsp:useBean id="c42_cvBn" class="acar.cus0402.Cycle_vstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");

	Cus0402_Database c42_db = Cus0402_Database.getInstance();	
	Cycle_vstBean[] cvBns = c42_db.getCycle_vstList(client_id);
	
	LoginBean login = LoginBean.getInstance();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>순회방문리스트</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function Cycle_vstDisp(client_id,seq){
		var SUBWIN="./cus0402_d_sc_clienthis_reg.jsp?client_id="+client_id+"&seq="+seq;
		window.open(SUBWIN, "Cycle_vst", "left=100, top=110, width=470, height=450, scrollbars=no");
	}
	function Cycle_vstDel(client_id,seq){
		if(!confirm('해당 방문건을 삭제하시겠습니까?')){ return; }
		var fm = document.form1;
		fm.action = "./cus0402_d_sc_Cycle_vstDel.jsp?client_id="+client_id+"&seq="+seq;
		fm.target = "i_no";
		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line"><table border="0" cellspacing="1" cellpadding="0" width="100%">
          <%for(int i=0; i<cvBns.length; i++){
				c42_cvBn = cvBns[i];%>
          <tr> 
            <td width=5% align=center><%= i+1 %></td>
            <td width=12% align=center><%=AddUtil.ChangeDate2(c42_cvBn.getVst_dt())%></td>
            <td width=8% align=center><%= login.getAcarName(c42_cvBn.getVisiter()) %></td>
            <td width=18% align=left>&nbsp;&nbsp;<a href="javascript:Cycle_vstDisp('<%=c42_cvBn.getClient_id()%>','<%=c42_cvBn.getSeq()%>')"><%=c42_cvBn.getVst_title()%></a></td>
            <td width=33% align="left">&nbsp;&nbsp;<span title="<%=c42_cvBn.getVst_cont()%>"><%=Util.subData(c42_cvBn.getVst_cont(),20)%></span></td>
            <td width=14% align=center><%=AddUtil.ChangeDate2(c42_cvBn.getVst_est_dt())%></td>
            <td width=10% align=center>
			<% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			<a href="javascript:Cycle_vstDel('<%=c42_cvBn.getClient_id()%>','<%=c42_cvBn.getSeq()%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
			<%}%>
			</td>
          </tr>
          <%}%>
          <% if(cvBns.length == 0) { %>
          <tr> 
            <td align=center height=25 colspan="8">등록된 데이타가 없습니다.</td>
          </tr>
          <%}%>
        </table></td>
  </tr>
</table>
</form>
</body>
</html>
