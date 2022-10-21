<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String dt = request.getParameter("dt")==null?"3":request.getParameter("dt");
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.target = "i_no";
		fm.action = "find_myaccid_search_in.jsp";		
		fm.submit();		
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	
	//휴/대차료 선택
	function loan_confirm(){
		var fm1= document.form1;	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "cho_id"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("최고서를 발송할 휴/대차료를 선택하세요.");
			return;
		}	
		
		
		fm.target = "c_foot";
		fm.action = "settle_doc3_reg_sc.jsp";		
		fm.submit();
		window.close();
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form name='form1' action='find_myaccid_search_in.jsp' method='post' target='i_no'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='r_gov_id' value='<%=gov_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=830>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>휴/대차료 내역조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  
                    <td width=270><img src=/acar/images/center/arrow_gys.gif align=absmiddle>&nbsp;
                      <input type="text" name="t_wd" value='<%=t_wd%>' size="30" class="text" >                     
                    </td>
                  
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <!--
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      당월 
                      -->
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      조회기간 </td>                       
                    <td> 
                      <select name="gubun2">
                        <option value="1" <%if(gubun2.equals("2"))%>selected<%%>>청구일</option>                     
                      </select>&nbsp;			
                      <input type="text" name="st_dt" value='<%=st_dt%>' size="11" class="text">
                      ~ 
                      <input type="text" name="end_dt" value='<%=end_dt%>' size="11" class="text">
                    </td>
                    <td colspan=2 >     
                      <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./find_myaccid_search_in.jsp?r_gov_id=<%=gov_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&t_wd=<%=t_wd%>" name="i_no" width="820" height="530" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr>
        <td style='height:5'></td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:loan_confirm()"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
