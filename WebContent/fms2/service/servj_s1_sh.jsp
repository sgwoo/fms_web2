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
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun3 	= request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	int year =AddUtil.getDate2(1);
			
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
<form name='form1' action='/fms2/service/servj_s1_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > ������� > <span class=style5>�����ü�� �ŷ���Ȳ</span></span></td>
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
                        <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>����</option>                       								
      
                      </select>
                	
                	    <select name="gubun4"  >
						<%for(int i=2011; i<=year; i++){%>
						<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>��</option>
						<%}%>
		 </select> 
		 
		  <select name="off_id"  >
					<option value="000620"  <%if(off_id.equals("000620")){%>selected<%}%>>MJ���ͽ�</option>
					<option value="009290"  <%if(off_id.equals("009290")){%>selected<%}%>> �츮�ڵ���</option>
					<option value="006858"  <%if(off_id.equals("006858")){%>selected<%}%>>����ũ��</option>
					<option value="000286"  <%if(off_id.equals("000286")){%>selected<%}%>>���ϰ�����</option>
					<option value="002105"  <%if(off_id.equals("002105")){%>selected<%}%>>�ΰ������</option>
					<option value="002734"  <%if(off_id.equals("002734")){%>selected<%}%>>����ī��ũ</option>
					<option value="007603"  <%if(off_id.equals("007603")){%>selected<%}%>>�����</option>
					<option value="001816"  <%if(off_id.equals("001816")){%>selected<%}%>> ��������</option>
					<option value="007897"  <%if(off_id.equals("007897")){%>selected<%}%>> 1�ޱ�ȣ�ڵ���</option>
					<option value="008462"  <%if(off_id.equals("008462")){%>selected<%}%>> ��������(�뱸)</option>
					<option value="008507"  <%if(off_id.equals("008507")){%>selected<%}%>> ������(����)</option>
					<option value="006490"  <%if(off_id.equals("006490")){%>selected<%}%>> ��1��(����)</option>
					<option value="010424"  <%if(off_id.equals("010424")){%>selected<%}%>> ��������</option>
					
		 </select> 
		 
		
                	</td>           
                    <td class=title width=10%>�˻�����</td>
                    <td>&nbsp;
                	  <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>���� </option>
                        <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�����</option>                 
                      </select>
                	  &nbsp;&nbsp;&nbsp;
            	    <input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
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
