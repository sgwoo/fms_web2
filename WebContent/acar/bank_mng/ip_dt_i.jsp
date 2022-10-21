<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.forfeit_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String ip_dt 		= request.getParameter("ip_dt")==null?"":request.getParameter("ip_dt");
	String cmd			= "";
	int count = 0;
			
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "07");	
		

%>
<HTML>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--
function save()
{
	var theForm = document.from1;
	
	<%if(ip_dt.equals("")){%>
		theForm.cmd.value='i';
	<%}else{%>
		theForm.cmd.value='m';
	<%}%>
	
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	theForm.target = "i_no";
	theForm.submit();
}

function showpicks() {
  _s = "";
  if (document.from1.c1.checked) _s += "없음 ";
  if (document.from1.c2.checked) _s += "은행설정 ";

  document.from1.ip_dt.value = _s;
}

function doIt(_v) {
document.from1.ip_dt.value=_v;
}


//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</HEAD>
<BODY>
<form action="ip_dt_a.jsp" name='from1' method='post'>
<input type="hidden" name="doc_id" value="<%=doc_id%>">
<input type="hidden" name="cmd" value="">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 구매자금관리 ><span class=style5> 근저당설정비용 입금일등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="" class='title'>입금일자</td>
                    <td>&nbsp;<input type="text" name="ip_dt" value="<%=ip_dt%>" class='text' >&nbsp;&nbsp;&nbsp;
                    
                       <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
                    
                    <a href="javascript:save();">                    
                    <%if(ip_dt.equals("")){%><img src=../images/center/button_in_reg.gif align=absmiddle border=0><%}else{%><img src=../images/center/button_in_modify.gif align=absmiddle border=0><%}%>
                    </a>
                    <% } %>
                    </td>
                </tr>
				<tr>
					<td colspan="2" align="center">
						<input type="radio" name="r1" onclick=doIt('없음')> 없음
						<input type="radio" name="r1" onclick=doIt('은행설정')> 은행설정
						 &nbsp;<input type=reset value="Clear!">
					</td>
				</tr>
            </table>
        </td>
</table>
</form>

<script language="JavaScript">
<!--
	//alert("정상적으로 등록되었습니다.");
	opener.LoadSche();
	window.close();
//-->
</script>	

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</BODY>
</HTML>
