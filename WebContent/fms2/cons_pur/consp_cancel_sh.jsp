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
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
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
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<form name='form1' action='/fms2/cons_pur/consp_cancel_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > ���Ź�۰��� > <span class=style5>Ź�������Ȳ</span></span></td>
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
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>		
                    <td class=title width=10%>����</td>
                    <td width=40%>&nbsp;
                          <select name='gubun6'>
                          <option value='3' <%if(gubun6.equals("3")){%>selected<%}%>>�������</option>
                        </select>
                        &nbsp;
            		    <select name='gubun1'>
                          <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>����</option>
                          <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>����</option>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>���</option>
                          <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>�Ⱓ </option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
        		    </td>        		    
                    <td class=title width=10%>������</td>
                    <td width=40%>&nbsp;
                            <input type="radio" name="gubun3" value=""  <%if(gubun3.equals(""))%>checked<%%>>
            			��ü
            		    <input type="radio" name="gubun3" value="1" <%if(gubun3.equals("1"))%>checked<%%>>
            			�����ڵ���
            		    <input type="radio" name="gubun3" value="2" <%if(gubun3.equals("2"))%>checked<%%>>
            			����ڵ���
            		    <input type="radio" name="gubun3" value="3" <%if(gubun3.equals("3"))%>checked<%%>>
            			��Ÿ�ڵ���
            		    
        		    </td>
                </tr>
                <tr>
                    <td class=title width=10%>���繫��</td>
                    <td width=40%>&nbsp;
            		  <input type='text' name='gubun4' size='25' class='text' value='<%=gubun4%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>		
                    <td class=title width=10%>Ź������</td>
                    <td width=40%>&nbsp;
            		    <select name='gubun5'>
                          <option value='' <%if(gubun5.equals("3")){%>selected<%}%>>����</option>
                          <option value='1' <%if(gubun5.equals("4")){%>selected<%}%>>���ﺻ��</option>
                          <option value='2' <%if(gubun5.equals("1")){%>selected<%}%>>�λ�����</option>
                          <option value='3' <%if(gubun5.equals("5")){%>selected<%}%>>��������</option>
                          <option value='5' <%if(gubun5.equals("5")){%>selected<%}%>>�뱸����</option>
                          <option value='6' <%if(gubun5.equals("6")){%>selected<%}%>>��������</option>
                          <option value='4' <%if(gubun5.equals("2")){%>selected<%}%>>�� </option>
                        </select>
        		    </td>
                </tr>                
        		<tr>
                    <td class=title width=10%>�˻�����</td>
                    <td <%if(nm_db.getWorkAuthUser("�ܺ�_Ź�۾�ü",ck_acar_id)){%>colspan="3"<%}%>>&nbsp;
            		    <select name='s_kd' <%=disabled%>>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>����</option>
                          <!--<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>Ź�۾�ü </option>-->
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>�����ȣ</option>			  
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>�Ǹ�����</option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�Ƿ���</option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        		    </td>   
        		    <%if(nm_db.getWorkAuthUser("�ܺ�_Ź�۾�ü",ck_acar_id)){%>
    	        <input type='hidden' name='gubun2' value='<%=gubun2%>'> 
    	        <%}else{%>
                    <td class=title width=10%>Ź�۾�ü</td>
                    <td>&nbsp;
            		<select name='gubun2'>
                            <option value='' <%if(gubun2.equals("")){%>selected<%}%>> ��ü </option>
                            <option value='007751' <%if(gubun2.equals("007751")){%>selected<%}%>> ����Ư�� </option>                                                        
                            <option value='009026' <%if(gubun2.equals("009026")){%>selected<%}%>> �������� </option>
                            <option value='011372' <%if(gubun2.equals("011372")){%>selected<%}%>> ������� </option>
                            <option value='009771' <%if(gubun2.equals("009771")){%>selected<%}%>> ����ī�� </option>
                            <option value='010265' <%if(gubun2.equals("010265")){%>selected<%}%>> ��ȭ������ </option>
                            <option value='010266' <%if(gubun2.equals("010266")){%>selected<%}%>> ����� </option>
                            <option value='010630' <%if(gubun2.equals("010630")){%>selected<%}%>> ��������� </option>   
                        </select>
        	  </td>					
    	        <%}%>  	         		        		    			  
        		</tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
