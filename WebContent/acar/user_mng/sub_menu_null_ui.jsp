<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>

<jsp:useBean id="sub_bean" class="acar.user_mng.MenuBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String m_st = "";
	String m_cd = "";
	int seq_no = 0;
	String sm_nm = "";
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert 구분
	}
	
	if(request.getParameter("m_st") !=null) m_st = request.getParameter("m_st");
	if(request.getParameter("m_cd") !=null) m_cd = request.getParameter("m_cd");
	if(request.getParameter("sm_nm") !=null) sm_nm = request.getParameter("sm_nm");
	if(request.getParameter("seq_no") !=null) seq_no = Util.parseInt(request.getParameter("seq_no"));
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		
		sub_bean.setM_st(m_st);
		sub_bean.setM_cd(m_cd);
		sub_bean.setSm_nm(sm_nm);
		sub_bean.setSeq_no(seq_no);
		if(cmd.equals("i"))
		{
			count = umd.insertSubMenu(sub_bean);
		}else if(cmd.equals("u")){
			count = umd.updateSubMenu(sub_bean);
		}
	}else if(cmd.equals("d"))
    {
    	
    	String code [] = null;
    	
    	code = request.getParameterValues("ch_seq_no");
    	
	    Vector v = new Vector();
	    Throwable error = null;
	    if(code != null && code.length > 0){
	        for(int i=0; i<code.length; i++){
	            try{
		            int val [] = {Util.parseInt(code[i])};
	                v.addElement(val);
	            }catch(NoSuchElementException  nse){
	                error = nse;
	            }
	        }
	    }
	    count = umd.deleteSubMenu(m_st,m_cd, v);
    }	

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

</head>
<body leftmargin="15">

<script>
<%
	if(cmd.equals("u"))
	{
		if(count==1)
		{
%>
alert("정상적으로 수정되었습니다.");
top.window.SubMenuSearch();
window.location = "about:blank";
<%
		}
	}else if(cmd.equals("i")){
		if(count==1)
		{
%>
alert("정상적으로 등록되었습니다.");
top.window.SubMenuSearch();
window.location = "about:blank";
<%
		}
	}else if(cmd.equals("d")){
		if(count==1)
		{
%>
alert("정상적으로 삭제되었습니다.");
top.window.SubMenuSearch();
window.location = "about:blank";
<%
		}
	}
%>
</script>
</body>
</html>