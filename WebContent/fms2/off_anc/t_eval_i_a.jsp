<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	boolean flag = true;
	
	String prop_id = request.getParameter("prop_id")==null?"":request.getParameter("prop_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String re_seq = request.getParameter("re_seq")==null?"":request.getParameter("re_seq");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	int e_amt = request.getParameter("e_amt")==null?0:AddUtil.parseDigit(request.getParameter("e_amt"));
	int p_amt = request.getParameter("p_amt")==null?0:AddUtil.parseDigit(request.getParameter("p_amt"));
		
	OffPropDatabase p_db = OffPropDatabase.getInstance();

	
	flag = p_db.insertCommentEval(prop_id, seq, re_seq, user_id, e_amt, p_amt);
%>
<form name='form1' action='t_eval_frame_s.jsp' method="POST">
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
		document.form1.target = 'CommentReg';
		document.form1.submit();
		
<%	}%>

</script>
</body>
</html>
