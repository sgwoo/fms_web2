<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>

<jsp:useBean id="me_bean" class="acar.user_mng.MenuBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String m_st = "";
	String m_st2 = "";
	String m_cd = "";
	String m_nm = "";
	String url = "";
	String note = "";
	int seq = 0;
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		if(request.getParameter("m_st") !=null) 	m_st 	= request.getParameter("m_st");
		if(request.getParameter("m_st2") !=null) 	m_st2 	= request.getParameter("m_st2");
		if(request.getParameter("m_cd") !=null) 	m_cd 	= request.getParameter("m_cd");
		if(request.getParameter("m_nm") !=null) 	m_nm 	= request.getParameter("m_nm");
		if(request.getParameter("url") !=null) 		url 	= request.getParameter("url");
		if(request.getParameter("note") !=null) 	note 	= request.getParameter("note");
		if(request.getParameter("seq") !=null) 		seq 	= Util.parseInt(request.getParameter("seq"));
		
		me_bean.setM_st(m_st);
		me_bean.setM_st2(m_st2);
		me_bean.setM_cd(m_cd);
		me_bean.setM_nm(m_nm);
		me_bean.setUrl(url);
		me_bean.setNote(note);
		me_bean.setSeq(seq);
		if(cmd.equals("i"))
		{
			count = umd.insertXmlMaMenu(me_bean,"b");
		}else if(cmd.equals("u")){
			count = umd.updateXmlMaMenu(me_bean);
		}
	}else if(cmd.equals("d"))
    {
    	
    	String code [] = null;
    	
    	code = request.getParameterValues("ch_m_st");
    	
	    Vector v = new Vector();
	    Throwable error = null;
	    if(code != null && code.length > 0){
	        for(int i=0; i<code.length; i++){
	            try{
		            String val [] = {code[i]};
	                v.addElement(val);
	            }catch(NoSuchElementException  nse){
	                error = nse;
	            }
	        }
	    }
	    count = umd.deleteBXmlMaMenu(v);
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
parent.BMenuSearch();
<%
		}
	}else if(cmd.equals("i")){
		if(count==1)
		{
%>
alert("정상적으로 등록되었습니다.");
parent.BMenuSearch();
<%
		}
	}else if(cmd.equals("d")){
		if(count==1)
		{
%>
alert("정상적으로 삭제되었습니다.");
parent.BMenuSearch();
<%
		}
	}
%>
</script>
</body>
</html>