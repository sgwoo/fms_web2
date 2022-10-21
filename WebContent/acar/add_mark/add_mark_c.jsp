<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int bbs_id = request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	a_bean = oad.getAncBean(bbs_id);
	
	count = oad.readChkAnc(bbs_id, acar_id);
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
function UpDisp()
{
	var theForm = document.AncDispForm;
	theForm.submit();
}
function AncClose()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body onLoad="javascript:self.focus()">
<center>
<table border="0" cellspacing="0" cellpadding="0" width=500>
	<tr>
		<td>
			<font color="navy">MASTER -> </font><font color="red">공지사항</font>
		</td>
	</tr>
	<tr>
		<td colspan='4' align='right'>
		<%	if(acar_id.equals(a_bean.getUser_id())){%>	
		 <a href="javascript:UpDisp()" onMouseOver="window.status=''; return true">수정화면</a> 
		<%	}%>
		<a href="javascript:AncClose()" onMouseOver="window.status=''; return true">닫기</a></td>
	</tr>
	<form action="./anc_u.jsp" name="AncDispForm" method="post">
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="0" width=500>
			
			<tr>
				<td class="title">작성자</td>
				<td align="center"><%=a_bean.getUser_nm()%></td>
				<td class="title">부서</td>
				<td align="center"><%=a_bean.getDept_nm()%></td>
				
			</tr>
			<tr>
				<td class="title" width="70">작성일</td>
				<td align="center" width="180"><%=a_bean.getReg_dt()%></td>
				<td class="title" width="70">만료일</td>
				<td align="center" width="180"><%=a_bean.getExp_dt()%></td>
			</tr>
			<tr>
				<td class="title">제목</td>
				<td colspan="3" align="center"><%=a_bean.getTitle()%></td>
			</tr>									
			<tr>
				<td class="title">내용</td>
				<td colspan="3" style="height:200" valign="top">
					<table border=0 cellspacing=0 cellpadding=5 width=430>
						<tr>
							<td width=430><textarea name="content" cols='68' rows='15'><%=a_bean.getContent()%></textarea></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<input type="hidden" name="user_id" value="<%=a_bean.getUser_id()%>">
		<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
		<input type="hidden" name="cmd" value="">
	</td>
	</tr>
	</form>		
</table>
</center>
</body>
</html>