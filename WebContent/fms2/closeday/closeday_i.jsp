<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.common.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
	String closeday = request.getParameter("closeday")==null?"":request.getParameter("closeday");	
	
	
	//해당부서 사원리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = new Vector();

	users = c_db.getUserList("", "", "EMP");

	int user_size = users.size();
	
	
%>

<HTML>
<HEAD>
<TITLE></TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
function reg()
{
	var theForm = document.form1;
	if(get_length(theForm.content.value) > 4000){alert("4000자 까지만 입력할 수 있습니다."); return; }

	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	theForm.cmd.value = "i";
	theForm.action = "./fms2/closeday/closeday_a.jsp";	
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
<table border="0" cellspacing="0" cellpadding="0" width=600>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>중식대신청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
		<form action="" name='form1' method='post' >
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="cmd" value="">		
	<tr>
		<td align='right'>
	 		<a href="javascript:reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
			<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=600>
                <tr> 
                    <td width=100 class='title'>사원명</td>
                    <td colspan="2" align='left' >&nbsp; 
                      <select name="user_id">
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width="100">연차중 업무일자</td>
                    <td colspan="2">&nbsp; 
        			  <input type="text" name="closeday" value='' size="20" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width="100">내용</td>
                    <td colspan="2" >&nbsp; 
                      <textarea name='content' rows='9' cols='70' ></textarea>
                    </td>
                </tr>
            </table>
		</td>
	</tr>	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
