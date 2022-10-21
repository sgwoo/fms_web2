<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String year = request.getParameter("year")==null?"":AddUtil.ChangeString(request.getParameter("year")); 
	String tm = request.getParameter("tm")==null?"":AddUtil.ChangeString(request.getParameter("tm")); 
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String gubun = request.getParameter("gubun")==null?"5":AddUtil.ChangeString(request.getParameter("gubun"));
	String cs_dt = request.getParameter("cs_dt")==null?"":AddUtil.ChangeString(request.getParameter("cs_dt")); 
	String ce_dt = request.getParameter("ce_dt")==null?"":AddUtil.ChangeString(request.getParameter("ce_dt"));
	int amt1 = request.getParameter("amt1")==null?0:AddUtil.parseDigit(request.getParameter("amt1"));  //���ȰǼ�
	int amt2 = request.getParameter("amt2")==null?0:AddUtil.parseDigit(request.getParameter("amt2"));   //ä�°Ǽ�
	int amt3 = request.getParameter("amt3")==null?0:AddUtil.parseDigit(request.getParameter("amt3"));   //�ǰ߰Ǽ�
	int cam_per = request.getParameter("cam_per")==null?0:AddUtil.parseDigit(request.getParameter("cam_per"));
	int amt1_per = request.getParameter("amt1_per")==null?0:AddUtil.parseDigit(request.getParameter("amt1_per"));
	
	String o_cs_dt 		= request.getParameter("o_cs_dt")	==null?"":AddUtil.ChangeString(request.getParameter("o_cs_dt")); 
	String o_ce_dt 		= request.getParameter("o_ce_dt")	==null?"":AddUtil.ChangeString(request.getParameter("o_ce_dt"));	
	
	String t_chk = request.getParameter("t_chk")==null?"":request.getParameter("t_chk"); //1:���� ,  2:ķ���θ��� ����
	
	int result = 0;
	int result1 = 0;
	
	String today = AddUtil.getDate(4);
	String save_dt = today;
		
	if ( t_chk.equals("2")) { //ķ���� ���� ��������Ÿ ���� ���� - ���� ��� �ݿ� ���� �ڷ� 
		result1 = ac_db.insertMagamProp(save_dt);
	} else {
		//����
		if(o_cs_dt.equals(cs_dt) && o_ce_dt.equals(ce_dt)){
			result = ac_db.updatePropVar(year, tm, gubun, cs_dt, ce_dt, amt1, amt2, amt3, cam_per, amt1_per );
		//���	
		}else{
			year 	= cs_dt.substring(0,4);
			tm 	= cs_dt.substring(4,6);
			
			result = ac_db.insertPropVar(year, tm, gubun, cs_dt, ce_dt, amt1, amt2, amt3, cam_per, amt1_per );
		}			
	}
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='/fms2/mis/prop_campaign_null.jsp' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='t_chk' value='<%=t_chk%>'>
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
<% if ( result1 >= 1) { %>
    alert("ķ���� ���� ������Ÿ�� ����Ǿ����ϴ�.");
<% } else { %>    
	<%if(result >= 1){%>
		alert("�����Ǿ����ϴ�.\n\n����� ������ �ݿ��� ķ������ �����մϴ�. ��ٷ� �ֽʽÿ�.");
		fm.submit();		
	<%}else{%>
		alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڿ��� �����ϼ��� !");
	<%}%>
<% } %>
//-->
</script>
</body>
</html>
