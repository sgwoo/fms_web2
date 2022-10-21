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
	
	//대체근무정보
	Hashtable ht3= ft_db.getFree_work(user_id, doc_no);
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
	
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.action = "free_time_work_cng_a.jsp";
	theForm.submit();
}

function free_close()
{
	self.close();	
}


//대체근무자 조회하기
function User_search(dept_id)
{
	var fm = document.form1;
	var st_dt = fm.st_dt.value;
	var end_dt = fm.end_dt.value;
	var user_id = fm.user_id.value;
	var dept_id = dept_id;
	window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
	fm.action = "user_search.jsp?st_dt="+st_dt+"&end_dt="+end_dt+"&dept_id="+dept_id+"&user_id="+user_id;
	fm.target = "User_search";
	fm.submit();		
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>휴가신청 업무대체자 변경</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
<form action="free_time_work_cng_a.jsp" name='form1' method='post' enctype="">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="doc_no" value="<%=doc_no%>">
<input type="hidden" name="o_work_id" value="<%=ht3.get("WORK_ID")%>">
<input type="hidden" name="cancel" value="Y">
<input type="hidden" name="cmd" value="">



<%if(vt_size > 0){
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i); %>	
<input type="hidden" name="st_dt" value="<%=ht.get("START_DATE")%>">
<input type="hidden" name="end_dt" value="<%=ht.get("END_DATE")%>">
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	 <tr> 
                  <td class='title' width="150">신청자</td>
                  <td>&nbsp;&nbsp;<%=ht.get("USER_NM")%></td>
                 </tr>
                <tr>  
                  <td class='title'>등록된일자</td>
                  <td>&nbsp;&nbsp;<%=ht.get("START_DATE")%>~<%=ht.get("END_DATE")%></td>
                </tr>
                <tr> 
                    <td class='title'>변경전 업무대체자</td>
                    <td>&nbsp;&nbsp;<%=ht3.get("WORK_DEPT")%> <%=ht3.get("WORK_NM")%></td>
                </tr>		  
                <tr> 
                    <td class='title'>변경후 업무대체자</td>
                    <td>&nbsp;&nbsp;<input ytpe="text" name="user_nm" size="11" class=text readOnly>
					  <input type="hidden" name="work_id" >  <a href="javascript:User_search('<%=dept_id%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
        			  </td>
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
