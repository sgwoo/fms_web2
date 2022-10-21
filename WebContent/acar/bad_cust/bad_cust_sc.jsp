<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bad_cust.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
   //스크롤이 두개이상인경우 고정
	int cnt = 2; //검색 라인수
    	int sh_height = cnt*sh_line_height;
  	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "06", "02");
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function BadCustReg(){	
		var SUBWIN="./bad_cust_id.jsp?cmd=i&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>";	
		window.open(SUBWIN, "UserList", "left=100, top=100, width=800, height=550, scrollbars=no");
	}

	function BadCustUpdate(seq){	
		var SUBWIN="./bad_cust_id.jsp?cmd=u&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&seq="+seq;	
		window.open(SUBWIN, "UserList", "left=100, top=100, width=800, height=550, scrollbars=no");
	}

	//체크된것 삭제
	function BadCustDelete(){
		var fm = document.form1;
		var len= fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];		
			if(ck.name == "chk_idnum"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
	 		alert("삭제할 불량임차인을 선택하세요.");
			return;
		}	
		//if(!confirm('삭제하시겠습니까?')){	return;	}		
		//fm.cmd.value = 'd';
		//fm.target="i_no";		
		//fm.submit();
	}	
//-->
</script>
</head>
<body leftmargin="15">
<form action="bad_cust_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">
  <input type="hidden" name="t_wd" value="<%=t_wd%>">  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>   
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td align="right">
    		
    	
    	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
            <a href="javascript:BadCustReg()"><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a>
    	<%}%>
        </td>
    </tr>
	<tr>	
		<td>
			<iframe src="/acar/bad_cust/bad_cust_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" >
			</iframe>
		</td>
	</tr>
	<tr>
		<td>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>