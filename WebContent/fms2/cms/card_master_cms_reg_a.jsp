<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body style="font-size:12">


<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID	
		
	// cms 처리전 데이타여부 확인 후 삭제 		
	int cnt = 0;
	String jbit = "";
	String  flag = "0"; 
	
	//전송된 파일(결과수신이 안된) 이 있는지 여부 - 
	cnt =  ai_db.getCntCardMemberCmsBit();
	
	if ( cnt > 0 ) {  //수신처리가 안된 기등록분이 있음.
	     flag = "T";
	}  else {  	
		cnt =  ai_db.getCntCardMemberToday();
		if (cnt < 1 ) {	
			     flag =  ai_db.call_sp_card_cms_member_reg();	
		} else {	
			flag = "2";
		}	
	}
		
	System.out.println(" card cms 고객데이타 생성처리:" +flag);
	
%>

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag.equals("1")){%>
		alert('오류발생!');
<%	}else if(flag.equals("2")){%>
		alert('cms고객데이타를 생성할수 없습니다.!');
<%	}else if(flag.equals("T")){%>
		alert('결과확인이 안된건이 있습니다.  카드 CMS 고객데이타를 생성할수 없습니다.!');		
<%	}else{%>
		alert('처리되었습니다');
		fm.action='/fms2/cms/card_master_cms_reg.jsp';
   		fm.target='d_content';		
    	fm.submit();

<%	}%>

</script>
</body>
</html>

