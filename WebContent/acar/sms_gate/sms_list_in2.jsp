<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	

	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean[] ubList = umd.getUserSmsAll(br_id, dept_id, user_nm);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	//명단수 합계
	int sum = 0;

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="javascript">
	
</script>
</head>

<body>
<form name="form1" action="./send_list.jsp" method="post">
<input name="sendname" type="hidden" value="">
<input name="sendphone" type="hidden" value="">
<input name="msg" type="hidden" value="">
<input name="target_size" type="hidden" value="<%=ubList.length%>">
<input name="req_dt" type="hidden" value="">
<input name="req_dt_h" type="hidden" value="">
<input name="req_dt_s" type="hidden" value="">
<input name="msg_type" type="hidden" value="0">
<input name="gubun1" type="hidden" value="">
<input name="gubun2" type="hidden" value="">
<table width="580" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
	if(ubList.length>0){
		for(int i=0; i<ubList.length; i++){
			UsersBean ubBn = ubList[i];
			//String car_off_nm = (String)ht.get("CAR_OFF_NM");
			sum = i+1;
%>
		  <tr>
			<td width="30"  align="center"><input name="pr" type="checkbox" value="<%= i %>" checked></td>
			<td width="30"  align="center"><%= i+1 %></td>
			<td width="78"  align="center"><%= c_db.getNameById(ubBn.getBr_id(), "BRCH") %></td>
			<td width="123" align="center"><%= c_db.getNameById(ubBn.getDept_id(), "DEPT") %></td>
			<td width="83"  align="center"><%= ubBn.getUser_pos() %></td>
			<td width="113" align="center"><input name="destname" type="text" class="white" size="8" readonly="true" value="<%= ubBn.getUser_nm() %>"></td>
			<td width="115" align="center"><input name="destphone" type="text" class="white" size="14" readonly="true" value="<%= ubBn.getUser_m_tel() %>"></td>
			<input name="excel_msg" type="hidden" value="">
		  </tr>

<% 		}
	}else{ %>
      <tr>
        <td colspan="7"><div align="center">발송 대상자가 없습니다. </div></td>
        </tr>
<% 	} %>
      <tr>
        <td colspan="7" class="title">&nbsp;</td>
        </tr>
    </table></td>
  </tr>
</table>
</form>
</body>
</html>
<script language="javascript">
	parent.parent.form1.total.value = '<%= sum %>';
</script>
