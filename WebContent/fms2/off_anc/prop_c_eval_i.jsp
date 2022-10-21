<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	boolean flag = true;
	
	String prop_id = request.getParameter("prop_id")==null?"":request.getParameter("prop_id");
	String[] seq = request.getParameterValues("seq");
	String[] re_seq = request.getParameterValues("re_seq");
	String[] e_amt = request.getParameterValues("e_amt"); 
	
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
		
	int vid_size = 0;
	vid_size = seq.length;		

	int amt_size = 0;	
	amt_size = e_amt.length;	
		
	String i_seq = "";
	String i_amt = "";
	String i_re_seq = "";
		
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	for(int i=0;i < vid_size;i++){
		
		i_seq = seq[i];
		i_amt = e_amt[i];
		i_re_seq = re_seq[i];
		
	//	System.out.println(amt_size+ "|" + AddUtil.parseInt(i_amt));
			
		if (AddUtil.parseInt(i_amt) >= 0) {		
		//댓글평가
	//		System.out.println(prop_id+ "|" + AddUtil.parseInt(i_amt));
			flag = p_db.insertCommentEval(prop_id, i_seq, i_re_seq, user_id, AddUtil.parseInt(i_amt));
		} 
	
	}
%>
<form name='form1' method="POST">
<input type='hidden' name='prop_id' value='<%=prop_id%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
//		location='about:blank';
<%	}else{%>
	
//		alert('등록되었습니다');
		var fm = document.form1;
			
		fm.action = "./prop_c.jsp";
		fm.target = 'd_content';
		fm.submit();
			
		
<%	}%>

</script>
</body>
</html>
