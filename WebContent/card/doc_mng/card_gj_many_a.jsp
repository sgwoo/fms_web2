<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String[] pre = request.getParameterValues("ch_cd");
	int pre_size = pre.length;
	
	String value[] = new String[2];
	String c_cardno = "";
	String c_buyid = "";
			
	int flag = 0;
	
	for(int i=0; i < pre_size; i++){
	
		StringTokenizer st = new StringTokenizer(pre[i],"^");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;

		}

		c_cardno		= value[0];
		c_buyid		= value[1];
		
		if(!CardDb.updateCardDocChiefId(c_cardno, c_buy_id, acar_id)) flag += 1;
		
	}
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){		
	
		var fm = document.form1;
		fm.action = 'doc_mng_frame3.jsp';
		fm.target = "d_content";
		fm.submit();

		parent.window.close();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
</form>
<script language='javascript'>
<!--
<%		if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%		}else{//����%>
		alert("��ϵǾ����ϴ�.");
		go_step();
<%		}%>
//-->
</script>
</body>
</html>