<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	String white = "";
	String disabled = "";
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	if(nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){
		white = "white";
		disabled = "disabled";
	}
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
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
<body <%if(white.equals("")){%>onload="javascript:document.form1.t_wd.focus();"<%}%> leftmargin=15>
<form name='form1' action='/fms2/service/serv_c4_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > ������� > <span class=style5>�����Ȯ����Ȳ</span></span></td>
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
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>�Ⱓ</td>
                    <td>&nbsp;
        			  <select name='gubun3'>
                        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>��������</option>
                        <!--<option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>�԰�����</option>				
                        <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>�������</option>-->										
                        <option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>�������</option>
                      </select>
                	  <select name='gubun2'>
                        <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>���</option>					  
                        <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>����</option>
                        <option value='5' <%if(gubun2.equals("5")){%>selected<%}%>>����</option>
                        <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>����</option>
                        <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>�Ⱓ </option>
                      </select>
                	  <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                      ~ 
                      <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
                	</td>
                    <td class=title width=10%>�����ü</td>
                    <td width=40%>&nbsp;
					  <input type='text' name='gubun1' size='25' class='text' value='<%=gubun1%>' style='IME-MODE: active'>
					  <!--
        		      <select name='gubun1'>
        			    <%if(user_id.equals("000103")){%>
                        <option value='�ٿȹ�' <%if(gubun1.equals("�ٿȹ�")){%>selected<%}%>>�ٿȹ�</option>
        			    <%}else if(user_id.equals("000104")){%>			  
                        <option value='����ī����' <%if(gubun1.equals("����ī����")){%>selected<%}%>>����ī����</option>			  
        			    <%}else if(user_id.equals("000105")){%>			  
                        <option value='����Ųõ������' <%if(gubun1.equals("����Ųõ������")){%>selected<%}%>>����Ųõ������</option>			  
        			    <%}else{%>
        			    <option value='' >��ü</option>
                        <option value='�ٿȹ�' 		<%if(gubun1.equals("�ٿȹ�")){%>selected<%}%>			>�ٿȹ�</option>
                        <option value='����ī����' 		<%if(gubun1.equals("����ī����")){%>selected<%}%>		>����ī����</option>
                        <option value='����Ųõ������' 	<%if(gubun1.equals("����Ųõ������")){%>selected<%}%>	>����Ųõ������</option>
        			    <%}%>
                      </select>
					  -->
                	</td>
                </tr>	  
                <tr>
                    <td class=title width=10%>����з�</td>
                    <td>&nbsp;
                	    <input type="radio" name="gubun4" value=""  <%if(gubun4.equals(""))%>checked<%%>>
            			��ü
            		    <input type="radio" name="gubun4" value="1" <%if(gubun4.equals("1"))%>checked<%%>>
            			�Ϲ�����
            		    <input type="radio" name="gubun4" value="2" <%if(gubun4.equals("2"))%>checked<%%>>
            			��������+�������
            		    <input type="radio" name="gubun4" value="3" <%if(gubun4.equals("3"))%>checked<%%>>
            			�縮������
            	    </td>
                    <td class=title width=10%>������</td>
                    <td>&nbsp;
                	    <input type="radio" name="gubun5" value=""  <%if(gubun5.equals(""))%>checked<%%>>
            			��ü
            		    <input type="radio" name="gubun5" value="1" <%if(gubun5.equals("1"))%>checked<%%>>
            			����
            		    <input type="radio" name="gubun5" value="2" <%if(gubun5.equals("2"))%>checked<%%>>
            			���
            		    <input type="radio" name="gubun5" value="3" <%if(gubun5.equals("3"))%>checked<%%>>
            			ī��
            		    <input type="radio" name="gubun5" value="4" <%if(gubun5.equals("4"))%>checked<%%>>
            			��Ÿ
            	    </td>					
                </tr>				  
                <tr>
                    <td class=title width=10%>�˻�����</td>
                    <td>&nbsp;
                	  <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>���� </option>
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�����</option>
                        <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>����</option>
                        <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>������ȣ</option>						
                        <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>�����ȣ</option>			  					  					  
                        <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>���� </option>
                      </select>
                	  &nbsp;&nbsp;&nbsp;
            	    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            	    </td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;
                	  <select name='sort'>
                        <option value='1' <%if(sort.equals("1")){%>selected<%}%>>���� </option>
                        <option value='2' <%if(sort.equals("2")){%>selected<%}%>>�����</option>
                        <option value='3' <%if(sort.equals("3")){%>selected<%}%>>����</option>
                        <option value='4' <%if(sort.equals("4")){%>selected<%}%>>�����ȣ</option>			  					  					  
                        <option value='5' <%if(sort.equals("5")){%>selected<%}%>>���� </option>
                        <option value='6' <%if(sort.equals("6")){%>selected<%}%>>������� </option>
                        <option value='7' <%if(sort.equals("7")){%>selected<%}%>>�������� </option>
                      </select>
            	    </td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>