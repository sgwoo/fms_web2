<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"9":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//gubun_nm = java.net.URLDecoder.decode(gubun_nm);
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-125;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun_nm="+gubun_nm+"&gubun="+gubun+
				   	"&sh_height="+height+"";

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function AncReg(){
		var SUBWIN="./anc_se_i.jsp?ck_acar_id=<%=ck_acar_id%>&from_page=/fms2/off_anc/off_frame.jsp";	
		window.open(SUBWIN, "AncReg", "left=100, top=100, width=1024, height=750, scrollbars=no");
	}

	function AncDisp(bbs_id){
		var SUBWIN="./anc_se_c.jsp?ck_acar_id=<%=ck_acar_id%>&from_page=/fms2/off_anc/off_frame.jsp&bbs_id=" + bbs_id;	
		window.open(SUBWIN, "AncDisp", "left=10, top=10, width=1024, height=800, scrollbars=yes");
	}
//-->
</script>
</head>
<body>
<form action="" name="AncRegForm" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type="hidden" name="gubun"   value="<%=gubun%>">
	<input type="hidden" name="gubun1"  value="<%=gubun1%>">
	<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type="hidden" name="cmd" value="">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr> 
        <td colspan="2" align='right'> <a href='javascript:AncReg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
  <%}%>
    <tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class=line>
	        <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class='title' width='6%'>연번</td>
                  <td class='title' width='46%'>제목</td>
                  <td class='title' width='10%'>등록자</td>
                  <td class='title' width='10%'>부서</td>
                  <td class='title' width='11%'>&nbsp;등록일&nbsp;</td>
                  <td class='title' width='11%'>&nbsp;만료일&nbsp;</td>
                  <td class='title' width='6%'>&nbsp;&nbsp;댓글&nbsp;&nbsp;</td>		  
                </tr>
	  </table>
    <td width="17">&nbsp;</td>
  </tr>

  <tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="off_sc_in.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
 </tr>

 
</table>

</form>
</body>
</html>