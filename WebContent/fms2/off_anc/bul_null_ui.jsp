<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.off_anc.*" %>
<jsp:useBean id="b_bean" class="acar.off_anc.BulBean" scope="page"/>

<%

		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int b_id = request.getParameter("b_id")==null?0:Util.parseInt(request.getParameter("b_id"));
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String title = request.getParameter("title")==null?"":request.getParameter("title");
	String content = request.getParameter("content")==null?"":request.getParameter("content");
	String exp_dt = request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");

	String user_nm = "";
	String br_id = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	

	int i = 4;
	int count = 0;
	
	
		
	String ck_acar_id = request.getParameter("ck_acar_id")==null?"":request.getParameter("ck_acar_id");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");	
	
//	System.out.println("ck_acar_id="+ck_acar_id);
//	System.out.println("s_height="+s_height);
		
	OffBulDatabase oad = OffBulDatabase.getInstance();
	
	b_bean.setB_id(b_id);
	b_bean.setUser_id(user_id);
	b_bean.setExp_dt(exp_dt);
	b_bean.setTitle(title);
	b_bean.setContent(content);	
	b_bean.setB_st("B");

	
if (cmd.equals("d")|| cmd.equals("u")) {
	if(cmd.equals("u")){

			
				count = oad.updateBul(b_bean);

		}else if(cmd.equals("d")){
			
				count = oad.deleteBul(b_bean);
						
		}
	}
	else if(cmd.equals("i")){
			
			

			count = oad.insertBul(b_bean);
			
		}
				
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>

<form name='form1' method="POST">
<input type='hidden' name='b_id' value='<%=b_id%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;

<%	if(cmd.equals("u")){
		if(count==1){		
%>
		alert("정상적으로 수정되었습니다.");
	//	fm.action='./bul_c.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&b_id=<%=b_id%>';
		fm.action='./bul_s_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';
		top.window.close();
		fm.target='d_content'; 
		fm.submit();		

<%		}
	}else if(cmd.equals("d")){
		if(count==1){		
%>
		alert("정상적으로 삭제되었습니다.");
		fm.action='./bul_s_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();					
	
<%		}
	}else if(cmd.equals("i")){
		if(count==1){		
%>
		
		alert("정상적으로 등록되었습니다.");
		fm.action='./bul_s_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';
		top.window.close();
		fm.target='d_content';
		fm.submit();					
<%
		}
	}
%>
//-->
</script>
</body>
</html>

