<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id   		= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	boolean flag = false;
	boolean flag_f = false;
	int	cnt	= 0;
	

	
	
	if(mode.equals("compl_etc_u")){	//����ó������ ������Ʈ(20180726)
			
		String vid[] = request.getParameterValues("ch_l_cd");
		String vid2[] = request.getParameterValues("ch_doc_id");
		String vid3[] = request.getParameterValues("ch_cnt");
		String vid_num="";
		String doc_id = "";
		
		String compl_etc   	= request.getParameter("compl_etc")==null?"":request.getParameter("compl_etc");
	
		int vid_size = vid.length;
		
		for(int i=0;i < vid_size;i++){
			vid_num 	= vid[i];
			doc_id 		= vid2[AddUtil.parseInt(vid_num)];
			flag 		= FineDocDb.changeComplete_etc(doc_id, compl_etc);
			if(flag==true)	cnt++;
		}
		if(vid_size==cnt)	flag_f = true;
		
	}else{}	//�߰��� ��尡 ������ ���⼭ �ۼ�.
%>	


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title></title>
<script language="JavaScript">
<!--
var flag_f 	= <%=flag_f%>;
var mode 	= '<%=mode%>';
if(mode=="compl_etc_u"){
	if(flag_f==true){
		alert("���� ó���Ǿ����ϴ�.");
	}else{
		alert("ó���� �����߻�!");
	}
	parent.opener.location.reload();
	window.close();
}
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>

</body>
</html>
