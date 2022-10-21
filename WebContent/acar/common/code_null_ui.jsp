<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.common.*" %>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ce_bean" class="acar.common.CodeEtcBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String c_st 	= request.getParameter("c_st")==null?"":request.getParameter("c_st");
	String code 	= request.getParameter("code")==null?"":request.getParameter("code");
	
	
	String nm_cd 	= request.getParameter("nm_cd")==null?"":request.getParameter("nm_cd");
	String nm 	= request.getParameter("nm")==null?"":request.getParameter("nm");
	String before_nm 	= request.getParameter("before_nm")==null?"":request.getParameter("before_nm");
	String cms_bk 	= request.getParameter("cms_bk")==null?"":request.getParameter("cms_bk");
	String app_st 	= request.getParameter("app_st")==null?"":request.getParameter("app_st");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String var1 	= request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 	= request.getParameter("var2")==null?"":request.getParameter("var2");
	String var3 	= request.getParameter("var3")==null?"":request.getParameter("var3");
	String var4 	= request.getParameter("var4")==null?"":request.getParameter("var4");
	String var5 	= request.getParameter("var5")==null?"":request.getParameter("var5");
	String var6 	= request.getParameter("var6")==null?"":request.getParameter("var6");
	
	// 로그인 정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getSessionValue(request, "USER_ID");	
	String user_nm = login.getSessionValue(request, "USER_NM");
	String id = login.getSessionValue(request, "ID");
		
	int count = 0;
	boolean flag = false;

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(cmd.equals("u")||cmd.equals("i")||cmd.equals("d")){
		code_bean.setC_st(c_st);
		code_bean.setCode(code);
		code_bean.setNm_cd(nm_cd);
		code_bean.setNm(nm);
		code_bean.setCms_bk(cms_bk);
		code_bean.setApp_st(app_st);
		code_bean.setVar1(var1);
		code_bean.setVar2(var2);
		code_bean.setVar3(var3);
		code_bean.setVar4(var4);
		code_bean.setVar5(var5);
		code_bean.setVar6(var6);
			
		if(cmd.equals("i")){
			count = c_db.insertCode(code_bean);
		}else if(cmd.equals("u")){

			count = c_db.updateCode(code_bean);
		}else if(cmd.equals("d")){
			count = c_db.deleteCode(code_bean);
		}
				
		//은행인경우 주소처리
		if (c_st.equals("0003")) {
		    
		    String t_nm 	= request.getParameter("t_nm")==null?"":request.getParameter("t_nm");
		    String t_zip 	= request.getParameter("t_zip")==null?"":request.getParameter("t_zip");
		    String t_addr	= request.getParameter("t_addr")==null?"":request.getParameter("t_addr");
		    String t_gubun	= request.getParameter("t_gubun")==null?"":request.getParameter("t_gubun");  
		    
		    ce_bean.setC_st(c_st);
		    ce_bean.setCode(code);		   
		    ce_bean.setNm(nm);
		    ce_bean.setZip(t_zip);
		    ce_bean.setAddr(t_addr);
		    ce_bean.setGubun(t_gubun);
		    
		    if ( !t_gubun.equals("") )  	count = c_db.insupdCodeEtc(ce_bean);  
	
         }	
	}	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>

<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type="hidden" name="c_st" value="<%=c_st%>">
<input type="hidden" name="code" value="<%=code%>">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;

<%	if(cmd.equals("u")){
		if(count==1 && flag==true){		
%>
		alert('정상적으로 수정되었습니다.');
		<%if(from_page.equals("/acar/common/finance_frame.jsp")){%>
			fm.action= './finance_frame.jsp';
		<%}else{%>
			fm.action= './code_frame_s.jsp';
		<%}%>				
		<%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
		fm.target='CODE';
		<%}else{%>
		fm.target='d_content';
		<%}%>		
		top.window.close();
		fm.submit();		

<%		}
	}else if(cmd.equals("d")){
		if(count==1){		
%>
		alert("정상적으로 삭제되었습니다.");
		fm.action='./code_frame_s.jsp';
		<%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
		fm.target='CODE';
		<%}else{%>
		fm.target='d_content';
		<%}%>		
		top.window.close();
		fm.submit();					
	
<%		}
	}else if(cmd.equals("i")){
		if(count==1){		
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./code_frame_s.jsp';
		<%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
		fm.target='CODE';
		<%}else{%>
		fm.target='d_content';
		<%}%>		
		top.window.close();
		fm.submit();					
<%
		}
	}
%>
//-->
</script>
</body>
</html>
