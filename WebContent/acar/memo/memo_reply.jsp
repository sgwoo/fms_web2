<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.memo.*" %>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_pos = request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String memo_id = request.getParameter("memo_id")==null?"":request.getParameter("memo_id");
	
	MemoBean memo_bn = new MemoBean();
	//memo_bn.setMemo_id(); //+1 추가
	//memo_bn.setDept_id(request.getParameter("dept_id")==null?"":request.getParameter("dept_id")); //부서코드라?? 
	memo_bn.setSend_id(user_id); //보낸사람=로그인한사람
	memo_bn.setRece_id(request.getParameter("send_id")==null?"":request.getParameter("send_id")); //받는사람=보낸사람
	memo_bn.setTitle(request.getParameter("title")==null?"":request.getParameter("title"));
	memo_bn.setContent(request.getParameter("content")==null?"":request.getParameter("content"));
	memo_bn.setAnonym_yn(request.getParameter("anonym_yn")==null?"":request.getParameter("anonym_yn"));
	memo_bn.setAnrece_yn(request.getParameter("anrece_yn")==null?"":request.getParameter("anrece_yn"));
	//memo_bn.setMemo_dt(request.getParameter("memo_dt")==null?"":request.getParameter("memo_dt")); //sysdate
	//memo_bn.setRece_yn(request.getParameter("rece_yn")==null?"":request.getParameter("rece_yn")); //미수신
/*System.out.println("getMemo_id="+memo_bn.getMemo_id());
System.out.println("getDept_id="+memo_bn.getDept_id());
System.out.println("getSend_id="+memo_bn.getSend_id());
*///System.out.println("getRece_id="+memo_bn.getRece_id());
/*System.out.println("getTitle="+memo_bn.getTitle());
System.out.println("getContent="+memo_bn.getContent());
System.out.println("getMemo_dt="+memo_bn.getMemo_dt());
System.out.println("getRece_yn="+memo_bn.getRece_yn());
*/
%>
<script language='javascript'>
<%
if(!memo_db.sendMemo(memo_bn))
{
%>		alert('오류발생!');
	parent.location='about:blank';
<%
}
else
{
	String[] rece_id = memo_bn.getRece_id().split(" ");
	
	for(int i=0; i<rece_id.length; i++){
		memo_bn.setRece_id(rece_id[i]);
		if(!memo_db.sendMemo_rece(memo_bn)){
			%>	alert('오류발생!');
				parent.location='about:blank';
			<%
		}
	}
	
%>	alert('답장을 보냈읍니다.');
	parent.location='memo_f_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>';
<%
}
%>

</script>
</body>
</html>
