<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
			
		
	
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function search(){
		var fm = document.form1;
		fm.target = "c_body";
		fm.action = "cus_mng_sc.jsp";
		fm.submit()
}
	
function tot_fee_amt(){
	window.open('/acar/bus_mng/bus_s_frame.jsp','tot_fee_amt','scrollbars=yes,status=no,resizable=no,width=840,height=700,top=80,left=100');
}	

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

	
function set_bus_id2(){
	var fm = document.form1;
	if(fm.gubun4.value == ''  ){
	 	alert("담당자를 선택해 주세요!");
	 	return;
	}
	
	fm.target = "_blank";
	fm.action = "cng_bus_id.jsp";
	fm.submit();

}		

function set_mng_id(){
	var fm = document.form1;
	if(fm.gubun4.value == ''  ){
	 	alert("담당자를 선택해 주세요!");
	 	return;
	}
	
	fm.target = "_blank";
	fm.action = "cng_mng_id.jsp";
	fm.submit();

}	

function set_mng_id2(){
	var fm = document.form1;
	if(fm.gubun4.value == ''  ){
	 	alert("담당자를 선택해 주세요!");
	 	return;
	}
	
	fm.target = "_blank";
	fm.action = "cng_mng_id2.jsp";
	fm.submit();

}		

function set_mng_id2_apply(){
	var fm = document.form1;
  			
	if(!confirm('등록하시겠습니까?')){	return;	}		
	fm.action = "cng_mng_id2_null_a.jsp";
	fm.target = "i_no";
	fm.submit()

}		
-->
</script>
</head>
<body leftmargin="15">
<form name=form1 method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>	

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 계약관리 > <span class=style5>담당자배정관리</span></span></td>
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
            <table border=0 cellspacing=1 cellpadding=0>
                <tr> 
                    <td width="350">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
                      일반식 
                      <input type="radio" name="gubun1" value="3" <%if(gubun1.equals("3"))%>checked<%%>>
                      기본식(맞춤식) 
                      <input type="radio" name="gubun1" value="A" <%if(gubun1.equals("A"))%>checked<%%>>
                      전체 </td>
                    
                    <td width="200">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ddj.gif"  align="absmiddle" border="0">&nbsp;
                          <select name="gubun3">
                            <option value=""  <%if(gubun3.equals(""))%>selected<%%>>전체</option>
                            <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>최초영업자</option>
                            <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>영업담당자</option>
                            <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>관리담당자</option>
                            <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>예비배정자</option>
                          </select></td>
                    <td width="150"> 
                        &nbsp;<input type="text" class="text" name="gubun4" size="15" value="<%= gubun4 %>" align="absbottom">
                    </td>
                    <td> 
                        <a href='javascript:search();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>                           
                </tr>
            </table>
        </td>
    </tr>     
    <tr>     
        <td align="right">
     	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
            <a href='javascript:set_bus_id2()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_bj_yu.gif"  align="absmiddle" border="0"></a>&nbsp;
            <a href='javascript:set_mng_id()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_bj_gr.gif"  align="absmiddle" border="0"></a>&nbsp;  
            <a href='javascript:set_mng_id2()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_bj_yb.gif"  align="absmiddle" border="0"></a>&nbsp;  
            <a href='javascript:set_mng_id2_apply()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_bg_ybdd.gif"  align="absmiddle" border="0"></a> 
             <%}%> 
           &nbsp;&nbsp;
           <a href="javascript:tot_fee_amt();"><img src="/acar/images/center/button_allfee.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
</table>
</form>  
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
