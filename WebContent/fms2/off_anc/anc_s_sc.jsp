<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-125;//��Ȳ ���μ���ŭ ���� ���������� ������
	
		
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun_nm="+gubun_nm+"&gubun="+gubun+
				   	"&sh_height="+height+"&ck_acar_id="+ck_acar_id+"";				
				
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function AncReg(){
		var SUBWIN="./anc_se_i.jsp?ck_acar_id=<%=ck_acar_id%>";	
		window.open(SUBWIN, "AncReg", "left=100, top=100, width=650, height=750, scrollbars=yes");
	}

	function AncDisp(bbs_id,st){
		if(st == '5'){
			var SUBWIN="./anc_c2.jsp?bbs_id=" + bbs_id+"&bbs_st="+st+"&ck_acar_id=<%=ck_acar_id%>";	
		}else{

			var SUBWIN="./anc_se_c.jsp?bbs_id=" + bbs_id+"&bbs_st="+st+"&ck_acar_id=<%=ck_acar_id%>";	
		}
		window.open(SUBWIN, "AncDisp", "left=10, top=10, width=650, height=750, scrollbars=yes");
	}
//-->
</script>
</head>
<body>
<form action="" name="AncRegForm" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type="hidden" name="gubun" value="<%=gubun%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type="hidden" name="cmd" value="">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr> 
        <td colspan="2" align='right'> <a href='javascript:AncReg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
    </td>
  
  </tr>
  <%	}%>
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
						<iframe src="anc_s_sc_in.jsp<%=valus%>&s_width=<%=s_width%>&s_height=<%=s_height%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
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