<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.insur.*"%>
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
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String sort = request.getParameter("sort")==null?"2":request.getParameter("sort");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	//과태료 선택
	function ins_confirm(){
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
		fm.target = "c_foot";
//		fm.action = "popup_excel.jsp";
		fm.action = "ins_doc_reg_sc.jsp";		
		fm.submit();
		window.close();
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus()">
<form name='form1' action='ins_search_in.jsp' method='post' target='i_no'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > <span class=style5>해지보험조회</span></span></td>
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
                    <td width=31%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_ssc.gif align=absmiddle>&nbsp;&nbsp;&nbsp;
                      <select name='t_wd' onChange='javascript:ins_display()'>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ic.getIns_com_id().equals(t_wd)){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width=22%><img src=../images/center/arrow_gmjsyb.gif align=absmiddle>&nbsp;
                      <select name="gubun1">
                        <option value="0" <%if(gubun1.equals("0"))%>selected<%%>>전체</option>
                        <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>작성</option>
                        <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>미작성</option>
                      </select>
                    </td>
                    <td><img src=../images/center/arrow_gg.gif align=absmiddle>&nbsp;
                      <select name="gubun2">
                        <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>청구일자</option>
                        <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>발생일자</option>
                      </select>&nbsp;			
                      <input type="text" name="st_dt" value='<%=st_dt%>' size="9" class="text">
                      ~ 
                      <input type="text" name="end_dt" value='<%=end_dt%>' size="9" class="text">
                      <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_carnum.gif align=absmiddle>&nbsp;
                    <input type="text" name="car_no" value='<%=car_no%>' size="9" class="text"></td>
                    <td><img src=../images/center/arrow_jr.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <select name="sort">
                        <option value="1" <%if(sort.equals("1"))%>selected<%%>>차량번호</option>
                        <option value="2" <%if(sort.equals("2"))%>selected<%%>>청구일자</option>
                      </select></td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./ins_search_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&t_wd=<%=t_wd%>&car_no=<%=car_no%>&sort=<%=sort%>" name="i_no" width="100%" height="500" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:ins_confirm()"><img src="/acar/images/center/button_conf.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
