<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*,acar.common.*" %>
<%@ page import="acar.schedule.*, acar.attend.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
	
	
	String mtel_scan_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	
	//해당부서 사원리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = new Vector();

	users = c_db.getUserList("", "", "EMP");

	int user_size = users.size();
	
%>

<HTML>
<HEAD>
<TITLE>연차등록</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
function save()
{
	var fm = document.form1;
	
	if(fm.mtel_scan_file.value == ''){	alert('통신비 영수증을  PDF 스캔한 후 등록하십시오.'); 	fm.mtel_scan_file.focus(); 	return; }
			
	//스캔파일 확장자가 ".PDF" 인치 체크 
	
	var file = fm.mtel_scan_file.value;
	file = file.slice(file.indexOf("\\") +1 );
	ext = file.slice(file.indexOf(".")).toLowerCase();
	
	if(ext != '.pdf'){
		alert('PDF가 아닙니다. PDF로 스캔한 파일만 등록이 가능합니다.'); 	
		fm.mtel_scan_file.focus(); 	
		return;
	}
	
	
	
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	
	
	fm.target = "i_no";
	fm.action = "mtel_scan_a.jsp";	
	fm.submit();
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > <span class=style5>통신비영수증등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="" name='form1' method='post' enctype="multipart/form-data">
	<tr>
		<td align='right'>
			<a href="javascript:save()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
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
                    <td width=100 class='title'>사원</td>
                    <td colspan="2" align='left' >&nbsp; 
                      <select name="user_id">
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); 
								if(ck_acar_id.equals(user.get("USER_ID"))){

								}
								%>
								
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
						
                        <%	}
        				}		%>
                      </select>
                    </td>
				</tr>
				<tr> 
                    <td class='title' width="100">일자</td>
                    <td colspan="2">&nbsp; 
					<select name="st_year">
				<option value="">전체</option>
				<%for(int i=2009; i<=year; i++){%>
				<option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select> 
			<select name="st_mon">
				<option value="">전체</option>
				<%for(int i=1; i<=12; i++){%>
				<option value="<%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>월</option>
				<%}%>
			</select>&nbsp;
                    </td>
                </tr>
                <tr> 
                    <td class='title' width="100">증빙첨부</td>
                    <td colspan="2" >&nbsp; 
                      <input type="file" name="mtel_scan_file" size = "40">
                    </td>
                </tr>
            </table>
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type='hidden' name="s_width" value="<%=s_width%>">   
			<input type='hidden' name="s_height" value="<%=s_height%>">  
			<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
			
		</td>
	</tr>	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
