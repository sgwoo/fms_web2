<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getUserBranchs("rent"); 			//������ ����Ʈ
	int brch_size = branches.size();	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
	   	var fm = document.form1;	   	 
	   	//�Ⱓ
	     	if(fm.gubun2.value == '2'){
		     	if (fm.t_wd.value == '' || fm.st_dt.value == '') {
		     		alert("�Ⱓ Ȥ�� �˻������� �Է��ϼž� �մϴ�.")
	     			return;
	     		}						     
	     	}
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>

<form name='form1' action='/fms2/lc_rent/lc_start5_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ڹ��� > <span class=style5>�뿩�ὺ���ٵ����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�Ⱓ</td>
                    <td>&nbsp;
                    <select name='gubun3'>
                          <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>�뿩������</option>
                          <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>�������</option>
                        </select>
                        &nbsp;
            		    <select name='gubun2'>
                          <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>����</option>
                          <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>����</option>						  
                          <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>���</option>
                          <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>����</option>
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>�Ⱓ </option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
        		    </td>
                    <td class=title width=10%>������</td>
                    <td width=40%>&nbsp;
            		<select name='gubun1'>
                          <option value=''>��ü</option>
                          <%	if(brch_size > 0)	{
            						for (int i = 0 ; i < brch_size ; i++){
            							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                          <option value='<%=branch.get("BR_ID")%>' <%if(gubun1.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                          <%		}
            					}%>
                        </select>
        	    </td>        		    
                </tr>		    
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td colspan='3'>&nbsp;
            		<select name='s_kd'>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>���ʿ�����</option>                          
                        </select>
        		&nbsp;&nbsp;&nbsp;
        		<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        	    </td>                    		  
                </tr>
            </table>
	</td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>
