<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	NaviBean  ins = new NaviBean();
	ins.setSerial_no	(request.getParameter("serial_no")==null?"":request.getParameter("serial_no"));
	ins.setModel		(request.getParameter("model")==null?"":request.getParameter("model"));
	ins.setGubun		(request.getParameter("gubun")==null?"":request.getParameter("gubun"));
	ins.setRemark		(request.getParameter("remark")==null?"":request.getParameter("remark"));
	
	int count = 0;
	
	if(cmd.equals("i")){		//���
		count = c_db.insertNavi(ins);	
	}else if(cmd.equals("u")){	//����
		count = c_db.updateNavi(ins);	

	}else{}
%>
<script language='javascript'>
<%	if(count != 1){%>
		alert('�����߻�!');
		location='about:blank';
<%	}else{%>
		alert('ó���Ǿ����ϴ�');
		parent.parent.location='/fms2/rent_stat/lc_navi_stat_frame.jsp?auth_rw=<%=auth_rw%>';
				
<%	}%>
</script>
</body>
</html>
