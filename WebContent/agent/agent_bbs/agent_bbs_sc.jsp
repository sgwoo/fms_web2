<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<%@ include file="/agent/cookies.jsp" %>

<%
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"8":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-125;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun_nm="+gubun_nm+"&gubun="+gubun+
				   	"&sh_height="+height+"";

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--


	function AncDisp(bbs_id){
		var SUBWIN="./agent_c.jsp?ck_acar_id=<%=ck_acar_id%>&from_page=/agent/agent_bbs/agent_bbs_frame.jsp&bbs_id=" + bbs_id;	
		window.open(SUBWIN, "AncDisp", "left=10, top=10, width=1024, height=800, scrollbars=yes");
	}
//-->
</script>
</head>
<body>
<form action="" name="AncRegForm" method="POST">
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
    <!--
	<tr> 
        <td colspan="2" align='right'> <a href='javascript:AncReg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
    </td>
	-->
	<tr>
		<td class='h'></td>
	</tr>
  </tr>
    <tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class=line>
	        <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class='title' width='6%'>����</td>
                  <td class='title' width='46%'>����</td>
                  <td class='title' width='10%'>�����</td>
                  <td class='title' width='10%'>�μ�</td>
                  <td class='title' width='11%'>&nbsp;�����&nbsp;</td>
                  <td class='title' width='11%'>&nbsp;������&nbsp;</td>
                  <td class='title' width='6%'>&nbsp;&nbsp;���&nbsp;&nbsp;</td>		  
                </tr>
	  </table>
    <td width="17">&nbsp;</td>
  </tr>

  <tr>
		<td colspan="2">
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="agent_bbs_sc_in.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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