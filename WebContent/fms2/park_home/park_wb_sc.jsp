<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cus0601.*"%>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");

	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	ServOffBean[] c61_soBns = c61_db.getServ_offList(s_kd, t_wd, sort_gubun, sort, "5");	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function view_detail_pop(off_id, off_nm) {
		window.open("park_wb_cont.jsp?off_id="+off_id, "사업장 현황", "left=100, top=120, width=1100, height=800, scrollbars=no");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
	<table border="0" cellspacing="0" cellpadding="0" width=100%>
	    <tr>
		    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사업장현황</span></td>
		</tr>
		<tr><td class=line2></td></tr>
	    <tr>
	        <td class="line" >
		        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	                <tr>
	                    <td width='5%' class='title'>연번</td>
	                    <td width='15%' class='title'>상호</td>
	                    <td width='10%' class='title'>대표자</td>
	                    <td width='10%' class='title'>사업자번호</td>
	                    <td width='10%' class='title'>업태</td>
	                    <td width='10%' class='title'>품목</td>
	                    <td width='10%' class='title'>전화번호</td>
	                    <td width='10%' class='title'>팩스번호</td>
	                    <td class='title'>주소</td>
	                </tr>
	                <%if(c61_soBns.length !=0 ) {%>
	                	<%for(int i=0; i< c61_soBns.length; i++) {
								c61_soBn = c61_soBns[i];
						%>
			                <tr>
			                	<td align="center"><%=i+1%></td>
			                	<td><span title='<%=c61_soBn.getOff_nm()%>'>&nbsp;<a href="javascript:view_detail_pop('<%=c61_soBn.getOff_id()%>','<%=c61_soBn.getOff_nm()%>')"><%=AddUtil.subData(c61_soBn.getOff_nm(),10)%></a></span></td>
			                	<td align="center"><span title="<%=c61_soBn.getOwn_nm()%>"><%=AddUtil.subData(c61_soBn.getOwn_nm(),3)%></span></td>
			                	<td align="center"><%=AddUtil.ChangeEnt_no(c61_soBn.getEnt_no())%></td>
			                	<td align="center"><span title="<%= c61_soBn.getOff_sta() %>"><%=AddUtil.subData(c61_soBn.getOff_sta(),5)%></span></td>
			                	<td align="center"><span title="<%= c61_soBn.getOff_item() %>"><%=AddUtil.subData(c61_soBn.getOff_item(),6)%></span></td>
			                	<td align="center"><%=c61_soBn.getOff_tel()%></td>
			                	<td align="center"><%=c61_soBn.getOff_fax()%></td>
			                	<td><span title="<%=c61_soBn.getOff_post()%> <%=c61_soBn.getOff_addr()%>">&nbsp;<%=c61_soBn.getOff_post()%>&nbsp;<%=AddUtil.subData(c61_soBn.getOff_addr(),20)%></span></td>
			                </tr>
			        	<%}%>
	                <%} else {%>
	                <tr>
	                	<td colspan="9" align="center">데이터가 없습니다.</td>
	                </tr>
	                <%}%>	
	            </table>
		    </td>
	    </tr>
	</table>
</form>
</body>
</html>
