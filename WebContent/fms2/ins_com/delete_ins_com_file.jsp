<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.im_email.*, acar.client.*, acar.user_mng.*, acar.insur.*" %>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 			= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String mode 			= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String checkScdFee 	= request.getParameter("checkScdFee")==null?"":request.getParameter("checkScdFee");
	
	String replyEmail	= "";
	String mail_addr	= "";
	
	String vid[] = request.getParameterValues("ch_cd");
	
	int deletedCnt = 0;
	for (String seq : vid) {
		boolean flag = ic_db.deleteInsComFile(seq);
		if (flag) {
			deletedCnt += 1;
		}
	}
%>	
	<h3>
		<%= deletedCnt %>개 파일이 삭제 되었습니다.
	</h3>
