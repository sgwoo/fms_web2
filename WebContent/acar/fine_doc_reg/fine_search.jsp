<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_idx = request.getParameter("s_idx")==null?"":request.getParameter("s_idx");
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.target = "i_no";
		fm.action = "fine_search_in.jsp";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	//과태료 선택
	function fine_confirm(){
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
		 	alert("이의신청할 과태료를 선택하세요.");
			return;
		}	
		//fm.target = "c_foot";
		//fm.action = "fine_doc_reg_sc.jsp";
		fm.target = "i_no2";
		fm.action = "fine_search_set.jsp";
		fm.submit();
		//window.close();
	}
//-->
	
	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus()" leftmargin=15>
<form name='form1' action='fine_search_in.jsp' method='post' target='i_no'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_idx' value='<%=s_idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>과태료조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td width=37%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssc.gif align=absmiddle>&nbsp;
                      <input type="text" name="t_wd" value='<%=t_wd%>' size="25" class="text" onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    </td>
                    <td ><img src=/acar/images/center/arrow_iiscyb.gif align=absmiddle>&nbsp;
                      <select name="gubun1">
                        <option value="0" <%if(gubun1.equals("0"))%>selected<%%>>전체</option>
                        <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>신청</option>
                        <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>미신청</option>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gg.gif align=absmiddle>&nbsp;&nbsp;&nbsp;
                      <select name="gubun2">
                        <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>사실확인접수일</option>
                        <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>의견진술기한</option>
                        <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>고지서접수일</option>
                        <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>이의신청일</option>
                        <option value="5" <%if(gubun2.equals("5"))%>selected<%%>>납부기한</option>
                        <option value="6" <%if(gubun2.equals("6"))%>selected<%%>>등록일</option>
                      </select>&nbsp;<INPUT TYPE="radio" NAME="gubun3" value="1" checked>당일&nbsp;<INPUT TYPE="radio" NAME="gubun3" value="2">전일&nbsp;<INPUT TYPE="radio" NAME="gubun3" value="3" >기간&nbsp;			
                      <input type="text" name="st_dt" value='<%=st_dt%>' size="11" class="text">
                      ~ 
                      <input type="text" name="end_dt" value='<%=end_dt%>' size="11" class="text">&nbsp;&nbsp;
                      &nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
                      <select name='gubun4'>
                        <option value='car_no' >차량번호</option>
                        <option value='firm_nm' >상호</option>
                      </select> 
                      <input type="text" name="gubun5" value="" class="text" size="20" onKeyDown='javascript:enter()' style='IME-MODE: active'>
                      <a href='javascript:search()'><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
                    </td>
                </tr>
                <tr>
                	<td>
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                		<select name="select_chk_box" id="select_chk_box">
                			<option value="0">체크 해제</option>
                			<option value="10">10건 체크</option>
                			<option value="20">20건 체크</option>
                			<option value="30" selected>30건 체크</option>
                			<option value="35">35건 체크</option>
                			<option value="40">40건 체크</option>
                			<option value="50">50건 체크</option>
                		</select>
                	</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./fine_search_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&t_wd=<%=t_wd%>&s_idx=<%=s_idx%>" name="i_no" width="1000" height="600" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:fine_confirm()"><img src="/acar/images/center/button_conf.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no2" width="100%" height="100" frameborder="0" noresize></iframe> 
</body>
</html>
