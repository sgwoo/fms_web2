<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String sort 	= request.getParameter("sort")==null?"5":request.getParameter("sort");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String chk1 	= request.getParameter("chk1")==null?"":request.getParameter("chk1");
		
	String acar_id = ck_acar_id;
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

function Search()
{
	var theForm = document.MaintSearchForm;
	theForm.target = "c_foot";
	theForm.action = 'car_cost_s_sc.jsp';
	theForm.submit();
}

function ChangeFocus()
{
	var theForm = document.MaintSearchForm;
	if(theForm.gubun.value=="all")
	{
		nm.style.display = 'none';
		theForm.gubun_nm.value = "";
	
		
	}else{
		nm.style.display = '';
		theForm.gubun_nm.value = "";
		theForm.gubun_nm.focus();
	}
}
function ChangeDT(arg)
{
	var theForm = document.MaintSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}


function magam()
{
	var theForm = document.MaintSearchForm;
	
	if(!confirm('�����Ͻðڽ��ϱ�?'))
		return;
			
	theForm.action = 'stat_end_null.jsp';		
	theForm.target = 'i_no';
					
	theForm.submit();	
	
}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �ڵ������� > <span class=style5>������ ���������Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<form name="MaintSearchForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
	            	<td width=40% colspan=2> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;             	   
	            	   <input type="text" name=ref_dt1 size="11" maxlength="10"   class=text >
						~
					   <input type="text" name="ref_dt2" size="11" maxlength="10"  class=text>&nbsp;&nbsp;
	            	</td>   
	            	
	            	<td>
						<input type="radio" name="chk1" value="" <%if(chk1.equals("")){%> checked <%}%>>����
						<input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>1����
	            	</td>           	            	
	            	        	
	            </tr>
	            <tr>    		
	            	<td width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp;&nbsp;
	            			<select name="gubun" onChange="jvascript:ChangeFocus()">
	            			    <option value="all">��ü</option>
	            				<option value="car_no">������ȣ</option>
	            				<option value="firm_nm">��ȣ</option>
	            		<!--		<option value="client_nm">����</option> -->
	            				<option value="car_nm">����</option>
	            				<option value="jg_code" selected>�����ڵ�</option>
	            				<option value="bus_itm">����</option>
	            			</select>&nbsp;&nbsp;            			
	            	</td>
	            	<td id="nm" width=20%><input type="text" name="gubun_nm" size="20" value="" class=text >&nbsp;</td>            					
           			<td width=30%><img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
           				<select name="gubun3">
            				<option value=""   <%if(gubun3.equals(""))%> 	selected<%%>>��ü</option>
	            			<option value="1"  <%if(gubun3.equals("1"))%> 	selected<%%>>��Ʈ(������)</option> 
	            			<option value="2"  <%if(gubun3.equals("2"))%> 	selected<%%>>����(������)</option> 
	            			<option value="3"  <%if(gubun3.equals("3"))%> 	selected<%%>>�Ϲݽ�</option> 
	            			<option value="4"  <%if(gubun3.equals("4"))%> 	selected<%%>>�⺻��</option> 
	            		</select>	
	            			<select name="gubun4">
            				<option value=""   <%if(gubun4.equals(""))%> 	selected<%%>>��ü</option>
	            			<option value="0"  <%if(gubun4.equals("0"))%> 	selected<%%>>�縮��</option> 
	            			<option value="1"  <%if(gubun4.equals("1"))%> 	selected<%%>>����</option> 
	            			<option value="2"  <%if(gubun4.equals("2"))%> 	selected<%%>>�߰���</option> 	            		
	            		</select>	
            	    </td> 				
            		<td width=15%><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;
            			<select name="sort">
            				<option value="1" 	<%if(sort.equals("1"))%> 	selected<%%>>��������Ÿ�</option>
            				<option value="2" 	<%if(sort.equals("2"))%> 	selected<%%>>���������Ÿ�</option>
            			         <option value="3" 	<%if(sort.equals("3"))%> 	selected<%%>>���ʵ����</option>
            			         <option value="4" 	<%if(sort.equals("4"))%> 	selected<%%>>�����Ѻ��</option>
            			         <option value="5" 	<%if(sort.equals("5"))%> 	selected<%%>>������Ѻ��</option>
            			         <option value="6" 	<%if(sort.equals("6"))%> 	selected<%%>>��ȣ</option>            			         
            			         <option value="7" 	<%if(sort.equals("7"))%> 	selected<%%>>�����ڵ�</option>

            			</select>
            	    </td> 		
            	    <td><input type="hidden" name="auth_rw" value="<%=auth_rw%>"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
            	    &nbsp;&nbsp; <% if (nm_db.getWorkAuthUser("������",acar_id)) { %> <a href="javascript:magam()">.</a><% } %>
            	    </td>           		
            		
            	</tr>
            </table>
        </td>
    </tr>
    <input type='hidden' name='sh_height' value='<%=sh_height%>'>
    <input type='hidden' name='ck_acar_id' value='<%=ck_acar_id%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
	<input type='hidden' name="s_height" value="<%=s_height%>"> 
    </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>