<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String dest_gubun = request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");	
	String send_dt = request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_bus = request.getParameter("s_bus")==null?"":request.getParameter("s_bus");	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");	

	//LoginBean login = LoginBean.getInstance();
	//String user_id = login.getCookieValue(request, "acar_id");
	//if(s_bus.equals(""))	s_bus = user_id;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Vector resultList = umd.getSmsResult_V5(gubun, dest_gubun, send_dt, st_dt, end_dt, s_bus, sort, sort_gubun, c_db.getNameById(s_bus,"USER"));
	
	int sum1=0, sum2=0;
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
function open_list(msg, senddate){
	window.open("about:blank", "result_list", "left=100, top=110, width=740, height=650, scrollbars=no");	
	fm = document.form1;
	fm.msg.value = msg;
	fm.senddate.value = senddate;	
	fm.target = "result_list";
	fm.action = "./v5_result_list.jsp";
	fm.submit();
}
//-->
</script>
</head>
<body>
<form name="form1" method="post">
<input name="msg" type="hidden" value="">
<input name="senddate" type="hidden" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    <td class="line"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td width="4%" class="title">연번</td>
            <td width="12%" class="title">발신자</td>
            <td width="6%" class="title">총건수</td>
            <td width="7%" class="title">유효건수</td>
            <td width="6%" class="title">문자타입</td>
            <td width="46%" class="title">내용</td>
            <td width="19%" class="title">발신일자</td>
            </tr>
	
<%	if(resultList.size() !=0 ){
		for(int i=0; i< resultList.size(); i++){
			Hashtable ht = (Hashtable)resultList.elementAt(i);
			sum1 += AddUtil.parseInt((String)ht.get("CNT"));
			sum2 += AddUtil.parseInt((String)ht.get("R_CNT"));
%>
	  <tr>
		<td width="4%" align="center"><%= i+1 %></td>
		<td width="12%" align="center"><%= ht.get("SEND_NAME") %></td>
		<td width="6%" align="right"><a href="javascript:open_list('<%= ht.get("MSG_BODY") %>','<%= ht.get("SEND_TIME") %>');" onMouseOver="window.status=''; return true"><%= ht.get("CNT") %></a>&nbsp;</td>
		<td width="7%" align="right"><%= ht.get("R_CNT") %>&nbsp;</td>
		<td width="6%" align="center"><%if(String.valueOf(ht.get("MSG_TYPE")).equals("장문자")){%><font color=red><%}%><%= ht.get("MSG_TYPE") %><%if(String.valueOf(ht.get("MSG_TYPE")).equals("장문자")){%></font><%}%></td>		
		<td width="46%" align="left">&nbsp;<%= ht.get("MSG_BODY") %></td>
		<td width="19%" align="center"><%= AddUtil.ChangeDate3((String)ht.get("SEND_TIME")) %></td>
		</tr>
<% 		} %>
	  <tr>
		<td width="4%" class="title">&nbsp;</td>
		<td width="12%" class="title">합&nbsp;&nbsp;계</td>
		<td width="6%" class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum1) %></a>&nbsp;</td>
		<td width="7%" class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum2) %>&nbsp;</td>
		<td width="6%" class="title">&nbsp;</td>
		<td width="46%" class="title">&nbsp;</td>
		<td width="19%" class="title"></td>
		</tr>
<%	}else{ %>
	  <tr>
	    <td colspan="7" align="center">해당 데이터가 없습니다. </td>
	    </tr>
<% 	} %>		
    </table></td>
  </tr>
</table>
</form>
</body>
</html>