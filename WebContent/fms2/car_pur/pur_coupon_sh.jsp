<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;	
		
		if(fm.gubun2.value == '2' && fm.gubun3[0].checked == true && fm.st_dt.value =='' && fm.t_wd.value ==''){
			alert('���������� �� �־��ּ���. ��ü�� ��ȸ�Ҽ��� �����ϴ�.');  return;
		}
		fm.target = "c_foot";
		fm.action = "/fms2/car_pur/pur_coupon_sc.jsp";	
		fm.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//����Ʈ ���� ��ȯ
	function pop_auto(){
		var fm = document.form1;	
		fm.target = "_blank";
		fm.action = "pur_pay_autodocu.jsp";
		fm.submit();
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
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' action='/fms2/car_pur/pur_coupon_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > <span class=style5>���������������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�Ⱓ</td>
                    <td width=40%>&nbsp;
            		    <select name='gubun2'>
                          <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>����</option>
                          <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>���</option>
                          <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>�Ⱓ </option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
        		    </td>
                    <td class=title width=10%>����</td>
                    <td width=40%>&nbsp;
            		    <input type="radio" name="gubun3" value=""  <%if(gubun3.equals(""))%>checked<%%>>
            			��ü
            		    <input type="radio" name="gubun3" value="Y" <%if(gubun3.equals("Y"))%>checked<%%>>
            			����
            		    <input type="radio" name="gubun3" value="N" <%if(gubun3.equals("N"))%>checked<%%>>
            			�̼���
						<input type="radio" name="gubun3" value="E" <%if(gubun3.equals("E"))%>checked<%%>>
            			����
						<input type="radio" name="gubun3" value="P" <%if(gubun3.equals("P"))%>checked<%%>>
            			������
						</td>		  		  
                </tr>	  
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td width=40%>&nbsp;
            		    <select name='s_kd'>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>������ </option>						
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��������� </option>
						  <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�����ȣ </option>						  						  
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>����ȣ </option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>���ʿ�����</option>
						  <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>����������</option>
						  <!--<option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>���¾�ü</option>-->
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		            </td>
                    <td class=title width=10%></td>
                    <td width=40%>&nbsp;
						<!--
            		    <input type="radio" name="gubun1" value=""  <%if(gubun1.equals(""))%>checked<%%>>
            			��ü
            		    <input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
            			����̰�
            		    <input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>
            			����ϰ�
						-->
            			</td>		  		  
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>&nbsp;
	    </td>
    </tr>
</table>
</form>
</body>
</html>