<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
   //스크롤이 두개이상인경우 고정
	int cnt = 3; //검색 라인수
    int sh_height = cnt*sh_line_height;
  	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
  	

%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//거래처 보기
	function view_client(client_id)
	{
		var fm = document.form1;
		fm.client_id.value = client_id;
		fm.target = "d_content";
		fm.action = "client_c.jsp";
		fm.submit();
	}
	//거래처 등록
	function reg_client()
	{
		var fm = document.form1;	
		fm.target = "d_content";
		fm.action = "client_i.jsp";
		fm.submit();	
	}
	//거래처 메모
	function cl_mm(client_id)
	{
		window.open('/acar/mng_client2/client_mm_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id, "CLIENT_MM", "left=100, top=100, width=550, height=500");
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
		
	Hashtable stat = l_db.getClientStat(s_kd, t_wd);
%>
<form name='form1' method='post' target='d_content' action='/acar/mng_client2/client_c.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='c_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<tr>
		<td align='right'><a href='javascript:reg_client()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
<%	}%>
	
	<tr>	
		<td>
			<iframe src="/acar/mng_client2/client_sc_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" >
			</iframe>
		</td>
	</tr>
	<tr>
		<td>
		</td>
	</tr>
<!--	
	<tr>
		<td class='line'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='800'>
          <tr> 
            <td width='129' class='title' rowspan="2">구분</td>
            <td width='121' class='title' rowspan="2">법인사업장</td>
            <td class='title' colspan="3">개인사업자</td>
            <td width='105' class='title' rowspan="2">개인</td>
            <td width='121' class='title' rowspan="2">합계</td>
          </tr>
          <tr> 
            <td width='102' class='title'>일반과세</td>
            <td width='111' class='title'>간이과세</td>
            <td width='103' class='title'>면세</td>
          </tr>
          <tr> 
            <td class='title' width="129">건수</td>
            <td align='right' width="121"><%=Util.parseDecimal(String.valueOf(stat.get("C1")))%>건&nbsp;</td>
            <td align='right' width="102"><%=Util.parseDecimal(String.valueOf(stat.get("C3")))%>건&nbsp;</td>
            <td align='right' width="111"><%=Util.parseDecimal(String.valueOf(stat.get("C4")))%>건&nbsp;</td>
            <td align='right' width="103"><%=Util.parseDecimal(String.valueOf(stat.get("C5")))%>건&nbsp;</td>
            <td align='right' width="105"><%=Util.parseDecimal(String.valueOf(stat.get("C2")))%>건&nbsp;</td>
            <td align='right' width="121"><%=Util.parseDecimal(String.valueOf(stat.get("CT")))%>건&nbsp;</td>
          </tr>
        </table>
		</td>
	</tr>	
-->	
</table>
</form>
</body>
</html>
