<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*,acar.common.*" %>
<%@ page import="acar.schedule.*" %>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//연차취소 의뢰자
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
	String doc_no	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	int can_seq = request.getParameter("can_seq")==null?0:Util.parseInt(request.getParameter("can_seq"));
	String cancel_tit 	= request.getParameter("cancel_tit")==null?"":request.getParameter("cancel_tit");
	String cancel_cmt 	= request.getParameter("cancel_cmt")==null?"":request.getParameter("cancel_cmt");
	String cancel_dt 	= request.getParameter("cancel_dt")==null?"":request.getParameter("cancel_dt");
	String tem_id 	= request.getParameter("tem_id")==null?"":request.getParameter("tem_id");
	String tem_dt 	= request.getParameter("tem_dt")==null?"":request.getParameter("tem_dt");
		
	String cancel 	= "";
	
		
	//해당부서 사원리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String dept_id = c_db.getUserDept(user_id);
	
	Vector vt = ft_db.Free_per(user_id, doc_no);
	int vt_size = vt.size();
%>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function free_reg()
{
	var theForm = document.form1;
	if(get_length(theForm.cancel_cmt.value) > 4000){alert("4000자 까지만 입력할 수 있습니다."); return; }

	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	
	theForm.submit();
}

function free_close()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

//-->
</script>
</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>휴가신청 취소 </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
<form action="free_time_cancel_a.jsp" name='form1' method='post' enctype="">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="doc_no" value="<%=doc_no%>">
<input type="hidden" name="cancel" value="Y">
<input type="hidden" name="cmd" value="">


<%if(vt_size > 0){
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i); %>		
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	 <tr> 
                  <td class='title' width="15%">신청자</td>
                  <td width="34%">&nbsp;&nbsp;<%=ht.get("USER_NM")%></td>
                  <td class='title' width="17%">등록된일자</td>
                  <td width="34%">&nbsp;&nbsp;<INPUT TYPE="text" NAME="cancel_dt" value="<%=ht.get("START_DATE")%>~<%=ht.get("END_DATE")%>" size="23" readonly ></td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td COLSPAN="3">&nbsp;&nbsp;<INPUT TYPE="text" NAME="cancel_tit" value="<%=ht.get("TITLE")%>등록 취소 요청" size="66" readonly ></td>
                </tr>		  
                <tr> 
                    <td class='title' width="100">내용</td>
                    <td COLSPAN="3">&nbsp;&nbsp;<textarea name='cancel_cmt' rows='9' cols='76' ></textarea> </td>
                </tr>
            </table>
		</td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
		<td align='center'>
	 		<a href="javascript:free_reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
			<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
<input type="hidden" name="start_date" value="<%=ht.get("START_DATE")%>">
<input type="hidden" name="end_date" value="<%=ht.get("END_DATE")%>">
	
<%}
}%>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
