<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="pc_bean" class="acar.off_anc.PropCommentBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	//request.setCharacterEncoding("euc-kr");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int prop_id 	= request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	int seq 		= request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String content	= request.getParameter("content")==null?"":request.getParameter("content");
	int yn			= request.getParameter("yn") 	 ==null?0:Util.parseInt(request.getParameter("yn"));  // 추가
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String open_yn 	= request.getParameter("open_yn")==null?"N":request.getParameter("open_yn");
	
	
	
	int count = 0;
	int count2 = 0;
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
	if(cmd.equals("i")){
		pc_bean.setProp_id	(prop_id);
		pc_bean.setReg_id	(user_id);
		pc_bean.setContent	(content);
		pc_bean.setYn		(yn);                    //추가
		pc_bean.setCom_st	(mode);
		pc_bean.setOpen_yn	(open_yn);  
		count = p_db.insertPropComment(pc_bean);
	}else if(cmd.equals("u")){
		pc_bean.setProp_id	(prop_id);
		pc_bean.setSeq		(seq);
		pc_bean.setRe_seq	(0);
		pc_bean.setContent	(content);
		pc_bean.setYn		(yn);                    //추가
		pc_bean.setCom_st	(mode);
		count = p_db.updatePropComment(pc_bean);
	}else if(cmd.equals("d")){
		pc_bean.setProp_id	(prop_id);
		pc_bean.setSeq		(seq);
		count = p_db.deletePropComment(pc_bean);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='asc'	 	value='<%=asc%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>      
  <input type="hidden" name="prop_id" 	value="<%=prop_id%>">
  <input type="hidden" name="yn" 	value="<%=yn%>">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
  
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
	alert("정상적으로 처리되었습니다.");
	fm.action='./prop_c.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>';
	fm.target='d_content';
	fm.submit();			
	parent.window.close();		
<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
-->
</script>
</body>
</html>
