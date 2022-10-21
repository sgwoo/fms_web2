<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.cont.*"%> 
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	boolean result =false;
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	//System.out.println(dt+","+st_dt+","+end_dt+","+gubun1+","+gubun2+","+t_wd);
	
	String result_value = "";
	
	
	
	int count = 0;
	%>
	</head>
	<body leftmargin="15">
	<form action="/acar/ins_mng/ins_c2_frame.jsp" id="form1" name="form1" method="POST" target="c_foot">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type='hidden' name='dt' value='<%=dt%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	
	<%
		result = ic_db.call_sp_ins_cng_base_case2();
	%>
		
	</form>
</body>
<script>
	var result = '<%=result%>';
	
	if(!result){
		alert("재검색이 보류되었습니다.");	
		opener.parent.location.reload();
		self.close();
	}else{
		alert("재검색이 완료되었습니다.");	
		opener.parent.location.reload();
		self.close();
	}
	
</script>

</html>