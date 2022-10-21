<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*" %>
<jsp:useBean id="bean" class="acar.asset.AssetVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String a_a = request.getParameter("a_a")==null?"1":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
		
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	bean.setA_a(a_a);
	bean.setSeq(seq);
	bean.setA_1(request.getParameter("a_1")==null?"":request.getParameter("a_1"));
	bean.setB_1(request.getParameter("b_1")==null?0:AddUtil.parseFloat(request.getParameter("b_1")));	
	bean.setB_2(request.getParameter("b_2")==null?"":request.getParameter("b_2"));
	bean.setB_3(request.getParameter("b_3")==null?"":request.getParameter("b_3"));
	bean.setB_4(request.getParameter("b_4")==null?"":request.getParameter("b_4"));	
	bean.setB_5(request.getParameter("b_5")==null?"":request.getParameter("b_5"));
	bean.setC_1(request.getParameter("c_1")==null?"":request.getParameter("c_1"));
	bean.setC_2(request.getParameter("c_2")==null?0:AddUtil.parseFloat(request.getParameter("c_2")));
	bean.setC_3(request.getParameter("c_3")==null?"":request.getParameter("c_3"));
	bean.setC_4(request.getParameter("c_4")==null?"":request.getParameter("c_4"));	
	bean.setC_5(request.getParameter("c_5")==null?"":request.getParameter("c_5"));
	bean.setD_1(request.getParameter("d_1")==null?"":request.getParameter("d_1"));
	bean.setD_2(request.getParameter("d_2")==null?"":request.getParameter("d_2"));
	bean.setD_3(request.getParameter("d_3")==null?"":request.getParameter("d_3"));
	bean.setD_4(request.getParameter("d_4")==null?"":request.getParameter("d_4"));	
	bean.setD_5(request.getParameter("d_5")==null?"":request.getParameter("d_5"));
					
	
	if(cmd.equals("i") || cmd.equals("up")){
		seq = a_db.insertAssetVar(bean);
	}else if(cmd.equals("u")){
		count = a_db.updateAssetVar(bean);
	}
%>
<html>
<head>

<title></title>
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="asset_var_i.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="a_a" value="<%=a_a%>">
  <input type="hidden" name="seq" value="<%=seq%>">
  <input type="hidden" name="cmd" value="u">
</form>
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}else{
		if(!seq.equals("")){%>
		alert("정상적으로 등록되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}	%>
</script>
</body>
</html>
